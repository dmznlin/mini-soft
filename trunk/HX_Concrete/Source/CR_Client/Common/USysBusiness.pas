{*******************************************************************************
  作者: dmzn@163.com 2007-10-09
  描述: 系统业务逻辑单元
*******************************************************************************}
unit USysBusiness;

interface

uses
  Windows, Controls, Classes, SysUtils, UBusinessWorker, UBusinessConst,
  UBusinessPacker, UFormBase, ULibFun, USysConst;

function GetTruckCard: string;
//桌面读卡
function SetTruckCard(const nTruck: string): Boolean;
function SaveTruckCard(const nTruck,nCard: string): Boolean;
//车辆绑定磁卡
function LogoutBillCard(const nCard: string): Boolean;
//注销指定卡

function MakeTruckIn(const nCard: string): Boolean;
//车辆进站
function MakeTruckOut(const nCard: string): Boolean;
//车辆出站
function MakeTruckResponse(const nCard: string): Boolean;
//车辆应答

implementation

//Date: 2013-07-08
//Parm: 车牌号;磁卡号
//Desc: 为nTruck绑定磁卡nCard
function SaveTruckCard(const nTruck,nCard: string): Boolean;
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
      Values['Card'] := nCard;
      Values['Truck'] := nTruck;
    end;

    nIn.FCommand := cBC_SaveTruckCard;
    nIn.FData := PackerEncodeStr(nList.Text);

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessCommand);
    Result := nWorker.WorkActive(@nIn, @nOut);
  finally
    nList.Free;
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//Date: 2013-7-8
//Parm: 磁卡号;交货单
//Desc: 注销指定磁卡号
function LogoutBillCard(const nCard: string): Boolean;
var nIn: TWorkerBusinessCommand;
    nOut: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := cBC_LogoutBillCard;
    nIn.FData := nCard;

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessCommand);
    Result := nWorker.WorkActive(@nIn, @nOut);
  finally
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//Date: 2013-07-10
//Parm: 车牌号
//Desc: 为nTruck绑定磁卡
function SetTruckCard(const nTruck: string): Boolean;
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_AddData;
  nP.FParamA := nTruck;
  nP.FParamB := '车辆关联磁卡:';

  CreateBaseFormItem(cFI_FormMakeCard, '', @nP);
  Result := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;

//Date: 2013-07-10
//Desc: 弹窗,桌面读卡
function GetTruckCard: string;
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_AddData;
  nP.FParamA := '业务';
  nP.FParamB := '请刷磁卡:';

  CreateBaseFormItem(cFI_FormMakeCard, '', @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
       Result := nP.FParamB
  else Result := '';
end;

//------------------------------------------------------------------------------
//Date: 2013-07-10
//Desc: 车辆进站
function MakeTruckIn(const nCard: string): Boolean;
begin

end;

//Date: 2013-07-10
//Desc: 车辆出站
function MakeTruckOut(const nCard: string): Boolean;
begin

end;

//Date: 2013-07-10
//Desc: 车辆现场刷卡应答
function MakeTruckResponse(const nCard: string): Boolean;
begin

end;

end.


