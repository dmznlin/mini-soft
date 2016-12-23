{*******************************************************************************
  ����: dmzn 2008-9-22
  ����: �޸��û�����
*******************************************************************************}
unit UFormPassword;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, StdCtrls, ExtCtrls, dxLayoutControl, cxControls,
  cxContainer, cxEdit, cxTextEdit, UFormBase;

type
  TfFormPassword = class(TBaseForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    EditOld: TcxTextEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    EditNext: TcxTextEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    EditNew: TcxTextEdit;
    dxLayoutControl1Item3: TdxLayoutItem;
    BtnOK: TButton;
    dxLayoutControl1Item4: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item5: TdxLayoutItem;
    dxLayoutControl1Group2: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, USysPopedom;

//------------------------------------------------------------------------------
class function TfFormPassword.CreateForm;
begin
  Result := nil;

  with TfFormPassword.Create(Application) do
  begin
    //Caption := '�޸�����';
    BtnOK.Enabled := gPopedomManager.HasPopedom(nPopedom, sPopedom_Edit);
    ShowModal;
    Free;
  end;
end;

class function TfFormPassword.FormID: integer;
begin
  Result := cFI_FormChangePwd;
end;

//------------------------------------------------------------------------------
//Desc: ����
procedure TfFormPassword.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if EditOld.Text <> gSysParam.FUserPwd then
  begin
    EditOld.SetFocus;
    ShowMsg('���������,����������', sHint); Exit;
  end;

  if EditNew.Text <> EditNext.Text then
  begin
    EditNew.SetFocus;
    ShowMsg('��������������벻һ��', '������'); Exit;
  end;

  nStr := 'Update %s Set U_PASSWORD=''%s'' Where U_NAME=''%s''';
  nStr := Format(nStr, [sTable_User, EditNew.Text, gSysParam.FUserID]);

  if FDM.ExecuteSQL(nStr, False) > 0 then
  begin
    gSysParam.FUserPwd := EditNew.Text;
    ModalResult := mrOK;
    ShowMsg('�������Ѿ���Ч', sHint);
  end else ShowMsg('��������ʱ����δ֪����', '����ʧ��');
end;

initialization
  gControlManager.RegCtrl(TfFormPassword, TfFormPassword.FormID);
end.
