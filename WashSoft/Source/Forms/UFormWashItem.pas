{*******************************************************************************
  作者: dmzn@163.com 2015-06-26
  描述: 添加收衣项
*******************************************************************************}
unit UFormWashItem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxDropDownEdit;

type
  TWashItem = record
    FRecord: string;
    FTypeID: string;
    FName: string;
    FUnit: string;
    FWashType: string;
    FNumber: Integer;
    FNumOut: Integer;
    FPrice: Double;
    FColor: string;
    FMemo: string;

    FEnable: Boolean;
    FSelected: Boolean;
  end;

  TWashItems = array of TWashItem;

  TfFormWashItem = class(TfFormNormal)
    EditName: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditMemo: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditUnit: TcxComboBox;
    dxLayout1Item7: TdxLayoutItem;
    EditWashType: TcxComboBox;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    EditNum: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Item9: TdxLayoutItem;
    EditColor: TcxComboBox;
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditNameKeyPress(Sender: TObject; var Key: Char);
    procedure EditNumKeyPress(Sender: TObject; var Key: Char);
    procedure EditUnitKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FWashItem: TWashItem;
    procedure InitFormData;
    procedure LoadUIWashItem;
  public
    { Public declarations }
    class function FormID: integer; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

var
  gWashItems: TWashItems;
  gWashEditor: TfFormWashItem = nil;
  gWashItemRefresh: procedure of Object = nil;
  //全局使用

procedure ShowWashItemEditor;
procedure CloseWashItemEditor;
//入口函数

implementation

{$R *.dfm}
uses
  UMgrControl, ULibFun, USysDB, USysConst, UDataModule, UFormCtrl, USysBusiness;

//Desc: 显示编辑器
procedure ShowWashItemEditor;
begin
  if not Assigned(gWashEditor) then
  begin
    gWashEditor := TfFormWashItem.Create(Application);
    gWashEditor.InitFormData;
  end;

  gWashEditor.Show;
end;

//Desc: 关闭编辑器
procedure CloseWashItemEditor;
begin
  if Assigned(gWashEditor) then
    gWashEditor.Free;
  gWashEditor := nil;
end;

class function TfFormWashItem.FormID: integer;
begin
  Result := 0;
end;

procedure TfFormWashItem.FormCreate(Sender: TObject);
begin
  inherited;
  LoadFormConfig(Self);
end;

procedure TfFormWashItem.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SaveFormConfig(Self);

  Action := caFree; 
  gWashEditor := nil;
end;

procedure TfFormWashItem.InitFormData;
var nIdx: Integer;
    nBool: Boolean;
begin
  BtnOK.Enabled := False;
  FWashItem.FNumOut := 0;
  //init flag
  
  for nIdx:=Low(gWashItems) to High(gWashItems) do
  if gWashItems[nIdx].FSelected then
  begin
    FWashItem := gWashItems[nIdx];
    Break;
  end;

  LoadUIWashItem;
  nBool := FWashItem.FNumOut > 0;
  //取衣时,不可更改数据

  for nIdx:=dxLayout1.ControlCount - 1 downto 0 do
  begin
    if dxLayout1.Controls[nIdx] is TcxTextEdit then
      (dxLayout1.Controls[nIdx] as TcxTextEdit).Properties.ReadOnly := nBool;
    //xxxxx

    if dxLayout1.Controls[nIdx] is TcxComboBox then
      (dxLayout1.Controls[nIdx] as TcxComboBox).Properties.ReadOnly := nBool;
    //xxxxx
  end;

  EditNum.Properties.ReadOnly := False;
  //数量可调

  LoadBaseInfoByGroup(sFlag_GroupUnit, EditUnit.Properties.Items);
  LoadBaseInfoByGroup(sFlag_GroupColor, EditColor.Properties.Items);
  LoadBaseInfoByGroup(sFlag_GroupType, EditWashType.Properties.Items);
end;

procedure TfFormWashItem.EditNameKeyPress(Sender: TObject; var Key: Char);
var nStr: string;
begin
  if Key = #13 then
  begin
    Key := #0;
    BtnOK.Enabled := False;
    EditNum.Text := '0';

    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    nStr := 'Select * From %s Where ' +
            'T_Name Like ''%%%s%%'' Or T_Py Like ''%%%s%%''';
    nStr := Format(nStr, [sTable_WashType, EditName.Text, EditName.Text]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then
      begin
        ShowMsg('没有找到该衣物', sHint);
        Exit;
      end;

      with FWashItem do
      begin
        FRecord := '';
        FTypeID := FieldByName('T_ID').AsString;
        FName := FieldByName('T_Name').AsString;
        FUnit := FieldByName('T_Unit').AsString;
        FWashType := FieldByName('T_WashType').AsString;
        
        FNumber := 0;
        FNumOut := 0;
        FPrice := FieldByName('T_Price').AsFloat;
        FColor := '';
        FMemo := '';

        FEnable := True;
        FSelected := False;
      end;
    end;
           
    ActiveControl := EditNum;
    EditNum.SelectAll;
    LoadUIWashItem;
  end;
end;

procedure TfFormWashItem.EditNumKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;

    if Sender = EditWashType then
         ActiveControl := BtnOK
    else SwitchFocusCtrl(Self, True);
  end;
end;

procedure TfFormWashItem.EditUnitKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    Key := 0;

    if Sender = EditUnit then
     if EditUnit.Properties.Items.IndexOf(EditUnit.Text) >= 0 then
     begin
       SaveBaseInfoByGroup(sFlag_GroupUnit, EditUnit.Text, True);
       LoadBaseInfoByGroup(sFlag_GroupUnit, EditUnit.Properties.Items);
       EditUnit.Text := '';
     end;

    if Sender = EditColor then
     if EditColor.Properties.Items.IndexOf(EditColor.Text) >= 0 then
     begin
       SaveBaseInfoByGroup(sFlag_GroupColor, EditColor.Text, True);
       LoadBaseInfoByGroup(sFlag_GroupColor, EditColor.Properties.Items);
       EditColor.Text := '';
     end;

    if Sender = EditWashType then
     if EditWashType.Properties.Items.IndexOf(EditWashType.Text) >= 0 then
     begin
       SaveBaseInfoByGroup(sFlag_GroupType, EditWashType.Text, True);
       LoadBaseInfoByGroup(sFlag_GroupType, EditWashType.Properties.Items);
       EditWashType.Text := '';
     end;
  end;
end;

procedure TfFormWashItem.LoadUIWashItem;
begin
  with FWashItem do
  begin
    EditName.Text := FName;
    EditNum.Text := IntToStr(FNumber);
    EditUnit.Text := FUnit;
    EditColor.Text := FColor;
    EditWashType.Text := FWashType;
    EditMemo.Text := FMemo;

    BtnOK.Enabled := True;
    //valid
  end;
end;

function TfFormWashItem.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
var nVal: Double;
begin
  Result := True;

  if Sender = EditNum then
  begin
    Result := IsNumber(EditNum.Text, False);
    nHint := '数量为>0的数字';
    if not Result then Exit;

    nVal := StrToInt(EditNum.Text);
    Result := nVal > 0;
    if not Result then Exit;

    Result := (FWashItem.FNumOut = 0) or (FWashItem.FNumOut >= nVal);
    nHint := '超出可领取件数';
  end else

  if Sender = EditUnit then
  begin
    EditUnit.Text := Trim(EditUnit.Text);
    Result := EditUnit.Text <> '';
    nHint := '请填写单位';

    if Result and (EditUnit.Properties.Items.IndexOf(EditUnit.Text) < 0) then
    begin
      SaveBaseInfoByGroup(sFlag_GroupUnit, EditUnit.Text);
      LoadBaseInfoByGroup(sFlag_GroupUnit, EditUnit.Properties.Items);
    end;
  end else

  if Sender = EditColor then
  begin
    EditColor.Text := Trim(EditColor.Text);
    Result := EditColor.Text <> '';
    nHint := '请填写颜色';

    if Result and (EditColor.Properties.Items.IndexOf(EditColor.Text) < 0) then
    begin
      SaveBaseInfoByGroup(sFlag_GroupColor, EditColor.Text);
      LoadBaseInfoByGroup(sFlag_GroupColor, EditColor.Properties.Items);
    end;
  end else

  if Sender = EditWashType then
  begin
    EditWashType.Text := Trim(EditWashType.Text);
    Result := EditWashType.Text <> '';
    nHint := '请填写清理方式';

    if Result and (EditWashType.Properties.Items.IndexOf(EditWashType.Text) < 0) then
    begin
      SaveBaseInfoByGroup(sFlag_GroupType, EditWashType.Text);
      LoadBaseInfoByGroup(sFlag_GroupType, EditWashType.Properties.Items);
    end;
  end;
end;

procedure TfFormWashItem.BtnOKClick(Sender: TObject);
var nIdx: Integer;
begin
  if not IsDataValid then Exit;

  with FWashItem do
  begin
    FNumber := StrToInt(EditNum.Text);
    FUnit := EditUnit.Text;
    FColor := EditColor.Text;
    FWashType := EditWashType.Text;
    FMemo := EditMemo.Text;
  end;

  for nIdx:=Low(gWashItems) to High(gWashItems) do
  if gWashItems[nIdx].FSelected then
  begin
    gWashItems[nIdx] := FWashItem;
    gWashItemRefresh;
    ShowMsg('修改成功', sHint);
    
    Close;
    Exit;
  end;

  nIdx := Length(gWashItems);
  SetLength(gWashItems, nIdx + 1);
  gWashItems[nIdx] := FWashItem;

  gWashItemRefresh;
  ShowMsg('添加成功', sHint);

  with FWashItem do
  begin
    FName := '';
    FWashItem.FNumber := 0;
    LoadUIWashItem;
  end;

  ActiveControl := EditName;
  BtnOk.Enabled := False;
end;

end.
