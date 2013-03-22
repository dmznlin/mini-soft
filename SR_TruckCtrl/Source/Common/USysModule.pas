{*******************************************************************************
  作者: dmzn@163.com 2009-6-25
  描述: 单元模块

  备注: 由于模块有自注册能力,只要Uses一下即可.
*******************************************************************************}
unit USysModule;

{$I Link.Inc}
interface

uses
  Windows, Forms, SysUtils, USysConst,
  //System Object
  UMgrDBConn, USysLoger, USysShareMem, UMgrConnection, 
  //System frame Module
  UFrameRealTime, UFrameRunMon, UFrameReport, UFrameRunLog, UFrameConfig,
  UFrameSetSystem, UFrameSetDevice, UFrameSetPort, UFrameHistogram,
  //System form Module
  UFormSetDB, UFormCOMPort, UFormDevice, UFormSetIndex, UFormPressMax,
  UFormSysParam, UFormChartStyle;

procedure InitSystemObject;
procedure RunSystemObject(const nFormHandle: THandle);
procedure FreeSystemObject;

implementation

//Desc: 初始化系统对象
procedure InitSystemObject;
begin
  gSysLoger := TSysLoger.Create(gPath + sLogDir, 'SR_TruckCtrl_Loger');
  //system loger

  //gDBConnManager := TDBConnManager.Create;
  gDBConnManager.MaxConn := 10; 
  //db conn pool

  {$IFNDEF DEBUG}
  gProcessMonitorClient := TProcessMonitorClient.Create(gSysParam.FProgID);
  //process monitor
  {$ENDIF}
end;

//Desc: 运行系统对象
procedure RunSystemObject(const nFormHandle: THandle);
var nStr: string;
begin
  {$IFNDEF DEBUG}
  if Assigned(gProcessMonitorClient) then
  begin
    gProcessMonitorClient.UpdateHandle(nFormHandle, GetCurrentProcessId, nStr);
    gProcessMonitorClient.StartMonitor(nStr, FMonInterval);
  end;
  {$ENDIF}
end;

//Desc: 释放系统对象
procedure FreeSystemObject;
begin
  gPortManager.StopReader;
  //stop port
  
  if Assigned(gProcessMonitorSapMITClient) then
  begin
    gProcessMonitorSapMITClient.StopMonitor(Application.Active);
    FreeAndNil(gProcessMonitorSapMITClient);
  end; //stop monitor
end;

end.
