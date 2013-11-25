{*******************************************************************************
  作者: dmzn@163.com 2011-10-22
  描述: 常量定义
*******************************************************************************}
unit UMITConst;

{$I Link.Inc}
interface

uses
  Windows, SysUtils, Classes, ComCtrls, Forms, IniFiles, Registry,
  ZnExeData, USysMAC;

const
  cSBar_Date            = 0;                         //日期面板索引
  cSBar_Time            = 1;                         //时间面板索引
  cSBar_User            = 2;                         //用户面板索引

type
  TSysParam = record
    FProgID     : string;                            //程序标识
    FAppTitle   : string;                            //程序标题栏提示
    FMainTitle  : string;                            //主窗体标题
    FHintText   : string;                            //提示文本

    FLocalIP    : string;                            //本机IP
    FLocalMAC   : string;                            //本机MAC
    FLocalName  : string;                            //本机名称

    FDisplayDPI : Integer;                           //屏幕分辨率
    FAutoMin    : Boolean;                           //自动最小化
  end;
  //系统参数

var
  gPath: string;                                     //程序所在路径
  gSysParam:TSysParam;                               //程序环境参数
  gStatusBar: TStatusBar;                            //全局使用状态栏
  gShareData: TZnPostData;                           //跨进程数据共享

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
  sAppTitle           = 'Bus_MIT';                   //程序标题
  sMainCaption        = '通用中间件';                //主窗口标题
  sHintText           = '通用中间件服务';            //提示内容

  sHint               = '提示';                      //对话框标题
  sWarn               = '警告';                      //==
  sAsk                = '询问';                      //询问对话框
  sError              = '错误';                      //错误对话框

  sDate               = '日期:【%s】';               //任务栏日期
  sTime               = '时间:【%s】';               //任务栏时间
  sUser               = '用户:【%s】';               //任务栏用户
                                                               
  sConfigFile         = 'Config.Ini';                //主配置文件
  sFormConfig         = 'FormInfo.ini';              //窗体配置
  sLogDir             = 'Logs\';                     //日志目录
  sLogSyncLock        = 'SyncLock_MIT_CommonMIT';    //日志同步锁

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
begin
  nIni := nil;
  try
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

        FLocalMAC   := MakeActionID_MAC;
        GetLocalIPConfig(FLocalName, FLocalIP);
        FDisplayDPI := GetDeviceCaps(GetDC(0), LOGPIXELSY);
      end else
      begin
        WriteBool('System', 'AutoMin', FAutoMin);
      end;
    end;
  finally
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
    gStatusBar.Panels[nIdx].Width := gStatusBar.Canvas.TextWidth(nMsg) +
                                     Trunc(gSysParam.FDisplayDPI * Length(nMsg) / 50);
    //Application.ProcessMessages;
  end;
end;

end.
