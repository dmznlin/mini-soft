{*******************************************************************************
  作者: dmzn@163.com 2013-10-25
  描述: 亚星商砼数据校正
*******************************************************************************}
unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtCtrls, dxGDIPlusClasses, Menus, ImgList;

type
  TfFormMain = class(TForm)
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Panel1: TPanel;
    Image1: TImage;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    procedure N4Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
    FCanMove: Boolean;
    FOldPos: TPoint;
    //原有坐标
    FCanClose: Boolean;
    //可以关闭
    FBackupID,FRestoreID: Integer;
    //全局标识
  protected
    procedure WMHotkey(var nMsg: TWMHOTKEY);message WM_HOTKEY;
    //快捷键
    procedure CreateParams(var Params: TCreateParams); override;
    procedure LoadImage(const nIdx: Integer);
    //载入图标
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses
  Inifiles, ULibFun, USysLoger, UFormPeiBi, USysConst;

procedure TfFormMain.FormCreate(Sender: TObject);
begin
  FBackupID := GlobalAddAtom('YX_Guard_Backup');
  FRestoreID := GlobalAddAtom('YX_Guard_Restore');

  gPath := ExtractFilePath(Application.ExeName);
  InitGlobalVariant(gPath, gPath + sConfigFile, gPath + sConfigFile);
  gSysLoger := TSysLoger.Create(gPath + sLogDir);

  ConfigDBConnection;
  ParepareDBWork(False);
end;

procedure TfFormMain.FormShow(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sConfigFile);
  try
    LoadFormConfig(Self, nIni);
    ClientWidth := ClientHeight;
    ShowWindow(Application.Handle,SW_HIDE);

    if IsSystemNormal(nIni) then
         LoadImage(0)
    else LoadImage(1);

    nStr := nIni.ReadString('System', 'ShortKey1', 'A');
    RegisterHotKey(Handle, FBackupID, MOD_CONTROL or MOD_Alt, Ord(nStr[1]));

    nStr := nIni.ReadString('System', 'ShortKey2', 'R');
    RegisterHotKey(Handle, FRestoreID, MOD_CONTROL or MOD_Alt, Ord(nStr[1]));
  finally
    nIni.Free;
  end;
end;

procedure TfFormMain.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := WS_POPUP or WS_CLIPSIBLINGS or WS_DLGFRAME;
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
  end;
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not FCanClose then
  begin
    Action := caNone;
    Exit;
  end;

  SaveFormConfig(Self);
  UnRegisterHotKey(Handle, FBackupID);
  GlobalDeleteAtom(FBackupID);

  UnregisterHotKey(Handle, FRestoreID);
  GlobalDeleteAtom(FRestoreID);
end;

//------------------------------------------------------------------------------
procedure TfFormMain.N4Click(Sender: TObject);
begin
  if QueryDlg('确定要退出系统吗?', sAsk) then
  begin
    FCanClose := True;
    Close;
  end;
end;

//Desc: 增量备份
procedure TfFormMain.N6Click(Sender: TObject);
begin
  ParepareDBWork(False);
end;

//Desc: 全部备份
procedure TfFormMain.N7Click(Sender: TObject);
begin
  if QueryDlg('确定要重新备份吗?该操作会花费较长时间.', sAsk) then
    ParepareDBWork(True);
  //xxxxx
end;

procedure TfFormMain.N3Click(Sender: TObject);
begin
  if GetKeyState( VK_CONTROL ) and $8000 <> 0 then
    ShowPeiBiForm;
  //xxxxx
end;

//------------------------------------------------------------------------------
procedure TfFormMain.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    FCanMove := True;
    FOldPos := Point(X, Y);
  end;
end;

procedure TfFormMain.Image1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if FCanMove then
  begin
    Left := Left - (FOldPos.X - X);
    Top := Top - (FOldPos.Y - Y);
  end;
end;

procedure TfFormMain.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FCanMove := False;
end;

//------------------------------------------------------------------------------
//Desc: 载入索引为nIdx的图像
procedure TfFormMain.LoadImage(const nIdx: Integer);
var nStr: string;
begin
  nStr := gPath + Format('%d.png', [nIdx]);
  if FileExists(nStr) then
    Image1.Picture.LoadFromFile(nStr);
  //xxxxx

  case nIdx of
   0: Self.Color := clTeal;
   1: Self.Color := clRed;
  end;

  N3.Enabled := nIdx = 0;
  N6.Enabled := nIdx = 0;
end;

procedure TfFormMain.WMHotkey(var nMsg: TWMHOTKEY);
begin
  try
    if nMsg.HotKey = FBackupID then
    begin
      BackupSystemData;
    end;

    if nMsg.HotKey = FRestoreID then
    begin
      RestoreSystemData;
    end;
  finally
    if IsSystemNormal then
         LoadImage(0)
    else LoadImage(1);
  end;
end;

end.
