{*******************************************************************************
  ����: dmzn 2008-8-30
  ����: ���,�޸��ֵ���
*******************************************************************************}
unit UFormDict;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TfFormDict = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    BtnOK: TButton;
    BtnExit: TButton;
    Edit_Title: TLabeledEdit;
    Edit_Width: TLabeledEdit;
    Edit_Index: TLabeledEdit;
    Edit_Table: TLabeledEdit;
    Edit_Field: TLabeledEdit;
    Edit_FWidth: TLabeledEdit;
    Edit_Decimal: TLabeledEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit_Align: TComboBox;
    Edit_Visible: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Edit_IsKey: TComboBox;
    Edit_Type: TComboBox;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Edit_FmtData: TLabeledEdit;
    Edit_Format: TLabeledEdit;
    Edit_FmtExt: TLabeledEdit;
    Edit_Style: TComboBox;
    GroupBox4: TGroupBox;
    Label6: TLabel;
    Edit_FteFormat: TLabeledEdit;
    Edit_FteDisplay: TLabeledEdit;
    Edit_FteKind: TComboBox;
    Label7: TLabel;
    Edit_FtePosition: TComboBox;
    Edit_Lang: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure Edit_TitleDblClick(Sender: TObject);
    procedure Edit_FteDisplayKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FItemID: integer;
    FEntity: string;
    {*ʵ������*}
    procedure InitFormData;
    {*��ʼ������*}
    function IsDataValid: Boolean;
    {*У������*}
    function SaveData: Boolean;
    {*��������*}
  public
    { Public declarations }
  end;

procedure ShowAddDictItemForm(const nEntity: string);
procedure ShowEditDictItemForm(const nEntity: string; const nItemID: integer);
procedure SetDictItemFormData(const nItemID: integer);
procedure UpdateDictItemFormEntity(const nEntity: string);
//��ں���

implementation

{$R *.dfm}
uses
  DB, ULibFun, UAdjustForm, UMgrDataDict, USysConst, USysFun, USysDict,
  USysDataSet, UFormDataEdit;

var
  gForm: TfFormDict = nil;
  gLangID: string;

//------------------------------------------------------------------------------
//Desc: ���nEntity����ϸ
procedure ShowAddDictItemForm(const nEntity: string);
begin
  if not Assigned(gForm) then
    gForm := TfFormDict.Create(Application);
  gForm.Caption := '�����ϸ';

  gForm.FItemID := 0;
  gForm.FEntity := nEntity;

  if gForm.Showing then
       gForm.BringToFront
  else gForm.Show;
end;

//Desc: �༭nEntityʵ���б��ΪnItemID����ϸ
procedure ShowEditDictItemForm(const nEntity: string; const nItemID: integer);
begin
  if not Assigned(gForm) then
    gForm := TfFormDict.Create(Application);
  gForm.Caption := '�༭��ϸ: ' + IntToStr(nItemID);

  gForm.FItemID := nItemID;
  gForm.FEntity := nEntity;

  if gForm.Showing then
       gForm.BringToFront
  else gForm.Show;

  if nItemID > 0 then
    SetDictItemFormData(nItemID);
  //��������
end;

//Desc: ����ǰ�ʵ���б��ΪnItemID�������������
procedure SetDictItemFormData(const nItemID: integer);
var nStr: string;
    nItem: PDictItemData;
begin
  if not Assigned(gForm) then Exit;
  nItem := gSysEntityManager.GetActiveDictItem(nItemID);
  
  if Assigned(nItem) then
  with gForm do
  begin
    Edit_Title.Text := nItem.FTitle;
    Edit_Width.Text := IntToStr(nItem.FWidth);
    Edit_Index.Text := IntToStr(nItem.FIndex);

    SetCtrlData(Edit_Align, IntToStr(Ord(nItem.FAlign)));
    if nItem.FVisible then nStr := '1' else nStr := '2';
    SetCtrlData(Edit_Visible, nStr);
    Edit_Lang.Text := nItem.FLangID;

    Edit_Table.Text := nItem.FDBItem.FTable;
    Edit_Field.Text := nItem.FDBItem.FField;
    Edit_FWidth.Text := IntToStr(nItem.FDBItem.FWidth);
    Edit_Decimal.Text := IntToStr(nItem.FDBItem.FDecimal);

    SetCtrlData(Edit_Type, IntToStr(Ord(nItem.FDBItem.FType)));
    if nItem.FDBItem.FIsKey then nStr := '1' else nStr := '2';
    SetCtrlData(Edit_IsKey, nStr);

    SetCtrlData(Edit_Style, IntToStr(Ord(nItem.FFormat.FStyle)));
    Edit_FmtData.Text := nItem.FFormat.FData;
    Edit_Format.Text := nItem.FFormat.FFormat;
    Edit_FmtExt.Text := nItem.FFormat.FExtMemo;

    Edit_FteDisplay.Text := nItem.FFooter.FDisplay;
    Edit_FteFormat.Text := nItem.FFooter.FFormat;
    SetCtrlData(Edit_FteKind, IntToStr(Ord(nItem.FFooter.FKind)));
    SetCtrlData(Edit_FtePosition, IntToStr(Ord(nItem.FFooter.FPosition)));
  end;
end;

//Desc: ���´����ʵ��
procedure UpdateDictItemFormEntity(const nEntity: string);
begin
  if Assigned(gForm) then
  begin
    if gForm.FItemID > 0 then
         gForm.Close
    else gForm.FEntity := nEntity;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormDict.FormCreate(Sender: TObject);
begin
  InitFormData;
  LoadFormConfig(Self);
end;

procedure TfFormDict.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  Action := caFree;

  gForm := nil;
  ReleaseCtrlData(Self);
end;

procedure TfFormDict.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: ��ʼ������
procedure TfFormDict.InitFormData;
begin
  Edit_Lang.Text := gLangID;
  //default value

  GetOrdTypeInfo(TypeInfo(TAlignment), Edit_Align.Items);
  GetOrdTypeInfo(TypeInfo(TFieldType), Edit_Type.Items);
  GetOrdTypeInfo(TypeInfo(TDictFormatStyle), Edit_Style.Items);
  GetOrdTypeInfo(TypeInfo(TDictFooterKind), Edit_FteKind.Items);
  GetOrdTypeInfo(TypeInfo(TDictFooterPosition), Edit_FtePosition.Items);
  AdjustCtrlData(Self);
end;

//------------------------------------------------------------------------------
//Desc: �����ݼ�
procedure TfFormDict.Edit_FteDisplayKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_Return,VK_Right,VK_Down:
      begin
        if (Ord(Key) = VK_Down) and (Sender is TComboBox) then Exit
        else
        if (Ord(Key) = VK_Right) and (Sender is TCustomEdit) then Exit;
        SwitchFocusCtrl(Self, True); Key := 0;
      end;
    VK_Left,VK_UP:
      begin
        if (Ord(Key) = VK_UP) and (Sender is TComboBox) then Exit
        else
        if (Ord(Key) = VK_Left) and (Sender is TCustomEdit) then Exit;
        SwitchFocusCtrl(Self, False); Key := 0;
      end;
  end;
end;

//Desc: �༭����
procedure TfFormDict.Edit_TitleDblClick(Sender: TObject);
var nStr: string;
    nLen: integer;
    nCtrl: TComponent;
    nStyle: TDataEditStyle;
begin
  if Sender is TComponent then
       nCtrl := Sender as TComponent
  else Exit;

  if nCtrl = Edit_FmtData then
       nStyle := [dsList, dsText]
  else nStyle := [dsText];

  if nCtrl is TEdit then
    nLen := TEdit(nCtrl).MaxLength else
  if nCtrl is TLabeledEdit then
       nLen := TLabeledEdit(nCtrl).MaxLength
  else nLen := 0;

  nStr := GetCtrlData(nCtrl);
  if ShowDataEditForm(nStyle, nStr, nLen) then SetCtrlData(nCtrl, nStr);
end;

//Desc: У������
function TfFormDict.IsDataValid: Boolean;
var nStr: string;
    i,nCount: integer;
    nCtrl: TWinControl;
begin
  Result := True;
  nCount := ComponentCount - 1;

  for i:=0 to nCount do
  if Components[i] is TWinControl then
  begin
    nCtrl := Components[i] as TWinControl;
    if nCtrl.HelpKeyword <> 'D' then Continue;

    nStr := GetCtrlData(nCtrl);
    if not IsNumber(nStr, False) then
    begin
      nCtrl.SetFocus;
      Result := False;
      ShowMsg('����д��ȷ������', sHint); Exit;
    end;
  end;
end;

//Desc: ��������
function TfFormDict.SaveData: Boolean;
var nItem: TDictItemData;
begin
  nItem.FItemID := FItemID;
  nItem.FTitle := Edit_Title.Text;
  nItem.FAlign := TAlignment(StrToInt(GetCtrlData(Edit_Align)));

  nItem.FWidth := StrToInt(Edit_Width.Text);
  nItem.FIndex := StrToInt(Edit_Index.Text);
  nItem.FVisible := GetCtrlData(Edit_Visible) = '1';
  nItem.FLangID := Trim(Edit_Lang.Text);

  nItem.FDBItem.FTable := Edit_Table.Text;
  nItem.FDBItem.FField := Edit_Field.Text;
  nItem.FDBItem.FIsKey := GetCtrlData(Edit_IsKey) = '1';

  nItem.FDBItem.FType := TFieldType(StrToInt(GetCtrlData(Edit_Type)));
  nItem.FDBItem.FWidth := StrToInt(Edit_FWidth.Text);
  nItem.FDBItem.FDecimal := StrToInt(Edit_Decimal.Text);

  nItem.FFormat.FStyle := TDictFormatStyle(StrToInt(GetCtrlData(Edit_Style)));
  nItem.FFormat.FData := Edit_FmtData.Text;
  nItem.FFormat.FFormat := Edit_Format.Text;
  nItem.FFormat.FExtMemo := Edit_FmtExt.Text;

  nItem.FFooter.FDisplay := Edit_FteDisplay.Text;
  nItem.FFooter.FFormat := Edit_FteFormat.Text;
  nItem.FFooter.FKind := TDictFooterKind(StrToInt(GetCtrlData(Edit_FteKind)));
  nItem.FFooter.FPosition := TDictFooterPosition(StrToInt(GetCtrlData(Edit_FtePosition)));

  Result := gSysEntityManager.AddDictItemToDB(FEntity, nItem);
  if Result then
       ShowMsg('����ɹ�', sHint)
  else ShowMsg('����ʧ��', sHint);
end;

//Desc: ִ�б���
procedure TfFormDict.BtnOKClick(Sender: TObject);
begin
  if IsDataValid and SaveData then
  begin
    if FItemID < 1 then
      gLangID := Trim(Edit_Lang.Text);
    gSysDataSet.DataChanged;
  end;
end;

end.
