{*******************************************************************************
  作者: dmzn@163.com 2013-10-31
  描述: 管理配比参数
*******************************************************************************}
unit UFormPeiBi;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, ValEdit, ComCtrls, StdCtrls, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  dxSkinsCore, dxSkinsDefaultPainters, cxLabel, ImgList;

type
  TfFormPeiBi = class(TForm)
    PanelClient: TPanel;
    Splitter1: TSplitter;
    PanelTop: TPanel;
    ListPB: TListView;
    cxLabel1: TcxLabel;
    ListHistory: TListBox;
    Splitter2: TSplitter;
    ListValue: TListView;
    ImageList1: TImageList;
    Panel1: TPanel;
    EditName: TLabeledEdit;
    EditGB: TLabeledEdit;
    EditFD: TLabeledEdit;
    cxLabel2: TcxLabel;
    BtnSave: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListPBClick(Sender: TObject);
    procedure ListValueChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure EditGBChange(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure ListHistoryClick(Sender: TObject);
  private
    { Private declarations }
    FLastPB: string;
    FNewPBDate: string;
    procedure LoadPeibiList;
    procedure LoadPeibiHistory(const nPB: string);
    procedure LoadPeibiValue(const nPB: string);

    function GetSelectedPB(const nRecordID: Boolean = False): string;
    function MakePBSQL(const nNewDate: string; const nGB,nNew: Boolean): string;
    procedure SetPBValue(const nField,nValue: string; const nGB: Boolean);
  public
    { Public declarations }
  end;

procedure ShowPeiBiForm;
//入口函数

implementation

{$R *.dfm}

uses
  ULibFun, UMgrDBConn, UFormCtrl, IniFiles, USysConst;

var
  gForm: TfFormPeiBi = nil;
  //全局使用

procedure ShowPeiBiForm;
begin
  if not Assigned(gForm) then
    gForm := TfFormPeiBi.Create(Application);
  //xxxxx

  with gForm do
  begin
    LoadPeibiList;
    Show;
  end;
end;

procedure TfFormPeiBi.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sConfigFile);
  try
    FLastPB := '';
    FNewPBDate := '';
    LoadFormConfig(Self, nIni);
    
    PanelTop.Height := nIni.ReadInteger(Name, 'PanelH', 300);
    ListHistory.Width := nIni.ReadInteger(Name, 'ListW', 300);
  finally
    nIni.Free;
  end;
end;

procedure TfFormPeiBi.FormClose(Sender: TObject; var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sConfigFile);
  try
    SaveFormConfig(Self, nIni);
    nIni.WriteInteger(Name, 'PanelH', PanelTop.Height);
    nIni.WriteInteger(Name, 'ListW', ListHistory.Width);
  finally
    nIni.Free;
  end;

  Action := caFree;
  gForm := nil;
end;

//------------------------------------------------------------------------------
function TfFormPeiBi.GetSelectedPB(const nRecordID: Boolean): string;
begin
  Result := '';

  if Assigned(ListPB.Selected) then
  begin
    if nRecordID then
         Result := ListPB.Selected.Caption
    else Result := ListPB.Selected.SubItems[0];
  end;
end;

procedure TfFormPeiBi.LoadPeibiList;
var nStr: string;
    nIdx: Integer;
    nWorker: PDBWorker;
begin
  nWorker := nil;
  try
    ListPB.Clear;
    nStr := Format('Select * From %s', [sTable_Peibi]);

    with gDBConnManager.SQLQuery(nStr, nWorker, sSCCtrl) do
    if RecordCount > 0 then
    begin
      if ListPB.Columns.Count < 1 then
      begin
        for nIdx:=0 to FieldCount - 2 do
        with ListPB.Columns.Add do
        begin
          Caption := Fields[nIdx].FieldName;
          Width := 75;
        end;
      end;

      First;
      while not Eof do
      begin
        with ListPB.Items.Add do
        begin
          Caption := Fields[0].AsString;

          for nIdx:=1 to FieldCount - 2 do
            SubItems.Add(Fields[nIdx].AsString);
          //xxxxx
        end;

        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nWorker);
  end;
end;

procedure TfFormPeiBi.ListPBClick(Sender: TObject);
var nStr: string;
begin
  nStr := GetSelectedPB;
  if (nStr <> '') and (nStr <> FLastPB) then
  begin
    LoadPeibiHistory(nStr);
    LoadPeibiValue(nStr);
    
    FLastPB := nStr;
    FNewPBDate := '';
  end;
end;

//Date: 2013-10-31
//Parm: 配比号
//Desc: 载入nPB的改动历史
procedure TfFormPeiBi.LoadPeibiHistory(const nPB: string);
var nStr: string;
    nWorker: PDBWorker;
begin
  nWorker := nil;
  try
    ListHistory.Clear;
    nStr := 'Select B_Date From %s_g Where 配比编号=''%s''';
    nStr := Format(nStr, [sTable_Peibi, nPB]);

    with gDBConnManager.SQLQuery(nStr, nWorker, sSCCtrl) do
    if RecordCount > 0 then
    begin
      First;
      while not Eof do
      begin
        ListHistory.Items.Add(DateTime2Str(Fields[0].AsDateTime));
        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nWorker);
  end;
end;

//Date: 2013-10-31
//Parm: 配比号
//Desc: 载入nPB的值列表
procedure TfFormPeiBi.LoadPeibiValue(const nPB: string);
var nStr: string;
    nIdx: Integer;
    nWorker: PDBWorker;
begin
  nWorker := nil;
  try
    ListValue.Clear;
    nStr := 'Select * From %s where 配比编号=''%s''';
    nStr := Format(nStr, [sTable_Peibi,nPB]);

    with gDBConnManager.SQLQuery(nStr, nWorker, sSCCtrl) do
    if RecordCount > 0 then
    begin
      First;

      for nIdx:=2 to FieldCount - 3 do
      begin
        with ListValue.Items.Add do
        begin
          ImageIndex := 0;
          Caption := Fields[nIdx].FieldName;

          SubItems.Add(Fields[nIdx].AsString);
          SubItems.Add('');
          SubItems.Add('');
        end;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nWorker);
  end;
end;

procedure TfFormPeiBi.ListValueChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if Assigned(ListValue.Selected) then
  begin
    EditName.Text := ListValue.Selected.Caption;
    EditGB.Text := ListValue.Selected.SubItems[1];
    EditFD.Text := ListValue.Selected.SubItems[2];
  end else EditName.Text := '';
end;

procedure TfFormPeiBi.EditGBChange(Sender: TObject);
begin
  if Assigned(ListValue.Selected) and (Sender as TWinControl).Focused then
  begin
    if IsNumber(EditGB.Text, True) then
      ListValue.Selected.SubItems[1] := EditGB.Text;
    //xxxxx

    if IsNumber(EditFD.Text, True) then
      ListValue.Selected.SubItems[2] := EditFD.Text;
    //xxxxx
  end;
end;

procedure TfFormPeiBi.SetPBValue(const nField, nValue: string;
  const nGB: Boolean);
var nIdx: Integer;
begin
  for nIdx:=0 to ListValue.Items.Count - 1 do
  if CompareText(ListValue.Items[nIdx].Caption, nField) = 0 then
  begin
    if nGB then
         ListValue.Items[nIdx].SubItems[1] := nValue
    else ListValue.Items[nIdx].SubItems[2] := nValue;
  end;
end;

procedure TfFormPeiBi.ListHistoryClick(Sender: TObject);
var nStr,nDate: string;
    nIdx: Integer;
    nWorker: PDBWorker;
begin
  if GetSelectedPB() = '' then Exit;
  if ListHistory.ItemIndex < 0 then
       Exit
  else nDate := ListHistory.Items[ListHistory.ItemIndex];

  nWorker := nil;
  try
    nStr := 'Select * From %s_g where 配比编号=''%s'' and B_Date=CDate(''%s'')';
    nStr := Format(nStr, [sTable_Peibi, GetSelectedPB(), nDate]);

    with gDBConnManager.SQLQuery(nStr, nWorker, sSCCtrl) do
    if RecordCount > 0 then
    begin
      First;

      for nIdx:=0 to FieldCount - 1 do
        SetPBValue(Fields[nIdx].FieldName, Fields[nIdx].AsString, True);
      //xxxxx
    end;

    nStr := 'Select * From %s_w where 配比编号=''%s'' and B_Date=CDate(''%s'')';
    nStr := Format(nStr, [sTable_Peibi, GetSelectedPB(), nDate]);

    with gDBConnManager.WorkerQuery(nWorker, nStr) do
    if RecordCount > 0 then
    begin
      First;

      for nIdx:=0 to FieldCount - 1 do
        SetPBValue(Fields[nIdx].FieldName, Fields[nIdx].AsString, False);
      //xxxxx
    end;
  finally
    gDBConnManager.ReleaseConnection(nWorker);
  end;
end;

//------------------------------------------------------------------------------
function TfFormPeiBi.MakePBSQL(const nNewDate: string;
 const nGB,nNew: Boolean): string;
var nIdx,nLen: Integer;
    nMI,nTmp: TDynamicMacroArray;
begin
  Result := '';
  SetLength(nTmp, ListValue.Items.Count);

  for nIdx:=0 to ListValue.Items.Count - 1 do
  begin
    if nGB then
    begin
      nTmp[nIdx].FMacro := ListValue.Items[nIdx].Caption;
      nTmp[nIdx].FValue := ListValue.Items[nIdx].SubItems[1];

      if (nTmp[nIdx].FValue = '') or (not IsNumber(nTmp[nIdx].FValue, True)) then
        nTmp[nIdx].FValue := '';
      //xxxxx
    end else
    begin
      nTmp[nIdx].FMacro := ListValue.Items[nIdx].Caption;
      nTmp[nIdx].FValue := ListValue.Items[nIdx].SubItems[2];

      if (nTmp[nIdx].FValue = '') or (not IsNumber(nTmp[nIdx].FValue, True)) then
        nTmp[nIdx].FValue := '';
      //xxxxx
    end;
  end;

  nLen := 0;
  for nIdx:=Low(nTmp) to High(nTmp) do
  if nTmp[nIdx].FValue <> '' then
  begin
    SetLength(nMI, nLen + 1);
    nMI[nLen].FMacro := nTmp[nIdx].FMacro;
    nMI[nLen].FValue := '''' + nTmp[nIdx].FValue + '''';
    Inc(nLen);
  end;

  if nLen < 1 then Exit;
  //no valid data
  
  if nNew then
  begin
    nIdx := Length(nMI);
    SetLength(nMI, nIdx + 3);

    nMI[nIdx].FMacro := 'B_Date';
    nMI[nIdx].FValue := '''' + nNewDate + '''' ;

    nMI[nIdx+1].FMacro := 'B_Valid';
    nMI[nIdx+1].FValue := '''Y''' ;

    nMI[nIdx+2].FMacro := '配比编号';
    nMI[nIdx+2].FValue := '''' + GetSelectedPB() + '''' ;

    if nGB then
         Result := MakeSQLByMI(nMI, sTable_Peibi + '_g', '', True)
    else Result := MakeSQLByMI(nMI, sTable_Peibi + '_w', '', True);
  end else
  begin
    nIdx := Length(nMI);
    SetLength(nMI, nIdx + 1);

    nMI[nIdx].FMacro := 'B_Valid';
    nMI[nIdx].FValue := '''Y''' ;

    Result := '配比编号=''%s'' and B_Date=CDate(''%s'')';
    Result := Format(Result, [GetSelectedPB(), FNewPBDate]);

    if nGB then
         Result := MakeSQLByMI(nMI, sTable_Peibi + '_g', Result, False)
    else Result := MakeSQLByMI(nMI, sTable_Peibi + '_w', Result, False);
  end;
end;

procedure TfFormPeiBi.BtnSaveClick(Sender: TObject);
var nStr: string;
begin
  if GetSelectedPB() = '' then
  begin
    ShowMsg('请在上面的列表中选择配比', sHint);
    Exit;
  end;

  BtnSave.Enabled := False;
  try
    ParepareDBWork(False);
    //备份数据
    CombineProductData;
    //旧数据应用旧配比

    if FNewPBDate = '' then
    begin
      FNewPBDate := DateTime2Str(Now);
      nStr := MakePBSQL(FNewPBDate, True, True);
      if nStr <> '' then
        gDBConnManager.ExecSQL(nStr, sSCCtrl);
      //xxxxx

      nStr := MakePBSQL(FNewPBDate, False, True);
      if nStr <> '' then
        gDBConnManager.ExecSQL(nStr, sSCCtrl);
      //xxxxx
    end else
    begin
      nStr := MakePBSQL(FNewPBDate, True, False);
      if nStr <> '' then
        gDBConnManager.ExecSQL(nStr, sSCCtrl);
      //xxxxx

      nStr := MakePBSQL(FNewPBDate, False, False);
      if nStr <> '' then
        gDBConnManager.ExecSQL(nStr, sSCCtrl);
      //xxxxx
    end;

    nStr := 'Update %s_g Set B_Valid=''N'' Where ' +
            '配比编号=''%s'' and B_Date<>CDate(''%s'')';
    nStr := Format(nStr, [sTable_Peibi, GetSelectedPB(), FNewPBDate]);
    gDBConnManager.ExecSQL(nStr, sSCCtrl);

    nStr := 'Update %s_w Set B_Valid=''N'' Where ' +
            '配比编号=''%s'' and B_Date<>CDate(''%s'')';
    nStr := Format(nStr, [sTable_Peibi, GetSelectedPB(), FNewPBDate]);
    gDBConnManager.ExecSQL(nStr, sSCCtrl);
         
    CombinePeibiData;
    //应用新配比
  finally
    BtnSave.Enabled := True;
    ShowMsg('保存成功', sHint);
  end;
end;

end.
