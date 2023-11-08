program TempMon;

uses
  FastMM4,
  Vcl.Forms,
  UFormMain in 'UFormMain.pas' {fFormMain},
  UQingTian in 'UQingTian.pas',
  USysConst in 'USysConst.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.
