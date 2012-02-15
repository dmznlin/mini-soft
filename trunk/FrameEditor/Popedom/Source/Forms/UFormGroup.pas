{*******************************************************************************
  作者: dmzn@ylsoft.com 2008-2-27
  描述: 管理组信息
*******************************************************************************}
unit UFormGroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ImgList;

type
  TfFormGroup = class(TForm)
    Edit_Name: TLabeledEdit;
    Edit_Desc: TLabeledEdit;
    BtnOK: TButton;
    BtnExit: TButton;
    Box_CanDel: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FIsAdd: Boolean;
    {*是否添加*}
    FGroupID: string;
    {*组标识*}

    procedure LoadGroupInfo(const nGroup: string);
    {*载入组信息*}
  public
    { Public declarations }
  end;

function ShowAddGroupForm: Boolean;
function ShowEditGroupForm(const nGroup: string): Boolean;
function DeleteGroup(const nGroup,nName: string): Boolean;
//入口函数

implementation

{$R *.dfm}
uses
  ULibFun, USysFun, USysConst, USysPopedom, UMgrPopedom, UDataModule;

//------------------------------------------------------------------------------
//Desc: 添加组
function ShowAddGroupForm: Boolean;
begin
  with TfFormGroup.Create(Application) do
  begin
    Caption := '新建组';
    FIsAdd := True;

    Result := ShowModal = mrOK;
    Free
  end;
end;

//Desc: 修改nGroup组
function ShowEditGroupForm(const nGroup: string): Boolean;
begin
  with TfFormGroup.Create(Application) do
  begin
    Caption := '修改组';
    FIsAdd := False;
    FGroupID := nGroup;

    LoadGroupInfo(nGroup);
    Result := ShowModal = mrOK;
    Free
  end;
end;

//Desc: 删除nGroup组
function DeleteGroup(const nGroup,nName: string): Boolean;
var nStr: string;
begin
  Result := False;
  nStr := '确定要删除 [%s] 组吗';
  nStr := Format(nStr, [nName]);
  if not QueryDlg(nStr, sAsk) then Exit;

  ShowMsgOnLastPanelOfStatusBar('正在读取组信息,请稍后...');
  try
    nStr := 'Select G_CANDEL From %s Where G_ID=%s';
    nStr := Format(nStr, [gSysParam.FTableGroup, nGroup]);

    FDM.SQLQuery.Close;
    FDM.SQLQuery.SQL.Text := nStr;
    FDM.SQLQuery.Open;

    if FDM.SQLQuery.RecordCount <> 1 then
    begin
      ShowDlg('无法获取该组详细信息,操作中止!', sHint); Exit;
    end;

    FDM.SQLQuery.First;
    if FDM.SQLQuery.Fields[0].AsInteger <> cPopedomGroup_CanDel then
    begin
      nStr := '管理员设置该组不能删除' + #13#10 +
              '确定要删除该组,请先设定"允许删除"属性';
      ShowDlg(nStr, sHint); Exit;
    end;

    ShowMsgOnLastPanelOfStatusBar('正在执行删除操作,请稍后...');
    nStr := 'Delete From %s Where P_GROUP=%s';
    nStr := Format(nStr, [gSysParam.FTablePopedom, nGroup]);

    FDM.ADOConn.BeginTrans;
    FDM.Command.Close;
    FDM.Command.SQL.Text := nStr;
    Result := FDM.Command.ExecSQL > -1;

    if Result then
    begin
      nStr := 'Delete From %s Where G_ID=%s';
      nStr := Format(nStr, [gSysParam.FTableGroup, nGroup]);

      FDM.Command.Close;
      FDM.Command.SQL.Text := nStr;
      Result := FDM.Command.ExecSQL > -1;
    end;

    if not Result then
    begin
      FDM.ADOConn.RollbackTrans;
      ShowDlg('删除过程出现异常,操作中止', sHint);
    end else FDM.ADOConn.CommitTrans;
  finally
    ShowMsgOnLastPanelOfStatusBar('');
    if FDM.ADOConn.InTransaction then FDM.ADOConn.RollbackTrans;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormGroup.FormCreate(Sender: TObject);
begin
  LoadFormConfig(Self);
end;

procedure TfFormGroup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

//------------------------------------------------------------------------------
//Desc: 读取nGroup组信息
procedure TfFormGroup.LoadGroupInfo(const nGroup: string);
var nStr: string;
begin
  ShowMsgOnLastPanelOfStatusBar('正在读取组信息,请稍后...');
  try
    nStr := 'Select * From %s Where G_ID=%s';
    nStr := Format(nStr, [gSysParam.FTableGroup, nGroup]);

    FDM.SQLQuery.Close;
    FDM.SQLQuery.SQL.Text := nStr;
    FDM.SQLQuery.Open;

    if FDM.SQLQuery.RecordCount <> 1 then
    begin
      ShowDlg('无法读取该组的信息', sHint); Exit;
    end;

    FDM.SQLQuery.First;
    Edit_Name.Text := FDM.SQLQuery.FieldByName('G_NAME').AsString;
    Edit_Desc.Text := FDM.SQLQuery.FieldByName('G_DESC').AsString;
    Box_CanDel.Checked := FDM.SQLQuery.FieldByName('G_CANDEL').AsInteger = cPopedomGroup_CanDel;
  finally
    ShowMsgOnLastPanelOfStatusBar('');
  end;
end;

//Desc: 保存
procedure TfFormGroup.BtnOKClick(Sender: TObject);
var nStr,nID: string;
    nDel: integer;
begin
  Edit_Name.Text := Trim(Edit_Name.Text);
  if Edit_Name.Text = '' then
  begin
    Edit_Name.SetFocus;
    ShowDlg('请输入组名称', sHint); Exit;
  end;

  if Box_CanDel.Checked then
       nDel := cPopedomGroup_CanDel
  else nDel := cPopedomGroup_NoDel;

  if FIsAdd then
  begin
    nStr := 'Select Max(G_ID) From $Group';
    nStr := MacroValue(nStr, [MI('$Group', gSysParam.FTableGroup)]);

    FDM.SQLQuery.Close;
    FDM.SQLQuery.SQL.Text := nStr;
    FDM.SQLQuery.Open;
    nID := IntToStr(FDM.SQLQuery.Fields[0].AsInteger + 1);
    
    nStr := 'Insert Into $Group(G_ID, G_PROGID, G_NAME, G_DESC, G_CANDEL) ' +
            'Values($GID, ''%s'', ''%s'', ''%s'', %d)';
    nStr := MacroValue(nStr, [MI('$Group', gSysParam.FTableGroup), MI('$GID', nID)]);
    nStr := Format(nStr, [gSysParam.FProgID, Edit_Name.Text, Edit_Desc.Text, nDel]);
  end else
  begin
    nStr := 'Update %s Set G_NAME=''%s'', G_DESC=''%s'', G_CANDEL=%d ' +
            'Where G_ID=%s';
    nStr := Format(nStr, [gSysParam.FTableGroup, Edit_Name.Text, Edit_Desc.Text, nDel, FGroupID]);
  end;

  FDM.Command.Close;
  FDM.Command.SQL.Text := nStr;
  if FDM.Command.ExecSQL > -1 then
  begin
    ModalResult := mrOk;
    ShowMsg('组信息已经保存', sHint);
  end else ShowDlg('无法提交组信息', '未知错误');
end;

end.
