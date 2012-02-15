{*******************************************************************************
  作者: dmzn@ylsoft.com 2007-10-09
  描述: 项目通用常,变量定义单元
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, ComCtrls, UMgrSync;

const
  cSBar_Date            = 0;                         //日期面板索引
  cSBar_Time            = 1;                         //时间面板索引
  cImg_Pack             = 2;                         //参数包索引
  cImg_Time             = 3;                         //时间点索引

type
  TSysParam = record
    FProgID     : string;                            //程序标识
    FAppTitle   : string;                            //程序标题栏提示
    FMainTitle  : string;                            //主窗体标题
    FHintText   : string;                            //提示文本
    FCopyRight  : string;                            //主窗体提示内容
  end;
  //系统参数

  TWriteDebugLog = procedure (const nMsg: string; const nMustShow: Boolean) of object;
  //调试日志

  procedure ShowSyncLog(const nMsg: string);
  //线程同步日志

//------------------------------------------------------------------------------
var
  gPath: string;                                     //程序所在路径
  gSysParam:TSysParam;                               //程序环境参数
  gDebugLog: TWriteDebugLog;                         //调试日志

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'DMZN';                      //默认标识
  sAppTitle           = 'DMZN';                      //程序标题
  sMainCaption        = 'DMZN';                      //主窗口标题

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
  sDBConfig           = 'DBConn.ini';                //数据连接

  sExportExt          = '.txt';                      //导出默认扩展名
  sExportFilter       = '文本(*.txt)|*.txt|所有文件(*.*)|*.*';
                                                     //导出过滤条件

  sInvalidConfig      = '配置文件无效或已经损坏';    //配置文件无效
  sCloseQuery         = '确定要退出程序吗?';         //主窗口退出

  
implementation

var
  gLogSync: TDataSynchronizer = nil;
  //日志同步对象

procedure ShowSyncLog(const nMsg: string);
var nBuf: PChar;
    nLen: Integer;
begin
  nLen := Length(nMsg);
  if nLen < 1 then Exit;

  GetMem(nBuf, nLen+1);
  StrLCopy(nBuf, PChar(nMsg), nLen);

  gLogSync.AddData(nBuf, nLen + 1);
  gLogSync.ApplySync;
end;

procedure DoSync(const nData: Pointer; const nSize: Cardinal);
begin
  gDebugLog(StrPas(nData), True);
end;

procedure DoFree(const nData: Pointer; const nSize: Cardinal);
begin
  FreeMem(nData, nSize);
end;

initialization
  gLogSync := TDataSynchronizer.Create;
  gLogSync.SyncProcedure := DoSync;
  gLogSync.SyncFreeProcedure := DoFree;
finalization
  FreeAndNil(gLogSync);
end.


