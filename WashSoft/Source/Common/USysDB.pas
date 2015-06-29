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

  sFlag_IOType_In     = 'C';                         //充值
  sFlag_IOType_Out    = 'X';                         //消费

  sFlag_GroupUnit     = 'Unit';                      //单位
  sFlag_GroupColor    = 'Color';                     //颜色
  sFlag_GroupType     = 'Type';                      //类型

  sFlag_BusGroup      = 'BusFunction';               //业务编码组
  sFlag_MemberID      = 'ID_Member';                 //会员编号
  sFlag_WashTypeID    = 'ID_WashType';               //衣物类型
  sFlag_WashData      = 'ID_WashData';               //洗衣记录

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
  sTable_SerialBase   = 'Sys_SerialBase';            //编码种子

  sTable_Member       = 'W_Member';                  //会员表
  sTable_InOutMoney   = 'W_InOutMoney';              //资金明细
  sTable_WashType     = 'W_WashType';                //衣物类型
  sTable_WashData     = 'W_WashData';                //洗衣数据
  sTable_WashDetail   = 'W_WashDetail';              //收衣明细

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
       'I_ItemID varChar(20), I_Item varChar(30), I_Info varChar(500),' +
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
       'B_Text varChar(100), B_Py varChar(25), B_Memo varChar(50),' +
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

  sSQL_NewSerialBase = 'Create Table $Table(R_ID $Inc, B_Group varChar(15),' +
       'B_Object varChar(32), B_Prefix varChar(25), B_IDLen Integer,' +
       'B_Base Integer, B_Date DateTime)';
  {-----------------------------------------------------------------------------
   串行编号基数表: SerialBase
   *.R_ID: 编号
   *.B_Group: 分组
   *.B_Object: 对象
   *.B_Prefix: 前缀
   *.B_IDLen: 编号长
   *.B_Base: 基数
   *.B_Date: 参考日期
  -----------------------------------------------------------------------------}

  sSQL_NewMember = 'Create Table $Table(R_ID $Inc, M_ID varChar(16),' +
       'M_Name varChar(32), M_Py varChar(32),' +
       'M_Phone varChar(32), M_Times Integer,' +
       'M_MoneyIn $Float, M_MoneyOut $Float, M_MoneyFreeze $Float,' +
       'M_JiFen $Float, M_ZheKou $Float)';
  {-----------------------------------------------------------------------------
   会员表: Member
   *.R_ID: 编号
   *.M_ID: 内码
   *.M_Name: 姓名
   *.M_Py: 拼音
   *.M_Phone: 手机号
   *.M_MoneyIn: 充值金额
   *.M_MoneyOut: 消费金额
   *.M_MoneyFreeze: 冻结金额
   *.M_Times: 消费次数
   *.M_JiFen: 积分
   *.M_ZheKou: 折扣
  -----------------------------------------------------------------------------}

  sSQL_NewInOutMoney = 'Create Table $Table(R_ID $Inc, M_ID varChar(16),' +
       'M_Type Char(1), M_Money $Float, M_Date DateTime, M_Memo varChar(100))';
  {-----------------------------------------------------------------------------
   资金明细: InOutMoney
   *.R_ID: 编号
   *.M_ID: 标识
   *.M_Type: 类型
   *.M_Money: 金额
   *.M_Date: 日期
   *.M_Memo: 描述
  -----------------------------------------------------------------------------}

  sSQL_NewWashType = 'Create Table $Table(R_ID $Inc, T_ID varChar(16),' +
       'T_Name varChar(32), T_Py varChar(32), T_Unit varChar(16),' +
       'T_WashType varChar(16), T_Price $Float, T_Memo varChar(100))';
  {-----------------------------------------------------------------------------
   衣物表: WashType
   *.R_ID: 编号
   *.T_ID: 标识
   *.T_Name,T_Py: 名称
   *.T_Unit: 单位
   *.T_WashType: 洗衣类型(干/水)
   *.T_Price: 单件价格
   *.T_Memo: 备注
  -----------------------------------------------------------------------------}

  sSQL_NewWashData = 'Create Table $Table(R_ID $Inc, D_ID varChar(16),' +
       'D_MID varChar(16), D_Number Integer, D_HasNumber Integer,' +
       'D_YSMoney $Float, D_Money $Float, D_HasMoney $Float,' +
       'D_Man varChar(16), D_Date DateTime, D_Memo varChar(100))';
  {-----------------------------------------------------------------------------
   洗衣记录: WashType
   *.R_ID: 编号
   *.D_ID: 标识
   *.D_MID: 会员号
   *.D_Number: 件数
   *.D_HasNumber: 剩余
   *.D_YSMoney: 应收
   *.D_Money: 实收
   *.D_HasMoney: 剩余
   *.D_Man: 收件人
   *.D_Date: 时间
   *.D_Memo: 备注
  -----------------------------------------------------------------------------}

  sSQL_NewWashDetail = 'Create Table $Table(R_ID $Inc, D_ID varChar(16),' +
       'D_TID varChar(16), D_Name varChar(32), D_Py varChar(32), ' +
       'D_Unit varChar(16),D_WashType varChar(16), D_Color varChar(16), ' +
       'D_Number Integer, D_HasNumber Integer,D_Memo varChar(100))';
  {-----------------------------------------------------------------------------
   收衣明细: WashDetail
   *.R_ID: 编号
   *.D_ID: 上架号
   *.D_TID: 类型号
   *.D_Name: 名称
   *.D_Py: 拼音
   *.D_Unit: 单位
   *.D_WashType: 干/水
   *.D_Number: 数量
   *.D_HasNumber: 剩余
   *.D_Color: 颜色
   *.D_Memo: 备注
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
  AddSysTableItem(sTable_SerialBase, sSQL_NewSerialBase);

  AddSysTableItem(sTable_Member, sSQL_NewMember);
  AddSysTableItem(sTable_InOutMoney, sSQL_NewInOutMoney);
  AddSysTableItem(sTable_WashType, sSQL_NewWashType);
  AddSysTableItem(sTable_WashData, sSQL_NewWashData);
  AddSysTableItem(sTable_WashDetail, sSQL_NewWashDetail);
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


