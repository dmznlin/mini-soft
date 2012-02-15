program Demo;

uses
  Forms,
  UFromMain in 'UFromMain.pas' {fDemoFormMain},
  UDataModule in 'UDataModule.pas' {FDM: TDataModule},
  USysDataDict in 'USysDataDict.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfDemoFormMain, fDemoFormMain);
  Application.CreateForm(TFDM, FDM);
  Application.Run;
end.
