program YX_Guard;

uses
  FastMM4,
  Forms,
  UFormMain in 'UFormMain.pas' {fFormMain},
  USysConst in 'USysConst.pas',
  UFormProgress in 'UFormProgress.pas' {fFormProgress},
  UFormPeiBi in 'UFormPeiBi.pas' {fFormPeiBi};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.
