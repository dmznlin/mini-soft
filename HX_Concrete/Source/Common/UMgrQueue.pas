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
    FTrucks     : TList;
  end;//装车线

  PTruckItem = ^TTruckItem;
  TTruckItem = record
    FEnable     : Boolean;
    FTruck      : string;      //车牌号
    FConNo      : string;      //物料号
    FConName    : string;      //品种名
    FLine       : string;      //装车线
    FTaskID     : string;      //任务单
    
    FInTime     : Int64;       //进队时间
    FInFact     : Boolean;     //是否进厂
    FInLade     : Boolean;     //是否提货
    FIsVIP      : string;      //特权车
    FIndex      : Integer;     //队列索引
  end;

  TQueueParam = record
    FLoaded     : Boolean;     //载入标记
  end;

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
    FTruckChanged: Boolean;
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
    //载入装车线
    procedure LoadTrucks;
    //载入车辆
    procedure InvalidTruckOutofQueue;
    //队列处理
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
    //装车线
    FLineLoaded: Boolean;
    //是否已载入
    FLineChanged: Int64;
    //队列变动
    FSyncLock: TCriticalSection;
    //同步锁
    FDBReader: TTruckQueueDBReader;
    //数据读写
  protected
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
    function GetVoiceTruck(const nSeparator: string;
     const nLocked: Boolean): string;
    //语音车辆
    procedure RefreshTrucks(const nLoadLine: Boolean);
    //刷新队列
    function GetLine(const nLineID: string): Integer;
    //装车线
    function TruckInQueue(const nTruck: string): Integer;
    function TruckInLine(const nTruck: string; const nList: TList): Integer;
    //车辆检索
    property Lines: TList read FLines;
    property LineChanged: Int64 read FLineChanged;
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
  FLineChanged := GetTickCount;

  FLines := TList.Create;
  FSyncLock := TCriticalSection.Create;
end;

destructor TTruckQueueManager.Destroy;
begin
  StopQueue;
  ClearLines(True);

  FSyncLock.Free;
  inherited;
end;

//Desc: 释放装车线
procedure TTruckQueueManager.FreeLine(nItem: PLineItem; nIdx: Integer);
var i: Integer;
begin
  if Assigned(nItem) then
    nIdx := FLines.IndexOf(nItem);
  if nIdx < 0 then Exit;

  if (not Assigned(nItem)) and (nIdx > -1) then
    nItem := FLines[nIdx];
  if not Assigned(nItem) then Exit;

  for i:=nItem.FTrucks.Count - 1 downto 0 do
  begin
    Dispose(PTruckItem(nItem.FTrucks[i]));
    nItem.FTrucks.Delete(i);
  end;

  nItem.FTrucks.Free;
  Dispose(PLineItem(nItem));
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

//Date: 2012-8-24
//Parm: 分隔符;是否锁定
//Desc: 获取语音播发的车辆列表
function TTruckQueueManager.GetVoiceTruck(const nSeparator: string;
  const nLocked: Boolean): string;
var i,nIdx: Integer;
    nLine: PLineItem;
    nTruck: PTruckItem;
begin
  if nLocked then SyncLock.Enter;
  try
    Result := '';

    for nIdx:=0 to Lines.Count - 1 do
    begin
      nLine := Lines[nIdx];
      for i:=0 to nLine.FTrucks.Count - 1 do
      begin
        nTruck := nLine.FTrucks[i];
        Result := Result + nTruck.FTruck + nSeparator;
        //xxxxx
      end;
    end;

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

//Date: 2012-4-15
//Parm: 装车线表示
//Desc: 检索标识为nLineID的装车线(需加锁调用)
function TTruckQueueManager.GetLine(const nLineID: string): Integer;
var nIdx: Integer;
begin
  Result := -1;
              
  for nIdx:=FLines.Count - 1 downto 0 do
  if CompareText(nLineID, PLineItem(FLines[nIdx]).FLineID) = 0 then
  begin
    Result := nIdx;
    Break;
  end;
end;

//Date: 2012-4-14
//Parm: 车牌号;列表
//Desc: 判定nTruck是否在nList单道队列中(需加锁调用)
function TTruckQueueManager.TruckInLine(const nTruck: string;
  const nList: TList): Integer;
var nIdx: Integer;
begin
  Result := -1;

  for nIdx:=nList.Count - 1 downto 0 do
  if CompareText(nTruck, PTruckItem(nList[nIdx]).FTruck) = 0 then
  begin
    Result := nIdx;
    Break;
  end;
end;

//Date: 2012-4-14
//Parm: 车牌号
//Desc: 判断nTruck是否在队列中(需加锁调用)
function TTruckQueueManager.TruckInQueue(const nTruck: string): Integer;
var nIdx: Integer;
begin
  Result := -1;

  for nIdx:=FLines.Count - 1 downto 0 do
  if TruckInLine(nTruck, PLineItem(FLines[nIdx]).FTrucks) > -1 then
  begin
    Result := nIdx;
    Break;
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

        FTruckChanged := False;
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

    FLineChanged := GetTickCount;
    First;

    while not Eof do
    begin
      nStr := FieldByName('Z_ID').AsString;
      nIdx := GetLine(nStr);

      if nIdx < 0 then
      begin
        New(nLine);
        FLines.Add(nLine);
        nLine.FTrucks := TList.Create;
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
//Desc: Desc: 载入装车队列
procedure TTruckQueueDBReader.LoadTrucks;
var nStr: string;
    i,nIdx: Integer;
begin
  nStr := 'Select * From %s Where IsNull(T_Valid,''%s'')<>''%s'' $Ext ' +
          'Order By T_Index ASC,T_InFact ASC,T_InTime ASC';
  nStr := Format(nStr, [sTable_ZCTrucks, sFlag_Yes, sFlag_No]);

  {++++++++++++++++++++++++++++++ 注意 +++++++++++++++++++++++++
   1.厂外模式时,进厂时间(T_InFact)为空,车辆以开单时间(T_InTime)为准.
   2.厂内模式时,车辆已进厂时间为准.
   3.排序条件上, T_InFact和T_InTime不能调换顺序.
  -------------------------------------------------------------}

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

        FInFact     := FieldByName('T_InFact').AsString <> '';
        FInLade     := FieldByName('T_InLade').AsString <> '';

        FIndex      := FieldByName('T_Index').AsInteger;
        if FIndex < 1 then FIndex := MaxInt;
      end;
      
      Inc(nIdx);
      Next;
    end;
  end else SetLength(FTruckPool, 0);
  //可进厂和已在队列车辆缓冲池

  InvalidTruckOutofQueue;
  //将无效车辆移出队列

  if Length(FTruckPool) < 1 then Exit;
  //无新车辆处理

  //--------------------------------------------------------------------------
  for nIdx:=0 to FOwner.FLines.Count - 1 do
  with PLineItem(FOwner.Lines[nIdx])^,FOwner do
  begin
    for i:=Low(FTruckPool) to High(FTruckPool) do
    if FTruckPool[i].FEnable then
    begin
      if FTruckPool[i].FLine <> FLineID then Continue;
      if TruckInLine(FTruckPool[i].FTruck, FTrucks) >= 0 then Continue;

      //MakePoolTruckIn(i, FOwner.Lines[nIdx]);
      //本队列车辆优先,全部进队
    end;

  end;
end;

//Date: 2012-4-15
//Desc: 将无效车辆(已出厂,进厂超时)移出队列
procedure TTruckQueueDBReader.InvalidTruckOutofQueue;
var nStr: string;
    i,j,nIdx: Integer;
    nLine: PLineItem;
    nTruck: PTruckItem;
begin
  with FOwner do
  begin
    for nIdx:=FLines.Count - 1 downto 0 do
     with PLineItem(FLines[nIdx])^ do
      for i:=FTrucks.Count - 1 downto 0 do
       PTruckItem(FTrucks[i]).FEnable := False;
    //xxxxx
  end;

  for nIdx:=FOwner.FLines.Count - 1 downto 0 do
  begin

  end;

  for nIdx:=FOwner.FLines.Count - 1 downto 0 do
  begin
    nLine := FOwner.FLines[nIdx];
    for i:=nLine.FTrucks.Count - 1 downto 0 do
    begin
      nTruck := nLine.FTrucks[i];
      if nTruck.FEnable then Continue;

      {$IFDEF DEBUG}
      WriteLog(Format('车辆[ %s ]无效出队.', [nTruck.FTruck]));
      {$ENDIF}
      
      Dispose(nTruck);
      nLine.FTrucks.Delete(i);

      FTruckChanged := True;
      FOwner.FLineChanged := GetTickCount;
    end;
  end;
  //清理无效车辆
end;

initialization
  gTruckQueueManager := TTruckQueueManager.Create
finalization
  FreeAndNil(gTruckQueueManager);
end.
