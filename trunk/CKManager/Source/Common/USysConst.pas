{*******************************************************************************
  作者: dmzn@ylsoft.com 2007-10-09
  描述: 项目通用常,变量定义单元
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, ComCtrls;

const
  cSBar_Date            = 0;                         //日期面板索引
  cSBar_Time            = 1;                         //时间面板索引
  cSBar_User            = 2;                         //用户面板索引
  cRecMenuMax           = 5;                         //最近使用导航区最大条目数
  cPrecision            = 100;                       //浮动精度
  
const
  {*Frame ID*}
  cFI_FrameSysLog       = $0001;                     //系统日志
  cFI_FrameViewLog      = $0002;                     //本地日志
  cFI_FrameUnit         = $0010;                     //材质规格
  cFI_FrameDepartment   = $0011;                     //部门单位
  cFI_FrameStorage      = $0012;                     //仓库仓位
  cFI_FrameProvider     = $0013;                     //供应厂商
  cFI_FrameGoodsType    = $0014;                     //物品分类
  cFI_FrameGoods        = $0015;                     //品名管理
  cFI_FrameWeeks        = $0016;                     //采购周期
  cFI_FramePlan         = $0017;                     //采购计划
  cFI_FrameRYuanLiao    = $0020;                     //原料入库
  cFI_FrameRBeiPin      = $0021;                     //备品入库
  cFI_FrameChuKu        = $0022;                     //物品出库

  cFI_FrameQBuyPlan     = $0030;                     //采购报表
  cFI_FrameQKuCun       = $0031;                     //库存报表

  cFI_FormBackup        = $1001;                     //数据备份
  cFI_FormRestore       = $1002;                     //数据恢复
  cFI_FormIncInfo       = $1003;                     //公司信息
  cFI_FormChangePwd     = $1005;                     //修改密码
  cFI_FormBaseInfo      = $1006;                     //基本信息

  cFI_FormUnit          = $1010;                     //规格才是
  cFI_FormDepartment    = $1011;                     //部门单位
  cFI_FormStorage       = $1012;                     //仓库仓位
  cFI_FormProvider      = $1013;                     //供应厂商
  cFI_FormGoodsType     = $1014;                     //物品分类
  cFI_FormGoods         = $1015;                     //品名管理
  cFI_FormWeeks         = $1016;                     //采购周期
  cFI_FormGetWeek       = $1017;                     //筛选周期
  cFI_FormBuyReq        = $1018;                     //采购申请
  cFI_FormBuyPlan       = $1019;                     //采购计划

  cFI_FormRYuanLiao     = $1020;                     //原料入库
  cFI_FormRBeiPin       = $1021;                     //备品入库
  cFI_FormChuKu         = $1022;                     //物品出库

  {*Command*}
  cCmd_RefreshData      = $0002;                     //刷新数据
  cCmd_ViewSysLog       = $0003;                     //系统日志

  cCmd_ModalResult      = $1001;                     //Modal窗体
  cCmd_FormClose        = $1002;                     //关闭窗口
  cCmd_AddData          = $1003;                     //添加数据
  cCmd_EditData         = $1005;                     //修改数据
  cCmd_ViewData         = $1006;                     //查看数据
  cCmd_GetData          = $1007;                     //选择数据

type
  TSysParam = record
    FProgID     : string;                            //程序标识
    FAppTitle   : string;                            //程序标题栏提示
    FMainTitle  : string;                            //主窗体标题
    FHintText   : string;                            //提示文本
    FCopyRight  : string;                            //主窗体提示内容

    FUserID     : string;                            //用户标识
    FUserName   : string;                            //当前用户
    FUserPwd    : string;                            //用户口令
    FGroupID    : string;                            //所在组
    FIsAdmin    : Boolean;                           //是否管理员
    FIsNormal   : Boolean;                           //帐户是否正常

    FRecMenuMax : integer;                           //导航栏个数
    FIconFile   : string;                            //图标配置文件
  end;
  //系统参数

  TModuleItemType = (mtFrame, mtForm);
  //模块类型

  PMenuModuleItem = ^TMenuModuleItem;
  TMenuModuleItem = record
    FMenuID: string;                                 //菜单名称
    FModule: integer;                                //模块标识
    FItemType: TModuleItemType;                      //模块类型
  end;

//------------------------------------------------------------------------------
var
  gPath: string;                                     //程序所在路径
  gSysParam:TSysParam;                               //程序环境参数
  gStatusBar: TStatusBar;                            //全局使用状态栏
  gMenuModule: TList = nil;                          //菜单模块映射表

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

//------------------------------------------------------------------------------
//Desc: 添加菜单模块映射项
procedure AddMenuModuleItem(const nMenu: string; const nModule: Integer;
 const nType: TModuleItemType = mtFrame);
var nItem: PMenuModuleItem;
begin
  New(nItem);
  gMenuModule.Add(nItem);

  nItem.FMenuID := nMenu;
  nItem.FModule := nModule;
  nItem.FItemType := nType;
end;

//Desc: 菜单模块映射表
procedure InitMenuModuleList;
begin
  gMenuModule := TList.Create;

  AddMenuModuleItem('MAIN_A01', cFI_FormIncInfo, mtForm);
  AddMenuModuleItem('MAIN_A02', cFI_FrameSysLog);
  AddMenuModuleItem('MAIN_A03', cFI_FormBackup, mtForm);
  AddMenuModuleItem('MAIN_A04', cFI_FormRestore, mtForm);
  AddMenuModuleItem('MAIN_A05', cFI_FormChangePwd, mtForm);

  AddMenuModuleItem('MAIN_B01', cFI_FrameUnit);
  AddMenuModuleItem('MAIN_B02', cFI_FrameDepartment);
  AddMenuModuleItem('MAIN_B03', cFI_FrameStorage);
  AddMenuModuleItem('MAIN_B04', cFI_FrameProvider);
  AddMenuModuleItem('MAIN_B05', cFI_FormBaseInfo, mtForm);
  AddMenuModuleItem('MAIN_B06', cFI_FrameGoods);

  AddMenuModuleItem('MAIN_C01', cFI_FramePlan);
  AddMenuModuleItem('MAIN_C02', cFI_FrameRYuanLiao);
  AddMenuModuleItem('MAIN_C03', cFI_FrameRBeiPin);
  AddMenuModuleItem('MAIN_C05', cFI_FrameWeeks);

  AddMenuModuleItem('MAIN_D01', cFI_FormChuKu, mtForm);
  AddMenuModuleItem('MAIN_D02', cFI_FrameChuKu);

  AddMenuModuleItem('MAIN_E01', cFI_FrameQBuyPlan);
  AddMenuModuleItem('MAIN_E02', cFI_FrameQKuCun);
end;

//Desc: 清理模块列表
procedure ClearMenuModuleList;
var nIdx: integer;
begin
  for nIdx:=gMenuModule.Count - 1 downto 0 do
  begin
    Dispose(PMenuModuleItem(gMenuModule[nIdx]));
    gMenuModule.Delete(nIdx);
  end;

  FreeAndNil(gMenuModule);
end;

initialization
  InitMenuModuleList;
finalization
  ClearMenuModuleList;
end.


