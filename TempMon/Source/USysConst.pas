{*******************************************************************************
  作者: dmzn@163.com 2023-11-06
  描述: 常量定义
*******************************************************************************}
unit USysConst;

interface

uses
  System.SysUtils;

const
  {*table name*}
  sTable_QingTian = 'nbheat';
  sTable_Samlee   = 'samlee';
  sTable_Sensor   = 'sensor';

  {*flag define*}
  sFlag_Yes       = 'Y';
  sFlag_No        = 'N';
  sFlag_Hint      = '提示';

  {*image index*}
  sImage_QingTian = 4;
  sImage_Samlee   = 5;

type
  TParamConfig = record
    FChanged     : Boolean;                //已改动
    FAutoRun     : Boolean;                //自启动
    FAutoHide    : Boolean;                //启动后隐藏
    FAdminPwd    : string;                 //管理密码

    FServerURI   : string;                 //青天服务器
    FContentType : string;                 //ct
    FAppID       : string;                 //ai
    FAppKey      : string;                 //ak
    FFreshRateQT : Integer;                //青天刷新频率(秒)
    FFreshRateSL : Integer;                //三丽刷新频率(秒)

    FSamleeServer: string;                 //三丽服务地址
    FSamleeCType : string;                 //ct
  end;

  TDeviceType = (dtQingTian, dtSamlee);
  //设备类型

  TDeviceItem = record
    FType        : TDeviceType;            //设备类型
    FRecord      : string;                 //记录号
    FDevice      : string;                 //设备ID
    FName        : string;                 //设备名称
    FSn          : string;                 //sn
    FPos         : string;                 //安装位置
    FValid       : Boolean;                //是否有效
    FDeleted     : Boolean;                //是否删除
  end;

const
  sDeviceType: array[TDeviceType] of string =('nbheat', 'sltemp');
  //设备类型描述

var
  gSystemParam: TParamConfig;
  //系统参数
  gDevices: array of TDeviceItem;
  //设备清单

function FindDevice(const nID: string): Integer;
//入口函数

implementation

//Date: 2023-11-26
//Parm: 设备ID
//Desc: 检索nID的索引
function FindDevice(const nID: string): Integer;
var nIdx: Integer;
begin
  Result := -1;

  for nIdx := Low(gDevices) to High(gDevices) do
   with gDevices[nIdx] do
    if (not FDeleted) and (CompareText(FDevice, nID) = 0) then
    begin
      Result := nIdx;
      Break;
    end;
end;

end.
