{*******************************************************************************
  作者: dmzn@163.com 2011-6-7
  描述: 物品出库
*******************************************************************************}
unit UFormChuKu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMCListBox, cxMaskEdit,
  cxDropDownEdit, cxTextEdit, dxLayoutControl, StdCtrls, cxLabel,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox;

type
  TfFormChuKu = class(TfFormNormal)
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Item4: TdxLayoutItem;
    InfoList1: TcxMCListBox;
    EditName: TcxLookupComboBox;
    dxLayout1Item10: TdxLayoutItem;
    EditNum: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    dxLayout1Group6: TdxLayoutGroup;
    EditBM: TcxLookupComboBox;
    dxLayout1Item3: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditNamePropertiesEditValueChanged(Sender: TObject);
    procedure EditNumExit(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FLastLookup: string;
    //上次检索
    procedure InitFormData(const nID: string);
    //载入数据
    procedure LoadKCList;
    //库存清单
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
  TKCItem = record
    FRecord: string;
    FWeek: string;
    FWPName: string;
    FStgeID: string;
    FStorage: string;
    FAll: Double;
    FNum: Double;
  end;

var
  gKCItems: array of TKCItem;
  //全局使用

class function TfFormChuKu.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  nP := nParam;

  with TfFormChuKu.Create(Application) do
  try
    Caption := '物品出库';
    InitFormData('');

    if Assigned(nP) then
    begin
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
    end else ShowModal;
  finally
    Free;
  end;
end;

class function TfFormChuKu.FormID: integer;
begin
  Result := cFI_FormChuKu;
end;

procedure TfFormChuKu.FormCreate(Sender: TObject);
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

procedure TfFormChuKu.FormClose(Sender: TObject;
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
procedure TfFormChuKu.InitFormData(const nID: string);
var nStr,nTmp: string;
    nDStr: TDynamicStrArray;
    nItem: TLookupComboBoxItem;
begin
  FLastLookup := '';
  dxGroup1.AlignVert := avTop;
  dxLayout1Group2.AlignVert := avClient;

  if not Assigned(EditBM.Properties.ListSource) then
  begin
    nStr := 'Select D_ID,D_PY,D_Name From %s Order By D_PY';
    nStr := Format(nStr, [sTable_Department]);

    SetLength(nDStr, 1);
    nDStr[0] := 'D_PY';
    nTmp := Name + 'BM';

    nItem := gLookupComboBoxAdapter.MakeItem(Name, nTmp, nStr, 'D_ID', 1,
             [MI('D_PY', '简写'), MI('D_Name', '名称')], nDStr);
    gLookupComboBoxAdapter.AddItem(nItem);
    gLookupComboBoxAdapter.BindItem(nTmp, EditBM);
  end;

  if not Assigned(EditName.Properties.ListSource) then
  begin
    nStr := 'Select * From %s Order By G_PY';
    nStr := Format(nStr, [sTable_Goods]);

    SetLength(nDStr, 1);
    nDStr[0] := 'G_PY';
    nTmp := Name + 'WP';

    nItem := gLookupComboBoxAdapter.MakeItem(Name, nTmp, nStr, 'G_ID;G_Type;G_OutStyle',
             1, [MI('G_PY', '简写'), MI('G_Name', '名称')], nDStr);
    gLookupComboBoxAdapter.AddItem(nItem);
    gLookupComboBoxAdapter.BindItem(nTmp, EditName);
  end;
end;

//Desc: 载入库存清单
procedure TfFormChuKu.LoadKCList;
var nAll: Double;
    nIdx: Integer;
begin
  nAll := 0;
  InfoList1.Items.Clear;

  for nIdx:=Low(gKCItems) to High(gKCItems) do
  with gKCItems[nIdx] do
  begin
    InfoList1.Items.Add(CombinStr([FWPName, FStorage,
      Format('%.2f', [FAll]), Format('%.2f', [FNum])], InfoList1.Delimiter));
    nAll := nAll + FAll;
  end;

  if nAll > 0 then
       dxLayout1Group2.Caption := Format('库存清单 总量:[ %.2f ]', [nAll])
  else dxLayout1Group2.Caption := '库存清单';
end;

//Desc: 更新库存清单
procedure TfFormChuKu.EditNamePropertiesEditValueChanged(Sender: TObject);
var nIdx: Integer;
    nStr,nCK: string;
begin
  EditNum.Text := '0';
  SetLength(gKCItems, 0);
  
  LoadKCList;
  if VarIsNull(EditName.EditValue) then Exit;
  
  nCK := 'Select D_RID,Sum(D_Num) as D_All From %s Group By D_RID';
  nCK := Format(nCK, [sTable_ChuKuDtl]);

  if EditName.EditValue[1] = sFlag_BeiPin then
  begin
    nStr := 'Select bp.R_ID,B_Num-IsNull(D_All, 0),S_Name,B_Week,B_Storage From %s bp ' +
            ' Left Join %s st On st.S_ID=bp.B_Storage ' +
            ' Left Join (%s) ck On ck.D_RID=bp.R_ID ';
    //xxxxx

    nStr := Format(nStr, [sTable_BeiPin, sTable_Storage, nCK]);
    nStr := nStr + Format(' Where B_Goods=''%s'' ', [EditName.EditValue[0]]);

    if EditName.EditValue[2] = sFlag_NInNOut then
         nStr := nStr + ' Order By B_Date ASC '
    else nStr := nStr + ' Order By B_Date DESC '
  end else

  if EditName.EditValue[1] = sFalg_CaiLiao then
  begin
    nStr := 'Select yl.R_ID,Y_Num-IsNull(D_All, 0),S_Name,Y_Week,Y_Storage From %s yl ' +
            ' Left Join %s st On st.S_ID=yl.Y_Storage ' +
            ' Left Join (%s) ck On ck.D_RID=yl.R_ID ';
    //xxxxx

    nStr := Format(nStr, [sTable_YuanLiao, sTable_Storage, nCK]);
    nStr := nStr + Format(' Where Y_Goods=''%s'' ', [EditName.EditValue[0]]);

    if EditName.EditValue[2] = sFlag_NInNOut then
         nStr := nStr + ' Order By Y_Date ASC '
    else nStr := nStr + ' Order By Y_Date DESC '
  end else Exit;

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nIdx := 0;
    First;

    while not Eof do
    begin
      if Fields[1].AsFloat > 0 then
      begin
        SetLength(gKCItems, nIdx + 1);

        with gKCItems[nIdx] do
        begin
          FRecord := Fields[0].AsString;
          FStgeID := Fields[4].AsString;
          FStorage := Fields[2].AsString;

          FWeek := Fields[3].AsString;
          FWPName := EditName.Text;
          FNum := 0;
          FAll := Float2Float(Fields[1].AsFloat, cPrecision, False);
        end;

        Inc(nIdx);
      end;

      Next;
    end;

    LoadKCList;
  end;
end;

//Desc: 分配出库仓位
procedure TfFormChuKu.EditNumExit(Sender: TObject);
var nIdx: Integer;
    nNum: Double;
begin
  if not IsNumber(EditNum.Text, False) then Exit;
  nNum := StrToFloat(EditNum.Text);
  if nNum <= 0 then Exit;

  for nIdx:=Low(gKCItems) to High(gKCItems) do
  with gKCItems[nIdx] do
  begin
    if FAll >= nNum then
    begin
      FNum := nNum;
      nNum := 0;
    end else
    begin
      FNum := FAll;
      nNum := nNum - FAll;
    end;

    if nNum = 0 then Break;
  end;

  if nNum > 0 then
  begin
    EditNum.SetFocus;
    ShowMsg('领用量超出库存', sHint);
  end else LoadKCList;
end;

//Desc: 验证数据
function TfFormChuKu.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditName then
  begin
    Result := not VarIsNull(EditName.EditValue);
    nHint := '请选择有效的名称';
  end else

  if Sender = EditBM then
  begin
    Result := not VarIsNull(EditBM.EditValue);
    nHint := '请选择有效的部门';
  end else

  if Sender = EditNum then
  begin
    Result := IsNumber(EditNum.Text, True) and (StrToFloat(EditNum.Text) > 0);
    nHint := '请输入有效的采购数量';
  end;
end;

//Desc: 保存
procedure TfFormChuKu.BtnOKClick(Sender: TObject);
var nIdx: Integer;
    nStr,nID: string;
begin
  if not IsDataValid then Exit;

  FDM.ADOConn.BeginTrans;
  try
    nStr := 'Insert Into $TB(C_Goods,C_GType,C_Depart,C_Num,C_Man,' +
            'C_Date) Values(''$GD'',''$GT'',''$BM'',$Num,''$MM'',$Now)';
    nStr := MacroValue(nStr, [MI('$TB', sTable_ChuKu),
            MI('$GD', EditName.EditValue[0]), MI('$BM', EditBM.EditValue),
            MI('$Num', EditNum.Text), MI('$MM', gSysParam.FUserID),
            MI('$GT', EditName.EditValue[1]), MI('$Now', FDM.SQLServerNow)]);
    //xxxxx

    FDM.ExecuteSQL(nStr);
    nID := IntToStr(FDM.GetFieldMax(sTable_ChuKu, 'R_ID'));

    for nIdx:=Low(gKCItems) to High(gKCItems) do
    with gKCItems[nIdx] do
    begin
      if FNum <= 0 then Continue;

      nStr := 'Insert Into $TB(D_CID,D_RID,D_RWeek,D_RStorage,D_Goods,D_Num) ' +
              'Values(''$CD'',''$RD'',''$RW'',''$CW'',''$GD'',$Num)';
      nStr := MacroValue(nStr, [MI('$TB', sTable_ChuKuDtl), MI('$CD', nID),
              MI('$RD', FRecord), MI('$GD', EditName.EditValue[0]),
              MI('$Num', FloatToStr(FNum)), MI('$RW', FWeek),
              MI('$CW', FStgeID)]);
      FDM.ExecuteSQL(nStr);
    end;

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOk;
    ShowMsg('出库成功', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('出库操作失败', sHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormChuKu, TfFormChuKu.FormID);
end.
