{*******************************************************************************
  作者: dmzn@163.com 2011-5-11
  描述: 短信服务TC35主单元
*******************************************************************************}
unit UFormMain;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTrayIcon, UMgrMCGS, ImgList, ExtCtrls, ComCtrls, Buttons, StdCtrls,
  Menus;

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
    ListClient: TListView;
    ImageList2: TImageList;
    ParamPage: TPageControl;
    SheetBase: TTabSheet;
    GroupBox2: TGroupBox;
    BtnRun: TButton;
    BtnStop: TButton;
    CheckLogs: TCheckBox;
    GroupBox1: TGroupBox;
    CheckAutoRun: TCheckBox;
    CheckAutoMin: TCheckBox;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    SheetConn: TTabSheet;
    GroupBox5: TGroupBox;
    GroupBox7: TGroupBox;
    EditURL: TEdit;
    Label1: TLabel;
    BtnTest: TButton;
    Label2: TLabel;
    EditCH: TEdit;
    Label3: TLabel;
    EditDH: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EditPL: TEdit;
    Label7: TLabel;
    GroupBox3: TGroupBox;
    Label8: TLabel;
    EditSound: TEdit;
    BtnSelect: TButton;
    Label9: TLabel;
    EditJG: TEdit;
    Label10: TLabel;
    BtnNoSound: TButton;
    GroupBox6: TGroupBox;
    Label11: TLabel;
    EditPwd: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure BtnSelectClick(Sender: TObject);
    procedure BtnNoSoundClick(Sender: TObject);
    procedure BtnRunClick(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure EditPLExit(Sender: TObject);
    procedure BtnTestClick(Sender: TObject);
  private
    { Private declarations }
    FTrayIcon: TTrayIcon;
    //状态栏
    procedure InitFormData;
    //初始化
    procedure CtrlStatus(const nRun: Boolean);
    //组件状态
    procedure DoParamConfig(const nRead: Boolean);
    //参数配置
    procedure ShowLog(const nMsg: string; const nMustShow: Boolean = False);
    //显示日志
    function IsValidParam: Boolean;
    //验证参数
    procedure DoItem(const nItem: TMCGSItemData);
    procedure DoDataSync(const nData: TMCGSParamItem);
    //采集器
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses
  IniFiles, MMSystem , Registry, ULibFun,  USysConst, UAdjustForm, UFormWait,
  UDataModule, UFormInputbox, UBase64;

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

  LoadListViewConfig(Name, ListClient);
  LoadFormConfig(Self);
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
    FAppTitle := 'DataMon Client';
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

  SaveListViewConfig(Name, ListClient);
  SaveFormConfig(Self);
  DoParamConfig(False);
end;

//------------------------------------------------------------------------------
//Desc: 显示调试记录
procedure TfFormMain.ShowLog(const nMsg: string; const nMustShow: Boolean);
var nStr: string;
begin
  if CheckLogs.Checked or nMustShow then
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
      CheckAutoRun.Checked := nReg.ValueExists('DMClient');
      CheckAutoMin.Checked := nIni.ReadBool('Setup', 'AutoMin', False);
      EditPwd.Text := DecodeBase64(nIni.ReadString('Setup', 'AdminPwd', ''));

      EditURL.Text := nIni.ReadString('Server', 'URL', '5000');
      EditCH.Text := nIni.ReadString('Data', 'CH', '');
      EditDH.Text := nIni.ReadString('Data', 'DH', '');

      EditPL.Text := IntToStr(nIni.ReadInteger('Data', 'Interval', 5));
      EditJG.Text := IntToStr(nIni.ReadInteger('Warn', 'Interval', 5));
      EditSound.Text := nIni.ReadString('Warn', 'Sound', '');

      if CheckAutoMin.Checked then
      begin
        BtnRun.Click;
        WindowState := wsMinimized;
        FTrayIcon.Minimize;
      end;
    end else
    begin
      nIni.WriteBool('Setup', 'AutoMin', CheckAutoMin.Checked);
      nIni.WriteString('Setup', 'AdminPwd', EncodeBase64(EditPwd.Text));
      
      nIni.WriteString('Server', 'URL', EditURL.Text);
      nIni.WriteString('Data', 'CH', EditCH.Text);
      nIni.WriteString('Data', 'DH', EditDH.Text);

      nIni.WriteString('Data', 'Interval', EditPL.Text);
      nIni.WriteString('Warn', 'Interval', EditJG.Text);
      nIni.WriteString('Warn', 'Sound', EditSound.Text);

      if CheckAutoRun.Checked then
        nReg.WriteString('DMClient', Application.ExeName)
      else if nReg.ValueExists('DMClient') then
        nReg.DeleteValue('DMClient');
      //xxxxx
    end;
  finally
    nReg.Free;
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 校验数据有效性
procedure TfFormMain.EditPLExit(Sender: TObject);
begin
  if Sender = EditPL then
  begin
    if (not IsNumber(EditPL.Text, False)) or (StrToInt(EditPL.Text) < 2) or
       (StrToInt(EditPL.Text) > 60) then
    begin
      ActiveControl := EditPL;
      ShowMsg('请输入有效的频率值', sHint);
    end;
  end else

  if Sender = EditJG then
  begin
    if (not IsNumber(EditJG.Text, False)) or (StrToInt(EditJG.Text) < 5) then
    begin
      ActiveControl := EditJG;
      ShowMsg('请输入有效的报警间隔', sHint);
    end;
  end;
end;

//Desc: 依据运行状态设置组件
procedure TfFormMain.CtrlStatus(const nRun: Boolean);
var i: Integer;
    nList: TList;
begin
  nList := TList.Create;
  try
    EnumSubCtrlList(ParamPage, nList);
    for i:= nList.Count - 1 downto 0 do
     if TObject(nList[i]) is TEdit then
       TEdit(nList[i]).Enabled  := not nRun else
     if TObject(nList[i]) is TButton then
       TButton(nList[i]).Enabled  := not nRun else
     if TObject(nList[i]) is TCheckBox then
       TCheckBox(nList[i]).Enabled := not nRun;
    //normal
  finally
    nList.Free;
  end;  

  BtnRun.Enabled := not nRun;
  BtnStop.Enabled := nRun;
  BtnNoSound.Enabled := True;
end;

//Desc: 选择声音
procedure TfFormMain.BtnSelectClick(Sender: TObject);
begin
  with TOpenDialog.Create(Self) do
  begin
    Title := '选择声音';
    Filter := '声音文件(*.wav)|*.wav';
    InitialDir := ExtractFilePath(EditSound.Text);

    if Execute then
    begin
      EditSound.Text := FileName;
      PlaySound(PChar(FileName), 0, SND_ASYNC or SND_LOOP);
    end;

    Free;
  end;
end;

//Desc: 停止播放
procedure TfFormMain.BtnNoSoundClick(Sender: TObject);
begin
  PlaySound(nil, 0, SND_ASYNC);
end;

//Desc: 验证参数是否有效
function TfFormMain.IsValidParam: Boolean;
var nCtrl: TWinControl;
begin
  Result := False;
  nCtrl := nil;
  try
    EditURL.Text := Trim(EditURL.Text);
    Result := EditURL.Text <> '';

    nCtrl := EditURL;
    if not Result then Exit;

    EditCH.Text := Trim(EditCH.Text);
    Result := EditURL.Text <> '';

    nCtrl := EditCH;
    if not Result then Exit;

    EditDH.Text := Trim(EditDH.Text);
    Result := EditDH.Text <> '';

    nCtrl := EditDH;
    if not Result then Exit;

    Result := IsNumber(EditPL.Text, False) and (StrToInt(EditPL.Text) >= 2) and
              (StrToInt(EditPL.Text) <= 60);
    nCtrl := EditPL;
    if not Result then Exit;

    EditSound.Text := Trim(EditSound.Text);
    Result := (EditSound.Text = '') or FileExists(EditSound.Text);
    
    nCtrl := EditSound;
    if not Result then Exit;
  finally
    if not Result then
    begin
      ParamPage.ActivePage := SheetConn;
      ActiveControl := nCtrl;
    end;
  end;
end;

//Desc: 启动采集
procedure TfFormMain.BtnRunClick(Sender: TObject);
var nStr: string;
    nParam: TRemoteParam;
begin
  if not IsValidParam then Exit;
  with nParam do
  begin
    FURL := EditURL.Text;
    FWarnSound := EditSound.Text;
    FWarnInterval := StrToInt(EditJG.Text);
  end;

  FDM.StartSender(nParam);
  //sender object

  gMCGSManager.OnItem := DoItem;
  gMCGSManager.OnDataSync := DoDataSync;
  gMCGSManager.Interval := StrToInt(EditPL.Text);

  ListClient.Items.Clear;
  gMCGSManager.SetDH(EditCH.Text, EditDH.Text);

  if gMCGSManager.StartReader(nStr) then
       CtrlStatus(True)
  else ShowMsg(nStr, sWarn);
end;

//Desc: 停止采集
procedure TfFormMain.BtnStopClick(Sender: TObject);
var nStr: string;
begin
  if EditPwd.Text <> '' then
  begin
    if not ShowInputPWDBox('请输入管理密码:', '停止服务', nStr) then Exit;
    if nStr <> EditPwd.Text then
    begin
      ShowMsg('密码错误', sHint); Exit;
    end;
  end;
  
  gMCGSManager.StopReader;
  FDM.StopSender;
  CtrlStatus(False);
end;

//Desc: 采集对象
procedure TfFormMain.DoItem(const nItem: TMCGSItemData);
begin
  if csDestroying in ComponentState then Exit;
  //invalid for update

  if nItem.FStatus = UMgrMCGS.isAdd then
  with ListClient.Items.Add do
  begin
    Caption := IntToStr(nItem.FSerial);
    SubItems.Add(nItem.FDH);
    SubItems.Add(nItem.FCH);
    SubItems.Add(DateTime2Str(nItem.FLastUpdate));

    ImageIndex := 0;
  end else

  if nItem.FStatus = UMgrMCGS.isUpdate then
  with ListClient.Items[nItem.FSerial] do
  begin
    ImageIndex := 1;
    SubItems[2] := DateTime2Str(nItem.FLastUpdate);
  end else

  if nItem.FStatus = UMgrMCGS.isNone then
  with ListClient.Items[nItem.FSerial] do
  begin
    ImageIndex := 0;
  end;
end;

//Desc: 采集到数据
procedure TfFormMain.DoDataSync(const nData: TMCGSParamItem);
var nStr: string;
begin
  if CheckLogs.Checked then
  begin
    nStr := 'DH:[ %s ] W1:[ %.2f ] W2:[ %.2f ] W3:[ %.2f ] ' +
            'W4:[ %.2f ] S1:[ %.2f ] S2:[ %.2f ] S3:[ %.2f ] ' +
            'S4:[ %.2f ] MW: [ %.2f ]';
    with nData do
    nStr := Format(nStr, [FDH, Fw1, Fw2, Fw3, Fw4, Fs1, Fs2, Fs3, Fs4, Fmw]);
    ShowLog(nStr);
  end;
end;

procedure TfFormMain.BtnTestClick(Sender: TObject);
var nBool: Boolean;
begin
  ShowWaitForm(Self, '正在连接');
  nBool := FDM.CheckURL(EditURL.Text);
  CloseWaitForm;

  if nBool then
       ShowMsg('地址有效', sHint)
  else ShowMsg('无法连接服务器', sHint);
end;

end.
