{*******************************************************************************
  作者: dmzn@163.com 2009-6-25
  描述: 单元模块

  备注: 由于模块有自注册能力,只要Uses一下即可.
*******************************************************************************}
unit USysModule;

{$I Link.Inc}
interface

uses
  //System Object
  UHardWorker, UMITPacker, UMgrChannel, UMgrDBConn, UMgrQueue,
  UMgrLEDCard, UMgrHardHelper, U02NReader, UMgrRemoteVoice;

procedure InitSystemObject;
procedure RunSystemObject(const nFormHandle: THandle);
procedure FreeSystemObject;

implementation

uses
  Windows, Forms, SysUtils, USysLoger, UMITConst, USysShareMem, UParamManager;

//Desc: 初始化系统对象
procedure InitSystemObject;
begin
  gSysLoger := TSysLoger.Create(gPath + sLogDir, 'Hard_Mon_Loger');
  //system loger

  //gDBConnManager := TDBConnManager.Create;
  //db conn pool

  gParamManager := TParamManager.Create(gPath + sConfigFile);
  if gSysParam.FProgID <> '' then
    gParamManager.GetParamPack(gSysParam.FProgID, True);
  //runtime parameter

  gProcessMonitorClient := TProcessMonitorClient.Create(gSysParam.FProgID);
  //process monitor

  gHardwareHelper := THardwareHelper.Create;
  //远距读头
end;

//Desc: 运行系统对象
procedure RunSystemObject(const nFormHandle: THandle);
var nStr: string;
begin
  try
    nStr := 'LED';
    gCardManager.TempDir := gPath + 'Temp\';
    gCardManager.FileName := gPath + 'LED.xml';

    nStr := '远距读头';
    gHardwareHelper.LoadConfig(gPath + '900MK.xml');

    nStr := '近距读头';
    g02NReader.LoadConfig(gPath + 'Readers.xml');

    nStr := '语音服务';
    gVoiceHelper.LoadConfig(gPath + 'Voice.xml');
  except
    on E:Exception do
    begin
      nStr := Format('加载[ %s ]配置文件失败: %s', [nStr, E.Message]);
      gSysLoger.AddLog(nStr);
    end;
  end;
end;

//Desc: 释放系统对象
procedure FreeSystemObject;
begin
  FreeAndNil(gHardShareData);
  //hard monitor
  
  if Assigned(gProcessMonitorClient) then
  begin
    gProcessMonitorClient.StopMonitor(Application.Active);
    FreeAndNil(gProcessMonitorClient);
  end; //stop monitor
end;

end.
