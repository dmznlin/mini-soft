{*******************************************************************************
  作者: dmzn@ylsoft.com 2007-10-09
  描述: 项目通用常,变量定义单元
*******************************************************************************}
unit USysConst;

interface

uses
  ComCtrls;

const
  cSBar_Date            = 0;                         //日期面板索引
  cSBar_Time            = 1;                         //时间面板索引

type
  TSysParam = record
    FProgID     : string;                            //程序标识
    FAppTitle   : string;                            //程序标题栏提示
    FMainTitle  : string;                            //主窗体标题
    FHintText   : string;                            //主窗体提示内容
    FCopyRight  : string;                            //程序版权

    FUserID     : string;                            //用户标记
    FUserName   : string;                            //用户名
    FUserPwd    : string;                            //用户密码

    FTableMenu  : string;                            //菜单表
    FTableUser  : string;                            //用户表
    FTableGroup : string;                            //权限组
    FTablePopedom: string;                           //权限表
    FTablePopItem: string;                           //权限项
  end;
  
//------------------------------------------------------------------------------
var
  gPath: string;                                     //程序所在路径
  gSysParam:TSysParam;                               //程序环境参数
  gStatusBar: TStatusBar;                            //全局使用状态栏

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'EPOP';                      //默认标识
  sAppTitle           = '权限编辑器';                //程序标题
  sMainCaption        = '权限编辑器';                //主窗口标题

  sHint               = '提示';                      //对话框标题
  sAsk                = '询问';                      //询问对话框
  sWarn               = '警告';                      //警告对话框

  sDate               = '日期:【%s】';               //任务栏日期
  sTime               = '时间:【%s】';               //任务栏时间

  sLogoFile           = 'Logo.bmp';                  //登录Logo
  sDBConnFile         = 'DBConn.ini';                //数据库连接             

  sConfigFile         = 'Config.Ini';                //主配置文件
  sConfigSec          = 'Config';                    //主配置小节
  sVerifyCode         = ';Verify:';                  //校验码标记

  sFormConfig         = 'FormInfo.ini';              //窗体配置
  sSetupSec           = 'Setup';                     //配置小节

  sInvalidConfig      = '配置文件无效或已经损坏';    //配置文件无效
  sCloseQuery         = '确定要退出程序吗?';         //主窗口退出

  sTableSec           = 'DBTable';                   //数据库小节
  sTable_Menu         = 'Sys_Menu';
  sTable_User         = 'Sys_User';
  sTable_Group        = 'Sys_Group';
  sTable_Popedom      = 'Sys_Popedom';
  sTable_PopItem      = 'Sys_PopItem';               //表名称

implementation

end.


