{*******************************************************************************
  ����: dmzn@163.com 2015-06-30
  ����: ��ȡ����
*******************************************************************************}
unit UFormWashOut;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFormNormal, UDataModule, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ComCtrls, cxListView, Menus,
  cxButtons, cxCheckBox, cxLabel, cxGraphics;

type
  TfFormWashOut = class(TfFormNormal)
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
    EditSSMoney: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    BtnNone: TcxButton;
    dxLayout1Item12: TdxLayoutItem;
    BtnAll: TcxButton;
    dxLayout1Item13: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item6: TdxLayoutItem;
    EditPay: TcxTextEdit;
    dxLayout1Item14: TdxLayoutItem;
    EditMemo: TcxTextEdit;
    dxLayout1Item15: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAllClick(Sender: TObject);
    procedure BtnNoneClick(Sender: TObject);
    procedure ListGridDblClick(Sender: TObject);
  private
    { Private declarations }
    FMID,FMName: String;
    FMMoney,FMZheKou: Double;
    //��Ա��Ϣ
    FID: string;
    FNumAll,FNumSY: Integer;
    FDFMoney,FZFMoney: Double;
    //�ϼ���
    procedure InitFormData(const nID: string);
    //��ʼ������
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

class function TfFormWashOut.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  nP := nParam;

  with TfFormWashOut.Create(Application) do
  try
    FID := nP.FParamA;
    InitFormData(FID);
    
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormWashOut.FormID: integer;
begin
  Result := cFI_FormWashOut;
end;

procedure TfFormWashOut.FormCreate(Sender: TObject);
begin
  inherited;
  dxGroup1.AlignVert := avTop;
  dxGroup2.AlignVert := avClient;
  dxGroup3.AlignVert := avBottom;

  SetUIStatus(False);
  SetLength(gWashItems, 0);
  gWashItemRefresh := RefreshWashItems;
  //ˢ�½���
  
  LoadFormConfig(Self);
  LoadcxListViewConfig(Name, ListGrid);
end;

procedure TfFormWashOut.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  CloseWashItemEditor;
  
  SaveFormConfig(Self);
  SavecxListViewConfig(Name, ListGrid);
end;

procedure TfFormWashOut.InitFormData(const nID: string);
var nStr: string;
    nIdx: Integer;
begin
  nStr := 'Select wd.*,D_MID,D_HasMoney,D_MID From $WD wd ' +
          ' Left Join $WS ws On ws.D_ID=wd.D_ID ' +
          'Where wd.D_ID=''$ID''';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$WS', sTable_WashData),
          MI('$WD', sTable_WashDetail), MI('$ID', nID)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then
    begin
      ShowMsg('��¼�Ѷ�ʧ', sHint);
      Exit;
    end;

    SetLength(gWashItems, RecordCount);
    nIdx := 0;
    First;

    FMID := FieldByName('D_MID').AsString;
    FDFMoney:= FieldByName('D_HasMoney').AsFloat;
    EditSSMoney.Text := Format('%.2f', [FDFMoney]);

    while not Eof do
    begin
      with gWashItems[nIdx] do
      begin
        FRecord := FieldByName('R_ID').AsString;
        FTypeID := FieldByName('D_TID').AsString;
        FName := FieldByName('D_Name').AsString;
        FUnit := FieldByName('D_Unit').AsString;
        FWashType := FieldByName('D_WashType').AsString;

        FNumber := FieldByName('D_HasNumber').AsInteger;
        FNumOut := FNumber;
        FColor := FieldByName('D_Color').AsString;
        FMemo := FieldByName('D_Memo').AsString;

        FEnable := True;
      end;

      Inc(nIdx);
      Next;
    end;

    LoadMemberInfo(FMID);
    //load info
  end;
end;

procedure TfFormWashOut.SetUIStatus(const nEnabled: Boolean);
begin
  BtnAll.Enabled := nEnabled;
  BtnNone.Enabled := nEnabled;
  BtnOK.Enabled := nEnabled;

  if not nEnabled then
  begin
    FMID := '';
    EditPhone.Text := '';
    EditMoney.Text := '';
    EditZheKou.Text := '';
  end;
end;

function TfFormWashOut.LoadMemberInfo(const nMember: string): Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select * From %s Where M_ID=''%s''';
  nStr := Format(nStr, [sTable_Member, nMember]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then
    begin
      ShowMsg('��Ա��Ϣ�Ѷ�ʧ', sHint);
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
//Desc: ������ϸ
procedure TfFormWashOut.RefreshWashItems;
var nStr: string;
    nIdx,nInt: Integer;
begin
  ListGrid.Items.BeginUpdate;
  try
    nInt := ListGrid.ItemIndex;
    ListGrid.Items.Clear;

    FNumAll := 0;
    FNumSY := 0;

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
        SubItems.Add(IntToStr(FNumOut));
        SubItems.Add(IntToStr(FNumber));
        SubItems.Add(FUnit);
        SubItems.Add(FWashType);
        SubItems.Add(FMemo);

        ImageIndex := cItemIconIndex;
        //icon
        Data := Pointer(nIdx);
      end;

      Inc(FNumAll, FNumOut);
      Inc(FNumSY, FNumber);
    end;

    if nInt >= ListGrid.Items.Count then
      nInt := ListGrid.Items.Count - 1;
    ListGrid.ItemIndex := nInt;

    nStr := '������ϸ �ϼ�:ʣ�� %d ��,��ȡ %d ��';
    dxGroup2.Caption := Format(nStr, [FNumAll, FNumSY]);
  finally
    ListGrid.Items.EndUpdate;
  end;   
end;

procedure TfFormWashOut.BtnAllClick(Sender: TObject);
var nIdx: Integer;
begin
  for nIdx:=Low(gWashItems) to High(gWashItems) do
    gWashItems[nIdx].FNumber := gWashItems[nIdx].FNumOut;
  RefreshWashItems;
end;

procedure TfFormWashOut.BtnNoneClick(Sender: TObject);
var nIdx: Integer;
begin
  for nIdx:=Low(gWashItems) to High(gWashItems) do
    gWashItems[nIdx].FNumber := 0;
  RefreshWashItems;
end;

procedure TfFormWashOut.ListGridDblClick(Sender: TObject);
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

function TfFormWashOut.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nVal: Double;
begin
  Result := True;

  if Sender = EditPay then
  begin
    Result := IsNumber(EditPay.Text, True);
    nHint := '֧�������>=0����ֵ';
    if not Result then Exit;

    FZFMoney := Float2Float(StrToFloat(EditPay.Text), cPercent, False);
    Result := FZFMoney >= 0;
    if not Result then Exit;

    if FNumAll > FNumSY then Exit;
    //δȡ��,�ӳ�֧��,��������
                            
    FMMoney := GetMemberValidMoney(FMID, True);
    nVal := FZFMoney + FMMoney;
    //�����: ʣ��� + ����֧��

    Result := FloatRelation(nVal, FDFMoney, rtGE, cPercent);
    //���ý���
    if Result then Exit;

    nHint := '��Ա�ʽ���,��������: ' + #13#10#13#10 +
             '��.����: %.2f Ԫ' + #13#10 +
             '��.����: %.2f Ԫ' + #13#10 +
             '��.�轻: %.2f Ԫ';
    nHint := Format(nHint, [FDFMoney, nVal, FDFMoney-nVal]);

    ShowDlg(nHint, sHint);
    nHint := '';
  end;
end;

procedure TfFormWashOut.BtnOKClick(Sender: TObject);
var nStr: string;
    nList: TStrings;
    nIdx: Integer;
begin
  if not OnVerifyCtrl(EditPay, nStr) then
  begin
    ActiveControl := EditPay;
    if nStr <> '' then
      ShowMsg(nStr, sHint);
    Exit;
  end;

  if ListGrid.Items.Count < 1 then
  begin
    ShowMsg('����д����', sHint);
    Exit;
  end;

  nList := TStringList.Create;
  try
    for nIdx:=Low(gWashItems) to High(gWashItems) do
    with gWashItems[nIdx] do
    begin
      if not FEnable then Continue;
      if FNumber < 1 then Continue;
      //valid filter

      nStr := MakeSQLByStr([
              SF('D_ID', FID),
              SF('D_TID', FTypeID),
              SF('D_Name', FName),
              SF('D_Py', GetPinYinOfStr(FName)),
              SF('D_Unit', FUnit),
              SF('D_WashType', FWashType),
              SF('D_Number', FNumber, sfVal),
              SF('D_Color', FColor),
              SF('D_Man', gSysParam.FUserID),
              SF('D_Date', sField_SQLServer_Now, sfVal),
              SF('D_Memo', FMemo)
              ], sTable_WashOut, '', True);
      nList.Add(nStr);

      nStr := 'Update %s Set D_HasNumber=D_HasNumber-%d Where D_ID=''%s''';
      nStr := Format(nStr, [sTable_WashData, FNumber, FID]);
      nList.Add(nStr);

      nStr := 'Update %s Set D_HasNumber=D_HasNumber-%d Where R_ID=%s';
      nStr := Format(nStr, [sTable_WashDetail, FNumber, FRecord]);
      nList.Add(nStr);
    end; //ȡ��

    if FZFMoney > 0 then
    begin
      nStr := 'Update %s Set M_MoneyIn=M_MoneyIn+%.2f ' +
              'Where M_ID=''%s''';
      nStr := Format(nStr, [sTable_Member, FZFMoney, FMID]);
      nList.Add(nStr);

      nStr := Format('���·�ʱ֧��[ %s ]', [FID]); 
      nStr := MakeSQLByStr([
              SF('M_ID', FMID),
              SF('M_Type', sFlag_IOType_In),
              SF('M_Money', FZFMoney, sfVal),
              SF('M_Date', sField_SQLServer_Now, sfVal),
              SF('M_Memo', nStr)
              ], sTable_InOutMoney, '', True);
      nList.Add(nStr);
    end; //����

    if (FNumSY >= FNumAll) and (FDFMoney > 0) then
    begin
      nStr := 'Update %s Set M_MoneyOut=M_MoneyOut+%.2f ' +
              'Where M_ID=''%s''';
      nStr := Format(nStr, [sTable_Member, FDFMoney, FMID]);
      nList.Add(nStr);

      nStr := Format('���·�ʱ����[ %s ]', [FID]);
      nStr := MakeSQLByStr([
              SF('M_ID', FMID),
              SF('M_Type', sFlag_IOType_Out),
              SF('M_Money', FDFMoney, sfVal),
              SF('M_Date', sField_SQLServer_Now, sfVal),
              SF('M_Memo', nStr)
              ], sTable_InOutMoney, '', True);
      nList.Add(nStr);
    end; //����
    
    FDM.ADOConn.BeginTrans;
    try
      for nIdx:=0 to nList.Count - 1 do
        FDM.ExecuteSQL(nList[nIdx]);
      FDM.ADOConn.CommitTrans;

      ModalResult := mrOk;
      ShowMsg('��ȡ�ɹ�', sHint);
    except
      FDM.ADOConn.RollbackTrans;
      ShowMsg('����δ֪����', sHint);
    end;  
  finally
    nList.Free;
  end;   
end;

initialization
  gControlManager.RegCtrl(TfFormWashOut, TfFormWashOut.FormID);
end.
