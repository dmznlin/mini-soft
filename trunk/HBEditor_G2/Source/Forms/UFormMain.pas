{*******************************************************************************
  作者: dmzn 2009-2-8
  描述: 编辑器主单元
*******************************************************************************}
unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UBoderControl, ImgList, Menus, ComCtrls, ToolWin, ExtCtrls,
  UTitleBar, ActnList;

type
  TfFormMain = class(TForm)
    MainMenu1: TMainMenu;
    ImageList1: TImageList;
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
    N12: TMenuItem;
    N13: TMenuItem;
    ToolBar1: TToolBar;
    BtnNew: TToolButton;
    BtnOpen: TToolButton;
    BtnSave: TToolButton;
    ToolButton4: TToolButton;
    BtnMovie: TToolButton;
    BtnText: TToolButton;
    BtnPic: TToolButton;
    BtnAnimate: TToolButton;
    BtnClock: TToolButton;
    BtnTime: TToolButton;
    BtnTimer: TToolButton;
    SBar: TStatusBar;
    StdPanel: TPanel;
    BtmPanel: TPanel;
    ZnTitleBar2: TZnTitleBar;
    Splitter1: TSplitter;
    ClientPanel: TPanel;
    Splitter2: TSplitter;
    LeftPanel: TPanel;
    ZnTitleBar1: TZnTitleBar;
    ScreenList: TTreeView;
    ActionList1: TActionList;
    acNew: TAction;
    acOpen: TAction;
    acSave: TAction;
    acExit: TAction;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    BtnDe: TToolButton;
    N14: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N22: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N23: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N15: TMenuItem;
    N24: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    acScreen: TAction;
    acConnTest: TAction;
    acResetCtrl: TAction;
    acAdjustTime: TAction;
    acSetWH: TAction;
    acBright: TAction;
    acBrightTime: TAction;
    acOC: TAction;
    acOCTime: TAction;
    acPlayDays: TAction;
    acSendAll: TAction;
    acSendSelected: TAction;
    acPreview: TAction;
    BtnSend: TToolButton;
    acStatus: TAction;
    N29: TMenuItem;
    WorkPanel: TScrollBox;
    ToolButton3: TToolButton;
    BtnTest: TToolButton;
    BtnRetset: TToolButton;
    BtnBorder: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure WorkPanelResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acNewExecute(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
    procedure BtnMovieClick(Sender: TObject);
    procedure BtnTextClick(Sender: TObject);
    procedure ScreenListChange(Sender: TObject; Node: TTreeNode);
    procedure BtnPicClick(Sender: TObject);
    procedure Splitter2CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure BtnTimeClick(Sender: TObject);
    procedure BtmPanelEnter(Sender: TObject);
    procedure BtmPanelExit(Sender: TObject);
    procedure BtnDeClick(Sender: TObject);
    procedure acScreenExecute(Sender: TObject);
    procedure acConnTestExecute(Sender: TObject);
    procedure acResetCtrlExecute(Sender: TObject);
    procedure acAdjustTimeExecute(Sender: TObject);
    procedure acSetWHExecute(Sender: TObject);
    procedure acBrightExecute(Sender: TObject);
    procedure acBrightTimeExecute(Sender: TObject);
    procedure acOCExecute(Sender: TObject);
    procedure acOCTimeExecute(Sender: TObject);
    procedure acPlayDaysExecute(Sender: TObject);
    procedure acSendSelectedExecute(Sender: TObject);
    procedure acSendAllExecute(Sender: TObject);
    procedure BtnSendClick(Sender: TObject);
    procedure BtnAnimateClick(Sender: TObject);
    procedure BtnClockClick(Sender: TObject);
    procedure acStatusExecute(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acOpenExecute(Sender: TObject);
    procedure BtnBorderClick(Sender: TObject);
  private
    { Private declarations }
    FMovieList: TList;
    {*节目列表*}
    FActiveMovie: TZnBorderControl;
    {*活动节目*}
    FLastFile: string;
    {*上次保存*}
    procedure FormLoadConfig;
    procedure FormSaveConfig;
    {*配置信息*}
    procedure HidenMovieList;
    {*隐藏列表*}
    procedure ClearMovieList(const nFree: Boolean; const nList: TList = nil);
    {*清空列表*}
    procedure LoadMovedItemToTreeView(const nPNode: TTreeNode);
    procedure LoadScreenListToTreeview;
    procedure LoadScreenListInFileToTreeView;
    {*载入屏幕*}
    procedure SetToolbarStatus;
    {*工具栏*}
    procedure GetItemSended(const nList: TList; const nSelected: Boolean);
    {*获取组件*}
    procedure OnBgImageClick(Sender: TObject);
    procedure OnMovieControlClick(Sender: TObject);
    procedure OnMovedItemSelected(Sender: TObject);
    {*对象选中*}
  public
    { Public declarations }
    procedure RefreshScreeListView;
    {*刷新列表*}
    function GetMovedItemNode(const nItem: TObject): TTreeNode;
    {*检索节点*}
    procedure UnSelecteAllMovedItem(const nCtrl: TWinControl);
    {*取消所有节点*}
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  IniFiles, ShellAPI, USysConst, ULibFun, UImgControl, UMovedControl, UMovedItems,
  UFrameBase, UFrameText, UFramePicture, UFrameTime, UFrameSummary, UFormScreen,
  UFormConnTest, UFormResetCtrl, UFormSetBright, UFormAdjustTime,
  UFormOpenOrClose, UFormPlayDays, UFormSetWH, UFormOCTime, UFormSetBrightTime,
  UFormSendData, UFormWait, UFrameAnimate, UFrameClock, UFormStatus, UMgrLang,
  UDataSaved, UFormBorder;

//------------------------------------------------------------------------------
//Desc: 载入配置
procedure TfFormMain.FormLoadConfig;
var nInt: integer;
    nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath  + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    FLastFile := nIni.ReadString(Name, 'LastSave', '');

    nInt := nIni.ReadInteger(Name, 'BtmPanel', 0);
    if nInt > 20 then BtmPanel.Height := nInt;

    nInt := nIni.ReadInteger(Name, 'LeftPanel', 0);
    if nInt > 20 then LeftPanel.Width := nInt;

    FreeAndNil(nIni);
    nIni := TIniFile.Create(gPath + sConfigFile);

    gSysParam.FAppTitle := nIni.ReadString(sProgID, 'AppTitle', sAppTitle);
    gSysParam.FMainTitle := nIni.ReadString(sProgID, 'MainTitle', sMainTitle);
    gSysParam.FCopyLeft := nIni.ReadString(sProgID, 'CopyLeft', sCopyRight);
    gSysParam.FCopyRight := nIni.ReadString(sProgID, 'CopyRight', sCopyRight);

    with gSysParam do
    begin
      FAppTitle := ML(FAppTitle);
      FMainTitle := ML(FMainTitle);
      FCopyLeft := ML(FCopyLeft);
      FCopyRight := ML(FCopyRight);
    end;

    Caption := gSysParam.FMainTitle;
    Application.Title := gSysParam.FAppTitle;
    StatusBarMsg(gSysParam.FCopyLeft, 0);
  finally
    nIni.Free;
  end;
end;

//Desc: 保存配置
procedure TfFormMain.FormSaveConfig;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath  + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    nIni.WriteInteger(Name, 'BtmPanel', BtmPanel.Height);
    nIni.WriteInteger(Name, 'LeftPanel', LeftPanel.Width);
  finally
    nIni.Free;
  end;
end;

procedure TfFormMain.FormCreate(Sender: TObject);
begin
  Randomize;
  gPath := ExtractFilePath(Application.ExeName);
  InitGlobalVariant(gPath, gPath + sConfigFile, gPath + sFormConfig);

  if not IsValidConfigFile(gPath + sConfigFile, sProgID) then
  begin
    ShowDlg(sInvalidConfig, sHint, GetDesktopWindow);
    Application.Terminate;
  end;
  //配置文件被改动

  with gMultiLangManager do
  if FileExists(gPath + 'Lang.xml') then
  begin
    LoadLangFile(gPath + 'Lang.xml');
    AutoNewNode := False;
    HasItemID := False;

    NowLang := 'cn';
    SectionID := Name;
    TranslateAllCtrl(Self);
  end;

  SetRStringMultiLang;
  //多语言翻译

  Caption := ML(sMainTitle);
  Application.Title := ML(sAppTitle);

  gStatusBar := SBar;
  SBar.Panels[0].Text := ML(sCopyRight);
  ShowMsgOnLastPanelOfStatusBar(ML(sCorConcept));

  if not DirectoryExists(gPath + sDocument) then
    ForceDirectories(gPath + sDocument);
  //xxxxx

  WorkPanel.DoubleBuffered := True;
  with TZnImageControl.Create(WorkPanel) do
  begin
    Parent := WorkPanel;
    Align := alClient;
    OnClick := OnBgImageClick;

    if FileExists(gPath + sBackImage) then
      Image.LoadFromFile(gPath + sBackImage);
  end;
  //生成背景图片

  FActiveMovie := nil;
  FMovieList := TList.Create;

  FormLoadConfig;
  //载入配置
  gScreenList := TList.Create;

  if FileExists(FLastFile) then
  begin
    gDataManager.MovieParent := WorkPanel;
    if gDataManager.LoadFromFile(FLastFile) then
    begin
      LoadScreenList(gScreenList);
      LoadScreenListInFileToTreeView;
      gDataManager.ResetBlank(False); Exit;
    end;
  end;

  LoadScreenList(gScreenList);
  LoadScreenListToTreeview;
  //载入屏幕列表
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if gIsSending then
  begin
    Action := caNone; Exit;
  end;

  if not QueryDlg(ML('确定要关闭程序吗?', Name), sAsk) then
  begin
    Action := caNone; Exit;
  end;

  FormSaveConfig;
  //保存配置
  ClearMovieList(True);
  //释放节目列表
  ClearScreenList(gScreenList, True);
  //清理屏幕列表
end;

//------------------------------------------------------------------------------
//Desc: 统计nNode一级子节点的个数
function ChildNodeCount(const nNode: TTreeNode): integer;
var nTmp: TTreeNode;
begin
  Result := 0;
  nTmp := nNode.getFirstChild;

  while Assigned(nTmp) do
  begin
    Inc(Result);
    nTmp := nTmp.getNextSibling;
  end;
end;

//Desc: 获取nTv选中节点所在的屏幕节点
function GetSelectedScreenNode(const nTv: TTreeView): TTreeNode;
begin
  Result := nTv.Selected;
  while Assigned(Result) and (Result.ImageIndex <> cImgScreen) do
    Result := Result.Parent;
  //xxxxx
end;

//Desc: 统计nCtrl中nClass类对象的个数
function MovedItemCount(nCtrl: TWinControl; nClass: TMovedItemClass): integer;
var nIdx: integer;
begin
  Result := 0;
  for nIdx:=nCtrl.ControlCount - 1 downto 0 do
  begin
    if nCtrl.Controls[nIdx] is nClass then Inc(Result);
  end;
end;

//Desc: 调整位置
procedure TfFormMain.WorkPanelResize(Sender: TObject);
begin
  if Assigned(FActiveMovie) then
  begin
    FActiveMovie.Left := Round((WorkPanel.Width - FActiveMovie.Width) / 2);
    if FActiveMovie.Left < 0 then FActiveMovie.Left := 0;
    FActiveMovie.Top := Round((WorkPanel.Height - FActiveMovie.Height) / 2);
    if FActiveMovie.Top < 0 then FActiveMovie.Top := 0;
  end;
end;

//Desc: 控制面板大小
procedure TfFormMain.Splitter2CanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
  Accept := NewSize > 152;
end;

procedure TfFormMain.BtmPanelEnter(Sender: TObject);
begin
  SetTitleBarStatus(TWinControl(Sender), True);
end;

procedure TfFormMain.BtmPanelExit(Sender: TObject);
begin
  SetTitleBarStatus(TWinControl(Sender), False);
end;

//Desc: 清空节目列表
procedure TfFormMain.ClearMovieList(const nFree: Boolean; const nList: TList);
var nTmp: TList;
    nIdx: integer;
begin
  if Assigned(nList) then
  begin
    nTmp := nList;
  end else
  begin
    nTmp := FMovieList;
    FActiveMovie := nil;
  end;

  for nIdx:=nTmp.Count - 1 downto 0 do
  begin
    TObject(nTmp[nIdx]).Free;
    nTmp.Delete(nIdx);
  end;
  
  if nFree then
   if Assigned(nList) then
        nList.Free
   else FreeAndNil(FMovieList);
end;

//Desc: 隐藏节目列表中所有节目面板
procedure TfFormMain.HidenMovieList;
var nIdx: integer;
begin
  for nIdx:= FMovieList.Count - 1 downto 0 do
  begin
    TWinControl(FMovieList[nIdx]).Hide;
  end;
end;

//Desc: 背景选中抢焦点
procedure TfFormMain.OnBgImageClick(Sender: TObject);
begin
  ActiveControl := nil;
end;

//Desc: 检索nItem对象对应的显示屏列表节点
function TfFormMain.GetMovedItemNode(const nItem: TObject): TTreeNode;
var nIdx: integer;
begin
  Result := nil;
  for nIdx:=ScreenList.Items.Count - 1 downto 0 do
   if ScreenList.Items[nIdx].Data = nItem then
   begin
     Result := ScreenList.Items[nIdx]; Break;
   end;
end;

//Desc: 取消选中所有组件
procedure TfFormMain.UnSelecteAllMovedItem(const nCtrl: TWinControl);
var nIdx: integer;
    nNode: TTreeNode;
begin
  if Assigned(nCtrl) then
   for nIdx:=nCtrl.ControlCount - 1 downto 0 do
    if nCtrl.Controls[nIdx] is TZnMovedControl then
    begin
      TZnMovedControl(nCtrl.Controls[nIdx]).Selected := False;
      nNode := GetMovedItemNode(nCtrl.Controls[nIdx]);
      if Assigned(nNode) then nNode.Selected := False;
    end;
end;

//Desc: 面板单机,取消选中
procedure TfFormMain.OnMovieControlClick(Sender: TObject);
var nCtrl: TWinControl;
begin
  nCtrl := TWinControl(Sender);
  ActiveControl := nil;
  UnSelecteAllMovedItem(nCtrl);
end;

//Desc: 对象被选中
procedure TfFormMain.OnMovedItemSelected(Sender: TObject);
var nIdx: integer;
    nNode: TTreeNode;
begin
  if (GetKeyState(VK_CONTROL) and $8000) <> 0 then Exit;
  //控制键多选

  if Assigned(FActiveMovie) and (Sender is TZnMovedControl) and
     (TZnMovedControl(Sender).Selected) then
  begin
    for nIdx:= FActiveMovie.ControlCount - 1 downto 0 do
     if (FActiveMovie.Controls[nIdx] is TZnMovedControl) and
        (FActiveMovie.Controls[nIdx] <> Sender) then
       TZnMovedControl(FActiveMovie.Controls[nIdx]).Selected := False;

    FActiveMovie.SetFocus;
    nNode := GetMovedItemNode(Sender);

    if Assigned(nNode) then
    begin
     nNode.Selected := True;
     nNode.MakeVisible;
    end;

    gIsFullColor := PScreenItem(GetMovedItemNode(FActiveMovie).Parent.Data).FType = stFull;
    //全彩会影响编辑器的某些特性,如颜色等

    if Sender is TTextMovedItem then
      SetItemEditor(TZnMovedControl(Sender), TfFrameText, BtmPanel) else
    if Sender is TPictureMovedItem then
      SetItemEditor(TZnMovedControl(Sender), TfFramePicture, BtmPanel) else
    if Sender is TAnimateMovedItem then
      SetItemEditor(TZnMovedControl(Sender), TfFrameAnimate, BtmPanel) else
    if Sender is TClockMovedItem then
      SetItemEditor(TZnMovedControl(Sender), TfFrameClock, BtmPanel) else
    if Sender is TTimeMovedItem then
      SetItemEditor(TZnMovedControl(Sender), TfFrameTime, BtmPanel);
  end;
end;

//------------------------------------------------------------------------------
//Desc: 载入nPNode对应的节目的内容节点
procedure TfFormMain.LoadMovedItemToTreeView(const nPNode: TTreeNode);
var nNode: TTreeNode;
    i,nCount: Integer;
    nCtrl: TWinControl;
    nZnCtrl: TZnMovedControl;
begin
  nCtrl := TWinControl(nPNode.Data);
  nCount := nCtrl.ControlCount - 1;

  for i:=0 to nCount do
  if nCtrl.Controls[i] is TZnMovedControl then
  begin
    nZnCtrl := TZnMovedControl(nCtrl.Controls[i]);
    nZnCtrl.OnSelected := OnMovedItemSelected;

    nNode := ScreenList.Items.AddChild(nPNode, nZnCtrl.ShortName);
    nNode.Data := nZnCtrl;

    if nZnCtrl is TTextMovedItem then
      nNode.ImageIndex := cImgText else
    if nZnCtrl is TPictureMovedItem then
      nNode.ImageIndex := cImgPicture else
    if nZnCtrl is TAnimateMovedItem then
      nNode.ImageIndex := cImgPicture else
    if nZnCtrl is TClockMovedItem then
      nNode.ImageIndex := cImgClock else
    if nZnCtrl is TTimeMovedItem then
      nNode.ImageIndex := cImgTime;
    nNode.SelectedIndex := nNode.ImageIndex;
  end;
end;

//Date: 2009-12-08
//Parm: 有效区域;控件;默认宽高
//Desc: 当默认宽高不在有效区域时自动调整
procedure AutoAdjustWH(nRect: TRect; nCtrl: TControl; nDefW,nDefH: Integer);
var nInt: Integer;
begin
  nInt := nRect.Right - nRect.Left;
  if nInt > nDefW then nCtrl.Width := nDefW else nCtrl.Width := nInt;

  nInt := nRect.Bottom - nRect.Top;
  if nInt > nDefH then nCtrl.Height := nDefH else nCtrl.Height := nInt;

  if nCtrl.Left > nRect.Right then
    nCtrl.Left := nRect.Right - nCtrl.Width;
  if nCtrl.Left < nRect.Left then nCtrl.Left := nRect.Left;

  if nCtrl.Top > nRect.Bottom then
    nCtrl.Top := nRect.Bottom - nCtrl.Width;
  if nCtrl.Top < nRect.Top then nCtrl.Top := nRect.Top;
end;

//Desc: 自动校正nPCtrl中所有控件的宽高
procedure AdjustItemsWH(const nPCtrl: TZnBorderControl);
var nItem: TControl;
    i,nCount: Integer;
begin
  nCount := nPCtrl.ControlCount - 1;
  for i:=0 to nCount do
  begin
    nItem := nPCtrl.Controls[i];
    AutoAdjustWH(nPCtrl.ValidClientRect, nItem, nItem.Width, nItem.Height);
  end;
end;

//Desc: 载入屏幕列表到树
procedure TfFormMain.LoadScreenListToTreeview;
var nStr: string;
    nList: TList;
    nNode,nTmp: TTreeNode;
    nItem: PScreenItem;
    i,nCount,nIdx: integer;
begin
  ScreenList.Items.BeginUpdate;
  nList := TList.Create;
  try
    ScreenList.Selected := nil;
    ScreenList.Items.Clear;
    //ClearMovieList(False);

    nList.Assign(FMovieList);
    FMovieList.Clear;
    nCount := gScreenList.Count - 1;
    
    for i:=0 to nCount do
    begin
      nItem := gScreenList.Items[i];
      //nStr := Format(sCaptionScreen, [i]);
      nNode := ScreenList.Items.AddChild(nil, nItem.FName);

      nNode.Data := nItem;
      nNode.ImageIndex := cImgScreen;
      nNode.SelectedIndex := nNode.ImageIndex;

      FActiveMovie := nil;
      for nIdx:=0 to nList.Count-1 do
      if TComponent(nList[nIdx]).Tag = i then
      begin
        FActiveMovie := nList[nIdx];
        nList.Delete(nIdx); Break;
      end;

      if not Assigned(FActiveMovie) then
        FActiveMovie := TZnBorderControl.Create(WorkPanel);
      FMovieList.Add(FActiveMovie);

      with FActiveMovie do
      begin
        Parent := WorkPanel;
        Width := nItem.FLenX;
        Height := nItem.FLenY;

        with ValidClientRect do
        begin
          Width := Width + (Width - Right + Left);
          Height := Height + (Height - Bottom + Top);
        end;

        Hide;
        Tag := i;
        OnClick := OnMovieControlClick;
        AdjustItemsWH(FActiveMovie);
      end;

      nStr := Format(sCaptionMovie, [0]);
      nTmp := ScreenList.Items.AddChild(nNode, nStr);
      with nTmp do
      begin
        ImageIndex := cImgMovie;
        SelectedIndex := ImageIndex;
        Data := FActiveMovie;
      end;

      LoadMovedItemToTreeView(nTmp);
      nNode.Expanded := True;
    end;
  finally
    if ScreenList.Items.Count > 0 then
    begin
      ScreenList.FullExpand;
      nNode := ScreenList.Items[0].getFirstChild;
      
      nNode.Selected := True;
      ShowScreenSummary(nNode.Parent.Data, BtmPanel);
      
      FActiveMovie := TZnBorderControl(nNode.Data);
      FActiveMovie.Show;
      SetToolbarStatus;
    end;

    WorkPanelResize(nil);
    ScreenList.Items.EndUpdate;
    ClearMovieList(True, nList);
  end;
end;

procedure TfFormMain.RefreshScreeListView;
begin
  LoadScreenListToTreeview;
end;

//Desc: 切换节目面板,或选中节目面板上指定的对象
procedure TfFormMain.ScreenListChange(Sender: TObject; Node: TTreeNode);
var nP: TPoint;
    nIdx: integer;
    nData: Pointer;
begin
  if not Assigned(Node) then Exit;
  GetCursorPos(nP);
  nP := ScreenList.ScreenToClient(nP);
  if not (ScreenList.Focused or PtInRect(ScreenList.ClientRect, nP))then Exit;
  //由外部导致的节点异动不予处理

  if Node.ImageIndex = cImgScreen then
  begin
    UnSelecteAllMovedItem(FActiveMovie);
    ShowScreenSummary(Node.Data, BtmPanel); Exit;
  end; //屏幕信息

  if Node.ImageIndex = cImgMovie then
  begin
    UnSelecteAllMovedItem(FActiveMovie);
    //取消组件选中

    nData := Node.Data;
    ShowScreenSummary(Node.Parent.Data, BtmPanel);
  end else

  if Assigned(Node.Parent) and (Node.Parent.ImageIndex = cImgMovie) then
    nData := Node.Parent.Data
  else Exit;

  if FActiveMovie <> nData then
  begin
    UnSelecteAllMovedItem(FActiveMovie);
    //取消组件选中
    
    HidenMovieList;
    FActiveMovie := nData;
    FActiveMovie.Show;

    SetToolbarStatus;
    WorkPanelResize(nil);
  end;

  if Node.ImageIndex <> cImgMovie then
  begin
    for nIdx:=FActiveMovie.ControlCount - 1 downto 0 do
     if FActiveMovie.Controls[nIdx] = Node.Data then
      TZnMovedControl(FActiveMovie.Controls[nIdx]).Selected := True;
  end; //组件信息
end;

//Desc: 依据活动屏设置工具栏状态
procedure TfFormMain.SetToolbarStatus;
var nIdx: integer;
    nNode: TTreeNode;
    nItem: TCardItem;
begin
  if Assigned(FActiveMovie) then
  begin
    nNode := GetMovedItemNode(FActiveMovie);
    if Assigned(nNode) then nNode := nNode.Parent;
    if not Assigned(nNode) then Exit;

    nIdx := CardItemIndex(PScreenItem(nNode.Data).FCard);
    if nIdx < 0 then Exit;
    nItem := cCardList[nIdx];

    BtnText.Enabled := not (atText in nItem.FForbid);
    BtnPic.Enabled := not (atPic in nItem.FForbid);
    BtnAnimate.Enabled := not (atAnimate in nItem.FForbid);
    BtnTime.Enabled := not (atTime in nItem.FForbid);
    BtnClock.Enabled := not (atClock in nItem.FForbid);
  end;
end;

//Desc: 新建字幕
procedure TfFormMain.BtnTextClick(Sender: TObject);
var nInt: integer;
    nNode: TTreeNode;
    nItem: TTextMovedItem;
begin
  if Assigned(FActiveMovie) then
  begin
    nInt := MovedItemCount(FActiveMovie, TTextMovedItem);
    nItem := TTextMovedItem.Create(FActiveMovie);

    with nItem do
    begin
      Parent := FActiveMovie;
      Text := Format(sCaptionText, [nInt]);
      ShortName := Text;

      AutoAdjustWH(FActiveMovie.ValidClientRect, nItem, 64, 16);
      Left := FActiveMovie.ValidClientRect.Left;
      Top := FActiveMovie.ValidClientRect.Top;

      Font.Size := 12;
      Font.Color := clRed;
      OnSelected := OnMovedItemSelected;

      ModeEnter := cEnterMode[3].FMode;
      SpeedEnter := 5;
      ModeExit := cExitMode[3].FMode;
      SpeedExit := 5;
    end;

    nNode := GetMovedItemNode(FActiveMovie);
    if Assigned(nNode) then
    begin
      nNode := ScreenList.Items.AddChild(nNode, nItem.Text);
      nNode.Data := nItem;

      nNode.ImageIndex := cImgText;
      nNode.SelectedIndex := nNode.ImageIndex;
    end;
  end;
end;

//Desc: 图文
procedure TfFormMain.BtnPicClick(Sender: TObject);
var nInt: integer;
    nNode: TTreeNode;
    nItem: TPictureMovedItem;
begin
  if Assigned(FActiveMovie) then
  begin
    nInt := MovedItemCount(FActiveMovie, TPictureMovedItem);
    nItem := TPictureMovedItem.Create(FActiveMovie);

    with nItem do
    begin
      Parent := FActiveMovie;
      Text := Format(sCaptionPicture, [nInt]);
      ShortName := Text;

      AutoAdjustWH(FActiveMovie.ValidClientRect, nItem, 64, 64);
      Left := FActiveMovie.ValidClientRect.Left;
      Top := FActiveMovie.ValidClientRect.Top;

      Font.Size := 12;
      Font.Color := clRed;
      OnSelected := OnMovedItemSelected; 

      ModeEnter := cEnterMode[8].FMode;
      SpeedEnter := 5;
    end;

    nNode := GetMovedItemNode(FActiveMovie);
    if Assigned(nNode) then
    begin
      nNode := ScreenList.Items.AddChild(nNode, nItem.Text);
      nNode.Data := nItem;

      nNode.ImageIndex := cImgPicture;
      nNode.SelectedIndex := nNode.ImageIndex;
    end;
  end;
end;

//Desc: 动画
procedure TfFormMain.BtnAnimateClick(Sender: TObject);
var nInt: integer;
    nNode: TTreeNode;
    nItem: TAnimateMovedItem;
begin
  if Assigned(FActiveMovie) then
  begin
    nInt := MovedItemCount(FActiveMovie, TAnimateMovedItem);
    nItem := TAnimateMovedItem.Create(FActiveMovie);

    with nItem do
    begin
      Parent := FActiveMovie;
      Text := Format(sCaptionAnimate, [nInt]);
      ShortName := Text;

      AutoAdjustWH(FActiveMovie.ValidClientRect, nItem, 64, 64);
      Left := FActiveMovie.ValidClientRect.Left;
      Top := FActiveMovie.ValidClientRect.Top;

      Font.Size := 12;
      Font.Color := clRed;
      OnSelected := OnMovedItemSelected;
    end;

    nNode := GetMovedItemNode(FActiveMovie);
    if Assigned(nNode) then
    begin
      nNode := ScreenList.Items.AddChild(nNode, nItem.Text);
      nNode.Data := nItem;

      nNode.ImageIndex := cImgPicture;
      nNode.SelectedIndex := nNode.ImageIndex;
    end;
  end;
end;

//Desc: 时间
procedure TfFormMain.BtnTimeClick(Sender: TObject);
var nInt: integer;
    nNode: TTreeNode;
    nItem: TTimeMovedItem;
begin
  if Assigned(FActiveMovie) then
  begin
    nInt := MovedItemCount(FActiveMovie, TTimeMovedItem);
    nItem := TTimeMovedItem.Create(FActiveMovie);

    with nItem do
    begin
      Parent := FActiveMovie;
      ShortName := Format(sCaptionTime, [nInt]);

      AutoAdjustWH(FActiveMovie.ValidClientRect, nItem, 96, 16);
      Left := FActiveMovie.ValidClientRect.Left;
      Top := FActiveMovie.ValidClientRect.Top;

      Font.Size := 12;
      Font.Color := clRed;
      OnSelected := OnMovedItemSelected;
    end;

    nNode := GetMovedItemNode(FActiveMovie);
    if Assigned(nNode) then
    begin
      nNode := ScreenList.Items.AddChild(nNode, nItem.ShortName);
      nNode.Data := nItem;

      nNode.ImageIndex := cImgTime;
      nNode.SelectedIndex := nNode.ImageIndex;
    end;
  end;
end;

//Desc: 模拟时钟
procedure TfFormMain.BtnClockClick(Sender: TObject);
var nInt: integer;
    nNode: TTreeNode;
    nItem: TClockMovedItem;
begin
  if Assigned(FActiveMovie) then
  begin
    nInt := MovedItemCount(FActiveMovie, TClockMovedItem);
    nItem := TClockMovedItem.Create(FActiveMovie);

    with nItem do
    begin
      Parent := FActiveMovie;
      Text := Format(sCaptionClock, [nInt]);
      ShortName := Text;

      AutoAdjustWH(FActiveMovie.ValidClientRect, nItem, 32, 32);
      Left := FActiveMovie.ValidClientRect.Left;
      Top := FActiveMovie.ValidClientRect.Top;

      Font.Size := 10;
      Font.Color := clRed;
      OnSelected := OnMovedItemSelected;
    end;

    nNode := GetMovedItemNode(FActiveMovie);
    if Assigned(nNode) then
    begin
      nNode := ScreenList.Items.AddChild(nNode, nItem.ShortName);
      nNode.Data := nItem;

      nNode.ImageIndex := cImgClock;
      nNode.SelectedIndex := nNode.ImageIndex;
    end;
  end;
end;

//Desc: 边框
procedure TfFormMain.BtnBorderClick(Sender: TObject);
begin
  if Assigned(FActiveMovie) then
    ShowBorderForm(FActiveMovie, GetMovedItemNode(FActiveMovie).Parent.Data);
  //xxxxx
end;

//Desc: 删除
procedure TfFormMain.BtnDeClick(Sender: TObject);
var nStr: string;
    i,nIdx: integer;
    nNode: TTreeNode;
begin
  if ScreenList.Focused and Assigned(ScreenList.Selected) and
     (ScreenList.Selected.ImageIndex = cImgMovie) then
  begin
    nStr := Format(ML('确定要删除选节目[ %s ]吗?', sMLMain), [ScreenList.Selected.Text]);
    if not QueryDlg(nStr, sAsk, Handle) then Exit;

    FMovieList.Delete(FMovieList.IndexOf(FActiveMovie));
    FreeAndNil(FActiveMovie);
    ScreenList.Selected.Delete; Exit;
  end; //删除节目

  if Assigned(FActiveMovie) then
  begin
    for nIdx:=FActiveMovie.ControlCount - 1 downto 0 do
     if FActiveMovie.Controls[nIdx] is TZnMovedControl and
        TZnMovedControl(FActiveMovie.Controls[nIdx]).Selected and
        QueryDlg(ML('确定要删除选中组件吗?', sMLMain), sAsk) then
     begin
       for i:=0 to BtmPanel.ControlCount - 1 do
        if (BtmPanel.Controls[i] is TfFrameBase) and
           (TfFrameBase(BtmPanel.Controls[i]).MovedItem = FActiveMovie.Controls[nIdx]) then
          BtmPanel.Controls[i].Visible := False;
        //隐藏编辑器

       nNode := GetMovedItemNode(FActiveMovie.Controls[nIdx]);
       if Assigned(nNode) then ScreenList.Items.Delete(nNode);
       FActiveMovie.Controls[nIdx].Free; Break;
     end;
  end;
end;

//------------------------------------------------------------------------------ 
//Desc: 新建
procedure TfFormMain.acNewExecute(Sender: TObject);
begin
  if (not Showing) or QueryDlg(ML('确定要新建显示屏的播放文件吗?', Name), sAsk) then
  begin
    gDataManager.ResetBlank(True);
    ClearMovieList(False);
    LoadScreenListToTreeview;

    with TIniFile.Create(gPath + sFormConfig) do
    try
      WriteString(Name, 'LastSave', '');
    finally
      Free;
    end;
  end;
end;

//Desc: 退出
procedure TfFormMain.acExitExecute(Sender: TObject);
begin
  Close;
end;

//Desc: 新建节目
procedure TfFormMain.BtnMovieClick(Sender: TObject);
var nStr: string;
    nRect: TRect;
    nNode: TTreeNode;
    nScreen: PScreenItem;
begin
  nNode := GetSelectedScreenNode(ScreenList);
  if not Assigned(nNode) then
  begin
    ShowMsg(ML('请选择节目所在的屏幕', Name), sHint); Exit;
  end;

  UnSelecteAllMovedItem(FActiveMovie);
  HidenMovieList;
  nScreen := PScreenItem(nNode.Data);

  FActiveMovie := TZnBorderControl.Create(WorkPanel);
  FMovieList.Add(FActiveMovie);

  with FActiveMovie do
  begin
    Parent := WorkPanel;
    Width := nScreen.FLenX;
    Height := nScreen.FLenY;

    nRect := ValidClientRect;
    Width := Width * 2 - (nRect.Right - nRect.Left);
    Height := Height * 2 - (nRect.Bottom - nRect.Top);
    WorkPanelResize(nil);
  end;

  nStr := Format(sCaptionMovie, [ChildNodeCount(nNode)]);     
  with ScreenList.Items.AddChild(nNode, nStr) do
  begin
    ImageIndex := cImgMovie;
    SelectedIndex := ImageIndex;
    Data := FActiveMovie;

    Selected := True;
    MakeVisible;
  end;
  
  nNode.Expanded := True;
end;

//Desc: 设置屏参
procedure TfFormMain.acScreenExecute(Sender: TObject);
var i,nIdx,nCount: Integer;
    nZnCtrl: TZnBorderControl;
begin
  if not ShowScreenSetupForm then Exit;
  if not FileExists(gDataManager.DataFile) then
  begin
   LoadScreenList(gScreenList);
   LoadScreenListToTreeview; Exit;
  end;

  for nIdx:=gScreenList.Count - 1 downto 0 do
  with PScreenItem(gScreenList[nIdx])^ do
  begin
    nCount := FMovieList.Count - 1;
    for i:=0 to nCount do
    begin
      nZnCtrl := TZnBorderControl(FMovieList[i]);
      if nZnCtrl.Tag <> nIdx then Continue;

      nZnCtrl.Width := FLenX;
      nZnCtrl.Height := FLenY;

      with nZnCtrl,nZnCtrl.ValidClientRect do
      begin
        Width := Width + (Width - Right + Left);
        Height := Height + (Height - Bottom + Top);
      end;
      AdjustItemsWH(nZnCtrl);
    end;
  end;
  //从文件打开,更新节目宽度
end;

//Desc: 连接测试
procedure TfFormMain.acConnTestExecute(Sender: TObject);
begin
  ShowConnTestForm;
end;

//Desc: 复位控制器
procedure TfFormMain.acResetCtrlExecute(Sender: TObject);
begin
  ShowResetCtrlForm;
end;

//Desc: 校准时间
procedure TfFormMain.acAdjustTimeExecute(Sender: TObject);
begin
  ShowAdjustTimeForm;
end;

//Desc: 设置宽高
procedure TfFormMain.acSetWHExecute(Sender: TObject);
begin
  ShowSetWHForm;
end;

//Desc: 设定亮度
procedure TfFormMain.acBrightExecute(Sender: TObject);
begin
  ShowSetBrightForm;
end;

//Desc: 自动屏幕亮度
procedure TfFormMain.acBrightTimeExecute(Sender: TObject);
begin
  ShowSetBrightTimeForm;
end;

//Desc: 手工开关屏幕
procedure TfFormMain.acOCExecute(Sender: TObject);
begin
  ShowOpenOrCloseForm;
end;

//Desc: 自动开关屏幕
procedure TfFormMain.acOCTimeExecute(Sender: TObject);
begin
  ShowOCTimeForm;
end;

//Desc: 播放天数
procedure TfFormMain.acPlayDaysExecute(Sender: TObject);
begin
  ShowPlayDaysForm;
end;

//Desc: 读取控制器状态
procedure TfFormMain.acStatusExecute(Sender: TObject);
begin
  ShowReadStatusForm;
end;

//------------------------------------------------------------------------------
//Desc: 调整区域编号和优先级
procedure AdjustMovedItemList(const nList: TList);
var nStr: string;
    i,nCount,nIdx,nSID: integer;
    nItem,nTmp: PMovedItemData;
begin
  nIdx := 0;
  nCount := nList.Count - 1;

  while nIdx < nCount do
  begin
    nItem := nList[nIdx];
    
    for i:=nIdx+1 to nCount do
    begin
      nTmp := nList[i];
      if nTmp.FPosX < nItem.FPosX then
      begin
        nList[nIdx] := nTmp;
        nList[i] := nItem;
        nItem := nTmp;
      end;
    end;

    Inc(nIdx);
  end; //按从左到右排列

  nIdx := 0;
  while nIdx < nCount do
  begin
    nItem := nList[nIdx];
    
    for i:=nIdx+1 to nCount do
    begin
      nTmp := nList[i];
      if nTmp.FPosY < nItem.FPosY then
      begin
        nList[nIdx] := nTmp;
        nList[i] := nItem;
        nItem := nTmp;
      end;
    end;

    Inc(nIdx);
  end; //按从上到下排列

  for i:=0 to nCount do
  begin
    nItem := nList[i];
    if nItem.FTypeIdx > 0 then Continue;

    nIdx := i; nSID := 1;
    nStr := nItem.FItem.ClassName;

    while nIdx <= nCount do
    begin
      nItem := nList[nIdx];
      Inc(nIdx);
      
      if nItem.FItem.ClassName = nStr then
      begin
        nItem.FTypeIdx := nSID;
        Inc(nSID);
      end;
    end;
  end; //同类型区域编号
end;

//Desc: 判断nList组件列表是否有区域重叠
function IsItemCrossed(const nList: TList): Boolean;
var nStr: string;
    nRect,nR: TRect;
    nItem: PMovedItemData;
    i,nCount,nIdx: integer;
begin
  Result := False;
  nCount := nList.Count - 1;

  for i:=0 to nCount do
  begin
    nItem := nList[i];
    with nItem^ do
      nRect := Rect(FPosX, FPosY, FPosX + FWidth, FPosY + FHeight);
    nIdx := i + 1;

    while nIdx <= nCount do
    begin
      nItem := nList[nIdx];
      with nItem^ do
        nR := Rect(FPosX, FPosY, FPosX + FWidth, FPosY + FHeight);
      //xxxxx

      if nR.Left < nRect.Left then nR.Left := nRect.Left;
      if nR.Top < nRect.Top then nR.Top := nRect.Top;
      if nR.Right > nRect.Right then nR.Right := nRect.Right;
      if nR.Bottom > nRect.Bottom then nR.Bottom := nRect.Bottom;

      Result := (nR.Right > nR.Left) and (nR.Bottom > nR.Top);
      if Result then
      begin      
        nStr := ML('组件"%s"和"%s"区域重叠,请调整位置!!', sMLMain);
        nStr := Format(nStr, [TZnMovedControl(PMovedItemData(nItem.FItem)).ShortName,
                TZnMovedControl(PMovedItemData(nList[i]).FItem).ShortName]);
        ShowDlg(nStr, sHint); Exit;
      end else Inc(nIdx);
    end;
  end;
end;

//Desc: 获取待发送的组件列表
procedure TfFormMain.GetItemSended(const nList: TList; const nSelected: Boolean);
var nItem: PMovedItemData;
    i,nCount,nIdx: integer;
begin
  ClearMovedItemDataList(nList, False);
  //清空列表
  nIdx := 1;
  nCount := FActiveMovie.ControlCount - 1;

  for i:=0 to nCount do
  if (FActiveMovie.Controls[i] is TZnMovedControl) and
     ((not nSelected) Or TZnMovedControl(FActiveMovie.Controls[i]).Selected) then
  begin
    New(nItem);
    nList.Add(nItem);
    FillChar(nItem^, SizeOf(TMovedItemData), #0);

    nItem.FItem := TZnMovedControl(FActiveMovie.Controls[i]);
    nItem.FPosX := nItem.FItem.Left - FActiveMovie.ValidClientRect.Left;
    nItem.FPosY := nItem.FItem.Top - FActiveMovie.ValidClientRect.Top;

    nItem.FLevel := nIdx; Inc(nIdx);
    nItem.FWidth := nItem.FItem.Width;
    nItem.FHeight := nItem.FItem.Height;
  end;

  AdjustMovedItemList(nList);
  //调整优先级
end;

//Desc: 发送选中
procedure TfFormMain.acSendSelectedExecute(Sender: TObject);
var nList: TList;
begin
  nList := nil;
  if Assigned(FActiveMovie) then
  try
    nList := TList.Create;
    GetItemSended(nList, True);
    if IsItemCrossed(nList) then Exit;

    if nList.Count > 0 then
      ShowSendDataForm(GetMovedItemNode(FActiveMovie).Parent.Data, nList);
    //xxxxx
  finally
    if Assigned(nList) then ClearMovedItemDataList(nList, True);
  end;
end;

//Desc: 发送全部
procedure TfFormMain.acSendAllExecute(Sender: TObject);
var nList: TList;
begin
  nList := nil;
  if Assigned(FActiveMovie) then
  try
    nList := TList.Create;
    GetItemSended(nList, False);
    if IsItemCrossed(nList) then Exit;

    if nList.Count > 0 then
      ShowSendDataForm(GetMovedItemNode(FActiveMovie).Parent.Data, nList);
    //xxxxx
  finally
    if Assigned(nList) then ClearMovedItemDataList(nList, True);
  end;
end;

//Desc: 发送数据
procedure TfFormMain.BtnSendClick(Sender: TObject);
var nList: TList;
begin
  nList := nil;
  if Assigned(FActiveMovie) then
  try
    nList := TList.Create;
    GetItemSended(nList, False);
    
    if nList.Count < 1 then Exit;
    if IsItemCrossed(nList) then Exit;

    ShowWaitForm(ML('数据发送中', Name));
    EnableWindow(Handle, False);

    gNeedAdjustWH := True;
    if SendDataToDevice(GetMovedItemNode(FActiveMovie).Parent.Data, -1, nList) then
      ShowMsg(ML('发送成功', Name), sHint);
    //xxxxx
  finally
    gNeedAdjustWH := False;
    CloseWaitForm;
    EnableWindow(Handle, True);
    if Assigned(nList) then ClearMovedItemDataList(nList, True);
  end;
end;

//Desc: 从文件中加载节目列表
procedure TfFormMain.LoadScreenListInFileToTreeView;
var nStr: string;
    nItem: PScreenItem;
    nNode,nTmp: TTreeNode;
    i,nCount,nIdx: integer;
begin
  ScreenList.Items.BeginUpdate;
  try
    ScreenList.Selected := nil;
    ScreenList.Items.Clear;

    ClearMovieList(False);
    nCount := gScreenList.Count - 1;
    
    for i:=0 to nCount do
    begin
      nItem := gScreenList.Items[i];
      //nStr := Format(sCaptionScreen, [i]);
      nNode := ScreenList.Items.AddChild(nil, nItem.FName);

      nNode.Data := nItem;
      nNode.ImageIndex := cImgScreen;
      nNode.SelectedIndex := nNode.ImageIndex;

      for nIdx:=Low(gDataManager.Movies) to High(gDataManager.Movies) do
      with gDataManager.Movies[nIdx] do
      begin
        if Tag <> i then Continue;
        FMovieList.Add(gDataManager.Movies[nIdx]);

        Hide;
        Tag := i;
        OnClick := OnMovieControlClick;

        nStr := Format(sCaptionMovie, [ChildNodeCount(nNode)]);
        nTmp := ScreenList.Items.AddChild(nNode, nStr);
        
        with nTmp do
        begin
          ImageIndex := cImgMovie;
          SelectedIndex := ImageIndex;
          Data := gDataManager.Movies[nIdx];
        end;

        LoadMovedItemToTreeView(nTmp);
      end;
    end;
  finally
    if ScreenList.Items.Count > 0 then
    begin
      ScreenList.FullExpand;
      nNode := ScreenList.Items[0].getFirstChild;
      
      nNode.Selected := True;
      ShowScreenSummary(nNode.Parent.Data, BtmPanel);
      
      FActiveMovie := TZnBorderControl(nNode.Data);
      FActiveMovie.Show;
      SetToolbarStatus;
    end;

    WorkPanelResize(nil);
    ScreenList.Items.EndUpdate;
  end;
end;

//Desc: 打开文件
procedure TfFormMain.acOpenExecute(Sender: TObject);
var nStr: string;
begin
  gMultiLangManager.SectionID := Name;
  gDataManager.MovieParent := WorkPanel;

  with TOpenDialog.Create(Application) do
  begin
    Title := ML('打开');
    Options := Options + [ofFileMustExist];
    Filter := ML('节目文件') + '(*.hbm)|*.hbm';

    if Execute then
         nStr := FileName
    else nStr := '';
    Free;
  end;

  if nStr = '' then Exit;
  if not gDataManager.LoadFromFile(nStr) then
  begin
    ShowMsg(ML('无法正确加载节目'), sHint); Exit;
  end;

  LoadScreenList(gScreenList);
  LoadScreenListInFileToTreeView;
  gDataManager.ResetBlank(False);
end;

//Desc: 保存数据
procedure TfFormMain.acSaveExecute(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  gMultiLangManager.SectionID := Name;
  gDataManager.MovieParent := WorkPanel;

  if not FileExists(gDataManager.DataFile) then
  begin
    with TSaveDialog.Create(Self) do
    begin
      Title := ML('保存');
      Options := Options + [ofOverwritePrompt];

      DefaultExt := '.hbm';
      Filter := ML('节目文件') + '(*.hbm)|*.hbm';

      if Execute then nStr := FileName else nStr := '';
      Free;
    end;
  end else nStr := gDataManager.DataFile;

  if nStr <> '' then
   if gDataManager.SaveToFile(nStr) then
   begin
     nIni := TIniFile.Create(gPath + sFormConfig);
     nIni.WriteString(Name, 'LastSave', nStr);
     nIni.Free;
     
     ShowMsg(ML('节目已成功保存'), sHint);
   end;
end;

//Desc: 关于
procedure TfFormMain.N13Click(Sender: TObject);
var nStr,nMsg: string;
begin
  nStr := Caption;
  nMsg := StringReplace(gSysParam.FCopyRight, '\n', #13#10, [rfReplaceAll]);
  ShellAbout(Handle, PChar(nStr), PChar(nMsg), Application.Icon.Handle);
end;

end.
