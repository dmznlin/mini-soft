program Bus_MIT;

{$I link.inc}
uses
  FastMM4,
  Forms,
  UFormMain in 'UFormMain.pas' {fFormMain},
  UFrameSummary in 'UFrameSummary.pas' {fFrameSummary: TFrame},
  UFrameRunLog in 'UFrameRunLog.pas' {fFrameRunLog: TFrame},
  UFrameParam in 'UFrameParam.pas' {fFrameParam: TFrame},
  UParamManager in 'UParamManager.pas',
  UROModule in 'UROModule.pas' {ROModule: TDataModule},
  UFrameBase in 'UFrameBase.pas' {fFrameBase: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TROModule, ROModule);
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.
