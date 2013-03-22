{*******************************************************************************
  作者: dmzn@ylsoft.com 2007-10-09
  描述: 项目通用常,变量定义单元
*******************************************************************************}
unit USysConst;

interface

uses
  Windows, SysUtils, Classes, Forms, IniFiles, Registry, UMgrDBConn,
  dxStatusBar, UBase64, ULibFun, UDataModule, UFormWait;

const
  cSBar_Date            = 0;                         //日期面板索引
  cSBar_Time            = 1;                         //时间面板索引
  cColor_Timeout        = 0;

const
  {*Frame ID*}
  cFI_FrameRunLog       = $0001;                     //系统日志
  cFI_FrameRunMon       = $0002;                     //运行监控
  cFI_FrameRealTime     = $0003;                     //实时监控
  cFI_FrameReport       = $0005;                     //报表查询
  cFI_FrameConfig       = $0006;                     //参数设置
  cFI_FrameSetSystem    = $0010;                     //系统设置
  cFI_FrameSetPort      = $0011;                     //串口设置
  cFI_FrameSetDevice    = $0012;                     //设备设置
  cFI_FrameHistogram    = $0013;                     //柱状显示

  cFI_FormSetDB         = $0020;                     //数据库
  cFI_FormCOMPort       = $0021;                     //端口配置
  cFI_FormDevice        = $0022;                     //设备配置
  cFI_FormSetIndex      = $0023;                     //设置地址
  cFI_FormPressMax      = $0025;                     //压力满度
  cFI_FormSysParam      = $0026;                     //系统参数
  cFI_FormChartStyle    = $0027;                     //界面风格

  {*Command*}
  cCmd_ViewSysLog       = $0001;                     //系统日志
  cCmd_RefreshData      = $0002;
  cCmd_RefreshDevList   = $0003;                     //刷新数据
                                                              
  cCmd_ModalResult      = $1001;                     //Modal窗体
  cCmd_FormClose        = $1002;                     //关闭窗口
  cCmd_AddData          = $1003;                     //添加数据
  cCmd_EditData         = $1005;                     //修改数据
  cCmd_ViewData         = $1006;                     //查看数据
  cCmd_DeleteData       = $1007;                     //删除数据

  cCmd_ViewPortData     = $1010;                     //查看端口
  cCmd_ViewDeviceData   = $1011;                     //查看设备

type
  TSysParam = record
    FProgID     : string;                            //程序标识
    FAppTitle   : string;                            //程序标题栏提示
    FMainTitle  : string;                            //主窗体标题

    FUserName   : string;                            //当前用户
    FUserPwd    : string;                            //用户口令
    FIsAdmin    : Boolean;                           //是否管理员

    FAutoStart  : Boolean;                           //开机自启动
    FAutoMin    : Boolean;                           //启动最小化

    FTrainID    : string;                            //火车标识
    FQInterval  : Cardinal;                          //查询指令间隔
    FPrintSend  : Boolean;
    FPrintRecv  : Boolean;                           //打印运行数据
    FUIInterval : Integer;                           //界面组件间隔
    FUIMaxValue : Double;                            //进度条最大值
    FChartCount : Integer;                           //曲线数据点个数
    FReportPage : Integer;                           //报表页大小
  end;
  //系统参数

//------------------------------------------------------------------------------
var
  gPath: string;                                     //程序所在路径
  gSysParam:TSysParam;                               //程序环境参数
  gDBPram: TDBParam;                                 //数据库参数
  gStatusBar: TdxStatusBar;                          //全局使用状态栏

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'TruckCtrl';                 //默认标识
  sAppTitle           = '制动监控';                  //程序标题
  sMainCaption        = '三瑞共和 - 制动监控';       //主窗口标题
  sAutoStartKey       = 'SR_TruckCtrl';              //自启动键值

  sHint               = '提示';                      //对话框标题
  sWarn               = '警告';                      //==
  sAsk                = '询问';                      //询问对话框
  sError              = '未知错误';                  //错误对话框

  sDate               = '日期:【%s】';               //任务栏日期
  sTime               = '时间:【%s】';               //任务栏时间
  sUser               = '用户:【%s】';               //任务栏用户

  sLogDir             = 'Logs\';                     //日志目录
  sLogExt             = '.log';                      //日志扩展名
  sLogField           = #9;                          //记录分隔符

  sImageDir           = 'Images\';                   //图片目录
  sReportDir          = 'Report\';                   //报表目录
  sBackupDir          = 'Backup\';                   //备份目录
  sBackupFile         = 'Bacup.idx';                 //备份索引

  sConfigFile         = 'Config.Ini';                //主配置文件
  sConfigSec          = 'Config';                    //主配置小节
  sVerifyCode         = ';Verify:';                  //校验码标记

  sFormConfig         = 'FormInfo.ini';              //窗体配置
  sSetupSec           = 'Setup';                     //配置小节

  sStyleConfig        = 'Style.ini';                 //风格配置
  sStyleDevList       = 'DeviceList';                //设备列表
  
  sExportExt          = '.txt';                      //导出默认扩展名
  sExportFilter       = '文本(*.txt)|*.txt|所有文件(*.*)|*.*';
                                                     //导出过滤条件 

  sInvalidConfig      = '配置文件无效或已经损坏';    //配置文件无效
  sCloseQuery         = '确定要退出程序吗?';         //主窗口退出

procedure InitSystemEnvironment;
//初始化系统运行环境的变量
procedure ActionSysParameter(const nIsRead: Boolean);
//读写系统配置参数
procedure ActionDBConfig(const nIsRead: Boolean);
//读写数据库配置
function CheckDBConnection(const nHint: Boolean = True): Boolean;

procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
//在状态栏显示信息

implementation

//Desc: 初始化运行环境
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
        FProgID     := sProgID;
        FAppTitle   := sAppTitle;
        FMainTitle  := sMainCaption;

        FAutoStart := nReg.ValueExists(sAutoStartKey);
        FAutoMin := ReadBool('System', 'AutoMin', False);
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

//Desc: 读写数据库配置参数
procedure ActionDBConfig(const nIsRead: Boolean);
var nStr: string;
    nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sConfigFile);
  with nIni,gDBPram do
  try
    nStr := ReadString('DBConfig', 'Active', '0');
    //active index
    
    if nIsRead then
    begin
      FID   := sProgID;
      FHost := ReadString('DBConfig', 'Host_' + nStr, '');
      FPort := ReadInteger('DBConfig', 'Port_' + nStr, 1433);
      FDB   := ReadString('DBConfig', 'DB_' + nStr, '');
      FUser := ReadString('DBConfig', 'User_' + nStr, '');
      FPwd  := DecodeBase64(ReadString('DBConfig', 'Password_' + nStr, ''));
      FConn := DecodeBase64(ReadString('DBConfig', 'ConnStr_' + nStr, ''));

      FEnable    := True;
      FNumWorker := 10;
    end else
    begin
      WriteString('DBConfig', 'Host_' + nStr, FHost);
      WriteInteger('DBConfig', 'Port_' + nStr, FPort);
      WriteString('DBConfig', 'DB_' + nStr, FDB);
      WriteString('DBConfig', 'User_' + nStr, FUser);
      WriteString('DBConfig', 'Password_' + nStr, EncodeBase64(FPwd));
      WriteString('DBConfig', 'ConnStr_' + nStr, EncodeBase64(FConn));
    end;
  finally
    nIni.Free;
  end;   
end;

//Date: 2013-3-11
//Parm: 是否提示
//Desc: 监测数据连接是否正常
function CheckDBConnection(const nHint: Boolean): Boolean;
begin
  with FDM.ADOConn do
  begin
    Result := Connected;
    if Result then Exit;

    if gDBPram.FHost = '' then
    begin
      if nHint then
        ShowMsg('请配置数据库', sHint);
      Exit;
    end;

    if nHint then
    begin
      ShowWaitForm(Application.MainForm, '连接数据库');
      Sleep(1200);
    end;

    try
      ConnectionString := gDBConnManager.MakeDBConnection(gDBPram);
      Connected := True;
      Result := Connected;

      if Result then
        FDM.AdjustAllSystemTables;
      //create new table
    except
      if nHint then
        ShowMsg('连接数据库失败', sHint);
      Result := False;
    end;

    if nHint then
      CloseWaitForm;
    //xxxxx
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


