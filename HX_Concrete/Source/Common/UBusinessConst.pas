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
  cBC_RemoteExecSQL           = $0050;
  cBC_ReaderCardIn            = $0052;
  cBC_MakeTruckIn             = $0053;
  cBC_MakeTruckOut            = $0055;
  cBC_MakeTruckCall           = $0056;
  cBC_MakeTruckResponse       = $0057;
  cBC_SaveTruckCard           = $0060;
  cBC_LogoutBillCard          = $0061;
  cBC_LoadQueueTrucks         = $0062;

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

  {*business mit function name*}
  sBus_BusinessCommand        = 'Bus_BusinessCommand';  //业务指令

  {*client function name*}
  sCLI_BusinessCommand        = 'CLI_BusinessCommand';  //业务指令
  sCLI_RemoteQueue            = 'CLI_RemoteQueue';      //业务指令

implementation

end.


