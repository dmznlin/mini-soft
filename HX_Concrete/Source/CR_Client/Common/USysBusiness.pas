{*******************************************************************************
  作者: dmzn@163.com 2007-10-09
  描述: 系统业务逻辑单元
*******************************************************************************}
unit USysBusiness;

interface

uses
  Windows, Classes, Controls, SysUtils, ULibFun, UBusinessWorker,
  UBusinessConst, UBusinessPacker, UClientWorker, UDataModule, UDataReport,
  USysNumber, UFormBase, UFormCtrl, UFormDateFilter, USysDB, USysConst;

type
  TLadingTruckItem = record
    FCard     : string;      //磁卡号
    FTruck    : string;      //车牌号
    FStatus   : string;      //当前
    FNext     : string;      //下一

    FOrder    : string;      //订单号
    FOrderTy  : string;      //类型
    FCusName  : string;      //客户名称

    FBill     : string;      //交货单
    FType     : string;      //类型
    FStock    : string;      //品种
    FValue    : Double;      //提货量
  end;

  TLadingTruckItems = array of TLadingTruckItem;

  PZTLineItem = ^TZTLineItem;
  TZTLineItem = record
    FID       : string;      //编号
    FName     : string;      //名称
    FStock    : string;      //品名
    FWeight   : Integer;     //袋重
    FValid    : Boolean;     //是否有效
  end;

  PZTTruckItem = ^TZTTruckItem;
  TZTTruckItem = record
    FTruck    : string;      //车牌号
    FLine     : string;      //通道
    FBill     : string;      //提货单
    FValue    : Double;      //提货量
    FDai      : Integer;     //袋数
    FTotal    : Integer;     //总数
    FInFact   : Boolean;     //是否进厂
    FIsRun    : Boolean;     //是否运行    
  end;

  TZTLineItems = array of TZTLineItem;
  TZTTruckItems = array of TZTTruckItem;

//------------------------------------------------------------------------------
function GetQueryField(const nType: Integer): string;
//获取查询的字段

procedure InitPoundItem(var nData: TWorkerBusinessPound);
//初始化磅信息
function ReadPoundLog(var nData: TWorkerBusinessPound): Boolean;
//读取本地过磅信息
function PoundReadBill(var nData: TWorkerBusinessPound): Boolean;
//读取交货单
function PoundReadOrder(var nData: TWorkerBusinessPound): Boolean;
//读取原料单
function PoundDeleteLog(const nPound: string): Boolean;
function PoundDeleteSAPLog(const nPound: string): Boolean;
//删除过磅记录
function PoundReadTruck(var nData: TWorkerBusinessPound): Boolean;
//读取车辆过磅信息
function PoundLoadMaterails(const nID,nName: TStrings): Boolean;
//读取物料列表
function PoundSaveData(var nData: TWorkerBusinessPound): Boolean;
//保存过磅数据

function SetBillCard(const nBill,nTruck: string; nVerify: Boolean): Boolean;
//交货单制卡
function SaveBillCard(const nBill,nTruck,nCard: string;
 const nCardA: string = ''; const nCardB: string = ''): Boolean;
//提货单绑定磁卡
function LogoutBillCard(const nCard: string; const nBill: string = ''): Boolean;
//注销卡
function GetLadingBills(const nCard,nPost: string;
 var nData: TLadingTruckItems): Boolean;
//获取指定岗位交货单列表
procedure LoadBillItemToMC(const nItem: TLadingTruckItem; const nMC: TStrings;
 const nDelimiter: string = ';');
//载入交货单信息
function SaveLadingBills(const nPost: string; nData: TLadingTruckItems): Boolean;
//保存指定岗位的交货单

function ReadPoundCard(const nPound: string): string;
//读取本磅磁卡号
function CheckSAPServiceStatus: Boolean;
//监测SAP服务状态
function LoadTruckQueue(var nLines: TZTLineItems; var nTrucks: TZTTruckItems;
 const nRefreshLine: Boolean = False): Boolean;
//读取车辆队列
function MakeTruckOutQueue(const nLine,nTruck: string): Boolean;
//车辆出队
procedure PrinterEnable(const nTunnel: string; const nEnable: Boolean);
//启停喷码机

function PrintBillReport(const nBill,nStock: string; nAsk: Boolean): Boolean;
//打印交货单
function PrintPoundReport(const nPound: string; nAsk: Boolean): Boolean;
//打印过磅单

implementation

type
  TMaterailsItem = record
    FID   : string;         //编号
    FName : string;         //名称
  end;
  
var
  gMaterails: array of TMaterailsItem;
  //全局使用

//------------------------------------------------------------------------------
//Date: 2012-3-20
//Parm: 查询类型
//Desc: 获取nType所需的字段
function GetQueryField(const nType: Integer): string;
var nIn: TWorkerQueryFieldData;
    nOut: TWorkerQueryFieldData;
    nWorker: TBusinessWorkerBase;
begin
  Result := '*';
  Exit;
  //if gSysParam.FNetBusMIT then Exit;
  
  nWorker := nil;
  try
    nIn.FType := nType;
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_GetQueryField);

    if nWorker.WorkActive(@nIn, @nOut) then
    begin
      Result := Trim(nOut.FData);
      if Result = '' then Result := '*';
    end;
  finally
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//------------------------------------------------------------------------------
//Desc: 初始化磅重记录
procedure InitPoundItem(var nData: TWorkerBusinessPound);
var nPacker: TBusinessPackerBase;
begin
  nPacker := gBusinessPackerManager.LockPacker(sBus_PoundCommand);
  try
    nPacker.InitData(@nData, False);
  finally
    gBusinessPackerManager.RelasePacker(nPacker);
  end;
end;

//Desc: 读取过磅记录
function ReadPoundLog(var nData: TWorkerBusinessPound): Boolean;
var nStr: string;
begin
  Result := False;
  nData.FNewPound := True;
  nData.FStatus := sFlag_TruckBFP;

  if nData.FPound <> '' then
  begin
    nStr := 'Select * From %s Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_PoundLog, nData.FPound]);
  end else //磅单号

  if nData.FCard <> '' then
  begin
    if Pos('+', nData.FCard) > 0 then
    begin
      System.Delete(nData.FCard, 1, 1);
      nStr := nStr + 'P_Bill=''$ID''';
    end else

    if Pos('-', nData.FCard) > 0 then
    begin
      System.Delete(nData.FCard, 1, 1);
      nStr := nStr + 'P_Card=''$ID''';
    end else
    begin
      nStr := nStr + 'P_Card=''$ID'' Or P_Bill=''$ID''';
    end;

    nStr := 'Select * From $PD Where ' + nStr;
    nStr := MacroValue(nStr, [MI('$PD', sTable_PoundLog),
            MI('$ID', nData.FCard)]);
    //xxxxx
  end else //销售单

  if nData.FTruck = '' then
  begin
    Exit;
  end else
  begin
    nStr := 'Select * From %s Where P_Truck=''%s'' And ' +
            '(IsNull(P_PDate,'''') = '''' Or IsNull(P_MDate,'''') = '''')';
    nStr := Format(nStr, [sTable_PoundLog, nData.FTruck]);
  end;

  with FDM.QueryTemp(nStr, gSysParam.FNetBusMIT) do
  begin
    Result := RecordCount > 0;
    if not Result then Exit;

    with nData do
    begin
      FNewPound    := False;
      FType        := FieldByName('P_Type').AsString;
      FPound       := FieldByName('P_ID').AsString;
      FBillID      := FieldByName('P_Bill').AsString;
      FOrder       := FieldByName('P_Order').AsString;
      FTruck       := FieldByName('P_Truck').AsString;
      FCusID       := FieldByName('P_CusID').AsString;
      FCusName     := FieldByName('P_CusName').AsString;
      FMType       := FieldByName('P_MType').AsString;
      FMID         := FieldByName('P_MID').AsString;
      FMName       := FieldByName('P_MName').AsString;
      FFactNum     := FieldByName('P_FactID').AsString;
      FLimValue    := FieldByName('P_LimValue').AsFloat;
      FPValue      := FieldByName('P_PValue').AsFloat;
      FPDate       := FieldByName('P_PDate').AsString;
      FPMan        := FieldByName('P_PMan').AsString;
      FMValue      := FieldByName('P_MValue').AsFloat;
      FMDate       := FieldByName('P_MDate').AsString;
      FMMan        := FieldByName('P_MMan').AsString;

      FStation     := FieldByName('P_Station').AsString;
      FDirect      := FieldByName('P_Direction').AsString;
      FPModel      := FieldByName('P_PModel').AsString;
      FStatus      := FieldByName('P_Status').AsString;

      if FStatus = sFlag_TruckBFP then
           FStatus := sFlag_TruckBFM
      else FStatus := sFlag_TruckBFP;
    end;
  end;
end;

//Date: 2012-3-22
//Desc: 获取nData.FBill的过磅信息
function PoundReadBill(var nData: TWorkerBusinessPound): Boolean;
var nWorker: TBusinessWorkerBase;
begin
  if gSysParam.FNetBusMIT then
  begin
    ReadPoundLog(nData);
    Result := True;
    Exit;
  end;

  nWorker := nil;
  try
    nData.FCommand := cBC_ReadBillInfo;
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_PoundCommand);

    Result := nWorker.WorkActive(@nData, @nData);
    Exit;
  finally
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//Date: 2012-3-27
//Desc: 读取nData.FOrder订单信息
function PoundReadOrder(var nData: TWorkerBusinessPound): Boolean;
var nWorker: TBusinessWorkerBase;
begin
  if gSysParam.FNetBusMIT then
  begin
    ReadPoundLog(nData);
    Result := True;
    Exit;
  end;
  
  nWorker := nil;
  try
    nData.FCommand := cBC_ReadOrderInfo;
    nData.FFactNum := gSysParam.FFactNum;
    nData.FSAPOK := not (gSysParam.FNetSAPSrv and gSysParam.FNetSAPMIT);
    
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_PoundCommand);
    Result := nWorker.WorkActive(@nData, @nData);
    if not Result then Exit;

    if nData.FBase.FErrCode = 'W.00' then
    begin
      ShowDlg(nData.FBase.FErrDesc, sHint);
    end;
  finally
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//Date: 2012-3-31
//Parm: 称重记录
//Desc: 删除nPound记录
function PoundDeleteLog(const nPound: string): Boolean;
var nStr: string;
begin
  nStr := 'Delete From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_PoundLog, nPound]);
  
  FDM.ExecuteSQL(nStr, False);
  FDM.ExecuteSQL(nStr, True);
  Result := True;
end;

//Date: 2012-7-6
//Parm: 称重记录号
//Desc: 删除SAP过磅记录
function PoundDeleteSAPLog(const nPound: string): Boolean;
var nIn,nOut: TWorkerBusinessPound;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := cBC_DeletePoundLog;
    nIn.FPound := nPound;

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_PoundCommand);
    Result := nWorker.WorkActive(@nIn, @nOut); 
  finally
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//Date: 2012-3-22
//Desc: 获取nData.FTruck的过磅信息
function PoundReadTruck(var nData: TWorkerBusinessPound): Boolean;
var nItem: TWorkerBusinessPound;
    nWorker: TBusinessWorkerBase;
begin
  if gSysParam.FNetBusMIT then
  begin
    ReadPoundLog(nData);
    Result := True;
    Exit;
  end;

  nWorker := nil;
  try
    nData.FCommand := cBC_ReadTruckInfo;
    nData.FBase.FParam := sParam_NoHintOnError;

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_PoundCommand);
    Result := nWorker.WorkActive(@nData, @nItem);

    if Result then
         nData := nItem
    else Result := True;
  finally
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//------------------------------------------------------------------------------
//Desc: 尝试从缓存载入物料
function LoadMaterailsFromBuffer(const nID,nName: TStrings): Boolean;
var nIdx: Integer;
begin
  Result := Length(gMaterails) > 0;
  if not Result then Exit;

  nID.Clear;
  nName.Clear;

  for nIdx:=Low(gMaterails) to High(gMaterails) do
  begin
    nID.Add(gMaterails[nIdx].FID);
    nName.Add(gMaterails[nIdx].FName);
  end;
end;

//Desc: 从本地数据库读取物料
function ReadMaterails(const nID,nName: TStrings): Boolean;
var nStr: string;
    nIdx: Integer;
begin
  nStr := 'Select M_ID,M_Name From %s Order By M_ID ASC';
  nStr := Format(nStr, [sTable_Materails]);

  with FDM.QueryTemp(nStr, True) do
  begin
    SetLength(gMaterails, RecordCount);
    Result := Length(gMaterails) > 0;
    if not Result then Exit;

    nIdx := 0;
    First;

    while not Eof do
    begin
      gMaterails[nIdx].FID := Fields[0].AsString;
      gMaterails[nIdx].FName := Fields[1].AsString;

      Inc(nIdx);
      Next;
    end;

    LoadMaterailsFromBuffer(nID, nName);
  end;
end;

//Desc: 更新本地物料
procedure SaveMaterails;
var nStr: string;
    nIdx: Integer;
begin
  nStr := 'Delete From ' + sTable_Materails;
  FDM.ExecuteSQL(nStr, True);

  for nIdx:=Low(gMaterails) to High(gMaterails) do
  with gMaterails[nIdx] do
  begin
    nStr := 'Insert Into %s(M_ID,M_Name) Values(''%s'',''%s'')';
    nStr := Format(nStr, [sTable_Materails, FID, FName]);
    FDM.ExecuteSQL(nStr, True);
  end;

  nStr := 'Update %s Set D_ParamB=''%s'' Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, Date2Str(NOw), sFlag_LoadMaterails]);
  FDM.ExecuteSQL(nStr, True);
end;

//Desc: 本地物料是否刚更新
function IsUpdateMaterailsJust: Boolean;
var nStr: string;
    nDate: TDateTime;
begin
  nStr := 'Select D_Value,D_ParamB From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict,sFlag_LoadMaterails]);

  with FDM.QueryTemp(nStr, True) do
  if RecordCount > 0 then
  begin
    nDate := Now - Str2Date(Fields[1].AsString);
    if nDate >= Fields[0].AsInteger then
         nDate := 1
    else nDate := 0;
  end else nDate := 0;

  Result := nDate = 0;
end;

//Date: 2012-3-22
//Parm: 物料号;物料名
//Desc: 可用的物料列表
function PoundLoadMaterails(const nID,nName: TStrings): Boolean;
var nIdx: Integer;
    nListA,nListB: TStrings;
    nIn: TWorkerBusinessCommand;
    nOut: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  Result := LoadMaterailsFromBuffer(nID, nName);
  if Result then Exit;
  //buffer load ok

  if gSysParam.FNetBusMIT or IsUpdateMaterailsJust then
  begin
    Result := ReadMaterails(nID, nName);
    Exit;
  end;

  nListA := nil;
  nListB := nil;
  nWorker := nil;
  try
    nIn.FCommand := cBC_LoadMaterails;
    nIn.FSAPOK := not (gSysParam.FNetSAPSrv and gSysParam.FNetSAPMIT);
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessCommand);

    Result := nWorker.WorkActive(@nIn, @nOut);
    if not Result then
    begin
      ReadMaterails(nID, nName);
      Exit;
    end;

    nListA := TStringList.Create;
    nListA.Text := PackerDecodeStr(nOut.FData);

    if nListA.Count < 1 then Exit;
    nListB := TStringList.Create;
    SetLength(gMaterails, nListA.Count);

    for nIdx:=0 to nListA.Count - 1 do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      gMaterails[nIdx].FID := nListB.Values['ID'];
      gMaterails[nIdx].FName := nListB.Values['Name'];
    end;

    Result := LoadMaterailsFromBuffer(nID, nName);
    if Result then SaveMaterails;
  finally
    nListA.Free;
    nListB.Free;
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2012-3-25
//Parm: 分组;对象;开启事务
//Desc: 获取nGroup.nObject当前的记录编号
function GetSerailID(const nGroup,nObject: string): string;
var nStr,nP,nB: string;
begin
  nStr := 'Update %s Set B_Base=B_Base+1 ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, nGroup, nObject]);
  FDM.ExecuteSQL(nStr, True);

  nStr := 'Select B_Prefix,B_IDLen,B_Base From %s ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, nGroup, nObject]);

  with FDM.QueryTemp(nStr, True) do
  begin
    nP := Fields[0].AsString;
    nB := Fields[2].AsString;

    nStr := StringOfChar('0', Fields[1].AsInteger-Length(nP)-Length(nB));
    Result := nP + nStr + nB;
  end;
end;

//Desc: 保存本地数据
function SavePound(var nData: TWorkerBusinessPound): Boolean;
var nNew: Boolean;
    nStr,nWhere: string;
begin
  with nData do
  try
    if FPound <> '' then
    begin
      nStr := 'Select Count(*) From %s Where P_ID=''%s''';
      nStr := Format(nStr, [sTable_PoundLog, FPound]);
      nNew := FDM.QueryTemp(nStr, True).Fields[0].AsInteger < 1;
    end else nNew := True;

    if nNew then
    begin
      if FPound = '' then
        FPound := GetSerailID(sFlag_SerailSYS, sFlag_PoundLog);
      //xxxxx
    end else
    begin
      nWhere := Format('P_ID=''%s''', [FPound]);
    end;

    nStr := MakeSQLByStr([
      SF('P_ID', FPound),
      SF('P_Type', FType),
      SF('P_Bill', FBillID),
      SF('P_Order', FOrder),
      SF('P_Truck', FTruck),
      SF('P_CusID', FCusID),
      SF('P_CusName', FCusName),
      SF('P_MID', FMID),
      SF('P_MName', FMName),
      SF('P_MType', FMType),
      SF('P_LimValue', FLimValue, sfVal),
      SF('P_PValue', '$PV', sfVal),
      SF('P_PDate', '$PD', sfVal), SF('P_PMan', '$PM', sfVal),
      SF('P_MValue', '$MV', sfVal),
      SF('P_MDate', '$MD', sfVal), SF('P_MMan', '$MM', sfVal),
      SF('P_FactID', FFactNum),
      SF('P_Station', FStation),
      SF('P_MAC', gSysParam.FLocalMAC),
      SF('P_Direction', FDirect),
      SF('P_PModel', FPModel),
      SF('P_Status', FStatus),
      SF('P_Valid', sFlag_Yes)], sTable_PoundLog, nWhere, nNew);
    //xxxxx

    if FPValue = 0 then
    begin
      nStr := MacroValue(nStr, [MI('$PV', 'Null'),
              MI('$PD', 'Null'), MI('$PM', 'Null')]);
    end else
    begin
      nStr := MacroValue(nStr, [MI('$PV', FloatToStr(FPValue))]);
      if FPDate = '' then
           nStr := MacroValue(nStr, [MI('$PD', sField_SQLServer_Now)])
      else nStr := MacroValue(nStr, [MI('$PD', ''''+FPDate+'''')]);

      if FPMan = '' then
           nStr := MacroValue(nStr, [MI('$PM', ''''+gSysParam.FUserID+'''')])
      else nStr := MacroValue(nStr, [MI('$PM', ''''+FPMan+'''')]);
    end;

    if FMValue = 0 then
    begin
      nStr := MacroValue(nStr, [MI('$MV', 'Null'),
              MI('$MD', 'Null'), MI('$MM', 'Null')]);
    end else
    begin
      nStr := MacroValue(nStr, [MI('$MV', FloatToStr(FMValue))]);
      if FMDate = '' then
           nStr := MacroValue(nStr, [MI('$MD', sField_SQLServer_Now)])
      else nStr := MacroValue(nStr, [MI('$MD', ''''+FMDate+'''')]);

      if FMMan = '' then
           nStr := MacroValue(nStr, [MI('$MM', ''''+gSysParam.FUserID+'''')])
      else nStr := MacroValue(nStr, [MI('$MM', ''''+FMMan+'''')]);
    end;

    FDM.ExecuteSQL(nStr, True);
    Result := True;
  except
    Result := False;
  end;
end;

//Desc: 保存车牌号
procedure SaveTruckNo(const nTruck: string);
var nStr: string;
begin
  nStr := 'Select Count(*) From %s Where T_Truck=''%s'''; 
  nStr := Format(nStr, [sTable_Truck, nTruck]);
  if FDM.QueryTemp(nStr).Fields[0].AsInteger > 0 then Exit;

  nStr := 'Insert Into %s(T_Truck, T_PY) Values(''%s'', ''%s'')';
  nStr := Format(nStr, [sTable_Truck, nTruck, GetPinYinOfStr(nTruck)]);
  FDM.ExecuteSQL(nStr);
end;

//Date: 2012-3-23
//Parm: 称重数据
//Desc: 保存称重数据
function PoundSaveData(var nData: TWorkerBusinessPound): Boolean;
var nStr: string;
    nOut: TWorkerBusinessPound;
    nWorker: TBusinessWorkerBase;
begin
  with nData do
  begin
    if FBillID <> '' then
      FType := sFlag_Sale
    else
    if FOrder <> '' then
      FType := sFlag_Provide
    else
      FType := sFlag_Other;
    //xxxxx
  end;

  Result := SavePound(nData);
  if not Result then
  begin
    ShowMsg('保存本机过磅数据失败', sHint);
    Exit;
  end;

  if gSysParam.FNetBusMIT then Exit;
  //离线模式
  
  SaveTruckNo(nData.FTruck);
  //保存车牌号

  nWorker := nil;
  try
    nData.FCommand := cBC_SavePoundData;
    nData.FSAPOK := not gSysParam.FNetSAPSrv;

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_PoundCommand);
    Result := nWorker.WorkActive(@nData, @nOut);

    if Result then
    begin
      nStr := 'Update %s Set P_Status=''%s'' Where P_ID=''%s''';
      nStr := Format(nStr, [sTable_PoundLog, sFlag_TruckMIT, nData.FPound]);
      FDM.ExecuteSQL(nStr, True);
    end;
  finally
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2012-4-6
//Parm: 交货单;车牌号;校验制卡开关
//Desc: 为nBill交货单制卡
function SetBillCard(const nBill,nTruck: string; nVerify: Boolean): Boolean;
var nStr: string;
    nP: TFormCommandParam;
begin
  Result := True;
  if nVerify then
  begin
    nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ViaBillCard]);

    with FDM.QueryTemp(nStr) do
     if (RecordCount < 1) or (Fields[0].AsString <> sFlag_Yes) then Exit;
    //no need do card
  end;

  nP.FParamA := nBill;
  nP.FParamB := nTruck;
  CreateBaseFormItem(cFI_FormMakeCard, '', @nP);
  Result := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;

//Date: 2012-4-5
//Parm: 交货单号;车船号;主卡;附卡A,B
//Desc: 为交货单nBill绑定提货磁卡
function SaveBillCard(const nBill,nTruck,nCard,nCardA,nCardB: string): Boolean;
var nListA,nListB: TStrings;
    nIn: TWorkerBusinessCommand;
    nOut: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nListA := nil;
  nListB := nil;
  nWorker := nil;
  try
    nListB := TStringList.Create;
    with nListB do
    begin
      Values['M'] := nCard;
      Values['A'] := nCardA;
      Values['B'] := nCardB;
    end;

    nListA := TStringList.Create;
    with nListA do
    begin
      Values['Bill'] := nBill;
      Values['Card'] := PackerEncodeStr(nListB.Text);
      Values['Truck'] := nTruck;
    end;

    nIn.FCommand := cBC_SaveBillCard;
    nIn.FData := PackerEncodeStr(nListA.Text);

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessCommand);
    Result := nWorker.WorkActive(@nIn, @nOut);
  finally
    nListA.Free;
    nListB.Free;
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//Date: 2012-4-8
//Parm: 磁卡号;交货单
//Desc: 注销指定磁卡号
function LogoutBillCard(const nCard,nBill: string): Boolean;
var nList: TStrings;
    nIn: TWorkerBusinessCommand;
    nOut: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nList := nil;
  nWorker := nil;
  try
    nList := TStringList.Create;
    with nList do
    begin
      Values['Bill'] := nBill;
      Values['Card'] := nCard;
    end;

    nIn.FCommand := cBC_LogoutBillCard;
    nIn.FData := PackerEncodeStr(nList.Text);

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessCommand);
    Result := nWorker.WorkActive(@nIn, @nOut);
  finally
    nList.Free;
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//Date: 2012-3-23
//Parm: 磁卡号;岗位;交货单列表
//Desc: 获取nPost岗位上磁卡为nCard的交货单列表
function GetLadingBills(const nCard,nPost: string;
 var nData: TLadingTruckItems): Boolean;
var nIdx: Integer;
    nListA,nListB: TStrings;
    nIn: TWorkerBusinessCommand;
    nOut: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nListA := nil;
  nListB := nil;
  nWorker := nil;
  try
    nListA := TStringList.Create;
    nListA.Values['Card'] := nCard;
    nListA.Values['Post'] := nPost;

    nIn.FCommand := cBC_GetPostBills;
    nIn.FData := PackerEncodeStr(nListA.Text);
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessCommand);

    SetLength(nData, 0);
    Result := nWorker.WorkActive(@nIn, @nOut);
    if not Result then Exit;
    
    nListA.Text := PackerDecodeStr(nOut.FData);
    SetLength(nData, nListA.Count);
    nListB := TStringList.Create;

    for nIdx:=Low(nData) to High(nData) do
    with nData[nIdx],nListB do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);

      FCard     := Values['Card'];
      FTruck    := Values['Truck'];
      FStatus   := Values['Status'];
      FNext     := Values['Next'];

      FOrder    := Values['Order'];
      FOrderTy  := Values['OrderTy'];
      FCusName  := Values['CusName'];

      FBill     := Values['Bill'];
      FType     := Values['Type'];
      FStock    := Values['Stock'];

      if IsNumber(Values['Value'], True) then
           FValue := StrToFloat(Values['Value'])
      else FValue := 0;
    end;
  finally
    nListA.Free;
    nListB.Free;
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//Date: 2012-3-25
//Parm: 交货单项; MCListBox;分隔符
//Desc: 将nItem载入nMC
procedure LoadBillItemToMC(const nItem: TLadingTruckItem; const nMC: TStrings;
 const nDelimiter: string);
var nStr: string;
begin
  with nItem,nMC do
  begin
    Clear;
    Add(Format('车牌号码:%s %s', [nDelimiter, FTruck]));
    Add(Format('当前状态:%s %s', [nDelimiter, TruckStatusToStr(FStatus)]));

    Add(Format('%s ', [nDelimiter]));
    Add(Format('交货单号:%s %s', [nDelimiter, FBill]));
    Add(Format('交货数量:%s %.3f 吨', [nDelimiter, FValue]));
    if FType = sFlag_Dai then nStr := '袋装' else nStr := '散装';

    Add(Format('品种类型:%s %s', [nDelimiter, nStr]));
    Add(Format('品种名称:%s %s', [nDelimiter, FStock]));
    
    Add(Format('%s ', [nDelimiter]));
    Add(Format('订单编号:%s %s', [nDelimiter, FOrder]));
    if FOrderTy = sFlag_XS then nStr := '销售' else nStr := '转储';

    Add(Format('订单类型:%s %s', [nDelimiter, nStr]));
    Add(Format('客户名称:%s %s', [nDelimiter, FCusName]));
  end;
end;

//Date: 2012-3-25
//Parm: 岗位;交货单列表
//Desc: 保存nPost岗位的交货单数据
function SaveLadingBills(const nPost: string; nData: TLadingTruckItems): Boolean;
var nIdx: Integer;
    nListA,nListB: TStrings;
    nIn: TWorkerBusinessCommand;
    nOut: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  Result := False;
  if Length(nData) < 1 then Exit;

  nListA := nil;
  nListB := nil;
  nWorker := nil;
  try
    nListA := TStringList.Create;
    nListB := TStringList.Create;

    for nIdx:=Low(nData) to High(nData) do
    with nData[nIdx],nListA do
    begin
      Values['Bill'] := FBill;
      Values['Stock'] := FStock;
      Values['Value'] := FloatToStr(FValue);
      nListB.Add(PackerEncodeStr(nListA.Text));
    end;

    with nListA do
    begin
      Clear; 
      Values['Post'] := nPost;
      Values['Card'] := nData[0].FCard;
      Values['Type'] := nData[0].FType;
      Values['Truck'] := nData[0].FTruck;
      Values['Bills'] := PackerEncodeStr(nListB.Text);
    end;

    nIn.FCommand := cBC_SavePostBills;
    nIn.FData := PackerEncodeStr(nListA.Text);
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessCommand);

    SetLength(nData, 0);
    Result := nWorker.WorkActive(@nIn, @nOut);
  finally
    nListA.Free;
    nListB.Free;
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//Date: 2012-4-22
//Parm: 磅站号
//Desc: 获取nPound磅的当前卡号
function ReadPoundCard(const nPound: string): string;
var nIn: TWorkerBusinessCommand;
    nOut: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  Result := '';
  nWorker := nil;
  try
    nIn.FCommand := cBC_GetPoundCard;
    nIn.FBase.FParam := sParam_NoHintOnError;
    nIn.FData := nPound;
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_HardwareMonitor);

    if nWorker.WorkActive(@nIn, @nOut) then
    begin
      Result := Trim(nOut.FData);
    end;
  finally
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//Date: 2012-7-8
//Desc: 监测SAP服务状态是否正常
function CheckSAPServiceStatus: Boolean;
var nIn,nOut: TBWDataBase;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FMsgNO := sFlag_NotMatter;
    nIn.FParam := sParam_NoHintOnError;

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_ServiceStatus);
    Result := nWorker.WorkActive(@nIn, @nOut);
  finally
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//Date: 2012-4-25
//Parm: 通道;车辆
//Desc: 读取车辆队列数据
function LoadTruckQueue(var nLines: TZTLineItems; var nTrucks: TZTTruckItems;
 const nRefreshLine: Boolean): Boolean;
var nIdx: Integer;
    nSLine,nSTruck: string;
    nListA,nListB: TStrings; 
    nIn: TWorkerBusinessCommand;
    nOut: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    if nRefreshLine then
         nIn.FData := sFlag_Yes
    else nIn.FData := sFlag_No;

    nIn.FCommand := cBC_GetQueueData;
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_HardwareMonitor);

    Result := nWorker.WorkActive(@nIn, @nOut);
    if not Result then Exit;

    nListA.Text := PackerDecodeStr(nOut.FData);
    nSLine := nListA.Values['Lines'];
    nSTruck := nListA.Values['Trucks'];

    nListA.Text := PackerDecodeStr(nSLine);
    SetLength(nLines, nListA.Count);

    for nIdx:=0 to nListA.Count - 1 do
    with nLines[nIdx],nListB do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      FID       := Values['ID'];
      FName     := Values['Name'];
      FStock    := Values['Stock'];
      FValid    := Values['Valid'] <> sFlag_No;

      if IsNumber(Values['Weight'], False) then
           FWeight := StrToInt(Values['Weight'])
      else FWeight := 1;
    end;

    nListA.Text := PackerDecodeStr(nSTruck);
    SetLength(nTrucks, nListA.Count);

    for nIdx:=0 to nListA.Count - 1 do
    with nTrucks[nIdx],nListB do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      FTruck    := Values['Truck'];
      FLine     := Values['Line'];
      FBill     := Values['Bill'];

      if IsNumber(Values['Value'], True) then
           FValue := StrToFloat(Values['Value'])
      else FValue := 0;

      FInFact   := Values['InFact'] = sFlag_Yes;
      FIsRun    := Values['IsRun'] = sFlag_Yes;
           
      if IsNumber(Values['Dai'], False) then
           FDai := StrToInt(Values['Dai'])
      else FDai := 0;

      if IsNumber(Values['Total'], False) then
           FTotal := StrToInt(Values['Total'])
      else FTotal := 0;
    end;
  finally
    nListA.Free;
    nListB.Free;
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//Date: 2012-4-27
//Parm: 车道;车牌
//Desc: 让nTruck从nLine出队
function MakeTruckOutQueue(const nLine,nTruck: string): Boolean;
var nList: TStrings;
    nIn: TWorkerBusinessCommand;
    nOut: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  nList := TStringList.Create;
  try
    nList.Values['Line'] := nLine;
    nList.Values['Truck'] := nTruck;

    nIn.FCommand := cBC_GetQueueData;
    nIn.FData := PackerEncodeStr(nList.Text);
    
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_HardwareMonitor);
    Result := nWorker.WorkActive(@nIn, @nOut);
  finally
    nList.Free;
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//Date: 2012-9-15
//Parm: 通道号;启停标识
//Desc: 启停nTunnel通道的喷码机
        procedure PrinterEnable(const nTunnel: string; const nEnable: Boolean);
var nList: TStrings;
    nIn: TWorkerBusinessCommand;
    nOut: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  nList := TStringList.Create;
  try
    nList.Values['Tunnel'] := nTunnel;
    if nEnable then
         nList.Values['Enable'] := sFlag_Yes
    else nList.Values['Enable'] := sFlag_No;

    nIn.FCommand := cBC_PrinterEnable;
    nIn.FData := PackerEncodeStr(nList.Text);
    
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_HardwareMonitor);
    nWorker.WorkActive(@nIn, @nOut);
  finally
    nList.Free;
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2012-4-1
//Parm: 交货单号;品种编号;是否询问
//Desc: 打印nBill交货单号
function PrintBillReport(const nBill,nStock: string; nAsk: Boolean): Boolean;
var nStr,nTmp: string;
    nP,nM: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印交货单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  if nStock <> '' then
  begin
    nStr := 'Select Count(*) From %s Where D_Name=''%s'' And D_Value=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_PrintBill, nStock]);

    with FDM.QueryTemp(nStr) do
     if Fields[0].AsInteger < 1 then Exit;
    //not need print
  end;

  nStr := 'Select * From %s b ' +
          ' Left Join %s xs On xs.BillID=b.L_ID ' +
          ' Left Join %s zc On zc.BillID=b.L_ID ' +
          'Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, sTable_OrderXS, sTable_OrderZC, nBill]);

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '交货单[ %s ] 已无效!!';
    nStr := Format(nStr, [nBill]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'LadingBill.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nP := '0.000';
  nM := '0.000';
  nStr := FDM.SqlTemp.FieldByName('L_Type').AsString;
  nTmp := FDM.SqlTemp.FieldByName('L_TruckID').AsString;

  if (nTmp <> '') and (nStr = sFlag_San) then
  begin
    nStr := 'Select T_BFPValue,T_BFMValue From %s Where T_ID=''%s''';
    nStr := Format(nStr, [sTable_TruckLog, nTmp]);

    with FDM.QuerySQL(nStr) do
    if RecordCount > 0 then
    begin
      nP := Format('%.3f', [Fields[0].AsFloat]);
      nM := Format('%.3f', [Fields[1].AsFloat]);
    end;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  nParam.FName := 'CHWeight';
  nParam.FValue := Num2CNum(FDM.SqlTemp.FieldByName('L_Value').AsFloat);
  FDR.AddParamItem(nParam);

  nParam.FName := 'PValue';
  nParam.FValue := nP;
  FDR.AddParamItem(nParam);

  nParam.FName := 'MValue';
  nParam.FValue := nM;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Date: 2012-4-15
//Parm: 过磅单号;是否询问
//Desc: 打印nPound过磅记录
function PrintPoundReport(const nPound: string; nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印过磅单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_PoundLog, nPound]);

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '称重记录[ %s ] 已无效!!';
    nStr := Format(nStr, [nPound]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'Pound.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;

  if Result  then
  begin
    nStr := 'Update %s Set P_PrintNum=P_PrintNum+1 Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_PoundLog, nPound]);
    FDM.ExecuteSQL(nStr, gSysParam.FNetBusMIT);
  end;
end;

end.


