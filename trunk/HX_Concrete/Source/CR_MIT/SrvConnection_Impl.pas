{*******************************************************************************
  作者: dmzn@163.com 2012-3-7
  描述: 连接服务,负责安全认证、心跳等
*******************************************************************************}
unit SrvConnection_Impl;

{$I Link.Inc}
interface

uses
  Classes, SysUtils, uROServer, MIT_Service_Intf;

type
  TSrvConnection = class(TRORemotable, ISrvConnection)
  private
    procedure WriteLog(const nLog: string);
  protected
    function Action(const nFunName: AnsiString; var nData: AnsiString): Boolean;
  end;

implementation

uses
  USysLoger, UROModule, UBusinessWorker, UMITConst;
  
procedure TSrvConnection.WriteLog(const nLog: string);
begin
  gSysLoger.AddLog(TSrvConnection, '连接服务对象', nLog);
end;

//Date: 2012-3-7
//Parm: 函数名;[in]参数,[out]输出数据
//Desc: 执行以nData为参数的nFunName函数
function TSrvConnection.Action(const nFunName: AnsiString;
 var nData: AnsiString): Boolean;
var nWorker: TBusinessWorkerBase;
begin
  nWorker := gBusinessWorkerManager.LockWorker(nFunName);
  try 
    try
      if nWorker.FunctionName = '' then
      begin
        nData := '远程调用失败(Worker Is Null).';
        Result := False;
        Exit;
      end;

      Result := nWorker.WorkActive(nData);
      //do action

      with ROModule.LockModuleStatus^ do
      try
        FNumConnection := FNumConnection + 1;
      finally
        ROModule.ReleaseStatusLock;
      end;
    except
      on E:Exception do
      begin
        Result := False;
        nData := E.Message;
        WriteLog('Function:[ ' + nFunName + ' ]' + E.Message);

        with ROModule.LockModuleStatus^ do
        try
          FNumActionError := FNumActionError + 1;
        finally
          ROModule.ReleaseStatusLock;
        end;
      end;
    end;

    if (not Result) and (Pos(#10#13, nData) < 1) then
    begin
      {$IFDEF SAPMIT}
      nData := Format('来源: SAPMIT,%s' + #13#10 + '对象: %s',
               [gSysParam.FLocalName, nWorker.FunctionName]) + #13#10#13#10 + nData;
      {$ELSE}
      nData := Format('来源: BusMIT,%s' + #13#10 + '对象: %s',
               [gSysParam.FLocalName, nWorker.FunctionName]) + #13#10#13#10 + nData;
      {$ENDIF}
    end;
  finally
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

end.
