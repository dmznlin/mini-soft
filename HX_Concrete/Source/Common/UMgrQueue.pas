{*******************************************************************************
  作者: dmzn@163.com 2012-4-11
  描述: 装车队列管理
*******************************************************************************}
unit UMgrQueue;

{$I Link.Inc}
interface

uses
  Windows, Classes, DB, SysUtils, SyncObjs, UMgrDBConn, UWaitItem, ULibFun,
  USysLoger, USysDB;

const
  cTruckMaxCalledNum = 2;
  //单车最多呼叫次数
  cCall_Prefix_1     = $1C;
  cCall_Prefix_2     = $2B;
  //呼叫协议前缀

type
  PLineItem = ^TLineItem;
  TLineItem = record
    FEnable     : Boolean;
    FLineID     : string;
    FName       : string;
    FConNo      : string;
    FConName    : string;
    FConType    : string;

    FQueueMax   : Integer;
    FIsVIP      : string;
    FIsValid    : Boolean;
    FIndex      : Integer;
  end;//装车线

  PTruckItem = ^TTruckItem;
  TTruckItem = record
    FEnable     : Boolean;
    FTruck      : string;      //车牌号
    FConNo      : string;      //物料号
    FConName    : string;      //品种名
    FLine       : string;      //装车线
    FTaskID     : string;      //任务单
    FIsVIP      : string;      //特权车

    FCallNum    : Byte;        //呼叫次数
    FCallIP     : string;
    FCallPort   : Integer;     //呼叫地址
    FAnswered   : Boolean;     //刷卡应答
  end;

  TQueueParam = record
    FLoaded     : Boolean;     //载入标记
  end;

  TTruckScanCallback = function (const nTruck: PTruckItem): Boolean;
  //车辆扫描回调函数

  TTruckQueueManager = class;
  TTruckQueueDBReader = class(TThread)
  private
    FOwner: TTruckQueueManager;
    //拥有者
    FDBConn: PDBWorker;
    //数据对象
    FWaiter: TWaitObject;
    //等待对象
    FParam: TQueueParam;
    //队列参数
    FTruckPool: array of TTruckItem;
    //车辆缓存
  protected
    procedure Execute; override;
    //执行线程
    procedure ExecuteSQL(const nList: TStrings);
    //执行SQL语句
    procedure LoadQueueParam;
    //载入排队参数
    procedure LoadLines;
    procedure LoadTrucks;
    //载入车辆
    function GetLine(const nLineID: string): Integer;
    function TruckInPool(const nTruck: string): Integer;
    function TruckInList(const nTruck: string): Integer;
    //检索车辆
    procedure InvalidTruckOutofQueue;
    procedure MakeTruckIn(var nStart: Integer; const nFilter: TTruckScanCallback);
    //扫描队列
  public
    constructor Create(AOwner: TTruckQueueManager);
    destructor Destroy; override;
    //创建释放
    procedure Wakup;
    procedure StopMe;
    //启停线程
  end;

  TTruckQueueManager = class(TObject)
  private
    FDBName: string;
    //数据标识
    FLines: TList;
    FTrucks: TList;
    //车辆列表
    FLineLoaded: Boolean;
    //是否已载入
    FQueueChanged: Int64;
    //队列变动
    FSyncLock: TCriticalSection;
    //同步锁
    FDBReader: TTruckQueueDBReader;
    //数据读写
  protected
    procedure FreeTruck(nItem: PTruckItem; nIdx: Integer = -1);
    procedure ClearTrucks(const nFree: Boolean);
    procedure FreeLine(nItem: PLineItem; nIdx: Integer = -1);
    procedure ClearLines(const nFree: Boolean);
    //释放资源
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放
    procedure StartQueue(const nDB: string);
    procedure StopQueue;
    //启停队列
    function TruckInQueue(const nTruck: string; const nLocked: Boolean): Integer;
    //车辆检索
    function GetVoiceTruck(const nSeparator: string;
     const nLocked: Boolean): string;
    //语音车辆
    procedure RefreshTrucks(const nLoadLine: Boolean);
    //刷新队列
    property Lines: TList read FLines;
    property Trucks: TList read FTrucks;
    property QueueChanged: Int64 read FQueueChanged;
    property SyncLock: TCriticalSection read FSyncLock;
    //属性相关
  end;

var
  gTruckQueueManager: TTruckQueueManager = nil;
  //全局使用

implementation

//Desc: 记录日志
procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TTruckQueueManager, '装车队列调度', nEvent);
end;

constructor TTruckQueueManager.Create;
begin
  FDBReader := nil;
  FLineLoaded := False;
  FQueueChanged := GetTickCount;

  FLines := TList.Create;
  FTrucks := TList.Create;
  FSyncLock := TCriticalSection.Create;
end;

destructor TTruckQueueManager.Destroy;
begin
  StopQueue;
  ClearLines(True);
  ClearTrucks(True);

  FSyncLock.Free;
  inherited;
end;

//Desc: 释放车辆
procedure TTruckQueueManager.FreeTruck(nItem: PTruckItem; nIdx: Integer);
begin
  if (nIdx < 0) and Assigned(nItem) then
    nIdx := FTrucks.IndexOf(nItem);
  if nIdx < 0 then Exit;

  if (not Assigned(nItem)) and (nIdx > -1) then
    nItem := FTrucks[nIdx];
  if not Assigned(nItem) then Exit;

  Dispose(nItem);
  FTrucks.Delete(nIdx);
end;

procedure TTruckQueueManager.ClearTrucks(const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx:=FTrucks.Count - 1 downto 0 do
    FreeTruck(nil, nIdx);
  if nFree then FreeAndNil(FTrucks);
end;

//Desc: 释放装车线
procedure TTruckQueueManager.FreeLine(nItem: PLineItem; nIdx: Integer);
begin
  if (nIdx < 0) and Assigned(nItem) then
    nIdx := FLines.IndexOf(nItem);
  if nIdx < 0 then Exit;

  if (not Assigned(nItem)) and (nIdx > -1) then
    nItem := FLines[nIdx];
  if not Assigned(nItem) then Exit;

  Dispose(nItem);
  FLines.Delete(nIdx);
end;

procedure TTruckQueueManager.ClearLines(const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx:=FLines.Count - 1 downto 0 do
    FreeLine(nil, nIdx);
  if nFree then FreeAndNil(FLines);
end;

procedure TTruckQueueManager.StartQueue(const nDB: string);
begin
  FDBName := nDB;
  if not Assigned(FDBReader) then
    FDBReader := TTruckQueueDBReader.Create(Self);
  FDBReader.Wakup;
end;

procedure TTruckQueueManager.StopQueue;
begin
  if Assigned(FDBReader) then
  try
    FSyncLock.Enter;
    FDBReader.StopMe;
  finally
    FSyncLock.Leave;
  end;

  FDBReader := nil;
end;

//Date: 2013-07-08
//Parm: 车牌号;是否锁定
//Desc: 检索nTruck在队列中的位置索引
function TTruckQueueManager.TruckInQueue(const nTruck: string;
  const nLocked: Boolean): Integer;
var nIdx: Integer;
begin
  if nLocked then SyncLock.Enter;
  try
    Result := -1;

    for nIdx:=FTrucks.Count - 1 downto 0 do
    if CompareText(nTruck, PTruckItem(FTrucks[nIdx]).FTruck) = 0 then
    begin
      Result := nIdx;
      Break;
    end;
  finally
    if nLocked then SyncLock.Leave;
  end;
end;

//Date: 2012-8-24
//Parm: 分隔符;是否锁定
//Desc: 获取语音播发的车辆列表
function TTruckQueueManager.GetVoiceTruck(const nSeparator: string;
  const nLocked: Boolean): string;
var i,nIdx: Integer;
    nTruck: PTruckItem;
begin
  if nLocked then SyncLock.Enter;
  try
    Result := '';

    i := Length(Result);
    if i > 0 then
    begin
      nIdx := Length(nSeparator);
      Result := Copy(Result, 1, i - nIdx);
    end;
  finally
    if nLocked then SyncLock.Leave;
  end;
end;

procedure TTruckQueueManager.RefreshTrucks(const nLoadLine: Boolean);
begin
  if Assigned(FDBReader) then
  begin
    if nLoadLine then
      FLineLoaded := False;
    FDBReader.Wakup;
  end;
end;

//------------------------------------------------------------------------------
constructor TTruckQueueDBReader.Create(AOwner: TTruckQueueManager);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FOwner := AOwner;
  with FParam do
  begin
    FLoaded := False;
  end;

  FWaiter := TWaitObject.Create;
  FWaiter.Interval := 20 * 1000;
end;

destructor TTruckQueueDBReader.Destroy;
begin
  FWaiter.Free;
  inherited;
end;

procedure TTruckQueueDBReader.Wakup;
begin
  FWaiter.Wakeup;
end;

procedure TTruckQueueDBReader.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure TTruckQueueDBReader.Execute;
var nErr: Integer;
begin
  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Exit;

    FDBConn := gDBConnManager.GetConnection(FOwner.FDBName, nErr);
    try
      if not Assigned(FDBConn) then
      begin
        WriteLog('DB connection is null.');
        Continue;
      end;

      if not FDBConn.FConn.Connected then
      begin
        FDBConn.FConn.Connected := True;
        //conn db
      end;

      FOwner.FSyncLock.Enter;
      try
        LoadQueueParam;
        LoadLines;
        LoadTrucks;
      finally
        FOwner.FSyncLock.Leave;
      end;
    finally
      gDBConnManager.ReleaseConnection(FOwner.FDBName, FDBConn);
    end;
  except
    on E: Exception do
    begin
      WriteLog(E.Message);
    end;
  end;
end;

//Desc: 执行SQL语句
procedure TTruckQueueDBReader.ExecuteSQL(const nList: TStrings);
var nIdx: Integer;
begin
  for nIdx:=nList.Count - 1 downto 0 do
  begin
    gDBConnManager.WorkerExec(FDBConn, nList[nIdx]);
    nList.Delete(nIdx);
  end;
end;

//Desc: 载入排队参数
procedure TTruckQueueDBReader.LoadQueueParam;
var nStr: string;
begin
  Exit;
  if FParam.FLoaded then Exit;

  nStr := 'Select D_Value,D_Memo From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    FParam.FLoaded := True;
    First;

    while not Eof do
    begin
      Next;
    end;
  end;
end;

//Date: 2012-4-15
//Parm: 装车线标识
//Desc: 检索标识为nLineID的装车线
function TTruckQueueDBReader.GetLine(const nLineID: string): Integer;
var nIdx: Integer;
begin
  Result := -1;

  for nIdx:=FOwner.FLines.Count - 1 downto 0 do
  if CompareText(nLineID, PLineItem(FOwner.FLines[nIdx]).FLineID) = 0 then
  begin
    Result := nIdx;
    Break;
  end;
end;

//Desc: 载入装车线列表
procedure TTruckQueueDBReader.LoadLines;
var nStr: string;
    nLine: PLineItem;
    i,nIdx,nInt: Integer;
begin
  if FOwner.FLineLoaded then Exit;
  nStr := 'Select * From %s Order By Z_Index ASC';
  nStr := Format(nStr, [sTable_ZCLines]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr),FOwner do
  begin
    FLineLoaded := True;
    if RecordCount < 1 then Exit;

    for nIdx:=FLines.Count - 1 downto 0 do
      PLineItem(FLines[nIdx]).FEnable := False;
    //xxxxx

    First;
    while not Eof do
    begin
      nStr := FieldByName('Z_ID').AsString;
      nIdx := GetLine(nStr);

      if nIdx < 0 then
      begin
        New(nLine);
        FLines.Add(nLine);
      end else nLine := FLines[nIdx];

      with nLine^ do
      begin
        FEnable     := True;
        FLineID     := FieldByName('Z_ID').AsString;
        FName       := FieldByName('Z_Name').AsString;

        FConNo      := FieldByName('Z_ConNo').AsString;
        FConName    := FieldByName('Z_ConName').AsString;
        FConType    := FieldByName('Z_ConType').AsString;

        FQueueMax   := FieldByName('Z_QueueMax').AsInteger;
        FIsVIP      := FieldByName('Z_VIPLine').AsString;
        FIsValid    := FieldByName('Z_Valid').AsString <> sFlag_No;
        FIndex      := FieldByName('Z_Index').AsInteger;
      end;

      Next;
    end;

    for nIdx:=FLines.Count - 1 downto 0 do
    begin
      if not PLineItem(FLines[nIdx]).FEnable then
        FreeLine(nil, nIdx);
      //xxxxx
    end;

    for nIdx:=0 to FLines.Count - 1 do
    begin
      nLine := FLines[nIdx];
      nInt := -1;

      for i:=nIdx+1 to FLines.Count - 1 do
      if PLineItem(FLines[i]).FIndex < nLine.FIndex then
      begin
        nInt := i;
        nLine := FLines[i];
        //find the mininum
      end;

      if nInt > -1 then
      begin
        FLines[nInt] := FLines[nIdx];
        FLines[nIdx] := nLine;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2013-07-07
//Parm: 车牌号
//Desc: 检索nTruck在FTruckPool中的位置
function TTruckQueueDBReader.TruckInPool(const nTruck: string): Integer;
var nIdx: Integer;
begin
  Result := - 1;
  
  for nIdx:=Low(FTruckPool) to High(FTruckPool) do
  if CompareText(nTruck, FTruckPool[nIdx].FTruck) = 0 then
  begin
    Result := nIdx;
    Break;
  end;
end;

//Date: 2013-07-07
//Parm: 车牌号
//Desc: 检索nTruck在FTrucks中的位置
function TTruckQueueDBReader.TruckInList(const nTruck: string): Integer;
var nIdx: Integer;
begin
  Result := - 1;

  for nIdx:=FOwner.FTrucks.Count - 1 downto 0 do
  if CompareText(nTruck, PTruckItem(FOwner.FTrucks[nIdx]).FTruck) = 0 then
  begin
    Result := nIdx;
    Break;
  end;    
end;

//Date: 2012-4-15
//Desc: 将无效车辆(已出厂,进厂超时)移出队列
procedure TTruckQueueDBReader.InvalidTruckOutofQueue;
var nIdx: Integer;
    nTruck: PTruckItem;
begin
  for nIdx:=FOwner.FTrucks.Count - 1 downto 0 do
  begin
    nTruck := FOwner.FTrucks[nIdx];
    if TruckInPool(nTruck.FTruck) >= 0 then Continue;

    {$IFDEF DEBUG}
    WriteLog(Format('车辆[ %s ]无效出队.', [nTruck.FTruck]));
    {$ENDIF}

    FOwner.FreeTruck(nTruck, nIdx);
    FOwner.FQueueChanged := GetTickCount;
  end;
end;

//Date: 2013-07-07
//Parm: 扫描FTrucks起始索引;过滤器
//Desc: 将FTruckPool符合nFilter的车辆添加到nStart开始的列表中
procedure TTruckQueueDBReader.MakeTruckIn(var nStart: Integer;
  const nFilter: TTruckScanCallback);
var nIdx,nPos: Integer;
    nTruck: PTruckItem;
begin
  with FOwner do
  begin
    for nIdx:=Low(FTruckPool) to High(FTruckPool) do
    begin
      if not nFilter(@FTruckPool[nIdx]) then Continue;
      //不符合筛选条件

      nPos := TruckInList(FTruckPool[nIdx].FTruck);
      if nPos = nStart then
      begin
        Inc(nStart);
        Continue;
      end;
      //车辆在正确位置,不予处理

      FQueueChanged := GetTickCount;
      //更新队列变动标记

      if nPos < 0 then
      begin
        New(nTruck);
        FTrucks.Insert(nStart, nTruck);

        nTruck^ := FTruckPool[nIdx];
        Inc(nStart);
      end else //不在队列则添加
      begin
        nTruck := FTrucks[nStart];
        FTrucks[nIdx] := FTrucks[nPos];

        FTrucks[nPos] := nTruck;
        Inc(nStart);
      end;     //已在队列则交换
    end;
  end;
end;

//Desc: 装车线为空回调
function Filter_LineIsNull(const nTruck: PTruckItem): Boolean;
begin
  Result := nTruck.FLine = '';
end;

//Desc: 装车线不为空回调
function Filter_LineIsNotNull(const nTruck: PTruckItem): Boolean;
begin
  Result := nTruck.FLine <> '';
end;

//Desc: Desc: 载入装车队列
procedure TTruckQueueDBReader.LoadTrucks;
var nStr: string;
    i,j,nIdx,nPos: Integer;
    nTruck,nTmp: PTruckItem;
begin
  nStr := 'Select zt.* From %s zt ' +
          ' Left Join %s tl on tl.T_ID=zt.T_TruckLog ' +
          'Where IsNull(T_Valid,''%s'')<>''%s'' ' +
          'Order By T_InTime ASC';
  nStr := Format(nStr, [sTable_ZCTrucks, sTable_TruckLog, sFlag_Yes, sFlag_No]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    SetLength(FTruckPool, RecordCount);
    nIdx := 0;
    First;

    while not Eof do
    begin
      with FTruckPool[nIdx] do
      begin
        FEnable     := True;
        FTruck      := FieldByName('T_Truck').AsString;
        FConNo      := FieldByName('T_ConNo').AsString;
        FConName    := FieldByName('T_ConName').AsString;

        FLine       := FieldByName('T_Line').AsString;
        FTaskID     := FieldByName('T_TaskID').AsString;
        FIsVIP      := FieldByName('T_VIP').AsString;

        FCallNum    := 0;
        FCallIP     := '';
        FCallPort   := 0;
        FAnswered   := False;
      end;
      
      Inc(nIdx);
      Next;
    end;
  end else SetLength(FTruckPool, 0);
  //可进厂和已在队列车辆缓冲池

  InvalidTruckOutofQueue;
  //无效车辆出队

  nIdx := 0;
  MakeTruckIn(nIdx, @Filter_LineIsNotNull);
  //装车线不为空优先

  MakeTruckIn(nIdx, @Filter_LineIsNull);
  //正常车辆进队
end;

initialization
  gTruckQueueManager := TTruckQueueManager.Create
finalization
  FreeAndNil(gTruckQueueManager);
end.
