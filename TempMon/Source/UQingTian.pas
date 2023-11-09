{*******************************************************************************
  作者: dmzn@163.com 2023-11-06
  描述: 同步 重庆青天特克科技有限公司 物联网服务器数据

  备注:
  *. 文档: 超声波网络表平台API说明(20210115)
*******************************************************************************}
unit UQingTian;

interface

uses
  System.Classes, System.SysUtils, IdBaseComponent, IdComponent, IdTCPConnection,
  IdHTTP, superobject, ULibFun, UWaitItem, UManagerGroup, USysConst;

type
  TDeviceData = record
    FDevice     : string;                        //设备ID
    FHeatAcc    : Double;                        //累计热量(kW·h)
    FColdAcc    : Double;                        //累计冷量(kW·h)
    FHeat       : Double;                        //热功率(kW)
    FTempIn     : Double;                        //进水温度
    FTempOut    : Double;                        //回水温度
    FTimeAcc    : Double;                        //累计工作时间(h)
    FFlowAcc    : Double;                        //累计流量(m3)
    FQflow      : Double;                        //瞬时流量(m3/h)
    FPressure   : Double;                        //压力(MPa)
    FStatus     : string;                        //状态码
    FUpTime     : TDateTime;                     //更新时间
    FNewUpdate  : Boolean;                       //是否新数据
  end;

  TDataSync = class(TThread)
  private
    FHttp: TIdHTTP;
    {*http client*}
    FWaiter: TWaitObject;
    {*time counter*}
    FDevices: array of TDeviceData;
    {*device buffer*}
    FUpdateCounter: Integer;
    {*device update counter*}
  protected
    procedure DoSyncDB;
    function DoSync(const nPage, nPageSize: Integer): Boolean;
    procedure Execute; override;
    {*执行同步*}
    function FindDevice(const nID: string): Integer;
    {*检索设备*}
  public
    constructor Create();
    destructor Destroy; override;
    {*创建释放*}
    procedure Wakeup;
    {*唤醒线程*}
    procedure StopMe;
    {*停止线程*}
  end;

implementation

procedure WriteLog(const nEvent: string);
begin
  gMG.FLogManager.AddLog(TDataSync, '青天同步', nEvent);
end;

//------------------------------------------------------------------------------
constructor TDataSync.Create;
begin
  inherited Create(False);
  FreeOnTerminate := False;

  SetLength(FDevices, 0);
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

//Date: 2023-11-09
//Parm: 设备id
//Desc: 检索nID设备索引
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
    nPage: Integer;
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
  begin
    try
      FUpdateCounter := 0;
      nPage := 1;
      //init

      while DoSync(nPage, 50) do
        Inc(nPage);
      //sync data

      if FUpdateCounter > 0 then
        DoSyncDB;
      //write db
    except
      on nErr: Exception do
      begin
        WriteLog('同步异常: ' + nErr.Message);
      end;
    end;

    FWaiter.EnterWait;
    //delay
  end;

  FreeAndNil(FHttp);
end;

//Date: 2023-11-09
//Parm: 日期字符串
//Desc: 格式化nStr为日期类型
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
//Parm: 分页页码;分页大小
//Desc: 更新第nPage页的数据
function TDataSync.DoSync(const nPage, nPageSize: Integer): Boolean;
var nStr: string;
    i,nIdx,nLen: Integer;
    nDate: TDateTime;

    nParse: ISuperObject;
    nDataBuf: TSuperArray;
begin
  Result := False;
  nStr := '/app/hm/h001/deviceDataList?pageNo=%d&pageSize=%d';
  nStr := Format(nStr, [nPage, nPageSize]);
  //4.2 批量查询设备最新数据: 批量查询设备上报平台的最新数据

  nStr := FHttp.Get(gSystemParam.FServerURI + nStr);
  nLen := Length(nStr);
  nIdx := -1;

  for i := TStringHelper.cFI to nLen do
  if nStr[i] <> #32 then //过滤前端空格
  begin
    if nStr[i] = '{' then
      nIdx := i;
    Break;
  end;

  if nIdx < 0 then
  begin
    WriteLog('青天服务器返回无效json数据: ' + TEncodeHelper.EncodeBase64(nStr));
    Exit;
  end;

  nParse := SO(nStr);
  nStr := nParse.S['StatusCode'];
  if (nPage > 1) and (nStr  = '400') then Exit; //没有多余分页数据

  if nStr <> '200' then
  begin
    WriteLog('获取青天数据失败: ' + nParse.S['message']);
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
      //旧数据不予处理
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
//Desc: 同步写入数据库
procedure TDataSync.DoSyncDB;
begin

end;

end.
