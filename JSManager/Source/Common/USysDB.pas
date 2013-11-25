{*******************************************************************************
  作者: dmzn@163.com 2008-08-07
  描述: 系统数据库常量定义

  备注:
  *.自动创建SQL语句,支持变量:$Inc,自增;$Float,浮点;$Integer=sFlag_Integer;
    $Decimal=sFlag_Decimal;$Image,二进制流
*******************************************************************************}
unit USysDB;

{$I Link.inc}
interface

uses
  SysUtils, Classes;

const
  cSysDatabaseName: array[0..4] of String = (
     'Access', 'SQL', 'MySQL', 'Oracle', 'DB2');
  //db names

type
  TSysDatabaseType = (dtAccess, dtSQLServer, dtMySQL, dtOracle, dtDB2);
  //db types

  PSysTableItem = ^TSysTableItem;
  TSysTableItem = record
    FTable: string;
    FNewSQL: string;
  end;
  //系统表项

var
  gSysTableList: TList = nil;                        //系统表数组
  gSysDBType: TSysDatabaseType = dtSQLServer;        //系统数据类型

//------------------------------------------------------------------------------
const
  //自增字段
  sField_Access_AutoInc          = 'Counter';
  sField_SQLServer_AutoInc       = 'Integer IDENTITY (1,1) PRIMARY KEY';

  //小数字段
  sField_Access_Decimal          = 'Float';
  sField_SQLServer_Decimal       = 'Decimal(15, 5)';

  //图片字段
  sField_Access_Image            = 'OLEObject';
  sField_SQLServer_Image         = 'Image';

  //日期相关
  sField_SQLServer_Now           = 'getDate()';

ResourceString     
  {*权限项*}
  sPopedom_Read       = 'A';                         //浏览
  sPopedom_Add        = 'B';                         //添加
  sPopedom_Edit       = 'C';                         //修改
  sPopedom_Delete     = 'D';                         //删除
  sPopedom_Preview    = 'E';                         //预览
  sPopedom_Print      = 'F';                         //打印
  sPopedom_Export     = 'G';                         //导出

  {*相关标记*}
  sFlag_Yes           = 'Y';                         //是
  sFlag_No            = 'N';                         //否
  sFlag_Enabled       = 'Y';                         //启用
  sFlag_Disabled      = 'N';                         //禁用

  sFlag_Integer       = 'I';                         //整数
  sFlag_Decimal       = 'D';                         //小数

  sFlag_StockDai      = 'D';                         //袋装
  sFlag_StockSan      = 'S';                         //散装

  sFlag_SysParam      = 'SysParam';                  //系统参数
  sFlag_ValidDate     = 'SysValidDate';              //有效期
  sFlag_KeyName       = 'SysKeyName';                //识别码
  sFlag_Tunnel        = 'JSTunnelNum';               //装车道数

  sFlag_TruckItem     = 'TruckInfo';                 //车辆信息
  sFlag_TruckType     = 'TruckType';                 //车辆类型
  sFlag_CustomerItem  = 'CustomerItem';              //客户信息

  {*数据表*}
  sTable_Group        = 'Sys_Group';                 //用户组
  sTable_User         = 'Sys_User';                  //用户表
  sTable_Menu         = 'Sys_Menu';                  //菜单表
  sTable_Popedom      = 'Sys_Popedom';               //权限表
  sTable_PopItem      = 'Sys_PopItem';               //权限项
  sTable_Entity       = 'Sys_Entity';                //字典实体
  sTable_DictItem     = 'Sys_DataDict';              //字典明细

  sTable_SysDict      = 'Sys_Dict';                  //系统字典
  sTable_ExtInfo      = 'Sys_ExtInfo';               //附加信息
  sTable_SysLog       = 'Sys_EventLog';              //系统日志
  sTable_BaseInfo     = 'Sys_BaseInfo';              //基础信息

  sTable_StockType    = 'Sys_StockType';             //水泥品钟
  sTable_TruckInfo    = 'Sys_TruckInfo';             //车辆管理
  sTable_Customer     = 'Sys_Customer';              //客户管理
  sTable_JSLog        = 'Sys_JSLog';                 //计数日志

  {*新建表*}
  sSQL_NewSysDict = 'Create Table $Table(D_ID $Inc, D_Name varChar(15),' +
       'D_Desc varChar(30), D_Value varChar(50), D_Memo varChar(20),' +
       'D_ParamA $Float, D_ParamB varChar(50), D_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   系统字典: SysDict
   *.D_ID: 编号
   *.D_Name: 名称
   *.D_Desc: 描述
   *.D_Value: 取值
   *.D_Memo: 相关信息
   *.D_ParamA: 浮点参数
   *.D_ParamB: 字符参数
   *.D_Index: 显示索引
  -----------------------------------------------------------------------------}
  
  sSQL_NewExtInfo = 'Create Table $Table(I_ID $Inc, I_Group varChar(20),' +
       'I_ItemID varChar(20), I_Item varChar(30), I_Info varChar(50),' +
       'I_ParamA $Float, I_ParamB varChar(50), I_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   扩展信息表: ExtInfo
   *.I_ID: 编号
   *.I_Group: 信息分组
   *.I_ItemID: 信息标识
   *.I_Item: 信息项
   *.I_Info: 信息内容
   *.I_ParamA: 浮点参数
   *.I_ParamB: 字符参数
   *.I_Memo: 备注信息
   *.I_Index: 显示索引
  -----------------------------------------------------------------------------}
  
  sSQL_NewSysLog = 'Create Table $Table(L_ID $Inc, L_Date DateTime,' +
       'L_Man varChar(32),L_Group varChar(20), L_ItemID varChar(20),' +
       'L_KeyID varChar(20), L_Event varChar(220))';
  {-----------------------------------------------------------------------------
   系统日志: SysLog
   *.L_ID: 编号
   *.L_Date: 操作日期
   *.L_Man: 操作人
   *.L_Group: 信息分组
   *.L_ItemID: 信息标识
   *.L_KeyID: 辅助标识
   *.L_Event: 事件
  -----------------------------------------------------------------------------}

  sSQL_NewBaseInfo = 'Create Table $Table(B_ID $Inc, B_Group varChar(15),' +
       'B_Text varChar(50), B_Py varChar(25), B_Memo varChar(25),' +
       'B_PID Integer, B_Index Float)';
  {-----------------------------------------------------------------------------
   基本信息表: BaseInfo
   *.B_ID: 编号
   *.B_Group: 分组
   *.B_Text: 内容
   *.B_Py: 拼音简写
   *.B_Memo: 备注信息
   *.B_PID: 上级节点
   *.B_Index: 创建顺序
  -----------------------------------------------------------------------------}

  sSQL_NewStockType = 'Create Table $Table(S_ID varChar(15), S_Type Char(1),' +
       'S_Name varChar(50), S_Level varChar(50), S_Weight $Float,' +
       'S_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   品种管理: StockType
   *.S_ID: 编号
   *.S_Type: 类型(袋,散)
   *.S_Name: 品种名称
   *.S_Level: 强度等级
   *.S_Weight: 袋重
  -----------------------------------------------------------------------------}

  sSQL_NewTruckInfo = 'Create Table $Table(T_ID $Inc, T_TruckNo varChar(15),' +
       'T_Type varChar(32), T_Owner varChar(50), T_Phone varChar(32),' +
       'T_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   车辆信息: TruckInfo
   *.T_ID: 编号
   *.T_TruckNo: 车牌号
   *.T_Type: 车辆类型
   *.T_Owner: 车主
   *.T_Phone: 联系方式
   *.T_Memo: 备注信息
  -----------------------------------------------------------------------------}

  sSQL_NewCustomer = 'Create Table $Table(C_ID varChar(15), C_Name varChar(100),' +
       'C_PY varChar(100), C_Addr varChar(100), C_Phone varChar(32),' +
       'C_Memo varChar(50), C_Date DateTime)';
  {-----------------------------------------------------------------------------
   客户信息: Customer
   *.C_ID: 编号
   *.C_Name: 名称
   *.C_PY: 拼音简写
   *.C_Addr: 地址
   *.C_Phone: 联系方式
   *.C_Memo: 备注信息
   *.C_Date: 建档时间
  -----------------------------------------------------------------------------}

  sSQL_NewJSLog = 'Create Table $Table(L_ID $Inc, L_CusID varChar(15), ' +
       'L_Customer varChar(100), L_StockID varChar(15), L_Stock varChar(100),' +
       'L_TruckNo varChar(15),  L_SerialID varChar(32),' +
       'L_Weight $Float, L_DaiShu Integer, L_BC Integer, L_PValue $Float,' +
       'L_ZTLine varChar(32), L_Date DateTime, L_Man varChar(32),' +
       'L_HasDone Char(1), L_OKTime DateTime, L_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   计数日志: JSLog
   *.L_ID: 编号
   *.L_CusID: 客户编号
   *.L_Customer: 客户
   *.L_TruckNo: 车牌号
   *.L_StockID: 品种编号
   *.L_Stock: 水泥品种
   *.L_SerialID: 批次号
   *.L_Weight: 提货数量
   *.L_DaiShu: 提货袋数
   *.L_BC: 补差袋数
   *.L_PValue: 破袋率
   *.L_ZTLine: 栈台位置
   *.L_Date: 操作日期
   *.L_Man: 操作人
   *.L_HasDone: 是否装车
   *.L_OKTime: 完成时间
   *.L_Memo: 备注
  -----------------------------------------------------------------------------}

//------------------------------------------------------------------------------
// 数据查询
//------------------------------------------------------------------------------
  sQuery_SysDict = 'Select D_ID, D_Value, D_Memo From $Table ' +
                   'Where D_Name=''$Name'' Order By D_Index Desc';
  {-----------------------------------------------------------------------------
   从数据字典读取数据
   *.$Table: 数据字典表
   *.$Name: 字典项名称
  -----------------------------------------------------------------------------}

  sQuery_ExtInfo = 'Select I_ID, I_Item, I_Info From $Table Where ' +
                   'I_Group=''$Group'' and I_ItemID=''$ID'' Order By I_Index Desc';    
  {-----------------------------------------------------------------------------
   从扩展信息表读取数据
   *.$Table: 扩展信息表
   *.$Group: 分组名称
   *.$ID: 信息标识
  -----------------------------------------------------------------------------}
  
implementation

//------------------------------------------------------------------------------
//Desc: 添加系统表项
procedure AddSysTableItem(const nTable,nNewSQL: string);
var nP: PSysTableItem;
begin
  New(nP);
  gSysTableList.Add(nP);

  nP.FTable := nTable;
  nP.FNewSQL := nNewSQL;
end;

//Desc: 系统表
procedure InitSysTableList;
begin
  gSysTableList := TList.Create;

  AddSysTableItem(sTable_SysDict, sSQL_NewSysDict);

  AddSysTableItem(sTable_ExtInfo, sSQL_NewExtInfo);

  AddSysTableItem(sTable_SysLog, sSQL_NewSysLog);

  AddSysTableItem(sTable_BaseInfo, sSQL_NewBaseInfo);

  AddSysTableItem(sTable_StockType, sSQL_NewStockType);

  AddSysTableItem(sTable_TruckInfo, sSQL_NewTruckInfo);

  AddSysTableItem(sTable_Customer, sSQL_NewCustomer);

  AddSysTableItem(sTable_JSLog, sSQL_NewJSLog);
end;

//Desc: 清理系统表
procedure ClearSysTableList;
var nIdx: integer;
begin
  for nIdx:= gSysTableList.Count - 1 downto 0 do
  begin
    Dispose(PSysTableItem(gSysTableList[nIdx]));
    gSysTableList.Delete(nIdx);
  end;

  FreeAndNil(gSysTableList);
end;

initialization
  InitSysTableList;
finalization
  ClearSysTableList;
end.


