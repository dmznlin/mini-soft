{*******************************************************************************
  作者: dmzn@163.com 2011-6-7
  描述: 部门单位管理
*******************************************************************************}
unit UFormDepart;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxButtonEdit, cxLabel, cxTextEdit, cxContainer, cxEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, cxMCListBox, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox;

type
  TfFormDepart = class(TfFormNormal)
    dxLayout1Item7: TdxLayoutItem;
    EditName: TcxTextEdit;
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
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    EditPPart: TcxLookupComboBox;
    dxLayout1Item11: TdxLayoutItem;
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
    procedure GetData(Sender: TObject; var nData: string);
    function SetData(Sender: TObject; const nData: string): Boolean;
    //数据处理
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
  USysConst, UDataModule, USysBusiness, USysGrid, USysLookupAdapter;

var
  gForm: TfFormDepart = nil;
  //全局使用

class function TfFormDepart.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormDepart.Create(Application) do
    begin
      FRecordID := '';
      Caption := '部门 - 添加';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormDepart.Create(Application) do
    begin
      Caption := '部门 - 修改';
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
        gForm := TfFormDepart.Create(Application);
        with gForm do
        begin
          Caption := '部门 - 查看';
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

class function TfFormDepart.FormID: integer;
begin
  Result := cFI_FormDepartment;
end;

procedure TfFormDepart.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, InfoList1, nIni);
    ResetHintAllForm(Self, 'T', sTable_Department);
  finally
    nIni.Free;
  end;
end;

procedure TfFormDepart.FormClose(Sender: TObject;
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
  gLookupComboBoxAdapter.DeleteGroup(Name);
end;

//------------------------------------------------------------------------------ .
procedure TfFormDepart.GetData(Sender: TObject; var nData: string);
begin
  if Sender = EditPPart then
  begin
    if VarIsNull(EditPPart.EditValue) then
         nData := ''
    else nData := EditPPart.EditValue;
  end;
end;

function TfFormDepart.SetData(Sender: TObject; const nData: string): Boolean;
begin
  Result := False;

  if Sender = EditPPart then
  begin
    Result := True;
    EditPPart.EditValue := nData;
  end;
end;

procedure TfFormDepart.InitFormData(const nID: string);
var nStr,nSID: string;
    nItem: TLookupComboBoxItem;
begin
  if not Assigned(EditPPart.Properties.ListSource) then
  begin
    nStr := 'Select D_ID,D_PY,D_Name From %s ';
    if nID <> '' then
      nStr := nStr + Format('Where D_ID<>''%s'' ', [nID]);
    //xxxxx

    nStr := nStr + 'Order By D_PY';
    nStr := Format(nStr, [sTable_Department]);

    nSID := Name + 'Part';
    nItem := gLookupComboBoxAdapter.MakeItem(Name, nSID, nStr, 'D_ID', 1,
             [MI('D_PY', '简写'), MI('D_Name', '名称')]);
    gLookupComboBoxAdapter.AddItem(nItem);
    gLookupComboBoxAdapter.BindItem(nSID, EditPPart);
  end;

  if nID <> '' then
  begin
    nStr := 'Select * From %s Where D_ID=''%s''';
    nStr := Format(nStr, [sTable_Department, nID]);

    LoadDataToCtrl(FDM.QueryTemp(nStr), Self, '', SetData);
    LoadItemExtInfo(InfoList1.Items, sFlag_DepartItem, nID);
  end;
end;

//Desc: 验证数据
function TfFormDepart.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    Result := EditName.Text <> '';
    nHint := '请填写有效的名称';
  end;
end;

procedure TfFormDepart.BtnAddClick(Sender: TObject);
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

procedure TfFormDepart.BtnDelClick(Sender: TObject);
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
procedure TfFormDepart.BtnOKClick(Sender: TObject);
var nList: TStrings;
    i: integer;
    nStr,nSQL, nId: string;
begin
  if not IsDataValid then Exit;

  nList := TStringList.Create;
  nList.Text := Format('D_PY=''%s''', [GetPinYinOfStr(EditName.Text)]);

  if FRecordID = '' then
  begin
     nSQL := MakeSQLByForm(Self, sTable_Department, '', True, GetData, nList);
  end else
  begin
    nStr := 'D_ID=''' + FRecordID + '''';
    nSQL := MakeSQLByForm(Self, sTable_Department, nStr, False, GetData, nList);
  end;

  nList.Free;
  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nSQL);

    if FRecordID = '' then
    begin
      i := FDM.GetFieldMax(sTable_Department, 'R_ID');
      nID := FDM.GetSerialID2('BM', sTable_Department, 'R_ID', 'D_ID', i);

      nSQL := 'Update %s Set D_ID=''%s'' Where R_ID=%d';
      nSQL := Format(nSQL, [sTable_Department, nID, i]);
      FDM.ExecuteSQL(nSQL);
    end else nID := FRecordID;

    SaveItemExtInfo(InfoList1.Items, sFlag_DepartItem, nID, FRecordID <> '');
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
  gControlManager.RegCtrl(TfFormDepart, TfFormDepart.FormID);
end.
