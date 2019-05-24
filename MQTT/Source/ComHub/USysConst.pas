{*******************************************************************************
  作者: dmzn@163.com 2019-05-21
  描述: 常量定义
*******************************************************************************}
unit USysConst;

interface

uses
  Winapi.Windows, System.Classes, System.IniFiles, Vcl.Forms, System.SysUtils,
  System.Win.Registry, ComPort, UBaseObject, UManagerGroup, ULibFun;

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
  end;
  //系统参数

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

var
  gPath: string;                                     //程序所在路径
  gSysParam:TSysParam;                               //程序环境参数
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

ResourceString
  sProgID             = 'DMZN';                      //默认标识
  sAppTitle           = 'DMZN';                      //程序标题
  sMainCaption        = 'DMZN';                      //主窗口标题

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

      FAppTitle := ReadString(FProgID, 'AppTitle', sAppTitle);
      FMainTitle := ReadString(FProgID, 'MainTitle', sMainCaption);
      FHintText := ReadString(FProgID, 'HintText', '');
      FCopyRight := ReadString(FProgID, 'CopyRight', '');

      FAutoRun := nReg.ValueExists('Com_Hub');
      FMinAfterRun := ReadString(FProgID, 'MinAfterRun', '')  = 'Y';
      FAdminPassword := ReadString(FProgID, 'AdminPwd', '');
      FHotKey := ReadString(FProgID, 'HotKey', 'Ctrl + Alt + D');

      FServerIP := ReadString(FProgID, 'ServerIP', '118.89.157.37');
      FServerPort := ReadInteger(FProgID, 'ServerPort', 8030);
      FServerUser := ReadString(FProgID, 'ServerUser', 'admin');
      FServerPwd := ReadString(FProgID, 'ServerPwd', 'admin');
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

      WriteString(FProgID, 'ServerIP', FServerIP);
      WriteInteger(FProgID, 'ServerPort', FServerPort);
      WriteString(FProgID, 'ServerUser', FServerUser);
      WriteString(FProgID, 'ServerPwd', FServerPwd);
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
        FMQIn           := ReadString(nList[nIdx], 'MQIn', '');
        FMQOut          := ReadString(nList[nIdx], 'MQOut', '');

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

end.
