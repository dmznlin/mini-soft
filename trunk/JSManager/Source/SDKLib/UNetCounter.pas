{*******************************************************************************
  作者: dmzn@163.com 2014-04-27
  描述: 网络多道计数器接口实现
*******************************************************************************}
unit UNetCounter;

interface

uses
  Windows, Classes, SysUtils, SyncObjs, UMultiJS_Net, USysLoger;

procedure LibraryEntity(const nReason: Integer);
//入口函数

function JSLoadConfig(const nConfigFile: PChar): Boolean; stdcall;
//载入配置
procedure JSServiceStart; stdcall;
procedure JSServiceStop; stdcall;
//启停服务
function JSStart(const nTunnel,nTruck: PChar; const nDaiNum: Integer): Boolean; stdcall;
//添加计数
function JSStop(const nTunnel: PChar): Boolean; stdcall;
//停止计数
function JSStatus(const nStatus: PChar): Integer; stdcall;
//计数状态    

implementation

const
  sLogDir             = 'Logs\';                     //日志目录
  sLogSyncLock        = 'SyncLock_MIT_CommonMIT';    //日志同步锁

var
  gPath: string;
  //模块运行路径
  gStatusList: TStrings = nil;
  gSyncLock: TCriticalSection = nil;
  //计数状态列表

//------------------------------------------------------------------------------
//Date: 2014-04-27
//Desc: 初始化系统对象
procedure InitSystemObjects;
var nBuf: array[0..MAX_PATH-1] of Char;
begin
  gPath := Copy(nBuf, 1, GetModuleFileName(HInstance, nBuf, MAX_PATH));
  gPath := ExtractFilePath(gPath);

  gSysLoger := TSysLoger.Create(gPath + sLogDir, sLogSyncLock);
  //日志管理器

  gStatusList := TStringList.Create;
  gSyncLock := TCriticalSection.Create;
end;

//Date: 2014-04-27
//Desc: 释放系统对象
procedure FreeSystemObjects;
begin
  FreeAndNil(gStatusList);
  FreeAndNil(gSyncLock);
end;

procedure LibraryEntity(const nReason: Integer);
begin
  case nReason of
   DLL_PROCESS_ATTACH : InitSystemObjects;
   DLL_PROCESS_DETACH : FreeSystemObjects;
   DLL_THREAD_ATTACH : IsMultiThread := True;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2014-04-27
//Parm: 配置文件路径
//Desc: 载入计数管理器所需的配置文件
function JSLoadConfig(const nConfigFile: PChar): Boolean;
begin
  Result := False;
  try
    gMultiJSManager.LoadFile(nConfigFile);
    Result := True;
  except
    on E: Exception do
    begin
      gSysLoger.AddLog(TMultiJSManager, '多道计数管理器', E.Message);
    end;
  end;
end;

//Date: 2014-04-28
//Desc: 启动服务
procedure JSServiceStart;
begin
  gMultiJSManager.StartJS;
end;

//Date: 2014-04-28
//Desc: 停止服务
procedure JSServiceStop;
begin
  gMultiJSManager.StopJS;
end;

//Date: 2014-04-27
//Parm: 通道号;车牌号;袋数
//Desc: 向nTunnel发送nTruck.nDaiNum计数
function JSStart(const nTunnel,nTruck: PChar; const nDaiNum: Integer): Boolean;
begin
  Result := gMultiJSManager.AddJS(nTunnel, nTruck, nDaiNum);
end;

//Date: 2014-04-28
//Parm: 通道号
//Desc: 像nTunnel发送停止计数指令
function JSStop(const nTunnel: PChar): Boolean;
begin
  Result := gMultiJSManager.DelJS(nTunnel);
end;

//Date: 2014-04-28
//Parm: 状态结果
//Desc: 获取计数结果,返回有效数据长度
function JSStatus(const nStatus: PChar): Integer;
begin
  gSyncLock.Enter;
  try
    gMultiJSManager.GetJSStatus(gStatusList);
    Result := Length(StrPCopy(nStatus, gStatusList.Text));
  finally
    gSyncLock.Leave;
  end;
end;

end.
