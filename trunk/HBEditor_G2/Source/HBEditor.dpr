program HBEditor;

uses
  Forms,
  UFormMain in 'Forms\UFormMain.pas' {fFormMain},
  UFrameSummary in 'Forms\UFrameSummary.pas' {fFrameSummary: TFrame},
  UFrameText in 'Forms\UFrameText.pas' {fFrameText: TFrame},
  UFramePicture in 'Forms\UFramePicture.pas' {fFramePicture: TFrame},
  UFrameBase in 'Forms\UFrameBase.pas' {fFrameBase: TFrame},
  UFrameTime in 'Forms\UFrameTime.pas' {fFrameTime: TFrame},
  UFormTextEditor in 'Forms\UFormTextEditor.pas' {fFormTextEditor},
  UFormScreen in 'Forms\UFormScreen.pas' {fFormScreen},
  UFormConnTest in 'Forms\UFormConnTest.pas' {fFormConnTest},
  UDataModule in 'Forms\UDataModule.pas' {FDM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFDM, FDM);
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.
