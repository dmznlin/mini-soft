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

  sFlag_CaiZhi        = 'C';                         //材质
  sFlag_DanWei        = 'D';                         //单位
  sFlag_GuiGe         = 'G';                         //规格

  sFlag_BeiPin        = 'B';                         //备品备件
  sFalg_CaiLiao       = 'C';                         //生产材料

  sFlag_NInNOut       = 'I';                         //先进先出
  sFlag_NInBOut       = 'O';                         //先进后出

  sFlag_CommonItem    = 'CommonItem';                //公共信息
  sFlag_DepartItem    = 'DepartItem';                //部门信息项
  sFlag_StorageItem   = 'StorageItem';               //仓位信息项
  sFlag_ProviderItem  = 'ProviderItem';              //供应商信息
  sFlag_GoodsTpItem   = 'GoodsTypeItem';             //分类信息项

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

  sTable_Unit         = 'K_Unit';                    //规格材质
  sTable_Department   = 'K_Department';              //部门单位
  sTable_Storage      = 'K_Storage';                 //仓库仓位
  sTable_Provider     = 'K_Provider';                //供应商
  sTable_ProvideDtl   = 'K_ProvideDtl';              //供应明细

  sTable_GoodsType    = 'K_GoodsType';               //物品分类
  sTable_Goods        = 'K_Goods';                   //物品信息
  sTable_Weeks        = 'K_Weeks';                   //采购周期
  sTable_BuyReq       = 'K_BuyReq';                  //采购申请
  sTable_BuyPlan      = 'K_BuyPlan';                 //采购计划

  sTable_YuanLiao     = 'K_YuanLiao';                //原料入库
  sTable_BeiPin       = 'K_BeiPin';                  //备品入库
  sTable_ChuKu        = 'K_ChuKu';                   //物品出库
  sTable_ChuKuDtl     = 'K_ChuKuDtl';                //出库明细
  sTable_KuCun        = 'K_KuCun';                   //库存盘点
  sTable_KuCunTmp     = 'K_KuCunTemp';               //临时库存

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

  sSQL_NewUnit = 'Create Table $Table(R_ID $Inc, U_Name varChar(32),' +
       'U_PY varChar(32), U_Type Char(1))';
  {-----------------------------------------------------------------------------
   规格材质: Unit
   *.R_ID: 编号
   *.U_Name: 名称
   *.U_PY: 拼音
   *.U_Type: 类型(D,规格,C材质)
  -----------------------------------------------------------------------------}

  sSQL_NewDepartment = 'Create Table $Table(R_ID $Inc, D_ID varChar(15),' +
       'D_Name varChar(52), D_PY varChar(54), D_Parent varChar(15),' +
       'D_Owner varChar(32), D_Phone varChar(22))';
  {-----------------------------------------------------------------------------
   部门单位: Department
   *.D_ID: 编号
   *.D_Name: 名称
   *.D_PY: 拼音
   *.D_Parent: 父单位
   *.D_Owner: 主管
   *.D_Phone: 电话
  -----------------------------------------------------------------------------}

  sSQL_NewStorage = 'Create Table $Table(R_ID $Inc, S_ID varChar(15),' +
       'S_Name varChar(52), S_PY varChar(52), S_Parent varChar(15),' +
       'S_Owner varChar(32), S_Phone varChar(22))';
  {-----------------------------------------------------------------------------
   仓库仓位: Storage
   *.S_ID: 编号
   *.S_Name: 名称
   *.S_PY: 拼音
   *.S_Parent: 父仓库
   *.S_Owner: 保管员
   *.S_Phone: 电话
  -----------------------------------------------------------------------------}

  sSQL_NewProvider = 'Create Table $Table(R_ID $Inc, P_ID varChar(15),' +
       'P_Name varChar(52), P_PY varChar(52), P_Owner varChar(32),' +
       'P_Phone varChar(22), P_Fax varChar(22), P_Addr varChar(100))';
  {-----------------------------------------------------------------------------
   供应厂商: Provider
   *.P_ID: 编号
   *.P_Name: 名称
   *.P_PY: 拼音
   *.P_Owner: 联系人
   *.P_Phone: 电话
   *.P_Fax:传真
   *.P_Addr: 厂址
  -----------------------------------------------------------------------------}

  sSQL_NewProvideDtl = 'Create Table $Table(R_ID $Inc, D_PID varChar(15),' +
       'D_Goods varChar(15), D_Valid Char(1) Default ''Y'')';
  {-----------------------------------------------------------------------------
   供应厂商: Provider
   *.R_ID: 编号
   *.D_PID: 供应商
   *.D_Goods: 物品
   *.D_Valid: 有效(Y,N)
  -----------------------------------------------------------------------------}

  sSQL_NewGoodsType = 'Create Table $Table(R_ID $Inc, T_ID varChar(15),' +
       'T_Name varChar(32), T_Parent varChar(15))';
  {-----------------------------------------------------------------------------
   物品分类: GoodsType
   *.T_ID: 编号
   *.T_Name: 名称
   *.T_Parent: 父类
  -----------------------------------------------------------------------------}

  sSQL_NewGoods = 'Create Table $Table(R_ID $Inc, G_ID varChar(15),' +
       'G_Name varChar(52), G_PY varChar(52), G_CaiZhi varChar(32),' +
       'G_GuiGe varChar(32), G_Unit varChar(32), G_Type Char(1),' +
       'G_GType varChar(100), G_Storage varChar(15), G_OutStyle Char(1))';
  {-----------------------------------------------------------------------------
   物品: Storage
   *.G_ID: 编号
   *.G_Name: 名称
   *.G_PY: 拼音
   *.G_CaiZhi: 材质
   *.G_GuiGe: 规格
   *.G_Unit: 单位
   *.G_Type: 类型(备品,材料)
   *.G_GType: 物品分类
   *.G_Storage: 仓位
   *.G_OutStyle: 出仓规则(先进先出..)
  -----------------------------------------------------------------------------}

  sSQL_NewWeeks = 'Create Table $Table(W_ID $Inc, W_NO varChar(15),' +
       'W_Name varChar(50), W_Begin DateTime, W_End DateTime,' +
       'W_Man varChar(32), W_Date DateTime, W_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   采购周期:Weeks
   *.W_ID:记录编号
   *.W_NO:周期编号
   *.W_Name:名称
   *.W_Begin:开始
   *.W_End:结束
   *.W_Man:创建人
   *.W_Date:创建时间
   *.W_Memo:备注信息
  -----------------------------------------------------------------------------}

  sSQL_NewBuyReq = 'Create Table $Table(R_ID $Inc, R_Week varChar(15),' +
       'R_Department varChar(15), R_Goods varChar(15), R_Num $Float Default 0,' +
       'R_Date DateTime, R_Man varChar(32), R_Memo varChar(100))';
  {-----------------------------------------------------------------------------
   采购申请:BuyReq
   *.R_ID:记录编号
   *.R_Week:周期编号
   *.R_Department:部门
   *.R_Goods:物品
   *.R_Num:申请量
   *.R_Date:申请时间
   *.R_Man:申请人
   *.R_Memo:备注信息
  -----------------------------------------------------------------------------}

  sSQL_NewBuyPlan = 'Create Table $Table(P_ID $Inc, P_Week varChar(15),' +
       'P_Goods varChar(15), P_Num $Float Default 0, P_Has $Float Default 0,' +
       'P_Done $Float Default 0, P_Man varChar(32), P_Date DateTime)';
  {-----------------------------------------------------------------------------
   采购计划:BuyPlan
   *.P_ID:记录编号
   *.P_Week:周期编号
   *.P_Goods:物品
   *.P_Num:数目
   *.P_Has:库存
   *.P_Done:完成量
   *.P_Man:创建人
   *.P_Date:创建时间
  -----------------------------------------------------------------------------}

  sSQL_NewYuanLiao = 'Create Table $Table(R_ID $Inc, Y_Week varChar(15),' +
       'Y_Goods varChar(15), Y_GuiGe varChar(32), Y_Unit varChar(32),' +
       'Y_Provider varChar(15), Y_Storage varChar(15), Y_Num $Float,' +
       'Y_Price $Float, Y_Memo varChar(100), Y_Man varChar(32), Y_Date DateTime)';
  {-----------------------------------------------------------------------------
   物品: YuanLiao
   *.R_ID: 编号
   *.Y_Week:周期
   *.Y_Goods: 物品
   *.Y_GuiGe: 规格
   *.Y_Unit: 单位
   *.Y_Provider: 供应商
   *.Y_Storage: 仓位
   *.Y_Num,Y_Price:数量单价
   *.Y_Memo: 备注信息
   *.Y_Man,Y_Date: 入库人
  -----------------------------------------------------------------------------}

  sSQL_NewBeiPin = 'Create Table $Table(R_ID $Inc, B_Week varChar(15),' +
       'B_Goods varChar(15), B_Serial varChar(32), B_TuNo varChar(32),' +
       'B_CaiZhi varChar(32), B_GuiGe varChar(32), B_Unit varChar(32),' +
       'B_Provider varChar(15), B_Storage varChar(15), B_Num $Float,' +
       'B_Price $Float, B_PerZ $Float, B_Memo varChar(100), B_Man varChar(32),'+
       'B_Date DateTime)';
  {-----------------------------------------------------------------------------
   物品: BeiPin
   *.R_ID: 编号
   *.B_Week: 周期
   *.B_Goods: 物品
   *.B_Serial:编号
   *.B_TuNo:图号
   *.B_CaiZhi:材质
   *.B_GuiGe: 规格
   *.B_Unit: 单位
   *.B_Provider: 供应商
   *.B_Storage: 仓位
   *.B_Num,Y_Price:数量单价
   *.B_PerZ: 单重
   *.B_Memo: 备注信息
   *.B_Man,B_Date: 入库人
  -----------------------------------------------------------------------------}

  sSQL_NewChuKU = 'Create Table $Table(R_ID $Inc, C_Goods varChar(15),' +
       'C_GType Char(1), C_Depart varChar(15), C_Num $Float, '+
       'C_Memo varChar(100), C_Man varChar(32), C_Date DateTime)';
  {-----------------------------------------------------------------------------
   物品: ChuKu
   *.R_ID: 编号
   *.C_Goods: 物品
   *.C_GType: 类型
   *.C_Depart: 部门
   *.C_Num:数量
   *.C_Memo:备注
   *.C_Man,C_Date: 入库人
  -----------------------------------------------------------------------------}

  sSQL_NewChuKuDtl = 'Create Table $Table(R_ID $Inc, D_CID varChar(15),' +
       'D_RID varChar(15), D_RWeek varChar(15), D_RStorage varChar(15),' +
       'D_Goods varChar(15), D_Num $Float)';
  {-----------------------------------------------------------------------------
   物品: ChuKuDtl
   *.R_ID: 编号
   *.D_CID: 出库记录号
   *.D_RID: 入库记录号
   *.D_RWeek: 入库周期
   *.D_RStorage: 入库仓位
   *.D_Goods: 物品编号
   *.D_Num: 出库数量
  -----------------------------------------------------------------------------}

  sSQL_NewKuCun = 'Create Table $Table(R_ID $Inc, K_Goods varChar(15),' +
       'K_Storage varChar(15), K_RuKu $Float Default 0,' +
       'K_ChuKu $Float Default 0, K_Man varChar(32), K_Date DateTime)';
  {-----------------------------------------------------------------------------
   物品: BeiPin
   *.R_ID: 编号
   *.K_Goods: 物品
   *.K_Storage: 仓位
   *.K_RuKu:入库量
   *.K_ChuKu:出库量
   *.K_Man,K_Date:盘库人
  -----------------------------------------------------------------------------}

//------------------------------------------------------------------------------
// 数据查询
//------------------------------------------------------------------------------
  sQuery_SysDict = 'Select D_ID, D_Value, D_Memo From $Table ' +
                   'Where D_Name=''$Name'' Order By D_Index ASC';
  {-----------------------------------------------------------------------------
   从数据字典读取数据
   *.$Table:数据字典表
   *.$Name:字典项名称
  -----------------------------------------------------------------------------}

  sQuery_ExtInfo = 'Select I_ID, I_Item, I_Info From $Table Where ' +
                   'I_Group=''$Group'' and I_ItemID=''$ID'' Order By I_Index Desc';
  {-----------------------------------------------------------------------------
   从扩展信息表读取数据
   *.$Table:扩展信息表
   *.$Group:分组名称
   *.$ID:信息标识
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

  AddSysTableItem(sTable_Unit, sSQL_NewUnit);
  AddSysTableItem(sTable_Department, sSQL_NewDepartment);
  AddSysTableItem(sTable_Storage, sSQL_NewStorage);

  AddSysTableItem(sTable_Provider, sSQL_NewProvider);
  AddSysTableItem(sTable_ProvideDtl, sSQL_NewProvideDtl);

  AddSysTableItem(sTable_GoodsType, sSQL_NewGoodsType);
  AddSysTableItem(sTable_Goods, sSQL_NewGoods);
  AddSysTableItem(sTable_Weeks, sSQL_NewWeeks);
  AddSysTableItem(sTable_BuyReq, sSQL_NewBuyReq);
  AddSysTableItem(sTable_BuyPlan, sSQL_NewBuyPlan);

  AddSysTableItem(sTable_YuanLiao, sSQL_NewYuanLiao);
  AddSysTableItem(sTable_BeiPin, sSQL_NewBeiPin);
  AddSysTableItem(sTable_ChuKu, sSQL_NewChuKU);
  AddSysTableItem(sTable_ChuKuDtl, sSQL_NewChuKuDtl);

  AddSysTableItem(sTable_KuCun, sSQL_NewKuCun);
  AddSysTableItem(sTable_KuCunTmp, sSQL_NewKuCun);
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


