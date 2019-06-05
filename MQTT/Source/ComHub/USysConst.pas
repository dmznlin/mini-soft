{*******************************************************************************
  ����: dmzn@163.com 2019-05-21
  ����: ��������
*******************************************************************************}
unit USysConst;

interface

uses
  Winapi.Windows, System.Classes, System.IniFiles, Vcl.Forms, System.SysUtils,
  System.Win.Registry, System.SyncObjs, ComPort, UBaseObject, UManagerGroup,
  ULibFun;

type
  TSysParam = record
    FProgID         : string;                        //�����ʶ
    FAppTitle       : string;                        //�����������ʾ
    FMainTitle      : string;                        //���������
    FHintText       : string;                        //��ʾ�ı�
    FCopyRight      : string;                        //��������ʾ����

    FLocalIP        : string;                        //����IP
    FLocalMAC       : string;                        //����MAC
    FLocalName      : string;                        //��������

    FChanged        : Boolean;                       //�ѱ��
    FAutoRun        : Boolean;                       //������
    FMinAfterRun    : Boolean;                       //��������С��
    FAdminPassword  : string;                        //��������
    FHotKey         : string;                        //ȫ���ȼ�

    FServerIP       : string;
    FServerPort     : Integer;
    FServerUser     : string;
    FServerPwd      : string;                        //MQTT Server
    FHeatBeat       : Integer;                       //����(��)
    FReconnect      : Integer;                       //��������(��)
  end;
  //ϵͳ����

  TSystemStatus = record
    FMQTTConnected      : Boolean;                   //����������
    FMQTTLastPing       : Cardinal;                  //Ping
    FTopicsSubscribed   : Boolean;                   //�����Ѷ���
    FShowDetailLog      : Boolean;                   //��ʾ��־��ϸ
    FApplicationRunning : Boolean;                   //ϵͳ������
    FMainEventCounter   : Integer;                   //��Ҫ�¼�����
    FHotkeyWorking      : Boolean;                   //�ȼ��ѳ���
  end;

  PTunnelItem = ^TTunnelItem;
  TTunnelItem = record
    FName           : string;                        //ͨ������
    FMQIn           : string;                        //�����ʶ(��Ϣ����)
    FMQOut          : string;                        //�����ʶ(��Ϣ����)

    FCOMPort        : TComPort;                      //���ڶ���
    FPortName       : string;                        //�˿�����
    FBaudRate       : TBaudRate;                     //������
    FDataBits       : TDataBits;                     //����λ
    FParity         : TParity;                       //У��λ
    FStopBits       : TStopBits;                     //ֹͣλ
    FDTRControl     : TDTRControl;
    FRTSControl     : TRTSControl;
    FXOnXOffControl : TXOnXOffControl;               //������

    FEnabled        : Boolean;                       //ͨ����Ч
    FSaveFile       : Boolean;                       //�����ļ�
  end;

  TTunnelItems = array of TTunnelItem;
  //ͨ���б�

  TTopicItem = record
    FTopic          : string;                        //��������
    FChannel        : Word;                          //���ı��
    FHasSub         : Boolean;                       //�Ѷ���
    FLastSub        : Cardinal;                      //������
  end;

  TTopicItems = array of TTopicItem;
  //�����б�

var
  gPath: string;                                     //��������·��
  gSysParam: TSysParam;                              //���򻷾�����
  gSysStatus: TSystemStatus;                         //��������״̬
  gSyncLock: TCriticalSection;                       //ȫ��ͬ������

  gTopics: TTopicItems;                              //�����б�
  gTunnels: TTunnelItems;                            //ͨ���б�
  gSetupParam: TTunnelItem;                          //������ͨ������

procedure InitSystemEnvironment;
//��ʼ��ϵͳ���л����ı���
procedure SysParameter(const nLoad: Boolean; const nIni: TIniFile = nil);
//ϵͳ���ò���
procedure TunnelConfig(const nLoad: Boolean);
//��дͨ�������ļ�
procedure ApplyConfig(const nCOMPort: TComPort; const nSet: Boolean = True;
 const nCfg: Integer = -1);
//Ӧ������
procedure MakeTopicList(const nOnlyReset: Boolean = False);
//���������б�
function MainEventCounter(const nInc: Boolean; const nNum: Integer = 1): Integer;
//���������¼�����

ResourceString
  sProgID             = 'ComHub';                    //Ĭ�ϱ�ʶ
  sAppTitle           = 'ComHub';                    //�������
  sMainCaption        = 'ComHub';                    //�����ڱ���

  sHint               = '��ʾ';                      //�Ի������
  sWarn               = '����';                      //==
  sAsk                = 'ѯ��';                      //ѯ�ʶԻ���
  sError              = 'δ֪����';                  //����Ի���

  sLogDir             = 'Logs\';                     //��־Ŀ¼
  sLogExt             = '.log';                      //��־��չ��
  sConfigFile         = 'Config.Ini';                //�������ļ�
  sFormConfig         = 'FormInfo.ini';              //��������

implementation

//Date: 2007-01-09
//Desc: ��ʼ�����л���
procedure InitSystemEnvironment;
begin
  Randomize;
  gPath := ExtractFilePath(Application.ExeName);

  with FormatSettings do
  begin
    DateSeparator := '-';
    ShortDateFormat := 'yyyy-MM-dd';
  end;

  with TObjectStatusHelper do
  begin
    shData := 45;
    shTitle := 90;
  end;

  FillChar(gSysStatus, SizeOf(gSysStatus), #0);
  //init status
end;

//Date: 2007-09-13
//Desc: ����ϵͳ���ò���
procedure SysParameter(const nLoad: Boolean; const nIni: TIniFile);
var nReg: TRegistry;
    nTmp: TIniFile;
begin
  if Assigned(nIni) then
       nTmp := nIni
  else nTmp := TIniFile.Create(gPath + sConfigFile);

  nReg := TRegistry.Create;
  try
    nReg.RootKey := HKEY_CURRENT_USER;
    nReg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', False);

    with gSysParam, nTmp do
    if nLoad then    
    begin
      FillChar(gSysParam, SizeOf(TSysParam), #0);
      FProgID := ReadString('Config', 'ProgID', sProgID);
      //�����ʶ�����������в���

      FLocalMAC := TGUID.NewGuid.ToString;
      //����ο���ʶ

      FAppTitle := ReadString(FProgID, 'AppTitle', sAppTitle);
      FMainTitle := ReadString(FProgID, 'MainTitle', sMainCaption);
      FHintText := ReadString(FProgID, 'HintText', '');
      FCopyRight := ReadString(FProgID, 'CopyRight', '');

      FAutoRun        := nReg.ValueExists('Com_Hub');
      FMinAfterRun    := ReadString(FProgID, 'MinAfterRun', '')  = 'Y';
      FAdminPassword  := ReadString(FProgID, 'AdminPwd', '');
      FHotKey         := ReadString(FProgID, 'HotKey', 'Ctrl + Alt + D');

      FServerIP       := ReadString('MQTT', 'ServerIP', '118.89.157.37');
      FServerPort     := ReadInteger('MQTT', 'ServerPort', 8030);
      FServerUser     := ReadString('MQTT', 'ServerUser', 'admin');
      FServerPwd      := ReadString('MQTT', 'ServerPwd', 'admin');
      FHeatBeat       := ReadInteger('MQTT', 'ServerHeatBeat', 5);
      FReconnect      := ReadInteger('MQTT', 'ServerReConn', 3);
    end else
    begin
      if FAutoRun then
           nReg.WriteString('Com_Hub', Application.ExeName)
      else nReg.DeleteValue('Com_Hub');

      if FMinAfterRun then
           WriteString(FProgID, 'MinAfterRun', 'Y')
      else WriteString(FProgID, 'MinAfterRun', 'N');

      WriteString(FProgID, 'AdminPwd', FAdminPassword);
      WriteString(FProgID, 'HotKey', FHotKey);

      WriteString('MQTT', 'ServerIP', FServerIP);
      WriteInteger('MQTT', 'ServerPort', FServerPort);
      WriteString('MQTT', 'ServerUser', FServerUser);
      WriteString('MQTT', 'ServerPwd', FServerPwd);
      WriteInteger('MQTT', 'ServerHeatBeat', FHeatBeat);
      WriteInteger('MQTT', 'ServerReConn', FReconnect);
    end;
  finally
    gSysParam.FChanged := False;
    nReg.Free;
    if not Assigned(nIni) then nTmp.Free;
  end;
end;

//Date: 2019-05-23
//Parm: �Ƿ�����
//Desc: ��дͨ�����ò���
procedure TunnelConfig(const nLoad: Boolean);
var nStr: string;
    nIdx: Integer;
    nIni: TIniFile;
    nList: TStrings;
begin
  nIni := nil;
  nList := nil;
  try
    nIni := TIniFile.Create(gPath + 'Tunnels.ini');
    nList := gMG.FObjectPool.Lock(TStringList) as TStringList;
    nIni.ReadSections(nList);

    if nLoad then
    begin
      SetLength(gTunnels, nList.Count);
      //init buffer

      for nIdx := 0 to nList.Count-1 do
      with gTunnels[nIdx],nIni do
      begin
        FEnabled        := True;
        FSaveFile       := True;
        FName           := ReadString(nList[nIdx], 'Name', '');
        FMQIn           := Trim(ReadString(nList[nIdx], 'MQIn', ''));
        FMQOut          := Trim(ReadString(nList[nIdx], 'MQOut', ''));

        FCOMPort        := nil;
        FPortName       := ReadString(nList[nIdx], 'COMPort', '');
        nStr            := ReadString(nList[nIdx], 'BaudRate', '');
        FBaudRate       := TStringHelper.Str2Enum<TBaudRate>(nStr);
        nStr            := ReadString(nList[nIdx], 'DataBits', '');
        FDataBits       := TStringHelper.Str2Enum<TDataBits>(nStr);
        nStr            := ReadString(nList[nIdx], 'Parity', '');
        FParity         := TStringHelper.Str2Enum<TParity>(nStr);
        nStr            := ReadString(nList[nIdx], 'StopBits', '');
        FStopBits       := TStringHelper.Str2Enum<TStopBits>(nStr);
        nStr            := ReadString(nList[nIdx], 'DTRControl', '');
        FDTRControl     := TStringHelper.Str2Enum<TDTRControl>(nStr);
        nStr            := ReadString(nList[nIdx], 'RTSControl', '');
        FRTSControl     := TStringHelper.Str2Enum<TRTSControl>(nStr);
        nStr            := ReadString(nList[nIdx], 'XOnXOffControl', '');
        FXOnXOffControl := TStringHelper.Str2Enum<TXOnXOffControl>(nStr);
      end;
    end else
    begin
      for nIdx := nList.Count-1 downto 0 do
        nIni.EraseSection(nList[nIdx]);
      //clear all

      for nIdx := Low(gTunnels) to High(gTunnels) do
      with gTunnels[nIdx],nIni,TStringHelper do
      begin
        if not (FEnabled and FSaveFile) then Continue;
        nStr := Format('Tunnel_%d', [nIdx]);

        WriteString(nStr, 'Name', FName);
        WriteString(nStr, 'MQIn', FMQIn);
        WriteString(nStr, 'MQOut', FMQOut);

        WriteString(nStr, 'COMPort',         FPortName);
        WriteString(nStr, 'BaudRate',        Enum2Str(FBaudRate));
        WriteString(nStr, 'DataBits',        Enum2Str(FDataBits));
        WriteString(nStr, 'Parity',          Enum2Str(FParity));
        WriteString(nStr, 'StopBits',        Enum2Str(FStopBits));
        WriteString(nStr, 'DTRControl',      Enum2Str(FDTRControl));
        WriteString(nStr, 'RTSControl',      Enum2Str(FRTSControl));
        WriteString(nStr, 'XOnXOffControl',  Enum2Str(FXOnXOffControl));
      end;
    end;
  finally
    gMG.FObjectPool.Release(nList);
    nIni.Free;
  end;
end;

//Date: 2019-05-23
//Parm: ���ڶ���
//Desc: ʹ��nCfg����nCOMPort
procedure ApplyConfig(const nCOMPort: TComPort; const nSet: Boolean;
 const nCfg: Integer);
var nStr: string;
    nParam: PTunnelItem;
begin
  if nCfg < 0 then
       nParam := @gSetupParam
  else nParam := @gTunnels[nCfg];

  with nParam^,nCOMPort do
  begin
    if nSet then
    begin
      nStr := StringReplace(FPortName, 'COM', '', [rfIgnoreCase]);
      if StrToInt(nStr) > 9 then
           DeviceName := '\\.\' + FPortName
      else DeviceName := FPortName;

      BaudRate   := FBaudRate;
      DataBits   := FDataBits;
      Parity     := FParity;
      StopBits   := FStopBits;

      FlowControl.DTR := FDTRControl;
      FlowControl.RTS := FRTSControl;
      FlowControl.XOnXOff := FXOnXOffControl;

      if FRTSControl = rcHandshake then
           Options := Options + [opOutputCTSFlow]
      else Options := Options - [opOutputCTSFlow];
    end else
    begin
      nStr             := 'br' + IntToStr(CustomBaudRate);
      FBaudRate        := TStringHelper.Str2Enum<TBaudRate>(nStr);
      FDataBits        := DataBits;
      FParity          := Parity;
      FStopBits        := StopBits;
      FDTRControl      := FlowControl.DTR;
      FRTSControl      := FlowControl.RTS;
      FXOnXOffControl  := FlowControl.XOnXOff;
    end;
  end;
end;

//Date: 2019-05-27
//Parm: ֻ���ö���״̬
//Desc: ���������������б�
procedure MakeTopicList(const nOnlyReset: Boolean = False);
var i,nIdx,nLen: Integer;
begin
  gSyncLock.Enter;
  try
    if nOnlyReset then
    begin
      for nIdx := Low(gTopics) to High(gTopics) do
        gTopics[nIdx].FHasSub := False;
      Exit;
    end;

    SetLength(gTopics, 0);
    for nIdx := Low(gTunnels) to High(gTunnels) do
    with gTunnels[nIdx] do
    begin
      if (not FEnabled) or (FMQIn = '') then Continue;
      //invalid
      nLen := -1;

      for i := Low(gTopics) to High(gTopics) do
      if gTopics[i].FTopic = FMQIn then
      begin
        nLen := i;
        Break;
      end; //topic has exists

      if nLen <> -1 then Continue;
      nLen := Length(gTopics);
      SetLength(gTopics, nLen + 1);

      with gTopics[nLen] do
      begin
        FTopic   := FMQIn;
        FChannel := 0;
        FHasSub  := False;
        FLastSub := 0;
      end;
    end;
  finally
    gSyncLock.Leave;
  end;
end;

//Date: 2019-05-28
//Parm: ����;����
//Desc: ��������¼�����
function MainEventCounter(const nInc: Boolean; const nNum: Integer): Integer;
begin
  with gSysStatus do
  try
    gSyncLock.Enter;
    if nNum > 0 then
    begin
      if nInc then
           FMainEventCounter := FMainEventCounter + nNum
      else FMainEventCounter := FMainEventCounter - nNum;
    end else

    if nNum = 0 then
    begin
      FMainEventCounter := 0;
    end;

    Result := FMainEventCounter;
  finally
    gSyncLock.Leave;
  end;
end;

initialization
  gSyncLock := TCriticalSection.Create;
finalization
  gSyncLock.Free;
end.
