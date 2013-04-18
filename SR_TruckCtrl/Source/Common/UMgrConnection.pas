{*******************************************************************************
  作者: dmzn@163.com 2013-3-7
  描述: 通道管理器

  备注:
  *.通道管理器维护一组TPortReader,每个对象负责与一个通道进行通信.
*******************************************************************************}
unit UMgrConnection;

interface

uses
  Windows, Classes, CPort, CPortTypes, SysUtils, SyncObjs, UWaitItem,
  USysProtocol, USysLoger, USysConst;

const
  cReadBufferSize = 1024;
  //buffer size

type
  TDoubleByte = packed record
    FL: Byte;
    FH: Byte;
  end;
  
  TCommandDispose = (cdAuto, cdManual);
  //free method

  PCommandData = ^TCommandData;
  TCommandData = record
    FData: PDataItem;          //指令数据
    FWaiter: TWaitObject;      //等待对象
    FFree: TCommandDispose;    //释放策略
    
    FSendTime: Byte;           //发送次数
    FLastActive: Int64;        //上次活动
  end;

const
  cSizeCMDData = SizeOf(TCommandData);

type
  TPortReadEvent = procedure (const nData: PDeviceItem) of object;
  //event
  TPortReadManager = class;
  //connection manager

  TPortReader = class(TThread)
  private
    FOwner: TPortReadManager;
    //拥有者
    FCOMPort: TCOMItem;
    //串口参数
    FReader: TComPort;
    //串口对象
    FBufIdx: Integer;
    FBuffer: array[0..cReadBufferSize-1] of Byte;
    //接收缓冲
    FWaitItem: TWaitObject;
    //等待对象
    FCMDBuffer: TList;
    //命令缓冲
    FLastInit: Int64;
    FInitDevice: Boolean;
    //重置设备
    FSyncLock: TCriticalSection;
    //同步锁定
  protected
    procedure ClearCMD(const nFree: Boolean);
    procedure DeleteCMD(const nIdx: Integer);
    //清理资源
    function GetCMD(const nIndex, nFun: Byte; nLocked: Boolean = True): Integer;
    //检索指令
    procedure WriteData(const nData: PDataItem);
    procedure SendQueryFrame;
    procedure SendRepairFrame(const nDevice: PDeviceItem);
    function SendResetFrame: Boolean;
    procedure SendData;
    //发送数据
    procedure ReceiveData(const nWaitInterval: Cardinal = 0;
     const nWaitOne: Boolean = False);
    function ParseData(const nData: PDataItem): Boolean;
    //解析数据
    procedure DoQuery(const nDevice: PDeviceItem; const nData: PDataItem);
    procedure DoWork(const nData: PDataItem);
    //业务处理
    procedure DelayWait(const nTime: Word);
    procedure Execute; override;
    //执行线程
  public
    constructor Create(AOwner: TPortReadManager; APort: PCOMItem);
    destructor Destroy; override;
    //创建释放
    procedure StopMe;
    //停止线程
    procedure InitCMD(const nCMD: PCommandData; const nWait: Boolean);
    procedure AddCMD(const nCMD: PCommandData);
    procedure DelCMD(const nCMD: PCommandData);
    //增删命令
  end;

  TPortReadManager = class(TObject)
  private
    FReaders: array of TPortReader;
    //读写对象
    FOnData: TPortReadEvent;
    //事件相关
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放
    class procedure WriteReaderLog(const nMsg: string);
    //记录日志
    class procedure IncTime(var nDate: TDateTime; const nNum: Word);
    //累加时间
    procedure StartReader;
    procedure StopReader;
    //起停服务
    function FindReader(const nPort: string): TPortReader;
    //检索对象
    function DeviceCommand(const nPort: string; const nIndex,nCommand: Byte;
      const nData: TDataBytes; var nHint: string): Boolean;
    //设备指令
    function IsReaderRun: Boolean;
    //运行状态
    property OnData: TPortReadEvent read FOnData write FOnData;
    //事件相关
  end;

var
  gPortManager: TPortReadManager = nil;
  //全局使用

implementation

procedure WriteLog(const nMsg: string);
begin
  gSysLoger.AddLog(TPortReadManager, '', nMsg);
end;

class procedure TPortReadManager.WriteReaderLog(const nMsg: string);
begin
  WriteLog(nMsg);
end;

constructor TPortReadManager.Create;
begin
  SetLength(FReaders, 0);
end;

destructor TPortReadManager.Destroy;
begin
  StopReader;
  inherited;
end;

//Desc: 启动服务
procedure TPortReadManager.StartReader;
var nIdx: Integer;
    nList: TList;
begin
  if Length(FReaders) > 0 then Exit;
  //is run

  nList := gDeviceManager.LockPortList;
  try
    SetLength(FReaders, nList.Count);
    for nIdx:=0 to nList.Count - 1 do
      FReaders[nIdx] := nil;
    //init

    for nIdx:=0 to nList.Count - 1 do
      FReaders[nIdx] := TPortReader.Create(Self, nList[nIdx]);
    //new reader
  finally
    gDeviceManager.ReleaseLock;
  end;
end;

//Desc: 停止服务
procedure TPortReadManager.StopReader;
var nIdx: Integer;
    nObj: TPortReader;
begin
  if Length(FReaders) < 1 then Exit;
  //is run

  for nIdx:=Low(FReaders) to High(FReaders) do
   if Assigned(FReaders[nIdx]) then
    FReaders[nIdx].Terminate;
  //try stop

  for nIdx:=Low(FReaders) to High(FReaders) do
  if Assigned(FReaders[nIdx]) then
  begin
    nObj := FReaders[nIdx];
    FReaders[nIdx] := nil;
    nObj.StopMe;
  end;

  SetLength(FReaders, 0);
end;

//Date: 2013-3-14
//Parm: 串口
//Desc: 检索端口为nPort的对象
function TPortReadManager.FindReader(const nPort: string): TPortReader;
var nIdx: Integer;
begin
  Result := nil;

  for nIdx:=Low(FReaders) to High(FReaders) do
  if CompareText(nPort, FReaders[nIdx].FCOMPort.FParam.FPortName) = 0 then
  begin
    Result := FReaders[nIdx];
    Break;
  end;
end;

//Date: 2013-3-14
//Parm: 串口;地址;功能码;数据
//Desc: 向nPort.nIndex设备发送nCMD指令
function TPortReadManager.DeviceCommand(const nPort: string; const nIndex,
  nCommand: Byte; const nData: TDataBytes; var nHint: string): Boolean;
var nIdx: Integer;
    nReader: TPortReader;
    nCMD: TCommandData;
begin
  Result := False;
  nReader := FindReader(nPort);

  if not Assigned(nReader) then
  begin
    nHint := '串口无效';
    Exit;
  end;

  nReader.InitCMD(@nCMD, True);
  try
    with nCMD.FData^ do
    begin
      case nCommand of
       cFun_SetIndex:
        begin
          FIndex := cAddr_Broadcast;
          FFunction := cFun_SetIndex;
        end;
       cFun_DevLocate:
        begin
          FIndex := nIndex;
          FFunction := cFun_DevLocate;
        end;
       cFun_SetTime:
        begin
          FIndex := cAddr_Broadcast;
          FFunction := cFun_SetTime;
        end;
       cFun_BreakPipeMin:
        begin
          FIndex := nIndex;
          FFunction := cFun_BreakPipeMin;
        end;
       cFun_BreakPipeMax:
        begin
          FIndex := nIndex;
          FFunction := cFun_BreakPipeMax;
        end;
       cFun_BreakPotMin:
        begin
          FIndex := nIndex;
          FFunction := cFun_BreakPotMin;
        end;
       cFun_BreakPotMax:
        begin
          FIndex := nIndex;
          FFunction := cFun_BreakPotMax;
        end;
       cFun_TotalPipeMin:
        begin
          FIndex := nIndex;
          FFunction := cFun_TotalPipeMin;
        end;
       cFun_TotalPipeMax:
        begin
          FIndex := nIndex;
          FFunction := cFun_TotalPipeMax;
        end;
      end;

      for nIdx:=Low(nData) to High(nData) do
        FData[nIdx] := nData[nIdx];
      FDataLen := Length(nData);
    end;

    nCMD.FFree := cdManual;
    nReader.AddCMD(@nCMD);

    nCMD.FWaiter.EnterWait;
    Result := nCMD.FWaiter.WaitResult = WAIT_OBJECT_0;

    if not Result then
      nHint := '设备无响应';
    //xxxxx
  finally
    nReader.DelCMD(@nCMD);
    //xxxxx
    
    if Assigned(nCMD.FWaiter) then
      nCMD.FWaiter.Free;
    gDataManager.ReleaseData(nCMD.FData);
  end;
end;

//Date: 2013-3-21
//Desc: 服务是否运行
function TPortReadManager.IsReaderRun: Boolean;
begin
  Result := Length(FReaders) > 0;
end;

//Date: 2013-4-12
//Parm: 时间;采集间隔数
//Desc: 为nDate增加nNum间隔的时间
class procedure TPortReadManager.IncTime(var nDate: TDateTime; const nNum: Word);
begin
  if nNum > 0 then
    nDate := nDate + (nNum * gSysParam.FCollectTM) / (24 * 3600 * 1000);
  //1ms = 1 / (24*3600*1000)
end;

//------------------------------------------------------------------------------
constructor TPortReader.Create(AOwner: TPortReadManager; APort: PCOMItem);
var nIdx: Integer;
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FOwner := AOwner;
  FCOMPort.FParam := APort.FParam;
  FCOMPort.FDevices := TList.Create;

  for nIdx:=0 to APort.FDevices.Count - 1 do
    FCOMPort.FDevices.Add(APort.FDevices.Items[nIdx]);
  //copy data

  FBufIdx := 0;
  FCMDBuffer := TList.Create;
  FSyncLock := TCriticalSection.Create;
  
  FWaitItem := TWaitObject.Create;
  FWaitItem.Interval := 100;

  FReader := TComPort.Create(nil);
  with FReader do
  begin
    Port := FCOMPort.FParam.FPortName;
    BaudRate := FCOMPort.FParam.FBaudRate;
    DataBits := FCOMPort.FParam.FDataBits;
    StopBits := FCOMPort.FParam.FStopBits;

    SyncMethod := smDisableEvents;
    Timeouts.ReadInterval := 0;
    Timeouts.ReadTotalMultiplier := 100;
    Timeouts.ReadTotalConstant := 3000;
  end;
end;

destructor TPortReader.Destroy;
begin
  FreeAndNil(FReader);
  FreeAndNil(FWaitItem);

  ClearCMD(True);
  FreeAndNil(FSyncLock);
  
  FCOMPort.FDevices.Free;
  inherited;
end;

procedure TPortReader.StopMe;
begin
  Terminate;
  FWaitItem.Wakeup;

  WaitFor;
  Free;
end;

procedure TPortReader.DeleteCMD(const nIdx: Integer);
var nCmd: PCommandData;
begin
  nCmd := FCMDBuffer[nIdx];
  FCMDBuffer.Delete(nIdx);
  //remove from buffer
  
  if nCmd.FFree = cdAuto then
  begin
    gDataManager.ReleaseData(nCmd.FData);
    FreeAndNil(nCmd.FWaiter);
    Dispose(nCmd);
  end;
end;

procedure TPortReader.ClearCMD(const nFree: Boolean);
var nIdx: Integer;
begin
  FSyncLock.Enter;
  try
    for nIdx:=FCMDBuffer.Count - 1 downto 0 do
      DeleteCMD(nIdx);
    //clear

    if nFree then
      FreeAndNil(FCMDBuffer);
    //free it
  finally
    FSyncLock.Leave;
  end;
end;

//Date: 2013-3-14
//Parm: 指令
//Desc: 初始化nCMD数据
procedure TPortReader.InitCMD(const nCMD: PCommandData; const nWait: Boolean);
begin
  FillChar(nCMD^, cSizeCMDData, #0);
  //init nil
  
  nCMD.FFree := cdAuto;
  nCMD.FLastActive := GetTickCount;
  nCMD.FData := gDataManager.LockData;

  if nWait then
  begin
    nCMD.FWaiter := TWaitObject.Create;
    nCMD.FWaiter.Interval := 3 * 1000;
  end;
end;

//Date: 2013-3-12
//Parm: 指令;是否需要等待
//Desc: 添加nCMD到指令队列
procedure TPortReader.AddCMD(const nCMD: PCommandData);
begin
  FSyncLock.Enter;
  try
    nCMD.FSendTime := 0;
    nCMD.FLastActive := GetTickCount;
    
    FCMDBuffer.Add(nCMD);
    FWaitItem.Wakeup;
  finally
    FSyncLock.Leave;
  end;
end;

//Date: 2013-3-12
//Parm: 指令
//Desc: 删除指令
procedure TPortReader.DelCMD(const nCMD: PCommandData);
var nIdx: Integer;
begin
  FSyncLock.Enter;
  try
    nIdx := FCMDBuffer.IndexOf(nCMD);
    if nIdx >= 0 then
      DeleteCMD(nIdx);
    //xxxx
  finally
    FSyncLock.Leave;
  end;   
end;

//Date: 2013-3-14
//Parm: 地址码;功能码;同步锁定
//Desc: 检索nIndex.nFun是否在指令缓存
function TPortReader.GetCMD(const nIndex, nFun: Byte; nLocked: Boolean): Integer;
var nIdx: Integer;
    nCMD: PCommandData;
begin
  Result := -1;
  if nLocked then
    FSyncLock.Enter;
  //lock

  try
    for nIdx:=FCMDBuffer.Count - 1 downto 0 do
    begin
      nCMD := FCMDBuffer[nIdx];
      if (nCMD.FData.FIndex = nIndex) and (nCMD.FData.FFunction = nFun) then
      begin
        Result := nIdx;
        Break;
      end;
    end;
  finally
    if nLocked then
      FSyncLock.Leave;
    //unlock
  end;
end;

//Desc: 延时等待nTime时长
procedure TPortReader.DelayWait(const nTime: Word);
var nOld: Cardinal;
begin
  nOld := FWaitItem.Interval;
  FWaitItem.Interval := nTime;

  FWaitItem.EnterWait;
  FWaitItem.Interval := nOld;
end;

procedure TPortReader.Execute;
var nStr: string;
begin
  FLastInit := 0;
  FInitDevice := False;

  FCOMPort.FParam.FLastQuery := 0;
  FCOMPort.FParam.FLastActive := GetTickCount;
  //init default

  while not Terminated do
  try
    FWaitItem.EnterWait;
    if Terminated then Break;

    if not FReader.Connected then
    try
      nStr := Format('[%s]尝试打开端口.', [FCOMPort.FParam.FPortName]);
      FCOMPort.FParam.FRunFlag := nStr;

      FReader.Open;
      //连接串口
      FReader.ClearBuffer(True, True);
      //重置缓冲
      FBufIdx := 0;
      //重置索引
    except
      nStr := Format('连接端口[ %s ]失败.', [FCOMPort.FParam.FPortName]);
      WriteLog(nStr);

      DelayWait(3 * 1000);
      Continue;
    end;

    FCOMPort.FParam.FLastActive := GetTickCount;
    //connection is active

    if (gSysParam.FResetTime > 0) and
       (GetTickCount - FLastInit > gSysParam.FResetTime * 60 * 1000) then
      FInitDevice := False;
    //定时同步时钟

    if not FInitDevice then
    begin
      nStr := Format('[%s]尝试重置设备.', [FCOMPort.FParam.FPortName]);
      FCOMPort.FParam.FRunFlag := nStr;

      FInitDevice := SendResetFrame;
      //发送重置指令
      
      if not FInitDevice then
      begin
        DelayWait(1 * 1000);
        Continue;
      end;
      //重置完成前不能作业
    end;

    try
      nStr := Format('[%s] SendData.', [FCOMPort.FParam.FPortName]);
      FCOMPort.FParam.FRunFlag := nStr;
      SendData; //发送数据

      nStr := Format('[%s] ReceiveData.', [FCOMPort.FParam.FPortName]);
      FCOMPort.FParam.FRunFlag := nStr;
      ReceiveData; //接收数据

      nStr := Format('[%s] ParseData.', [FCOMPort.FParam.FPortName]);
      FCOMPort.FParam.FRunFlag := nStr;
      ParseData(nil);
      //处理数据
    except
      nStr := Format('[%s]线程错误,关闭端口.', [FCOMPort.FParam.FPortName]);
      FCOMPort.FParam.FRunFlag := nStr;

      FReader.Close;
      raise;
    end;
  except
    on E:Exception do
    begin
      WriteLog(Format('[%s]: %s', [FCOMPort.FParam.FPortName, E.Message]));
      DelayWait(3 * 1000);
    end;
  end;
end;

//------------------------------------------------------------------------------ 
//Date: 2013-3-13
//Parm: 数据指针;数据长度
//Desc: 将nData转换成可视的16进制码
function HexData(nData: PByte; const nLen: Integer): string;
var nIdx: Integer;
begin
  Result := '';
  for nIdx:=1 to nLen do
  begin
    Result := Result + IntToHex(nData^, 2) + ' ';
    Inc(nData);
  end;
end;

//Date: 2013-3-13
//Parm: 前缀;数据;长度
//Desc: 将nData转换成可视的16进制码写入日志
procedure PrintHex(const nPrefix: string; const nData: Pointer;
 const nLen: Integer);
begin
  if gSysLoger.LogSync then
  begin
    WriteLog(nPrefix + HexData(nData, nLen));
  end;
end;

//Desc: 对nPtr做异或校验
function VerifyData(const nPtr: Pointer; nLen: Integer): Byte;
var nIdx: Integer;
    nBuf: array of Byte;
begin
  SetLength(nBuf, nLen);
  Move(nPtr^, nBuf[0], nLen);

  Result := nBuf[0];
  for nIdx:=1 to High(nBuf) do
    Result := Result xor nBuf[nIdx];
  //xxxxx
end;

//Date: 2013-3-12
//Parm: 数据
//Desc: 将nData写入串口
procedure TPortReader.WriteData(const nData: PDataItem);
var nCRC,nLen: Byte;
begin
  nData.FHeader[0] := cHeader_0;
  nData.FHeader[1] := cHeader_1;
  nData.FHeader[2] := cHeader_2;

  nLen := 6 + nData.FDataLen + 1;
  //data len  
  nCRC := VerifyData(@nData.FIndex, 3 + nData.FDataLen);
  //crc
  if nCRC <> cFooter_0 then nLen := nLen + 1;
  //add footer

  if nData.FDataLen > High(nData.FData) then
  begin
    nData.FCRC := nCRC;
    nData.FFooter := cFooter_0;
  end else
  begin
    nData.FData[nData.FDataLen] := nCRC;
    if nData.FDataLen + 1 <= High(nData.FData) then
         nData.FData[nData.FDataLen + 1] := cFooter_0
    else nData.FCRC := cFooter_0;
  end;

  if gSysParam.FPrintSend then
    PrintHex(Format('[%s]-->:' + #9, [FCOMPort.FParam.FPortName]), nData, nLen);
  //xxxxx
  
  FReader.Write(PCPortAnsiChar(nData), nLen);
  //send data
end;

//Date: 2013-3-12
//Desc: 发送缓冲中的指令
procedure TPortReader.SendData;
var nIdx: Integer;
    nCMD: PCommandData;
begin
  FSyncLock.Enter;
  try
    for nIdx:=FCMDBuffer.Count - 1 downto 0 do
    begin
      nCMD := FCMDBuffer[nIdx];
      if GetTickCount - nCMD.FLastActive >= 5 * 1000 then
      begin
        if Assigned(nCMD.FWaiter) then
          nCMD.FWaiter.Wakeup;
        DeleteCMD(nIdx);
      end;
    end; //指令发送后无响应超时

    if FCMDBuffer.Count = 0 then
    begin
      SendQueryFrame;
      Exit;
    end; //无指令时发送查询帧
    
    for nIdx:=0 to FCMDBuffer.Count - 1 do
    begin
      nCMD := FCMDBuffer[nIdx];
      if nCMD.FSendTime > 0 then Exit;
      //未完成指令

      if nCMD.FSendTime < 1 then
      begin
        Inc(nCMD.FSendTime);
        nCMD.FLastActive := GetTickCount;

        WriteData(nCMD.FData);
        Exit;
      end;
    end;
  finally
    FSyncLock.Leave;
  end;
end;

//Date: 2013-3-12
//Desc: 发送查询帧
procedure TPortReader.SendQueryFrame;
var nIdx: Integer;
    nCMD: PDataItem;
    nDev: PDeviceItem;
begin
  if GetTickCount - FCOMPort.FParam.FLastQuery < gSysParam.FQInterval then Exit;
  //interval is short

  nCMD := gDataManager.LockData;
  try
    nCMD.FIndex := cAddr_Broadcast;
    nCMD.FFunction := cFun_Query;
    nCMD.FDataLen := 0;

    for nIdx:=0 to FCOMPort.FDevices.Count - 1 do
    begin
      nDev := FCOMPort.FDevices[nIdx];
      nCMD.FData[nCMD.FDataLen] := nDev.FIndex;
      Inc(nCMD.FDataLen);
    end;

    WriteData(nCMD);
    //send
    FCOMPort.FParam.FLastQuery := GetTickCount;
  finally
    gDataManager.ReleaseData(nCMD);
  end;
end;

//Date: 2013-3-13
//Parm: 设备
//Desc: 向nDevice发送补码指令
procedure TPortReader.SendRepairFrame(const nDevice: PDeviceItem);
var nCMD: PCommandData;
begin
  if GetCMD(nDevice.FIndex, cFun_Repair) >= 0 then Exit;
  //exits 

  New(nCMD);
  InitCMD(nCMD, False);
  
  with nCMD.FData^ do
  begin
    FIndex := nDevice.FIndex;
    FFunction := cFun_Repair;
    FDataLen := 2;

    FData[0] := nDevice.FIndex;
    FData[1] := nDevice.FLastFrameID;
  end;

  AddCMD(nCMD);
  //add buffer
  WriteLog(Format('[%s:%d]对报文帧[ %s ]补值.', [FCOMPort.FParam.FPortName,
    nDevice.FIndex, IntToHex(nDevice.FLastFrameID, 2)]));
  //loged
end;

//Date: 2013-3-12
//Desc: 发送重置帧
function TPortReader.SendResetFrame: Boolean;
var nStr: string;
    nIdx: Integer;
    nData: TDataItem;
    nDevice: PDeviceItem;
begin
  Result := False;

  for nIdx:=FCOMPort.FDevices.Count - 1 downto 0 do
  begin
    nDevice := FCOMPort.FDevices[nIdx];
    nDevice.FLastActive := GetTickCount;
    nDevice.FLastFrameID := 0;
    //item

    with nData do
    begin
      FIndex := nDevice.FIndex;
      FFunction := cFun_Reset;
      FDataLen := 0;
    end;

    nDevice.FTotalPipeTimeBase := Now();
    nDevice.FBreakPipeTimeBase := nDevice.FTotalPipeTimeBase;
    nDevice.FBreakPotTimeBase := nDevice.FTotalPipeTimeBase;
    //init base time

    nDevice.FTotalPipeTimeNow := nDevice.FTotalPipeTimeBase;
    nDevice.FBreakPipeTimeNow := nDevice.FTotalPipeTimeBase;
    nDevice.FBreakPotTimeNow := nDevice.FTotalPipeTimeBase;
    //init cureent time
    
    WriteData(@nData);
    ReceiveData(500, True);

    if (not ParseData(@nData)) or (nData.FFunction <> cFun_Reset) or
       (nData.FIndex <> nDevice.FIndex) then
    begin
      nStr := '[%s:%d]重置设备失败.';
      nStr := Format(nStr, [FCOMPort.FParam.FPortName, nDevice.FIndex]);
      
      WriteLog(nStr);
      Exit;
    end;  
  end;

  FLastInit := GetTickCount;
  Result := True;
  //all done
end;

//Date: 2013-3-12
//Parm: 等待间隔;等一包数据
//Desc: 接收数据
procedure TPortReader.ReceiveData(const nWaitInterval: Cardinal;
  const nWaitOne: Boolean);
var nInt: Integer;
    nVal: Int64;
begin
  if nWaitOne and (nWaitInterval > 0) then
  begin
    nVal := GetTickCount;
    while GetTickCount - nVal < nWaitInterval do
    begin
      Sleep(10);
      if Terminated then Exit;

      if FReader.InputCount >= 7 then Break;
      //起始符3 + 地址,功能,数据长度3 + 校验1
    end;
  end else

  if nWaitInterval > 0 then
  begin
    nVal := FWaitItem.Interval;
    FWaitItem.Interval := nWaitInterval;
    FWaitItem.EnterWait;

    FWaitItem.Interval := nVal;
    if Terminated then Exit;
  end;

  nInt := FReader.InputCount;
  if nInt < 1 then Exit;
  //no data

  if nInt + FBufIdx >= cReadBufferSize then
    FBufIdx := 0;
  //buffer overflow

  if nInt >= cReadBufferSize then
    nInt := cReadBufferSize;
  //data maybe too big

  nInt := FReader.Read(@FBuffer[FBufIdx], nInt);
  Inc(FBufIdx, nInt);
end;

//Date: 2013-3-12
//Parm: 数据;功能码
//Desc: 解析数据
function TPortReader.ParseData(const nData: PDataItem): Boolean;
var nItem: PDataItem;
    nCRC,nIndex,nFun: Byte;
    nIdx,nLen,nLastEnd: Integer;
begin         
  if Assigned(nData) then
  begin
    nIndex := nData.FIndex;
    nFun := nData.FFunction;
  end else
  begin
    nFun := 0;
    nIndex := 0;
  end;

  Result := False;
  nLastEnd := FBufIdx;
  nIdx := 0;
  //init
  
  while (nIdx <= FBufIdx - 7) do //无数据包最小为7byte
  try
    if (FBuffer[nIdx] <> cHeader_0) or (FBuffer[nIdx + 1] <> cHeader_1) or
       (FBuffer[nIdx + 2] <> cHeader_2) then
    begin
      Inc(nIdx);
      Continue;
    end; //无效起始符

    nLen := nIdx + 6 + FBuffer[nIdx + 5] + 1;
    //数据长度 + 数据 + 校验位
    
    if nLen > FBufIdx then
    begin
      Inc(nIdx);
      Continue;
    end;
    //数据未接收完毕,或数据错位(起始符无效)

    nItem := nil;
    try
      nLen := nLen - nIdx;
      //数据包长度

      if nLen > cSize_DataItem then
      begin
        Inc(nIdx);
        Continue;
      end; //数据包超大

      if Assigned(nData) then
           nItem := nData
      else nItem := gDataManager.LockData;

      Move(FBuffer[nIdx], nItem^, nLen);
      //复制数据

      if nItem.FDataLen - 1 < High(nItem.FData) then
        nItem.FCRC := nItem.FData[nItem.FDataLen];
      //获取校验值

      nCRC := VerifyData(@nItem.FIndex, 3 + nItem.FDataLen);
      //crc
      Result := nItem.FCRC = nCRC;

      if Result then
      begin
        nLastEnd := nIdx + nLen;
        if nLastEnd = FBufIdx then
          FBufIdx := 0;
        //正好处理完,重置

        nIdx := nLastEnd;
        //下一包开始

        if Assigned(nData) then
        begin
          if (nItem.FIndex = nIndex) and (nItem.FFunction = nFun) then
            Break;
          //找到所需数据,即刻退出
        end;

        DoWork(nItem);
        //解析数据
      end;
    finally
      if not Assigned(nData) then
        gDataManager.ReleaseData(nItem);
      //xxxxx
    end;
  except
    on E:Exception do
    begin
      raise;
    end;
  end;

  if nLastEnd < FBufIdx then
  begin
    FBufIdx := FBufIdx - nLastEnd;
    Move(FBuffer[nLastEnd], FBuffer[0], FBufIdx);
    //将未使用数据移到开始
  end;
end;

//------------------------------------------------------------------------------
//Date: 2013-3-12
//Desc: 执行业务
procedure TPortReader.DoWork(const nData: PDataItem);
var nIdx: Integer;
    nDev: PDeviceItem;
    nCMD: PCommandData;
begin
  if gSysParam.FPrintRecv then
    PrintHex(Format('[%s]<--: ', [FCOMPort.FParam.FPortName]), nData,
             cSize_DataItem - (64 - nData.FDataLen) - 1);
  //xxxxx

  nDev := nil;
  //try-to verify device

  for nIdx:=FCOMPort.FDevices.Count - 1 downto 0 do
  begin
    nDev := FCOMPort.FDevices[nIdx];
    if nDev.FIndex = nData.FIndex then
         Break
    else nDev := nil;
  end;

  if (nData.FFunction = cFun_Query) or (nData.FFunction = cFun_Repair) then
  begin
    if Assigned(nDev) then
    begin
      DoQuery(nDev, nData);
      nDev.FLastActive := GetTickCount;
    end;

    Exit;
    //query end
  end;

  if Assigned(nDev) then
    nDev.FLastActive := GetTickCount;
  //active status

  FSyncLock.Enter;
  try
    for nIdx:=FCMDBuffer.Count - 1 downto 0 do
    begin
      nCMD := FCMDBuffer[nIdx];
      if ((nCMD.FData.FIndex = nData.FIndex) or
          (nCMD.FData.FIndex = cAddr_Broadcast))and
         (nCMD.FData.FFunction = nData.FFunction) then
      begin
        if Assigned(nCMD.FWaiter) then
          nCMD.FWaiter.Wakeup;
        DeleteCMD(nIdx);
      end;
    end; //check command
  finally
    FSyncLock.Leave;
  end;
end;

//Date: 2013-3-15
//Parm: 低字节;高字节
//Desc: 解析高低字节中的数据
procedure DecodeVal(const nL,nH: Byte; var nVal,nNum: Word);
var nD: TDoubleByte;
begin
  nD.FH := nH and $03; //0000 0011
  nD.FL := nL;
  nVal := Word(nD);

  nD.FH := nH shr 2;
  nD.FH := nD.FH and $3F; //0011 1111
  nNum := nD.FH + 1;
end;

//Date: 2013-3-13
//Parm: 设备;数据
//Desc: 处理来自nDevice的查询应答
procedure TPortReader.DoQuery(const nDevice: PDeviceItem;
  const nData: PDataItem);
var nVal: Word;
    nL,nH: Byte;
    nIdx: Integer;
    nFirst: Boolean;
begin
  if nDevice.FLastFrameID <> nData.FData[0] then
    begin
    SendRepairFrame(nDevice);
    Exit;
  end; //to repair

  nDevice.FLastFrameID := nDevice.FLastFrameID + 1;
  if nDevice.FLastFrameID > cFrameIDMax then
    nDevice.FLastFrameID := 0;
  //reset id

  //----------------------------------------------------------------------------
  nL := 0; nH := 0;
  nVal := nData.FDataLen - 1; //index start from 0

  nIdx := 1;
  nFirst := True;

  while nIdx <= nVal do
  begin
    if nData.FData[nIdx] = $FF then
    begin
      if nIdx + 1 > nVal then Break;
      //is end

      if nData.FData[nIdx + 1] = $FF then
      begin
        if nFirst then
        begin
          nL := cFooter_0;
          Inc(nIdx);
        end else
        begin
          nH := cFooter_0;
          Inc(nIdx);
        end;
      end else
      begin
        if nFirst then
             nL := nData.FData[nIdx]
        else nH := nData.FData[nIdx];
      end;
    end else
    begin
      if nFirst then
           nL := nData.FData[nIdx]
      else nH := nData.FData[nIdx];
    end;

    Inc(nIdx);
    nFirst := not nFirst;

    if nFirst then //high-low is pair
    begin
      DecodeVal(nL, nH, nDevice.FTotalPipe, nVal);
      //total pipe value
      Break;
    end;
  end;

  //----------------------------------------------------------------------------
  nVal := nData.FData[nIdx] + nIdx;
  if nVal > High(nData.FData) then Exit;
  //overflow data

  nL := 0; nH := 0;
  nDevice.FBreakPipeNum := 0;
  
  Inc(nIdx);
  nFirst := True;

  while nIdx <= nVal do
  begin
    if nData.FData[nIdx] = $FF then
    begin
      if nIdx + 1 > nVal then Break;
      //is end

      if nData.FData[nIdx + 1] = $FF then
      begin
        if nFirst then
        begin
          nL := cFooter_0;
          Inc(nIdx);
        end else
        begin
          nH := cFooter_0;
          Inc(nIdx);
        end;
      end else
      begin
        if nFirst then
             nL := nData.FData[nIdx]
        else nH := nData.FData[nIdx];
      end;
    end else
    begin
      if nFirst then
           nL := nData.FData[nIdx]
      else nH := nData.FData[nIdx];
    end;

    Inc(nIdx);
    nFirst := not nFirst;

    if nFirst then //high-low is pair
    begin
      DecodeVal(nL, nH, nDevice.FBreakPipe[nDevice.FBreakPipeNum].FData,
                nDevice.FBreakPipe[nDevice.FBreakPipeNum].FNum);
      Inc(nDevice.FBreakPipeNum);
    end;
  end;

  //----------------------------------------------------------------------------
  nDevice.FBreakPotNum := 0;
  nFirst := True;

  while nIdx < nData.FDataLen do
  begin
    if nData.FData[nIdx] = $FF then
    begin
      if nIdx + 1 >= nData.FDataLen then Break;
      //is end

      if nData.FData[nIdx + 1] = $FF then
      begin
        if nFirst then
        begin
          nL := cFooter_0;
          Inc(nIdx);
        end else
        begin
          nH := cFooter_0;
          Inc(nIdx);
        end;
      end else
      begin
        if nFirst then
             nL := nData.FData[nIdx]
        else nH := nData.FData[nIdx];
      end;
    end else
    begin
      if nFirst then
           nL := nData.FData[nIdx]
      else nH := nData.FData[nIdx];
    end;

    Inc(nIdx);
    nFirst := not nFirst;

    if nFirst then //high-low is pair
    begin
      DecodeVal(nL, nH, nDevice.FBreakPot[nDevice.FBreakPotNum].FData,
                nDevice.FBreakPot[nDevice.FBreakPotNum].FNum);
      Inc(nDevice.FBreakPotNum);
    end;
  end;

  nDevice.FBreakPipeTimeBase := nDevice.FBreakPipeTimeNow;
  for nIdx:=0 to nDevice.FBreakPipeNum - 1 do
    FOwner.IncTime(nDevice.FBreakPipeTimeNow, nDevice.FBreakPipe[nIdx].FNum);
  //add timebase

  nDevice.FBreakPotTimeBase := nDevice.FBreakPotTimeNow;
  for nIdx:=0 to nDevice.FBreakPotNum - 1 do
    FOwner.IncTime(nDevice.FBreakPotTimeNow, nDevice.FBreakPot[nIdx].FNum);
  //add timebase

  nDevice.FTotalPipeTimeBase := nDevice.FTotalPipeTimeNow;
  if nDevice.FBreakPipeTimeNow > nDevice.FBreakPotTimeNow then
       nDevice.FTotalPipeTimeNow := nDevice.FBreakPipeTimeNow
  else nDevice.FTotalPipeTimeNow := nDevice.FBreakPotTimeNow;
  
  if Assigned(FOwner.FOnData) then
  try
    FCOMPort.FParam.FRunFlag := Format('[%s] OnData.', [
                                       FCOMPort.FParam.FPortName]);
    //flaged

    FOwner.FOnData(nDevice);
    //do event
  except
    on E:Exception do
    begin
      WriteLog(E.Message);
    end;
  end;
end;

initialization
  gPortManager := TPortReadManager.Create;
finalization
  FreeAndNil(gPortManager);
end.
