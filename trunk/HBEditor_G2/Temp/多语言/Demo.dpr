program Demo;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UMgrLang in '..\..\..\..\Program Files\MyVCL\ZnLib\LibFun\UMgrLang.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
