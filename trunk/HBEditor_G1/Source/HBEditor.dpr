program HBEditor;

uses
  Forms,
  UFormMain in 'UFormMain.pas' {fFormMain},
  UDataModule in 'UDataModule.pas' {FDM: TDataModule},
  USysConst in 'USysConst.pas',
  UEditControl in 'UEditControl.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFDM, FDM);
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.
