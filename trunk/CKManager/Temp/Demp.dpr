program Demp;

uses
  FastMM4,
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  USysLookupAdapter in '..\Source\Common\USysLookupAdapter.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
