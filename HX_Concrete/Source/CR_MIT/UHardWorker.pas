{*******************************************************************************
  作者: dmzn@163.com 2011-10-22
  描述: 硬件处理工作对象
*******************************************************************************}
unit UHardWorker;

{$I Link.Inc}
interface

uses
  Windows, SysUtils, Classes, ComCtrls, UMgrDBConn, UParamManager, UMgrChannel,
  UBusinessWorker, UBusinessConst, UBusinessPacker;

type
  THardwareWorker = class(TBusinessWorkerBase)
  protected
    FErrNum: Integer;
    //错误码
    FDBConn: PDBWorker;
    //数据通道
    FDataIn,FDataOut: PBWDataBase;
    //入参出参
    FDataOutNeedUnPack: Boolean;
    //需要解包
    procedure GetInOutData(var nIn,nOut: PBWDataBase); virtual; abstract;
    //出入参数
    function VerifyParamIn(var nData: string): Boolean; virtual;
    //验证入参
    function DoDBWork(var nData: string): Boolean; virtual; abstract;
    function DoAfterDBWork(var nData: string; nResult: Boolean): Boolean; virtual;
    //数据业务
  public
    function DoWork(var nData: string): Boolean; override;
    //执行业务
  end;

  THarareBusinessCommander = class(THardwareWorker)
  protected
    FListA,FListB,FListC: TStrings;
    //list
    FIn: TWorkerBusinessCommand;
    FOut: TWorkerBusinessCommand;
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoDBWork(var nData: string): Boolean; override;
    //base funciton
    function ExecuteSQL(var nData: string): Boolean;
    //执行SQL语句
    function DoReaderCardIn(var nData: string): Boolean;
    //现场刷卡
    function CardVerify(const nCard: string; var nData: string): Boolean;
    function DoMakeTruckIn(var nData: string): Boolean;
    function DoMakeTruckOut(var nData: string): Boolean;
    //车辆进出厂
    function DoSaveTruckCard(var nData: string): Boolean;
    function DoLogoutBillCard(var nData: string): Boolean;
    //磁卡处理
    function LoadQueue(var nData: string): Boolean;
    //读取队列
  public
    constructor Create; override;
    destructor destroy; override;
    //new free
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

implementation

{$I Link.Inc}
uses
  ULibFun, UFormCtrl, UBase64, USysLoger, UMITConst, USysDB,
  UMgrHardHelper, UMgrQueue;

//Date: 2012-3-13
//Parm: 如参数护具
//Desc: 获取连接数据库所需的资源
function THardwareWorker.DoWork(var nData: string): Boolean;
begin
  Result := False;
  FDBConn := nil;

  with gParamManager.ActiveParam^ do
  try
    FDBConn := gDBConnManager.GetConnection(FDB.FID, FErrNum);
    if not Assigned(FDBConn) then
    begin
      nData := '连接HM数据库失败(DBConn Is Null).';
      Exit;
    end;

    if not FDBConn.FConn.Connected then
      FDBConn.FConn.Connected := True;
    //conn db

    FDataOutNeedUnPack := True;
    GetInOutData(FDataIn, FDataOut);
    FPacker.UnPackIn(nData, FDataIn);

    with FDataIn.FVia do
    begin
      FUser   := gSysParam.FProgID;
      FIP     := gSysParam.FLocalIP;
      FMAC    := gSysParam.FLocalMAC;
      FTime   := FWorkTime;
      FKpLong := FWorkTimeInit;
    end;

    {$IFDEF DEBUG}
    WriteLog('Fun: '+FunctionName+' InData:'+ FPacker.PackIn(FDataIn, False));
    {$ENDIF}
    if not VerifyParamIn(nData) then Exit;
    //invalid input parameter

    FPacker.InitData(FDataOut, False, True, False);
    //init exclude base
    FDataOut^ := FDataIn^;

    Result := DoDBWork(nData);
    //execute worker

    if Result then
    begin
      if FDataOutNeedUnPack then
        FPacker.UnPackOut(nData, FDataOut);
      //xxxxx
      
      Result := DoAfterDBWork(nData, True);
      if not Result then Exit;

      with FDataOut.FVia do
        FKpLong := GetTickCount - FWorkTimeInit;
      nData := FPacker.PackOut(FDataOut);

      {$IFDEF DEBUG}
      WriteLog('Fun: '+FunctionName+' OutData:'+ FPacker.PackOut(FDataOut, False));
      {$ENDIF}
    end else DoAfterDBWork(nData, False);
  finally
    gDBConnManager.ReleaseConnection(FDB.FID, FDBConn);
  end;
end;

//Date: 2012-3-22
//Parm: 输出数据;结果
//Desc: 数据业务执行完毕后的收尾操作
function THardwareWorker.DoAfterDBWork(var nData: string;
  nResult: Boolean): Boolean;
begin
  Result := True;
end;

//Date: 2012-3-18
//Parm: 入参数据
//Desc: 验证入参数据是否有效
function THardwareWorker.VerifyParamIn(var nData: string): Boolean;
begin
  Result := True;
end;

//------------------------------------------------------------------------------
class function THarareBusinessCommander.FunctionName: string;
begin
  Result := sBus_BusinessCommand;
end;

constructor THarareBusinessCommander.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;
  inherited;
end;

destructor THarareBusinessCommander.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  inherited;
end;

function THarareBusinessCommander.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
  end;
end;

procedure THarareBusinessCommander.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FDataOutNeedUnPack := False;
end;

//Date: 2012-3-22
//Parm: 输入数据
//Desc: 执行nData业务指令
function THarareBusinessCommander.DoDBWork(var nData: string): Boolean;
begin
  with FOut.FBase do
  begin
    FResult := True;
    FErrCode := 'S.00';
    FErrDesc := '业务执行成功.';
  end;

  case FIn.FCommand of
   cBC_RemoteExecSQL : Result := ExecuteSQL(nData);
   cBC_ReaderCardIn  : Result := DoReaderCardIn(nData);
   cBC_MakeTruckIn   : Result := DoMakeTruckIn(nData);
   cBC_MakeTruckOut  : Result := DoMakeTruckOut(nData);
   cBC_SaveTruckCard : Result := DoSaveTruckCard(nData);
   cBC_LogoutBillCard : Result := DoLogoutBillCard(nData);
   cBC_MakeTruckResponse : Result := DoReaderCardIn(nData);
   cBC_LoadQueueTrucks   : Result := LoadQueue(nData);
   else
    begin
      Result := False;
      nData := '无效的业务代码(Invalid Command).';
    end;
  end;
end;

//Desc: 执行SQL语句
function THarareBusinessCommander.ExecuteSQL(var nData: string): Boolean;
var nInt: Integer;
begin
  Result := True;
  nInt := gDBConnManager.WorkerExec(FDBConn, PackerDecodeStr(FIn.FData));
  FOut.FData := IntToStr(nInt);
end;

//Date: 2012-3-25
//Parm: 分组;对象;开启事务
//Desc: 获取nGroup.nObject当前的记录编号
function GetSerailID(const nGroup,nObject: string; const nDB: PDBWorker;
  const nTrans: Boolean = True): string;
var nStr,nP,nB: string;
begin
  if nTrans then nDB.FConn.BeginTrans;
  try
    nStr := 'Update %s Set B_Base=B_Base+1 ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sTable_SerialBase, nGroup, nObject]);
    gDBConnManager.WorkerExec(nDB, nStr);

    nStr := 'Select B_Prefix,B_IDLen,B_Base From %s ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sTable_SerialBase, nGroup, nObject]);

    with gDBConnManager.WorkerQuery(nDB, nStr) do
    begin
      nP := Fields[0].AsString;
      nB := Fields[2].AsString;

      nStr := StringOfChar('0', Fields[1].AsInteger-Length(nP)-Length(nB));
      Result := nP + nStr + nB;
    end;

    if nTrans then nDB.FConn.CommitTrans;
  except
    if nTrans then
      nDB.FConn.RollbackTrans;
    raise;
  end;
end;

//Desc: 现场用户刷卡
function THarareBusinessCommander.DoReaderCardIn(var nData: string): Boolean;
var nIdx: Integer;
    nStr,nTruck: string;
    nPTruck: PTruckItem;
begin
  Result := False;
  FListA.Text := FIn.FData;

  nTruck := FListA.Values['Card'];
  if nTruck = '' then
    nTruck := FIn.FData;
  //only card

  nStr := 'Select T_Truck From %s Where T_Card=''%s''';
  nStr := Format(nStr, [sTable_ZCTrucks, nTruck]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount > 0 then
    begin
      nTruck := Fields[0].AsString;
    end else
    begin
      nData := '没有找到磁卡匹配的车牌号.';
      Exit;
    end;
  end;

  gTruckQueueManager.SyncLock.Enter;
  try
    nIdx := gTruckQueueManager.TruckInQueue(nTruck, False);
    if nIdx < 0 then
    begin
      nData := Format('车辆[ %s ]不在队列中.', [nTruck]);
      Exit;
    end;

    nPTruck := gTruckQueueManager.Trucks[nIdx];
    if nPTruck.FCallNum < 1 then
    begin
      nData := Format('车辆[ %s ]未被叫到,需等候.', [nTruck]);
      Exit;
    end;

    if nPTruck.FCallNum > cTruckMaxCalledNum then
    begin
      nData := Format('车辆[ %s ]已呼叫超时.', [nTruck]);
      Exit;
    end;

    nStr := FListA.Values['Line'];
    if (nStr <> '') and (nPTruck.FLine <> nStr) then
    begin
      nData := Format('车辆[ %s ]需在[ %s ]仓装车.', [nTruck, nPTruck.FLine]);
      Exit;
    end;

    nStr := '<?xml version="1.0" encoding="gb2312"?>' +
            '<call_truck_responese><call_truck_responese_row>' +
            '<result>y</result><hint>ok</hint>' +
            '<truck>%s</truck>' +
            '</call_truck_responese_row></call_truck_responese>';
    nStr := Format(nStr, [nTruck]);
    nStr := Char(cCall_Prefix_1) + Char(cCall_Prefix_2) +
            Char(cCMD_CallTruck) + EncodeBase64(nStr);
    //combine data

    for nIdx:=1 to 2 do
    begin
      gClientUDPServer.Send(nPTruck.FCallIP, nPTruck.FCallPort, nStr);
      Sleep(100);
    end; //防止丢包

    nPTruck.FAnswered := True;
    //应答标记
    Result := True;
    FOut.FBase.FResult := True;

    nStr := Format('向[ %s,%d ]发送叫车应答.', [nPTruck.FCallIP, nPTruck.FCallPort]);
    WriteLog(nStr);
  finally
    gTruckQueueManager.SyncLock.Leave;
  end;
end;

//Date: 2013-07-08
//Parm: 磁卡;结果
//Desc: 验证nCard是否有效
function THarareBusinessCommander.CardVerify(const nCard: string;
  var nData: string): Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select C_Status,C_Freeze,C_TruckNo From %s Where C_Card=''%s''';
  nStr := Format(nStr, [sTable_Card, nCard]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    if Fields[0].AsString <> sFlag_CardUsed then
    begin
      nData := '磁卡[ %s ]状态为[ %s ],无法使用.';
      nData := Format(nData, [nCard, CardStatusToStr(Fields[0].AsString)]);
      Exit;
    end;

    if Fields[1].AsString = sFlag_Yes then
    begin
      nData := '磁卡[ %s ]已被冻结,无法提货.';
      nData := Format(nData, [nCard]);
      Exit;
    end;

    Result := True;
    nData := Fields[2].AsString;
    //truck
  end else
  begin
    nData := '该磁卡不存在或已无效.';
  end;
end;

//Desc: 车辆进站
function THarareBusinessCommander.DoMakeTruckIn(var nData: string): Boolean;
var nStr,nTID,nTruck: string;
    nIdx: Integer;
    nList: TStrings;
begin
  Result := CardVerify(FIn.FData, nData);
  if not Result then Exit;
  nTruck := nData;

  nList := TStringList.Create;
  try
    nStr := 'Select zt.T_TruckLog,tl.T_Status From %s zt ' +
            ' Left Join %s tl On tl.T_ID = zt.T_TruckLog ' +
            'Where zt.T_Card=''%s''';
    nStr := Format(nStr, [sTable_ZCTrucks, sTable_TruckLog, FIn.FData]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      if Fields[1].AsString = sFlag_TruckIn then
        Exit;
      //新进站状态,允许多次刷卡

      nStr := 'Delete From %s Where T_TruckLog=''%s''';
      nStr := Format(nStr, [sTable_ZCTrucks, Fields[0].AsString]);
      nList.Add(nStr);

      nStr := 'Delete From %s Where T_ID=''%s''';
      nStr := Format(nStr, [sTable_ZCTrucks, Fields[0].AsString]);
      nList.Add(nStr);
    end;

    FDBConn.FConn.BeginTrans;
    try
      nTID := GetSerailID(sFlag_SerailSYS, sFlag_TruckLog, FDBConn, False);
      nStr := MakeSQLByStr([SF('T_ID', nTID), SF('T_Truck', nTruck),
              SF('T_Status', sFlag_TruckIn),
              SF('T_NextStatus', sFlag_TruckQIn),
              SF('T_InTime' ,sField_SQLServer_Now, sfVal),
              SF('T_InMan', FIn.FBase.FFrom.FUser)], sTable_TruckLog, '', True);
      nList.Add(nStr);

      nStr := MakeSQLByStr([SF('T_Truck', nTruck),
              SF('T_Card', FIn.FData),
              SF('T_TruckLog', nTID), SF('T_Valid', sFlag_Yes),
              SF('T_InTime' ,sField_SQLServer_Now, sfVal)
              ], sTable_ZCTrucks, '', True);
      nList.Add(nStr);

      for nIdx:=0 to nList.Count - 1 do
        gDBConnManager.WorkerExec(FDBConn, nList[nIdx]);
      FDBConn.FConn.CommitTrans;
    except
      FDBConn.FConn.RollbackTrans;
      raise;
    end;
  finally
    nList.Free;
  end;
end;

//Desc: 车辆出站
function THarareBusinessCommander.DoMakeTruckOut(var nData: string): Boolean;
var nStr,nTID,nTruck: string;
begin
  Result := False;
  if not CardVerify(FIn.FData, nData) then Exit;
  nTruck := nData;

  nStr := 'Select zt.T_TruckLog,tl.T_NextStatus From %s zt ' +
          ' Left Join %s tl On tl.T_ID = zt.T_TruckLog ' +
          'Where zt.T_Card=''%s''';
  nStr := Format(nStr, [sTable_ZCTrucks, sTable_TruckLog, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '该磁卡没有需要出站的车辆.';
      Exit;
    end;

    nStr := Fields[1].AsString;
    if nStr <> sFlag_TruckOut then
    begin
      nStr := TruckStatusToStr(nStr);
      nData := Format('车辆[ %s ]下一状态为[ %s ],不能出站.', [nTruck, nStr]);
      Exit;
    end;

    nTID := Fields[0].AsString;
    //truck id
  end;

  FDBConn.FConn.BeginTrans;
  try
    nStr := 'Delete From %s Where T_Card=''%s''';
    nStr := Format(nStr, [sTable_ZCTrucks, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := MakeSQLByStr([SF('T_Status', sFlag_TruckOut),
            SF('T_NextStatus', ''),
            SF('T_OutTime' ,sField_SQLServer_Now, sfVal),
            SF('T_OutMan', FIn.FBase.FFrom.FUser)
            ], sTable_TruckLog, SF('T_ID', nTID), False);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    FDBConn.FConn.CommitTrans;
    //commit trans
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Desc: 办理磁卡
function THarareBusinessCommander.DoSaveTruckCard(var nData: string): Boolean;
var nStr: string;
begin
  Result := False;
  FListA.Text := FIn.FData;

  nStr := 'Select C_TruckNo From %s Where C_Card=''%s'' And C_Status=''%s''';
  nStr := Format(nStr, [sTable_Card, FListA.Values['Card'], sFlag_CardUsed]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nStr := Fields[0].AsString;
    if CompareText(nStr, FListA.Values['Truck']) <> 0 then
    begin
      nData := Format('车辆[ %s ]正在使用该卡,请先注销.', [nStr]);
      Exit;
    end;
  end;

  FDBConn.FConn.BeginTrans;
  try
    nStr := MakeSQLByStr([SF('C_TruckNo', FListA.Values['Truck']),
            SF('C_Status', sFlag_CardUsed),
            SF('C_Freeze', sFlag_No),
            SF('C_Date' ,sField_SQLServer_Now, sfVal),
            SF('C_Man', FIn.FBase.FFrom.FUser)
            ], sTable_Card, SF('C_Card', FListA.Values['Card']), False);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := MakeSQLByStr([SF('T_Card', FListA.Values['Card'])
            ],sTable_ZCTrucks, SF('T_Truck', FListA.Values['Truck']), False);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    FDBConn.FConn.CommitTrans;
    //commit trans
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Desc: 注销磁卡
function THarareBusinessCommander.DoLogoutBillCard(var nData: string): Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select T_Truck From %s Where T_Card=''%s''';
  nStr := Format(nStr, [sTable_ZCTrucks, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nStr := '该磁卡有对应的车辆[ %s ]在站内,无法注销.';
    nData := Format(nStr, [Fields[0].AsString]);
    Exit;
  end;

  nStr := 'Update %s Set C_Status=''%s'' Where C_Card=''%s''';
  nStr := Format(nStr, [sTable_Card, sFlag_CardInvalid, FIn.FData]);

  gDBConnManager.WorkerExec(FDBConn, nStr);
  Result := True;
end;

//Desc: 读取队列列表
function THarareBusinessCommander.LoadQueue(var nData: string): Boolean;
var nIdx: Integer;
    nTruck: PTruckItem;
begin
  with gTruckQueueManager do
  try
    SyncLock.Enter;
    FListA.Clear;
    FListB.Clear;

    for nIdx:=0 to Trucks.Count - 1 do
    begin
      nTruck := Trucks[nIdx];
      with FListB do
      begin
        Values['Truck'] := nTruck.FTruck;
        Values['Line'] := nTruck.FLine;
        Values['LineName'] := nTruck.FLineName;

        Values['IsVIP'] := nTruck.FIsVIP;
        Values['CallNum'] := IntToStr(nTruck.FCallNum);
        Values['InTime'] := DateTime2Str(nTruck.FInTime);

        if nTruck.FAnswered then
             Values['Answered'] := sFlag_Yes
        else Values['Answered'] := sFlag_No;
      end;

      FListA.Add(PackerEncodeStr(FListB.Text));
    end;

    FOut.FData := FListA.Text;
    Result := True;
  finally
    SyncLock.Leave;
  end;
end;

initialization
  gBusinessWorkerManager.RegisteWorker(THarareBusinessCommander);
end.
