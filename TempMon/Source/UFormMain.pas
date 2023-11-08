{*******************************************************************************
  作者: dmzn@163.com 2023-11-06
  描述: 主单元
*******************************************************************************}
unit UFormMain;

interface

uses
  Winapi.Windows, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ComCtrls,Vcl.Samples.Spin, Vcl.Menus;

type
  TfFormMain = class(TForm)
    SBar1: TStatusBar;
    Timer1: TTimer;
    HintPanel: TPanel;
    Image1: TImage;
    Image2: TImage;
    HintLabel: TLabel;
    wPage1: TPageControl;
    Sheet1: TTabSheet;
    Sheet2: TTabSheet;
    Panel1: TPanel;
    CheckSrv: TCheckBox;
    CheckShowLog: TCheckBox;
    MemoLog: TMemo;
    Group1: TGroupBox;
    CheckRun: TCheckBox;
    CheckMin: TCheckBox;
    EditPwd: TLabeledEdit;
    GroupBox1: TGroupBox;
    EditURI: TLabeledEdit;
    EditCType: TLabeledEdit;
    EditAID: TLabeledEdit;
    EditAKey: TLabeledEdit;
    EditRate: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Tray1: TTrayIcon;
    PMenu1: TPopupMenu;
    MenuAbout: TMenuItem;
    N1: TMenuItem;
    MenuExit: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckRunClick(Sender: TObject);
    procedure EditAKeyExit(Sender: TObject);
    procedure EditRateChange(Sender: TObject);
    procedure wPage1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure CheckShowLogClick(Sender: TObject);
    procedure CheckSrvClick(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure Tray1Click(Sender: TObject);
  private
    { Private declarations }
    FCanExit: Boolean;
    {*可退出*}
    procedure SystemConfig(const nLoad: Boolean);
    procedure ShowLog(const nStr: string);
    //显示日志
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  System.IniFiles, System.Win.Registry, Winapi.ShellAPI, UFormInputbox,
  ULibFun, UManagerGroup, USysConst, UQingTian;

var
  gDataSyncer: TDataSync = nil;
  //同步线程

procedure WriteLog(const nEvent: string);
begin
  gMG.FLogManager.AddLog(TfFormMain, 'TempMonitor', nEvent);
end;

procedure ActionSync(const nStart: Boolean);
begin
  if nStart then
  begin
    if not Assigned(gDataSyncer) then
      gDataSyncer := TDataSync.Create;
    //xxxxx
  end else

  if Assigned(gDataSyncer) then
  begin
    gDataSyncer.StopMe;
    gDataSyncer := nil;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormMain.FormCreate(Sender: TObject);
begin
  gMG.FLogManager.SyncMainUI := True;
  gMG.FLogManager.SyncSimple := ShowLog;
  gMG.FLogManager.StartService();

  FCanExit := False;
  wPage1.ActivePage := Sheet1;
  SystemConfig(True);
  TApplicationHelper.LoadFormConfig(Self);
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not FCanExit then
  begin
    Visible := False;
    Action := caNone;
    Exit;
  end;

  ActionSync(False);
  SystemConfig(False);
  TApplicationHelper.SaveFormConfig(Self);
end;

procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  with TDateTimeHelper do
    SBar1.SimpleText := '※.' + DateTime2Str(Now()) + ' ' + Date2Week();
  //xxxxx
end;

procedure TfFormMain.Tray1Click(Sender: TObject);
begin
  if not Visible then
    Visible := True;
  //xxxxx
end;

procedure TfFormMain.MenuAboutClick(Sender: TObject);
begin
  ShellAbout(Handle, PWideChar(Caption), PWideChar(HintLabel.Caption),
    Application.Icon.Handle);
  //xxxxx
end;

procedure TfFormMain.MenuExitClick(Sender: TObject);
begin
  FCanExit := True;
  Close;
end;

//Date: 2018-01-11
//Parm: 读写
//Desc: 处理配置信息
procedure TfFormMain.SystemConfig(const nLoad: Boolean);
const
  sStartKey = 'TempMon';
var
  nStr: string;
  nIni: TIniFile;
  nReg: TRegistry;
begin
  nIni := nil;
  nReg := nil;
  try
    nIni := TIniFile.Create(TApplicationHelper.gSysConfig);
    //new obj

    if nLoad then
    with nIni do
    begin
      FillChar(gSystemParam, SizeOf(TParamConfig), #0);
      //init first

      gSystemParam.FAutoHide := ReadBool('Config', 'MinAfterRun', False);
      gSystemParam.FServerURI := ReadString('Config', 'ServerURI', '');
      gSystemParam.FContentType := ReadString('Config', 'ContentType', '');
      gSystemParam.FAppID := ReadString('Config', 'AppID', '');
      gSystemParam.FAppKey := ReadString('Config', 'AppKey', '');
      gSystemParam.FFreshRate := ReadInteger('Config', 'FreshRate', 60);

      nStr := ReadString('Config', 'Password', '');
      if nStr <> '' then
        gSystemParam.FAdminPwd := TEncodeHelper.DecodeBase64(nStr);
      //xxxxx

      nReg := TRegistry.Create;
      nReg.RootKey := HKEY_CURRENT_USER;

      nReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
      gSystemParam.FAutoRun := nReg.ValueExists(sStartKey);

      CheckRun.Checked := gSystemParam.FAutoRun;
      CheckMin.Checked := gSystemParam.FAutoHide;
      EditRate.Value := gSystemParam.FFreshRate;
      EditPwd.Text := gSystemParam.FAdminPwd;
      EditURI.Text := gSystemParam.FServerURI;
      EditCType.Text := gSystemParam.FContentType;
      EditAID.Text := gSystemParam.FAppID;
      EditAKey.Text := gSystemParam.FAppKey;
    end else

    if gSystemParam.FChanged then
    begin
      nStr := TEncodeHelper.EncodeBase64(gSystemParam.FAdminPwd);
      nIni.WriteString('Config', 'Password', nStr);
      nIni.WriteString('Config', 'ServerURI', gSystemParam.FServerURI);
      nIni.WriteString('Config', 'ContentType', gSystemParam.FContentType);
      nIni.WriteString('Config', 'AppID', gSystemParam.FAppID);
      nIni.WriteString('Config', 'AppKey', gSystemParam.FAppKey);
      nIni.WriteBool('Config', 'MinAfterRun', gSystemParam.FAutoHide);
      nIni.WriteInteger('Config', 'FreshRate', gSystemParam.FFreshRate);

      nReg := TRegistry.Create;
      nReg.RootKey := HKEY_CURRENT_USER;
      nReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);

      if gSystemParam.FAutoRun then
      begin
        nReg.WriteString(sStartKey, Application.ExeName);
      end else
      if nReg.ValueExists(sStartKey) then
        nReg.DeleteValue(sStartKey);
      //xxxxx
    end;

    gSystemParam.FChanged := False;
    //flag
  finally
    nIni.Free;
    nReg.Free;
  end;
end;

//Desc: 显示日志
procedure TfFormMain.ShowLog(const nStr: string);
var
  nIdx: Integer;
begin
  MemoLog.Lines.BeginUpdate;
  try
    MemoLog.Lines.Insert(0, nStr);
    if MemoLog.Lines.Count > 100 then
      for nIdx := MemoLog.Lines.Count - 1 downto 50 do
        MemoLog.Lines.Delete(nIdx);
  finally
    MemoLog.Lines.EndUpdate;
  end;
end;

procedure TfFormMain.CheckShowLogClick(Sender: TObject);
begin
  gMG.FLogManager.SyncMainUI := CheckShowLog.Checked;
end;

procedure TfFormMain.CheckSrvClick(Sender: TObject);
begin
  ActionSync(CheckSrv.Checked);
end;

procedure TfFormMain.CheckRunClick(Sender: TObject);
begin
  gSystemParam.FAutoRun := CheckRun.Checked;
  gSystemParam.FAutoHide := CheckMin.Checked;
  gSystemParam.FChanged := True;
end;

procedure TfFormMain.EditAKeyExit(Sender: TObject);
var nStr: string;
begin
  nStr := Trim(TLabeledEdit(Sender).Text);
  if (Sender = EditPwd) and (nStr <> gSystemParam.FAdminPwd) then
  begin
    gSystemParam.FAdminPwd := nStr;
    gSystemParam.FChanged := True;
  end else

  if (Sender = EditURI) and (nStr <> gSystemParam.FServerURI) then
  begin
    if TStringHelper.CopyRight(nStr, 1) = '/' then
      nStr := TStringHelper.CopyNoRight(nStr, 1);
    //xxxxx

    gSystemParam.FServerURI := nStr;
    gSystemParam.FChanged := True;
  end else

  if (Sender = EditCType) and (nStr <> gSystemParam.FContentType) then
  begin
    gSystemParam.FContentType := nStr;
    gSystemParam.FChanged := True;
  end else

  if (Sender = EditAID) and (nStr <> gSystemParam.FAppID) then
  begin
    gSystemParam.FAppID := nStr;
    gSystemParam.FChanged := True;
  end else

  if (Sender = EditAKey) and (nStr <> gSystemParam.FAppKey) then
  begin
    gSystemParam.FAppKey := nStr;
    gSystemParam.FChanged := True;
  end;
end;

procedure TfFormMain.EditRateChange(Sender: TObject);
begin
  if EditRate.Focused then
  begin
    gSystemParam.FFreshRate := EditRate.Value;
    gSystemParam.FChanged := True;
  end;
end;

procedure TfFormMain.wPage1Changing(Sender: TObject; var AllowChange: Boolean);
var nStr: string;
begin
  if (wPage1.ActivePage = Sheet1) and (gSystemParam.FAdminPwd <> '') then
  begin
    ShowInputPWDBox('请输入密码:', '管理员', nStr);
    AllowChange := nStr = gSystemParam.FAdminPwd;
  end;
end;

end.

