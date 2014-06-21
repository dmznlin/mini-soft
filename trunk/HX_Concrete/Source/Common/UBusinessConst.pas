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


