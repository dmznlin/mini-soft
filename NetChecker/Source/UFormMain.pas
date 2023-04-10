{*******************************************************************************
  作者: dmzn@163.com 2023-03-19
  描述: 监测排产和打印网络是否正常
*******************************************************************************}
unit UFormMain;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Vcl.Forms, Winapi.Messages,
  Winapi.Windows, UThreadPool, Vcl.Imaging.GIFImg, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList, Vcl.Controls, cxImageList, cxGraphics,
  Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, cxLabel;

const
  cScanThreadNumber = 20;
  //扫描线程上线

type
  TfFormMain = class(TForm)
    SBar1: TStatusBar;
    wPage1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Group2: TGroupBox;
    Label1: TLabel;
    EditLPort: TEdit;
    Label2: TLabel;
    EditLName: TEdit;
    TrayIcon1: TTrayIcon;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    TabSheet3: TTabSheet;
    Group1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    EditRPort: TEdit;
    EditRHost: TEdit;
    Group3: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    EditScanPort: TEdit;
    EditScanS: TEdit;
    EditScanE: TEdit;
    Label7: TLabel;
    BtnScanStart: TButton;
    ListScan: TListView;
    cxImageList1: TcxImageList;
    Image1: TImage;
    LabelHint: TcxLabel;
    GroupBox1: TGroupBox;
    CheckAutoStart: TCheckBox;
    CheckAutoMin: TCheckBox;
    TimerDelay: TTimer;
    CheckFirewall: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure BtnScanStartClick(Sender: TObject);
    procedure EditRHostChange(Sender: TObject);
    procedure TimerDelayTimer(Sender: TObject);
  private
    { Private declarations }
    FCanExit: Boolean;
    {*关闭标记*}
    FScanPort: Integer;
    FScanStart,FScanEnd,FScanNow: Int64;
    FScanThread,FActiveHost: Integer;
    FScanWorker: TThreadWorkerConfig;
    {*IP扫描*}
    FProcessID: THandle;
    FRemoteHost,FLocalName: string;
    FRemotePort,FLocalPort: Integer;
    FNetCheckerID: Cardinal;
    FNetChecker: TThreadWorkerConfig;
    {*网络守护*}
    procedure WMSysCommand(var nMsg: TMessage);message WM_SYSCOMMAND;
    {*消息处理*}
    procedure DoFormConfig(const nLoad: Boolean);
    {*界面配置*}
    procedure DoScanInit(const nConfig: PThreadWorkerConfig;
      const nThread: TThread);
    procedure DoScanHost(const nConfig: PThreadWorkerConfig;
      const nThread: TThread);
    procedure DoScanFree(const nConfig: PThreadWorkerConfig;
      const nThread: TThread);
    {*扫描主机*}
    procedure ApplyNetCheckParams;
    procedure DoNetCheck(const nConfig: PThreadWorkerConfig;
      const nThread: TThread);
    {*检查网络*}
    procedure ShowHint(const nHint: string);
    {*提示信息*}
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  System.IniFiles, System.Win.Registry, Winapi.TLHelp32, Winapi.ShellAPI,
  IdTCPClient, ULibFun, UManagerGroup;

procedure WriteLog(const nEvent: string);
begin
  gMG.FLogManager.AddLog(TfFormMain, 'NetChecker', nEvent);
end;

procedure TfFormMain.FormCreate(Sender: TObject);
var nStr: string;
    nGif: TGIFImage;
begin
  FCanExit := False;
  wPage1.ActivePageIndex := 0;
  gMG.FLogManager.StartService();

  gMG.FThreadPool.WorkerInit(FScanWorker);
  with FScanWorker do
  begin
    FWorkerName := '远程主机扫描';
    FParentObj := Self;
    FParentDesc := 'Net Checker';
    FCallInterval := 0;
    FAutoDelete := True;

    FOnInit.WorkEvent := DoScanInit;
    FOnWork.WorkEvent := DoScanHost;
    FOnFree.WorkEvent := DoScanFree;
  end;

  gMG.FThreadPool.WorkerInit(FNetChecker);
  with FNetChecker do
  begin
    FWorkerName := '网络状态监控';
    FCallInterval := 3000;
    FAutoDelete := False;

    FOnInit.WorkEvent := DoScanInit;
    FOnWork.WorkEvent := DoNetCheck;
    FOnFree.WorkEvent := DoScanFree;
  end;

  ShowHint('');
  DoFormConfig(True);
  FNetCheckerID := gMG.FThreadPool.WorkerAdd(@FNetChecker);
  //投递监控

  nGif := nil;
  nStr := TApplicationHelper.gPath + 'animate.gif';
  if FileExists(nStr) then
  try
    nGif := TGIFImage.Create;
    nGif.LoadFromFile(nStr);
    nGif.Animate := True;
    Image1.Picture.Assign(nGif);
  finally
    nGif.Free;
  end;
end;

procedure TfFormMain.N1Click(Sender: TObject);
begin
  FCanExit := True;
  Close();
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not FCanExit then
  begin
    Action := caNone;
    Visible := False;
    Exit;
  end;

  gMG.FThreadPool.WorkerDelete(Self);
  gMG.FThreadPool.WorkerDelete(FNetCheckerID);
  //clear threads

  Action := caFree;
  DoFormConfig(False);
end;

procedure TfFormMain.WMSysCommand(var nMsg: TMessage);
begin
  if nMsg.WParam = SC_ICON then
       Visible := False
  else DefWindowProc(Handle, nMsg.Msg, nMsg.WParam, nMsg.LParam);
end;

procedure TfFormMain.TimerDelayTimer(Sender: TObject);
begin
  TimerDelay.Enabled := False;
  Hide();
end;

procedure TfFormMain.TrayIcon1DblClick(Sender: TObject);
begin
  if not Visible then
    Visible := True;
  //xxxxx
end;

procedure TfFormMain.DoFormConfig(const nLoad: Boolean);
const
  cConfig = 'Config';
  cAutoKey = 'Software\Microsoft\Windows\CurrentVersion\Run';
  cAutoVal = 'Fihe_NetChecker';
  cFirewall = '/c Firewall.bat "%s" "%s" "%s"';
var nStr: string;
    nIni: TIniFile;
    nReg: TRegistry;
begin
  nIni := TIniFile.Create(TApplicationHelper.gFormConfig);
  with nIni do
  try
    if nLoad then
    begin
      EditRHost.Text := ReadString(cConfig, 'RemoteHost', '127.0.0.1');
      EditRPort.Text := ReadString(cConfig, 'RemotePort', '33196');
      EditLName.Text := ReadString(cConfig, 'ExeName', 'EES.Client.exe');
      EditLPort.Text := ReadString(cConfig, 'LocalPort', '33196');

      EditScanS.Text := ReadString(cConfig, 'ScanStart', '127.0.0.1');
      EditScanE.Text := ReadString(cConfig, 'ScanEnd', '127.0.0.1');
      EditScanPort.Text := ReadString(cConfig, 'ScanPort', '33196');

      CheckAutoMin.Checked := ReadBool(cConfig, 'AutoMin', False);
      if CheckAutoMin.Checked then
        TimerDelay.Enabled := True;
      //xxxxx

      CheckFirewall.Checked := ReadBool(cConfig, 'AutoFirewall', True);
      if CheckFirewall.Checked then
      begin
        nStr := Format(cFirewall, ['Feihe_NetChecker', 'check network for feihei',
          Application.ExeName]);
        ShellExecute(GetDesktopWindow(), 'open', 'cmd.exe', PChar(nStr),
          PChar(TApplicationHelper.gPath), SW_HIDE);
      end;
      //check firewall

      ApplyNetCheckParams;
      //enable settings
    end else
    begin
      if EditScanS.Modified then
        WriteString(cConfig, 'ScanStart', EditScanS.Text);
      //xxxxx

      if EditScanE.Modified then
        WriteString(cConfig, 'ScanEnd', EditScanE.Text);
      //xxxxx

      if EditScanPort.Modified then
        WriteString(cConfig, 'ScanPort', EditScanPort.Text);
      //xxxxx

      if EditRHost.Modified then
        WriteString(cConfig, 'RemoteHost', EditRHost.Text);
      //xxxxx

      if EditRPort.Modified then
        WriteString(cConfig, 'RemotePort', EditRPort.Text);
      //xxxxx

      if EditLName.Modified then
        WriteString(cConfig, 'ExeName', EditLName.Text);
      //xxxxx

      if EditLPort.Modified then
        WriteString(cConfig, 'LocalPort', EditLPort.Text);
      //xxxxx

      WriteBool(cConfig, 'AutoMin', CheckAutoMin.Checked);
      WriteBool(cConfig, 'AutoFirewall', CheckFirewall.Checked);
      //other config
    end;
  finally
    nIni.Free;
  end;

  nReg := TRegistry.Create;
  try
    nReg.RootKey := HKEY_CURRENT_USER;
    if nLoad then
    begin
      if nReg.OpenKey(cAutoKey, False) then
        CheckAutoStart.Checked := nReg.ValueExists(cAutoVal);
      //xxxxx
    end else
    begin
      if nReg.OpenKey(cAutoKey, True) then
       if CheckAutoStart.Checked then
       begin
         if not nReg.ValueExists(cAutoVal) then
           nReg.WriteString(cAutoVal, Application.ExeName);
         //xxxxx
       end else
       begin
         if nReg.ValueExists(cAutoVal) then
           nReg.DeleteValue(cAutoVal);
         //xxxxx
       end;
    end;
  finally
    nReg.Free;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2023-03-19
//Parm: ip
//Desc: ip转数值
function IP2Int(const nIP: string): Int64;
var nIdx: Integer;
    nList: TStrings;
    nVal,nInt: Int64;
begin
  Result := 0;
  nList := TStringList.Create;
  try
    TStringHelper.Split(nIP, nList, '.');
    if nList.Count <> 4 then Exit;
    nVal := 0;

    for nIdx := 0 to nList.Count-1 do
    begin
      if not TStringHelper.IsNumber(nList[nIdx], False) then Exit;
      //invalid number

      nInt := StrToInt64(nList[nIdx]);
      if (nInt < 0) or (nInt > 255) then Exit;
      //invalid value

      nVal := nVal + nInt shl (24 - nIdx * 8);
    end;

    Result := nVal;
  finally
    nList.Free;
  end;
end;

//Date: 2023-03-19
//Parm: ip数值
//Desc: 将nVal转为ip字符串
function Int2IP(nVal: Int64): string;
var nInt: Int64;
    nIdx: Integer;
begin
  Result := '';
  for nIdx := 0 to 3 do
  begin
    nInt := nVal shr (24 - nIdx * 8);
    nVal := nVal xor (nInt shl (24 - nIdx * 8));

    if Result = '' then
         Result := IntToStr(nInt)
    else Result := Result + '.' + IntToStr(nInt);
  end;
end;

//Desc: 开启扫描
procedure TfFormMain.BtnScanStartClick(Sender: TObject);
var nInt: Int64;
begin
  if not TStringHelper.IsNumber(EditScanPort.Text, False) then
  begin
    TApplicationHelper.ShowDlg('请输入有效端口(1-65535)', '', Handle);
    Exit;
  end;

  FScanPort := StrToInt(EditScanPort.Text);
  if (FScanPort < 1) or (FScanPort > 65535) then
  begin
    TApplicationHelper.ShowDlg('请输入有效端口(1-65535)', '', Handle);
    Exit;
  end;

  FScanStart := IP2Int(EditScanS.Text);
  FScanEnd := IP2Int(EditScanE.Text);

  if (FScanStart < 1) or (FScanEnd < 1) then
  begin
    TApplicationHelper.ShowDlg('请输入有效的IP地址', '', Handle);
    Exit;
  end;

  nInt := FScanEnd - FScanStart + 1;
  //ip numbers
  if nInt < 0 then
  begin
    TApplicationHelper.ShowDlg('结束IP应大于开始IP', '', Handle);
    Exit;
  end;

  ListScan.Items.BeginUpdate;
  try
    ListScan.Items.Clear;
    FScanNow := FScanStart;

    while FScanNow <= FScanEnd do
    begin
      with ListScan.Items.Add do
      begin
        Caption := Int2IP(FScanNow);
        SubItems.Add('待扫描');
        ImageIndex := 0;
      end;

      FScanNow := FScanNow + 1;
    end;
  finally
    ListScan.Items.EndUpdate;
  end;

  BtnScanStart.Enabled := False;
  gMG.FThreadPool.WorkerDelete(Self);
  //clear first

  FScanNow := FScanStart;
  FScanThread := 0;
  FActiveHost := 0;

  if nInt > 20 then
       nInt := 20; //限制最大线程数
  gMG.FThreadPool.ThreadMin := nInt;

  while nInt > 0 do
  begin
    Dec(nInt);
    gMG.FThreadPool.WorkerAdd(@FScanWorker);
    //投递线程
  end;
end;

procedure TfFormMain.DoScanInit(const nConfig: PThreadWorkerConfig;
  const nThread: TThread);
begin
  Inc(FScanThread);
  nConfig.FDataObj[0] := TIdTCPClient.Create(nil);
  with TIdTCPClient(nConfig.FDataObj[0]) do
  begin
    ConnectTimeout := 3000;
    ReadTimeout := 3000;
  end;
end;

procedure TfFormMain.DoScanFree(const nConfig: PThreadWorkerConfig;
  const nThread: TThread);
begin
  if Assigned(nConfig.FDataObj[0]) then
    FreeAndNil(nConfig.FDataObj[0]);
  Dec(FScanThread);
end;

procedure TfFormMain.DoScanHost(const nConfig: PThreadWorkerConfig;
  const nThread: TThread);
var nIP: string;
    nClient: TIdTCPClient;

    //Desc: 更新界面状态
    procedure SyncIPStatus(const nState: string; isOver: Boolean);
    begin
      TThread.Synchronize(nThread,
        procedure
        var nIdx: Integer;
        begin
          for nIdx := ListScan.Items.Count-1 downto 0 do
            if ListScan.Items[nIdx].Caption = nIP then
            begin
              ListScan.Items[nIdx].SubItems[0] := nState;

              if isOver then
              begin
                if nState = '在线' then
                     ListScan.Items[nIdx].ImageIndex := 1
                else ListScan.Items[nIdx].ImageIndex := 2;

                ListScan.Items[nIdx].MakeVisible(True);
              end;

              Break;
            end;

          if (FScanNow > FScanEnd) and isOver then //scan over
          begin
            SBar1.SimpleText := '';
            BtnScanStart.Enabled := True;
            ListScan.Items.BeginUpdate;
            try
              for nIdx := ListScan.Items.Count-1 downto 0 do
                if ListScan.Items[nIdx].ImageIndex <> 1 then
                  ListScan.Items.Delete(nIdx);
              //clear offline
            finally
              ListScan.Items.EndUpdate;
            end;

            if ListScan.Items.Count < 1 then
              with ListScan.Items.Add do
              begin
                Caption := '未扫描到在线主机';
                ImageIndex := 2;
              end;
          end else
          begin
            SBar1.SimpleText := Format('※.线程:[%d] 在线:[%d] 进度:[%d/%d]', [
              FScanThread, FActiveHost, FScanNow-FScanStart,FScanEnd-FScanStart+1]);
          end;
        end);
      //update status
    end;
begin
  gMG.FObjectPool.SyncEnter;
  try
    if FScanNow > FScanEnd then //已扫描完毕
    begin
      nConfig.FCallTimes := 0; //set over flag
      Exit;
    end;

    nIP := Int2IP(FScanNow);
    Inc(FScanNow);
  finally
    gMG.FObjectPool.SyncLeave;
  end;

  SyncIPStatus('扫描..', False);
  nClient := nConfig.FDataObj[0] as TIdTCPClient;
  nClient.Disconnect;

  with nClient do
  try
    Host := nIP;
    Port := FScanPort;
    Connect;

    Inc(FActiveHost);
    SyncIPStatus('在线', True);
  except
    on nErr: Exception do
    begin
      SyncIPStatus('不在线', True);
      WriteLog(Format('Host:%s, Err:%s', [nIP, nErr.Message]));
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormMain.ShowHint(const nHint: string);
begin
  if nHint = '' then
  begin
    LabelHint.Visible := False;
    Exit;
  end;

  with LabelHint do
  begin
    Visible := True;
    Caption := nHint;
    Left := Trunc((TabSheet1.Width - Width) / 2);
    Top := Trunc((TabSheet1.Height - Height) / 2);
  end;
end;

procedure TfFormMain.EditRHostChange(Sender: TObject);
begin
  if TWinControl(Sender).Focused then
    ApplyNetCheckParams();
  //xxxxx
end;

procedure TfFormMain.ApplyNetCheckParams;
begin
  if IP2Int(EditRHost.Text) > 0 then
    FRemoteHost := EditRHost.Text;
  //xxxxx

  if TStringHelper.IsNumber(EditRPort.Text, False) then
    FRemotePort := StrToInt(EditRPort.Text);
  //xxxxx

  EditLName.Text := Trim(EditLName.Text);
  if EditLName.Text <> '' then
    FLocalName := EditLName.Text;
  //xxxxx

  if TStringHelper.IsNumber(EditLPort.Text, False) then
    FLocalPort := StrToInt(EditLPort.Text);
  //xxxxx
end;

var
  gWindowName: string;                   //待监测窗体类名称
  gWindowHandle: THandle;                //待监测窗体句柄
  gControlName: string;                  //待监测控件类名称
  gControlHandle: THandle;               //待监测控件句柄
  gControlText: string;                  //待监测控件关键字

//Date: 2018-01-12
//Parm: 程序名称
//Desc: 获取nExeName的进程标识
function GetFixProcessID(const nExeName: string): THandle;
var nStr: string;
    nSnapshotHandle: THandle;
    nProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  nSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    nProcessEntry32.dwSize := Sizeof(nProcessEntry32);
    if Process32First(nSnapshotHandle, nProcessEntry32) then
    repeat
      nStr := ExtractFileName(nProcessEntry32.szExeFile);
      //file name

      if CompareText(nStr, nExeName) = 0 then
      begin
        Result := nProcessEntry32.th32ProcessID;
        Break;
      end;
    until not Process32Next(nSnapshotHandle, nProcessEntry32);
  finally
    CloseHandle(nSnapshotHandle);
  end;
end;

//Desc: 检索窗体回调
function EnumThreadWndProc(AHWnd: HWnd; ALPARAM: LPARAM): Boolean; stdcall;
var nWndClassName: array[0..254] of Char;
begin
  GetClassName(AHWnd, @nWndClassName, 254);
  if nWndClassName = gWindowName then
    gWindowHandle := AHWnd; //win-handle
  Result := True;
end;

//Date: 2018-01-12
//Parm: 进程句柄;窗体类名
//Desc: 获取nProcess的指定窗体标识
function GetFixWindowID(const nProcess: THandle; const nForm: string): THandle;
var nSnapshotHandle: THandle;
    nThreadEntry: TThreadEntry32;
begin
  Result := 0;
  nSnapshotHandle := CreateToolHelp32Snapshot(TH32CS_SNAPTHREAD, nProcess);
  try
    nThreadEntry.dwSize := sizeOf(nThreadEntry);
    if Thread32First(nSnapshotHandle, nThreadEntry) then
    repeat
      if nThreadEntry.th32OwnerProcessID = nProcess then
      begin
        gWindowHandle := 0;
        gWindowName := nForm;

        EnumThreadWindows(nThreadEntry.th32ThreadID, @EnumThreadWndProc, 0);
        Result := gWindowHandle;
        Break;
      end;
    until not Thread32Next(nSnapshotHandle, nThreadEntry);
  finally
    CloseHandle(nSnapshotHandle);
  end;
end;

//Date: 2018-01-12
//Parm: 控件句柄
//Desc: 获取控件的文本内容
function GetControlText(const nHwnd: HWnd): string;
var nBuf: array[0..254] of Char;
begin
  if SendMessage(nHwnd, WM_GETTEXT, 255, Integer(@nBuf[0])) > 0 then
       Result := PChar(@nBuf[0])
  else Result := '';
end;

//Desc: 检索控件回调
function EnumChildWndProc(AHWnd: HWnd; ALPARAM: LPARAM): Boolean; stdcall;
var nWndClassName: array[0..254] of Char;
begin
  GetClassName(AHWnd, @nWndClassName, 254);
  if nWndClassName = gControlName then
    if Pos(gControlText, UpperCase(GetControlText(AHWnd))) > 0 then
      gControlHandle := AHWnd; //get control
  Result := True;
end;

//Date: 2018-01-12
//Parm: 窗体句柄;控件名;关键字
//Desc: 获取nWindow上的指定控件
function GetFixControlID(const nWindow: THandle; const nName: string): THandle;
begin
  gControlHandle := 0;
  gControlName := nName;

  EnumChildWindows(nWindow, @EnumChildWndProc, 0);
  Result := gControlHandle;
end;

procedure TfFormMain.DoNetCheck(const nConfig: PThreadWorkerConfig;
  const nThread: TThread);
var nHwnd: THandle;
    nClient: TIdTCPClient;

    //Desc: 更新界面状态
    procedure SyncNetStatus(const nState: string; nShowForm: Boolean);
    begin
      TThread.Synchronize(nThread,
        procedure
        begin
          ShowHint(nState);
          if nShowForm and (not Visible) then
          begin
            Visible := True;
            wPage1.ActivePageIndex := 0;
          end;
        end);
    end;
begin
  if (FRemotePort < 1) and (FLocalPort < 1) then Exit;
  //invalid config

  nHwnd := GetFixProcessID(FLocalName);
  if FProcessID <> nHwnd then
  begin
    FProcessID := nHwnd;
    if nHwnd = 0 then
      SyncNetStatus('', False);
    //xxxxx
  end;

  if FProcessID = 0 then Exit;
  //no find exe

  nClient := nConfig.FDataObj[0] as TIdTCPClient;
  with nClient do
  try
    Disconnect;
    Host := '127.0.0.1';
    Port := FLocalPort;
    Connect;
  except
    on nErr: Exception do
    begin
      SyncNetStatus('本地:离线', True);
      Exit;
    end;
  end;

  with nClient do
  try
    Disconnect;
    Host := FRemoteHost;
    Port := FRemotePort;

    Connect;
    Disconnect;
    SyncNetStatus('服务:正常', False);
  except
    on nErr: Exception do
    begin
      SyncNetStatus('远程:离线', True);
      //WriteLog(Format('Host:%s, Err:%s', [Host, nErr.Message]));
    end;
  end;
end;

end.
