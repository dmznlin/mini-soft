{*******************************************************************************
  作者: dmzn@163.com 2011-10-22
  描述: 客户端业务处理工作对象
*******************************************************************************}
unit UClientWorker;

interface

uses
  Windows, SysUtils, Classes, UMgrChannel, UBusinessWorker, UBusinessConst,
  UBusinessPacker, ULibFun;

type
  TClient2MITWorker = class(TBusinessWorkerBase)
  protected
    FListA,FListB: TStrings;
    //字符列表
    procedure WriteLog(const nEvent: string);
    //记录日志
    function ErrDescription(const nCode,nDesc: string;
      const nInclude: TDynamicStrArray): string;
    //错误描述
    function MITWork(var nData: string): Boolean;
    //执行业务
    function GetFixedServiceURL: string; virtual;
    //固定地址
  public
    constructor Create; override;
    destructor destroy; override;
    //创建释放
    function DoWork(const nIn, nOut: Pointer): Boolean; override;
    //执行业务
  end;

  TClientBusinessCommand = class(TClient2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TClientQueueStatus = class(TClient2MITWorker)
  public
    function GetFixedServiceURL: string; override;
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

resourcestring
  sParam_NoHintOnError     = '##';

implementation

uses
 UFormWait, Forms, USysLoger, USysConst, USysDB, MIT_Service_Intf;

//Date: 2012-3-11
//Parm: 日志内容
//Desc: 记录日志
procedure TClient2MITWorker.WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(ClassType, '客户业务对象', nEvent);
end;

constructor TClient2MITWorker.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  inherited;
end;

destructor TClient2MITWorker.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  inherited;
end;

//Date: 2012-3-11
//Parm: 入参;出参
//Desc: 执行业务并对异常做处理
function TClient2MITWorker.DoWork(const nIn, nOut: Pointer): Boolean;
var nStr: string;
    nParam: string;
    nArray: TDynamicStrArray;
begin
  with PBWDataBase(nIn)^,gSysParam do
  begin
    nParam := FParam;
    FPacker.InitData(nIn, True, False);

    with FFrom do
    begin
      FUser   := FUserID;
      FIP     := FLocalIP;
      FMAC    := FLocalMAC;
      FTime   := Now;
      FKpLong := GetTickCount;
    end;
  end;

  nStr := FPacker.PackIn(nIn);
  Result := MITWork(nStr);

  if not Result then
  begin
    if Pos(sParam_NoHintOnError, nParam) < 1 then
    begin
      CloseWaitForm;
      Application.ProcessMessages;
      ShowDlg(nStr, sHint, Screen.ActiveForm.Handle);
    end else PBWDataBase(nOut)^.FErrDesc := nStr;
    
    Exit;
  end;

  FPacker.UnPackOut(nStr, nOut);
  with PBWDataBase(nOut)^ do
  begin
    nStr := 'User:[ %s ] FUN:[ %s ] SAP:[ %s ] KP:[ %d ]';
    nStr := Format(nStr, [gSysParam.FUserID, FunctionName, FFinal.FIP,
            GetTickCount - FWorkTimeInit]);
    WriteLog(nStr);

    Result := FResult;
    if Result then
    begin
      if FErrCode = sFlag_ForceHint then
      begin
        nStr := '业务执行成功,提示信息如下: ' + #13#10#13#10 + FErrDesc;
        ShowDlg(nStr, sWarn, Screen.ActiveForm.Handle);
      end;
      Exit;
    end;

    if Pos(sParam_NoHintOnError, nParam) < 1 then
    begin
      CloseWaitForm;
      Application.ProcessMessages;
      SetLength(nArray, 0);

      nStr := '业务在服务器上执行异常,描述如下: ' + #13#10#13#10 +

              ErrDescription(FErrCode, FErrDesc, nArray) +

              '请检查输入参数、操作是否有效,或联系管理员!' + #32#32#32;
      ShowDlg(nStr, sWarn, Screen.ActiveForm.Handle);
    end;
  end;
end;

//Date: 2012-3-20
//Parm: 代码;描述
//Desc: 格式化错误描述
function TClient2MITWorker.ErrDescription(const nCode, nDesc: string;
  const nInclude: TDynamicStrArray): string;
var nIdx: Integer;
begin
  FListA.Text := StringReplace(nCode, #9, #13#10, [rfReplaceAll]);
  FListB.Text := StringReplace(nDesc, #9, #13#10, [rfReplaceAll]);

  if FListA.Count <> FListB.Count then
  begin
    Result := '※.代码: ' + nCode + #13#10 +
              '   描述: ' + nDesc + #13#10#13#10;
  end else Result := '';

  for nIdx:=0 to FListA.Count - 1 do
  if (Length(nInclude) = 0) or (StrArrayIndex(FListA[nIdx], nInclude) > -1) then
  begin
    Result := Result + '※.代码: ' + FListA[nIdx] + #13#10 +
                       '   描述: ' + FListB[nIdx] + #13#10#13#10;
  end;
end;

//Desc: 强制指定服务地址
function TClient2MITWorker.GetFixedServiceURL: string;
begin
  Result := '';
end;

//Date: 2012-3-9
//Parm: 入参数据
//Desc: 连接MIT执行具体业务
function TClient2MITWorker.MITWork(var nData: string): Boolean;
var nChannel: PChannelItem;
begin
  Result := False;
  nChannel := nil;
  try
    nChannel := gChannelManager.LockChannel(cBus_Channel_Business);
    if not Assigned(nChannel) then
    begin
      nData := '连接MIT服务失败(BUS-MIT No Channel).';
      Exit;
    end;

    with nChannel^ do
    try
      if not Assigned(FChannel) then
        FChannel := CoSrvBusiness.Create(FMsg, FHttp);
      //xxxxx

      if GetFixedServiceURL = '' then
           FHttp.TargetURL := gSysParam.FURL_MIT
      else FHttp.TargetURL := GetFixedServiceURL;

      Result := ISrvBusiness(FChannel).Action(GetFlagStr(cWorker_GetMITName),
                                              nData);
      //call mit funciton
    except
      on E:Exception do
      begin
        nData := Format('%s(BY %s ).', [E.Message, gSysParam.FLocalName]);
        WriteLog('Function:[ ' + FunctionName + ' ]' + E.Message);
      end;
    end;
  finally
    gChannelManager.ReleaseChannel(nChannel);
  end;
end;

//------------------------------------------------------------------------------
class function TClientBusinessCommand.FunctionName: string;
begin
  Result := sCLI_BusinessCommand;
end;

function TClientBusinessCommand.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
   cWorker_GetMITName    : Result := sBus_BusinessCommand;
  end;
end;

//------------------------------------------------------------------------------
class function TClientQueueStatus.FunctionName: string;
begin
  Result := sCLI_RemoteQueue;
end;

function TClientQueueStatus.GetFixedServiceURL: string;
begin
  Result := gSysParam.FRemoteURL;
end;

function TClientQueueStatus.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
   cWorker_GetMITName    : Result := sBus_BusinessCommand;
  end;
end;

initialization
  gBusinessWorkerManager.RegisteWorker(TClientBusinessCommand);
  gBusinessWorkerManager.RegisteWorker(TClientQueueStatus);
end.
