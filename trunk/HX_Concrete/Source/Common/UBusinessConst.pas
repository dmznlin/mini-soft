{*******************************************************************************
  作者: dmzn@163.com 2012-02-03
  描述: 业务常量定义

  备注:
  *.所有In/Out数据,最好带有TBWDataBase基数据,且位于第一个元素.
*******************************************************************************}
unit UBusinessConst;

interface

const
  {*channel type*}
  cBus_Channel_Connection     = $0002;
  cBus_Channel_Business       = $0005;

  {*worker action code*}
  cWorker_GetPackerName       = $0010;
  cWorker_GetMITName          = $0012;

  {*business command*}
  cBC_RemoteExecSQL           = $0055;

type
  TBWWorkerInfo = record
    FUser   : string;              //发起人
    FIP     : string;              //IP地址
    FMAC    : string;              //主机标识
    FTime   : TDateTime;           //发起时间
    FKpLong : Int64;               //消耗时长
  end;

  PBWDataBase = ^TBWDataBase;
  TBWDataBase = record
    FWorker   : string;            //封装者
    FFrom     : TBWWorkerInfo;     //源
    FVia      : TBWWorkerInfo;     //经由
    FFinal    : TBWWorkerInfo;     //到达

    FMsgNO    : string;            //消息号
    FKey      : string;            //记录标记
    FParam    : string;            //扩展参数

    FResult   : Boolean;           //执行结果
    FErrCode  : string;            //错误代码
    FErrDesc  : string;            //错误描述
  end;

  PWorkerBusinessCommand = ^TWorkerBusinessCommand;
  TWorkerBusinessCommand = record
    FBase     : TBWDataBase;
    FCommand  : Integer;           //命令
    FData     : string;            //数据
  end;

resourcestring
  {*common function*}
  sSys_SweetHeart             = 'Sys_SweetHeart';       //心跳指令
  sSys_BasePacker             = 'Sys_BasePacker';       //基本封包器

  {*sap mit function name*}
  sSAP_ServiceStatus          = 'SAP_ServiceStatus';    //服务状态
  sSAP_ReadXSSaleOrder        = 'SAP_Read_XSSaleOrder'; //销售订单
  sSAP_ReadZCSaleOrder        = 'SAP_Read_ZCSaleOrder'; //转储订单
  sSAP_CreateSaleBill         = 'SAP_Create_SaleBill';  //创建交货单
  sSAP_ModifySaleBill         = 'SAP_Modify_SaleBill';  //修改交货单
  sSAP_DeleteSaleBill         = 'SAP_Delete_SaleBill';  //删除交货单
  sSAP_PickSaleBill           = 'SAP_Pick_SaleBill';    //拣配交货单
  sSAP_PostSaleBill           = 'SAP_Post_SaleBill';    //过账交货单
  sSAP_ReadSaleBill           = 'SAP_Read_SaleBill';    //读取交货单

  sSAP_PoundReadMatnr         = 'SAP_Pound_ReadMatnr';  //读取物料
  sSAP_PoundReadNew           = 'SAP_Pound_ReadNew';    //称重读取
  sSAP_PoundWeighNew          = 'SAP_Pound_WeighNew';   //称重接口

  {*business mit function name*}
  sBus_ServiceStatus          = 'Bus_ServiceStatus';    //服务状态
  sBus_ReadXSSaleOrder        = 'Bus_Read_XSSaleOrder'; //销售订单
  sBus_ReadZCSaleOrder        = 'Bus_Read_ZCSaleOrder'; //转储订单
  sBus_CreateSaleBill         = 'Bus_Create_SaleBill';  //创建交货单
  sBus_ModifySaleBill         = 'Bus_Modify_SaleBill';  //修改交货单
  sBus_DeleteSaleBill         = 'Bus_Delete_SaleBill';  //删除交货单
  sBus_PickSaleBill           = 'Bus_Pick_SaleBill';    //拣配交货单
  sBus_PostSaleBill           = 'Bus_Post_SaleBill';    //过账交货单
  sBus_ReadSaleBill           = 'Bus_Read_SaleBill';    //读取交货单
  sBus_ReadCRMOrder           = 'Bus_Read_CRMOrder';    //CRM提货单   20130515

  sBus_PoundReadMatnr         = 'Bus_Pound_ReadMatnr';  //读取物料
  sBus_PoundReadNew           = 'Bus_Pound_ReadNew';    //称重读取
  sBus_PoundWeighNew          = 'Bus_Pound_WeighNew';   //称重接口
  sBus_PoundCommand           = 'Bus_Pound_Command';    //称重操作

  sBus_GetQueryField          = 'Bus_GetQueryField';    //查询的字段
  sBus_BusinessCommand        = 'Bus_BusinessCommand';  //业务指令
  sHM_BusinessCommand         = 'HH_BusinessCommand';   //硬件守护

  {*client function name*}
  sCLI_ServiceStatus          = 'CLI_ServiceStatus';    //服务状态
  sCLI_ReadXSSaleOrder        = 'CLI_Read_XSSaleOrder'; //销售订单
  sCLI_ReadZCSaleOrder        = 'CLI_Read_ZCSaleOrder'; //转储订单
  sCLI_ReadCRMOrder           = 'sCLI_Read_CRMOrder';   //CRM提货单   20130515
  sCLI_CreateSaleBill         = 'CLI_Create_SaleBill';  //创建交货单
  sCLI_ModifySaleBill         = 'CLI_Modify_SaleBill';  //修改交货单
  sCLI_DeleteSaleBill         = 'CLI_Delete_SaleBill';  //删除交货单
  sCLI_PickSaleBill           = 'CLI_Pick_SaleBill';    //拣配交货单
  sCLI_PostSaleBill           = 'CLI_Post_SaleBill';    //过账交货单
  sCLI_ReadSaleBill           = 'CLI_Read_SaleBill';    //读取交货单

  sCLI_PoundReadMatnr         = 'CLI_Pound_ReadMatnr';  //读取物料
  sCLI_PoundReadNew           = 'CLI_Pound_ReadNew';    //称重读取
  sCLI_PoundWeighNew          = 'CLI_Pound_WeighNew';   //称重接口

  sCLI_GetQueryField          = 'CLI_GetQueryField';    //查询的字段
  sCLI_BusinessCommand        = 'CLI_BusinessCommand';  //业务指令
  sCLI_PoundCommand           = 'CLI_Pound_Command';    //称重操作
  sCLI_HardwareMonitor        = 'CLI_Hardware_Monitor'; //硬件守护
  sCLI_TruckQueue             = 'CLI_TruckQueue';       //车辆排队

implementation

end.


