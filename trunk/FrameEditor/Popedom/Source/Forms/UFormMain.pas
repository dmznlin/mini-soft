{*******************************************************************************
  作者: dmzn@163.com 2008-8-9
  描述: 编辑器主单元
*******************************************************************************}
unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxTL, Menus, cxLookAndFeels,
  ExtCtrls, ImgList, StdCtrls, ComCtrls, cxInplaceContainer, cxPC,
  cxControls, ToolWin, cxTextEdit, cxSplitter, cxGraphics, cxCustomData,
  cxStyles;

type
  TfFormMain = class(TForm)
    ImageList1: TImageList;
    sBar: TStatusBar;
    ToolBar1: TToolBar;
    Btn_PopItem: TToolButton;
    Btn_DelGroup: TToolButton;
    ToolButton1: TToolButton;
    Btn_AddGroup: TToolButton;
    Btn_AddUser: TToolButton;
    Btn_Exit: TToolButton;
    Timer1: TTimer;
    cxLook1: TcxLookAndFeelController;
    wPage: TcxPageControl;
    Sheet1: TcxTabSheet;
    PMenu1: TPopupMenu;
    ToolButton3: TToolButton;
    ToolButton2: TToolButton;
    Btn_DelUser: TToolButton;
    Panel_Left: TPanel;
    LTv1: TTreeView;
    GroupBox1: TGroupBox;
    ProgList: TComboBox;
    HintPanel: TPanel;
    BtnApply: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    mEdit: TMenuItem;
    mRefresh: TMenuItem;
    wPanel: TPanel;
    PopedomTree: TcxTreeList;
    StatusPanel: TPanel;
    PMenu2: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    mRefreshTree: TMenuItem;
    ImageList2: TImageList;
    Splitter1: TcxSplitter;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Btn_ExitClick(Sender: TObject);
    procedure Btn_AddGroupClick(Sender: TObject);
    procedure Btn_PopItemClick(Sender: TObject);
    procedure Btn_DelGroupClick(Sender: TObject);
    procedure Btn_AddUserClick(Sender: TObject);
    procedure Btn_DelUserClick(Sender: TObject);
    procedure ProgListChange(Sender: TObject);
    procedure mRefreshClick(Sender: TObject);
    procedure mEditClick(Sender: TObject);
    procedure PopedomTreeEditing(Sender: TObject;
      AColumn: TcxTreeListColumn; var Allow: Boolean);
    procedure N10Click(Sender: TObject);
    procedure PMenu2Popup(Sender: TObject);
    procedure mRefreshTreeClick(Sender: TObject);
    procedure PopedomTreeIsGroupNode(Sender: TObject;
      ANode: TcxTreeListNode; var IsGroup: Boolean);
    procedure PopedomTreeEditValueChanged(Sender: TObject;
      AColumn: TcxTreeListColumn);
    procedure LTv1Change(Sender: TObject; Node: TTreeNode);
    procedure BtnApplyClick(Sender: TObject);
  private
    { Private declarations }
    FNowID: string;
    FNowGroup: string;
    {*当前组*}
    FExpandGroup: TStrings;
    {节点展开的组}
    FGroupNum,FUserNum: integer;
    {*组,用户计数*}
  protected
    procedure SetGlobalVariant;
    {*全局变量*}
    procedure FormLoadConfig;
    procedure FormSaveConfig;
    {*载入,保存配置*}

    procedure LoadProgList;
    procedure LoadGroupList;
    procedure RefreshGroupList;
    {*载入组列表*}
    procedure LoadUnGroupUser(const nRoot: TTreeNode);
    {*未分组用户*}

    procedure LoadPopedomTreeColumn;
    procedure LoadPopedomItem;
    {*载入权限树*}
    procedure LoadPopedom(const nGroup: string);
    procedure LodNodePopedom(const nNode: TcxTreeListNode; const nPopedom: string);
    procedure LoadUserDefinePopedom;
    {*载入权限*}
    procedure LoadEntityItems(const nNode: TcxTreeListNode; const nEntity: string);
    procedure LoadEntitySubItems(const nNode: TcxTreeListNode; const nSub: TList);
    {*载入节点*}
    function BuildNodePopedom(const nNode: TcxTreeListNode): string;
    {*构建权限值*}
    procedure SetAllNodePopedom(const nType: integer);
    procedure SetColumnPopedom(const nColumn,nType: integer);
    {*调整权限*}
    procedure SaveTreeListColumn(const nTree: TcxTreeList; const nID: string);
    procedure LoadTreeListColumn(const nTree: TcxTreeList; const nID: string);
    {*表头宽度*}

    function SelectGroupID: string;
    {*选中组标识*}
    procedure LockMainForm(const nLock: Boolean);
    {*锁定界面*}
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  IniFiles, cxCheckBox, UMgrVar, UMgrTheme, UMgrThemeCX, UMgrPopedom, UMgrMenu,
  ULibFun, ULibRes, UcxChinese, USysFun, USysConst, USysPopedom, USysMenu,
  UDataModule, UFormWait, UFormPopItem, UFormLogin, UFormGroup, UFormUser;

const
  cImgGroup = 0;
  cImgUser  = 3;

ResourceString
  sNullGroup = '没有组信息';
  sRootGroup = '组列表';
  sHintProg = '※.当前程序:【%s】';
  sHintText1 = '※.共计组:【%d】个,用户:【%d】个';
  sHintText2 = '※.当前组:【%s】,下属用户:【%d】个';

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
    Panel_Left.Width := nIni.ReadInteger(sSetupSec, 'PanelLeft', 200);

    nStr := nIni.ReadString(sSetupSec, 'Theme', '');
    if (nStr <> '') and gCxThemeManager.LoadTheme(nStr) then
    begin
      gCxThemeManager.ApplyTheme(Self); 
    end;
  finally
    nIni.Free;
  end;

  FExpandGroup := TStringList.Create;
  LoadProgList;
end;

//Desc: 保存窗体配置
procedure TfFormMain.FormSaveConfig;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    if Splitter1.State <> ssClosed then
      nIni.WriteInteger(sSetupSec, 'PanelLeft', Panel_Left.Width);
    //xxxxx

    if gSysParam.FProgID <> '' then
      SaveTreeListColumn(PopedomTree, gSysParam.FProgID);
    //save column width
  finally
    nIni.Free;
  end;

  FExpandGroup.Free;
end;

//Desc: 设置全局变量
procedure TfFormMain.SetGlobalVariant;
begin
  gVariantManager.AddVarStr(sVar_AppPath, gPath);
  gVariantManager.AddVarStr(sVar_SysConfig, gPath + sConfigFile);
  gVariantManager.AddVarStr(sVar_FormConfig, gPath + sFormConfig);
  gVariantManager.AddVarStr(sVar_ConnDBConfig, gPath + sDBConnFile);
end;

procedure TfFormMain.FormCreate(Sender: TObject);
begin
  InitSystemEnvironment;
  LoadSysParameter;
  SetGlobalVariant;

  if not IsValidConfigFile(gPath + sConfigFile, gSysParam.FProgID) then
  begin
    ShowDlg(sInvalidConfig, sHint);
    Application.Terminate;
  end;

  if ShowLoginForm then
  begin
    FormLoadConfig;
  end else
  begin
    Application.Terminate;
  end;
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
procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  sBar.Panels[cSBar_Date].Text := Format(sDate, [DateToStr(Now)]);
  sBar.Panels[cSBar_Time].Text := Format(sTime, [TimeToStr(Now)]);
end;

//Desc: 以nID为标记保存nTree表头宽度
procedure TfFormMain.SaveTreeListColumn(const nTree: TcxTreeList; const nID: string);
var nStr: string;
    nIni: TIniFile;
    i,nCount: integer;
begin
  nStr := '';
  nCount := nTree.ColumnCount - 1;

  for i:=0 to nCount do
  if i = nCount then
       nStr := nStr + IntToStr(nTree.Columns[i].Width)
  else nStr := nStr + IntToStr(nTree.Columns[i].Width) + ';';

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nIni.WriteString(sSetupSec, nID + '_Column', nStr);
  finally
    nIni.Free;
  end;
end;

//Desc: 载入以nID为标记的nTree的表头宽度值
procedure TfFormMain.LoadTreeListColumn(const nTree: TcxTreeList; const nID: string);
var nStr: string;
    nIni: TIniFile;
    nList: TStrings;
    i,nCount: integer;
begin
  if nTree.ColumnCount < 1 then Exit;

  nIni := TIniFile.Create(gPath + sFormConfig);
  nList := TStringList.Create;
  try
    nStr := nIni.ReadString(sSetupSec, nID + '_Column', '');
    if not SplitStr(nStr, nList, nTree.ColumnCount, ';') then Exit;

    nCount := nList.Count - 1;
    for i:=0 to nCount do
     if IsNumber(nList[i], False) then
      nTree.Columns[i].Width := StrToInt(nList[i]);
  finally
    nList.Free;
    nIni.Free;
  end;
end;

//Desc: 锁定界面
procedure TfFormMain.LockMainForm(const nLock: Boolean);
var i,nCount: integer;
begin
  nCount := ToolBar1.ButtonCount - 1;
  for i:=0 to nCount do
   if ToolBar1.Buttons[i] <> Btn_Exit then
    ToolBar1.Buttons[i].Enabled := not nLock;

  LTv1.Enabled := not nLock;
  PopedomTree.Enabled := not nLock;
end;

//------------------------------------------------------------------------------
//Desc: 当前选中的组节点所对应的ID
function TfFormMain.SelectGroupID: string;
var nIdx: integer;
begin
  Result := '';
  with LTv1,gPopedomManager do
  begin
    if not Assigned(Selected) then Exit;

    if Selected.ImageIndex = cImgGroup then
      nIdx := Selected.StateIndex else
    if (Selected.ImageIndex = cImgUser) and (Assigned(Selected.Parent)) then
      nIdx := Selected.Parent.StateIndex
    else Exit;

    if (nIdx > -1) and (nIdx < Groups.Count) then
      Result := PGroupItemData(Groups[nIdx]).FID;
    //xxxxx
  end;
end;

//Desc: 载入程序列表
procedure TfFormMain.LoadProgList;
var nStr: string;
    nList: TList;
    i,nCount: integer;
begin
  ProgList.Clear;
  nList := gMenuManager.GetProgList;

  nCount := nList.Count - 1;
  for i:=0 to nCount do
  with PMenuItemData(nList[i])^ do
  begin
    nStr := '%-10s|%s';
    nStr := Format(nStr, [FProgID, FTitle]);
    ProgList.Items.Add(nStr);
  end;

  if ProgList.Items.Count = 1 then
    ProgList.ItemIndex := 0;
  ProgListChange(nil);
end;

//Desc: 载入组列表
procedure TfFormMain.LoadGroupList;
var i,nCount: integer;
    nIdx,nNum: integer;
    nGroup: PGroupItemData;
    nRoot,nNode: TTreeNode;
begin
  nRoot := nil;
  FUserNum := 0;
  FGroupNum := 0;

  LTv1.Items.BeginUpdate;
  try
    LTv1.Items.Clear;
    nRoot := LTv1.Items.AddChild(nil, sRootGroup);
    nRoot.ImageIndex := 7;
    nRoot.SelectedIndex := nRoot.ImageIndex;

    FGroupNum := gPopedomManager.Groups.Count;
    nCount := gPopedomManager.Groups.Count - 1;

    for i:=0 to nCount do
    begin
      nGroup := gPopedomManager.Groups[i];
      nNode := LTv1.Items.AddChild(nRoot, nGroup.FName);

      nNode.StateIndex := i;
      nNode.ImageIndex := cImgGroup;
      nNode.SelectedIndex := nNode.ImageIndex;

      if not Assigned(nGroup.FUser) then Continue;
      nNum := nGroup.FUser.Count - 1;

      for nIdx:=0 to nNum do
       if Trim(nGroup.FUser[nIdx]) <> '' then
        with LTv1.Items.AddChild(nNode, nGroup.FUser[nIdx]) do
        begin
          Inc(FUserNum);
          ImageIndex := cImgUser;
          SelectedIndex := ImageIndex;
        end;

      if FExpandGroup.IndexOf(nGroup.FID) > -1 then
        nNode.Expanded := True;
      //需要展开的节点

      if nGroup.FID = FNowID then
      begin
        nNode.Selected := True;
        nNode.MakeVisible;
      end;
    end;
    
    LoadUnGroupUser(nRoot);
    //未分组用户
  finally
    if not Assigned(nRoot) then
      nRoot := LTv1.Items.AddChild(nil, sNullGroup);
    if LTv1.Items.Count = 1 then nRoot.Text := sNullGroup;

    nRoot.Expand(False);
    LTv1.Items.EndUpdate;                  
    HintPanel.Caption := Format(sHintText1, [FGroupNum, FUserNum]);
  end; 
end;

//Desc: 在nRoot下添加未分组的用户
procedure TfFormMain.LoadUnGroupUser(const nRoot: TTreeNode);
var nStr: string;
    nParent,nNode: TTreeNode;
begin
  ShowMsgOnLastPanelOfStatusBar('正在载入未分组用户,请稍后...');
  try
    nStr := 'Select U_NAME From $User u Where Not Exists ' +
            '(Select 1 From $Group Where u.U_GROUP=G_ID)';
    nStr := MacroValue(nStr, [MI('$User', gSysParam.FTableUser),
                              MI('$Group', gSysParam.FTableGroup)]);

    FDM.SQLQuery.Close;
    FDM.SQLQuery.SQL.Text := nStr;
    FDM.SQLQuery.Open;  

    if FDM.SQLQuery.RecordCount < 1 then Exit;
    nParent := LTv1.Items.AddChild(nRoot, '未分组用户');
    nParent.ImageIndex := 9;
    nParent.SelectedIndex := nParent.ImageIndex;

    FDM.SQLQuery.First;
    while not FDM.SQLQuery.Eof do
    begin
      nStr := Trim(FDM.SQLQuery.Fields[0].AsString);
      if nStr <> '' then
      begin
        nNode := LTv1.Items.AddChild(nParent, nStr);
        nNode.ImageIndex := cImgUser;
        nNode.SelectedIndex := nNode.ImageIndex;
      end;
      FDM.SQLQuery.Next;
    end;
  finally
    ShowMsgOnLastPanelOfStatusBar('');
  end;
end;

//Desc: 刷新组列表
procedure TfFormMain.RefreshGroupList;
var i,nCount: integer;
begin
  FExpandGroup.Clear;
  nCount := LTv1.Items.Count - 1;

  for i:=0 to nCount do
   with LTv1.Items[i],gPopedomManager do
   if Expanded and (StateIndex > -1) and (StateIndex < Groups.Count) then
     FExpandGroup.Add(PGroupItemData(Groups[StateIndex]).FID);
  //保存所有展开的组节点标识

  ShowMsgOnLastPanelOfStatusBar('正在刷新数据,请稍后...');
  try
    gPopedomManager.LoadGroupFromDB(gSysParam.FProgID);
    LoadGroupList;
  finally
    ShowMsgOnLastPanelOfStatusBar('');
  end;
end;

//------------------------------------------------------------------------------
//Date: 2008-01-04
//Parm: 列索引;选中类型
//Desc: 设置nColumn列的权限状态(10,全选 20,取消 30,反选)
procedure TfFormMain.SetColumnPopedom(const nColumn,nType: integer);
var i,nCount: integer;
    nNode: TcxTreeListNode;
begin
  nCount := PopedomTree.Nodes.Count - 1;
  for i:=0 to nCount do
  begin
    nNode := PopedomTree.Nodes[i];
    if nNode.Texts[0] = '' then Continue;

    case nType of
     10: nNode.Values[nColumn] := True;
     20: nNode.Values[nColumn] := False;
     30: nNode.Values[nColumn] := nNode.Values[nColumn] <> True;
    end;
  end;

  PopedomTree.FullRefresh;
  Application.ProcessMessages;
end;

//Desc: 设置所有节点的权限状态(10,全选 20,取消 30,反选)
procedure TfFormMain.SetAllNodePopedom(const nType: integer);
var i,nCount: integer;
    nIdx,nNum: integer;
    nNode: TcxTreeListNode;
begin
  nNum := PopedomTree.ColumnCount - 1;
  nCount := PopedomTree.Nodes.Count - 1;

  for i:=0 to nCount do
  begin
    nNode := PopedomTree.Nodes[i];
    if nNode.Texts[0] = '' then Continue;

    for nIdx:=0 to nNum do
     if PopedomTree.Columns[nIdx].PropertiesClass = TcxCheckBoxProperties then
      case nType of
       10: nNode.Values[nIdx] := True;
       20: nNode.Values[nIdx] := False;
       30: nNode.Values[nIdx] := nNode.Values[nIdx] <> True;
      end;
  end;

  PopedomTree.FullRefresh;
  Application.ProcessMessages;
end;

//Desc: 将nPopedom权限应用到nNode节点上
procedure TfFormMain.LodNodePopedom(const nNode: TcxTreeListNode;
  const nPopedom: string);
var i,nCount: integer;
    nCheckBox: TcxCheckBoxProperties;
begin
  nCount := PopedomTree.ColumnCount - 1;
  for i:=0 to nCount do
   if PopedomTree.Columns[i].PropertiesClass = TcxCheckBoxProperties then
   begin
     nCheckBox := TcxCheckBoxProperties(PopedomTree.Columns[i].PropertiesValue);
     nNode.Values[i] := Pos(nCheckBox.DisplayChecked, nPopedom) > 0;
   end;
end;

//Desc: 将nGroup载入到权限树中
procedure TfFormMain.LoadPopedom(const nGroup: string);
var i,nCount: integer;
    nIdx,nNum: integer;
    nNode: TcxTreeListNode;
    nData: PGroupItemData;
    nPopedom: PPopedomItemData;
begin
  SetAllNodePopedom(20);
  nData := gPopedomManager.FindGroupByID(nGroup);
  if not (Assigned(nData) and Assigned(nData.FPopedom)) then Exit;

  nNum := nData.FPopedom.Count - 1;
  nCount := PopedomTree.Nodes.Count - 1;

  for i:=0 to nCount do
  begin
    nNode := PopedomTree.Nodes[i];
    if nNode.Texts[0] = '' then Continue;

    for nIdx:=0 to nNum do
    begin
      nPopedom := nData.FPopedom[nIdx];
      if nPopedom.FItem = nNode.Texts[0] then
        LodNodePopedom(nNode, nPopedom.FPopedom);
      //xxxxx
    end;
  end;
end;

//Desc: 载入权限树表头
procedure TfFormMain.LoadPopedomTreeColumn;
var nStr: string;
    nList: TStrings;
    i,nCount,nPos: integer;
    nCheckBox: TcxCheckBoxProperties;
begin
  PopedomTree.BeginUpdate;
  nList := TStringList.Create;
  try
    PopedomTree.Clear;
    PopedomTree.DeleteAllColumns;

    with PopedomTree.CreateColumn(nil) do
    begin
       Visible := False;
       Caption.Text := '模块标记';
    end;

    with PopedomTree.CreateColumn(nil) do
    begin
       Visible := True;
       Caption.Text := '模块名称';
       Caption.AlignHorz := taCenter;
    end;

    if not gPopedomManager.LoadPopItemList(nList, gSysParam.FProgID) then Exit;
    nCount := nList.Count - 1;

    for i:=0 to nCount do
    with PopedomTree.CreateColumn(nil) do
    begin
      Options.Moving := False;
      Options.Sorting := False;

      PropertiesClassName := 'TcxCheckBoxProperties';
      nCheckBox := TcxCheckBoxProperties(PropertiesValue);
      nCheckBox.NullStyle := nssUnchecked;

      nStr := nList[i];
      nPos := Pos(';', nStr);
      nCheckBox.DisplayChecked := Copy(nStr, 1, nPos - 1);

      Caption.AlignHorz := taCenter;
      System.Delete(nStr, 1, nPos);
      Caption.Text := nStr + '[' + nCheckBox.DisplayChecked + ']';
    end;
  finally
    nList.Free;
    PopedomTree.EndUpdate;
    LoadTreeListColumn(PopedomTree, gSysParam.FProgID);
  end;
end;

//Desc: 载入待设置权限的项
procedure TfFormMain.LoadPopedomItem;
var i,nCount: integer;
    nItem: PMenuItemData;
    nNode: TcxTreeListNode;
begin
  PopedomTree.BeginUpdate;
  try
    PopedomTree.Clear;
    gMenuManager.LoadMenuFromDB(gSysParam.FProgID);
    nCount := gMenuManager.TopMenus.Count - 1;

    for i:=0 to nCount do
    begin
      nItem := gMenuManager.TopMenus[i];
      if (nItem.FEntity = '') or (nItem.FMenuID <> '') then Continue;

      nNode := PopedomTree.AddChild(nil);
      nNode.Texts[0] := '';
      nNode.Texts[1] := nItem.FTitle;
      LoadEntityItems(nNode, nItem.FEntity);
    end; //载入所有实体

    LoadUserDefinePopedom;
    //载入自定义权限
  finally
    PopedomTree.FullExpand;
    PopedomTree.EndUpdate;
  end;
end;

//Desc: 载入自定义权限
procedure TfFormMain.LoadUserDefinePopedom;
begin

end;

//Date: 2008-08-20
//Parm: 父节点;实体标识
//Desc: 载入nEntity下所有菜单项,作为nNode的子节点
procedure TfFormMain.LoadEntityItems(const nNode: TcxTreeListNode;
  const nEntity: string);
var i,nCount: integer;
    nItem: PMenuItemData;
    nSNode: TcxTreeListNode;
begin
  nCount := gMenuManager.TopMenus.Count - 1;
  for i:=0 to nCount do
  begin
    nItem := gMenuManager.TopMenus[i];
    if (nItem.FEntity <> nEntity) or
       (nItem.FMenuID = '') or (nItem.FTitle = '-') then Continue;

    nSNode := PopedomTree.AddChild(nNode);
    nSNode.Texts[0] := gMenuManager.MenuName(nItem.FEntity, nItem.FMenuID);
    nSNode.Texts[1] := nItem.FTitle;

    if Assigned(nItem.FSubMenu) then
      LoadEntitySubItems(nSNode, nItem.FSubMenu);
    //load subitems
  end;
end;

//Date: 2008-08-20
//Parm: 父节点;子节点列表
//Desc: 载入nSub数据,作为nNode的子节点
procedure TfFormMain.LoadEntitySubItems(const nNode: TcxTreeListNode;
  const nSub: TList);
var i,nCount: integer;
    nItem: PMenuItemData;
    nSNode: TcxTreeListNode;
begin
  nCount := nSub.Count - 1;
  for i:=0 to nCount do
  begin
    nItem := nSub[i];
    if (nItem.FMenuID = '') or (nItem.FTitle = '-') then Continue;

    nSNode := PopedomTree.AddChild(nNode);
    nSNode.Texts[0] := gMenuManager.MenuName(nItem.FEntity, nItem.FMenuID);
    nSNode.Texts[1] := nItem.FTitle;

    if Assigned(nItem.FSubMenu) then
      LoadEntitySubItems(nSNode, nItem.FSubMenu);
    //load subitems
  end;
end;

//------------------------------------------------------------------------------
//Desc: 控制列不可编辑
procedure TfFormMain.PopedomTreeEditing(Sender: TObject;
  AColumn: TcxTreeListColumn; var Allow: Boolean);
begin
  Allow := Assigned(AColumn.Properties);
end;

//Desc: 有下级节点,则视为组节点
procedure TfFormMain.PopedomTreeIsGroupNode(Sender: TObject;
  ANode: TcxTreeListNode; var IsGroup: Boolean);
begin
  IsGroup := ANode.Texts[0] = '';
end;

//Desc: 提交复选框数据
procedure TfFormMain.PopedomTreeEditValueChanged(Sender: TObject;
  AColumn: TcxTreeListColumn);
var nIdx: integer;
    nCheck: Boolean;
begin           
  if AColumn.PropertiesClass = TcxCheckBoxProperties then
  begin
    nIdx := TcxTreeList(Sender).FocusedNode.RecordIndex;
    nCheck := AColumn.Values[nIdx] <> True;
    AColumn.Values[nIdx] := nCheck;
  end;
end;

//Desc: 控制菜单状态
procedure TfFormMain.PMenu2Popup(Sender: TObject);
var nEnable: Boolean;
    i,nCount,nTag: integer;
begin
  nEnable := Assigned(PopedomTree.FocusedColumn) and
             (PopedomTree.FocusedColumn.PropertiesClass = TcxCheckBoxProperties);
  nCount := PMenu2.Items.Count - 1;

  for i:=0 to nCount do
  begin
    nTag := PMenu2.Items[i].Tag;
    case nTag of
     30,31,32: PMenu2.Items[i].Enabled := nEnable;
    end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 退出
procedure TfFormMain.Btn_ExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 权限项
procedure TfFormMain.Btn_PopItemClick(Sender: TObject);
begin
  ShowPopItemSetupForm;
end;

//Decc: 添加组
procedure TfFormMain.Btn_AddGroupClick(Sender: TObject);
begin
  if ShowAddGroupForm then RefreshGroupList;
end;

//Desc: 删除组
procedure TfFormMain.Btn_DelGroupClick(Sender: TObject);
begin
  if SelectGroupID <> '' then
   if DeleteGroup(SelectGroupID, LTv1.Selected.Text) then
   begin
     RefreshGroupList; FNowID := '';
   end;
end;

//Desc: 添加用户
procedure TfFormMain.Btn_AddUserClick(Sender: TObject);
begin
  if ShowAddUserForm then RefreshGroupList;
end;

procedure TfFormMain.Btn_DelUserClick(Sender: TObject);
begin
  if Assigned(LTv1.Selected) and (LTv1.Selected.ImageIndex = cImgUser) then
  begin
    if DeleteUser(LTv1.Selected.Text) then RefreshGroupList;
  end else ShowDlg('请选择要删除的用户', sHint);
end;

//Desc: 切换程序
procedure TfFormMain.ProgListChange(Sender: TObject);
var nStr: string;
    nPos: integer;
begin
  StatusPanel.Caption := '';
  LockMainForm(ProgList.ItemIndex < 0);
  if ProgList.ItemIndex < 0 then Exit;

  if gSysParam.FProgID <> '' then
    SaveTreeListColumn(PopedomTree, gSysParam.FProgID);
  //save column width

  nStr := ProgList.Text;
  nPos := Pos('|', nStr);

  System.Delete(nStr, nPos, MaxInt);
  gSysParam.FProgID := Trim(nStr);

  RefreshGroupList;
  LoadPopedomTreeColumn;
  LoadPopedomItem;

  nStr := Copy(ProgList.Text, nPos + 1, MaxInt);
  StatusPanel.Caption := Format(sHintProg, [nStr]);
end;

//Desc: 刷新组
procedure TfFormMain.mRefreshClick(Sender: TObject);
begin
  RefreshGroupList;
end;
                                               
//Desc: 编辑组,用户信息
procedure TfFormMain.mEditClick(Sender: TObject);
var nStr: string;
begin
  if not Assigned(LTv1.Selected) then Exit;

  if LTv1.Selected.ImageIndex = cImgUser then
  begin
    if not ShowEditUserForm(LTv1.Selected.Text) then Exit;
    nStr := LTv1.Selected.Text;
    RefreshGroupList;
  end else

  if LTv1.Selected.ImageIndex = cImgGroup then
  begin
    if (SelectGroupID <> '') and ShowEditGroupForm(SelectGroupID) then
      RefreshGroupList;
  end;
end;

//Desc: 快捷菜单
procedure TfFormMain.N10Click(Sender: TObject);
var nTag: integer;
begin
  nTag := (Sender as TComponent).Tag;
  case nTag of
   10: PopedomTree.FullExpand;
   11: PopedomTree.FullCollapse;
   20: SetAllNodePopedom(10);
   21: SetAllNodePopedom(20);
   22: SetAllNodePopedom(30);
   30: SetColumnPopedom(PopedomTree.FocusedColumn.ItemIndex, 10);
   31: SetColumnPopedom(PopedomTree.FocusedColumn.ItemIndex, 20);
   32: SetColumnPopedom(PopedomTree.FocusedColumn.ItemIndex, 30);
  end;
end;

//Desc: 刷新权限树
procedure TfFormMain.mRefreshTreeClick(Sender: TObject);
begin
  LoadPopedomTreeColumn;
  LoadPopedomItem;
end;

//Desc: 载入组权限
procedure TfFormMain.LTv1Change(Sender: TObject; Node: TTreeNode);
var nStr: string;
begin
  nStr := SelectGroupID;
  if nStr = '' then
  begin
    FNowID := '';
    FNowGroup := '';
    SetAllNodePopedom(20);
    HintPanel.Caption := Format(sHintText1, [FGroupNum, FUserNum]);
  end else

  if nStr <> FNowID then
  begin
    FNowID := nStr;

    if Node.ImageIndex = cImgGroup then
      nStr := Node.Text else
    if (Node.ImageIndex = cImgUser) and Assigned(Node.Parent) then
      nStr := Node.Parent.Text
    else Exit;

    FNowGroup := nStr;
    if FNowID <> '' then LoadPopedom(FNowID);
    HintPanel.Caption := Format(sHintText2, [FNowGroup, Node.Count]);
  end;
end;

//Desc: 构建nNode节点的权限值
function TfFormMain.BuildNodePopedom(const nNode: TcxTreeListNode): string;
var i,nCount: integer;
    nCheckBox: TcxCheckBoxProperties;
begin
  Result := '';
  nCount := PopedomTree.ColumnCount - 1;

  for i:=0 to nCount do
   if PopedomTree.Columns[i].PropertiesClass = TcxCheckBoxProperties then
   begin
     nCheckBox := TcxCheckBoxProperties(PopedomTree.Columns[i].PropertiesValue);
     if nNode.Values[i] = True then Result := Result + nCheckBox.DisplayChecked;
   end;
end;

//Desc: 授权
procedure TfFormMain.BtnApplyClick(Sender: TObject);
var nStr,nSQL: string;
    i,nCount: integer;
begin
  if FNowID = '' then
  begin
    ShowMsg('请先选择组并设置该组权限', sHint); Exit;
  end;

  nStr := '正在为组[ %s ]授权,请稍候...';
  nStr := Format(nStr, [FNowGroup]);
  ShowMsgOnLastPanelOfStatusBar(nStr);

  ShowWaitForm(Self, '正在授权');
  try
    FDM.ADOConn.BeginTrans;
    nSQL := 'Delete From %s Where P_GROUP=%s';
    nSQL := Format(nSQL, [gSysParam.FTablePopedom, FNowID]);

    FDM.Command.Close;
    FDM.Command.SQL.Text := nSQL;
    FDM.Command.ExecSQL;

    nSQL := 'Insert Into $Table(P_GROUP, P_ITEM, P_POPEDOM) ' +
            'Values(%s, ''%s'', ''%s'')';
    nSQL := MacroValue(nSQL, [MI('$Table', gSysParam.FTablePopedom)]);

    nCount := PopedomTree.Nodes.Count - 1;
    for i:=0 to nCount do
    begin
      if PopedomTree.Nodes[i].Texts[0] = '' then Continue;
      //非模块名称

      nStr := BuildNodePopedom(PopedomTree.Nodes[i]);
      if nStr <> '' then
      begin
        nStr := Format(nSQL, [FNowID, PopedomTree.Nodes[i].Texts[0], nStr]);

        FDM.Command.Close;
        FDM.Command.SQL.Text := nStr;
        FDM.Command.ExecSQL;
      end;
    end;

    FDM.ADOConn.CommitTrans;
    gPopedomManager.LoadGroupFromDB(gSysParam.FProgID);
    ShowMsg('权限设置保存成功', sHint);
  finally
    ShowMsgOnLastPanelOfStatusBar('');
    CloseWaitForm;
    if FDM.ADOConn.InTransaction then FDM.ADOConn.RollbackTrans;
  end;
end;

end.
