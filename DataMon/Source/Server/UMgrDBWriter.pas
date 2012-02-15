{*******************************************************************************
  作者: dmzn@163.com 2011-5-29
  描述: 数据库写入对象
*******************************************************************************}
unit UMgrDBWriter;

interface

uses
  Windows, Classes, ComCtrls, SysUtils, SyncObjs, ADODB, DB, UWaitItem,
  UMgrMCGS;

const
  cData_BufSize = 100;             //数据缓存
  cItem_BufSize = 10;              //命中缓存

type
  TWriterItemStatus = (isNone, isActive, isNoAction);
  //状态:未知,活动,不活动

  PWriterItem = ^TWriterItem;
  TWriterItem = record
    FCH,FDH: string;               //场号,栋号
    FSerial: Word;                 //栋号顺序
    FStatus: TWriterItemStatus;    //状态

    FTable: string;                //表名称
    FStart,FEnd: TDateTime;        //周期
    FLastUpdate: TDateTime;        //上次更新

    FItemIndex: Integer;           //待写数据位置
    FItemCount: Integer;           //有效数据个数
    FItemData: array[0..cData_BufSize-1] of TMCGSParamItem; //数据
  end;

  TDBWriteManager = class;
  TDBWriterThread = class(TThread)
  private
    FOwner: TDBWriteManager;
    //拥有者
    FWaiter: TWaitObject;
    //等待对象
    FBuffer: TStrings;
    //数据对象
  protected
    procedure DoWeekCheck;
    procedure Execute; override;
    //线程体
  public
    constructor Create(AOwner: TDBWriteManager);
    destructor Destroy; override;
    //创建释放
    procedure Wakeup;
    //唤醒线程
    procedure Stop;
    //停止线程
  end;

  TDBWriteManager = class(TObject)
  private
    FSQLLock: TCriticalSection;
    FSyncLock: TCriticalSection;
    //同步锁
    FItems: array of TWriterItem;
    //有效对象
    FItemIdx: Integer;
    FItemBuf: array[0..cItem_BufSize-1] of Integer;
    //命中缓存
    FDBConn: TADOConnection;
    //数据连接
    FSQLCmd: TADOQuery;
    FSQLQuery: TADOQuery;
    //数据对象
    FWeekInterval: Cardinal;
    //周期间隔
    FWriter: TDBWriterThread;
    //写线程
  protected
    function ExecuteSQL(const nSQL: string): Integer;
    function QuerySQL(const nSQL: string): TDataSet;
    //数据库操作
    function NewDMTable(const nCH, nDH: string; const nIdx: Integer): string;
    //新建数据表
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放
    function StartWriter(const nConnStr: string): Boolean;
    procedure StopWriter;
    //启动停止
    procedure WriteItems(const nItems: TMCGSParamItems; const nLen: Integer);
    //写入对象
    procedure LoadItems(const nLv: TListView);
    //显示列表
    property WeekInterval: Cardinal read FWeekInterval write FWeekInterval;
    //属性相关
  end;

var
  gDBWriteManager: TDBWriteManager = nil;
  //全局使用

implementation

uses
  ULibFun, UDataModule, USysConst;

resourcestring
  sSQLInsert = 'Insert Into $TB(Farm_ID,Cage_ID,Cage_Idx,Get_Time,' +
               'w1,w2,w3,w4,s1,s2,s3,s4,fj1,fj2,fj3,fj4,fj5,fjo,fjc,' +
               'tfjb,tfbj,rs1,rs2,rs3,rs4,rld,rlh,llt,llk,rll,slt,' +
               'slk,sww,cold,hot,weight,mw,aq,fy1,fy2,slkd,slb,ccl,' +
               'ccr) Values (''$CH'',''$DH'',$Idx,GetDate(),' +
               '$w1,$w2,$w3,$w4,$s1,$s2,$s3,$s4,$fj1,$fj2,$fj3,$fj4,$fj5,$fjo,$fjc,' +
               '$tfjb,$tfbj,$rs1,$rs2,$rs3,$rs4,$rld,$rlh,$llt,$llk,$rll,$slt,' +
               '$$slk,$sww,$cold,$hot,$weight,$mw,$aq,$fy1,$fy2,$slkd,$slb,$ccl,' +
               '$ccr)';
  //插入语句

//------------------------------------------------------------------------------
constructor TDBWriteManager.Create;
begin
  FWeekInterval := 2;
  FSQLLock := TCriticalSection.Create;
  FSyncLock := TCriticalSection.Create;

  FDBConn := TADOConnection.Create(nil);
  FDBConn.LoginPrompt := False;
  
  FSQLCmd := TADOQuery.Create(nil);
  FSQLCmd.Connection := FDBConn;
  FSQLQuery := TADOQuery.Create(nil);
  FSQLQuery.Connection := FDBConn;
end;

destructor TDBWriteManager.Destroy;
begin
  StopWriter;
  FSQLCmd.Free;
  FSQLQuery.Free;

  FDBConn.Free;
  FSQLLock.Free;
  FSyncLock.Free;
  inherited;
end;

//Desc: 开启
function TDBWriteManager.StartWriter(const nConnStr: string): Boolean;
begin
  try
    FDBConn.Close;
    FDBConn.ConnectionString := nConnStr;
    FDBConn.Open;
    //连接数据库

    FItemIdx := 0;
    FillChar(FItemBuf, SizeOf(FItemBuf), -1);
    //初始化命中缓冲

    SetLength(FItems, 0);
    //初始化待写入项

    FWriter := TDBWriterThread.Create(Self);
    Result := True;
  except
    Result := False; Exit;
  end;
end;

//Desc: 关闭
procedure TDBWriteManager.StopWriter;
begin
  if Assigned(FWriter) then
  begin
    FWriter.Stop;
    FWriter := nil;
  end;
  FDBConn.Close;
end;

//Desc: 执行
function TDBWriteManager.ExecuteSQL(const nSQL: string): Integer;
begin
  FSQLLock.Enter;
  try
    try
      FSQLCmd.Close;
      FSQLCmd.SQL.Text := nSQL;
      Result := FSQLCmd.ExecSQL;
    except
      on E:Exception do
      begin
        Result := -1;
        ShowSyncLog(E.Message);
      end;
    end;
  finally
    FSQLLock.Leave;
  end;
end;

//Desc: 查询
function TDBWriteManager.QuerySQL(const nSQL: string): TDataSet;
begin
  with FSQLQuery do
  begin
    Close;
    SQL.Text := nSQL;
    Open;
  end;

  Result := FSQLQuery;
end;

//Desc: 添加
procedure TDBWriteManager.WriteItems(const nItems: TMCGSParamItems;
  const nLen: Integer);
var i,j,nIdx: Integer;
begin
  FSyncLock.Enter;
  try
    for i:=0 to nLen - 1 do
    begin
      nIdx := -1;

      for j:=0 to cItem_BufSize - 1 do
      begin
        if FItemBuf[j] < 0 then Continue;

        with FItems[FItemBuf[j]] do
        if (FCH = nItems[i].FCH) and (FDH = nItems[i].FDH) then
        begin
          nIdx := FItemBuf[j]; Break;
        end;
      end;
      //尝试在缓冲中命中

      if nIdx < 0 then
      begin
        for j:=Low(FItems) to High(FItems) do
         with FItems[j] do
          if (FCH = nItems[i].FCH) and (FDH = nItems[i].FDH) then
          begin
            nIdx := j;
            FItemBuf[FItemIdx] := j;
            Inc(FItemIdx);
            
            if FItemIdx >= cItem_BufSize then
              FItemIdx := 0;
            Break;
          end;
      end;
      //在对象列表中命中

      if nIdx < 0 then
      begin
        nIdx := Length(FItems);
        SetLength(FItems, nIdx + 1);

        with FItems[nIdx] do
        begin
          FCH := nItems[i].FCH;
          FDH := nItems[i].FDH;
          FSerial := nItems[i].FSerial;
          FStatus := isActive;

          FTable := NewDMTable(FCH, FDH, FSerial);
          FStart := Now;
          FEnd := Now;
          FLastUpdate := Now;

          FItemData[0] := nItems[i];
          FItemIndex := 1;
          FItemCount := 1;          
        end;

        FItemBuf[FItemIdx] := nIdx;
        Inc(FItemIdx);
            
        if FItemIdx >= cItem_BufSize then
          FItemIdx := 0;
        //更新命中缓冲
      end else

      with FItems[nIdx] do
      begin
        FItemData[FItemIndex] := nItems[i]; 
        Inc(FItemIndex);
        Inc(FItemCount);

        if FItemIndex >= cData_BufSize then
          FItemIndex := 0;
        //start from begin

        if FItemCount > cData_BufSize then
          FItemCount := cData_BufSize;
        //xxxxx
      end;
    end;

    FWriter.Wakeup;
  finally
    FSyncLock.Leave;
  end;
end;

//Desc: 新建数据表
function TDBWriteManager.NewDMTable(const nCH, nDH: string;
  const nIdx: Integer): string;
var nStr: string;
begin
  try
    nStr := 'Select Table_Name From %s Where Farm_ID=''%s'' And Cage_ID=''%s''';
    nStr := Format(nStr, ['Cage_Table', nCH, nDH]);

    with QuerySQL(nStr) do
    if RecordCount > 0 then
    begin
      Result := Fields[0].AsString; Exit;
    end;

    FDBConn.BeginTrans;
    Result := DateTime2Str(Now);
    System.Delete(Result, 1, 2);

    Result := StringReplace(Result, ' ', '', [rfReplaceAll]);
    Result := StringReplace(Result, '-', '', [rfReplaceAll]);
    Result := 't' + StringReplace(Result, ':', '', [rfReplaceAll]);
    //new table name
      
    nStr := 'Insert Into $TB(Farm_ID,Cage_ID,Cage_Idx,Table_Name,Create_Time) ' +
            'Values(''$CH'', ''$DH'', $Idx, ''$TN'', GetDate())';
    //xxxx
      
    nStr := MacroValue(nStr, [MI('$TB', 'Cage_Table'), MI('$CH', nCH),
            MI('$DH', nDH), MI('$Idx', IntToStr(nIdx)), MI('$TN', Result)]);
    ExecuteSQL(nStr);

    nStr := 'Create Table $TB(R_ID Integer IDENTITY (1,1) PRIMARY KEY,' +
      'Farm_ID varChar(32), Cage_ID varChar(32),' +
      'Cage_Idx Integer Default -1, Get_Time DateTime,'+
      'w1 Decimal(15, 5), w2 Decimal(15, 5), w3 Decimal(15, 5), w4 Decimal(15, 5),'+
      's1 Decimal(15, 5), s2 Decimal(15, 5), s3 Decimal(15, 5), s4 Decimal(15, 5),'+
      //4-s4
      'fj1 Decimal(15, 5), fj2 Decimal(15, 5), fj3 Decimal(15, 5), fj4 Decimal(15, 5), fj5 Decimal(15, 5),'+
      'fjo Decimal(15, 5), fjc Decimal(15, 5), tfjb Decimal(15, 5), tfbj Decimal(15, 5), '+
      'rs1 Decimal(15, 5), rs2 Decimal(15, 5), rs3 Decimal(15, 5), rs4 Decimal(15, 5), '+
      //13-rs4
      'rld Decimal(15, 5), rlh Decimal(15, 5), llt Decimal(15, 5), llk Decimal(15, 5),'+
      'rll Decimal(15, 5), slt Decimal(15, 5), slk Decimal(15, 5), sww Decimal(15, 5),'+
      'cold Decimal(15, 5), hot Decimal(15, 5), '+
      //10-hot
      'weight Decimal(15, 5), mw Decimal(15, 5), aq Decimal(15, 5),'+
      'fy1 Decimal(15, 5), fy2 Decimal(15, 5), slkd Decimal(15, 5), slb Decimal(15, 5),'+
      'ccl Decimal(15, 5), ccr Decimal(15, 5))';
      //9-ccr
    //xxxxx

    nStr := MacroValue(nStr, [MI('$TB', Result)]);
    ExecuteSQL(nStr);

    FDBConn.CommitTrans;
    Sleep(1000);
    //table name is time
  except
    Result := '';
    if FDBConn.InTransaction then
      FDBConn.RollbackTrans;
    //xxxxx
  end;
end;

//Desc: 显示对象到nLv中
procedure TDBWriteManager.LoadItems(const nLv: TListView);
var nIdx: Integer;
begin
  FSyncLock.Enter;
  try
    nLv.Items.BeginUpdate;
    nLv.Items.Clear;

    for nIdx:=Low(FItems) to High(FItems) do
    with FItems[nIdx],nLv.Items.Add do
    begin
      Caption := FDH;
      SubItems.Add(FCH);
      SubItems.Add(IntToStr(FSerial));
      SubItems.Add(DateTime2Str(FLastUpdate));

      if FStatus = isActive then
           ImageIndex := 1
      else ImageIndex := 0;
    end;
  finally
    nLv.Items.EndUpdate;
    FSyncLock.Leave;
  end;
end;

//------------------------------------------------------------------------------
constructor TDBWriterThread.Create(AOwner: TDBWriteManager);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FOwner := AOwner;
  FBuffer := TStringList.Create;

  FWaiter := TWaitObject.Create;
  FWaiter.Interval := 10 * 1000;
end;

destructor TDBWriterThread.Destroy;
begin
  FWaiter.Free;
  FBuffer.Free;
  inherited;
end;

procedure TDBWriterThread.Wakeup;
begin
  FWaiter.Wakeup;
end;

procedure TDBWriterThread.Stop;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure TDBWriterThread.Execute;
var nStr: string;
    i,nIdx: Integer;
begin
  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Exit;

    with FOwner do
    try
      FSyncLock.Enter;
      FBuffer.Clear;
      DoWeekCheck;
      
      for i:=Low(FItems) to High(FItems) do
      with FItems[i] do
      begin
        if Terminated then Exit;
        if FTable = '' then Continue;

        for nIdx:=0 to FItemCount - 1 do
        with FItemData[nIdx] do
        begin
          nStr := MacroValue(sSQLInsert, [MI('$TB', FTable), MI('$CH', FCH),
             MI('$DH', FDH), MI('$Idx', IntToStr(FSerial)),
             MI('$w1', FloatToStr(Fw1)), MI('$w2', FloatToStr(Fw2)),
             MI('$w3', FloatToStr(Fw3)), MI('$w4', FloatToStr(Fw4)),
             MI('$s1', FloatToStr(Fs1)), MI('$s2', FloatToStr(Fs2)),
             MI('$s3', FloatToStr(Fs3)), MI('$s4', FloatToStr(Fs4)),

             MI('$fj1', FloatToStr(Ffj1)), MI('$fj2', FloatToStr(Ffj2)),
             MI('$fj3', FloatToStr(Ffj3)), MI('$fj4', FloatToStr(Ffj4)),
             MI('$fj5', FloatToStr(Ffj5)),
             MI('$fjo', FloatToStr(Ffjo)), MI('$fjc', FloatToStr(Ffjc)),
             MI('$tfjb', FloatToStr(Ftfjb)), MI('$tfbj', FloatToStr(Ftfbj)),
             MI('$rs1', FloatToStr(Frs1)), MI('$rs2', FloatToStr(Frs2)),
             MI('$rs3', FloatToStr(Frs3)), MI('$rs4', FloatToStr(Frs4)),
             MI('$rld', FloatToStr(Frld)), MI('$rlh', FloatToStr(Frlh)),
             MI('$llt', FloatToStr(Fllt)), MI('$llk', FloatToStr(Fllk)),
             MI('$rll', FloatToStr(Frll)), MI('$slt', FloatToStr(Fslt)),
             MI('$$slk', FloatToStr(fslk)), MI('$sww', FloatToStr(Fsww)),
             MI('$cold', FloatToStr(Fcold)), MI('$hot', FloatToStr(Fhot)),
             MI('$weight', FloatToStr(Fweight)), MI('$mw', FloatToStr(Fmw)),
             MI('$aq', FloatToStr(Faq)), MI('$fy1', FloatToStr(Ffy1)),
             MI('$fy2', FloatToStr(Ffy2)), MI('$slkd', FloatToStr(Fslkd)),
             MI('$slb', FloatToStr(Fslb)), MI('$ccl', FloatToStr(Fccl)),
             MI('$ccr', FloatToStr(Fccr))]);
          FBuffer.Add(nStr);
        end;

        FItemIndex := 0;
        FItemCount := 0;
      end;
    finally
      FSyncLock.Leave;
    end;

    for nIdx:=0 to FBuffer.Count - 1 do
    begin
      if Terminated then Exit;
      FOwner.ExecuteSQL(FBuffer[nIdx]);       
    end;
  except
    //ignor any error
  end;
end;

//Desc: 周期检查
procedure TDBWriterThread.DoWeekCheck;
begin

end;

end.
