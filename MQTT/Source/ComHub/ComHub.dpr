program ComHub;

uses
  Vcl.Forms,
  UFormMain in 'UFormMain.pas' {fFormMain},
  Vcl.Themes,
  Vcl.Styles,
  USysConst in 'USysConst.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.
