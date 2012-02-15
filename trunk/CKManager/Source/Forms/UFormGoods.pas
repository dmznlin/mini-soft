{*******************************************************************************
  作者: dmzn@163.com 2011-6-7
  描述: 物品管理
*******************************************************************************}
unit UFormGoods;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxButtonEdit, cxLabel, cxTextEdit, cxContainer, cxEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, cxMCListBox;

type
  TfFormGoods = class(TfFormNormal)
    dxLayout1Item7: TdxLayoutItem;
    EditName: TcxTextEdit;
    EditType: TcxComboBox;
    dxLayout1Item13: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Item3: TdxLayoutItem;
    InfoItems: TcxComboBox;
    dxLayout1Item4: TdxLayoutItem;
    InfoList1: TcxMCListBox;
    dxLayout1Item5: TdxLayoutItem;
    EditInfo: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    BtnAdd: TButton;
    dxLayout1Item8: TdxLayoutItem;
    BtnDel: TButton;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Item11: TdxLayoutItem;
    EditGG: TcxComboBox;
    dxLayout1Item12: TdxLayoutItem;
    EditCZ: TcxComboBox;
    dxLayout1Item14: TdxLayoutItem;
    EditGType: TcxComboBox;
    dxLayout1Group6: TdxLayoutGroup;
    dxLayout1Item9: TdxLayoutItem;
    EditUnit: TcxComboBox;
    dxLayout1Item15: TdxLayoutItem;
    EditOStyle: TcxComboBox;
    dxLayout1Group7: TdxLayoutGroup;
    dxLayout1Group8: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
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
  IniFiles, ULibFun, UFormCtrl, UAdjustForm, UFormBase, UMgrControl, USysDB, 
  USysConst, UDataModule, USysBusiness, USysGrid;

var
  gForm: TfFormGoods = nil;
  //全局使用

class function TfFormGoods.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormGoods.Create(Application) do
    begin
      FRecordID := '';
      Caption := '物品 - 添加';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormGoods.Create(Application) do
    begin
      Caption := '物品 - 修改';
      FRecordID := nP.FParamA;

      InitFormData(FRecordID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
      begin
        gForm := TfFormGoods.Create(Application);
        with gForm do
        begin
          Caption := '物品 - 查看';
          FormStyle := fsStayOnTop; 
          BtnOK.Visible := False;
        end;
      end;

      with gForm  do
      begin
        FRecordID := nP.FParamA;
        InitFormData(FRecordID);
        if not Showing then Show;
      end;
    end;
   cCmd_FormClose:
    begin
      if Assigned(gForm) then FreeAndNil(gForm);
    end;
  end;
end;

class function TfFormGoods.FormID: integer;
begin
  Result := cFI_FormGoods;
end;

procedure TfFormGoods.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, InfoList1, nIni);

    ResetHintAllForm(Self, 'T', sTable_Goods);
    AdjustCtrlData(Self);
  finally
    nIni.Free;
  end;
end;

procedure TfFormGoods.FormClose(Sender: TObject;
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

  if not (fsModal in FormState) then
  begin
    gForm := nil;
    Action := caFree;
  end;
  ReleaseCtrlData(Self);
end;

//------------------------------------------------------------------------------
procedure TfFormGoods.InitFormData(const nID: string);
var nStr: string;
begin
  if EditGType.Properties.Items.Count < 1 then
  begin
    nStr := 'Select B_Text From %s Where B_Group=''%s'' Order By B_Index';
    nStr := Format(nStr, [sTable_BaseInfo, sFlag_GoodsTpItem]);

    LoadDataToList(FDM.QueryTemp(nStr), EditGType.Properties.Items, '', -1);
    AdjustStringsItem(EditGType.Properties.Items, False);
  end;

  if EditUnit.Properties.Items.Count < 1 then
  begin
    nStr := 'U_Name=Select U_PY,U_Name From %s Where U_Type=''%s'' Order By U_PY';
    nStr := Format(nStr, [sTable_Unit, sFlag_DanWei]);

    FDM.FillStringsData(EditUnit.Properties.Items, nStr, -1, '.');
    EditUnit.Properties.Items.Insert(0, '');
    AdjustStringsItem(EditUnit.Properties.Items, False);
  end;

  if EditGG.Properties.Items.Count < 1 then
  begin
    nStr := 'U_Name=Select U_PY,U_Name From %s Where U_Type=''%s'' Order By U_PY';
    nStr := Format(nStr, [sTable_Unit, sFlag_GuiGe]);

    FDM.FillStringsData(EditGG.Properties.Items, nStr, -1, '.');
    EditGG.Properties.Items.Insert(0, '');
    AdjustStringsItem(EditGG.Properties.Items, False);
  end;

  if EditCZ.Properties.Items.Count < 1 then
  begin
    nStr := 'U_Name=Select U_PY,U_Name From %s Where U_Type=''%s'' Order By U_PY';
    nStr := Format(nStr, [sTable_Unit, sFlag_CaiZhi]);

    FDM.FillStringsData(EditCZ.Properties.Items, nStr, -1, '.');
    EditCZ.Properties.Items.Insert(0, '');
    AdjustStringsItem(EditCZ.Properties.Items, False);
  end;

  if nID <> '' then
  begin
    nStr := 'Select * From %s Where G_ID=''%s''';
    nStr := Format(nStr, [sTable_Goods, nID]);

    LoadDataToCtrl(FDM.QueryTemp(nStr), Self);
    LoadItemExtInfo(InfoList1.Items, sFlag_GoodsTpItem, nID);
  end;
end;

//Desc: 验证数据
function TfFormGoods.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nStr: string;
begin
  Result := True;

  if Sender = EditName then
  begin
    nHint := '请填写有效的名称';
    EditName.Text := Trim(EditName.Text);

    Result := EditName.Text <> '';
    if not Result then Exit;

    nStr := 'Select Count(*) From %s Where G_Name=''%s'' And G_Type=''%s''';
    nStr := Format(nStr, [sTable_Goods, EditName.Text, GetCtrlData(EditType)]);

    if FRecordID <> '' then
      nStr := nStr + Format(' And G_ID<>''%s''', [FRecordID]);
    //xxxxx

    with FDM.QueryTemp(nStr) do
    begin
      nHint := '品种重复';
      Result := Fields[0].AsInteger < 1;
    end;
  end;
end;

procedure TfFormGoods.BtnAddClick(Sender: TObject);
begin
  InfoItems.Text := Trim(InfoItems.Text);
  if InfoItems.Text = '' then
  begin
    InfoItems.SetFocus;
    ShowMsg('请填写有效的信息项', sHint); Exit;
  end;

  EditInfo.Text := Trim(EditInfo.Text);
  if EditInfo.Text = '' then
  begin
    EditInfo.SetFocus;
    ShowMsg('请填写有效的信息内容', sHint); Exit;
  end;

  InfoList1.Items.Add(InfoItems.Text + InfoList1.Delimiter + EditInfo.Text);
  ActiveControl := InfoItems;
end;

procedure TfFormGoods.BtnDelClick(Sender: TObject);
var nIdx: integer;
begin
  if InfoList1.ItemIndex < 0 then
  begin
    ShowMsg('请选择要删除的内容', sHint); Exit;
  end;

  nIdx := InfoList1.ItemIndex;
  InfoList1.Items.Delete(InfoList1.ItemIndex);

  if nIdx >= InfoList1.Count then Dec(nIdx);
  InfoList1.ItemIndex := nIdx;
  ShowMsg('信息项已删除', sHint);
end;

//Desc: 保存
procedure TfFormGoods.BtnOKClick(Sender: TObject);
var nList: TStrings;
    i: integer;
    nStr,nSQL, nId: string;
begin
  if not IsDataValid then Exit;

  nList := TStringList.Create;
  nList.Text := Format('G_PY=''%s''', [GetPinYinOfStr(EditName.Text)]);

  if FRecordID = '' then
  begin
     nSQL := MakeSQLByForm(Self, sTable_Goods, '', True, nil, nList);
  end else
  begin
    nStr := 'G_ID=''' + FRecordID + '''';
    nSQL := MakeSQLByForm(Self, sTable_Goods, nStr, False, nil, nList);
  end;

  nList.Free;
  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nSQL);

    if FRecordID = '' then
    begin
      i := FDM.GetFieldMax(sTable_Goods, 'R_ID');
      nID := FDM.GetSerialID2('WP', sTable_Goods, 'R_ID', 'G_ID', i);

      nSQL := 'Update %s Set G_ID=''%s'' Where R_ID=%d';
      nSQL := Format(nSQL, [sTable_Goods, nID, i]);
      FDM.ExecuteSQL(nSQL);
    end else nID := FRecordID;

    SaveItemExtInfo(InfoList1.Items, sFlag_GoodsTpItem, nID, FRecordID <> '');
    //ext info

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOK;
    ShowMsg('数据已保存', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('数据保存失败', sError);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormGoods, TfFormGoods.FormID);
end.
