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
  UThreadPool, UHotKeyManager, sgcWebSocket_Protocol_MQTT_Message,
  sgcWebSocket_Types, sgcWebSocket_Classes, sgcWebSocket_Protocol_Base_Client,
  sgcWebSocket_Protocol_MQTT_Client, sgcWebSocket_Protocols,
  sgcWebSocket_Classes_Indy, sgcWebSocket_Client, sgcWebSocket;

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
    MQTT1: TsgcWSPClient_MQTT;
    WSClient1: TsgcWebSocketClient;
    EditHeat: TLabeledEdit;
    EditReconn: TLabeledEdit;
    Timer1: TTimer;
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
    procedure MQTT1MQTTConnect(Connection: TsgcWSConnection;
      const Session: Boolean; const ReturnCode: TmqttConnReturnCode);
    procedure MQTT1MQTTDisconnect(Connection: TsgcWSConnection);
    procedure WSClient1Exception(Connection: TsgcWSConnection; E: Exception);
    procedure CheckServiceClick(Sender: TObject);
    procedure MQTT1MQTTSubscribe(Connection: TsgcWSConnection;
      aPacketIdentifier: Word; aCodes: TsgcWSSUBACKS);
    procedure MQTT1MQTTPublish(Connection: TsgcWSConnection; aTopic,
      aText: string);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckDetailClick(Sender: TObject);
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
    procedure ActiveService(const nActive: Boolean);
    //��ͣ����
    procedure DoSubscribe(const nConfig: PThreadWorkerConfig;
      const nThread: TThread);
    procedure AddSubscribeWorker;
    //�Զ���������
    procedure OnComPortRxChar(Sender: TObject);
    //�������ݴ���
  public
    { Public declarations }
    procedure WMSysCommand(var nMsg: TWMSysCommand); message WM_SYSCOMMAND;
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  UManagerGroup, UWaitItem, ULibFun, USysConst;

procedure WriteLog(const nEvent: string);
begin
  gMG.FLogManager.AddLog(TfFormMain, '', nEvent);
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
    CheckRun.Checked  := FAutoRun;
    CheckMin.Checked  := FMinAfterRun;
    EditPwd.Text      := FAdminPassword;
    EditHotKey1.Text  := FHotKey;

    EditSrvIP.Text    := FServerIP;
    EditSrvPort.Text  := IntToStr(FServerPort);
    EditSrvUser.Text  := FServerUser;
    EditSrvPwd.Text   := FServerPwd;
    EditHeat.Text     := IntToStr(FHeatBeat);
    EditReconn.Text   := IntToStr(FReconnect);

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

  AddSubscribeWorker();
  //��������

  CheckShowLog.Checked := not gSysParam.FMinAfterRun;
  if gSysParam.FMinAfterRun then
  begin
    Application.ShowMainForm := False;
    Timer1.Enabled := True;
  end;

  gSysStatus.FApplicationRunning := True;
  //run flag
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  gSysStatus.FApplicationRunning := False;
  gSysStatus.FShowDetailLog := False;
  gMG.RunBeforApplicationHalt;
  //close flag

  ActiveService(False);
  //ֹͣ����

  if gSysParam.FChanged then
    SysParameter(False);
  TApplicationHelper.SaveFormConfig(Self);
end;

//Desc: ��ʱ��������
procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  CheckService.Checked := True;
end;

//Desc: ˢ���ڴ�
procedure TfFormMain.BtnFreshMemClick(Sender: TObject);
begin
  MemoLog.Lines.Clear;
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
var nInt: Integer;
begin
  if not TWinControl(Sender).Focused then Exit;
  nInt := StrToInt(EditReconn.Text);
  if nInt < 1 then EditReconn.Text := '3';
  if nInt > 60 then EditReconn.Text := '60';

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
    FHeatBeat      := StrToInt(EditHeat.Text);
    FReconnect     := StrToInt(EditReconn.Text);
  end;
end;

//Desc: ��ʾ��־
procedure TfFormMain.CheckShowLogClick(Sender: TObject);
begin
  gMG.FLogManager.SyncMainUI := CheckShowLog.Checked;
  gSysStatus.FShowDetailLog := CheckShowLog.Checked and CheckDetail.Checked;
end;

//Desc: ��ʾ��ϸ
procedure TfFormMain.CheckDetailClick(Sender: TObject);
begin
  gSysStatus.FShowDetailLog := CheckShowLog.Checked and CheckDetail.Checked;
end;

//Desc: ��Ӧ�ȼ�
procedure TfFormMain.OnHotKey(HotKey: Cardinal; Index: Word);
var nStr: string;
    nThread: Thandle;
begin
  if HotKey = FHotKeyHide then //��ʾ����
  begin
    if Visible then
    begin
      Visible := False;
      Exit;
    end;

    nStr := InputBox('swtich', 'Please input admin''s password:', '');
    if nStr = gSysParam.FAdminPassword then
    begin
      FLastLogin := GetTickCount();
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

//------------------------------------------------------------------------------
//Date: 2019-05-28
//Parm: ��ͣ��ʶ
//Desc: ��ͣת������
procedure TfFormMain.ActiveService(const nActive: Boolean);
var nIdx: Integer;
begin
  gSysStatus.FMQTTConnected := False;
  gSysStatus.FTopicsSubscribed := False;
  //init flag

  while COMEventCounter(True, -1) > 0 do
    Sleep(10);
  //�ȴ����ڴ������

  Sheet2.Enabled := not nActive;
  Sheet3.Enabled := not nActive;
  //����������
    
  for nIdx := Low(gTunnels) to High(gTunnels) do
  with gTunnels[nIdx] do
  begin
    if not FEnabled then Continue;
    //invalid

    if not Assigned(FCOMPort) then
    begin
      FCOMPort := TComPort.Create(Self);
      with FCOMPort do
      begin
        Tag := nIdx;
        SynchronizeEvents := False;
        OnRxChar := OnComPortRxChar;

        Timeouts.ReadConstant := 200;
        Timeouts.ReadMultiplier := 100;
        //Timeouts.WriteConstant := 200;
        //Timeouts.WriteMultiplier := 100;
      end;
    end;

    if nActive then
    begin
      ApplyConfig(FCOMPort, True, nIdx);
      FCOMPort.Active := True;
    end else
    begin
      FCOMPort.Active := False;
      //close comport    
    end;
  end;
    
  gMG.FThreadPool.WorkerStop(Self);
  WSClient1.Active := False;
  if not nActive then Exit;
  //close all first

  with WSClient1 do
  begin
    //Active := False;
    Host := gSysParam.FServerIP;
    Port := gSysParam.FServerPort;

    //WatchDog.Interval := gSysParam.FReconnect;
    WatchDog.Enabled := False;
    //�����Զ�����
  end;

  with MQTT1 do
  begin
    HeartBeat.Interval := gSysParam.FHeatBeat;
    Authentication.Enabled := gSysParam.FServerUser <> '';
    Authentication.UserName := gSysParam.FServerUser;
    Authentication.Password := gSysParam.FServerPwd;
  end;

  MakeTopicList();
  //����������
  gMG.FThreadPool.WorkerStart(Self);
  //��������
end;

//Desc: ��ͣ����
procedure TfFormMain.CheckServiceClick(Sender: TObject);
begin
  ActiveService(CheckService.Checked);
end;

//Desc: ����Զ����������߳�
procedure TfFormMain.AddSubscribeWorker;
var nWorker: TThreadWorkerConfig;
begin
  gMG.FThreadPool.WorkerInit(nWorker);
  with nWorker do
  begin
    FWorkerName   := 'TfFormMain.Subscribe';
    FParentObj    := Self;
    FParentDesc   := 'MQTT Subscribe';
    FCallTimes    := 0; //��ͣ
    FCallInterval := gSysParam.FReconnect * 1000;
    FProcEvent    := DoSubscribe;
  end;

  gMG.FThreadPool.WorkerAdd(@nWorker);
  //����߳���ҵ
end;

//Desc: ��������
procedure TfFormMain.DoSubscribe(const nConfig: PThreadWorkerConfig;
  const nThread: TThread);
var nIdx,nNum: Integer;
begin
  if not gSysStatus.FApplicationRunning then Exit;
  //closeing

  if not WSClient1.Active then //���ӷ���
    WSClient1.Active := True;
  if not gSysStatus.FMQTTConnected then Exit;

  if not gSysStatus.FTopicsSubscribed then //��������
  begin
    nNum := 0;
    gSyncLock.Enter;
    try
      for nIdx := Low(gTopics) to High(gTopics) do
      with gTopics[nIdx],TDateTimeHelper do
      begin
        if FHasSub or (GetTickCountDiff(FLastSub) < 5 * 1000) then Continue;
        Inc(nNum);

        FLastSub := GetTickCount();
        FChannel := MQTT1.Subscribe(FTopic);
      end;
    finally
      gSyncLock.Leave;
    end;

    if nNum < 1 then
      gSysStatus.FTopicsSubscribed := True;
    //xxxxx
  end;
end;

//Desc: �쳣
procedure TfFormMain.WSClient1Exception(Connection: TsgcWSConnection;
  E: Exception);
begin
  WriteLog('MQTT Exception:' + E.Message);
end;

//Desc: ���ӳɹ�
procedure TfFormMain.MQTT1MQTTConnect(Connection: TsgcWSConnection;
  const Session: Boolean; const ReturnCode: TmqttConnReturnCode);
begin
  WriteLog('MQTT Has Connected.');
  gSysStatus.FMQTTConnected := True;
  gMG.FThreadPool.WorkerWakeup(Self);
end;

//Desc: ���ӶϿ�
procedure TfFormMain.MQTT1MQTTDisconnect(Connection: TsgcWSConnection);
begin
  WriteLog('MQTT Has Disconnected.');
  gSysStatus.FMQTTConnected := False;
  gSysStatus.FTopicsSubscribed := False;

  MakeTopicList(True);
  gMG.FThreadPool.WorkerWakeup(Self);
end;

//Desc: ���ĳɹ�
procedure TfFormMain.MQTT1MQTTSubscribe(Connection: TsgcWSConnection;
  aPacketIdentifier: Word; aCodes: TsgcWSSUBACKS);
var nIdx: Integer;
begin
  gSyncLock.Enter;
  try
    for nIdx := Low(gTopics) to High(gTopics) do
     with gTopics[nIdx] do
      if FChannel = aPacketIdentifier then
      begin
        FHasSub := True;
        WriteLog(Format('%s Has Subscribed.', [FTopic]));
      end;
  finally
    gSyncLock.Leave;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��ͨ������ת����ָ������
procedure TfFormMain.MQTT1MQTTPublish(Connection: TsgcWSConnection; aTopic,
  aText: string);
var nStr,nHex: string;
    nIdx: Integer;
begin
  with gSysStatus do
   if not (FApplicationRunning and FMQTTConnected) then Exit;
  //xxxxx
     
  nStr := TEncodeHelper.DecodeBase64(aText); 
  if gSysStatus.FShowDetailLog then
    nHex := TStringHelper.Str2Hex(nStr);
  //xxxxx
  
  for nIdx := Low(gTunnels) to High(gTunnels) do
  with gTunnels[nIdx] do
  begin
    if (not FEnabled) or (FMQIn <> aTopic) then Continue;
    if gSysStatus.FShowDetailLog then
      WriteLog(Format('%s.[ %s -> COM ]: %s', [FName, FMQIn, nHex]));
    //xxxxx

    if gSysStatus.FMQTTConnected then    
      FCOMPort.WriteAnsiString(nStr);
    //send data
  end;
end;

//Desc: ����������ת����ָ��ͨ��
procedure TfFormMain.OnComPortRxChar(Sender: TObject);
var nStr: string;
    nComPort: TComPort;
begin
  with gSysStatus do
   if not (FApplicationRunning and FMQTTConnected) then Exit;
  //xxxxx
  
  COMEventCounter(True);
  try                    
    nComPort := Sender as TComPort;
    nStr := nComPort.ReadAnsiString;
    if nStr = '' then Exit;

    with gTunnels[nComPort.Tag] do
    begin
      if gSysStatus.FShowDetailLog then
        WriteLog(Format('%s.[ COM -> %s ]: %s', [FName,
          FMQOut, TStringHelper.Str2Hex(nStr)]));
      //xxxxx

      if gSysStatus.FMQTTConnected then
        MQTT1.Publish(FMQOut, TEncodeHelper.EncodeBase64(nStr));
      //send data
    end; 
  finally
    COMEventCounter(False);
  end;     
end;

end.
