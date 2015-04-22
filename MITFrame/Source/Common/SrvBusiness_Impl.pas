{*******************************************************************************
  ����: dmzn@163.com 2012-3-7
  ����: ϵͳҵ����ڶ���
*******************************************************************************}
unit SrvBusiness_Impl;

{$I Link.Inc}
interface

uses
  Classes, SysUtils, uROServer, MIT_Service_Intf;

type
  TSrvBusiness = class(TRORemotable, ISrvBusiness)
  private
    FEvent: string;
    FTaskID: Int64;
    procedure WriteLog(const nLog: string);
  protected
    function Action(const nFunName: AnsiString; var nData: AnsiString): Boolean;
  end;

implementation

uses
  UROModule, UBusinessWorker, UTaskMonitor, USysLoger, UMITConst;

procedure TSrvBusiness.WriteLog(const nLog: string);
begin
  gSysLoger.AddLog(TSrvBusiness, 'ҵ��������', nLog);
end;

//Date: 2012-3-7
//Parm: ������;[in]����,[out]�������
//Desc: ִ����nDataΪ������nFunName����
function TSrvBusiness.Action(const nFunName: AnsiString;
 var nData: AnsiString): Boolean;
var nWorker: TBusinessWorkerBase;
begin
  FEvent := Format('TSrvBusiness.Action( %s )', [nFunName]);
  FTaskID := gTaskMonitor.AddTask(FEvent, 10 * 1000);
  //new task

  nWorker := nil;
  try
    nWorker := gBusinessWorkerManager.LockWorker(nFunName);
    try
      if nWorker.FunctionName = '' then
      begin
        nData := 'Զ�̵���ʧ��(Worker Is Null).';
        Result := False;
        Exit;
      end;

      Result := nWorker.WorkActive(nData);
      //do action

      with ROModule.LockModuleStatus^ do
      try
        FNumBusiness := FNumBusiness + 1;
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
      nData := Format('��Դ: %s,%s' + #13#10 + '����: %s',
               [gSysParam.FAppFlag, gSysParam.FLocalName,
               nWorker.FunctionName]) + #13#10#13#10 + nData;
      //xxxxx
    end;
  finally
    gTaskMonitor.DelTask(FTaskID);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

end.
