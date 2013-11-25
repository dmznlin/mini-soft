{*******************************************************************************
  作者: dmzn@163.com 2013-10-31
  描述: 管理任务单配比
*******************************************************************************}
unit UFormRwd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, ValEdit, ComCtrls, StdCtrls, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  dxSkinsCore, dxSkinsDefaultPainters, cxLabel, ImgList;

type
  TfFormRwd = class(TForm)
    PanelClient: TPanel;
    Splitter1: TSplitter;
    PanelTop: TPanel;
    ListRwd: TListView;
    cxLabel1: TcxLabel;
    Splitter2: TSplitter;
    ListSJ: TListView;
    ImageList1: TImageList;
    Panel1: TPanel;
    EditName: TLabeledEdit;
    EditGB: TLabeledEdit;
    cxLabel2: TcxLabel;
    BtnSave: TButton;
    ListSC: TListView;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListRwdClick(Sender: TObject);
    procedure ListSJChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure EditGBChange(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
  private
    { Private declarations }
    FLastRwd: string;
    FLastList: TListView;

    procedure LoadRwdList;
    function GetSelectedRwd: string;
    procedure LoadRwdData(const nID: string);
    procedure MakeSQLList(const nList: TStrings);
  public
    { Public declarations }
  end;

procedure ShowRwdPBForm;
//入口函数

implementation

{$R *.dfm}

uses
  DB, ULibFun, UMgrDBConn, UFormCtrl, IniFiles, USysConst;

var
  gForm: TfFormRwd = nil;
  //全局使用

procedure ShowRwdPBForm;
begin
  if not Assigned(gForm) then
    gForm := TfFormRwd.Create(Application);
  //xxxxx

  with gForm do
  begin
    BackupData(sSCCtrl, sTable_RwdPB);
    LoadRwdList;
    Show;
  end;
end;

procedure TfFormRwd.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sConfigFile);
  try
    FLastRwd := '';
    FLastList := nil;
    LoadFormConfig(Self, nIni);

    PanelTop.Height := nIni.ReadInteger(Name, 'PanelH', 300);
    ListSC.Width := nIni.ReadInteger(Name, 'ListW', 300);
  finally
    nIni.Free;
  end;
end;

procedure TfFormRwd.FormClose(Sender: TObject; var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sConfigFile);
  try
    SaveFormConfig(Self, nIni);
    nIni.WriteInteger(Name, 'PanelH', PanelTop.Height);
    nIni.WriteInteger(Name, 'ListW', ListSC.Width);
  finally
    nIni.Free;
  end;

  Action := caFree;
  gForm := nil;
end;

//------------------------------------------------------------------------------
function TfFormRwd.GetSelectedRwd: string;
begin
  if Assigned(ListRwd.Selected) then
       Result := ListRwd.Selected.Caption
  else Result := '';
end;

procedure TfFormRwd.LoadRwdList;
var nStr: string;
    nIdx: Integer;
    nWorker: PDBWorker;
begin
  nWorker := nil;
  try
    ListRwd.Clear;
    nStr := Format('Select * From %s', [sTable_Rwd]);

    with gDBConnManager.SQLQuery(nStr, nWorker, sSCCtrl) do
    if RecordCount > 0 then
    begin
      if ListRwd.Columns.Count < 1 then
      begin
        for nIdx:=0 to FieldCount - 2 do
        with ListRwd.Columns.Add do
        begin
          Caption := Fields[nIdx].FieldName;
          Width := 75;
        end;
      end;

      First;
      while not Eof do
      begin
        with ListRwd.Items.Add do
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

procedure TfFormRwd.ListRwdClick(Sender: TObject);
var nStr: string;
begin
  nStr := GetSelectedRwd;
  if (nStr <> '') and (nStr <> FLastRwd) then
  begin
    LoadRwdData(nStr);
    FLastRwd := nStr;
  end;
end;

function FindListItem(const nLV: TListView; const nField: string): TListItem;
var nIdx: Integer;
begin
  Result := nil;

  for nIdx:=nLV.Items.Count - 1 downto 0 do
  if CompareText(nField, nLV.Items[nIdx].SubItems[3]) = 0 then
  begin
    Result := nLV.Items[nIdx];
    Break;
  end;
end;

//Date: 2013-10-31
//Parm: 任务单号
//Desc: 载入nID的数据
procedure TfFormRwd.LoadRwdData(const nID: string);
var nStr: string;
    nIdx: Integer;
    nItem: TListItem;
    nWorker: PDBWorker;
begin
  nWorker := nil;
  try
    ListSC.Clear;
    ListSJ.Clear;
    nStr := 'Select * From %s Order By FID';
    nStr := Format(nStr, [sTable_RwdPBName]);

    with gDBConnManager.SQLQuery(nStr, nWorker, sSCCtrl) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        with ListSC.Items.Add do
        begin
          Caption := FieldByName('FDisName').AsString;
          SubItems.Add(FieldByName('FClgg').AsString);
          SubItems.Add('');
          SubItems.Add('');
          SubItems.Add(FieldByName('FpbName1').AsString);
        end;  

        with ListSJ.Items.Add do
        begin
          Caption := FieldByName('FDisName').AsString;
          SubItems.Add(FieldByName('FClgg').AsString);
          SubItems.Add('');
          SubItems.Add('');
          SubItems.Add(FieldByName('FpbName1').AsString);
        end;

        Next;
      end;
    end;

    //--------------------------------------------------------------------------
    nStr := 'Select * From %s_b Where pb_bh=''%s''';
    nStr := Format(nStr, [sTable_RwdPB, nID]);

    with gDBConnManager.WorkerQuery( nWorker, nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := FieldByName('pb_flag').AsString;
        if nStr = '0' then
        begin
          for nIdx:=FieldCount - 1 downto 0 do
          begin
            nItem := FindListItem(ListSC, Fields[nIdx].FieldName);
            if Assigned(nItem) then
              nItem.SubItems[1] := Fields[nIdx].AsString;
            //xxxxx
          end;
        end else

        if nStr = '1' then
        begin
          for nIdx:=FieldCount - 1 downto 0 do
          begin
            nItem := FindListItem(ListSJ, Fields[nIdx].FieldName);
            if Assigned(nItem) then
              nItem.SubItems[1] := Fields[nIdx].AsString;
            //xxxxx
          end;
        end;

        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nWorker);
  end;
end;

procedure TfFormRwd.ListSJChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if Assigned(Item) and (Sender as TWinControl).Focused then
  begin
    EditName.Text := Item.Caption;
    EditGB.Text := Item.SubItems[1];
    FLastList := Sender as TListView;
  end else EditName.Text := '';
end;

procedure TfFormRwd.EditGBChange(Sender: TObject);
begin
  if (Sender as TWinControl).Focused and IsNumber(EditGB.Text, True) then
  begin
    if Assigned(FLastList) and Assigned(FLastList.Selected) then
      FLastList.Selected.SubItems[2] := EditGB.Text;
    //xxxxx
  end;
end;

procedure TfFormRwd.MakeSQLList(const nList: TStrings);
var nStr: string;
    nIdx: Integer;
    nMI: TDynamicMacroArray;
begin
  SetLength(nMI, ListSC.Items.Count);
  for nIdx:=0 to ListSC.Items.Count - 1 do
  with ListSC.Items[nIdx] do
  begin
    nMI[nIdx].FMacro := SubItems[3];
    if IsNumber(SubItems[2], True) then
         nMI[nIdx].FValue := SubItems[2]
    else nMI[nIdx].FValue := SubItems[1];

    if not IsNumber(nMI[nIdx].FValue, True) then
      nMI[nIdx].FValue := '0';
    //xxxxx
  end;

  nStr := 'pb_bh=''%s'' And pb_flag=''%s''';
  nStr := Format(nStr, [GetSelectedRwd, '0']);

  nStr := MakeSQLByMI(nMI, sTable_RwdPB + '_b', nStr, False);
  nList.Add(nStr);
  //生产配比

  for nIdx:=0 to ListSJ.Items.Count - 1 do
  with ListSJ.Items[nIdx] do
  begin
    nMI[nIdx].FMacro := SubItems[3];
    if IsNumber(SubItems[2], True) then
         nMI[nIdx].FValue := SubItems[2]
    else nMI[nIdx].FValue := SubItems[1];

    if not IsNumber(nMI[nIdx].FValue, True) then
      nMI[nIdx].FValue := '0';
    //xxxxx
  end;

  nStr := 'pb_bh=''%s'' And pb_flag=''%s''';
  nStr := Format(nStr, [GetSelectedRwd, '1']);

  nStr := MakeSQLByMI(nMI, sTable_RwdPB + '_b', nStr, False);
  nList.Add(nStr);
  //砂浆配比
end;

procedure TfFormRwd.BtnSaveClick(Sender: TObject);
var nList: TStrings;
begin
  if GetSelectedRwd() = '' then
  begin
    ShowMsg('请在上面的列表中选择配比', sHint);
    Exit;
  end;

  BtnSave.Enabled := False;
  nList := nil;
  try
    nList := TStringList.Create;
    MakeSQLList(nList);
    gDBConnManager.ExecSQLs(nList, True, sSCCtrl);
  finally
    nList.Free;
    BtnSave.Enabled := True;
    ShowMsg('保存成功', sHint);
  end;
end;

end.
