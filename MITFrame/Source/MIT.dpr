program MIT;

uses
  FastMM4,
  Windows,
  Forms,
  ULibFun,
  UMITConst,
  UROModule in 'Forms\UROModule.pas' {ROModule: TDataModule},
  UDataModule in 'Forms\UDataModule.pas' {FDM: TDataModule},
  UFormMain in 'Forms\UFormMain.pas' {fFormMain},
  UFrameBase in 'Forms\UFrameBase.pas' {fFrameBase: TFrame},
  UFrameSummary in 'Forms\UFrameSummary.pas' {fFrameSummary: TFrame},
  UFrameRunLog in 'Forms\UFrameRunLog.pas' {fFrameRunLog: TFrame},
  UFrameConfig in 'Forms\UFrameConfig.pas' {fFrameConfig: TFrame},
  UFrameParam in 'Forms\UFrameParam.pas' {fFrameParam: TFrame};

{$R *.res}

begin
  InitSystemEnvironment;
  //初始化运行环境
  ActionSysParameter(True);
  //载入系统配置信息
  
  if not IsValidConfigFile(gPath + sConfigFile, gSysParam.FProgID) then
  begin
    ShowDlg(sInvalidConfig, sHint, GetDesktopWindow); Exit;
  end; //配置文件被改动

  Application.Initialize;
  Application.CreateForm(TFDM, FDM);
  Application.CreateForm(TROModule, ROModule);
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.
