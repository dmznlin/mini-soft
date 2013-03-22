program TruckCtrl;

uses
  FastMM4,
  Forms,
  UDataModule in 'Forms\UDataModule.pas' {FDM: TDataModule},
  UFormMain in 'Forms\UFormMain.pas' {fFormMain},
  UFrameBase in '..\..\..\..\Program Files\MyVCL\znlib\LibForm\UFrameBase.pas' {fFrameBase: TFrame},
  UFormBase in 'Forms\UFormBase.pas' {BaseForm},
  UFormNormal in 'Forms\UFormNormal.pas' {fFormNormal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFDM, FDM);
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.
