{*******************************************************************************
  作者: dmzn@163.com 2019-05-21
  描述: 常量定义
*******************************************************************************}
unit USysConst;

interface

uses
  Winapi.Windows, System.Classes, System.IniFiles, Vcl.Forms, System.SysUtils,
  System.Win.Registry, System.SyncObjs, ComPort, UBaseObject, UManagerGroup,
  ULibFun;

type
  TSysParam = record
    FProgID         : string;                        //程序标识
    FAppTitle       : string;                        //程序标题栏提示
    FMainTitle      : string;                        //主窗体标题
    FHintText       : string;                        //提示文本
    FCopyRight      : string;                        //主窗体提示内容

    FLocalIP        : string;                        //本机IP
    FLocalMAC       : string;                        //本机MAC
    FLocalName      : string;                        //本机名称

    FChanged        : Boolean;                       //已变更
    FAutoRun        : Boolean;                       //自启动
    FMinAfterRun    : Boolean;                       //启动后最小化
    FAdminPassword  : string;                        //管理密码
    FHotKey         : string;                        //全局热键

    FServerIP       : string;
    FServerPort     : Integer;
    FServerUser     : string;
    FServerPwd      : string;                        //MQTT Server
    FHeatBeat       : Integer;                       //心跳(秒)
    FReconnect      : Integer;                       //断线重连(秒)
  end;
  //系统参数

  TSystemStatus = record
    FMQTTConnected      : Boolean;                   //服务已连接
    FMQTTLastPing       : Cardinal;                  //Ping
    FTopicsSubscribed   : Boolean;                   //主题已订阅
    FShowDetailLog      : Boolean;                   //显示日志明细
    FApplicationRunning : Boolean;                   //系统运行中
    FMainEventCounter   : Integer;                   //主要事件计数
    FHotkeyWorking      : Boolean;                   //热键已出发
  end;

  PTunnelItem = ^TTunnelItem;
  TTunnelItem = record
    FName           : string;                        //通道名称
    FMQIn           : string;                        //输入标识(消息订阅)
    FMQOut          : string;                        //输出标识(消息发布)

    FCOMPort        : TComPort;                      //串口对象
    FPortName       : string;                        //端口名称
    FBaudRate       : TBaudRate;                     //波特率
    FDataBits       : TDataBits;                     //数据位
    FParity         : TParity;                       //校验位
    FStopBits       : TStopBits;                     //停止位
    FDTRControl     : TDTRControl;
    FRTSControl     : TRTSControl;
    FXOnXOffControl : TXOnXOffControl;               //流控制

    FEnabled        : Boolean;                       //通道有效
    FSaveFile       : Boolean;                       //存入文件
  end;

  TTunnelItems = array of TTunnelItem;
  //通道列表

  TTopicItem = record
    FTopic          : string;                        //主题名称
    FChannel        : Word;                          //订阅编号
    FHasSub         : Boolean;                       //已订阅
    FLastSub        : Cardinal;                      //发起订阅
  end;

  TTopicItems = array of TTopicItem;
  //订阅列表

var
  gPath: string;                                     //程序所在路径
  gSysParam: TSysParam;                              //程序环境参数
  gSysStatus: TSystemStatus;                         //程序运行状态
  gSyncLock: TCriticalSection;                       //全局同步锁定

  gTopics: TTopicItems;                              //主题列表
  gTunnels: TTunnelItems;                            //通道列表
  gSetupParam: TTunnelItem;                          //设置中通道参数

procedure InitSystemEnvironment;
//初始化系统运行环境的变量
procedure SysParameter(const nLoad: Boolean; const nIni: TIniFile = nil);
//系统配置参数
procedure TunnelConfig(const nLoad: Boolean);
//读写通道配置文件
procedure ApplyConfig(const nCOMPort: TComPort; const nSet: Boolean = True;
 const nCfg: Integer = -1);
//应用配置
procedure MakeTopicList(const nOnlyReset: Boolean = False);
//构建订阅列表
function MainEventCounter(const nInc: Boolean; const nNum: Integer = 1): Integer;
//增减核心事件计数

ResourceString
  sProgID             = 'ComHub';                    //默认标识
  sAppTitle           = 'ComHub';                    //程序标题
  sMainCaption        = 'ComHub';                    //主窗口标题

  sHint               = '提示';                      //对话框标题
  sWarn               = '警告';                      //==
  sAsk                = '询问';                      //询问对话框
  sError              = '未知错误';                  //错误对话框

  sLogDir             = 'Logs\';                     //日志目录
  sLogExt             = '.log';                      //日志扩展名
  sConfigFile         = 'Config.Ini';                //主配置文件
  sFormConfig         = 'FormInfo.ini';              //窗体配置

implementation

//Date: 2007-01-09
//Desc: 初始化运行环境
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
//Desc: 载入系统配置参数
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
      //程序标识决定以下所有参数

      FLocalMAC := TGUID.NewGuid.ToString;
      //程序参考标识

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
//Parm: 是否载入
//Desc: 读写通道配置参数
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
//Parm: 串口对象
//Desc: 使用nCfg配置nCOMPort
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
//Parm: 只重置订阅状态
//Desc: 构建待订阅主题列表
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
//Parm: 增减;增量
//Desc: 变更串口事件计数
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
