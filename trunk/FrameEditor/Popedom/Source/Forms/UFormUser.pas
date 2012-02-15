{*******************************************************************************
  作者: dmzn@ylsoft.com 2008-01-02
  描述: 管理用户信息
*******************************************************************************}
unit UFormUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfFormUser = class(TForm)
    Edit_Name: TLabeledEdit;
    Edit_Pwd: TLabeledEdit;
    Edit_Phone: TLabeledEdit;
    Edit_Mail: TLabeledEdit;
    Label1: TLabel;
    Edit_Memo: TMemo;
    BtnSave: TButton;
    BtnExit: TButton;
    Box_Admin: TCheckBox;
    Box_Valid: TCheckBox;
    Label2: TLabel;
    Edit_Group: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit_NameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnSaveClick(Sender: TObject);
  private
    { Private declarations }
    FIsAdd: Boolean;
    {*是否添加*}

    procedure LoadGroupList;
    {*载入组列表*}
    procedure LoadUserInfo(const nUser: string);
    {*载入用户信息*}
    function IsDataValid: Boolean;
    {*数据是否合法*}
    function MakeSQL: string;
    {*构建SQL*}
  public
    { Public declarations }
  end;

function ShowAddUserForm: Boolean;
function ShowEditUserForm(const nUser: string): Boolean;
function DeleteUser(const nUser: string): Boolean;
//入口函数

implementation

{$R *.dfm}
uses
  ULibFun, USysFun, USysConst, USysPopedom, UMgrPopedom, UDataModule;

//------------------------------------------------------------------------------
//Desc: 添加用户
function ShowAddUserForm: Boolean;
begin
  with TfFormUser.Create(Application) do
  begin
    Caption := '新用户';
    FIsAdd := True;

    LoadGroupList;
    Result := ShowModal = mrOK;
    Free
  end;
end;

//Desc: 编辑用户信息
function ShowEditUserForm(const nUser: string): Boolean;
begin
  with TfFormUser.Create(Application) do
  begin
    Caption := '修改';
    FIsAdd := False;

    LoadGroupList;
    LoadUserInfo(nUser);

    Edit_Name.ReadOnly := True;
    Result := ShowModal = mrOK;
    Free
  end;
end;

//Desc: 删除nUser用户
function DeleteUser(const nUser: string): Boolean;
var nStr: string;
begin
  Result := False;
  nStr := '确定要删除用户 [%s] 吗';
  nStr := Format(nStr, [nUser]);
  if not QueryDlg(nStr, sAsk) then Exit;

  ShowMsgOnLastPanelOfStatusBar('正在验证用户身份,请稍后...');
  try
    nStr := 'Select U_IDENTITY From %s Where U_Name=''%s''';
    nStr := Format(nStr, [gSysParam.FTableUser, nUser]);

    FDM.SQLQuery.Close;
    FDM.SQLQuery.SQL.Text := nStr;
    FDM.SQLQuery.Open;

    if FDM.SQLQuery.RecordCount <> 1 then
    begin
      ShowDlg('无法验证该用户身份,操作中止!', sHint); Exit;
    end;

    FDM.SQLQuery.First;
    if FDM.SQLQuery.Fields[0].AsInteger = cPopedomUser_Admin then
    begin
      nStr := '管理员身份的用户不能直接删除' + #13#10 +
              '确定要删除该用户,请先修改用户身份为普通用户';
      ShowDlg(nStr, sHint); Exit;
    end;

    ShowMsgOnLastPanelOfStatusBar('正在执行删除操作,请稍后...');
    nStr := 'Delete From %s Where U_Name=''%s''';
    nStr := Format(nStr, [gSysParam.FTableUser, nUser]);

    FDM.Command.Close;
    FDM.Command.SQL.Text := nStr;
    Result := FDM.Command.ExecSQL > 0;

    if not Result then
      ShowDlg('删除过程出现异常,操作中止', sHint);
    //any error
  finally
    ShowMsgOnLastPanelOfStatusBar('');
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormUser.FormCreate(Sender: TObject);
begin
  LoadFormConfig(Self);
end;

procedure TfFormUser.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

//------------------------------------------------------------------------------
function AdjustGroup(const nItem: PGroupItemData): string;
begin
  Result := '%-10s|%s';
  Result := Format(Result, [nItem.FID, nItem.FName]);
end;

//Desc: 载入权限组列表
procedure TfFormUser.LoadGroupList;
var i,nCount: integer;
    nPopedom: PGroupItemData;
begin
  Edit_Group.Clear;
  nCount := gPopedomManager.Groups.Count - 1;
  for i:=0 to nCount do
  begin
    nPopedom := gPopedomManager.Groups[i];
    Edit_Group.Items.Add(AdjustGroup(nPopedom));
  end;
end;

//Desc: 载入nUser的信息
procedure TfFormUser.LoadUserInfo(const nUser: string);
var nStr,nTmp: string;
    i,nCount: integer;
begin
  ShowMsgOnLastPanelOfStatusBar('正在载入用户信息,请稍后...');
  try
    nStr := 'Select * From %s Where U_Name=''%s''';
    nStr := Format(nStr, [gSysParam.FTableUser, nUser]);

    FDM.SQLQuery.Close;
    FDM.SQLQuery.SQL.Text := nStr;
    FDM.SQLQuery.Open;

    if FDM.SQLQuery.RecordCount <> 1 then
    begin
      ShowDlg('无法读取该用户的信息', sHint); Exit;
    end;

    FDM.SQLQuery.First;
    Edit_Name.Text := nUser;
    Edit_Pwd.Text := FDM.SQLQuery.FieldByName('U_PASSWORD').AsString;
    Edit_Mail.Text := FDM.SQLQuery.FieldByName('U_MAIL').AsString;
    Edit_Phone.Text := FDM.SQLQuery.FieldByName('U_PHONE').AsString;
    Edit_Memo.Text := FDM.SQLQuery.FieldByName('U_MEMO').AsString;

    Box_Admin.Checked := FDM.SQLQuery.FieldByName('U_IDENTITY').AsInteger = cPopedomUser_Admin;
    Box_Valid.Checked := FDM.SQLQuery.FieldByName('U_STATE').AsInteger = cPopedomUser_Normal;

    nStr := FDM.SQLQuery.FieldByName('U_GROUP').AsString;
    nCount := Edit_Group.Items.Count - 1;

    for i:=0 to nCount do
    begin
      nTmp := Copy(Edit_Group.Items[i], 1, Pos('|', Edit_Group.Items[i]) - 1);
      if Trim(nTmp) = nStr then
      begin
        Edit_Group.ItemIndex := i; Break;
      end;
    end;
  finally
    ShowMsgOnLastPanelOfStatusBar('');
  end;
end;

//Desc: 验证当前数据是否合法
function TfFormUser.IsDataValid: Boolean;
var nStr: string;
begin
  Result := False;
  Edit_Name.Text := Trim(Edit_Name.Text);

  if Edit_Name.Text = '' then
  begin
    Edit_Name.SetFocus;
    ShowDlg('无效的用户名', sHint); Exit;
  end;

  if Edit_Pwd.Text = '' then
  begin
    Edit_Pwd.SetFocus;
    ShowDlg('请输入用户密码', sHint); Exit;
  end;

  Edit_Group.Text := Trim(Edit_Group.Text);
  if (Edit_Group.Text <> '') and (Edit_Group.Items.IndexOf(Edit_Group.Text) < 0) then
  begin
    Edit_Group.SetFocus;
    ShowDlg('请选择正确的组名称', sHint); Exit;
  end;

  if not FIsAdd then
  begin
    Result := True; Exit;
  end;

  ShowMsgOnLastPanelOfStatusBar('正在验证用户身份,请稍后...');
  try
    nStr := 'Select Count(*) From %s Where U_Name=''%s''';
    nStr := Format(nStr, [gSysParam.FTableUser, Edit_Name.Text]);

    FDM.SQLQuery.Close;
    FDM.SQLQuery.SQL.Text := nStr;
    FDM.SQLQuery.Open;

    FDM.SQLQuery.First;
    if FDM.SQLQuery.Fields[0].AsInteger < 1 then
         Result := True
    else ShowDlg('该用户已经存在', sHint);
  finally
    ShowMsgOnLastPanelOfStatusBar('');
  end;
end;

//Desc: 构建Insert,Update语句
function TfFormUser.MakeSQL: string;
var nStr: string;
    nIdent,nState,nGroup: Word;
begin
  if Box_Admin.Checked then
       nIdent := cPopedomUser_Admin
  else nIdent := cPopedomUser_User;

  if Box_Valid.Checked then
       nState := cPopedomUser_Normal
  else nState := cPopedomUser_Forbid;

  nStr := Edit_Group.Text;
  if nStr <> '' then
  begin
    nStr := Copy(nStr, 1, Pos('|', nStr) - 1);
    nGroup := StrToInt(Trim(nStr));
  end else nGroup := 0;

  if FIsAdd then
  begin
    Result := 'Insert Into %s(U_NAME,'  + //1
              'U_PASSWORD,'                   + //2
              'U_MAIL,'                       + //3
              'U_PHONE,'                      + //4
              'U_MEMO,'                       + //5
              'U_IDENTITY,'                   + //6
              'U_STATE,'                      + //7
              'U_GROUP) Values('              + //8
              '''%s'','                       + //*1
              '''%s'','                       + //*2
              '''%s'','                       + //*3
              '''%s'','                       + //*4
              '''%s'','                       + //*5
              '%d,'                           + //*6
              '%d,'                           + //*7
              '%d)';                            //*8

     Result := Format(Result, [gSysParam.FTableUser,
                               Edit_Name.Text,
                               Edit_Pwd.Text,
                               Edit_Mail.Text,
                               Edit_Phone.Text,
                               Edit_Memo.Text,
                               nIdent, nState, nGroup]);
  end else
  begin
    Result := 'Update %s Set U_PASSWORD=''%s'','  + //1
              'U_MAIL=''%s'','                          + //2
              'U_PHONE=''%s'','                         + //3
              'U_MEMO=''%s'','                          + //4
              'U_IDENTITY=%d,'                          + //5
              'U_STATE=%d,'                             + //6
              'U_GROUP=%d '                             + //7
              'Where U_NAME=''%s''';

     Result := Format(Result, [gSysParam.FTableUser,
                               Edit_Pwd.Text,
                               Edit_Mail.Text,
                               Edit_Phone.Text,
                               Edit_Memo.Text,
                               nIdent, nState, nGroup,
                               Edit_Name.Text]);
  end;
end;

//------------------------------------------------------------------------------
//Desc: 切换焦点
procedure TfFormUser.Edit_NameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_Return,VK_Right: SwitchFocusCtrl(Self, True);
    VK_Left: SwitchFocusCtrl(Self, False);
  end;
end;

//Desc: 保存
procedure TfFormUser.BtnSaveClick(Sender: TObject);
begin
  if not IsDataValid then Exit;
  FDM.Command.Close;
  FDM.Command.SQL.Text := MakeSQL;

  if FDM.Command.ExecSQL > -1 then
  begin
    ModalResult := mrOk;
    ShowMsg('用户信息已经保存', sHint);
  end else ShowDlg('无法提交用户信息', '未知错误')
end;

end.
