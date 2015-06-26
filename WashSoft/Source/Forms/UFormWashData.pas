{*******************************************************************************
  作者: dmzn@163.com 2015-06-25
  描述: 收取衣物
*******************************************************************************}
unit UFormWashData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ComCtrls, cxListView, Menus,
  cxButtons, cxCheckBox, cxLabel;

type
  TfFormWashData = class(TfFormNormal)
    EditPhone: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    EditZheKou: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditMoney: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    EditName: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    ListGrid: TcxListView;
    dxLayout1Item9: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    dxGroup3: TdxLayoutGroup;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    cxButton1: TcxButton;
    dxLayout1Item12: TdxLayoutItem;
    cxButton2: TcxButton;
    dxLayout1Item13: TdxLayoutItem;
    Check1: TcxCheckBox;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    cxLabel1: TcxLabel;
    dxLayout1Item6: TdxLayoutItem;
    EditPay: TcxTextEdit;
    dxLayout1Item14: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FMID,FMName: String;
    FMMoney,FMZheKou: Double;
    //会员信息
  public
    { Public declarations }
    class function FormID: integer; override;
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}
uses
  UMgrControl, ULibFun, USysDB, USysConst, UDataModule, UFormCtrl,
  USysGrid, USysBusiness;

class function TfFormWashData.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  nP := nParam;

  with TfFormWashData.Create(Application) do
  try
    FMID := '';
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormWashData.FormID: integer;
begin
  Result := cFI_FormWashData;
end;

procedure TfFormWashData.FormCreate(Sender: TObject);
begin
  inherited;
  dxGroup1.AlignVert := avTop;
  dxGroup2.AlignVert := avClient;
  dxGroup3.AlignVert := avBottom;

  LoadFormConfig(Self);
  LoadcxListViewConfig(Name, ListGrid);
end;

procedure TfFormWashData.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SaveFormConfig(Self);
  SavecxListViewConfig(Name, ListGrid);
end;

procedure TfFormWashData.EditNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
    nP: TFormCommandParam;
begin
  Visible := False;
  try
    FMID := '';
    nP.FCommand := cCmd_AddData;
    nP.FParamA := Trim(EditName.Text);

    CreateBaseFormItem(cFI_FormGetMember, '', @nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;
  finally
    Visible := True;
  end;

  nStr := 'Select * From %s Where M_ID=''%s''';
  nStr := Format(nStr, [sTable_Member, nP.FParamB]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then
    begin
      ShowMsg('会员信息已丢失', sHint);
      Exit;
    end;

    FMID := nP.FParamB;
    FMName := FieldByName('M_Name').AsString;
    EditName.Text := FMName;

    EditPhone.Text := FieldByName('M_Phone').AsString;
    FMZheKou := FieldByName('M_ZheKou').AsFloat;
    EditZheKou.Text := Format('%.2f', [FMZheKou]);

    FMMoney := GetMemberValidMoney(FMID, True);
    EditMoney.Text := Format('%.2f', [FMMoney]);
  end;

  EditName.SelectAll;
  ActiveControl := EditName;
end;

function TfFormWashData.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
var nVal,nVM: Double;
begin
  Result := True;
end;

procedure TfFormWashData.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if not IsDataValid then Exit;

end;

initialization
  gControlManager.RegCtrl(TfFormWashData, TfFormWashData.FormID);
end.
