{*******************************************************************************
  作者: dmzn@163.com 2011-6-7
  描述: 备品备件入库
*******************************************************************************}
unit UFormRBeiPin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMCListBox, cxMaskEdit,
  cxDropDownEdit, cxTextEdit, dxLayoutControl, StdCtrls, cxLabel,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox;

type
  TfFormRBeiPin = class(TfFormNormal)
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Item4: TdxLayoutItem;
    InfoList1: TcxMCListBox;
    dxLayout1Item6: TdxLayoutItem;
    BtnAdd: TButton;
    dxLayout1Item8: TdxLayoutItem;
    BtnDel: TButton;
    dxLayout1Item11: TdxLayoutItem;
    EditGG: TcxComboBox;
    dxLayout1Item9: TdxLayoutItem;
    EditUnit: TcxComboBox;
    dxLayout1Group7: TdxLayoutGroup;
    EditName: TcxLookupComboBox;
    dxLayout1Item10: TdxLayoutItem;
    EditGY: TcxLookupComboBox;
    dxLayout1Item7: TdxLayoutItem;
    EditCW: TcxLookupComboBox;
    dxLayout1Item12: TdxLayoutItem;
    EditNum: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    EditPrice: TcxTextEdit;
    dxLayout1Item14: TdxLayoutItem;
    dxLayout1Group6: TdxLayoutGroup;
    cxLabel1: TcxLabel;
    dxLayout1Item15: TdxLayoutItem;
    dxLayout1Group8: TdxLayoutGroup;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    EditBH: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditTH: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item16: TdxLayoutItem;
    EditCZ: TcxComboBox;
    dxLayout1Item17: TdxLayoutItem;
    EditDZ: TcxTextEdit;
    dxLayout1Item18: TdxLayoutItem;
    dxLayout1Group9: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure EditNamePropertiesEditValueChanged(Sender: TObject);
    procedure EditCWPropertiesEditValueChanged(Sender: TObject);
  private
    { Private declarations }
    FNowWeek: string;
    //当前周期
    FLastLookup: string;
    //上次检索
    procedure InitFormData(const nID: string);
    //载入数据
    procedure LoadRKItems;
    //入库项
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
  IniFiles, ULibFun, UFormBase, UMgrControl, UAdjustForm, UFormCtrl,
  USysDB, USysConst, UDataModule, USysBusiness, USysGrid, USysLookupAdapter;

type
  TRKItem = record
    FValid: Boolean;
    FWPID: string;
    FWPName: string;
    FSerial: string;
    FTuNo: string;
    FUnit: string;
    FGuiGe: string;
    FCaiZhi: string;
    FProvider: string;
    FNum,FPrice: Double;
    FPerWeight: Double;
    FStorage: string;
  end;

var
  gRKItems: array of TRKItem;
  //全局使用

class function TfFormRBeiPin.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormRBeiPin.Create(Application) do
    begin
      Caption := '备品入库';
      FNowWeek := nP.FParamA;
      InitFormData('');

      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
  end;
end;

class function TfFormRBeiPin.FormID: integer;
begin
  Result := cFI_FormRBeiPin;
end;

procedure TfFormRBeiPin.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, InfoList1, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormRBeiPin.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, InfoList1, nIni);
  finally
    nIni.Free;
  end;

  ReleaseCtrlData(Self);
  gLookupComboBoxAdapter.DeleteGroup(Name);
end;

//------------------------------------------------------------------------------
procedure TfFormRBeiPin.InitFormData(const nID: string);
var nStr,nTmp: string;
    nDStr: TDynamicStrArray;
    nItem: TLookupComboBoxItem;
begin
  SetLength(gRKItems, 0);
  //item list

  if EditUnit.Properties.Items.Count < 1 then
  begin
    nStr := 'U_Name=Select U_PY,U_Name From %s Where U_Type=''%s'' Order By U_PY';
    nStr := Format(nStr, [sTable_Unit, sFlag_DanWei]);

    FDM.FillStringsData(EditUnit.Properties.Items, nStr, -1, '.');
    AdjustStringsItem(EditUnit.Properties.Items, False);
  end;

  if EditGG.Properties.Items.Count < 1 then
  begin
    nStr := 'U_Name=Select U_PY,U_Name From %s Where U_Type=''%s'' Order By U_PY';
    nStr := Format(nStr, [sTable_Unit, sFlag_GuiGe]);

    FDM.FillStringsData(EditGG.Properties.Items, nStr, -1, '.');
    AdjustStringsItem(EditGG.Properties.Items, False);
  end;

  if EditCZ.Properties.Items.Count < 1 then
  begin
    nStr := 'U_Name=Select U_PY,U_Name From %s Where U_Type=''%s'' Order By U_PY';
    nStr := Format(nStr, [sTable_Unit, sFlag_CaiZhi]);

    FDM.FillStringsData(EditCZ.Properties.Items, nStr, -1, '.');
    AdjustStringsItem(EditCZ.Properties.Items, False);
  end;

  if not Assigned(EditName.Properties.ListSource) then
  begin
    nStr := 'Select * From %s Where G_Type=''%s'' Order By G_PY';
    nStr := Format(nStr, [sTable_Goods, sFlag_BeiPin]);

    SetLength(nDStr, 1);
    nDStr[0] := 'G_PY';
    nTmp := Name + 'WP';

    nItem := gLookupComboBoxAdapter.MakeItem(Name, nTmp, nStr, 'G_ID', 1,
             [MI('G_PY', '简写'), MI('G_Name', '名称')], nDStr);
    gLookupComboBoxAdapter.AddItem(nItem);
    gLookupComboBoxAdapter.BindItem(nTmp, EditName);
  end;

  if not Assigned(EditGY.Properties.ListSource) then
  begin
    nStr := 'Select P_ID,P_PY,P_Name From %s Order By P_PY';
    nStr := Format(nStr, [sTable_Provider]);

    SetLength(nDStr, 1);
    nDStr[0] := 'P_PY';
    nTmp := Name + 'GY';

    nItem := gLookupComboBoxAdapter.MakeItem(Name, nTmp, nStr, 'P_ID', 1,
             [MI('P_PY', '简写'), MI('P_Name', '名称')], nDStr);
    gLookupComboBoxAdapter.AddItem(nItem);
    gLookupComboBoxAdapter.BindItem(nTmp, EditGY);
  end;

  if not Assigned(EditCW.Properties.ListSource) then
  begin
    nStr := 'Select S_ID,S_PY,S_Name,S_Owner From %s Order By S_PY';
    nStr := Format(nStr, [sTable_Storage]);

    SetLength(nDStr, 1);
    nDStr[0] := 'S_PY';

    nTmp := Name + 'CW';
    nItem := gLookupComboBoxAdapter.MakeItem(Name, nTmp, nStr, 'S_ID', 1,
             [MI('S_PY', '简写'), MI('S_Name', '名称')], nDStr);
    gLookupComboBoxAdapter.AddItem(nItem);
    gLookupComboBoxAdapter.BindItem(nTmp, EditCW);
  end;
end;

//Desc: 载入入库清单
procedure TfFormRBeiPin.LoadRKItems;
var i,nIdx: Integer;
begin
  nIdx := InfoList1.ItemIndex;
  InfoList1.Items.Clear;

  for i:=Low(gRKItems) to High(gRKItems) do
  with gRKItems[i] do
  begin
    if not FValid then Continue;

    InfoList1.Items.Add(CombinStr([FWPName, FloatToStr(FNum),
        Format('%.2f', [FPrice]), IntToStr(i)], InfoList1.Delimiter));
    //xxxxx
  end;

  if (nIdx < 0) and (InfoList1.Items.Count > 0) then
    nIdx := 0;
  InfoList1.ItemIndex := nIdx;
end;

//Desc: 验证数据
function TfFormRBeiPin.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditName then
  begin
    Result := not VarIsNull(EditName.EditValue);
    nHint := '请选择有效的名称';
  end else

  if Sender = EditUnit then
  begin
    Result := EditUnit.ItemIndex > -1;
    nHint := '请选择有效的计量单位';
  end else

  if Sender = EditGG then
  begin
    Result := EditGG.ItemIndex > -1;
    nHint := '请选择有效的物品规格';
  end else

  if Sender = EditCZ then
  begin
    Result := EditCZ.ItemIndex > -1;
    nHint := '请选择有效的材质';
  end else

  if Sender = EditCW then
  begin
    Result := not VarIsNull(EditCW.EditValue);
    nHint := '请选择有效的仓位';
  end else

  if Sender = EditNum then
  begin
    Result := IsNumber(EditNum.Text, True);
    nHint := '请输入有效的采购数量';
  end else

  if Sender = EditPrice then
  begin
    Result := IsNumber(EditPrice.Text, True);
    nHint := '请输入有效的单价';
  end else

  if Sender = EditDZ then
  begin
    Result := IsNumber(EditDZ.Text, False);
    nHint := '请输入有效的单重';
  end;
end;

//Desc: 添加
procedure TfFormRBeiPin.BtnAddClick(Sender: TObject);
var nIdx: Integer;
begin
  if not IsDataValid then Exit;

  nIdx := Length(gRKItems);
  SetLength(gRKItems, nIdx + 1);

  with gRKItems[nIdx] do
  begin
    FValid := True;
    FWPID := EditName.EditValue;
    FWPName := EditName.Text;
    FSerial := EditBH.Text;
    FTuNo := EditTH.Text;

    FUnit := GetCtrlData(EditUnit);
    FGuiGe := GetCtrlData(EditGG);
    FCaiZhi := GetCtrlData(EditCZ);

    if VarIsNull(EditGY.EditValue) then
         EditGY.Text := ''
    else FProvider := EditGY.EditValue;

    FNum := StrToFloat(EditNum.Text);
    FPrice := StrToFloat(EditPrice.Text);
    FPerWeight := StrToFloat(EditDZ.Text);
    FStorage := EditCW.EditValue;
  end;

  ActiveControl := EditName;
  LoadRKItems;              
end;

//Desc: 删除
procedure TfFormRBeiPin.BtnDelClick(Sender: TObject);
var nList: TStrings;
begin
  nList := nil;
  if InfoList1.ItemIndex > -1 then
  try
    nList := TStringList.Create;
    if not SplitStr(InfoList1.Items[InfoList1.ItemIndex], nList, 4,
       InfoList1.Delimiter) then Exit;
    //xxxxx

    gRKItems[StrToInt(nList[3])].FValid := False;
    LoadRKItems;
  finally
    nList.Free;
  end;
end;

//Desc: 载入默认
procedure TfFormRBeiPin.EditNamePropertiesEditValueChanged(
  Sender: TObject);
var nStr: string;
begin
  if VarIsNull(EditName.EditValue) then Exit;
  nStr := EditName.EditValue;
  if nStr = FLastLookup then Exit;

  FLastLookup := nStr;
  nStr := 'Select * From %s Where G_ID=''%s''';
  nStr := Format(nStr, [sTable_Goods, FLastLookup]);

  with FDM.QueryTemp(nStr) do
  if REcordCount > 0 then
  begin
    SetCtrlData(EditUnit, FieldByName('G_Unit').AsString);
    SetCtrlData(EditGG, FieldByName('G_GuiGe').AsString);
    SetCtrlData(EditCW, FieldByName('G_Storage').AsString);
    SetCtrlData(EditCZ, FieldByName('G_CaiZhi').AsString);

    EditNum.Text := '0';
    EditPrice.Text := '0';
    EditDZ.Text := '0';
    ActiveControl := EditNum;
  end;
end;

procedure TfFormRBeiPin.EditCWPropertiesEditValueChanged(
  Sender: TObject);
begin
  ActiveControl := BtnAdd;
end;

//Desc: 保存
procedure TfFormRBeiPin.BtnOKClick(Sender: TObject);
var nIdx: Integer;
    nStr,nSQL: string;
begin
  if InfoList1.Items.Count < 1 then
  begin
    ShowMsg('请添加入库清单', sHint); Exit;
  end;

  FDM.ADOConn.BeginTrans;
  try
    nSQL := 'Insert Into %s(B_Week,B_Goods,B_Serial,B_TuNo,B_CaiZhi,B_GuiGe,' +
            'B_Unit,B_Provider,B_Storage,B_Num,B_Price,B_PerZ,B_Man,' +
            'B_Date) Values(''%s'',''$GD'',''$SR'',''$TN'',''$CZ'',' +
            '''$GG'',''$UT'',''$Pro'',''$ST'',$Num,$Pri,$DZ,''%s'',%s)';
    nSQL := Format(nSQL, [sTable_BeiPin, FNowWeek, gSysParam.FUserID,
            FDM.SQLServerNow]);
    //xxxxx

    for nIdx:=Low(gRKItems) to High(gRKItems) do
    with gRKItems[nIdx] do
    begin
      if not FValid then Continue;
      nStr := MacroValue(nSQL, [MI('$GD', FWPID), MI('$UT', FUnit),
              MI('$GG', FGuiGe), MI('$CZ', FCaiZhi), MI('$SR', FSerial),
              MI('$TN', FTuNo), MI('$DZ', FloatToStr(FPerWeight)),
              MI('$Pro', FProvider), MI('$ST', FStorage),
              MI('$Num', FloatToStr(FNum)), MI('$Pri', FloatToStr(FPrice))]);
      FDM.ExecuteSQL(nStr);

      nStr := 'Update %s Set P_Done=P_Done+%s ' +
              'Where P_Week=''%s'' And P_Goods=''%s''';
      nStr := Format(nStr, [sTable_BuyPlan, FloatToStr(FNum), FNowWeek, FWPID]);
      FDM.ExecuteSQL(nStr);
    end;

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOK;
    ShowMsg('入库完成', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('数据保存失败', sError);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormRBeiPin, TfFormRBeiPin.FormID);
end.
