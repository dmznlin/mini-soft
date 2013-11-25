program MIT;

uses
  FastMM4,
  Forms,
  UROModule in 'Forms\UROModule.pas' {ROModule: TDataModule},
  UDataModule in 'Forms\UDataModule.pas' {FDM: TDataModule},
  UFormMain in 'Forms\UFormMain.pas' {fFormMain},
  UFrameBase in 'Forms\UFrameBase.pas' {fFrameBase: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFDM, FDM);
  Application.CreateForm(TROModule, ROModule);
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.
