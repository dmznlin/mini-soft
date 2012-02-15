{*******************************************************************************
  作者: dmzn@163.com 2011-6-15
  描述: cxLookupComboBox适配器

  备注:
  *.本单元为cxLookupComboBox提供数据源支持.
*******************************************************************************}
unit USysLookupAdapter;

interface

uses
  Windows, Classes, SysUtils, cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox,
  DB, ADODB, ULibFun;

type
  TLookupComboBoxColumn = record
    FCaption: string;
    FField: string;
    FAlign: TAlignment;
    FWidth: Integer;
    FAutoSize: Boolean;
  end;

  TLookupComboBoxColumnArray = array of TLookupComboBoxColumn;

  PLookupComboBoxItem = ^TLookupComboBoxItem;
  TLookupComboBoxItem = record
    FItemID: string;
    FGroupID: string;
    //标识
    FSQL: string;
    FAQ: TADOQuery;
    FDS: TDataSource;
    //数据源
    FDispField: Integer;
    FKeyFields: string;
    FColCount: Integer;
    FColumns: array[0..10] of TLookupComboBoxColumn;
  end;

  TLookupComboBoxAdapter = class(TObject)
  private
    FConn: TADOConnection;
    //数据连接
    FItems: TList;
    //对象列表
  protected
    procedure DisposeItem(const nIdx: Integer);
    procedure ClearItems(const nFree: Boolean);
    //清理资源
    function FindItem(const nID: string): Integer;
    //检索对象
  public
    constructor Create(const nConn: TADOConnection);
    destructor Destroy; override;
    //创建释放
    function MakeItem(const nGroup,nID,nSQL,nKeys: string; const nDisplay: Integer;
      const nColumns: array of TMacroItem;
      const nAutoSizeCols: TDynamicStrArray = nil): TLookupComboBoxItem; overload;
    function MakeItem(const nGroup,nID,nSQL,nKeys: string; const nDisplay: Integer;
      const nColumns: TLookupComboBoxColumnArray): TLookupComboBoxItem; overload;
    //构建对象
    function AddItem(const nItem: TLookupComboBoxItem): Integer;
    function DeleteItem(const nID: string): Integer;
    procedure DeleteGroup(const nGroup: string); 
    //添加删除
    function BindItem(const nID: string; const nItem: TcxLookupComboBox): Boolean;
    //绑定对象
    property Connection: TADOConnection read FConn write FConn;
    property Items: TList read FItems write FItems;
    //属性相关
  end;

var
  gLookupComboBoxAdapter: TLookupComboBoxAdapter = nil;
  //全局使用

implementation

constructor TLookupComboBoxAdapter.Create(const nConn: TADOConnection);
begin
  FConn := nConn;
  FItems := TList.Create;
end;

destructor TLookupComboBoxAdapter.Destroy;
begin
  ClearItems(True);
  inherited;
end;

procedure TLookupComboBoxAdapter.DisposeItem(const nIdx: Integer);
var nItem: PLookupComboBoxItem;
begin
  nItem := FItems[nIdx];
  nItem.FAQ.Free;
  nItem.FDS.Free;

  Dispose(nItem);
  FItems.Delete(nIdx);
end;

procedure TLookupComboBoxAdapter.ClearItems(const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx:=FItems.Count - 1 downto 0 do
    DisposeItem(nIdx);
  if nFree then FItems.Free;
end;

function TLookupComboBoxAdapter.FindItem(const nID: string): Integer;
var nIdx: Integer;
begin
  Result := -1;

  for nIdx:=FItems.Count - 1 downto 0 do
  if PLookupComboBoxItem(FItems[nIdx]).FItemID = nID then
  begin
    Result := nIdx; Exit;
  end;
end;

function TLookupComboBoxAdapter.AddItem(const nItem: TLookupComboBoxItem): Integer;
var nTmp: PLookupComboBoxItem;
begin
  Result := FindItem(nItem.FItemID);
  if Result < 0 then
  begin
    New(nTmp);
    Result := FItems.Add(nTmp);

    nTmp.FAQ := nil;
    nTmp.FDS := nil;
  end else nTmp := FItems[Result];

  with nItem do
  begin
    nTmp.FItemID := FItemID;
    nTmp.FGroupID := FGroupID;
    nTmp.FSQL := FSQL;

    nTmp.FDispField := FDispField;
    nTmp.FKeyFields := FKeyFields;
    nTmp.FColCount := FColCount;
    nTmp.FColumns := FColumns;

    if not Assigned(nTmp.FAQ) then
      nTmp.FAQ := TADOQuery.Create(nil);
    if not Assigned(nTmp.FDS) then
      nTmp.FDS := TDataSource.Create(nil);
    nTmp.FDS.DataSet := nTmp.FAQ;
  end;
end;

function TLookupComboBoxAdapter.DeleteItem(const nID: string): Integer;
begin
  Result := FindItem(nID);
  if Result > -1 then DisposeItem(Result);
end;

procedure TLookupComboBoxAdapter.DeleteGroup(const nGroup: string);
var nIdx: Integer;
begin
  for nIdx:=FItems.Count - 1 downto 0 do
   if PLookupComboBoxItem(FItems[nIdx]).FGroupID = nGroup then
    DisposeItem(nIdx);
  //xxxxx
end;

function TLookupComboBoxAdapter.MakeItem(const nGroup,nID,nSQL,nKeys: string;
  const nDisplay: Integer;
  const nColumns: TLookupComboBoxColumnArray): TLookupComboBoxItem;
var nIdx: Integer;
begin
  with Result do
  begin
    FItemID := nID;
    FGroupID := nGroup;
    FSQL := nSQL;
    FKeyFields := nKeys;

    FDispField := nDisplay;
    FColCount := 0;

    for nIdx:=Low(nColumns) to High(nColumns) do
    begin
      FColumns[FColCount] := nColumns[nIdx];
      Inc(FColCount);                         
      if FColCount > High(FColumns) then Exit;
    end;
  end;
end;

function TLookupComboBoxAdapter.MakeItem(const nGroup,nID,nSQL,nKeys: string;
  const nDisplay: Integer;  const nColumns: array of TMacroItem;
  const nAutoSizeCols: TDynamicStrArray): TLookupComboBoxItem;
var i,nIdx: Integer;
begin
  with Result do
  begin
    FItemID := nID;
    FGroupID := nGroup;
    FSQL := nSQL;

    FKeyFields := nKeys;
    FDispField := nDisplay;
    FColCount := 0;

    for nIdx:=Low(nColumns) to High(nColumns) do
    with FColumns[FColCount] do
    begin
      FCaption := nColumns[nIdx].FValue;
      FField := nColumns[nIdx].FMacro;
      FAlign := taLeftJustify;
      FWidth := 65;
      FAutoSize := False;

      if Assigned(nAutoSizeCols) then
      begin
        for i:=Low(nAutoSizeCols) to High(nAutoSizeCols) do
        if CompareText(nAutoSizeCols[i], FField) = 0 then
        begin
          FAutoSize := True; Break;
        end;
      end;

      Inc(FColCount);
      if FColCount > High(FColumns) then Exit;
    end;
  end;
end;

function TLookupComboBoxAdapter.BindItem(const nID: string;
  const nItem: TcxLookupComboBox): Boolean;
var nField: TField;
    i,nIdx,nLen,nMax: Integer;
begin
  nIdx := FindItem(nID);
  Result := nIdx > -1;
  if not Result then Exit;

  with nItem.Properties,PLookupComboBoxItem(FItems[nIdx])^ do
  begin
    DropDownRows := 16;
    KeyFieldNames := FKeyFields;
    ListColumns.Clear;

    for i:=0 to FColCount -1 do
    with ListColumns.Add,FColumns[i] do
    begin
      Caption := FCaption;
      FieldName := FField;
      HeaderAlignment := FAlign;

      Width := FWidth;
      Fixed := FAutoSize;
    end;

    ListFieldIndex := FDispField;
    ListSource := FDS;
    FAQ.Connection := FConn;

    with FAQ do
    begin
      Close;
      SQL.Text := FSQL;
      Open;

      if RecordCount > 0 then
      begin
        for i:=ListColumns.Count - 1 downto 0 do
        begin
          if not ListColumns[i].Fixed then Continue;
          nField := FindField(ListColumns[i].FieldName);
          if not Assigned(nField) then Continue;

          nItem.Canvas.Font.Assign(nItem.Style.Font);
          nMax := nItem.Canvas.TextWidth(ListColumns[i].Caption);
          First;

          while not Eof do
          begin
            nLen := nItem.Canvas.TextWidth(nField.AsString);
            if nLen > nMax then nMax := nLen;
            Next;
          end;

          ListColumns[i].Width := nMax + 12;
          //max field
        end;
      end;
    end;
  end;
end;

initialization
  //none action
finalization
  FreeAndNil(gLookupComboBoxAdapter);
end.
