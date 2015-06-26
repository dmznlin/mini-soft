{*******************************************************************************
  ����: dmzn 2008-9-20
  ����: ��˾��Ϣ
*******************************************************************************}
unit UFormIncInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, StdCtrls, ExtCtrls, dxLayoutControl, cxContainer, cxEdit,
  cxTextEdit, cxControls, cxMemo, UFormBase, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TfFormIncInfo = class(TBaseForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    EditName: TcxTextEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    EditPhone: TcxTextEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    EditWeb: TcxTextEdit;
    dxLayoutControl1Item3: TdxLayoutItem;
    EditMail: TcxTextEdit;
    dxLayoutControl1Item4: TdxLayoutItem;
    EditAddr: TcxTextEdit;
    dxLayoutControl1Item5: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayoutControl1Item6: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item7: TdxLayoutItem;
    BtnOK: TButton;
    dxLayoutControl1Item8: TdxLayoutItem;
    dxLayoutControl1Group2: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    procedure InitFormData;
    {*��ʼ������*}
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, USysConst, USysDB, USysPopedom;

ResourceString
  sCompany = 'Company';

//------------------------------------------------------------------------------
class function TfFormIncInfo.CreateForm;
begin
  Result := nil;

  with TfFormIncInfo.Create(Application) do
  begin
    //Caption := '��Ϣ����';
    InitFormData;
    BtnOK.Enabled := gPopedomManager.HasPopedom(nPopedom, sPopedom_Edit);

    ShowModal;
    Free;
  end;
end;

class function TfFormIncInfo.FormID: integer;
begin
  Result := cFI_FormIncInfo;
end;

//------------------------------------------------------------------------------
//Date: 2009-5-31
//Parm: �ַ���;�������������
//Desc: ����nStr�еĻس����з�
function RegularStr(const nStr: string; const nGo: Boolean): string;
begin
  if nGo then
       Result := StringReplace(nStr, #13#10, '*|*', [rfReplaceAll])
  else Result := StringReplace(nStr, '*|*', #13#10, [rfReplaceAll]);
end;

//Desc: ��ʼ����������
procedure TfFormIncInfo.InitFormData;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sConfigFile);
  try
    EditName.Text := nIni.ReadString(sCompany, 'Name', '');
    EditPhone.Text := nIni.ReadString(sCompany, 'Phone', '');
    EditWeb.Text := nIni.ReadString(sCompany, 'Web', '');
    EditMail.Text := nIni.ReadString(sCompany, 'Mail', '');
    EditAddr.Text := nIni.ReadString(sCompany, 'Address', '');
    EditMemo.Text := RegularStr(nIni.ReadString(sCompany, 'Memo', ''), False);
  finally
    nIni.Free;
  end;
end;

//Desc: ����
procedure TfFormIncInfo.BtnOKClick(Sender: TObject);
var nIni: TIniFile;
begin
  EditName.Text := Trim(EditName.Text);
  if EditName.Text = '' then
  begin
    EditName.SetFocus;
    ShowMsg('�����빫˾����', sHint); Exit;
  end;

  nIni := TIniFile.Create(gPath + sConfigFile);
  try
    gSysParam.FHintText := EditName.Text;
    nIni.WriteString(gSysParam.FProgID, 'HintText', EditName.Text);

    nIni.WriteString(sCompany, 'Name', EditName.Text);
    nIni.WriteString(sCompany, 'Phone', EditPhone.Text);
    nIni.WriteString(sCompany, 'Web', EditWeb.Text);
    nIni.WriteString(sCompany, 'Mail', EditMail.Text);
    nIni.WriteString(sCompany, 'Address', EditAddr.Text);
    nIni.WriteString(sCompany, 'Memo', RegularStr(EditMemo.Text, True));
  finally
    nIni.Free;
  end;

  ModalResult := mrOK;
  AddVerifyData(gPath + sConfigFile, gSysParam.FProgID);
  ShowMsg('��Ϣ�ѱ���', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormIncInfo, TfFormIncInfo.FormID);
end.
