program DictBuild;

uses
  Forms,
  UFormMain in 'Forms\UFormMain.pas' {fFormMain},
  UDataModule in 'Forms\UDataModule.pas' {FDM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfFormMain, fFormMain);
  Application.CreateForm(TFDM, FDM);
  Application.Run;
end.
