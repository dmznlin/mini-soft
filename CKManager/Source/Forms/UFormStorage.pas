{*******************************************************************************
  作者: dmzn@163.com 2011-6-7
  描述: 仓库仓位管理
*******************************************************************************}
unit UFormStorage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxButtonEdit, cxLabel, cxTextEdit, cxContainer, cxEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, cxMCListBox;

type
  TfFormStorage = class(TfFormNormal)
    dxLayout1Item7: TdxLayoutItem;
    EditName: TcxTextEdit;
    EditPPart: TcxComboBox;
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
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
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
  gForm: TfFormStorage = nil;
  //全局使用

class function TfFormStorage.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormStorage.Create(Application) do
    begin
      FRecordID := '';
      Caption := '仓位 - 添加';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormStorage.Create(Application) do
    begin
      Caption := '仓位 - 修改';
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
        gForm := TfFormStorage.Create(Application);
        with gForm do
        begin
          Caption := '仓位信息 - 查看';
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

class function TfFormStorage.FormID: integer;
begin
  Result := cFI_FormStorage;
end;

procedure TfFormStorage.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, InfoList1, nIni);
    ResetHintAllForm(Self, 'T', sTable_Storage);
  finally
    nIni.Free;
  end;
end;

procedure TfFormStorage.FormClose(Sender: TObject;
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
procedure TfFormStorage.InitFormData(const nID: string);
var nStr: string;
begin
  if EditPPart.Properties.Items.Count < 1 then
  begin
    nStr := 'S_ID=Select S_ID,S_Name From %s ';
    if nID <> '' then
      nStr := nStr + Format('Where S_ID<>''%s'' ', [nID]);
    //xxxxx

    nStr := nStr + 'Order By S_PY';
    nStr := Format(nStr, [sTable_Storage]);

    FDM.FillStringsData(EditPPart.Properties.Items, nStr, -1, '.');
    AdjustStringsItem(EditPPart.Properties.Items, False);
  end;

  if nID <> '' then
  begin
    nStr := 'Select * From %s Where S_ID=''%s''';
    nStr := Format(nStr, [sTable_Storage, nID]);

    LoadDataToCtrl(FDM.QueryTemp(nStr), Self);
    LoadItemExtInfo(InfoList1.Items, sFlag_StorageItem, nID);
  end;
end;

//Desc: 验证数据
function TfFormStorage.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    Result := EditName.Text <> '';
    nHint := '请填写有效的名称';
  end;
end;

procedure TfFormStorage.BtnAddClick(Sender: TObject);
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

procedure TfFormStorage.BtnDelClick(Sender: TObject);
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
procedure TfFormStorage.BtnOKClick(Sender: TObject);
var nList: TStrings;
    i: integer;
    nStr,nSQL, nId: string;
begin
  if not IsDataValid then Exit;

  nList := TStringList.Create;
  nList.Text := Format('S_PY=''%s''', [GetPinYinOfStr(EditName.Text)]);

  if FRecordID = '' then
  begin
     nSQL := MakeSQLByForm(Self, sTable_Storage, '', True, nil, nList);
  end else
  begin
    nStr := 'S_ID=''' + FRecordID + '''';
    nSQL := MakeSQLByForm(Self, sTable_Storage, nStr, False, nil, nList);
  end;

  nList.Free;
  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nSQL);

    if FRecordID = '' then
    begin
      i := FDM.GetFieldMax(sTable_Storage, 'R_ID');
      nID := FDM.GetSerialID2('CW', sTable_Storage, 'R_ID', 'S_ID', i);

      nSQL := 'Update %s Set S_ID=''%s'' Where R_ID=%d';
      nSQL := Format(nSQL, [sTable_Storage, nID, i]);
      FDM.ExecuteSQL(nSQL);
    end else nID := FRecordID;

    SaveItemExtInfo(InfoList1.Items, sFlag_StorageItem, nID, FRecordID <> '');
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
  gControlManager.RegCtrl(TfFormStorage, TfFormStorage.FormID);
end.
