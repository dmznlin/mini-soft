program MenuEdit;

uses
  Forms,
  Menu_AddEntity in 'Forms\Menu_AddEntity.pas' {FrmEntity},
  Menu_AddNew in 'Forms\Menu_AddNew.pas' {FrmNew},
  Menu_Const in 'Forms\Menu_Const.pas',
  Menu_Demo in 'Forms\Menu_Demo.pas' {FrmDemo},
  Menu_DM in 'Forms\Menu_DM.pas' {FDM: TDataModule},
  Menu_Main in 'Forms\Menu_Main.pas' {FrmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFDM, FDM);
  Application.Run;
end.
