{*******************************************************************************
  作者: dmzn@163.com 2011-10-22
  描述: 常量定义
*******************************************************************************}
unit UMITConst;

{$I Link.Inc}
interface

uses
  Windows, SysUtils, Classes, ComCtrls, Forms, IniFiles, Registry, IdUDPServer,
  USysMAC;

const
  cSBar_Date            = 0;                         //日期面板索引
  cSBar_Time            = 1;                         //时间面板索引
  cSBar_User            = 2;                         //用户面板索引

const
  cFI_FrameRunlog     = $0002;                       //运行日志
  cFI_FrameSummary    = $0005;                       //信息摘要
  cFI_FrameParam      = $0006;                       //参数配置
  cFI_FrameHard       = $0007;                       //硬件配置

type
  TSysParam = record
    FProgID     : string;                            //程序标识
    FAppTitle   : string;                            //程序标题栏提示
    FMainTitle  : string;                            //主窗体标题
    FHintText   : string;                            //提示文本

    FCompany    : string;                            //公司名称
    FAutoStart  : Boolean;                           //开机自启动
    FAutoMin    : Boolean;                           //启动最小化

    FLocalIP    : string;                            //本机IP
    FLocalMAC   : string;                            //本机MAC
    FLocalName  : string;                            //本机名称
    F02NReader  : Integer;                           //现场读卡器
    F2ClientUDP : Integer;                           //对客户端UDP
  end;
  //系统参数

var
  gPath: string;                                     //程序所在路径
  gSysParam:TSysParam;                               //程序环境参数
  gStatusBar: TStatusBar;                            //全局使用状态栏
  gClientUDPServer: TIdUDPServer;                    //客户端UDP通道

procedure InitSystemEnvironment;
//初始化系统运行环境的变量
procedure ActionSysParameter(const nIsRead: Boolean);
//读写系统配置参数

procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
//在状态栏显示信息

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'Bus_MIT';                   //默认标识
  sAppTitle           = 'Business MIT';              //程序标题
  sMainCaption        = '业务中间件';                //主窗口标题
  sHintText           = '调度系统数据业务服务';      //提示内容

  sAutoStartKey       = 'HX_BusMIT';                 //自启动键值
  sStartServerHint    = '启动业务MIT服务';           //提示内容


  sHint               = '提示';                      //对话框标题
  sWarn               = '警告';                      //==
  sAsk                = '询问';                      //询问对话框
  sError              = '未知错误';                  //错误对话框

  sDate               = '日期:【%s】';               //任务栏日期
  sTime               = '时间:【%s】';               //任务栏时间
  sUser               = '用户:【%s】';               //任务栏用户
                                                               
  sConfigFile         = 'Config.Ini';                //主配置文件
  sFormConfig         = 'FormInfo.ini';              //窗体配置
  sLogDir             = 'Logs\';                     //日志目录
  sSetupSec           = 'Setup';                     //配置小节

  sInvalidConfig      = '配置文件无效或已经损坏';    //配置文件无效
  sCloseQuery         = '确定要退出程序吗?';         //主窗口退出
  
implementation

procedure InitSystemEnvironment;
begin
  Randomize;
  ShortDateFormat := 'YYYY-MM-DD';
  gPath := ExtractFilePath(Application.ExeName);
end;

//Desc: 读写系统配置参数
procedure ActionSysParameter(const nIsRead: Boolean);
var nIni: TIniFile;
    nReg: TRegistry;
begin
  nIni := nil;
  nReg := nil;
  try
    nReg := TRegistry.Create;
    nReg.RootKey := HKEY_CURRENT_USER;
    nReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    //registry

    nIni := TIniFile.Create(gPath + sConfigFile);
    //config file

    with nIni,gSysParam do
    begin
      if nIsRead then
      begin 
        FProgID     := ParamStr(1);
        FAppTitle   := sAppTitle;
        FMainTitle  := sMainCaption;
        FHintText   := sHintText;

        FAutoStart := nReg.ValueExists(sAutoStartKey);
        FAutoMin := ReadBool('System', 'AutoMin', False);

        FLocalMAC   := MakeActionID_MAC;
        GetLocalIPConfig(FLocalName, FLocalIP);

        F02NReader := ReadInteger('System', '02NReader', 1234);
        F2ClientUDP := ReadInteger('System', 'ClientUDPPort', 8050);
      end else
      begin
        WriteBool('System', 'AutoMin', FAutoMin);

        if FAutoStart then
          nReg.WriteString(sAutoStartKey, Application.ExeName)
        else if nReg.ValueExists(sAutoStartKey) then
          nReg.DeleteValue(sAutoStartKey);
        //xxxxx
      end;
    end;
  finally
    nReg.Free;
    nIni.Free;
  end; 
end;

//------------------------------------------------------------------------------
//Desc: 在全局状态栏最后一个Panel上显示nMsg消息
procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
begin
  if Assigned(gStatusBar) and (gStatusBar.Panels.Count > 0) then
  begin
    gStatusBar.Panels[gStatusBar.Panels.Count - 1].Text := nMsg;
    Application.ProcessMessages;
  end;
end;

//Desc: 在索引nIdx的Panel上显示nMsg消息
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
begin
  if Assigned(gStatusBar) and (gStatusBar.Panels.Count > nIdx) and
     (nIdx > -1) then
  begin
    gStatusBar.Panels[nIdx].Text := nMsg;
    gStatusBar.Panels[nIdx].Width := gStatusBar.Canvas.TextWidth(nMsg) + 20;
    Application.ProcessMessages;
  end;
end;

end.
