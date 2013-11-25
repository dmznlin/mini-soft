{*******************************************************************************
  作者: dmzn@163.com 2012-02-03
  描述: 业务常量定义

  备注:
  *.所有In/Out数据,最好带有TBWDataBase基数据,且位于第一个元素.
*******************************************************************************}
unit UBusinessConst;

interface

uses
  UBusinessPacker;
  
const
  {*channel type*}
  cBus_Channel_Connection     = $0002;
  cBus_Channel_Business       = $0005;

  {*worker action code*}
  cWorker_GetPackerName       = $0010;
  cWorker_GetSAPName          = $0011;
  cWorker_GetRFCName          = $0012;
  cWorker_GetMITName          = $0015;

  {*query field define*}
  cQF_Bill                    = $0001;
  cQF_BillPick                = $0002;
  cQF_BillPost                = $0003;
  cQF_BillCard                = $0004;
  cQF_QueryGuard              = $0005;
  cQF_QueryLadingSan          = $0006;
  cQF_QueryLadingDai          = $0007;
  cQF_QueryPound              = $0008;
  cQF_QuerySaleDtl            = $0009;
  cQF_QuerySaleTotal          = $0010;
  cQF_QueryTruck              = $0011;

  {*business command*}
  cBC_ReadBillInfo            = $0001;
  cBC_ReadOrderInfo           = $0002;
  cBC_ReadTruckInfo           = $0003;

  cBC_LoadMaterails           = $0021;
  cBC_SavePoundData           = $0022;
  cBC_GetPostBills            = $0023;
  cBC_SavePostBills           = $0025;
  cBC_SaveBillCard            = $0026;
  cBC_LogoutBillCard          = $0028;
  cBC_DeletePoundLog          = $0029;

  cBC_GetPoundCard            = $0050;
  cBC_GetQueueData            = $0051;
  cBC_SaveCountData           = $0052;
  cBC_RemoteExecSQL           = $0055;
  cBC_PrintCode               = $0056;
  cBC_PrinterEnable           = $0057;
  cBC_PrintFixCode            = $0058;

  cBC_JSStart                 = $0060;
  cBC_JSStop                  = $0061;
  cBC_JSPause                 = $0062;
  cBC_JSGetStatus             = $0063;

type
  PReadXSSaleOrderIn = ^TReadXSSaleOrderIn;
  TReadXSSaleOrderIn = record
    FBase  : TBWDataBase;          //基础数据
    FVBELN : string;               //销售订单号
    FVSTEL : string;               //装运点,接收点
  end;

  PReadXSSaleOrderOut = ^TReadXSSaleOrderOut;
  TReadXSSaleOrderOut = record
    FBase     : TBWDataBase;
    FVBELN    : string;            //销售订单号
    FAUART    : string;            //销售凭证类型
    FBEZEI    : string;            //类型描述
    FVKORG    : string;            //销售组织
    FVTEXT    : string;            //销售组织描述
    FKUNNR_AG : string;            //售达方
    FNAME1_AG : string;            //售达方描述
    FKUNNR_WE : string;            //送达方
    FNAME1_WE : string;            //送达方描述
    FVBELN_CT : string;            //运输合同号
    FLIFNR_CT : string;            //运输供应商
    FNAME1_CT : string;            //供应商名称
    FOTHER_MG : string;            //其它信息

    FPOSNR    : string;            //订单项目号
    FWERKS    : string;            //工厂
    FNAME1    : string;            //工厂名称
    FVSTEL    : string;            //装运点
    FVTEXT_1  : string;            //装运点描述
    FLGORT    : string;            //库存地点
    FLGOBE    : string;            //库存地点描述
    FMATNR    : string;            //物料号
    FARKTX    : string;            //物料描述
    FMVGR1    : string;            //物料组1
    FBEZEI_1  : string;            //物料类型
    FKWMENG   : Double;            //累计订单数量
    FRFMNG    : Double;            //已提数量
    FWTSL     : Double;            //未提数量
    FKYSL     : Double;            //可用数量
    FVSART    : string;            //转运类型编号
    FBEZEI_VT : string;            //装运类型的描述
  end;

  PReadCRMOrderIn = ^TReadCRMOrderIn;                   // {* 20130515
  TReadCRMOrderIn = record
    FBase  : TBWDataBase;          //基础数据
    FCRM   : string;               //CRM提货单号
  end;

  PReadCRMOrderOut =^TReadCRMOrderOut;
  TReadCRMOrderOut = record
    FBase  : TBWDataBase;
    FVBELN : string;               //订单号
    FTRUCK : string;               //车号
    FValue : Double;               //数量
  end;                                                 // crm电子委托单 *}

  PReadZCSaleOrderIn = ^TReadZCSaleOrderIn;
  TReadZCSaleOrderIn = record
    FBase  : TBWDataBase;          //基础数据
    FVBELN : string;               //销售订单号
    FVSTEL : string;               //装运点,接收点
  end;

  PReadZCSaleOrderOut = ^TReadZCSaleOrderOut;
  TReadZCSaleOrderOut = record
    FBase     : TBWDataBase;
    FVBELN    : string;            //转储订单号
    FBSART    : string;            //凭证类型
    FBATXT    : string;            //凭证类型的简短描述
    FLIFNR    : string;            //供应商
    FNAME1    : string;            //供应商描述
    FKUNNR_WE : string;            //送达方
    FNAME1_WE : string;            //送达方描述
    FVBELN_CT : string;            //运输合同号
    FLIFNR_CT : string;            //运输供应商
    FNAME1_CT : string;            //供应商名称
    FOTHER_MG : string;            //运输信息

    FPOSNR    : string;            //转储订单项目号
    FWERKS    : string;            //工厂
    FNAME1_1  : string;            //工厂名称
    FVSTEL    : string;            //装运点/接收点
    FVTEXT    : string;            //装运点描述
    FLGORT    : string;            //库存地点
    FLGOBE    : string;            //库存地点描述
    FWERKS_J  : string;            //交货工厂
    FNAME1_J  : string;            //交货工厂描述
    FMATNR    : string;            //物料号
    FTXZ01    : string;            //物料描述
    FMENGE    : Double;            //订单数量
    FYTSL     : Double;            //已提数量
    FWTSL     : Double;            //未提数量
    FVSART    : string;            //装运类型
    FBEZEI_VT : string;            //装运类型描述
  end;

  PWorkerCreateBillIn = ^TWorkerCreateBillIn;
  TWorkerCreateBillIn = record
    FBase     : TBWDataBase;       //基础数据
    FType     : string;            //类型(销售,转储)
    FOrder    : string;            //读取订单内容
    
    FVBELN    : string;            //销售订单号
    FVSTEL    : string;            //装运点,接收点
    FLFIMG    : string;            //交货量
    FKDMAT    : string;            //车船号
    FSDABW    : string;            //客户类型
    FLGORT    : string;            //库存地点
    FSeal     : string;            //封签号
    FIsVIP    : string;            //VIP单
    FCRM      : string;            //CRM单号                            20130517
  end;

  PWorkerCreateBillOut = ^TWorkerCreateBillOut;
  TWorkerCreateBillOut = record
    FBase     : TBWDataBase;
    FVBELN    : string;            //交货单号
    FBOLNR    : string;            //出厂编号
    FLFART    : string;            //交货单类型       *tanxin 2013-03-21
  end;

  PWorkerModifyBillIn = ^TWorkerModifyBillIn;
  TWorkerModifyBillIn = record
    FBase     : TBWDataBase;
    FVBELN    : string;            //交货单号
    FLFIMG    : string;            //交货量
    FKDMAT    : string;            //车船号
    FBOLNR    : string;            //出厂编号
    FSeal     : string;            //封签号
  end;

  PWorkerDeleteBillIn = ^TWorkerDeleteBillIn;
  TWorkerDeleteBillIn = record
    FBase     : TBWDataBase;
    FVBELN    : string;            //交货单号
  end;

  PWorkerPickBillIn = ^TWorkerPickBillIn;
  TWorkerPickBillIn = record
    FBase     : TBWDataBase;
    FVBELN    : string;            //交货单号
    FLFIMG    : string;            //拣配数量
    FType     : string;            //类型(D,S)
    FPValue   : string;
    FMValue   : string;            //皮,毛重
  end;

  PWorkerPickBillOut = ^TWorkerPickBillOut;
  TWorkerPickBillOut = record
    FBase     : TBWDataBase;
    FVBELN    : string;            //交货单号
    FKODAT    : string;            //拣配日期
    FKOUHR    : string;            //领货时间
    FLFIMG    : string;            //拣配数量        *tanxin 2013-03-25
  end;

  PWorkerPostBillIn = ^TWorkerPostBillIn;
  TWorkerPostBillIn = record
    FBase     : TBWDataBase;
    FData     : string;            //过账数据
  end;

  PWorkerPostBillOut = ^TWorkerPostBillOut;
  TWorkerPostBillOut = record
    FBase     : TBWDataBase;
    FData     : string;            //过账结果
  end;

  PWorkerReadMatnrOut = ^TWorkerReadMatnrOut;
  TWorkerReadMatnrOut = record
    FBase     : TBWDataBase;
    FMatnr    : string;            //物料列表
  end;

  PWorkerPoundReadNewIn = ^TWorkerPoundReadNewIn;
  TWorkerPoundReadNewIn = record
    FBase     : TBWDataBase;
    FVBELN    : string;            //凭证号码
  end;

  PWorkerPoundReadNewOut = ^TWorkerPoundReadNewOut;
  TWorkerPoundReadNewOut = record
    FBase     : TBWDataBase;
    FMSG      : string;            //结果标识
    FMSG_TEXT : string;            //结果描述
    FZRETURN  : string;            //结果数据
  end;

  PWorkerPoundWeighNewIn = ^TWorkerPoundWeighNewIn;
  TWorkerPoundWeighNewIn = record
    FBase     : TBWDataBase;
    FIMODE    : string;            //U,写;R读;D,删
    FWEIGITEM : string;            //称重记录组
    FWEIID    : string;            //称重编号组
  end;

  PWorkerPoundWeighNewOut = ^TWorkerPoundWeighNewOut;
  TWorkerPoundWeighNewOut = record
    FBase     : TBWDataBase;
    FOFLAG    : string;            //结果标识
    FWEIGITEM : string;            //称重记录组
    FLOG      : string;            //处理结果组
  end;

  PWorkerQueryFieldData = ^TWorkerQueryFieldData;
  TWorkerQueryFieldData = record
    FBase     : TBWDataBase;
    FType     : Integer;           //类型
    FData     : string;            //数据
  end;

  PWorkerBusinessCommand = ^TWorkerBusinessCommand;
  TWorkerBusinessCommand = record
    FBase     : TBWDataBase;
    FCommand  : Integer;           //命令
    FData     : string;            //数据
    FSAPOK    : Boolean;           //SAP网络
  end;

  PWorkerBusinessPound = ^TWorkerBusinessPound;
  TWorkerBusinessPound = record
    FBase     : TBWDataBase;
    FCommand  : Integer;           //指令
    FNewPound : Boolean;           //新称重
    FType     : string;            //称重类型
    FPound    : string;            //称重编号
    
    FCard     : string;            //磁卡号
    FBillID   : string;            //交货单号
    FOrder    : string;            //订单号
    FTruck    : string;            //车牌号
    FTruckID  : string;            //车辆记录
    FCusID    : string;            //客户编号
    FCusName  : string;            //客户名称
    FMType    : string;            //物料类型
    FMID      : string;            //物料编号
    FMName    : string;            //物料名称
    FFactNum  : string;            //工厂代码
    FLimValue : Double;            //票重
    FPValue   : Double;
    FPDate    : string;
    FPMan     : string;            //皮重
    FMValue   : Double;
    FMDate    : string;
    FMMan     : string;            //毛重
    FStation  : string;            //磅站编号
    FDirect   : string;            //方向(进,出)
    FPModel   : string;            //过磅模式
    FStatus   : string;            //状态(皮,毛)
    FSAPOK    : Boolean;           //SAP正常
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


