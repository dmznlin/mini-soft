{*******************************************************************************
  作者: dmzn@163.com 2008-8-8
  描述: 用户登录窗口
*******************************************************************************}
unit UFormLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TfFormLogin = class(TForm)
    Image1: TImage;
    GroupBox1: TGroupBox;
    Edit_User: TLabeledEdit;
    Edit_Pwd: TLabeledEdit;
    LabelCopy: TLabel;
    BtnExit: TSpeedButton;
    BtnSet: TSpeedButton;
    BtnLogin: TButton;
    procedure BtnSetClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnLoginClick(Sender: TObject);
    procedure Edit_UserKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowLoginForm: Boolean;
//入口函数

implementation

{$R *.dfm}
uses
  USysConst, USysFun, USysPopedom, USysMenu, UDataModule, ULibFun, UMgrPopedom,
  UFormWait, UFormConn;

ResourceString
  sConnDBError = '连接数据库失败,配置错误或远程无响应';

//------------------------------------------------------------------------------
//Desc: 用户登录
function ShowLoginForm: Boolean;
var nStr: string;
begin
  with TfFormLogin.Create(Application) do
  begin
    Caption := '权限 - 登录';
    Edit_User.Text := gSysParam.FUserName;

    nStr := gPath + sLogoFile;
    if FileExists(nStr) then
      Image1.Picture.LoadFromFile(nStr);
    //logo

    if gSysParam.FCopyRight <> '' then
      LabelCopy.Caption := gSysParam.FCopyRight;
    //copyright
    
    Result := ShowModal = mrOk;
    Free
  end;
end;

//------------------------------------------------------------------------------
//Desc: 连接测试回调
function TestConn(const nConnStr: string): Boolean;
begin
  FDM.ADOConn.Close;
  FDM.ADOConn.ConnectionString := nConnStr;
  FDM.ADOConn.Open;
  Result := FDM.ADOConn.Connected;
end;

//Desc: 设置
procedure TfFormLogin.BtnSetClick(Sender: TObject);
begin
  ShowConnectDBSetupForm(TestConn);
end;

//Desc: 退出
procedure TfFormLogin.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 登录
procedure TfFormLogin.BtnLoginClick(Sender: TObject);
var nStr: string;
    nMsg: string;
begin
  Edit_User.Text := Trim(Edit_User.Text);
  Edit_Pwd.Text := Trim(Edit_Pwd.Text);

  if (Edit_User.Text = '') or (Edit_Pwd.Text = '') then
  begin
    ShowMsg('请输入用户名和密码', sHint); Exit;
  end;

  nStr := BuildConnectDBStr;
  
  while nStr = '' do
  begin
    ShowMsg('请输入正确的"数据库"配置参数', sHint);
    if ShowConnectDBSetupForm(TestConn) then
         nStr := BuildConnectDBStr
    else Exit;
  end;

  nMsg := '';
  ShowWaitForm(Self, '连接数据库');
  try
    try
      FDM.ADOConn.Connected := False;
      FDM.ADOConn.ConnectionString := nStr;
      FDM.ADOConn.Connected := True;

      if not gPopedomManager.CreateUserTable then
       raise Exception.Create('');
    except
      ShowDlg(sConnDBError, sWarn, Handle); Exit;
    end;

    nStr := 'Select U_NAME from $a Where U_NAME=''$b'' and ' +
            'U_PASSWORD=''$c'' and U_Identity=$d and U_State=$e';
    nStr := MacroValue(nStr, [MI('$a', gSysParam.FTableUser),
                              MI('$b', Edit_User.Text),
                              MI('$c', Edit_Pwd.Text),
                              MI('$d', IntToStr(cPopedomUser_Admin)),
                              MI('$e', IntToStr(cPopedomUser_Normal))]);

    FDM.SqlQuery.Close;
    FDM.SqlQuery.SQL.Text := nStr;
    FDM.SqlQuery.Open;

    if FDM.SqlQuery.RecordCount <> 1 then
    begin
      Edit_User.SetFocus;
      nMsg := '错误的用户名或密码,请重新输入'; Exit;
    end;

    gSysParam.FUserID := Edit_User.Text;
    gSysParam.FUserName := FDM.SqlQuery.Fields[0].AsString;
    gSysParam.FUserPwd := Edit_Pwd.Text;

    gPopedomManager.CreateGroupTable;
    gPopedomManager.CreatePopedomTable;
    gPopedomManager.CreatePopItemTable;

    gMenuManager.CreateMenuTable;
    ModalResult := mrOk;
  finally
    CloseWaitForm;
    if nMsg <> '' then ShowDlg(nMsg, sHint);
  end;
end;

procedure TfFormLogin.Edit_UserKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN, VK_DOWN: SwitchFocusCtrl(Self, True);
    VK_UP: SwitchFocusCtrl(Self, False);
  end;
end;

end.
