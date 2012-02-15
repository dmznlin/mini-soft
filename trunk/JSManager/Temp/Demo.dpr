program Demo;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UMultiJSCtrl in '..\Source\Common\UMultiJSCtrl.pas',
  UMultiJS in '..\Source\Common\UMultiJS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
