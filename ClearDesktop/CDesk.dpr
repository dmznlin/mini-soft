program CDesk;

uses
  JclAppInst,
  Forms,
  UFormMain in 'UFormMain.pas' {fFormMain};

{$R *.res}

begin
  JclAppInstances.CheckSingleInstance;
  Application.Initialize;
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.
