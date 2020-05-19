program WXPic;

uses
  Vcl.Forms,
  UFormMain in 'UFormMain.pas' {fFormMain},
  UWXFun in 'UWXFun.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.
