{*******************************************************************************
  作者: dmzn@163.com 2011-6-7
  描述: 规格材质管理
*******************************************************************************}
unit UFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxButtonEdit, cxLabel, cxTextEdit, cxContainer, cxEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TfFormUnit = class(TfFormNormal)
    dxLayout1Item7: TdxLayoutItem;
    EditName: TcxTextEdit;
    EditType: TcxComboBox;
    dxLayout1Item13: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FRecordID: string;
    //记录编号
    procedure InitFormData(const nID: string);
    //载入数据
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UFormCtrl, UAdjustForm, UFormBase, UMgrControl, USysDB,
  USysConst, UDataModule;

class function TfFormUnit.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormUnit.Create(Application) do
    begin
      FRecordID := '';
      Caption := '规格 - 添加';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormUnit.Create(Application) do
    begin
      Caption := '规格 - 修改';
      FRecordID := nP.FParamA;

      InitFormData(FRecordID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
  end;
end;

class function TfFormUnit.FormID: integer;
begin
  Result := cFI_FormUnit;
end;

procedure TfFormUnit.FormCreate(Sender: TObject);
begin
  AdjustCtrlData(Self);
  LoadFormConfig(Self);
  ResetHintTable(Self, 'T', sTable_Unit);
end;

procedure TfFormUnit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  ReleaseCtrlData(Self);
end;

//------------------------------------------------------------------------------
procedure TfFormUnit.InitFormData(const nID: string);
var nStr: string;
begin
  if nID <> '' then
  begin
    nStr := 'Select * From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_Unit, nID]);
    LoadDataToCtrl(FDM.QueryTemp(nStr), Self);
  end;
end;

//Desc: 验证数据
function TfFormUnit.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nStr: string;
begin
  Result := True;

  if Sender = EditType then
  begin
    Result := EditType.ItemIndex > -1;
    nHint := '请选择有效类型';
  end else

  if Sender = EditName then
  begin
    nHint := '请填写有效的名称';
    EditName.Text := Trim(EditName.Text);

    Result := EditName.Text <> '';
    if not Result then Exit;

    nStr := 'Select Count(*) From %s Where U_Name=''%s'' And U_Type=''%s''';
    nStr := Format(nStr, [sTable_Unit, EditName.Text, GetCtrlData(EditType)]);

    if FRecordID <> '' then
      nStr := nStr + ' And R_ID<>' + FRecordID;
    //xxxxx

    with FDM.QueryTemp(nStr) do
    begin
      nHint := '名称重复';
      Result := Fields[0].AsInteger < 1;
    end;
  end;
end;

//Desc: 保存
procedure TfFormUnit.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if not IsDataValid then Exit;

  if FRecordID = '' then
  begin
    nStr := 'Insert $TB(U_Name,U_PY,U_Type) Values(''$N'',''$PY'',''$TP'')';
  end else
  begin
    nStr := 'Update $TB Set U_Name=''$N'',U_PY=''$PY'',U_Type=''$TP'' ' +
            'Where R_ID=' + FRecordID;
  end;

  nStr := MacroValue(nStr, [MI('$TB', sTable_Unit), MI('$TP', GetCtrlData(EditType)),          
          MI('$N', EditName.Text), MI('$PY', GetPinYinOfStr(EditName.Text))]);
  FDM.ExecuteSQL(nStr);

  ModalResult := mrOK;
  ShowMsg('数据已保存', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormUnit, TfFormUnit.FormID);
end.
