{*******************************************************************************
  ����: dmzn@163.com 2019-05-24
  ����: ����WebSocket-MQTT�Ĵ�������ת����
*******************************************************************************}
unit UFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Controls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.Graphics, System.Classes, ComPort,
  UHotKeyManager;

type
  TfFormMain = class(TForm)
    HintPanel: TPanel;
    Image1: TImage;
    Image2: TImage;
    HintLabel: TLabel;
    wPage1: TPageControl;
    Sheet1: TTabSheet;
    MemoLog: TMemo;
    Panel1: TPanel;
    CheckDetail: TCheckBox;
    CheckShowLog: TCheckBox;
    Sheet2: TTabSheet;
    Group2: TGroupBox;
    EditHotKey1: TLabeledEdit;
    Group1: TGroupBox;
    CheckRun: TCheckBox;
    CheckMin: TCheckBox;
    EditPwd: TLabeledEdit;
    Sheet3: TTabSheet;
    Panel2: TPanel;
    ListTunnels: TListBox;
    Splitter1: TSplitter;
    Panel3: TPanel;
    StatusBar1: TStatusBar;
    GroupBox1: TGroupBox;
    GroupBox3: TGroupBox;
    EditTPort: TLabeledEdit;
    EditTRate: TLabeledEdit;
    EditTData: TLabeledEdit;
    EditTStop: TLabeledEdit;
    EditTParity: TLabeledEdit;
    EditTControl: TLabeledEdit;
    Panel5: TPanel;
    BtnTSave: TBitBtn;
    Panel4: TPanel;
    BtnTAdd: TBitBtn;
    BtnTDel: TBitBtn;
    Label1: TLabel;
    EditTName: TLabeledEdit;
    EditTIn: TLabeledEdit;
    EditTOut: TLabeledEdit;
    BtnPortCfg: TBitBtn;
    BtnFreshMem: TBitBtn;
    GroupBox2: TGroupBox;
    EditSrvIP: TLabeledEdit;
    EditSrvPort: TLabeledEdit;
    EditSrvUser: TLabeledEdit;
    EditSrvPwd: TLabeledEdit;
    CheckService: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure BtnPortCfgClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnFreshMemClick(Sender: TObject);
    procedure BtnTAddClick(Sender: TObject);
    procedure BtnTDelClick(Sender: TObject);
    procedure ListTunnelsClick(Sender: TObject);
    procedure BtnTSaveClick(Sender: TObject);
    procedure wPage1Change(Sender: TObject);
    procedure CheckRunClick(Sender: TObject);
    procedure CheckShowLogClick(Sender: TObject);
  private
    { Private declarations }
    FLastLogin: Cardinal;
    //����¼ʱ��
    FHotKeyHide: Cardinal;
    FHotKeyManager: THotKeyManager;
    //ȫ���ȼ�
    procedure OnHotKey(HotKey: Cardinal; Index: Word);
    //�ȼ�����
    procedure ShowLog(const nStr: string);
    //��ʾ��־
    procedure LoadTunnelList(const nKeepPos: Boolean = True);
    //����ͨ��
  public
    { Public declarations }
    procedure WMSysCommand(var nMsg: TWMSysCommand); message WM_SYSCOMMAND;
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  UManagerGroup, ULibFun, USysConst;

procedure WriteLog(const nEvent: string);
begin
  gMG.FLogManager.AddLog(TfFormMain, 'Hub Main', nEvent);
end;

procedure TfFormMain.FormCreate(Sender: TObject);
begin
  InitSystemEnvironment;
  FLastLogin := 0;
  wPage1.ActivePageIndex := 0;

  FHotKeyManager := THotKeyManager.Create(Application);
  FHotKeyManager.OnHotKeyPressed := OnHotKey;
  //�ȼ�������

  SysParameter(True);
  with gSysParam do
  begin
    CheckRun.Checked := FAutoRun;
    CheckMin.Checked := FMinAfterRun;
    EditPwd.Text := FAdminPassword;
    EditHotKey1.Text := FHotKey;

    EditSrvIP.Text := FServerIP;
    EditSrvPort.Text := IntToStr(FServerPort);
    EditSrvUser.Text := FServerUser;
    EditSrvPwd.Text := FServerPwd;

    FHotKeyHide := TextToHotKey(FHotKey, False);
    FHotKeyManager.AddHotKey(FHotKeyHide);
  end;

  TunnelConfig(True);
  LoadTunnelList;
  //����ͨ��

  with TApplicationHelper do
  begin
    gPath := USysConst.gPath;
    gFormConfig := gPath + sConfigFile;
    LoadFormConfig(Self);
  end;

  with gMG.FLogManager do
  begin
    SyncSimple := ShowLog;
    StartService(gPath + 'Logs\');
  end;
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if gSysParam.FChanged then
    SysParameter(False);
  TApplicationHelper.SaveFormConfig(Self);
end;

//Desc: ˢ���ڴ�
procedure TfFormMain.BtnFreshMemClick(Sender: TObject);
begin
  gMG.GetManagersStatus(MemoLog.Lines);
end;

//Desc: ҳ���л�
procedure TfFormMain.wPage1Change(Sender: TObject);
var nStr: string;
begin
  if (TDateTimeHelper.GetTickCountDiff(FLastLogin) > 60 * 1000) and (
     (wPage1.ActivePage = Sheet2) or (wPage1.ActivePage = Sheet3)) then
  begin
    nStr := InputBox('swtich', 'Please input admin''s password:', '');
    if nStr = gSysParam.FAdminPassword then
         FLastLogin := GetTickCount()
    else wPage1.ActivePage := Sheet1
  end;
end;

//Desc: ��ʾ��־
procedure TfFormMain.ShowLog(const nStr: string);
var nIdx: Integer;
begin
  MemoLog.Lines.BeginUpdate;
  try
    MemoLog.Lines.Insert(0, nStr);
    if MemoLog.Lines.Count > 100 then
     for nIdx:=MemoLog.Lines.Count - 1 downto 50 do
      MemoLog.Lines.Delete(nIdx);
  finally
    MemoLog.Lines.EndUpdate;
  end;
end;

//Desc: Ӧ�ñ��
procedure TfFormMain.CheckRunClick(Sender: TObject);
begin
  if not TWinControl(Sender).Focused then Exit;
  with gSysParam do
  begin
    FChanged       := True;
    FAutoRun       := CheckRun.Checked;
    FMinAfterRun   := CheckMin.Checked;
    FAdminPassword := EditPwd.Text;
    FHotKey        := EditHotKey1.Text;

    FServerIP      := EditSrvIP.Text;
    FServerPort    := StrToInt(EditSrvPort.Text);
    FServerUser    := EditSrvUser.Text;
    FServerPwd     := EditSrvPwd.Text;
  end;
end;

procedure TfFormMain.CheckShowLogClick(Sender: TObject);
begin
  gMG.FLogManager.SyncMainUI := CheckShowLog.Checked;
end;

procedure TfFormMain.OnHotKey(HotKey: Cardinal; Index: Word);
var nStr: string;
    nThread: Thandle;
begin
  if HotKey = FHotKeyHide then //��ʾ����
  begin
    nStr := InputBox('swtich', 'Please input admin''s password:', '');
    if nStr = gSysParam.FAdminPassword then
    begin
      Visible := not Visible;
      Application.ProcessMessages;

      if Visible then //�����
      begin
        ShowWindow(Handle, SW_NORMAL);
        nThread := GetWindowThreadProcessId(GetForegroundWindow(), nil);

        if AttachThreadInput(GetCurrentThreadId, nThread, True) then
        begin
          SetForegroundWindow(Handle);
          AttachThreadInput(GetCurrentThreadId, nThread, False);
        end else SetForegroundWindow(Handle);
      end;
    end;
  end;
end;

//Desc: ��С������
procedure TfFormMain.WMSysCommand(var nMsg: TWMSysCommand);
begin
  if nMsg.CmdType = SC_MINIMIZE then
  begin
    Visible := False;
  end;

  inherited;
end;

//------------------------------------------------------------------------------
//Desc: ˢ���б�
procedure TfFormMain.LoadTunnelList(const nKeepPos: Boolean);
var nIdx,nLast: Integer;
begin
  ListTunnels.Items.BeginUpdate;
  try
    nLast := ListTunnels.ItemIndex;
    ListTunnels.Clear;

    for nIdx := Low(gTunnels) to High(gTunnels) do
     if gTunnels[nIdx].FEnabled then
      ListTunnels.Items.AddObject(gTunnels[nIdx].FName, Pointer(nIdx));
    //xxxxx
  finally
    ListTunnels.Items.EndUpdate;
  end;

  if nKeepPos then
  begin
    if nLast >= ListTunnels.Items.Count - 1 then
      nLast := ListTunnels.Items.Count - 1;
    //xxxxx
  end else
  begin
    nLast := ListTunnels.Items.Count - 1;
  end;

  ListTunnels.ItemIndex := nLast;
  if nKeepPos then
       ListTunnelsClick(nil)
  else ListTunnelsClick(ListTunnels);
end;

//Desc: ���ͨ��
procedure TfFormMain.BtnTAddClick(Sender: TObject);
var nIdx: Integer;
begin
  nIdx := Length(gTunnels);
  SetLength(gTunnels, nIdx + 1);

  with gTunnels[nIdx] do
  begin
    FEnabled        := True;
    FSaveFile       := False;
    
    FName           := '��ͨ��';
    FPortName       := 'COM1';
    FBaudRate       := br9600;
    FDataBits       := db8;
    FParity         := paNone;
    FStopBits       := sb1;
    FDTRControl     := dcDefault;
    FRTSControl     := rcDefault;
    FXOnXOffControl := xcDefault;
  end;

  LoadTunnelList(False);
end;

//Desc: ɾ��ͨ��
procedure TfFormMain.BtnTDelClick(Sender: TObject);
var nIdx: Integer;
begin
  nIdx := ListTunnels.ItemIndex;
  if nIdx < 0 then Exit;  
  nIdx := Integer(ListTunnels.Items.Objects[nIdx]);
   
  gTunnels[nIdx].FEnabled := False;
  LoadTunnelList;
  TunnelConfig(False);
end;

//Desc: ��ʾѡ��
procedure TfFormMain.ListTunnelsClick(Sender: TObject);
var nIdx: Integer;
begin
  nIdx := ListTunnels.ItemIndex;
  if nIdx < 0 then Exit;
  nIdx := Integer(ListTunnels.Items.Objects[nIdx]);

  if Assigned(Sender) then
    gSetupParam := gTunnels[nIdx];
  //����������

  with gSetupParam,TStringHelper do
  begin
    EditTName.Text    := FName;
    EditTIn.Text      := FMQIn;
    EditTOut.Text     := FMQOut;
    EditTPort.Text    := FPortName;
    EditTRate.Text    := Enum2Str(FBaudRate);
    EditTStop.Text    := Enum2Str(FStopBits);
    EditTData.Text    := Enum2Str(FDataBits);
    EditTParity.Text  := Enum2Str(FParity);

    EditTControl.Text := Enum2Str(FDTRControl) + ', ' +
                         Enum2Str(FRTSControl) + ', ' + Enum2Str(FXOnXOffControl);
    //xxxxx
  end;
end;

//Desc: ���ڲ�������
procedure TfFormMain.BtnPortCfgClick(Sender: TObject);
var nPort: TComPort;
begin
  if ListTunnels.ItemIndex < 0 then Exit;
  EditTPort.Text := UpperCase(Trim(EditTPort.Text));

  if Pos('COM', EditTPort.Text) <> 1 then
  begin
    ShowMessage('�˿ں���Ч');
    Exit;
  end;

  gSetupParam.FPortName := EditTPort.Text;
  nPort := TComPort.Create(Self);             
  ApplyConfig(nPort, True);
  
  with nPort do
  begin
    if ConfigDialog then
    begin
      ApplyConfig(nPort, False);
      ListTunnelsClick(nil);
    end;
    
    Free;
  end;
end;

//Desc: ����ͨ��
procedure TfFormMain.BtnTSaveClick(Sender: TObject);
var nIdx: Integer;
begin
  nIdx := ListTunnels.ItemIndex;
  if nIdx < 0 then Exit;
  nIdx := Integer(ListTunnels.Items.Objects[nIdx]);
  
  EditTPort.Text := UpperCase(Trim(EditTPort.Text));
  if Pos('COM', EditTPort.Text) <> 1 then
  begin
    ShowMessage('�˿ں���Ч');
    Exit;
  end;

  with gSetupParam do
  begin
    FSaveFile       := True;
    FName           := EditTName.Text;
    FMQIn           := EditTIn.Text;
    FMQOut          := EditTOut.Text;
    FPortName       := EditTPort.Text;
  end;

  gTunnels[nIdx] := gSetupParam;
  //������Ч
  TunnelConfig(False);

  LoadTunnelList;
  ShowMessage('�������');
end;

end.
