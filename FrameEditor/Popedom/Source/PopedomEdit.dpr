program PopedomEdit;

uses
  Forms,
  UFormMain in 'Forms\UFormMain.pas' {fFormMain},
  UDataModule in 'Forms\UDataModule.pas' {FDM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFDM, FDM);
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.
