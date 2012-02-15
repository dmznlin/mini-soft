{*******************************************************************************
  作者: dmzn@163.com 2009-09-13
  描述: 车辆管理
*******************************************************************************}
unit UFormTruckInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, 
  cxMemo, cxTextEdit, cxDropDownEdit, cxContainer, cxEdit, cxMaskEdit,
  cxCalendar, cxGraphics, cxMCListBox, cxImage, cxButtonEdit,
  cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFormTruckInfo = class(TfFormNormal)
    EditNo: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Item6: TdxLayoutItem;
    EditType: TcxComboBox;
    dxLayout1Item13: TdxLayoutItem;
    EditPhone: TcxTextEdit;
    dxLayout1Item14: TdxLayoutItem;
    EditOwner: TcxTextEdit;
    dxLayout1Item16: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group2: TdxLayoutGroup;
    ListInfo1: TcxMCListBox;
    dxLayout1Item3: TdxLayoutItem;
    EditInfo: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    InfoItems: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    BtnDel: TButton;
    dxLayout1Item8: TdxLayoutItem;
    BtnAdd: TButton;
    dxLayout1Item9: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure ListInfo1Click(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  protected
    FRecordID: string;
    //记录编号
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    //基类方法
    procedure InitFormData(const nID: string);
    //初始化数据
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, UMgrControl, UAdjustForm, UFormCtrl, ULibFun, UDataModule, 
  UFormBase, USysFun, USysGrid, USysConst, USysDB;

var
  gForm: TfFormTruckInfo = nil;
  
//------------------------------------------------------------------------------
class function TfFormTruckInfo.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormTruckInfo.Create(Application) do
    begin
      FRecordID := '';
      Caption := '车辆信息 - 添加';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormTruckInfo.Create(Application) do
    begin
      FRecordID := nP.FParamA;
      Caption := '车辆信息 - 修改';

      InitFormData(FRecordID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
      begin
        gForm := TfFormTruckInfo.Create(Application);
        gForm.Caption := '车辆信息 - 查看';
        gForm.FormStyle := fsStayOnTop;

        gForm.BtnOK.Visible := False;
        gForm.BtnAdd.Enabled := False;
        gForm.BtnDel.Enabled := False; 
      end;

      with gForm do
      begin
        FRecordID := nP.FParamA;
        InitFormData(FRecordID);
        if not gForm.Showing then gForm.Show;
      end;
    end;
   cCmd_FormClose:
    begin
      if Assigned(gForm) then FreeAndNil(gForm);
    end;
  end;
end;

class function TfFormTruckInfo.FormID: integer;
begin
  Result := cFI_FormTruckInfo;
end;

procedure TfFormTruckInfo.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  dxGroup1.AlignHorz := ahClient;
  AdjustCtrlData(Self);
  ResetHintAllCtrl(Self, 'T', sTable_TruckInfo);

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self);
    LoadMCListBoxConfig(Name, ListInfo1);
  finally
    nIni.Free;
  end;
end;

procedure TfFormTruckInfo.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self);
    SaveMCListBoxConfig(Name, ListInfo1);
  finally
    nIni.Free;
  end;

  gForm := nil;
  Action := caFree;
  ReleaseCtrlData(Self);
end;

//------------------------------------------------------------------------------
//Desc: 添加信息项
procedure TfFormTruckInfo.BtnAddClick(Sender: TObject);
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

  ListInfo1.Items.Add(InfoItems.Text + ListInfo1.Delimiter + EditInfo.Text);
end;

//Desc: 删除信息项
procedure TfFormTruckInfo.BtnDelClick(Sender: TObject);
var nIdx: integer;
begin
  if ListInfo1.ItemIndex < 0 then
  begin
    ShowMsg('请选择要删除的内容', sHint); Exit;
  end;

  nIdx := ListInfo1.ItemIndex;
  ListInfo1.Items.Delete(ListInfo1.ItemIndex);

  if nIdx >= ListInfo1.Count then Dec(nIdx);
  ListInfo1.ItemIndex := nIdx;
  ShowMsg('信息项已删除', sHint);
end;

procedure TfFormTruckInfo.ListInfo1Click(Sender: TObject);
var nStr: string;
    nPos: integer;
begin
  if ListInfo1.ItemIndex > -1 then
  begin
    nStr := ListInfo1.Items[ListInfo1.ItemIndex];
    nPos := Pos(ListInfo1.Delimiter, nStr);

    InfoItems.Text := Copy(nStr, 1, nPos - 1);
    System.Delete(nStr, 1, nPos + Length(ListInfo1.Delimiter) - 1);
    EditInfo.Text := nStr;
  end;
end;

procedure TfFormTruckInfo.InitFormData(const nID: string);
var nStr: string;
begin
  if EditType.Properties.Items.Count < 1 then
  begin
    EditType.Clear;
    nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                        MI('$Name', sFlag_TruckType)]);
    //数据字典中车辆类型

    with FDM.QueryTemp(nStr) do
    begin
      First;

      while not Eof do
      begin
        EditType.Properties.Items.Add(FieldByName('D_Value').AsString);
        Next;
      end;
    end;
  end;

  if nID <> '' then
  begin
    nStr := 'Select * From %s Where T_ID=%s';
    nStr := Format(nStr, [sTable_TruckInfo, nID]);
    LoadDataToCtrl(FDM.QueryTemp(nStr), Self, '');

    ListInfo1.Clear;
    nStr := MacroValue(sQuery_ExtInfo, [MI('$Table', sTable_ExtInfo),
                       MI('$Group', sFlag_TruckItem), MI('$ID', nID)]);
    //扩展信息

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := FieldByName('I_Item').AsString + ListInfo1.Delimiter +
                FieldByName('I_Info').AsString;
        ListInfo1.Items.Add(nStr);
        
        Next;
      end;
    end;
  end;
end;

//Desc: 验证数据
function TfFormTruckInfo.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditNo then
  begin
    EditNo.Text := Trim(EditNo.Text);
    Result := EditNo.Text <> '';
    nHint := '请填写有效的车牌号';
  end;
end;

//Desc: 保存数据
procedure TfFormTruckInfo.BtnOKClick(Sender: TObject);
var i,nCount,nPos: integer;
    nStr,nSQL,nTmp,nID: string;
begin
  if not IsDataValid then Exit;

  if FRecordID = '' then
  begin
     nSQL := MakeSQLByForm(Self, sTable_TruckInfo, '', True);
  end else
  begin
    nStr := 'T_ID=' + FRecordID;
    nSQL := MakeSQLByForm(Self, sTable_TruckInfo, nStr, False);
  end;

  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nSQL);

    if FRecordID = '' then
    begin
      nID := IntToStr(FDM.GetFieldMax(sTable_TruckInfo, 'T_ID'));
    end else
    begin
      nID := FRecordID;
      nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
      
      nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_TruckItem, FRecordID]);
      FDM.ExecuteSQL(nSQL);
    end;

    nCount := ListInfo1.Items.Count - 1;
    for i:=0 to nCount do
    begin
      nStr := ListInfo1.Items[i];
      nPos := Pos(ListInfo1.Delimiter, nStr);

      nTmp := Copy(nStr, 1, nPos - 1);
      System.Delete(nStr, 1, nPos + Length(ListInfo1.Delimiter) - 1);

      nSQL := 'Insert Into %s(I_Group, I_ItemID, I_Item, I_Info) ' +
              'Values(''%s'', ''%s'', ''%s'', ''%s'')';
      nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_TruckItem, nID, nTmp, nStr]);
      FDM.ExecuteSQL(nSQL);
    end;  

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOK;
    ShowMsg('数据已保存', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('数据保存失败', '未知原因');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormTruckInfo, TfFormTruckInfo.FormID);
end.
