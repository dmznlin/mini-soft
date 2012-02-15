{*******************************************************************************
  作者: dmzn@163.com 2010-11-22
  描述: 多道计数器管理

  备注:
  *.本单元实现了一机多端口,一端口多装车道的计数管理器.
*******************************************************************************}
unit UMultiJS;

interface

uses
  Windows, Classes, CPort, CPortTypes, SysUtils, SyncObjs, UMgrSync, UWaitItem,
  ULibFun;

const   
  cMultiJS_Truck = 3;            //车牌长度
  cMultiJS_DaiNum = 4;           //袋数长度
  cMultiJS_Delay = 9;            //最大延迟
  cMultiJS_Tunnel = 9;           //最大道数 
  cMultiJS_Interval = 500;       //刷新频率

type
  TMultiJSManager = class;
  TMultJSItem = class;

  PMultiJSTunnel = ^TMultiJSTunnel;
  TMultiJSTunnel = record
    FTunnel: Word;
    //车道编号
    FDelay: Word;
    //延迟时间
    FTruck: array[0..cMultiJS_Truck - 1] of Char;
    //车牌号
    FDaiNum: Word;
    //需装袋数
    FHasDone: Word;
    //已装袋数
    FLastRead: Cardinal;
    //上次读取
    FLastRecv: Cardinal;
    //上次接收
  end;

  PMultiJSPortData = ^TMultiJSPortData;
  TMultiJSPortData = record
    FCOMPort: array[0..4] of Char;
    //端口号
    FBaudRate: Word;
    //传输速率
    FTunnel: TList;
    //车道数据
    FReader: TMultJSItem;
    //操作线程
  end;

  TMultJSItem = class(TThread)
  private
    FOwner: TMultiJSManager;
    //拥有者
    FComObj: TComPort;
    //串口对象
    FPort: PMultiJSPortData;
    //端口数据
    FWaiter: TWaitObject;
    //等待对象
    FSyncer: TDataSynchronizer;
    //同步对象
  protected
    procedure Execute; override;
    //线程体
    procedure DoSyncEvent(const nData: Pointer; const nSize: Cardinal);
    procedure DoSyncFree(const nData: Pointer; const nSize: Cardinal);
    //同步过程
  public
    constructor Create(AOwner: TMultiJSManager; nPort: PMultiJSPortData);
    destructor Destroy; override;
    //创建释放
    procedure StopThread;
    //停止线程
    procedure SuspendThread;
    procedure ResumeThread;
    //暂停唤醒
  end;

  TMultiJSEvent = procedure (nPort: string; nData: TMultiJSTunnel) of Object;
  //any event

  TMultiJSManager = class(TObject)
  private
    FPorts: TList;
    //端口数据
    FTunnelEvent: TMultiJSEvent;
    //数据变动
  protected
    procedure ClearPort(const nPort: PMultiJSPortData);
    procedure ClearPorts(const nFree: Boolean);
    //清理数据
    function GetPort(const nPort: string): Integer;
    //检索端口
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放
    procedure AddPort(const nCOMPort: string; const nBaudRate: Word;
      const nTunnelNum: Byte);
    function DelPort(const nCOMPort: string; var nHint: string): Boolean;
    //端口管理
    function SetTunnelData(const nCOMPort: string; const nTunnel,nDelay: Word;
      const nTruck: string; const nDaiNum: Word; var nHint: string): Boolean;
    //设置计数
    function StopTunnel(const nCOMPort: string; const nTunnel: Word;
      var nHint: string): Boolean;
    //停止计数
    property Ports: TList read FPorts;
    property OnData: TMultiJSEvent read FTunnelEvent write FTunnelEvent;
    //属性相关
  end;

implementation

const
  cStopDaiNum = 9999;
  //视为停止的撞车袋数

  cSize_Port = SizeOf(TMultiJSPortData);
  cSize_Tunnel = SizeOf(TMultiJSTunnel);

//------------------------------------------------------------------------------
constructor TMultJSItem.Create(AOwner: TMultiJSManager; nPort: PMultiJSPortData);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FOwner := AOwner;
  FPort := nPort;

  FComObj := TComPort.Create(nil);
  FWaiter := TWaitObject.Create;
  FWaiter.Interval := cMultiJS_Interval;
  
  FSyncer := TDataSynchronizer.Create;
  FSyncer.SyncEvent := DoSyncEvent;
  FSyncer.SyncFreeEvent := DoSyncFree;
end;

destructor TMultJSItem.Destroy;
begin
  FComObj.Free;
  FWaiter.Free;
  FSyncer.Free;
  inherited;
end;

//Desc: 释放线程
procedure TMultJSItem.StopThread;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  FComObj.Close;
  Free;
end;

//Desc: 阻塞运行
procedure TMultJSItem.SuspendThread;
begin
  while not FWaiter.IsWaiting do;
  FWaiter.Interval := INFINITE;

  FWaiter.Wakeup;
  while not FWaiter.IsWaiting do;
end;

//Desc: 继续运行
procedure TMultJSItem.ResumeThread;
begin
  while not FWaiter.IsWaiting do;
  FWaiter.Interval := cMultiJS_Interval;

  FWaiter.Wakeup;
  while not FWaiter.IsWaiting do;
end;

procedure TMultJSItem.DoSyncEvent(const nData: Pointer; const nSize: Cardinal);
begin
  if Assigned(FOwner.FTunnelEvent) then
  begin
    FOwner.FTunnelEvent(FPort.FCOMPort, PMultiJSTunnel(nData)^);
  end;
end;

procedure TMultJSItem.DoSyncFree(const nData: Pointer; const nSize: Cardinal);
begin
  Dispose(PMultiJSTunnel(nData));
end;

//Desc: 线程体
procedure TMultJSItem.Execute;
var nIdx,nLen,nInt,nDS: Integer;
    nStr,nTruck,nTmp: string;
    nTunnel,nSync: PMultiJSTunnel;
begin
  while not Terminated do
  try
    FWaiter.EnterWait;
    if FWaiter.WaitResult <> WAIT_TIMEOUT then Continue;

    if not FComObj.Connected then
    begin
      FComObj.Port := FPort.FCOMPort;
      FComObj.BaudRate := StrToBaudRate(IntToStr(FPort.FBaudRate));

      FComObj.SyncMethod := smNone;
      FComObj.Timeouts.ReadInterval := 100;
      FComObj.Timeouts.ReadTotalMultiplier := 20;
      FComObj.Open;

      if FComObj.Connected then
        FComObj.ClearBuffer(True, True);
      //xxxxx
    end;

    if not FComObj.Connected then Continue;
    nStr := #$0A + #$55;

    for nIdx:=0 to FPort.FTunnel.Count - 1 do
    begin
      nTunnel := FPort.FTunnel[nIdx];
      nTruck := nTunnel.FTruck;
      nTruck := StringOfChar('0', cMultiJS_Truck - Length(nTruck)) + nTruck;

      nTmp := IntToStr(nTunnel.FDaiNum);
      nTmp := StringOfChar('0', cMultiJS_DaiNum - Length(nTmp)) + nTmp;

      nStr := nStr + Format('%d%d%s%s', [nTunnel.FTunnel, nTunnel.FDelay,
                     nTruck, nTmp]);
      //xxxxx
    end;

    nStr := nStr + #$0D;
    FComObj.ClearBuffer(True, False);
    FComObj.Write(PChar(nStr), Length(nStr));
    //发送数据

    //--------------------------------------------------------------------------
    nLen := 5 * FPort.FTunnel.Count + 3;
    //有效长度=(1位道号 + 4位袋数) * 道数 + 帧头帧尾
    SetLength(nStr, nLen);
    FillChar(PChar(nStr)^, nLen, #0);

    if FComObj.Read(PChar(nStr), nLen) <> nLen then  Continue;
    //读取数据

    if (nStr[1]<>#$0A) or (nStr[2]<>#$55) or (nStr[nLen]<>#$0D) then Continue;
    //无效数据

    nInt := 0;
    nStr := Copy(nStr, 3, nLen - 3);

    for nIdx:=0 to FPort.FTunnel.Count - 1 do
    begin
      if Terminated then Exit;
      nTmp := Copy(nStr, nIdx * 5 + 1, 5);
      //1位道号 + 4位袋数

      nTunnel := FPort.FTunnel[nIdx];
      if nTmp[1] <> IntToStr(nTunnel.FTunnel) then Continue;

      System.Delete(nTmp, 1, 1);
      if not IsNumber(nTmp, False) then Continue;

      if StrToInt(nTmp) > nTunnel.FHasDone then
      begin
        nDS := StrToInt(nTmp);
        if (nDS - nTunnel.FHasDone > 1) and
           (nTunnel.FLastRead - nTunnel.FLastRecv < nTunnel.FDelay * 2 * 100) then
        begin
          nTunnel.FLastRead := GetTickCount; Continue;
        end;
        //小于两个延迟收到多于一袋,认为无效

        nTunnel.FLastRead := GetTickCount;
        nTunnel.FLastRecv := nTunnel.FLastRead;

        nTunnel.FHasDone := nDS;
        New(nSync);
        Move(nTunnel^, nSync^, cSize_Tunnel);

        FSyncer.AddData(nSync, cSize_Tunnel);
        Inc(nInt);
      end;

      if nTunnel.FHasDone >= nTunnel.FDaiNum then
      begin
        nLen := nTunnel.FTunnel;
        nDS := nTunnel.FDaiNum;
        FillChar(nTunnel^, cSize_Tunnel, #0);
        
        if nDS > 0 then
          nTunnel.FDaiNum := cStopDaiNum;
        nTunnel.FTunnel := nLen;
      end;
    end;

    if nInt > 0 then
      FSyncer.ApplySync;
    //xxxxx
  except
    //ignor any error
  end;
end;

//------------------------------------------------------------------------------
constructor TMultiJSManager.Create;
begin
  FPorts := TList.Create;
end;

destructor TMultiJSManager.Destroy;
begin
  ClearPorts(True);
  inherited;
end;

//Desc: 清理端口数据
procedure TMultiJSManager.ClearPorts(const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx:=FPorts.Count - 1 downto 0 do
  begin
    ClearPort(FPorts[nIdx]);
    FPorts.Delete(nIdx);
  end;

  if nFree then
    FreeAndNil(FPorts);
  //xxxxx
end;

//Desc: 释放nData端口
procedure TMultiJSManager.ClearPort(const nPort: PMultiJSPortData);
var nIdx: Integer;
begin
  nPort.FReader.StopThread;
  //stop thread first
  
  for nIdx:=nPort.FTunnel.Count - 1 downto 0 do
  begin
    Dispose(PMultiJSTunnel(nPort.FTunnel[nIdx]));
    nPort.FTunnel.Delete(nIdx);
  end;

  nPort.FTunnel.Free;
  Dispose(nPort);
end;

//Desc: 返回端口nPort的索引
function TMultiJSManager.GetPort(const nPort: string): Integer;
var nIdx: Integer;
begin
  Result := -1;

  for nIdx:=FPorts.Count - 1 downto 0 do
  if CompareStr(nPort, PMultiJSPortData(FPorts[nIdx]).FCOMPort) = 0 then
  begin
    Result := nIdx; Break;
  end;
end;

//Date: 2010-11-22
//Parm: 端口;波特率;道数
//Desc: 添加一个波特率为nBaunRate,道数为nTunnelNum的端口
procedure TMultiJSManager.AddPort(const nCOMPort: string; const nBaudRate: Word;
  const nTunnelNum: Byte);
var nStr: string;
    nIdx: Integer;
    nPort: PMultiJSPortData;
    nTunnel: PMultiJSTunnel;
begin
  if nTunnelNum > cMultiJS_Tunnel then
  begin
    nStr := Format('道数为最大[ %d ]的整数', [cMultiJS_Tunnel]);
    raise Exception.Create(nStr);
  end;

  nPort := nil;
  try
    nIdx := GetPort(nCOMPort);
    if nIdx > -1 then
      nPort := FPorts[nIdx];
    //xxxxx
    
    if not Assigned(nPort) then
    begin
      New(nPort);
      FPorts.Add(nPort);
      FillChar(nPort^, cSize_Port, #0);

      StrPCopy(@nPort.FCOMPort[0], nCOMPort);
      nPort.FTunnel := TList.Create;
      nPort.FReader := TMultJSItem.Create(Self, nPort);
    end;

    nPort.FReader.SuspendThread;
    //stop thread

    if nPort.FBaudRate <> nBaudRate then
    begin
      nPort.FReader.FComObj.Close;
      nPort.FBaudRate := nBaudRate;
    end;

    if nPort.FTunnel.Count > nTunnelNum then
    begin
      for nIdx:=nPort.FTunnel.Count - 1 downto nTunnelNum do
      begin
        Dispose(PMultiJSTunnel(nPort.FTunnel[nIdx]));
        nPort.FTunnel.Delete(nIdx);
      end;
    end else

    if nPort.FTunnel.Count < nTunnelNum then
    begin
      for nIdx:=nPort.FTunnel.Count to nTunnelNum - 1 do
      begin
        New(nTunnel);
        nPort.FTunnel.Add(nTunnel);

        FillChar(nTunnel^, cSize_Tunnel, #0);
        nTunnel.FTunnel := nIdx + 1;
      end;
    end;
  finally
    if Assigned(nPort) then
      nPort.FReader.ResumeThread;
    //xxxxx
  end;
end;

//Desc: 删除nCOMPort端口
function TMultiJSManager.DelPort(const nCOMPort: string;
  var nHint: string): Boolean;
var nIdx: Integer;
begin
  for nIdx:=FPorts.Count - 1 downto 0 do
  if CompareStr(nCOMPort, PMultiJSPortData(FPorts[nIdx]).FCOMPort) = 0 then
  begin
    ClearPort(FPorts[nIdx]);
    FPorts.Delete(nIdx);
    
    Result := True;
    nHint := ''; Exit;
  end;

  Result := False;
  nHint := Format('没有找到[ %s ]端口', [nCOMPort]);
end;

//Date: 2010-11-22
//Parm: 端口;道号;延迟;车牌;袋数;提示内容
//Desc: 在nCOMPort.nTunnel道上添加一个nTruck.nDaiNum计数
function TMultiJSManager.SetTunnelData(const nCOMPort: string;
  const nTunnel,nDelay: Word; const nTruck: string; const nDaiNum: Word;
  var nHint: string): Boolean;
var nIdx: Integer;
    nPort: PMultiJSPortData;
    nPTunnel: PMultiJSTunnel;
begin
  Result := False;
  if nDelay > cMultiJS_Delay then
  begin
    nHint := Format('延迟为最大[ %d ]的整数', [cMultiJS_Delay]); Exit;
  end;

  if Length(IntToStr(nDaiNum)) > cMultiJS_DaiNum then
  begin
    nHint := Format('袋数最多为[ %d ]位整数', [cMultiJS_DaiNum]); Exit;
  end;

  nIdx := GetPort(nCOMPort);
  if nIdx < 0 then
  begin
    nHint := '无效的通讯端口'; Exit;
  end;

  nPTunnel := nil;
  nPort := FPorts[nIdx];

  for nIdx:=nPort.FTunnel.Count - 1 downto 0 do
  if PMultiJSTunnel(nPort.FTunnel[nIdx]).FTunnel = nTunnel then
  begin
    nPTunnel := nPort.FTunnel[nIdx]; Break;
  end;

  if not Assigned(nPTunnel) then
  begin
    nHint := '无效的装车道号'; Exit;
  end;

  nPort.FReader.SuspendThread;
  try
    if (nDaiNum <> cStopDaiNum) and (nPTunnel.FDaiNum <> cStopDaiNum) then
     if (nDaiNum > 0) and (nPTunnel.FDaiNum > nPTunnel.FHasDone) then
      begin
        nHint := '该道装车中,请稍候'; Exit;
      end;
    //valid check

    nIdx := nPTunnel.FTunnel;
    FillChar(nPTunnel^, cSize_Tunnel, #0);
    nPTunnel.FTunnel := nIdx;

    nPTunnel.FDelay := nDelay;
    nPTunnel.FDaiNum := nDaiNum;

    nIdx := cMultiJS_Truck;
    StrPCopy(@nPTunnel.FTruck, Copy(nTruck, Length(nTruck) - nIdx + 1, nIdx));

    nHint := '';
    Result := True;
  finally
    nPort.FReader.ResumeThread;
  end;
end;

//Date: 2010-11-22
//Parm: 端口;道号;提示内容
//Desc: 停止nCOMPort.nTunnel道的计数
function TMultiJSManager.StopTunnel(const nCOMPort: string;
  const nTunnel: Word; var nHint: string): Boolean;
begin
  Result := SetTunnelData(nCOMPort, nTunnel, 0, '', cStopDaiNum, nHint);
end;

end.
