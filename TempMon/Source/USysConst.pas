{*******************************************************************************
  作者: dmzn@163.com 2023-11-06
  描述: 常量定义
*******************************************************************************}
unit USysConst;

interface

type
  TParamConfig = record
    FChanged: Boolean; //已改动
    FAutoRun: Boolean; //自启动
    FAutoHide: Boolean; //启动后隐藏
    FAdminPwd: string;  //管理密码

    FServerURI: string;  //青天服务器
    FContentType: string; //ct
    FAppID: string;  //ai
    FAppKey: string;  //ak
    FFreshRate: Integer; //刷新频率(秒)
  end;

var
  gSystemParam: TParamConfig;
  //系统参数

implementation

end.
