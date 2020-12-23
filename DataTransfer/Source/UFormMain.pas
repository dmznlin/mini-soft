{*******************************************************************************
  作者: dmzn@163.com 2020-12-06
  描述: PLC数据转发存储服务
*******************************************************************************}
unit UFormMain;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTrayIcon, ImgList, ExtCtrls, ComCtrls, Buttons, StdCtrls, Menus;

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
    ListStations: TListView;
    ImageList2: TImageList;
    ParamPage: TPageControl;
    SheetBase: TTabSheet;
    GroupBox2: TGroupBox;
    BtnRun: TButton;
    BtnStop: TButton;
    GroupBox1: TGroupBox;
    CheckAutoRun: TCheckBox;
    CheckAutoMin: TCheckBox;
    SheetConn: TTabSheet;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    Label11: TLabel;
    EditPwd: TEdit;
    Panel1: TPanel;
    Bevel1: TBevel;
    Check1: TCheckBox;
    BtnClear: TButton;
    BtnCopy: TButton;
    EditConn: TMemo;
    Panel2: TPanel;
    Button1: TButton;
    BtnTest: TButton;
    Label1: TLabel;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    EditPort: TEdit;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure BtnRunClick(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure BtnCopyClick(Sender: TObject);
    procedure Check1Click(Sender: TObject);
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
    procedure LoadStationList(const nLoadFile: Boolean);
    //载入站点
    procedure ShowLog(const nStr: string);
    //显示日志
    function IsValidParam: Boolean;
    //验证参数
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses
  IniFiles, Registry, ULibFun, USysLoger, USysConst, UAdjustForm, UDataModule,
  UFormInputbox, UBase64, UProtocol;

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TfFormMain, '服务主模块', nEvent);
end;

//------------------------------------------------------------------------------
//Desc: 从nID指定的小节读取nList的配置信息
procedure LoadListViewConfig(const nID: string; const nListView: TListView; const nIni: TIniFile = nil);
var
  nTmp: TIniFile;
  nList: TStrings;
  i, nCount: integer;
begin
  nTmp := nil;
  nList := TStringList.Create;
  try
    if Assigned(nIni) then
      nTmp := nIni
    else
      nTmp := TIniFile.Create(gPath + sFormConfig);

    nList.Text := StringReplace(nTmp.ReadString(nID, nListView.Name + '_Cols', ''), ';', #13, [rfReplaceAll]);
    if nList.Count <> nListView.Columns.Count then
      Exit;

    nCount := nListView.Columns.Count - 1;
    for i := 0 to nCount do
      if IsNumber(nList[i], False) then
        nListView.Columns[i].Width := StrToInt(nList[i]);
    //xxxxx
  finally
    nList.Free;
    if not Assigned(nIni) then
      FreeAndNil(nTmp);
  end;
end;

//Desc: 将nList的信息存入nID指定的小节
procedure SaveListViewConfig(const nID: string; const nListView: TListView; const nIni: TIniFile = nil);
var
  nStr: string;
  nTmp: TIniFile;
  i, nCount: integer;
begin
  nTmp := nil;
  try
    if Assigned(nIni) then
      nTmp := nIni
    else
      nTmp := TIniFile.Create(gPath + sFormConfig);

    nStr := '';
    nCount := nListView.Columns.Count - 1;

    for i := 0 to nCount do
    begin
      nStr := nStr + IntToStr(nListView.Columns[i].Width);
      if i <> nCount then
        nStr := nStr + ';';
    end;

    nTmp.WriteString(nID, nListView.Name + '_Cols', nStr);
  finally
    if not Assigned(nIni) then
      FreeAndNil(nTmp);
  end;
end;

//Desc: 初始化窗体
procedure TfFormMain.InitFormData;
begin
  wPage.ActivePage := SheetSetup;
  ParamPage.ActivePage := SheetBase;

  LoadListViewConfig(Name, ListStations);
  LoadFormConfig(Self);
end;

procedure TfFormMain.FormCreate(Sender: TObject);
var
  nStr: string;
begin
  Randomize;
  ShortDateFormat := 'YYYY-MM-DD';
  gPath := ExtractFilePath(Application.ExeName);

  gSysLoger := TSysLoger.Create(gPath + 'Logs\');
  gSysLoger.LogEvent := ShowLog;

  with gSysParam do
  begin
    FAppTitle := 'DataTransfer';
    FMainTitle := FAppTitle;
  end;

  Application.Title := gSysParam.FAppTitle;
  InitGlobalVariant(gPath, gPath + sConfigFile, gPath + sFormConfig, gPath + sDBConfig);

  nStr := GetFileVersionStr(Application.ExeName);
  if nStr <> '' then
  begin
    nStr := Copy(nStr, 1, Pos('.', nStr) - 1);
    Caption := gSysParam.FMainTitle + ' V' + nStr;
  end
  else
    Caption := gSysParam.FMainTitle;

  FTrayIcon := TTrayIcon.Create(Self);
  FTrayIcon.Hint := HintLabel.Caption;
  FTrayIcon.Visible := True;
  //系统托盘

  InitFormData;
  //初始化
  DoParamConfig(True);
  //载入参数
  LoadStationList(True);
  //载入站点列表
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {$IFNDEF debug}
  if not QueryDlg(sCloseQuery, sHint) then
  begin
    Action := caNone;
    Exit;
  end;
  {$ENDIF}

  if BtnStop.Enabled then
  begin
    Action := caNone;
    ShowMsg('请先停止服务', sHint);
    Exit;
  end;
  //stop service

  SaveListViewConfig(Name, ListStations);
  SaveFormConfig(Self);
  DoParamConfig(False);
end;

//------------------------------------------------------------------------------
//Desc: 显示调试记录
procedure TfFormMain.ShowLog(const nStr: string);
var
  nIdx: Integer;
begin
  MemoLog.Lines.BeginUpdate;
  try
    MemoLog.Lines.Insert(0, nStr);
    if MemoLog.Lines.Count > 100 then
      for nIdx := MemoLog.Lines.Count - 1 downto 50 do
        MemoLog.Lines.Delete(nIdx);
  finally
    MemoLog.Lines.EndUpdate;
  end;
end;

procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  SBar.Panels[0].Text := FormatDateTime('日期:【yyyy-mm-dd】', Now);
  SBar.Panels[1].Text := FormatDateTime('时间:【hh:mm:ss】', Now);

  Timer1.Tag := Timer1.Tag + 1;
  if Timer1.Tag < 3600 then Exit;
  Timer1.Tag := 0; //counter

  if IsSystemExpire(gPath + 'Lock.ini') then
  begin
    FDM.StopService();
    CtrlStatus(False);
    WriteLog('system component: main-service has expired.');
  end;
end;

procedure TfFormMain.BtnCopyClick(Sender: TObject);
begin
  MemoLog.CopyToClipboard;
  ShowMsg('已复制到粘贴板', sHint);
end;

procedure TfFormMain.Check1Click(Sender: TObject);
begin
  //gSysLoger.LogEvent := ShowLog;
  gSysLoger.LogSync := Check1.Checked;
end;

//Desc: 参数配置的读取与保存
procedure TfFormMain.DoParamConfig(const nRead: Boolean);
const nProgID = 'DTServer';
var nIni: TIniFile;
    nReg: TRegistry;
begin
  nIni := TIniFile.Create(gPath + sConfigFile);
  nReg := TRegistry.Create;

  with nIni do
  try
    nReg.RootKey := HKEY_CURRENT_USER;
    nReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    //registry

    if nRead then
    begin
      CheckAutoRun.Checked := nReg.ValueExists(nProgID);
      CheckAutoMin.Checked := ReadBool('Setup', 'AutoMin', False);

      EditPort.Text := ReadString('Setup', 'UDPPort', '8080');
      EditPwd.Text := DecodeBase64(ReadString('Setup', 'AdminPwd', ''));

      EditConn.Text := DecodeBase64(ReadString('Setup', 'DBConn', ''));
      EditConn.Modified := False;
      
      if CheckAutoMin.Checked then
      begin
        BtnRun.Click;
        if BtnStop.Enabled then
        begin
          WindowState := wsMinimized;
          FTrayIcon.Minimize;
        end;
      end;
    end
    else
    begin
      WriteBool('Setup', 'AutoMin', CheckAutoMin.Checked);
      WriteString('Setup', 'AdminPwd', EncodeBase64(EditPwd.Text));
      WriteString('Setup', 'UDPPort', EditPort.Text);

      if EditConn.Modified then
        WriteString('Setup', 'DBConn', EncodeBase64(EditConn.Text));
      //xxxxx

      if CheckAutoRun.Checked then
        nReg.WriteString(nProgID, Application.ExeName)
      else if nReg.ValueExists(nProgID) then
        nReg.DeleteValue(nProgID);
      //xxxxx
    end;
  finally
    nReg.Free;
    nIni.Free;
  end;
end;

//Date: 2020-12-18
//Parm: 是否加载文件
//Desc: 载入站点列表
procedure TfFormMain.LoadStationList(const nLoadFile: Boolean);
var nIdx: Integer;
    nItem: TListItem;
    nStation: PStationItem;
begin
  if nLoadFile then
    FDM.LoadStation(gPath + sStations);
  //xxxxx

  FDM.LockEnter;
  try
    ListStations.Items.BeginUpdate;
    ListStations.Items.Clear;

    for nIdx:=0 to FDM.Stations.Count - 1 do
    begin
      nStation := FDM.Stations[nIdx];
      nItem := ListStations.Items.Add;

      with nItem do
      begin
        Caption := nStation.FID;
        SubItems.Add(nStation.FName);
        SubItems.Add(nStation.FInnerID);
        SubItems.Add(IntToStr(nStation.FCommitAll));
        SubItems.Add(nStation.FLastUpdate);

        nStation.FListItem := nItem;
      end;
    end;
  finally
    FDM.LockLeave;
    ListStations.Items.EndUpdate;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 依据运行状态设置组件
procedure TfFormMain.CtrlStatus(const nRun: Boolean);
var
  i: Integer;
  nList: TList;
begin
  nList := TList.Create;
  try
    EnumSubCtrlList(ParamPage, nList);
    for i := nList.Count - 1 downto 0 do
      if TObject(nList[i]) is TEdit then
        TEdit(nList[i]).Enabled := not nRun
      else if TObject(nList[i]) is TButton then
        TButton(nList[i]).Enabled := not nRun
      else if TObject(nList[i]) is TCheckBox then
        TCheckBox(nList[i]).Enabled := not nRun
      else if TObject(nList[i]) is TMemo then
        TMemo(nList[i]).Enabled := not nRun;
    //normal
  finally
    nList.Free;
  end;

  BtnRun.Enabled := not nRun;
  BtnStop.Enabled := nRun;
end;

//Desc: 验证参数是否有效
function TfFormMain.IsValidParam: Boolean;
var nCtrl: TWinControl;
begin
  Result := False;
  nCtrl := nil;
  try
    nCtrl := EditConn;
    EditConn.Text := Trim(EditConn.Text);
    Result := EditConn.Text <> '';

    nCtrl := EditPort;
    Result := IsNumber(EditPort.Text, False);
  finally
    if not Result then
    begin
      ParamPage.ActivePage := SheetConn;
      ActiveControl := nCtrl;
    end;
  end;
end;

//Desc: 启动服务
procedure TfFormMain.BtnRunClick(Sender: TObject);
var nParam: TServiceParam;
begin
  if not IsValidParam then
  begin
    ShowMsg('请填写正确的参数', sHint);
    Exit;
  end;

  nParam.FSrvPort := StrToInt(EditPort.Text);
  nParam.FDBConn := EditConn.Text;
  if FDM.StartService(nParam) then
       CtrlStatus(True)
  else ShowMsg('无法启动服务,请查阅日志', sHint);
end;

//Desc: 停止采集
procedure TfFormMain.BtnStopClick(Sender: TObject);
var
  nStr: string;
begin
  if EditPwd.Text <> '' then
  begin
    if not ShowInputPWDBox('请输入管理密码:', '停止服务', nStr) then
      Exit;
    if nStr <> EditPwd.Text then
    begin
      ShowMsg('密码错误', sHint);
      Exit;
    end;
  end;

  FDM.StopService;
  CtrlStatus(False);
end;

procedure TfFormMain.BtnTestClick(Sender: TObject);
begin
  with FDM.ADOConn1 do
  try
    Connected := False;
    ConnectionString := EditConn.Text;
    Connected := True;

    Connected := False;
    ShowMsg('数据库配置成功', sHint);
  except
    on nErr: Exception do
    begin
      Connected := False;
      ShowDlg(nErr.Message, '测试失败');
    end;
  end; 
end;

end.

