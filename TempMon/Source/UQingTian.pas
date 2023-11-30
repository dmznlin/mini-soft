{*******************************************************************************
  作者: dmzn@163.com 2023-11-06
  描述: 同步 重庆青天特克科技有限公司 物联网服务器数据

  备注:
  *. 文档: 超声波网络表平台API说明(20210115)
*******************************************************************************}
unit UQingTian;

{$I Link.Inc}
interface

uses
  System.Classes, System.SysUtils, IdBaseComponent, IdComponent, IdTCPConnection,
  IdHTTP, superobject, Winapi.ActiveX, ULibFun, UWaitItem, UManagerGroup,
  USysConst;

type
  TDeviceData = record
    FDevice     : string;                  //设备ID
    FHeatAcc    : Double;                  //累计热量(kW·h)
    FColdAcc    : Double;                  //累计冷量(kW·h)
    FHeat       : Double;                  //热功率(kW)
    FTempIn     : Double;                  //进水温度
    FTempOut    : Double;                  //回水温度
    FTimeAcc    : Double;                  //累计工作时间(h)
    FFlowAcc    : Double;                  //累计流量(m3)
    FQflow      : Double;                  //瞬时流量(m3/h)
    FPressure   : Double;                  //压力(MPa)
    FStatus     : string;                  //状态码
    FUpTime     : TDateTime;               //更新时间
    FNewUpdate  : Boolean;                 //是否新数据
  end;

  TDeviceSamlee = record
    FDevice     : string;                  //设备ID
    FRoomTemp   : Double;                  //室内温度 （室温采集器设备使用）
    FWaterInTemp: Double;                  //进水温度 （管道测温设备使用）
    FWaterBackTemp: Double;                //回水温度 （管道测温设备使用）
    FHumidity   : Double;                  //湿度
    FQos        : Integer;                 //信号质量
    FBattery    : Integer;                 //电量
    FUptime     : Integer;                 //上报时间分钟
    FTempComp   : Double;                  //温度补偿
    FRectime    : TDateTime;               //更新时间
    FNewUpdate  : Boolean;                 //是否新数据
  end;

  TDataSync = class(TThread)
  private
    FListA: TStrings;
    {*string list*}
    FHttpQingTian: TIdHTTP;
    FHttpSamlee: TIdHTTP;
    {*http client*}
    FSamleeList: TStrings;
    {*samlee id list*}
    FWaiter: TWaitObject;
    {*time counter*}
    FDeviceQT: array of TDeviceData;
    FDeviceSL: array of TDeviceSamlee;
    {*device buffer*}
    FCounterQT: Integer;
    FCounterSL: Integer;
    FUpdateCounter: Integer;
    {*device update counter*}
  protected
    procedure DoSyncDB;
    function DoSyncQingTian(const nPage, nPageSize: Integer): Boolean;
    function DoSyncSamlee(const nPage, nPageSize: Integer): Boolean;
    {*sync data*}
    procedure DoSync;
    procedure Execute; override;
    {*执行同步*}
    function FindDevice(const nID: string; const nType:TDeviceType): Integer;
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
  gMG.FLogManager.AddLog(TDataSync, '远程同步服务', nEvent);
end;

//------------------------------------------------------------------------------
constructor TDataSync.Create;
begin
  inherited Create(False);
  FreeOnTerminate := False;

  SetLength(FDeviceQT, 0);
  SetLength(FDeviceSL, 0);

  FListA := TStringList.Create;
  FWaiter := TWaitObject.Create();
  FWaiter.Interval := 1 * 1000;
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
//Parm: 设备id
//Desc: 检索nID设备索引
function TDataSync.FindDevice(const nID: string; const nType:TDeviceType): Integer;
var nIdx: Integer;
begin
  Result := -1;
  //init

  if nType = dtQingTian then
  begin
    for nIdx := Low(FDeviceQT) to High(FDeviceQT) do
    if FDeviceQT[nIdx].FDevice = nID then
    begin
      Result := nIdx;
      Break;
    end;
  end else 

  if nType = dtSamlee then
  begin
    for nIdx := Low(FDeviceSL) to High(FDeviceSL) do
    if FDeviceSL[nIdx].FDevice = nID then
    begin
      Result := nIdx;
      Break;
    end;
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
    end; //qingtian client

    FHttpSamlee := TIdHTTP.Create(nil);
    with FHttpSamlee, gSystemParam do
    begin
      Request.Clear;
      Request.ContentType := FSamleeCType;
    end; //samlee client

    FSamleeList := TStringList.Create;
    nStr := 'select s_id from %s ' +
            'where s_type=''%s'' and s_valid=''Y''';
    nStr := Format(nStr, [sTable_Sensor, sDeviceType[dtSamlee]]);
    //query valid samlee sensor
    
    with gMG.FDBManager.DBQuery(nStr) do
    begin
      if RecordCount > 0 then
      begin
        First;
        while not Eof do
        begin
          FSamleeList.Add(Fields[0].AsString);
          Next;
        end;        
      end;
    end; //init samlee device list

    FCounterQT := gSystemParam.FFreshRateQT;
    FCounterSL := gSystemParam.FFreshRateSL;
    //init counter

    while not Terminated do
    begin
      Inc(FCounterQT);
      Inc(FCounterSL);

      if (FCounterQT >= gSystemParam.FFreshRateQT) or
         (FCounterSL >= gSystemParam.FFreshRateSL) then //计时结束
      try
        DoSync;
        //do sync
      except
        on nErr: Exception do
        begin
          WriteLog('同步异常: ' + nErr.Message);
        end;
      end;

      FWaiter.EnterWait;
      //delay
    end;
  finally
    FreeAndNil(FSamleeList);
    FreeAndNil(FHttpQingTian);
    FreeAndNil(FHttpSamlee);
    CoUninitialize();
  end;
end;


procedure TDataSync.DoSync;
var nPage: Integer;
begin
  FUpdateCounter := 0;
  nPage := 1;
  //init

  if FCounterQT >= gSystemParam.FFreshRateQT then
  try
    FCounterQT := 0;
    //reset counter

    while DoSyncQingTian(nPage, 50) do
      Inc(nPage);
    //sync qingtian

    {$IFDEF DEBUG}
    WriteLog(Format('青天数据: %d 条', [FUpdateCounter]));
    {$ENDIF}
  except
    on nErr: Exception do
    begin
      WriteLog('青天异常: ' + nErr.Message);
    end;
  end;

  if FCounterSL >= gSystemParam.FFreshRateSL then
  try
    FCounterSL := 0;
    //reset counter
    nPage := 1;

    while DoSyncSamlee(nPage, 50) do
      Inc(nPage);
    //sync samlee

    {$IFDEF DEBUG}
    WriteLog(Format('三丽数据: %d 条', [FUpdateCounter]));
    {$ENDIF}
  except
    on nErr: Exception do
    begin
      WriteLog('三丽异常: ' + nErr.Message);
    end;
  end;

  if FUpdateCounter > 0 then
  begin
    DoSyncDB;
    //write db
    WriteLog(Format('更新数据: %d 条', [FUpdateCounter]));
  end;
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
  //4.2 批量查询设备最新数据: 批量查询设备上报平台的最新数据

  nStr := FHttpQingTian.Get(gSystemParam.FServerURI + nStr);
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
    nIdx := FindDevice(nDataBuf[i].S['deviceId'], dtQingTian);

    if nIdx >= 0 then
    begin
      if nDate <= FDeviceQT[nIdx].FUpTime then Continue;
      //旧数据不予处理
    end else
    begin
      nIdx := Length(FDeviceQT);
      SetLength(FDeviceQT, nIdx+1);
      FDeviceQT[nIdx].FDevice := nDataBuf[i].S['deviceId'];
    end;

    with FDeviceQT[nIdx] do
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
//Parm: 分页页码;分页大小
//Desc: 更新第nPage页设备列表的数据
function TDataSync.DoSyncSamlee(const nPage, nPageSize: Integer): Boolean;
var nStr: string;
    i,nIdx,nLen: Integer;
    nDate: TDateTime;
    
    nParam: TStringStream;    
    nParse: ISuperObject;
    nDataBuf: TSuperArray;
begin
  Result := False;
  i := (nPage - 1) * nPageSize; //开始索引
  nIdx := nPage * nPageSize - 1; //结束索引
  
  if (i > nIdx) or (i >= FSamleeList.Count) then 
    Exit; 
  //无效索引范围

  if nIdx >= FSamleeList.Count then
    nIdx := FSamleeList.Count - 1;
  //索引列表上限
    
  nParam := nil;
  try
    FListA.Clear;
    while nIdx >= i do
    begin
      FListA.Add(FSamleeList[nIdx]);  
      Dec(nIdx);
      //next
    end;

    nStr := '{' +
      '  "devType":1,' +
      '  "deviceID":[' +
      '    %s' +
      '  ]' +
      '}';
    nStr := Format(nStr, [TStringHelper.AdjustFormat(FListA, '"', True, ',', 
      False, True)]);    
    //build post data

    nParam := TStringStream.Create(nStr);
    nStr := FHttpSamlee.Post(gSystemParam.FSamleeServer, nParam);
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
      WriteLog('三丽服务器返回无效json数据: ' + TEncodeHelper.EncodeBase64(nStr));
      Exit;
    end;
  
    Result := True;
    nParse := SO(nStr);
    //parse json
    
    nDataBuf := nParse['devList'].AsArray;
    nLen := nDataBuf.Length - 1;

    for i := 0 to nLen do
    begin
      nDate := TDateTimeHelper.Str2DateTime(nDataBuf[i].S['rectime']);
      //last update
      nIdx := FindDevice(nDataBuf[i].S['deviceID'], dtSamlee);

      if nIdx >= 0 then
      begin
        if nDate <= FDeviceSL[nIdx].FRectime then Continue;
        //旧数据不予处理
      end else
      begin
        nIdx := Length(FDeviceSL);
        SetLength(FDeviceSL, nIdx+1);
        FDeviceSL[nIdx].FDevice := nDataBuf[i].S['deviceID'];
      end;

      with FDeviceSL[nIdx] do
      begin
        Inc(FUpdateCounter);
        FRectime := nDate;
        FNewUpdate := True;

        FRoomTemp       := nDataBuf[i].D['roomTemp'];
        FWaterInTemp    := nDataBuf[i].D['waterInTemp'];
        FWaterBackTemp  := nDataBuf[i].D['waterBackTemp'];
        FHumidity       := nDataBuf[i].D['humidity'];
        FQos            := nDataBuf[i].I['qos'];
        FBattery        := nDataBuf[i].I['battery'];
        FUptime         := nDataBuf[i].I['uptime'];
        FTempComp       := nDataBuf[i].D['tempComp'];
      end;
    end;
  finally
    nParam.Free;
  end;
end;

//Date: 2023-11-09
//Desc: 同步写入数据库
procedure TDataSync.DoSyncDB;
var nStr: string;
    nIdx: Integer;
begin
  FListA.Clear;
  //init

  for nIdx := Low(FDeviceQT) to High(FDeviceQT) do
  begin
    if not FDeviceQT[nIdx].FNewUpdate then Continue;
    //no new data
    FDeviceQT[nIdx].FNewUpdate := False;

    with TSQLBuilder,FDeviceQT[nIdx] do
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
      ], sTable_QingTian, '', True);
    FListA.Add(nStr);

    nStr := 'IF NOT EXISTS (SELECT * FROM $SS WHERE s_id=''$id'')' +
      'BEGIN' +
      '  INSERT INTO $SS(s_id,s_type,s_valid) ' +
      '  VALUES (''$id'', ''$QT'', ''Y'');' +
      'END';
    //new sensor

    with TStringHelper do
    nStr := MacroValue(nStr, [MI('$id', FDeviceQT[nIdx].FDevice),
      MI('$SS', sTable_Sensor),
      MI('$QT', sDeviceType[dtQingTian])]);
    FListA.Add(nStr);
  end;

  for nIdx := Low(FDeviceSL) to High(FDeviceSL) do
  begin
    if not FDeviceSL[nIdx].FNewUpdate then Continue;
    //no new data
    FDeviceSL[nIdx].FNewUpdate := False;

    with TSQLBuilder,FDeviceSL[nIdx] do
    nStr := MakeSQLByStr([
        SF('sl_id', FDevice),
        SF('sl_room', FRoomTemp, sfVal),
        SF('sl_waterIn', FWaterInTemp, sfVal),
        SF('sl_waterBack', FWaterBackTemp, sfVal),
        SF('sl_humidity', FHumidity, sfVal),
        SF('sl_qos', FQos, sfVal),
        SF('sl_battery', FBattery, sfVal),
        SF('sl_tempComp', FTempComp, sfVal),
        SF('sl_update', TDateTimeHelper.DateTime2Str(FRectime)),
        SF('sl_create', TDateTimeHelper.DateTime2Str(Now))
      ], sTable_Samlee, '', True);
    FListA.Add(nStr);
  end;
       
  if FListA.Count > 0 then
    gMG.FDBManager.DBExecute(FListA);
  //do write
end;

end.
