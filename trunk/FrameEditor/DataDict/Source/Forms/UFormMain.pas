{*******************************************************************************
  作者: dmzn@163.com 2008-8-9
  描述: 字典编辑器主单元
*******************************************************************************}
unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxCustomData, 
  cxEdit, cxSplitter, Menus, cxLookAndFeels, ExtCtrls,
  ImgList, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxClasses, cxControls, cxGridCustomView, cxGrid,
  ComCtrls, cxPC, ToolWin, cxStyles, cxGraphics, cxFilter, cxData,
  cxDataStorage;

type
  TfFormMain = class(TForm)
    ImageList1: TImageList;
    sBar: TStatusBar;
    ToolBar1: TToolBar;
    Btn_ConnDB: TToolButton;
    Btn_AddDetail: TToolButton;
    ToolButton1: TToolButton;
    Btn_AddEntity: TToolButton;
    Btn_DelDetail: TToolButton;
    ToolButton2: TToolButton;
    Btn_Exit: TToolButton;
    Timer1: TTimer;
    cxLook1: TcxLookAndFeelController;
    wPage: TcxPageControl;
    Sheet1: TcxTabSheet;
    ToolButton3: TToolButton;
    Btn_DelEntity: TToolButton;
    LeftPanel: TPanel;
    LTv1: TTreeView;
    Level1: TcxGridLevel;
    GridDict: TcxGrid;
    PMenu1: TPopupMenu;
    mRefresh: TMenuItem;
    mEdit: TMenuItem;
    TableView1: TcxGridBandedTableView;
    ableView1Column1: TcxGridBandedColumn;
    ableView1Column2: TcxGridBandedColumn;
    ableView1Column3: TcxGridBandedColumn;
    ableView1Column4: TcxGridBandedColumn;
    ableView1Column5: TcxGridBandedColumn;
    ableView1Column6: TcxGridBandedColumn;
    ableView1Column7: TcxGridBandedColumn;
    ableView1Column8: TcxGridBandedColumn;
    ableView1Column9: TcxGridBandedColumn;
    ableView1Column10: TcxGridBandedColumn;
    ableView1Column11: TcxGridBandedColumn;
    ableView1Column12: TcxGridBandedColumn;
    ableView1Column13: TcxGridBandedColumn;
    ableView1Column14: TcxGridBandedColumn;
    ableView1Column15: TcxGridBandedColumn;
    ableView1Column16: TcxGridBandedColumn;
    ableView1Column17: TcxGridBandedColumn;
    ableView1Column18: TcxGridBandedColumn;
    ableView1Column19: TcxGridBandedColumn;
    ableView1Column20: TcxGridBandedColumn;
    cxSplitter1: TcxSplitter;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Btn_ExitClick(Sender: TObject);
    procedure Btn_AddEntityClick(Sender: TObject);
    procedure Btn_ConnDBClick(Sender: TObject);
    procedure Btn_AddDetailClick(Sender: TObject);
    procedure Btn_DelDetailClick(Sender: TObject);
    procedure Btn_DelEntityClick(Sender: TObject);
    procedure mRefreshClick(Sender: TObject);
    procedure mEditClick(Sender: TObject);
    procedure LTv1DblClick(Sender: TObject);
    procedure TableView1DblClick(Sender: TObject);
    procedure ToolBar1DblClick(Sender: TObject);
  private
    { Private declarations }
    FActiveEntity: string;
    {*活动实体*}
  protected
    procedure FormLoadConfig;
    procedure FormSaveConfig;
    procedure LoadGridColumn(const nView: TcxGridTableView; const nWidth: string);
    function BuildGridColumn(const nView: TcxGridTableView): string;
    {*载入,保存配置*}

    procedure LockMainForm(const nLock: Boolean);
    {*锁定界面*}
    function GetProgNode(const nProgID: string): TTreeNode;
    {*实体节点*}
    procedure BuildEntityTree;
    {*实体列表*}
    procedure LoadEntityItemList(const nEntity: string);
    {*载入字典*}
    function ActiveEntity(var nProg,nEntity: string): Boolean;
    {*活动实体*}
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  IniFiles, UMgrVar, UMgrThemeCX, UMgrDataDict, UcxChinese, ULibFun,
  USysConst, USysFun, USysDict, USysDataSet, UDataModule, UFormWait, UFormConn,
  UFormEntity, UFormDict;

//------------------------------------------------------------------------------
//Desc: 载入窗体配置
procedure TfFormMain.FormLoadConfig;
var nStr: string;
    nIni: TIniFile;
begin
  Application.Title := gSysParam.FAppTitle;
  nStr := GetFileVersionStr(Application.ExeName);

  if nStr <> '' then
  begin
    nStr := Copy(nStr, 1, Pos('.', nStr) - 1);
    Caption := gSysParam.FMainTitle + ' V' + nStr;
  end else Caption := gSysParam.FMainTitle;

  gStatusBar := sBar;
  nStr := Format(sDate, [DateToStr(Now)]);
  StatusBarMsg(nStr, cSBar_Date);

  nStr := Format(sTime, [TimeToStr(Now)]);
  StatusBarMsg(nStr, cSBar_Time);

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    nStr := nIni.ReadString(Name, 'GridColumn', '');
    if nStr <> '' then LoadGridColumn(TableView1, nStr);

    nStr := nIni.ReadString(Name, 'LeftPanel', '');
    if IsNumber(nStr, False) and (StrToInt(nStr) > 100) then
      LeftPanel.Width := StrToInt(nStr);

    nStr := nIni.ReadString(sSetupSec, 'Theme', '');
    if (nStr <> '') and gCxThemeManager.LoadTheme(nStr) then
    begin
      gCxThemeManager.ApplyTheme(Self); 
    end;
  finally
    nIni.Free;
  end;
end;

//Desc: 保存窗体配置
procedure TfFormMain.FormSaveConfig;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    nIni.WriteString(Name, 'GridColumn', BuildGridColumn(TableView1));

    if cxSplitter1.State = ssClosed then
      cxSplitter1.State := ssOpened;
    nIni.WriteInteger(Name, 'LeftPanel', LeftPanel.Width);
  finally
    nIni.Free;
  end;
end;

procedure TfFormMain.FormCreate(Sender: TObject);
begin
  InitSystemEnvironment;
  LoadSysParameter;
  InitGlobalVariant(gPath, gPath + sConfigFile, gPath + sFormConfig, gPath + sDBConfig);

  if not IsValidConfigFile(gPath + sConfigFile, gSysParam.FProgID) then
  begin
    ShowDlg(sInvalidConfig, sHint);
    Application.Terminate;
  end;

  FormLoadConfig;
  LockMainForm(True);
  TableView1.DataController.CustomDataSource := gSysDataSet;
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if QueryDlg(sCloseQuery, sAsk) then
  begin
    Action := caFree;
    FormSaveConfig;
  end else Action := caNone;
end;

//------------------------------------------------------------------------------ 
//Desc: 构建nView表头宽度字符串
function TfFormMain.BuildGridColumn(const nView: TcxGridTableView): string;
var i,nCount: integer;
begin
  Result := '';
  nCount := nView.ColumnCount - 1;

  for i:=0 to nCount do
  begin
    Result := Result + IntToStr(nView.Columns[i].Width);
    if i < nCount then Result := Result + ';';
  end;
end;

//Desc: 载入nView的宽度配置nWidth
procedure TfFormMain.LoadGridColumn(const nView: TcxGridTableView;
  const nWidth: string);
var nList: TStrings;
    i,nCount: integer;
begin
  nList := TStringList.Create;
  try
    if not SplitStr(nWidth, nList, nView.ColumnCount) then Exit;
    nCount := nView.ColumnCount - 1;

    for i:=0 to nCount do
    if IsNumber(nList[i], False) then
      nView.Columns[i].Width := StrToInt(nList[i]);
    //xxxxx
  finally
    nList.Free;
  end;
end;

procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  sBar.Panels[cSBar_Date].Text := Format(sDate, [DateToStr(Now)]);
  sBar.Panels[cSBar_Time].Text := Format(sTime, [TimeToStr(Now)]);
end;

//Desc: 锁定界面
procedure TfFormMain.LockMainForm(const nLock: Boolean);
var i,nCount: integer;
begin
  nCount := ToolBar1.ButtonCount - 1;
  for i:=0 to nCount do
   if (ToolBar1.Buttons[i] <> Btn_Exit) and (ToolBar1.Buttons[i] <> Btn_ConnDB) then
    ToolBar1.Buttons[i].Enabled := not nLock;

  LTv1.Enabled := not nLock;
  GridDict.Enabled := not nLock;
end;

//Desc: 搜索ProgID为nProgID的节点
function TfFormMain.GetProgNode(const nProgID: string): TTreeNode;
var nList: TList;
    nInt: integer;
    i,nCount: integer;
begin
  Result := nil;
  nCount := LTv1.Items.Count - 1;
  nList := gSysEntityManager.ProgList;

  for i:=0 to nCount do
  begin
    nInt := LTv1.Items[i].StateIndex;
    with PEntityItemData(nList[nInt])^ do
    if CompareText(nProgID, FProgID) = 0 then
    begin
      Result := LTv1.Items[i]; Break;
    end;
  end;                               
end;

//Desc: 构建实体列表
procedure TfFormMain.BuildEntityTree;
var nStr: string;
    nList: TList;
    nNode: TTreeNode;
    i,nCount: integer;
begin
  LTv1.Items.BeginUpdate;
  try
    LTv1.Items.Clear;
    if not gSysEntityManager.LoadProgList then Exit;
    
    nList := gSysEntityManager.ProgList;
    nCount := nList.Count - 1;

    for i:=0 to nCount do
    with PEntityItemData(nList[i])^ do
    begin
      nStr := '%s[ %s ]';
      if FEntity = '' then
      begin
        nNode := nil;
        nStr := Format(nStr, [FTitle, FProgID]);
      end else
      begin
        nNode := GetProgNode(FProgID);
        nStr := Format(nStr, [FTitle, FEntity]);
      end;

      with LTv1.Items.AddChild(nNode, nStr) do
      begin
        StateIndex := i;
        if nNode = nil then
             ImageIndex := 7
        else ImageIndex := 8;
        SelectedIndex := ImageIndex;
      end;
    end;
  finally
    if LTv1.Items.Count < 1 then
    begin
      LockMainForm(False);
      with LTv1.Items.AddChild(nil, '没有实体') do
      begin
        ImageIndex := 7;
        SelectedIndex := ImageIndex;
      end;
    end else
    begin
      LockMainForm(False);
      LTv1.FullExpand;
    end;
    LTv1.Items.EndUpdate;
  end;    
end;

//Desc: 获取活动实体标识
function TfFormMain.ActiveEntity(var nProg,nEntity: string): Boolean;
var nIdx: integer;
begin
  nProg := '';
  nEntity := '';

  if Assigned(LTv1.Selected) then
  begin
    nIdx := LTv1.Selected.StateIndex;
    if (nIdx > -1) and (nIdx < gSysEntityManager.ProgList.Count) then
    with PEntityItemData(gSysEntityManager.ProgList[nIdx])^ do
    begin
      nProg := FProgID;
      nEntity := FEntity;
    end;
  end;

  Result := nProg <> '';
end;

//Desc: 载入nEntity的所有字典项
procedure TfFormMain.LoadEntityItemList(const nEntity: string);
begin
  if nEntity = FActiveEntity then
       Exit
  else FActiveEntity := nEntity;
  
  gSysEntityManager.LoadEntity(nEntity, True);
  gSysDataSet.DataChanged;
end;

//------------------------------------------------------------------------------
//Desc: 退出
procedure TfFormMain.Btn_ExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 连接测试回调
function TestConn(const nConnStr: string): Boolean;
begin
  FDM.ADOConn.Close;
  FDM.ADOConn.ConnectionString := nConnStr;
  FDM.ADOConn.Open;
  Result := FDM.ADOConn.Connected;
end;

//Desc: 连接数据库
procedure TfFormMain.Btn_ConnDBClick(Sender: TObject);
var nStr: string;
begin
  if ShowConnectDBSetupForm(TestConn) then
       nStr := BuildConnectDBStr
  else Exit;
  
  ShowWaitForm(Self, '连接数据库');
  try
    try
      FDM.ADOConn.Connected := False;
      FDM.ADOConn.ConnectionString := nStr;
      FDM.ADOConn.Connected := True;

      if not gSysEntityManager.CreateTable then
       raise Exception.Create('');
      BuildEntityTree;
    except
      ShowDlg('连接数据库失败,配置错误或远程无响应', sWarn, Handle); Exit;
    end;
  finally
    CloseWaitForm;
  end;
end;

//Decc: 添加实体
procedure TfFormMain.Btn_AddEntityClick(Sender: TObject);
begin
  if ShowAddEntityForm then BuildEntityTree;
end;

//Desc: 编辑实体
procedure TfFormMain.mEditClick(Sender: TObject);
var nInt: integer;
    nProg,nEntity: string;
begin
  if LTv1.Focused then
  begin
    if ActiveEntity(nProg, nEntity) and
       ShowEditEntityForm(nProg, nEntity) then BuildEntityTree;
  end else

  if TableView1.Site.Focused then
  with gSysDataSet do
  begin
    nInt := DataController.FocusedRecordIndex;
    if nInt < 0 then Exit;

    nProg := DataController.Values[nInt, 0];
    if IsNumber(nProg, False) then
      ShowEditDictItemForm(FActiveEntity, StrToInt(nProg));
    //xxxxx
  end;
end;

//Desc: 删除实体
procedure TfFormMain.Btn_DelEntityClick(Sender: TObject);
var nProg,nEntity: string;
begin
  if ActiveEntity(nProg, nEntity) and
     QueryDlg('确定要删除选中的实体吗?', sAsk, Handle) and
     ((nEntity = '') or gSysEntityManager.DelDictEntityItem(nEntity)) then
  begin
    if (FActiveEntity <> '') and (nEntity = FActiveEntity) then
    begin
      FActiveEntity := '';
      gSysDataSet.DataChanged;
      ShowMsgOnLastPanelOfStatusBar('');
    end;
    if gSysEntityManager.DelEntityFromDB(nProg, nEntity) then BuildEntityTree;
  end;
end;

//Desc: 刷新实体列表
procedure TfFormMain.mRefreshClick(Sender: TObject);
begin
  if GridDict.Focused then
    gSysDataSet.DataChanged else
  if LTv1.Focused then
    BuildEntityTree;
end;

//Desc: 增加明细
procedure TfFormMain.Btn_AddDetailClick(Sender: TObject);
begin
  if FActiveEntity <> ''  then
  begin
    ShowAddDictItemForm(FActiveEntity);
  end;
end;

//Desc: 删除明细
procedure TfFormMain.Btn_DelDetailClick(Sender: TObject);
var nInt: integer;
    nItemID: integer;
begin
  with gSysDataSet do
  begin
    nInt := DataController.GetSelectedCount;
    if nInt > 0 then
    begin
      nInt := DataController.FocusedRecordIndex;
      if nInt < 0 then Exit;

      nItemID := DataController.Values[nInt, 0];
      if gSysEntityManager.DelDictItemFromDB(FActiveEntity, nItemID) then
        gSysDataSet.DataChanged;
    end;
  end;
end;

//Desc: 切换实体
procedure TfFormMain.LTv1DblClick(Sender: TObject);
var nProg,nEntity: string;
begin
  if ActiveEntity(nProg, nEntity) and (nEntity <> '') then
  begin
    gSysParam.FProgID := nProg;
    gSysEntityManager.ProgID := nProg;

    LoadEntityItemList(nEntity);
    UpdateDictItemFormEntity(nEntity);

    nProg := '当前数据: ' + LTv1.Selected.Text;
    ShowMsgOnLastPanelOfStatusBar(nProg);
  end;
end;

//Desc: 带入参数到编辑窗口
procedure TfFormMain.TableView1DblClick(Sender: TObject);
var nInt: integer;
    nItemID: integer;
begin
  with gSysDataSet do
  begin
    nInt := DataController.GetSelectedCount;
    if nInt > 0 then
    begin
      nInt := DataController.FocusedRecordIndex;
      if nInt < 0 then Exit;
      
      nItemID := DataController.Values[nInt, 0];
      SetDictItemFormData(nItemID);
    end;
  end;
end;

//Desc: 控制实体列表显隐
procedure TfFormMain.ToolBar1DblClick(Sender: TObject);
begin
  if cxSplitter1.State = ssClosed then
       cxSplitter1.State := ssOpened
  else cxSplitter1.State := ssClosed;
end;

end.
