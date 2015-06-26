{*******************************************************************************
  ����: dmzn@163.com 2015-06-21
  ����: ѡ���Ա
*******************************************************************************}
unit UFormGetMember;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, cxLabel,
  cxListView, cxTextEdit, cxMaskEdit, cxButtonEdit, dxLayoutControl,
  StdCtrls;

type
  TfFormGetMember = class(TfFormNormal)
    EditCus: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    ListCustom: TcxListView;
    dxLayout1Item6: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure ListCustomKeyPress(Sender: TObject; var Key: Char);
    procedure EditCIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure ListCustomDblClick(Sender: TObject);
  private
    { Private declarations }
    FID,FName: string;
    //��Ա��Ϣ
    function QueryCustom(const nType: Byte): Boolean;
    procedure InitFormData(const nID: string);
    //��ʼ������
    procedure GetResult;
    //��ȡ���
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UMgrControl, UAdjustForm, UFormCtrl, UFormBase, USysGrid,
  USysDB, USysConst, USysBusiness, UDataModule;

class function TfFormGetMember.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormGetMember.Create(Application) do
  try
    Caption := 'ѡ���Ա';
    InitFormData(nP.FParamA);

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;

    if nP.FParamA = mrOK then
    begin
      nP.FParamB := FID;
      nP.FParamC := FName;
    end;
  finally
    Free;
  end;
end;

class function TfFormGetMember.FormID: integer;
begin
  Result := cFI_FormGetMember;
end;

procedure TfFormGetMember.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadcxListViewConfig(Name, ListCustom, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormGetMember.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SavecxListViewConfig(Name, ListCustom, nIni);
  finally
    nIni.Free;
  end;

  ReleaseCtrlData(Self);
end;

//------------------------------------------------------------------------------
//Desc: ��ʼ����������
procedure TfFormGetMember.InitFormData(const nID: string);
begin
  if nID <> '' then
  begin
    EditCus.Text := nID;
    if QueryCustom(10) then
      ActiveControl := ListCustom;
    //xxxxx
  end;
end;

//Date: 2010-3-9
//Parm: ��ѯ����(10: ������;20: ����Ա)
//Desc: ��ָ�����Ͳ�ѯ��ͬ
function TfFormGetMember.QueryCustom(const nType: Byte): Boolean;
var nStr: string;
begin
  Result := False;
  ListCustom.Items.Clear;

  nStr := 'Select * From $MM Where (M_Name Like ''%%$Q%%'' Or ' +
          'M_Py Like ''%%$Q%%'') Or (M_Phone Like ''%%$Q%%'') ' +
          'Order By M_PY';
  nStr := MacroValue(nStr, [MI('$MM', sTable_Member),
          MI('$Q', EditCus.Text)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    with ListCustom.Items.Add do
    begin
      Caption := FieldByName('M_ID').AsString;
      SubItems.Add(FieldByName('M_Name').AsString);
      SubItems.Add(FieldByName('M_Phone').AsString);

      ImageIndex := cItemIconIndex;
      Next;
    end;

    ListCustom.ItemIndex := 0;
    Result := True;
  end;
end;

procedure TfFormGetMember.EditCIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  EditCus.Text := Trim(EditCus.Text);
  if (EditCus.Text <> '') and QueryCustom(10) then ListCustom.SetFocus;
end;

//Desc: ��ȡ���
procedure TfFormGetMember.GetResult;
begin
  with ListCustom.Selected do
  begin
    FID := Caption;
    FName := SubItems[1];
  end;
end;

procedure TfFormGetMember.ListCustomKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if ListCustom.ItemIndex > -1 then
    begin
      GetResult; ModalResult := mrOk;
    end;
  end;
end;

procedure TfFormGetMember.ListCustomDblClick(Sender: TObject);
begin
  if ListCustom.ItemIndex > -1 then
  begin
    GetResult; ModalResult := mrOk;
  end;
end;

procedure TfFormGetMember.BtnOKClick(Sender: TObject);
begin
  if ListCustom.ItemIndex > -1 then
  begin
    GetResult;
    ModalResult := mrOk;
  end else ShowMsg('���ڲ�ѯ�����ѡ��', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormGetMember, TfFormGetMember.FormID);
end.
