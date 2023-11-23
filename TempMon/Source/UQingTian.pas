{*******************************************************************************
  ����: dmzn@163.com 2023-11-06
  ����: ͬ�� ���������ؿ˿Ƽ����޹�˾ ����������������

  ��ע:
  *. �ĵ�: �����������ƽ̨API˵��(20210115)
*******************************************************************************}
unit UQingTian;

interface

uses
  System.Classes, System.SysUtils, IdBaseComponent, IdComponent, IdTCPConnection,
  IdHTTP, superobject, Winapi.ActiveX, ULibFun, UWaitItem, UManagerGroup,
  USysConst;

type
  TDeviceData = record
    FDevice     : string;                        //�豸ID
    FHeatAcc    : Double;                        //�ۼ�����(kW��h)
    FColdAcc    : Double;                        //�ۼ�����(kW��h)
    FHeat       : Double;                        //�ȹ���(kW)
    FTempIn     : Double;                        //��ˮ�¶�
    FTempOut    : Double;                        //��ˮ�¶�
    FTimeAcc    : Double;                        //�ۼƹ���ʱ��(h)
    FFlowAcc    : Double;                        //�ۼ�����(m3)
    FQflow      : Double;                        //˲ʱ����(m3/h)
    FPressure   : Double;                        //ѹ��(MPa)
    FStatus     : string;                        //״̬��
    FUpTime     : TDateTime;                     //����ʱ��
    FNewUpdate  : Boolean;                       //�Ƿ�������
  end;

  TDataSync = class(TThread)
  private
    FListA: TStrings;
    {*string list*}
    FHttpQingTian: TIdHTTP;
    {*http client*}
    FWaiter: TWaitObject;
    {*time counter*}
    FDevices: array of TDeviceData;
    {*device buffer*}
    FUpdateCounter: Integer;
    {*device update counter*}
  protected
    procedure DoSyncDB;
    function DoSyncQingTian(const nPage, nPageSize: Integer): Boolean;
    procedure DoSync;
    procedure Execute; override;
    {*ִ��ͬ��*}
    function FindDevice(const nID: string): Integer;
    {*�����豸*}
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

  SetLength(FDevices, 0);
  FListA := TStringList.Create;
  FWaiter := TWaitObject.Create();
  FWaiter.Interval := gSystemParam.FFreshRate * 1000;
end;

destructor TDataSync.Destroy;
begin
  FreeAndNil(FWaiter);
  FreeAndNil(FListA);
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

//Date: 2023-11-09
//Parm: �豸id
//Desc: ����nID�豸����
function TDataSync.FindDevice(const nID: string): Integer;
var nIdx: Integer;
begin
  Result := -1;
  //init

  for nIdx := Low(FDevices) to High(FDevices) do
  if FDevices[nIdx].FDevice = nID then
  begin
    Result := nIdx;
    Break;
  end;
end;

procedure TDataSync.Execute;
var nStr: string;
begin
  CoInitialize(nil);
  try
    FHttpQingTian := TIdHTTP.Create(nil);
    with FHttpQingTian, gSystemParam do
    begin
      Request.CustomHeaders.Clear;
      Request.CustomHeaders.AddValue('app_id', FAppID);
      Request.CustomHeaders.AddValue('app_key', FAppKey);

      nStr := TEncodeHelper.EncodeMD5(FAppID + '&' + FAppKey);
      Request.CustomHeaders.AddValue('sign', UpperCase(nStr));
      Request.ContentType := FContentType;
    end;

    DoSync;
    //do sync
  finally
    FreeAndNil(FHttpQingTian);
    CoUninitialize();
  end;
end;


procedure TDataSync.DoSync;
var nPage: Integer;
begin
  while not Terminated do
  begin
    try
      FUpdateCounter := 0;
      nPage := 1;
      //init

      while DoSyncQingTian(nPage, 50) do
        Inc(nPage);
      //sync data

      if FUpdateCounter > 0 then
        DoSyncDB;
      //write db
    except
      on nErr: Exception do
      begin
        WriteLog('ͬ���쳣: ' + nErr.Message);
      end;
    end;

    FWaiter.EnterWait;
    //delay
  end;
end;

//Date: 2023-11-09
//Parm: �����ַ���
//Desc: ��ʽ��nStrΪ��������
function FormatDate(const nStr: string): TDateTime;
var nSet: TFormatSettings;
begin
  nSet := TFormatSettings.Create('en-US');
  //default config

  with nSet do
  begin
    ShortDateFormat:='yyyy/MM/dd';
    DateSeparator  :='/';
    LongTimeFormat :='hh:mm:ss';
    TimeSeparator  :=':';
  end;

  if not TryStrToDateTime(nStr, Result, nSet) then
    Result := Now();
  //xxxxx
end;

//Date: 2023-11-09
//Parm: ��ҳҳ��;��ҳ��С
//Desc: ���µ�nPageҳ������
function TDataSync.DoSyncQingTian(const nPage, nPageSize: Integer): Boolean;
var nStr: string;
    i,nIdx,nLen: Integer;
    nDate: TDateTime;

    nParse: ISuperObject;
    nDataBuf: TSuperArray;
begin
  Result := False;
  nStr := '/app/hm/h001/deviceDataList?pageNo=%d&pageSize=%d';
  nStr := Format(nStr, [nPage, nPageSize]);
  //4.2 ������ѯ�豸��������: ������ѯ�豸�ϱ�ƽ̨����������

  nStr := FHttpQingTian.Get(gSystemParam.FServerURI + nStr);
  nLen := Length(nStr);
  nIdx := -1;

  for i := TStringHelper.cFI to nLen do
  if nStr[i] <> #32 then //����ǰ�˿ո�
  begin
    if nStr[i] = '{' then
      nIdx := i;
    Break;
  end;

  if nIdx < 0 then
  begin
    WriteLog('���������������Чjson����: ' + TEncodeHelper.EncodeBase64(nStr));
    Exit;
  end;

  nParse := SO(nStr);
  nStr := nParse.S['StatusCode'];
  if (nPage > 1) and (nStr  = '400') then Exit; //û�ж����ҳ����

  if nStr <> '200' then
  begin
    WriteLog('��ȡ��������ʧ��: ' + nParse.S['message']);
    Exit;
  end;

  Result := True;
  nDataBuf := nParse['dataList'].AsArray;
  nLen := nDataBuf.Length - 1;

  for i := 0 to nLen do
  begin
    nDate := FormatDate(nDataBuf[i].S['UpdateTime']);
    //last update
    nIdx := FindDevice(nDataBuf[i].S['deviceId']);

    if nIdx >= 0 then
    begin
      if nDate <= FDevices[nIdx].FUpTime then Continue;
      //�����ݲ��账��
    end else
    begin
      nIdx := Length(FDevices);
      SetLength(FDevices, nIdx+1);
      FDevices[nIdx].FDevice := nDataBuf[i].S['deviceId'];
    end;

    with FDevices[nIdx] do
    begin
      Inc(FUpdateCounter);
      FUpTime := nDate;
      FNewUpdate := True;

      FHeatAcc    := nDataBuf[i].D['HeatAcc'];
      FColdAcc    := nDataBuf[i].D['ColdAcc'];
      FHeat       := nDataBuf[i].D['Heat'];
      FTempIn     := nDataBuf[i].D['TempInlet'];
      FTempOut    := nDataBuf[i].D['TempOutlet'];
      FTimeAcc    := nDataBuf[i].D['TimeAcc'];
      FFlowAcc    := nDataBuf[i].D['FlowAcc'];
      FQflow      := nDataBuf[i].D['Qflow'];
      FPressure   := nDataBuf[i].D['Pressure'];
      FStatus     := nDataBuf[i].S['Status'];
    end;
  end;
end;

//Date: 2023-11-09
//Desc: ͬ��д�����ݿ�
procedure TDataSync.DoSyncDB;
var nStr: string;
    nIdx: Integer;
begin
  FListA.Clear;
  //init

  for nIdx := Low(FDevices) to High(FDevices) do
  begin
    if not FDevices[nIdx].FNewUpdate then Continue;
    //no new data

    with TSQLBuilder,FDevices[nIdx] do
    nStr := MakeSQLByStr([
        SF('deviceId', FDevice),
        SF('HeatAcc', FHeatAcc, sfVal),
        SF('ColdAcc', FColdAcc, sfVal),
        SF('Heat', FHeat, sfVal),
        SF('TempInlet', FTempIn, sfVal),
        SF('TempOutlet', FTempOut, sfVal),
        SF('TimeAcc', FTimeAcc, sfVal),
        SF('FlowAcc', FFlowAcc, sfVal),
        SF('Qflow', FQflow, sfVal),
        SF('Pressure', FPressure, sfVal),
        SF('Status', FStatus),
        SF('UpdateTime', TDateTimeHelper.DateTime2Str(FUpTime)),
        SF('CreateTime', TDateTimeHelper.DateTime2Str(Now))
      ], 'nbheat', '', True);
    FListA.Add(nStr);
  end;

  if FListA.Count > 0 then
    gMG.FDBManager.DBExecute(FListA);
  //do write
end;

end.
