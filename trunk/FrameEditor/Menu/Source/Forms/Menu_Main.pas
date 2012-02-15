{*******************************************************************************
  作者: dmzn@163.com 2007-11-8
  描述: 菜单编辑器主菜单 
*******************************************************************************}
unit Menu_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menu_DM, IniFiles, cxStyles, 
  cxEdit, DB, cxDBData, cxGridTableView,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridDBTableView, cxGrid, ComCtrls, ToolWin,
  cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage;

type
  TFrmMain = class(TForm)
    ToolBar1: TToolBar;
    BtnConn: TToolButton;
    BtnFresh: TToolButton;
    BtnAdd: TToolButton;
    StatusBar1: TStatusBar;
    cxView1: TcxGridDBTableView;
    cxLevel1: TcxGridLevel;
    cxGrid1: TcxGrid;
    DataSource1: TDataSource;
    ToolButton4: TToolButton;
    BtnDel: TToolButton;
    ToolButton6: TToolButton;
    BtnPreview: TToolButton;
    BtnExit: TToolButton;
    StyleRepository: TcxStyleRepository;
    Sunny: TcxStyle;
    Dark: TcxStyle;
    Golden: TcxStyle;
    Summer: TcxStyle;
    Autumn: TcxStyle;
    Bright: TcxStyle;
    Cold: TcxStyle;
    Spring: TcxStyle;
    Light: TcxStyle;
    Winter: TcxStyle;
    Depth: TcxStyle;
    UserStyleSheet: TcxGridTableViewStyleSheet;
    BtnEdit: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnConnClick(Sender: TObject);
    procedure BtnFreshClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnPreviewClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadColumnInfo(const nIni: TIniFile);
    procedure SaveColumnInfo(const nIni: TIniFile);
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

uses
  UMgrMenu, Menu_Const, Menu_AddNew, Menu_AddEntity, Menu_Demo, UMgrVar,
  UcxChinese, ULibFun, UFormConn;

type
  TMenuManager = class(TBaseMenuManager)
  protected
    function QuerySQL(const nSQL: string;
      var nDS: TDataSet; var nAutoFree: Boolean): Boolean; override;
    {*查询操作*}
    function ExecSQL(const nSQL: string): integer; override;
    {*写操作*}
    function GetItemValue(const nItem: integer): string; override;
    {*获取对象*}
    function IsTableExists(const nTable: string): Boolean; override;
    {*判断表是否存在*}
  end;

var
  gMenuManager: TMenuManager;
  //菜单管理器

//------------------------------------------------------------------------------
function TMenuManager.ExecSQL(const nSQL: string): integer;
begin
  FDM.SQLCmd.Close;
  FDM.SQLCmd.SQL.Text := nSQL;
  Result := FDM.SQLCmd.ExecSQL;
end;

function TMenuManager.IsTableExists(const nTable: string): Boolean;
var nList: TStrings;
begin
  nList := TStringList.Create;
  try
    FDM.Connection1.GetTableNames(nList);
    Result := nList.IndexOf(nTable) > -1;
  finally
    nList.Free;
  end;
end;

function TMenuManager.QuerySQL(const nSQL: string; var nDS: TDataSet;
  var nAutoFree: Boolean): Boolean;
begin
  Result := True;
  nAutoFree := False;
  nDS := FDM.SQLTemp;

  FDM.SQLTemp.Close;
  FDM.SQLTemp.SQL.Text := nSQL;
  FDM.SQLTemp.Open;
end;

function TMenuManager.GetItemValue(const nItem: integer): string;
begin
  case nItem of
    cMenuTable_Menu : Result := gMenuTable;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 载入cxGrid配置
procedure TFrmMain.LoadColumnInfo(const nIni: TIniFile);
var nIdx: integer;
    nStr,nCol,nSec: string;
begin
  nSec := 'Grid';
  for nIdx:=0 to 100 do
  begin
    nCol :=  'Column' + IntToStr(nIdx);
    nStr := nIni.ReadString(nSec, nCol, '');
    if nStr = '' then Break;

    with cxView1.CreateColumn do
    begin
      DataBinding.FieldName := nStr;
      Width := nIni.ReadInteger(nSec, nCol + '_Width', 55);
      Caption := nIni.ReadString(nSec, nCol + '_Title', 'NoName');
    end;
  end;
end;

//Desc: 保存表格宽度
procedure TFrmMain.SaveColumnInfo(const nIni: TIniFile);
var i,nCount: integer;
    nSec,nCol: string;
begin
  nSec := 'Grid';
  nCount := cxView1.ColumnCount - 1;

  for i:=0 to nCount do
  begin
    nCol := 'Column' + IntToStr(i) + '_Width';
    nIni.WriteInteger(nSec, nCol, cxView1.Columns[i].Width);
  end;
end;

//------------------------------------------------------------------------------
procedure TFrmMain.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  gPath := ExtractFilePath(Application.ExeName);
  InitGlobalVariant(gPath, gPath + sConfigFile, gPath + sConfigFile, gPath + sDBConfig);

  gMenuManager := TMenuManager.Create;
  nIni := TIniFile.Create(gPath + sConfigFile);
  try
    LoadFormConfig(Self, nIni);
    LoadColumnInfo(nIni);

    nIni.Free;
    nIni := TIniFile.Create(gPath + sDBConfig);
    gMenuTable := nIni.ReadString('DBTable', 'TableMenu', sMenuTable);
  finally
    nIni.Free;
  end;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var nIni: TIniFile;
begin
  gMenuManager.Free;
  nIni := TIniFile.Create(gPath + sConfigFile);
  try
    SaveFormConfig(Self, nIni);
    SaveColumnInfo(nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
procedure TFrmMain.BtnExitClick(Sender: TObject);
begin
  if QueryDlg('确定要退出菜单编辑器吗', sAsk, Handle) then Close;
end;

//Desc: 测试nConnStr是否有效
function ConnCallBack(const nConnStr: string): Boolean;
begin
  FDM.Connection1.Close;
  FDM.Connection1.ConnectionString := nConnStr;
  FDM.Connection1.Open;               
  Result := FDM.Connection1.Connected;
end;

//Desc: 连接
procedure TFrmMain.BtnConnClick(Sender: TObject);
var nRes: Boolean;
begin
  nRes := ShowConnectDBSetupForm(ConnCallBack);
  if nRes then nRes := ConnCallBack(BuildConnectDBStr);

  if nRes and (not gMenuManager.CreateMenuTable) then
  begin
    ShowMsg('无法定位该数据库中的Menu表', sHint); nRes := False;
  end;

  BtnAdd.Enabled := nRes;
  BtnEdit.Enabled := nRes;
  BtnDel.Enabled := nRes;
  BtnFresh.Enabled := nRes;
  BtnPreview.Enabled := nRes;

  if nRes then
  begin
    BtnFreshClick(nil);
    StatusBar1.SimpleText := '※.连接: ' + FDM.Connection1.ConnectionString;
  end else StatusBar1.SimpleText := '※.连接: 无效';
end;

//Desc: 刷新
procedure TFrmMain.BtnFreshClick(Sender: TObject);
var nBM: Pointer;
begin
  nBM := FDM.SQLQuery.GetBookmark;
  try
    FDM.SQLQuery.Close;
    FDM.SQLQuery.SQL.Text := UpperCase('Select * from ' + gMenuTable);
    FDM.SQLQuery.Open;

    if FDM.SQLQuery.BookmarkValid(nBM) then
      FDM.SQLQuery.GotoBookmark(nBM);
  finally
    FDM.SQLQuery.FreeBookmark(nBM);
  end;
end;

//Desc: 添加新项
procedure TFrmMain.BtnAddClick(Sender: TObject);
var nRes: Boolean;
begin
  if (GetKeyState(VK_SHIFT) and $80 = 0) then
       nRes := ShowAddItemForm
  else nRes := ShowAddEntityForm;

  if nRes then BtnFreshClick(nil);
  //刷新
end;

//Desc: 删除
procedure TFrmMain.BtnDelClick(Sender: TObject);
var nDS: TDataSet;
begin
  nDS := cxView1.DataController.DataSet;

  if nDS.Active and (nDS.RecordCount > 0) and QueryDlg('确定要删除该菜单项吗', sAsk) then
  begin
    nDS.Delete;
    BtnFreshClick(nil);
    ShowMsg('删除成功', sHint);
  end;
end;

//Desc: 修改
procedure TFrmMain.BtnEditClick(Sender: TObject);
var nDS: TDataSet;
    nRes: Boolean;
    nProgID,nEntity,nMenuID: string;
begin
  nDS := cxView1.DataController.DataSet;

  if nDS.Active and (nDS.RecordCount > 0) then
  begin
    nProgID := nDS.FieldByName('M_ProgID').AsString;
    nEntity := nDS.FieldByName('M_Entity').AsString;
    nMenuID := nDS.FieldByName('M_MenuID').AsString;
  end else
  begin
    nProgID := '';
    nEntity := '';
    nMenuID := '';
  end;

  if nProgID <> '' then
  begin
    if nMenuID = '' then
         nRes := ShowEditEntityForm(nProgID, nEntity)
    else nRes := ShowEditItemForm(nProgID, nEntity, nMenuID);

    if nRes then BtnFreshClick(nil);
    //刷新
  end;
end;

//Desc: 预览
procedure TFrmMain.BtnPreviewClick(Sender: TObject);
var nDS: TDataSet;
    nProgID,nEntity: string;
begin
  nDS := cxView1.DataController.DataSet;

  if nDS.Active and (nDS.RecordCount > 0) then
  begin
    nProgID := nDS.FieldByName('M_ProgID').AsString;
    nEntity := nDS.FieldByName('M_Entity').AsString;
    if (nEntity <> '') and (nProgID <> '') then
         ShowPreviewForm(gMenuManager, nProgID, nEntity)
    else ShowMsg('该记录无法预览', sHint);
  end;
end;

end.
