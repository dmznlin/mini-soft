{*******************************************************************************
  作者: dmzn@163.com 2015-06-23
  描述: 衣物类型
*******************************************************************************}
unit UFormWashType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxDropDownEdit;

type
  TfFormWashType = class(TfFormNormal)
    EditName: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditPrice: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditMemo: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditUnit: TcxComboBox;
    dxLayout1Item7: TdxLayoutItem;
    EditWashType: TcxComboBox;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FID: String;
    procedure InitFormData;
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
  UMgrControl, ULibFun, USysDB, USysConst, UDataModule, UFormCtrl, USysBusiness;

class function TfFormWashType.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  nP := nParam;

  with TfFormWashType.Create(Application) do
  try
    if nP.FCommand = cCmd_AddData then
    begin
      FID := '';
      Caption := '衣物类型 - 添加';
    end else

    if nP.FCommand = cCmd_EditData then
    begin
      FID := nP.FParamA;
      Caption := '衣物类型 - 修改';
    end;

    InitFormData;
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormWashType.FormID: integer;
begin
  Result := cFI_FormWashType;
end;

procedure TfFormWashType.InitFormData;
var nStr: string;
begin
  ResetHintAllForm(Self, 'T', sTable_WashType);
  //重置表名称

  if FID <> '' then
  begin
    nStr := 'Select * From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_WashType, FID]);
    LoadDataToCtrl(FDM.QueryTemp(nStr), Self);
  end;
end;

function TfFormWashType.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
var nVal: Double;
begin
  Result := True;

  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    nHint := '请填写衣物名称';
    Result := EditName.Text <> '';
  end;

  if Sender = EditPrice then
  begin
    Result := IsNumber(EditPrice.Text, True);
    nHint := '价格为>0的数';

    if Result then
    begin
      nVal := StrToFloat(EditPrice.Text);
      Result := (nVal > 0);
    end;
  end;
end;

procedure TfFormWashType.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if not IsDataValid then Exit;

  if FID = '' then
  begin
    nStr := MakeSQLByStr([
            SF('T_ID', GetSerailID(sFlag_BusGroup, sFlag_WashTypeID, True)),
            SF('T_Name', EditName.Text),
            SF('T_Py', GetPinYinOfStr(EditName.Text)),
            SF('T_Unit', EditUnit.Text),
            SF('T_WashType', EditWashType.Text),
            SF('T_Price', EditPrice.Text, sfVal),
            SF('T_Memo', EditMemo.Text)
            ], sTable_WashType, '', True);
    //xxxxx
  end else
  begin
    nStr := MakeSQLByStr([SF('T_Name', EditName.Text),
            SF('T_Py', GetPinYinOfStr(EditName.Text)),
            SF('T_Unit', EditUnit.Text),
            SF('T_WashType', EditWashType.Text),
            SF('T_Price', EditPrice.Text, sfVal),
            SF('T_Memo', EditMemo.Text)
            ], sTable_WashType, SF('R_ID', FID), False);
    //xxxxx
  end;

  FDM.ExecuteSQL(nStr);
  ModalResult := mrOk;
  ShowMsg('保存成功', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormWashType, TfFormWashType.FormID);
end.
