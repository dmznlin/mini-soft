{*******************************************************************************
  作者: dmzn@163.com 2015-06-25
  描述: 收取衣物
*******************************************************************************}
unit UFormWashData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFormNormal, UDataModule, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ComCtrls, cxListView, Menus,
  cxButtons, cxCheckBox, cxLabel, cxGraphics;

type
  TfFormWashData = class(TfFormNormal)
    EditPhone: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    EditZheKou: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditMoney: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    EditName: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    ListGrid: TcxListView;
    dxLayout1Item9: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    dxGroup3: TdxLayoutGroup;
    EditYSMoney: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    EditSSMoney: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    BtnDel: TcxButton;
    dxLayout1Item12: TdxLayoutItem;
    BtnAdd: TcxButton;
    dxLayout1Item13: TdxLayoutItem;
    Check1: TcxCheckBox;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    cxLabel1: TcxLabel;
    dxLayout1Item6: TdxLayoutItem;
    EditPay: TcxTextEdit;
    dxLayout1Item14: TdxLayoutItem;
    EditMemo: TcxTextEdit;
    dxLayout1Item15: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure ListGridDblClick(Sender: TObject);
  private
    { Private declarations }
    FMID,FMName: String;
    FMMoney,FMZheKou: Double;
    //会员信息
    FNum: Integer;
    FYSMoney,FSSMoney,FSYMoney,FZFMoney: Double;
    //合计项
    procedure RefreshWashItems;
    procedure SetUIStatus(const nEnabled: Boolean);
    function LoadMemberInfo(const nMember: string): Boolean;
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
  UMgrControl, ULibFun, USysDB, USysConst, UFormCtrl, USysGrid, USysBusiness,
  UFormWashItem;

class function TfFormWashData.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  nP := nParam;

  with TfFormWashData.Create(Application) do
  try
    FMID := '';
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormWashData.FormID: integer;
begin
  Result := cFI_FormWashData;
end;

procedure TfFormWashData.FormCreate(Sender: TObject);
begin
  inherited;
  dxGroup1.AlignVert := avTop;
  dxGroup2.AlignVert := avClient;
  dxGroup3.AlignVert := avBottom;

  SetUIStatus(False);
  SetLength(gWashItems, 0);
  gWashItemRefresh := RefreshWashItems;
  //刷新界面
  
  LoadFormConfig(Self);
  LoadcxListViewConfig(Name, ListGrid);
end;

procedure TfFormWashData.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  CloseWashItemEditor;
  
  SaveFormConfig(Self);
  SavecxListViewConfig(Name, ListGrid);
end;

procedure TfFormWashData.SetUIStatus(const nEnabled: Boolean);
begin
  BtnAdd.Enabled := nEnabled;
  BtnDel.Enabled := nEnabled;
  BtnOK.Enabled := nEnabled;

  if not nEnabled then
  begin
    FMID := '';
    EditPhone.Text := '';
    EditMoney.Text := '';
    EditZheKou.Text := '';
  end;
end;

function TfFormWashData.LoadMemberInfo(const nMember: string): Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select * From %s Where M_ID=''%s''';
  nStr := Format(nStr, [sTable_Member, nMember]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then
    begin
      ShowMsg('会员信息已丢失', sHint);
      Exit;
    end;

    FMID := nMember;
    FMName := FieldByName('M_Name').AsString;
    EditName.Text := FMName;

    EditPhone.Text := FieldByName('M_Phone').AsString;
    FMZheKou := FieldByName('M_ZheKou').AsFloat;
    EditZheKou.Text := Format('%.2f', [FMZheKou]);

    FMMoney := GetMemberValidMoney(FMID, True);
    EditMoney.Text := Format('%.2f', [FMMoney]);

    SetUIStatus(True);
    RefreshWashItems;
    Result := True;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormWashData.EditNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nP: TFormCommandParam;
begin
  Visible := False;
  try
    SetUIStatus(False);
    nP.FCommand := cCmd_AddData;
    nP.FParamA := Trim(EditName.Text);

    CreateBaseFormItem(cFI_FormGetMember, '', @nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;
  finally
    Visible := True;
  end;

  if LoadMemberInfo(nP.FParamB) then
  begin
    EditName.SelectAll;
    ActiveControl := EditName;
  end;
end;

//Desc: 载入明细
procedure TfFormWashData.RefreshWashItems;
var nIdx,nInt: Integer;
    nVal: Double;
begin
  ListGrid.Items.BeginUpdate;
  try
    nInt := ListGrid.ItemIndex;
    ListGrid.Items.Clear;

    FNum := 0;
    FYSMoney := 0;

    for nIdx:=Low(gWashItems) to High(gWashItems) do
    with gWashItems[nIdx] do
    begin
      if not FEnable then Continue;
      //valid

      with ListGrid.Items.Add do
      begin
        Caption := FTypeID;
        SubItems.Add(FName);
        SubItems.Add(FColor);
        SubItems.Add(IntToStr(FNumber));
        SubItems.Add(FUnit);
        SubItems.Add(FWashType);
        SubItems.Add(FMemo);

        ImageIndex := cItemIconIndex;
        //icon
        Data := Pointer(nIdx);
      end;

      Inc(FNum, FNumber);
      nVal := Float2Float(FNumber * FPrice, cPercent, True);
      FYSMoney := FYSMoney + nVal;
    end;

    if nInt >= ListGrid.Items.Count then
      nInt := ListGrid.Items.Count - 1;
    ListGrid.ItemIndex := nInt;

    FSSMoney := Float2Float(FYSMoney * FMZheKou, cPercent, True);
    EditYSMoney.Text := Format('%.2f', [FYSMoney]);
    EditSSMoney.Text := Format('%.2f', [FSSMoney]);

    if FNum > 0 then
         dxGroup2.Caption := Format('衣物明细 合计:共 %d 件', [FNum])
    else dxGroup2.Caption := '衣物明细';
  finally
    ListGrid.Items.EndUpdate;
  end;   
end;

procedure TfFormWashData.BtnAddClick(Sender: TObject);
var nIdx: Integer;
begin
  for nIdx:=Low(gWashItems) to High(gWashItems) do
    gWashItems[nIdx].FSelected := False;
  ShowWashItemEditor;
end;

procedure TfFormWashData.BtnDelClick(Sender: TObject);
var nIdx: Integer;
begin
  if ListGrid.ItemIndex < 0 then
  begin
    ShowMsg('请选择明细项', sHint);
    Exit;
  end;

  nIdx := Integer(ListGrid.Items[ListGrid.ItemIndex].Data);
  gWashItems[nIdx].FEnable := False;
  RefreshWashItems;
end;

procedure TfFormWashData.ListGridDblClick(Sender: TObject);
var nIdx,nInt: Integer;
begin
  if ListGrid.ItemIndex >= 0 then
  begin
    nInt := Integer(ListGrid.Items[ListGrid.ItemIndex].Data);
    for nIdx:=Low(gWashItems) to High(gWashItems) do
      gWashItems[nIdx].FSelected := nIdx = nInt;
    //xxxxx

    ShowWashItemEditor;
  end;
end;

function TfFormWashData.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nVal: Double;
begin
  Result := True;

  if Sender = EditSSMoney then
  begin
    Result := IsNumber(EditSSMoney.Text, True);
    nHint := '金额是>=0的数值';
    if not Result then Exit;

    nVal := Float2Float(StrToFloat(EditSSMoney.Text), cPercent, True);
    Result := nVal >= 0;

    if Result then
      FSSMoney := nVal;
    //xxxxx 
  end else

  if Sender = EditPay then
  begin
    Result := IsNumber(EditPay.Text, True);
    nHint := '支付金额是>=0的数值';
    if not Result then Exit;

    FZFMoney := Float2Float(StrToFloat(EditPay.Text), cPercent, False);
    Result := FZFMoney >= 0;
    if not Result then Exit;

    FSYMoney := FSSMoney;
    //剩余=实收
    if Check1.Checked then Exit;
    //延迟支付,不计算金额
    FSYMoney := 0;
    //剩余=已支付

    FMMoney := GetMemberValidMoney(FMID, True);
    nVal := FZFMoney + FMMoney;
    //总余额: 剩余金 + 本次支付

    Result := FloatRelation(nVal, FSSMoney, rtGE, cPercent);
    //可用金够用
    if Result then Exit;

    nHint := '会员资金不足,详情如下: ' + #13#10#13#10 +
             '※.待付: %.2f 元' + #13#10 +
             '※.可用: %.2f 元' + #13#10 +
             '※.需交: %.2f 元';
    nHint := Format(nHint, [FSSMoney, nVal, FSSMoney-nVal]);

    ShowDlg(nHint, sHint);
    nHint := '';
  end;
end;

procedure TfFormWashData.BtnOKClick(Sender: TObject);
var nStr,nID: string;
    nList: TStrings;
    nIdx: Integer;
begin
  if not OnVerifyCtrl(EditSSMoney, nStr) then
  begin
    ActiveControl := EditSSMoney;
    ShowMsg(nStr, sHint);
    Exit;
  end;

  if not OnVerifyCtrl(EditPay, nStr) then
  begin
    ActiveControl := EditPay;
    if nStr <> '' then
      ShowMsg(nStr, sHint);
    Exit;
  end;

  if ListGrid.Items.Count < 1 then
  begin
    ShowMsg('请填写衣物', sHint);
    Exit;
  end;

  nList := TStringList.Create;
  try
    nID := GetSerailID(sFlag_BusGroup, sFlag_WashData, True);
    nStr := MakeSQLByStr([
            SF('D_ID', nID),
            SF('D_MID', FMID),
            SF('D_Number', FNum, sfVal),
            SF('D_HasNumber', FNum, sfVal),
            SF('D_YSMoney', FYSMoney, sfVal),
            SF('D_Money', FSSMoney, sfVal),
            SF('D_HasMoney', FSYMoney, sfVal),
            SF('D_Man', gSysParam.FUserID),
            SF('D_Date', sField_SQLServer_Now, sfVal),
            SF('D_Memo', EditMemo.Text)
            ], sTable_WashData, '', True);
    nList.Add(nStr);

    for nIdx:=Low(gWashItems) to High(gWashItems) do
    with gWashItems[nIdx] do
    begin
      if not FEnable then Continue;
      //valid filter

      nStr := MakeSQLByStr([
              SF('D_ID', nID),
              SF('D_TID', FWashType),
              SF('D_Name', FName),
              SF('D_Py', GetPinYinOfStr(FName)),
              SF('D_Unit', FUnit),
              SF('D_WashType', FWashType),
              SF('D_Number', FNum, sfVal),
              SF('D_HasNumber', FNum, sfVal),
              SF('D_Color', FColor),
              SF('D_Memo', FMemo)
              ], sTable_WashDetail, '', True);
      nList.Add(nStr);
    end;

    if FZFMoney > 0 then
    begin
      nStr := 'Update %s Set M_MoneyIn=M_MoneyIn+%.2f ' +
              'Where M_ID=''%s''';
      nStr := Format(nStr, [sTable_Member, FZFMoney, FMID]);
      nList.Add(nStr);

      nStr := Format('收衣服时支付[ %s ]', [nID]); 
      nStr := MakeSQLByStr([
              SF('M_ID', FMID),
              SF('M_Type', sFlag_IOType_In),
              SF('M_Money', FZFMoney, sfVal),
              SF('M_Date', sField_SQLServer_Now, sfVal),
              SF('M_Memo', nStr)
              ], sTable_InOutMoney, '', True);
      nList.Add(nStr);
    end;

    if Check1.Checked then
    begin
      nStr := 'Update %s Set M_Times=M_Times+1 ' +
              'Where M_ID=''%s''';
      nStr := Format(nStr, [sTable_Member, FMID]);
      nList.Add(nStr);
    end else
    begin
      nStr := 'Update %s Set M_MoneyOut=M_MoneyOut+%.2f,M_Times=M_Times+1 ' +
              'Where M_ID=''%s''';
      nStr := Format(nStr, [sTable_Member, FSSMoney, FMID]);
      nList.Add(nStr);

      nStr := Format('收衣服时消费[ %s ]', [nID]);
      nStr := MakeSQLByStr([
              SF('M_ID', FMID),
              SF('M_Type', sFlag_IOType_Out),
              SF('M_Money', FSSMoney, sfVal),
              SF('M_Date', sField_SQLServer_Now, sfVal),
              SF('M_Memo', nStr)
              ], sTable_InOutMoney, '', True);
      nList.Add(nStr);
    end;
    
    FDM.ADOConn.BeginTrans;
    try
      for nIdx:=0 to nList.Count - 1 do
        FDM.ExecuteSQL(nList[nIdx]);
      FDM.ADOConn.CommitTrans;

      ModalResult := mrOk;
      ShowMsg('收取成功', sHint);
    except
      FDM.ADOConn.RollbackTrans;
      ShowMsg('发生未知错误', sHint);
    end;  
  finally
    nList.Free;
  end;   
end;

initialization
  gControlManager.RegCtrl(TfFormWashData, TfFormWashData.FormID);
end.
