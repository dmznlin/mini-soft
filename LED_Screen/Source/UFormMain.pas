unit UFormMain;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UTrayIcon, Dialogs, ComCtrls, Buttons, StdCtrls, ImgList, ExtCtrls, UMgrCard;

type
  TfFormMain = class(TForm)
    HintPanel: TPanel;
    Image1: TImage;
    Image2: TImage;
    HintLabel: TLabel;
    wPage: TPageControl;
    SheetStatus: TTabSheet;
    SheetDebug: TTabSheet;
    SheetSetup: TTabSheet;
    SBar: TStatusBar;
    MemoLog: TMemo;
    Timer1: TTimer;
    ImageList1: TImageList;
    ListDevice: TListView;
    ImageList2: TImageList;
    ParamPage: TPageControl;
    SheetBase: TTabSheet;
    SheetScreen: TTabSheet;
    GroupBox2: TGroupBox;
    BtnRun: TButton;
    BtnStop: TButton;
    CheckLogs: TCheckBox;
    GroupBox1: TGroupBox;
    CheckAutoRun: TCheckBox;
    CheckAutoMin: TCheckBox;
    TreeScreen: TTreeView;
    Label1: TLabel;
    GroupScreen: TGroupBox;
    Label2: TLabel;
    EditType: TComboBox;
    Label3: TLabel;
    EditName: TEdit;
    Bevel1: TBevel;
    Label4: TLabel;
    Label5: TLabel;
    EditIP: TEdit;
    EditPort: TEdit;
    Label6: TLabel;
    EditCard: TComboBox;
    Label7: TLabel;
    EditSerial: TEdit;
    Label8: TLabel;
    EditW: TEdit;
    Label9: TLabel;
    EditH: TEdit;
    Label10: TLabel;
    EditEffect: TComboBox;
    GroupBox4: TGroupBox;
    EditTime: TDateTimePicker;
    Label11: TLabel;
    Label12: TLabel;
    EditFile: TEdit;
    BtnOpen: TBitBtn;
    BtnAdd: TSpeedButton;
    BtnDel: TSpeedButton;
    Label14: TLabel;
    Label15: TLabel;
    EditSpeed: TEdit;
    EditKeep: TEdit;
    Bevel2: TBevel;
    Label16: TLabel;
    EditFont: TEdit;
    Label17: TLabel;
    EditSize: TEdit;
    CheckBold: TCheckBox;
    BtnLate: TButton;
    CheckOE: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure EditTypeExit(Sender: TObject);
    procedure TreeScreenClick(Sender: TObject);
    procedure BtnOpenClick(Sender: TObject);
    procedure BtnRunClick(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure BtnLateClick(Sender: TObject);
  private
    { Private declarations }
    FTrayIcon: TTrayIcon;
    //状态栏
    FLastRun: TDateTime;
    //上次运行
    FNowCard: PCardItem;
    //当前卡
    procedure InitFormData;
    //初始化
    procedure LoadCardList;
    //屏幕列表
    procedure DoParamConfig(const nRead: Boolean);
    //参数配置
    procedure CtrlStatus(const nRun: Boolean);
    //组件状态
    procedure ShowLog(const nMsg: string);
    //显示日志
    procedure CardStatus(const nItem: TCardItem; const nMsg: string);
    //卡状态
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses
  IniFiles, Registry, ULibFun, USysConst;

//------------------------------------------------------------------------------
//Desc: 从nID指定的小节读取nList的配置信息
procedure LoadListViewConfig(const nID: string; const nListView: TListView;
 const nIni: TIniFile = nil);
var nTmp: TIniFile;
    nList: TStrings;
    i,nCount: integer;
begin
  nTmp := nil;
  nList := TStringList.Create;
  try
    if Assigned(nIni) then
         nTmp := nIni
    else nTmp := TIniFile.Create(gPath + sFormConfig); 

    nList.Text := StringReplace(nTmp.ReadString(nID, nListView.Name + '_Cols',
                                ''), ';', #13, [rfReplaceAll]);
    if nList.Count <> nListView.Columns.Count then Exit;

    nCount := nListView.Columns.Count - 1;
    for i:=0 to nCount do
     if IsNumber(nList[i], False) then
      nListView.Columns[i].Width := StrToInt(nList[i]);
    //xxxxx
  finally
    nList.Free;
    if not Assigned(nIni) then FreeAndNil(nTmp);
  end;
end;

//Desc: 将nList的信息存入nID指定的小节
procedure SaveListViewConfig(const nID: string; const nListView: TListView;
 const nIni: TIniFile = nil);
var nStr: string;
    nTmp: TIniFile;
    i,nCount: integer;
begin
  nTmp := nil;
  try
    if Assigned(nIni) then
         nTmp := nIni
    else nTmp := TIniFile.Create(gPath + sFormConfig); 

    nStr := '';
    nCount := nListView.Columns.Count - 1;

    for i:=0 to nCount do
    begin
      nStr := nStr + IntToStr(nListView.Columns[i].Width);
      if i <> nCount then nStr := nStr + ';';
    end;

    nTmp.WriteString(nID, nListView.Name + '_Cols', nStr);
  finally
    if not Assigned(nIni) then FreeAndNil(nTmp);
  end;
end;

//Desc: 初始化窗体
procedure TfFormMain.InitFormData;
var nStr: string;
    nIdx: Integer;
begin
  wPage.ActivePage := SheetSetup;
  ParamPage.ActivePage := SheetBase;

  EditType.Clear;
  for nIdx:=Low(cCardScreens) to High(cCardScreens) do
  begin
    nStr := Format('%d.%s', [nIdx, cCardScreens[nIdx].FDesc]);
    EditType.Items.AddObject(nStr, TObject(cCardScreens[nIdx].FCode));
  end;

  EditCard.Clear;
  for nIdx:=Low(cCardList) to High(cCardList) do
  begin
    nStr := Format('%d.%s', [nIdx, cCardList[nIdx].FDesc]);
    EditCard.Items.AddObject(nStr, TObject(cCardList[nIdx].FCode));
  end;

  EditEffect.Clear;
  for nIdx:=Low(cCardEffects) to High(cCardEffects) do
  begin
    nStr := Format('%d.%s', [nIdx, cCardEffects[nIdx].FDesc]);
    EditEffect.Items.AddObject(nStr, TObject(cCardEffects[nIdx].FCode));
  end;

  gCardManager.OnMessage := CardStatus;
  gCardManager.FileName := gPath + 'Card.Ini';
  LoadCardList;
  LoadListViewConfig(Name, ListDevice);
end;

procedure TfFormMain.FormCreate(Sender: TObject);
var nStr: string;
begin
  Randomize;
  ShortDateFormat := 'YYYY-MM-DD';

  gDebugLog := ShowLog;
  gPath := ExtractFilePath(Application.ExeName);

  with gSysParam do
  begin
    FAppTitle := 'LED大屏显示';
    FMainTitle := FAppTitle;
  end;

  Application.Title := gSysParam.FAppTitle;
  InitGlobalVariant(gPath, gPath + sConfigFile, gPath + sFormConfig, gPath + sDBConfig);

  nStr := GetFileVersionStr(Application.ExeName);
  if nStr <> '' then
  begin
    nStr := Copy(nStr, 1, Pos('.', nStr) - 1);
    Caption := gSysParam.FMainTitle + ' V' + nStr;
  end else Caption := gSysParam.FMainTitle;

  FTrayIcon := TTrayIcon.Create(Self);
  FTrayIcon.Hint := gSysParam.FAppTitle;
  FTrayIcon.Visible := True;
  //系统托盘

  InitFormData;
  //初始化
  DoParamConfig(True);
  //载入配置
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {$IFNDEF debug}
  if not QueryDlg(sCloseQuery, sHint) then
  begin
    Action := caNone; Exit;
  end;
  {$ENDIF}

  SaveListViewConfig(Name, ListDevice);
  DoParamConfig(False);
  //保存配置
end;

//------------------------------------------------------------------------------
//Desc: 显示调试记录
procedure TfFormMain.ShowLog(const nMsg: string);
var nStr: string;
begin
  if CheckLogs.Checked then
  begin
    if MemoLog.Lines.Count > 200 then
      MemoLog.Clear;
    //clear logs

    nStr := Format('【%s】::: %s', [Time2Str(Now), nMsg]);
    MemoLog.Lines.Add(nStr);
  end;
end;

procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  SBar.Panels[0].Text := FormatDateTime('日期:【yyyy-mm-dd】', Now);
  SBar.Panels[1].Text := FormatDateTime('时间:【hh:mm:ss】', Now);

  if not BtnRun.Enabled then
  begin
    if Now - FLastRun < 1 then Exit;
    //one day
    if Time() - EditTime.Time < 0 then Exit;
    //not until

    FLastRun := Now;
    if gCardManager.SendData(EditFile.Text) then
         ShowLog('数据成功加载!')
    else ShowLog('数据加载失败!文件路径错误或内容无效.');
  end;
end;

//Desc: 参数配置的读取与保存
procedure TfFormMain.DoParamConfig(const nRead: Boolean);
var nIni: TIniFile;
    nReg: TRegistry;
begin
  nIni := TIniFile.Create(gPath + sConfigFile);
  nReg := TRegistry.Create;
  try
    nReg.RootKey := HKEY_CURRENT_USER;
    nReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    //registry

    if nRead then
    begin
      CheckAutoRun.Checked := nReg.ValueExists('LEDMgr');
      CheckAutoMin.Checked := nIni.ReadBool('Setup', 'AutoMin', False);

      EditTime.DateTime := nIni.ReadDateTime('Setup', 'CheckTime', Time());
      EditFile.Text := nIni.ReadString('Setup', 'FilePath', '');

      if CheckAutoMin.Checked then
      begin
        if EditFile.Text <> '' then
        begin
          BtnRun.Click;
          WindowState := wsMinimized;
          FTrayIcon.Minimize;
        end;
      end;
    end else
    begin
      nIni.WriteBool('Setup', 'AutoMin', CheckAutoMin.Checked);
      nIni.WriteDateTime('Setup', 'CheckTime', EditTime.Time);
      nIni.WriteString('Setup', 'FilePath', EditFile.Text);

      if CheckAutoRun.Checked then
        nReg.WriteString('LEDMgr', Application.ExeName)
      else if nReg.ValueExists('LEDMgr') then
        nReg.DeleteValue('LEDMgr');
      //xxxxx
    end;
  finally
    nReg.Free;
    nIni.Free;
  end;
end;

//Desc: 载入屏幕列表
procedure TfFormMain.LoadCardList;
var i,nLen: Integer;
    nItem,nSelect: PCardItem;
begin
  nLen := gCardManager.Cards.Count - 1;
  TreeScreen.Items.BeginUpdate;
  try
    if Assigned(TreeScreen.Selected) then
         nSelect := TreeScreen.Selected.Data
    else nSelect := nil;

    TreeScreen.Items.Clear;
    //clear all

    for i:=0 to nLen do
    begin
      nItem := gCardManager.Cards[i];

      with TreeScreen.Items.AddChild(nil, nItem.FSerial) do
      begin
        ImageIndex := 2;
        SelectedIndex := ImageIndex;
        Data := nItem;

        if nItem = nSelect then
          Selected := True;
        MakeVisible;
      end;
    end;
  finally
    TreeScreen.Items.EndUpdate;
  end;

  ListDevice.Items.BeginUpdate;
  try
    ListDevice.Clear;
    //clear all

    for i:=0 to nLen do
    begin
      nItem := gCardManager.Cards[i];

      with ListDevice.Items.Add do
      begin
        Caption := nItem.FSerial;
        Data := nItem;

        SubItems.Add(nItem.FName);
        SubItems.Add(nItem.FIP);
        SubItems.Add(IntToStr(nItem.FPort));
        SubItems.Add(nItem.FLatUpdate);

        if nItem.FStatus = csSending then
             ImageIndex := 1
        else ImageIndex := 0;  
      end;
    end;
  finally
    ListDevice.Items.EndUpdate;
  end;
end;

//Desc: 在nList中检索nCode码所在的索引
function FindListCode(const nCode: Integer; const nList: TStrings): Integer;
var nIdx: Integer;
begin
  Result := -1;

  for nIdx:=nList.Count - 1 downto 0 do
  if Integer(nList.Objects[nIdx]) = nCode then
  begin
    Result := nIdx; Break;
  end;
end;

procedure TfFormMain.TreeScreenClick(Sender: TObject);
begin
  if Assigned(TreeScreen.Selected) then
  with PCardItem(TreeScreen.Selected.Data)^ do
  begin
    FNowCard := TreeScreen.Selected.Data;
    EditType.ItemIndex :=  FindListCode(FType, EditType.Items);
    EditSerial.Text := FSerial;
    EditName.Text := FName;

    EditCard.ItemIndex := FindListCode(FCard, EditCard.Items);
    CheckOE.Checked := FDataOE <> 0;
    EditIP.Text := FIP;
    EditPort.Text := IntToStr(FPort);
    EditW.Text := IntToStr(FWidth);
    EditH.Text := IntToStr(FHeight);

    EditSpeed.Text := IntToStr(FSpeed);
    EditKeep.Text := IntToStr(FKeep);
    EditEffect.ItemIndex := FindListCode(FEffect, EditEffect.Items);

    EditFont.Text := FFontName;
    EditSize.Text := IntToStr(FFontSize);
    CheckBold.Checked := FFontBold <> 0;
  end;
end;

//Desc: 添加新屏
procedure TfFormMain.BtnAddClick(Sender: TObject);
var nItem: TCardItem;
begin
  FillChar(nItem, SizeOf(nItem), #0);
  nItem.FType := 1;
  nItem.FSerial := 'New Screen';
  nItem.FCard := CONTROLLER_TYPE_4M1;
  nItem.FSpeed := 1;
  nItem.FKeep := 10;
  nItem.FFontName := '宋体';
  nItem.FFontSize := 9;

  gCardManager.AddCard(nItem);
  LoadCardList;
end;

//Desc: 删除屏幕
procedure TfFormMain.BtnDelClick(Sender: TObject);
var nItem: PCardItem;
begin
  if not Assigned(TreeScreen.Selected) then
  begin
    ShowMsg('请选择要删除的屏幕', sHint); Exit;
  end;

  if QueryDlg('确定要删除该屏幕吗?', sAsk, Handle) then
  begin
    nItem := TreeScreen.Selected.Data;
    gCardManager.DelCard(nItem.FSerial);

    if nItem = FNowCard then
      FNowCard := nil;
    LoadCardList;
  end;
end;

//Desc: 修改生效
procedure TfFormMain.EditTypeExit(Sender: TObject);
begin
  if not BtnRun.Enabled then Exit;
  //运行时不允许修改
  if not Assigned(FNowCard) then Exit;
  //节点已无效

  if Sender = EditType then
  begin
    if EditType.ItemIndex < 0 then
    begin
      EditType.SetFocus; Exit;
    end;

    FNowCard.FType := Integer(EditType.Items.Objects[EditType.ItemIndex]);
  end else

  if Sender = EditSerial then
  begin
    EditSerial.Text := Trim(EditSerial.Text);
    if EditSerial.Text = '' then
    begin
      EditSerial.SetFocus; Exit;
    end;

    FNowCard.FSerial := EditSerial.Text;
  end else

  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then
    begin
      EditName.SetFocus; Exit;
    end;

    FNowCard.FName := EditName.Text;
  end else

  if Sender = EditCard then
  begin
    if EditCard.ItemIndex < 0 then
    begin
      EditCard.SetFocus; Exit;
    end;

    FNowCard.FCard := Integer(EditCard.Items.Objects[EditCard.ItemIndex]);
  end else

  if Sender = CheckOE then
  begin
    if CheckOE.Checked then
         FNowCard.FDataOE := 1
    else FNowCard.FDataOE := 0;
  end;

  if Sender = EditIP then
  begin
    EditIP.Text := Trim(EditIP.Text);
    if EditIP.Text = '' then
    begin
      EditIP.SetFocus; Exit;
    end;

    FNowCard.FIP := EditIP.Text;
  end else

  if Sender = EditPort then
  begin
    if not IsNumber(EditPort.Text, False) then
    begin
      EditPort.SetFocus; Exit;
    end;

    FNowCard.FPort := StrToInt(EditPort.Text);
  end else

  if Sender = EditW then
  begin
    if not IsNumber(EditW.Text, False) then
    begin
      EditW.SetFocus; Exit;
    end;

    FNowCard.FWidth := StrToInt(EditW.Text);
  end else

  if Sender = EditH then
  begin
    if not IsNumber(EditH.Text, False) then
    begin
      EditH.SetFocus; Exit;
    end;

    FNowCard.FHeight := StrToInt(EditH.Text);
  end else

  if Sender = EditSpeed then
  begin
    if not IsNumber(EditSpeed.Text, False) then
    begin
      EditSpeed.SetFocus; Exit;
    end;

    FNowCard.FSpeed := StrToInt(EditSpeed.Text);
  end else

  if Sender = EditKeep then
  begin
    if not IsNumber(EditKeep.Text, False) then
    begin
      EditKeep.SetFocus; Exit;
    end;

    FNowCard.FKeep := StrToInt(EditKeep.Text);
  end else

  if Sender = EditEffect then
  begin
    if EditEffect.ItemIndex < 0 then
    begin
      EditEffect.SetFocus; Exit;
    end;

    FNowCard.FEffect := Integer(EditEffect.Items.Objects[EditEffect.ItemIndex]);
  end else

  if Sender = EditFont then
  begin
    EditFont.Text := Trim(EditFont.Text);
    if EditFont.Text = '' then
    begin
      EditFont.SetFocus; Exit;
    end;

    FNowCard.FFontName := EditFont.Text;
  end;

  if Sender = EditSize then
  begin
    if not IsNumber(EditSize.Text, False) then
    begin
      EditSize.SetFocus; Exit;
    end;

    FNowCard.FFontSize := StrToInt(EditSize.Text);
  end else

  if Sender = CheckBold then
  begin
    if CheckBold.Checked then
         FNowCard.FFontBold := 1
    else FNowCard.FFontBold := 0;
  end;

  gCardManager.AddCard(FNowCard^);
  LoadCardList;
  //刷新列表
end;

//Desc: 选择文件
procedure TfFormMain.BtnOpenClick(Sender: TObject);
begin
  with TOpenDialog.Create(Application) do
  begin
    Title := '选择内容';
    DefaultExt := '.xml';
    Filter := '屏幕内容(*.xml)|*.xml';
    //Options := Options + [ofFileMustExist];

    InitialDir := ExtractFilePath(EditFile.Text);
    if Execute then EditFile.Text := FileName;
    Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 依据运行状态设置组件
procedure TfFormMain.CtrlStatus(const nRun: Boolean);
begin
  BtnRun.Enabled := not nRun;
  BtnStop.Enabled := nRun;
  BtnLate.Enabled := not nRun;
  
  EditTime.Enabled := not nRun;
  BtnOpen.Enabled := not nRun;
  BtnAdd.Enabled := not nRun;
  BtnDel.Enabled := not nRun;
  GroupScreen.Enabled := not nRun;
end;

//Desc: 启动
procedure TfFormMain.BtnRunClick(Sender: TObject);
begin
  if BtnRun.Enabled then
  begin
    if EditFile.Text = '' then
    begin
      ActiveControl := BtnOpen;
      ShowMsg('请选择有效内容文件', sHint); Exit;
    end;

    CtrlStatus(True);
    FLastRun := 0;
  end;
end;

//Desc: 停止
procedure TfFormMain.BtnStopClick(Sender: TObject);
begin
  CtrlStatus(False);
end;

//Desc: 延迟启动
procedure TfFormMain.BtnLateClick(Sender: TObject);
begin
  EditTime.Time := Time() + 1/(3600*24);
  BtnRun.Click;

  if not BtnRun.Enabled then
  begin
    if CheckLogs.Checked then
         wPage.ActivePage := SheetDebug
    else wPage.ActivePage := SheetStatus;
  end;
end;

//Desc: 卡状态改变
procedure TfFormMain.CardStatus(const nItem: TCardItem; const nMsg: string);
var nStr: string;
begin
  nStr := '编号:[ %s ] 名称:[ %s ] 信息:%s';
  ShowLog(Format(nStr,[nItem.FSerial, nItem.FName, nMsg]));

  if (nItem.FStatus = csSending) or (nItem.FStatus = csDone) then
    LoadCardList;
  //refresh list
end;

end.
