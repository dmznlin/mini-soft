unit UFromMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ExtCtrls, ComCtrls, cxGridLevel,
  cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, StdCtrls, ADODB,
  cxLookAndFeels, ImgList;

type
  TfDemoFormMain = class(TForm)
    TableView1: TcxGridDBTableView;
    Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    StatusBar1: TStatusBar;
    wPanel: TPanel;
    BtnConn: TButton;
    Edit_SQL: TLabeledEdit;
    BtnOK: TButton;
    cxLookAndFeel1: TcxLookAndFeelController;
    LTv1: TTreeView;
    Splitter1: TSplitter;
    ImageList1: TImageList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BtnConnClick(Sender: TObject);
    procedure LTv1DblClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure TableView1DblClick(Sender: TObject);
  private
    { Private declarations }
    procedure LockMainForm(const nLock: Boolean);
    procedure FormLoadConfig;
    procedure FormSaveConfig;

    function ActiveEntity(var nProg,nEntity: string): Boolean;
    {*活动节点*}
    function GetProgNode(const nProgID: string): TTreeNode;
    {*实体节点*}
    procedure BuildEntityTree;
    {*实体列表*}
  public
    { Public declarations }
  end;

var
  fDemoFormMain: TfDemoFormMain;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrDataDict, UDataModule, UFormConn, UFormWait,
  USysFun, USysConst, USysDataDict;

//------------------------------------------------------------------------------
procedure TfDemoFormMain.FormCreate(Sender: TObject);
begin
  InitSystemEnvironment;
  InitGlobalVariant(gPath, gPath + sFormConfig, gPath + sFormConfig, gPath + sDBConfig);
  PopMsgOnOff(False);

  LoadSysParameter;
  FormLoadConfig;
  LockMainForm(True);
end;

procedure TfDemoFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FormSaveConfig;
end;

procedure TfDemoFormMain.FormLoadConfig;
var nInt: integer;
    nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self);
    Edit_SQL.Text := nIni.ReadString(Name, 'LastSQL', '');

    nInt := nIni.ReadInteger(Name, 'TreeWidth', 0);
    if nInt > 20 then LTv1.Width := nInt;
  finally
    nIni.Free;
  end;
end;

procedure TfDemoFormMain.FormSaveConfig;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self);
    nIni.WriteString(Name, 'LastSQL', Edit_SQL.Text);
    nIni.WriteInteger(Name, 'TreeWidth', LTv1.Width);
  finally
    nIni.Free;
  end;
end;

procedure TfDemoFormMain.LockMainForm(const nLock: Boolean);
begin
  BtnOK.Enabled := not nLock;  
end;

//Desc: 连接测试回调
function TestConn(const nConnStr: string): Boolean;
begin
  FDM.ADOConn.Close;
  FDM.ADOConn.ConnectionString := nConnStr;
  FDM.ADOConn.Open;
  Result := FDM.ADOConn.Connected;
end;

//------------------------------------------------------------------------------
//Desc: 搜索ProgID为nProgID的节点
function TfDemoFormMain.GetProgNode(const nProgID: string): TTreeNode;
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
procedure TfDemoFormMain.BuildEntityTree;
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

//------------------------------------------------------------------------------
//Desc: 连接数据库
procedure TfDemoFormMain.BtnConnClick(Sender: TObject);
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

      LockMainForm(not FDM.ADOConn.Connected);
      StatusBar1.SimpleText := ' ※.' + nStr;
      BuildEntityTree;
    except
      ShowDlg('连接数据库失败,配置错误或远程无响应', '', Handle); Exit;
    end;
  finally
    CloseWaitForm;
  end;
end;

//Desc: 获取活动实体标识
function TfDemoFormMain.ActiveEntity(var nProg,nEntity: string): Boolean;
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

//Desc: 切换实体
procedure TfDemoFormMain.LTv1DblClick(Sender: TObject);
var nProg,nEntity: string;
begin
  if ActiveEntity(nProg, nEntity) and (nEntity <> '') then
  begin
    gSysParam.FProgID := nProg;
    gSysEntityManager.ProgID := nProg;
    gSysEntityManager.BuildViewColumn(TableView1, nEntity);
  end;
end;

//Desc: 载入数据
procedure TfDemoFormMain.BtnOKClick(Sender: TObject);
begin
  FDM.SQLQuery.Close;
  FDM.SQLQuery.SQL.Text := Edit_SQL.Text;
  FDM.SQLQuery.Open;
end;

//Desc: 保存表头宽度和位置索引
procedure TfDemoFormMain.TableView1DblClick(Sender: TObject);
var nRes: Boolean;
    nInt: integer;
    i,nCount: integer;
    nItem: PDictItemData;
    nState: TKeyboardState;
begin
  GetKeyboardState(nState);
  if nState[VK_CONTROL] and 128 = 0 then Exit;

  nRes := False;
  nCount := TableView1.ColumnCount - 1;

  for i:=0 to nCount do
  begin
    nInt := TableView1.Columns[i].Tag;
    nItem := gSysEntityManager.ActiveEntity.FDictItem[nInt];

    nInt := TableView1.Columns[i].Width;
    nRes := gSysEntityManager.UpdateActiveDictItem(nItem.FItemID, nInt, i);
    if not nRes then Break;
  end;

  if nRes then
    ShowHintMsg('表头宽度和顺序已保存', sHint, Handle);
  //xxxxx
end;

end.
