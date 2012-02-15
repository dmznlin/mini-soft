program Demo;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UMgrCOMM in '..\..\..\..\Program Files\MyVCL\ZnLib\LibFun\UMgrCOMM.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
