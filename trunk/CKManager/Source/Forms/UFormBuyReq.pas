{*******************************************************************************
  作者: dmzn@163.com 2011-6-7
  描述: 采购申请
*******************************************************************************}
unit UFormBuyReq;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, UDataModule, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxMCListBox,
  cxTextEdit, cxCheckComboBox, cxLabel, cxMaskEdit, cxDropDownEdit,
  dxLayoutControl, StdCtrls, cxMemo, cxGroupBox;

type
  TfFormBuyReq = class(TfFormNormal)
    dxLayout1Item11: TdxLayoutItem;
    EditPart: TcxComboBox;
    cxLabel1: TcxLabel;
    dxLayout1Item5: TdxLayoutItem;
    EditType: TcxCheckComboBox;
    dxLayout1Item3: TdxLayoutItem;
    EditDesc: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    ListGoods: TcxMCListBox;
    dxLayout1Item6: TdxLayoutItem;
    GroupEdit: TcxGroupBox;
    EditNum: TcxTextEdit;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    EditMemo: TcxMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditTypePropertiesEditValueChanged(Sender: TObject);
    procedure GroupEditExit(Sender: TObject);
    procedure ListGoodsDblClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FNowWeek,FWeekName: string;
    //周期
    FDepartment: string;
    //部门编号
    procedure InitFormData;
    //载入数据
    function GetGoodsItem(const nIdx: Integer): Integer;
    //检索数据
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
  USysConst, USysBusiness, USysGrid;

type
  TGoodItem = record
    FID: string;
    FName: string;
    FType: string;
    FUnit: string;
    FGuiGe: string;
    FCaiZhi: string;
    FMemo: string;

    FValue: Double;
    FValid: Boolean;
  end;

var
  gGoodItems: array of TGoodItem;
  //全局使用

class function TfFormBuyReq.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormBuyReq.Create(Application) do
    begin
      Caption := '采购申请';
      FNowWeek := nP.FParamA;
      FWeekName := nP.FParamB;
      FDepartment := '';
      
      InitFormData;
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormBuyReq.Create(Application) do
    begin
      Caption := '采购申请 - 修改';
      FNowWeek := nP.FParamA;
      FWeekName := nP.FParamB;
      FDepartment := nP.FParamC;

      InitFormData;
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
  end;
end;

class function TfFormBuyReq.FormID: integer;
begin
  Result := cFI_FormBuyReq;
end;

procedure TfFormBuyReq.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  SetLength(gGoodItems, 0);
  //xxxxx
  
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, ListGoods, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormBuyReq.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, ListGoods, nIni);
  finally
    nIni.Free;
  end;

  ReleaseCtrlData(Self);
end;

//------------------------------------------------------------------------------
procedure TfFormBuyReq.InitFormData;
var nStr: string;
    i,nIdx: Integer;
begin
  nStr := '周期:[ %s ] 申请人:[ %s ]';
  EditDesc.Text := Format(nStr, [FWeekName, gSysParam.FUserID]);
  
  if EditPart.Properties.Items.Count < 1 then
  begin
    nStr := 'D_ID=Select D_ID,D_Name From %s Order By D_PY';
    nStr := Format(nStr, [sTable_Department]);

    FDM.FillStringsData(EditPart.Properties.Items, nStr, -1, '.');
    AdjustStringsItem(EditPart.Properties.Items, False);
  end;

  if EditType.Properties.Items.Count < 1 then
  begin
    nStr := 'Select B_Text From %s Where B_Group=''%s'' Order By B_Index';
    nStr := Format(nStr, [sTable_BaseInfo, sFlag_GoodsTpItem]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        with EditType.Properties.Items.Add do
        begin
          Description := Fields[0].AsString;
        end;
        
        Next;
      end;
    end;
  end;

  if Length(gGoodItems) < 1 then
  begin
    nStr := 'Select G_ID,G_Name,G_Unit,G_GType,G_CaiZhi,G_GuiGe From %s ' +
            'Order By G_PY';
    nStr := Format(nStr, [sTable_Goods]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      SetLength(gGoodItems, RecordCount);
      nIdx := 0;
      First;

      while not Eof do
      begin
        with gGoodItems[nIdx] do
        begin
          FID := FieldByName('G_ID').AsString;
          FName := FieldByName('G_Name').AsString;
          FType := FieldByName('G_GType').AsString;

          FUnit := FieldByName('G_Unit').AsString;
          FCaiZhi := FieldByName('G_CaiZhi').AsString;
          FGuiGe := FieldByName('G_GuiGe').AsString;

          FMemo := '';
          FValue := 0;
          FValid := False;
        end;

        Inc(nIdx);
        Next;
      end;
    end;
  end;

  if FDepartment <> '' then
  begin
    SetCtrlData(EditPart, FDepartment);
    EditPart.Properties.ReadOnly := True;

    nStr := 'Select R_Goods,R_Num,R_Memo From %s ' +
            'Where R_Week=''%s'' And R_Department=''%s''';
    nStr := Format(nStr, [sTable_BuyReq, FNowWeek, FDepartment]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        for nIdx:=Low(gGoodItems) to High(gGoodItems) do
         with gGoodItems[nIdx] do
          if FID = Fields[0].AsString then
          begin
            FValue := Fields[1].AsFloat;
            FMemo := Fields[2].AsString;

            for i:=EditType.Properties.Items.Count - 1 downto 0 do
            if EditType.Properties.Items[i].Description = FType then
            begin
              EditType.States[i] := cbsChecked;
              Break;
            end;

            Break;
          end;
        //xxxxx

        Next;
      end;
    end;
  end;
end;

//Desc: 合并单挑记录的现实内容
function CombinText(const nItem: Integer; nSplit: string): string;
begin
  with gGoodItems[nItem] do
  begin
    Result := CombinStr([FID, FName, FloatToStr(FValue), FUnit + ' ',
              FGuiGe + ' ', FCaiZhi + ' ', FMemo + ' ',
              IntToStr(nItem)], nSplit);
    //xxxxx
  end;
end;

//Desc: 选中分类
procedure TfFormBuyReq.EditTypePropertiesEditValueChanged(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
begin
  nList := nil;
  ListGoods.Items.BeginUpdate;
  try
    for nIdx:=Low(gGoodItems) to High(gGoodItems) do
      gGoodItems[nIdx].FValid := False;
    ListGoods.Items.Clear;
    
    nList := TStringList.Create;
    if SplitStr(EditType.Text, nList, 0, EditType.Properties.Delimiter) then
    begin 
      for nIdx:=Low(gGoodItems) to High(gGoodItems) do
      with gGoodItems[nIdx] do
      begin
        FValid := nList.IndexOf(FType) > -1;
        if not FValid then Continue;

        nStr := CombinText(nIdx, ListGoods.Delimiter);
        ListGoods.Items.Add(nStr);
      end;
    end;
  finally
    nList.Free;
    ListGoods.Items.EndUpdate;
  end;
end;

//Desc: 检索nIdx对应的数据项索引
function TfFormBuyReq.GetGoodsItem(const nIdx: Integer): Integer;
var nList: TStrings;
begin
  Result := -1;
  nList := TStringList.Create;
  try
    if SplitStr(ListGoods.Items[nIdx], nList, 8, ListGoods.Delimiter) then
     if IsNumber(nList[7], False) then Result := StrToInt(nList[7]);
  finally
    nList.Free;
  end;
end;

//Desc: 显示编辑
procedure TfFormBuyReq.ListGoodsDblClick(Sender: TObject);
var nIdx: Integer;
    nRect: TRect;
begin
  if ListGoods.ItemIndex < 0 then Exit;
  nIdx := ListGoods.ItemIndex;
  nRect := ListGoods.ItemRect(nIdx+1);

  GroupEdit.Tag := nIdx;  
  nIdx := GetGoodsItem(nIdx);
  if nIdx < 0 then Exit;

  with gGoodItems[nIdx] do
  begin
    GroupEdit.Caption := FName;
    EditNum.Text := FloatToStr(FValue);
    EditMemo.Text := FMemo;
  end;

  GroupEdit.Left := ListGoods.Left + ListGoods.Width - GroupEdit.Width - 3;
  GroupEdit.Top := ListGoods.Top + nRect.Top + 3;

  GroupEdit.BringToFront;
  ActiveControl := EditNum;
end;

procedure TfFormBuyReq.GroupEditExit(Sender: TObject);
var nIdx: Integer;
begin
  GroupEdit.SendToBack;
  nIdx := GetGoodsItem(GroupEdit.Tag);

  if nIdx < 0 then Exit;
  if not IsNumber(EditNum.Text, True) then Exit;

  with gGoodItems[nIdx] do
  begin
    FValue := StrToFloat(EditNum.Text);
    FMemo := Trim(EditMemo.Text);

    ListGoods.Items[GroupEdit.Tag] := CombinText(nIdx, ListGoods.Delimiter);
    //xxxxx
  end;

end;

//Desc: 验证数据
function TfFormBuyReq.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nIdx: Integer;
begin
  Result := True;

  if Sender = EditPart then
  begin
    Result := EditPart.ItemIndex > -1;
    nHint := '请选择申请部门';
  end else

  if Sender = ListGoods then
  begin
    for nIdx:=Low(gGoodItems) to High(gGoodItems) do
      if gGoodItems[nIdx].FValid and (gGoodItems[nIdx].FValue > 0) then Exit;
    //xxxxx

    Result := False;
    nHint := '请选择要申请的物品';
  end;
end;

//Desc: 保存
procedure TfFormBuyReq.BtnOKClick(Sender: TObject);
var nIdx: Integer;
    nStr,nSQL: string;
begin
  if not IsDataValid then Exit;

  nStr := 'Select Top 1 * From %s Where R_Week=''%s'' And R_Department=''%s''';
  nStr := Format(nStr, [sTable_BuyReq, FNowWeek, GetCtrlData(EditPart)]);
  nIdx := FDM.QueryTemp(nStr).RecordCount;

  if nIdx > 0 then
  begin
    nStr := '该部门已经提交过申请,是否要覆盖?';
    if not QueryDlg(nStr, sAsk, Handle) then Exit;
  end;

  FDM.ADOConn.BeginTrans;
  try
    if nIdx > 0 then
    begin
      nStr := 'Delete From %s Where R_Week=''%s'' And R_Department=''%s''';
      nStr := Format(nStr, [sTable_BuyReq, FNowWeek, GetCtrlData(EditPart)]);
      FDM.ExecuteSQL(nStr);
    end;

    nSQL := 'Insert Into %s(R_Week,R_Department,R_Goods,R_Num,R_Date,' +
            'R_Man,R_Memo) Values(''%s'',''%s'',''$GD'',$Num,%s,''%s'',''$MO'')';
    nSQL := Format(nSQL, [sTable_BuyReq, FNowWeek, GetCtrlData(EditPart),
            FDM.SQLServerNow, gSysParam.FUserID]);
    //xxxxx

    for nIdx:=Low(gGoodItems) to High(gGoodItems) do
    with gGoodItems[nIdx] do
    begin
      if FValue < 1 then Continue;
      //invalid item

      nStr := MacroValue(nSQL, [MI('$GD', FID), MI('$Num', FloatToStr(FValue)),
              MI('$MO', FMemo)]);
      FDM.ExecuteSQL(nStr);
    end;

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOk;
    ShowMsg('申请提交成功', sError);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('数据保存失败', sError);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormBuyReq, TfFormBuyReq.FormID);
end.
