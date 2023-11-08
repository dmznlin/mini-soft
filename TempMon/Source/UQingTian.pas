{*******************************************************************************
  ����: dmzn@163.com 2023-11-06
  ����: ͬ�� ���������ؿ˿Ƽ����޹�˾ ����������������
*******************************************************************************}
unit UQingTian;

interface

uses
  System.Classes, System.SysUtils, IdBaseComponent, IdComponent,
  IdTCPConnection, IdHTTP, ULibFun, UWaitItem, UManagerGroup, USysConst;

type
  TDataSync = class(TThread)
  private
    FHttp: TIdHTTP;
    {*http client*}
    FWaiter: TWaitObject;
    {*�ȴ�����*}
  protected
    procedure DoSync;
    procedure Execute; override;
    {*ִ���ػ�*}
  public
    constructor Create();
    destructor Destroy; override;
    {*�����ͷ�*}
    procedure Wakeup;
    {*�����߳�*}
    procedure StopMe;
    {*ֹͣ�߳�*}
  end;

implementation

procedure WriteLog(const nEvent: string);
begin
  gMG.FLogManager.AddLog(TDataSync, '����ͬ��', nEvent);
end;

//------------------------------------------------------------------------------
constructor TDataSync.Create;
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FWaiter := TWaitObject.Create();
  FWaiter.Interval := gSystemParam.FFreshRate * 1000;
end;

destructor TDataSync.Destroy;
begin
  FreeAndNil(FWaiter);
  inherited;
end;

procedure TDataSync.StopMe;
begin
  Terminate;
  FWaiter.Wakeup();

  WaitFor;
  Free;
end;

procedure TDataSync.Wakeup;
begin
  FWaiter.Wakeup();
end;

procedure TDataSync.Execute;
var nStr: string;
begin
  FHttp := TIdHTTP.Create(nil);
  with FHttp, gSystemParam do
  begin
    Request.CustomHeaders.Clear;
    Request.CustomHeaders.AddValue('app_id', FAppID);
    Request.CustomHeaders.AddValue('app_key', FAppKey);

    nStr := TEncodeHelper.EncodeMD5(FAppID + '&' + FAppKey);
    Request.CustomHeaders.AddValue('sign', UpperCase(nStr));
    Request.ContentType := FContentType;
  end;

  while not Terminated do
  try
    DoSync;
    FWaiter.EnterWait;
  except
    on nErr: Exception do
    begin
      WriteLog(nErr.Message);
    end;
  end;

  FreeAndNil(FHttp);
end;

procedure TDataSync.DoSync;
var nXML: string;
begin
  nXML := FHttp.Get(gSystemParam.FServerURI + '/app/hm/h001/deviceDataList');
  WriteLog(nXML);
end;

end.
