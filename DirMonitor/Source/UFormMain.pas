{*******************************************************************************
  作者: dmzn@163.com 2023-03-19
  描述: 监测排产和打印网络是否正常
*******************************************************************************}
unit UFormMain;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Vcl.Forms, Winapi.Messages,
  Winapi.Windows, UThreadPool, Vcl.Imaging.GIFImg, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, Vcl.Controls, cxImageList,
  Vcl.Menus, Vcl.StdCtrls, cxLabel, Vcl.ComCtrls;

type
  TfFormMain = class(TForm)
    SBar1: TStatusBar;
    wPage1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TrayIcon1: TTrayIcon;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    Group1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    EditFilter: TEdit;
    cxImageList1: TcxImageList;
    Image1: TImage;
    LabelHint: TcxLabel;
    GroupBox1: TGroupBox;
    CheckAutoStart: TCheckBox;
    CheckAutoMin: TCheckBox;
    TimerDelay: TTimer;
    EditDir: TButtonedEdit;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    EditDest: TButtonedEdit;
    CheckAddID: TCheckBox;
    N2: TMenuItem;
    MenuStart: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure TimerDelayTimer(Sender: TObject);
    procedure EditDestRightButtonClick(Sender: TObject);
    procedure EditDirRightButtonClick(Sender: TObject);
    procedure MenuStartClick(Sender: TObject);
  private
    { Private declarations }
    FCanExit: Boolean;
    {*关闭标记*}
    FMonDir: string;
    FMonFilter: string;
    FMonDest: string;
    FMonAddID: Boolean;
    FMonDate: string;
    {*监控参数*}
    FMonitorID: Cardinal;
    FMonitor: TThreadWorkerConfig;
    procedure DoMonitInit(const nConfig: PThreadWorkerConfig;
      const nThread: TThread);
    procedure DoMonit(const nConfig: PThreadWorkerConfig;
      const nThread: TThread);
    procedure DoMonitFree(const nConfig: PThreadWorkerConfig;
      const nThread: TThread);
    {*目录监控*}
    procedure WMSysCommand(var nMsg: TMessage);message WM_SYSCOMMAND;
    {*消息处理*}
    procedure DoFormConfig(const nLoad: Boolean);
    {*界面配置*}
    procedure ShowHint(const nHint: string);
    {*提示信息*}
    procedure CopyFiles(const nFiles: TStrings; const nDest: string);
    {*复制文件*}
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  System.IniFiles, System.Win.Registry, FileCtrl, ShlObj, ActiveX, ShellApi,
  IdTCPClient, ULibFun, UManagerGroup;

resourcestring
  sStart = '服务已启动';
  sStop  = '服务已停止';

procedure WriteLog(const nEvent: string);
begin
  gMG.FLogManager.AddLog(TfFormMain, 'DirMonitor', nEvent);
end;

procedure TfFormMain.FormCreate(Sender: TObject);
var nStr: string;
    nGif: TGIFImage;
begin
  FCanExit := False;
  wPage1.ActivePageIndex := 0;
  gMG.FLogManager.StartService();

  FMonitorID := 0;
  gMG.FThreadPool.WorkerInit(FMonitor);

  with FMonitor do
  begin
    FWorkerName := '目录状态监控';
    FCallInterval := 0;
    FAutoDelete := False;

    FOnInit.WorkEvent := DoMonitInit;
    FOnWork.WorkEvent := DoMonit;
    FOnFree.WorkEvent := DoMonitFree;
  end;

  ShowHint(sStop);
  DoFormConfig(True);
  //load config

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

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not FCanExit then
  begin
    Action := caNone;
    Visible := False;
    Exit;
  end;

  FCanExit := True;
  //for debug

  gMG.FThreadPool.WorkerDelete(Self);
  gMG.FThreadPool.WorkerDelete(FMonitorID);
  //clear threads

  Action := caFree;
  DoFormConfig(False);
end;

procedure TfFormMain.MenuStartClick(Sender: TObject);
begin
  if FMonitorID < 1 then
  begin
    if not System.SysUtils.DirectoryExists(EditDir.Text) then
    begin
      TApplicationHelper.ShowDlg('监控目录不存在', '提示', Handle);
      Exit;
    end;

    if not System.SysUtils.DirectoryExists(EditDest.Text) then
    begin
      TApplicationHelper.ShowDlg('存储目录不存在', '提示', Handle);
      Exit;
    end;

    FMonDir := TApplicationHelper.RegularPath(EditDir.Text);
    FMonDest := TApplicationHelper.RegularPath(EditDest.Text);
    FMonFilter := EditFilter.Text;
    FMonAddID := CheckAddID.Checked;

    FMonitor.FDataInt[0] := 0;
    FMonitorID := gMG.FThreadPool.WorkerAdd(@FMonitor);
    //投递监控

    ShowHint('');
    MenuStart.Caption := '停止服务';
    MenuStart.ImageIndex := 3;
  end else
  begin
    FMonitor.FDataInt[0] := 10;
    //set stop flag
    gMG.FThreadPool.WorkerDelete(FMonitorID);
    //停止监控
    FMonitorID := 0;

    ShowHint(sStop);
    MenuStart.ImageIndex := 2;
    MenuStart.Caption := '启动服务';
  end;
end;

procedure TfFormMain.N1Click(Sender: TObject);
begin
  FCanExit := True;
  Close();
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
  MenuStartClick(nil);
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
  cAutoVal = 'Fihe_DirMonitor';
var nIni: TIniFile;
    nReg: TRegistry;
begin
  nIni := TIniFile.Create(TApplicationHelper.gFormConfig);
  with nIni do
  try
    if nLoad then
    begin
      CheckAutoMin.Checked := ReadBool(cConfig, 'AutoMin', False);
      if CheckAutoMin.Checked then
        TimerDelay.Enabled := True;
      //xxxxx

      EditDir.Text := ReadString(cConfig, 'MonDir', '');
      EditFilter.Text := ReadString(cConfig, 'MonFilter', 'Image*.jpg');
      EditDest.Text := ReadString(cConfig, 'MonDest', '');
      CheckAddID.Checked := ReadBool(cConfig, 'FileAddID', True);
    end else
    begin
      if EditDir.Modified then
        WriteString(cConfig, 'MonDir', EditDir.Text);
      //xxxxx

      if EditFilter.Modified then
        WriteString(cConfig, 'MonFilter', EditFilter.Text);
      //xxxxx

      if EditDest.Modified then
        WriteString(cConfig, 'MonDest', EditDest.Text);
      //xxxxx

      WriteBool(cConfig, 'FileAddID', CheckAddID.Checked);
      WriteBool(cConfig, 'AutoMin', CheckAutoMin.Checked);
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
function SelectDirCB(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
begin
  if (uMsg = BFFM_INITIALIZED) and (lpData <> 0) then
    SendMessage(Wnd, BFFM_SETSELECTION, Integer(True), lpdata);
  result := 0;
end;

function SelectDirectoryB(const ACaption: string; var ADirectory: string): Boolean;
var
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
begin
  Result := False;
  if not System.SysUtils.DirectoryExists(ADirectory) then
    ADirectory := '';
  //判断默认选择目录是否存在，不存在时置为空

  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  //填充BrowseInfo结构体
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
  begin
    //分配IMalloc大小为路径最大大小
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      with BrowseInfo do
      begin
        hwndOwner := Application.Handle;
        pidlRoot := nil;
        pszDisplayName := Buffer;
        //设置标题
        lpszTitle := PChar(ACaption);
        //设置标识
        ulFlags := BIF_RETURNONLYFSDIRS or BIF_NEWDIALOGSTYLE;
        //设置默认选择目录（通过回调函数SelectDirCB处理）
        if ADirectory <> '' then
        begin
          lpfn := SelectDirCB;
          lParam := Integer(PChar(ADirectory));
        end;
      end;

      ItemIDList := ShBrowseForFolder(BrowseInfo);
      //获取选择的路径
      Result := ItemIDList <> nil;
      if Result then
      begin
        ShGetPathFromIDList(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        ADirectory := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;

procedure TfFormMain.EditDestRightButtonClick(Sender: TObject);
var nStr: string;
begin
  nStr := EditDest.Text;
  if SelectDirectoryB('存储到', nStr) then
  begin
    EditDest.Text := nStr;
    EditDest.Modified := True;
  end;
end;

procedure TfFormMain.EditDirRightButtonClick(Sender: TObject);
var nStr: string;
begin
  nStr := EditDir.Text;
  if SelectDirectoryB('监控目标', nStr) then
  begin
    EditDir.Text := nStr;
    EditDir.Modified := True;
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

procedure TfFormMain.DoMonitInit(const nConfig: PThreadWorkerConfig;
  const nThread: TThread);
begin

end;

procedure TfFormMain.DoMonitFree(const nConfig: PThreadWorkerConfig;
  const nThread: TThread);
begin

end;

function FileTimeToStr(const nFT: TFileTime): string;
var nLocal: TFileTime;
    nSys: TSystemTime;
begin
  FileTimeToLocalFileTime(nFT, nLocal);
  FileTimeToSystemTime(nLocal, nSys);
  Result := TDateTimeHelper.DateTime2Str(SystemTimeToDateTime(nSys));

  Result := StringReplace(Result, ':', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' ', '_', [rfReplaceAll]);
  //date _ time
end;

procedure TfFormMain.DoMonit(const nConfig: PThreadWorkerConfig;
  const nThread: TThread);
var nStr: string;
    nHwnd: THandle;
    nWait: DWORD;
    nSr: TSearchRec;
    nRes: Integer;
    nFiles: TStrings;
begin
  if FMonitor.FDataInt[0] = 10 then Exit;
  //has stop flag

  nHwnd := FindFirstChangeNotification(PChar(FMonDir), LongBool(1),
    FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_DIR_NAME);
    //FILE_NOTIFY_CHANGE_LAST_WRITE or FILE_NOTIFY_CHANGE_CREATION);
  //start monit

  while True do
  try
    if FCanExit or TThreadRunner(nThread).Terminated or
       (FMonitor.FDataInt[0] = 10) then Break;
    //程序退出,线程结束,服务停止

    nWait := WaitForSingleObject(nHwnd, 500);
    if nWait <> WAIT_OBJECT_0 then Continue;
    FindNextChangeNotification(nHwnd);

    nFiles := nil;
    try
      nRes := FindFirst(FMonDir + FMonFilter, faAnyFile, nSr);
      while nRes = 0 do
      begin
        if not Assigned(nFiles) then
          nFiles := TStringList.Create;
        //xxxxx

        nFiles.AddPair(FMonDir + nSr.Name,
          FileTimeToStr(nSr.FindData.ftCreationTime));
        //file, create_time
        nRes := FindNext(nSr);
      end;

      System.SysUtils.FindClose(nSr);
      //close handle

      if Assigned(nFiles) then
      begin
        FMonDate := TDateTimeHelper.Date2Str(Now());
        nStr := FMonDest + FMonDate + '\';

        if not System.SysUtils.DirectoryExists(nStr) then
          System.SysUtils.ForceDirectories(nStr);
        //new dir

        if System.SysUtils.DirectoryExists(nStr) then
             CopyFiles(nFiles, nStr) //do copy
        else WriteLog('无法创建目录: ' + nStr);
      end;
    finally
      nFiles.Free;
    end;
  except
    on nErr: Exception do
    begin
      WriteLog(nErr.Message);
    end;
  end;

  FindCloseChangeNotification(nHwnd);
  //close handle
end;

procedure MakeFileID(const nDate: string; var nID: Integer);
const
  cConfig = 'FileID';
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(TApplicationHelper.gFormConfig);
  try
    if nID < 1 then //read
    begin
      nID := nIni.ReadInteger(cConfig, nDate, 1);
      if nID < 1 then
        nID := 1;
      //limit value
    end else //write
    begin
      nIni.WriteInteger(cConfig, nDate, nID);
    end;
  finally
    nIni.Free;
  end;
end;

procedure TfFormMain.CopyFiles(const nFiles: TStrings; const nDest: string);
var nStr: string;
    nIdx,nID: Integer;
    nAction: TShFileOpStruct;
begin
  nID := 0;
  if FMonAddID then
    MakeFileID(FMonDate, nID);
  //xxxxx

  for nIdx := nFiles.Count -1 downto 0 do
  begin
    if nID > 0 then
    begin
      nStr := IntToStr(nID);
      nStr := StringOfChar('0', 3 - Length(nStr)) + nStr;
      nStr := nDest + nFiles.ValueFromIndex[nIdx] + '_' + nStr;

      Inc(nID);
    end else
    begin
      nStr := nDest + nFiles.ValueFromIndex[nIdx];
    end;

    nStr := nStr + ExtractFileExt(nFiles.Names[nIdx]);
    //full filename
    FillChar(nAction, SizeOf(nAction), #0);

    with nAction do
    begin
      Wnd := Handle;
      wFunc := FO_MOVE;
      pFrom := PChar(nFiles.Names[nIdx] + #0);
      pTo := PChar(nStr + #0);
      fFlags := FOF_NOCONFIRMATION or FOF_RENAMEONCOLLISION or
                FOF_NOERRORUI or FOF_SILENT;
      //不出现确认文件替换对话框
      //有重复文件时自动重命名
      //不出现错误对话框
      //产生正在复制的对话框
    end;

    ShFileOperation(nAction);
    //执行移动
  end;

  if nID > 0 then
    MakeFileID(FMonDate, nID);
  //write last
end;

end.
