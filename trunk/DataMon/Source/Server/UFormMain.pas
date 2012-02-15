{*******************************************************************************
  作者: dmzn@163.com 2011-5-11
  描述: 短信服务TC35主单元
*******************************************************************************}
unit UFormMain;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTrayIcon, ImgList, ExtCtrls, ComCtrls, Buttons, StdCtrls,
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
    SheetConn: TTabSheet;
    GroupBox5: TGroupBox;
    EditConn: TEdit;
    Label1: TLabel;
    BtnTest: TButton;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    EditJG: TEdit;
    Label10: TLabel;
    GroupBox4: TGroupBox;
    Label2: TLabel;
    EditPort: TEdit;
    Label3: TLabel;
    EditOMax: TEdit;
    Label4: TLabel;
    EditCMax: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    GroupBox6: TGroupBox;
    Label8: TLabel;
    EditPwd: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure BtnRunClick(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
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
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses
  IniFiles, MMSystem , Registry, ULibFun,  USysConst, UAdjustForm, UDataModule,
  UMgrDBWriter, UFormWait, UFormInputbox, UBase64;

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
    FAppTitle := 'DataMon Server';
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
      CheckAutoRun.Checked := nReg.ValueExists('DMServer');
      CheckAutoMin.Checked := nIni.ReadBool('Setup', 'AutoMin', False);
      EditPwd.Text := DecodeBase64(nIni.ReadString('Setup', 'AdminPwd', ''));

      EditConn.Text := nIni.ReadString('DB', 'Conn', '');
      EditPort.Text := IntToStr(nIni.ReadInteger('Server', 'Port', 8099));
      EditCMax.Text := IntToStr(nIni.ReadInteger('Server', 'ConnMax', 25));
      EditOMax.Text := IntToStr(nIni.ReadInteger('Server', 'ObjMax', 20));
      EditJG.Text := IntToStr(nIni.ReadInteger('Week', 'Interval', 48));

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
      nIni.WriteString('DB', 'Conn', EditConn.Text);

      nIni.WriteString('Server', 'Port', EditPort.Text);
      nIni.WriteString('Server', 'ConnMax', EditCMax.Text);
      nIni.WriteString('Server', 'ObjMax', EditOMax.Text);
      nIni.WriteString('Week', 'Interval', EditJG.Text);
      
      if CheckAutoRun.Checked then
        nReg.WriteString('DMServer', Application.ExeName)
      else if nReg.ValueExists('DMServer') then
        nReg.DeleteValue('DMServer');
      //xxxxx
    end;
  finally
    nReg.Free;
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
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
end;

//Desc: 验证参数是否有效
function TfFormMain.IsValidParam: Boolean;
var nCtrl: TWinControl;
begin
  Result := False;
  nCtrl := nil;
  try
    EditConn.Text := Trim(EditConn.Text);
    Result := EditConn.Text <> '';

    nCtrl := EditConn;
    if not Result then Exit;

    Result := IsNumber(EditJG.Text, False) and (StrToInt(EditJG.Text) >= 1);
    nCtrl := EditJG;
    if not Result then Exit;

    Result := IsNumber(EditPort.Text, False) and
        (StrToInt(EditPort.Text) >= 5000) and (StrToInt(EditPort.Text) <= 50000);
    nCtrl := EditPort;
    if not Result then Exit;

    Result := IsNumber(EditCMax.Text, False) and
        (StrToInt(EditCMax.Text) >= 1) and (StrToInt(EditCMax.Text) <= 50);
    nCtrl := EditCMax;
    if not Result then Exit;

    Result := IsNumber(EditOMax.Text, False) and
        (StrToInt(EditOMax.Text) >= 1) and (StrToInt(EditOMax.Text) <= 20);
    nCtrl := EditOMax;
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
var nParam: TServerParam;
begin
  if not IsValidParam then Exit;

  with nParam do
  begin
    FConnStr := EditConn.Text;
    FConnMax := StrToInt(EditCMax.Text);
    FSvrPort := StrToInt(EditPort.Text);
    FObjMax := StrToInt(EditOMax.Text);
    FWeekInt := StrToInt(EditJG.Text);
  end;

  if FDM.ActiveServer(True, @nParam) then
       CtrlStatus(True)
  else ShowMsg('服务启动失败', sHint);
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

  FDM.ActiveServer(False);
  CtrlStatus(False);
end;

//Desc: 载入当前活动的对象列表
procedure TfFormMain.N1Click(Sender: TObject);
begin
  if Assigned(gDBWriteManager) then
    gDBWriteManager.LoadItems(ListClient);
  //xxxxx
end;

//Desc: 数据连接测试
procedure TfFormMain.BtnTestClick(Sender: TObject);
begin
  with FDM do
  try
    BtnTest.Enabled := False;
    ShowWaitForm(Self, '正在连接');

    LocalConn.Close;
    LocalConn.ConnectionString := EditConn.Text;
    LocalConn.Open;
  except
    //any error
  end;

  CloseWaitForm;
  BtnTest.Enabled := True;
  
  if FDM.LocalConn.Connected then
       ShowMsg('连接数据库成功', sHint)
  else ShowMsg('连接数据库失败', sHint);
end;

end.
