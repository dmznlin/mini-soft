unit UFormMain;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UTrayIcon, Dialogs, ComCtrls, Buttons, StdCtrls, ImgList, ExtCtrls,
  UDataModule;

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
    SheetReader: TTabSheet;
    GroupBox2: TGroupBox;
    BtnRun: TButton;
    BtnStop: TButton;
    CheckLogs: TCheckBox;
    GroupBox1: TGroupBox;
    CheckAutoRun: TCheckBox;
    CheckAutoMin: TCheckBox;
    TreeReader: TTreeView;
    Label1: TLabel;
    GroupReader: TGroupBox;
    Label2: TLabel;
    EditType: TComboBox;
    Label3: TLabel;
    EditName: TEdit;
    Bevel1: TBevel;
    Label4: TLabel;
    EditGroup: TEdit;
    Label7: TLabel;
    EditSerial: TEdit;
    BtnAdd: TSpeedButton;
    BtnDel: TSpeedButton;
    GroupNet: TGroupBox;
    Label11: TLabel;
    EditComm: TComboBox;
    Label12: TLabel;
    EditBaud: TComboBox;
    Label5: TLabel;
    EditAddr: TEdit;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    EditIP: TEdit;
    EditPort: TEdit;
    EditUser: TEdit;
    EditPwd: TEdit;
    Label14: TLabel;
    EditNoLen: TEdit;
    Label15: TLabel;
    EditTimeLen: TEdit;
    Bevel2: TBevel;
    Label16: TLabel;
    Label17: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure BtnRunClick(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure TreeReaderClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure EditTypeExit(Sender: TObject);
  private
    { Private declarations }
    FTrayIcon: TTrayIcon;
    //状态栏
    FNowReader: PReaderItem;
    //当前读头
    procedure InitFormData;
    //初始化
    procedure DoParamConfig(const nRead: Boolean);
    //参数配置
    procedure CtrlStatus(const nRun: Boolean);
    //组件状态
    procedure RefreshReaders;
    //读头列表
  public
    { Public declarations }
    procedure ShowLog(const nMsg: string);
    //显示日志
    procedure ShowRunStatus(const nTime,nCardNo,nAction,nDetail: string);
    //运行状态
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses
  IniFiles, Registry, UBase64, ULibFun, UMgrCOMM, USysConst;

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
begin
  wPage.ActivePage := SheetSetup;
  ParamPage.ActivePage := SheetBase;

  GetValidCOMPort(EditComm.Items);
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
    FAppTitle := '平安校园';
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

  if BtnStop.Enabled then
  begin
    Action := caNone;
    ShowMsg('请先停止服务', sHint); Exit;
  end;
  //stop service 

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

//Desc: 显示运行状态
procedure TfFormMain.ShowRunStatus(const nTime, nCardNo, nAction,
  nDetail: string);
begin
  with ListDevice.Items.Insert(0) do
  begin
    ImageIndex := 3;
    Caption := nTime;
    
    SubItems.Add(nCardNo);
    SubItems.Add(nAction);
    SubItems.Add(nDetail);
  end;

  if ListDevice.Items.Count > 200 then
    ListDevice.Items.Delete(200);
  //xxxxx
end;

procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  SBar.Panels[0].Text := FormatDateTime('日期:【yyyy-mm-dd】', Now);
  SBar.Panels[1].Text := FormatDateTime('时间:【hh:mm:ss】', Now);
end;

procedure TfFormMain.RefreshReaders;
var nIdx: Integer;
begin
  TreeReader.Items.BeginUpdate;
  try
    TreeReader.Items.Clear;
    
    for nIdx:=FDM.Readers.Count - 1 downto 0 do
     with PReaderItem(FDM.Readers[nIdx])^ do
      with TreeReader.Items.AddChild(nil, FID + '[ ' + FName + ' ]') do
      begin
        ImageIndex := 1;
        SelectedIndex := 0;
        Data := FDM.Readers[nIdx];
        Selected := Data = FNowReader;
      end;
    //xxxxx

    if not Assigned(TreeReader.Selected) then
      FNowReader := nil;
    //xxxxx
  finally
    TreeReader.Items.EndUpdate;
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
      CheckAutoRun.Checked := nReg.ValueExists('CardReader');
      CheckAutoMin.Checked := nIni.ReadBool('Setup', 'AutoMin', False);

      EditComm.Text := nIni.ReadString('Comm', 'Port', 'COM1');
      EditBaud.Text := IntToStr(nIni.ReadInteger('Comm', 'Baud', 9600));

      EditIP.Text := nIni.ReadString('Server', 'IP', '127.0.0.1');
      EditPort.Text := IntToStr(nIni.ReadInteger('Server', 'Port', 8080));
      EditUser.Text := nIni.ReadString('Server', 'User', 'name');
      EditPwd.Text := DecodeBase64(nIni.ReadString('Server', 'Password', ''));

      EditNoLen.Text := IntToStr(nIni.ReadInteger('Readers', 'CardLen', 10));
      EditTimeLen.Text := IntToStr(nIni.ReadInteger('Readers', 'TimeLen', 20));

      FDM.LoadReaders(nIni);
      RefreshReaders;

      if CheckAutoMin.Checked then
      begin
        //if EditFile.Text <> '' then
        begin
          BtnRun.Click;
          WindowState := wsMinimized;
          FTrayIcon.Minimize;
        end;
      end;
    end else
    begin
      nIni.WriteBool('Setup', 'AutoMin', CheckAutoMin.Checked);
      nIni.WriteString('Comm', 'Port', EditComm.Text);
      if IsNumber(EditBaud.Text, False) then
        nIni.WriteInteger('Comm', 'Baud', StrToInt(EditBaud.Text));
      //xxxxx

      nIni.WriteString('Server', 'IP', EditIP.Text);
      if IsNumber(EditPort.Text, False) then
        nIni.WriteInteger('Server', 'Port', StrToInt(EditPort.Text));
      //xxxxx

      nIni.WriteString('Server', 'User', EditUser.Text);
      nIni.WriteString('Server', 'Password', EncodeBase64(EditPwd.Text));

      if IsNumber(EditNoLen.Text, False) then
        nIni.WriteInteger('Readers', 'CardLen', StrToInt(EditNoLen.Text));
      //xxxxx

      if IsNumber(EditTimeLen.Text, False) then
        nIni.WriteInteger('Readers', 'TimeLen', StrToInt(EditTimeLen.Text));
      FDM.SaveReaders(nIni);

      if CheckAutoRun.Checked then
        nReg.WriteString('CardReader', Application.ExeName)
      else if nReg.ValueExists('CardReader') then
        nReg.DeleteValue('CardReader');
      //xxxxx
    end;
  finally
    nReg.Free;
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormMain.TreeReaderClick(Sender: TObject);
begin
  if Assigned(TreeReader.Selected) then
  with PReaderItem(TreeReader.Selected.Data)^ do
  begin
    FNowReader := TreeReader.Selected.Data;
    EditType.ItemIndex := Ord(FType);
    EditSerial.Text := FID;
    EditName.Text := FName;
    EditGroup.Text := IntToStr(FGroup);
    EditAddr.Text := IntToStr(FAddrNo);
  end;
end;

//Desc: 添加读头
procedure TfFormMain.BtnAddClick(Sender: TObject);
var nReader: PReaderItem;
begin
  New(nReader);
  with nReader^ do
  begin
    FID := 'id';
    FName := '新读头';

    FGroup := 0;
    FAddrNo := 0;
    FType := rtIn;
  end;

  FDM.AddReader(nReader);
  RefreshReaders;
end;

//Desc: 删除读头
procedure TfFormMain.BtnDelClick(Sender: TObject);
begin
  if not Assigned(TreeReader.Selected) then
  begin
    ShowMsg('请选择要删除的读头', sHint); Exit;
  end;

  if QueryDlg('确定要删除该读头吗?', sAsk, Handle) then
  begin
    FDM.DelReader(PReaderItem(TreeReader.Selected.Data).FID);
    if TreeReader.Selected.Data = FNowReader then
      FNowReader := nil;
    RefreshReaders;
  end;
end;

//Desc: 修改生效
procedure TfFormMain.EditTypeExit(Sender: TObject);
begin
  if not BtnRun.Enabled then Exit;
  //运行时不允许修改
  if not Assigned(FNowReader) then Exit;
  //节点已无效

  if Sender = EditType then
  begin
    if EditType.ItemIndex < 0 then
    begin
      EditType.SetFocus; Exit;
    end;

    FNowReader.FType := TReaderType(EditType.ItemIndex);
  end else

  if Sender = EditSerial then
  begin
    EditSerial.Text := Trim(EditSerial.Text);
    if EditSerial.Text = '' then
    begin
      EditSerial.SetFocus; Exit;
    end;

    FNowReader.FID := EditSerial.Text;
  end else

  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then
    begin
      EditName.SetFocus; Exit;
    end;

    FNowReader.FName := EditName.Text;
    RefreshReaders;
  end else

  if Sender = EditGroup then
  begin
    if not IsNumber(EditGroup.Text, False) then
    begin
      EditGroup.SetFocus; Exit;
    end;

    FNowReader.FGroup := StrToInt(EditGroup.Text);
  end else

  if Sender = EditAddr then
  begin
    if not IsNumber(EditAddr.Text, False) then
    begin
      EditAddr.SetFocus; Exit;
    end;

    FNowReader.FAddrNo := StrToInt(EditAddr.Text);
  end;
end;

//------------------------------------------------------------------------------
//Desc: 依据运行状态设置组件
procedure TfFormMain.CtrlStatus(const nRun: Boolean);
begin
  BtnRun.Enabled := not nRun;
  BtnStop.Enabled := nRun;
  GroupNet.Enabled := not nRun;

  BtnAdd.Enabled := not nRun;
  BtnDel.Enabled := not nRun;
  GroupReader.Enabled := not nRun;
end;

//Desc: 启动
procedure TfFormMain.BtnRunClick(Sender: TObject);
var nStr: string;
begin
  if BtnRun.Enabled then
  begin
    if FDM.Readers.Count < 1 then
    begin
      wPage.ActivePage := SheetReader;
      ShowMsg('请添加读头', sHint); Exit;
    end;

    if FDM.StartService(nStr) then
         CtrlStatus(True)
    else ShowMsg(nStr, sHint);
  end;
end;

//Desc: 停止
procedure TfFormMain.BtnStopClick(Sender: TObject);
begin
  FDM.StopService;
  CtrlStatus(False);
end;

end.
