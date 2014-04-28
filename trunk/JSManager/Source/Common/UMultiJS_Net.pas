{*******************************************************************************
  作者: dmzn@163.com 2010-11-22
  描述: 多道计数器管理

  备注:
  *.本单元实现了TCP模式的一机多装车道的计数管理器.
*******************************************************************************}
unit UMultiJS_Net;

interface

uses
  Windows, Classes, SysUtils, SyncObjs, NativeXml, UMgrSync, UWaitItem, ULibFun,
  USysLoger, IdGlobal, IdTCPConnection, IdTCPClient;

const   
  cMultiJS_Truck           = 8;         //车牌长度
  cMultiJS_DaiNum          = 5;         //袋数长度
  cMultiJS_Delay           = 9;         //最大延迟
  cMultiJS_Tunnel          = 10;        //最大道数
  cMultiJS_Interval        = 1200;      //刷新频率

  cFrame_Control           = $05;       //控制帧
  cFrame_Display           = $09;       //显示帧
  cFrame_Query             = $12;       //查询帧
  cFrame_Clear             = $27;       //清理帧

type
  TMultiJSManager = class;
  TMultJSItem = class;

  PMultiJSTunnel = ^TMultiJSTunnel;
  TMultiJSTunnel = record
    FID: string;
    FName: string;    
    //通道标识
    FTunnel: Word;
    //车道编号
    FDelay: Word;
    //延迟时间
    FReader: string;
    //读头地址
    FTruck: array[0..cMultiJS_Truck - 1] of Char;
    //车牌号
    FDaiNum: Word;
    //需装袋数
    FHasDone: Word;
    //已装袋数
  end;

  PMultiJSHost= ^TMultiJSHost;
  TMultiJSHost = record
    FName: string;
    FHostIP: string;
    FHostPort: Integer;
    //主机信息
    F485Addr: Byte;
    //链路地址
    FTunnelNum: Byte;
    //有效道数
    FTunnel: TList;
    //车道数据
    FReader: TMultJSItem;
    //操作线程
  end;

  TMultiJSPeerSend = record
    FAddr: Byte;
    FDelay: Byte;
    FTruck: array[0..cMultiJS_Truck - 1] of Char;
    FDai: array[0..cMultiJS_DaiNum - 1] of Char;
  end;

  PMultiJSDataSend = ^TMultiJSDataSend;
  TMultiJSDataSend = record
    FHeader : array[0..1] of Byte;    //帧头
    FAddr   : Byte;                   //485地址
    FType   : Byte;                   //控制,查询
    FData   : TMultiJSPeerSend;       //有效数据
    FEnd    : Byte;                   //结束帧
  end;

  TMultiJSPeerRecv = record
    FAddr: Byte;
    FDai: array[0..cMultiJS_DaiNum - 1] of Char;
  end;

  PMultiJSDataRecv = ^TMultiJSDataRecv;
  TMultiJSDataRecv = record
    FHeader : array[0..1] of Char;    //帧头
    FAddr   : Byte;                   //485地址
    FType   : Byte;                   //控制,查询
    FData   : array[0..cMultiJS_Tunnel - 1] of TMultiJSPeerRecv;
    FEnd    : Byte;                   //结束帧
  end;

  TMultJSItem = class(TThread)
  private
    FOwner: TMultiJSManager;
    //拥有者
    FHost: PMultiJSHost;
    //计数器
    FClient: TIdTCPClient;
    //客户端
    FTmpList: TList;
    FBuffer: TThreadList;
    //发送缓冲
    FRecv: TMultiJSDataRecv;
    //接收缓冲
    FNowTunnel: PMultiJSTunnel;
    //当前通道
    FWaiter: TWaitObject;
    //等待对象
  protected
    procedure Execute; override;
    //线程体
    procedure ClearBuffer(const nList: TList);
    //清空缓冲
    procedure DeleteFromBuffer(nAddr: Byte; nList: TList);
    //删除指令
    procedure AddQueryFrame(const nList: TList);
    //查询指令
    procedure SendDataFrame(const nData: PMultiJSDataSend);
    //发送数据
    procedure ApplyRespondData;
    //更新袋数
    function GetTunnel(const nTunnel: Byte): PMultiJSTunnel;
    //检索通道
    procedure SyncNowTunnel;
    //同步通道
  public
    constructor Create(AOwner: TMultiJSManager; nHost: PMultiJSHost);
    destructor Destroy; override;
    //创建释放
    procedure Wakeup;
    procedure StopMe;
    //停止线程
  end;

  TMultiJSChange = procedure (const nTunnel: PMultiJSTunnel) of object;
  //事件

  TMultiJSManager = class(TObject)
  private
    FEnableQuery: Boolean;
    //计数查询
    FEnableCount: Boolean;
    //开启计数
    FHosts: TList;
    //主机列表
    FFileName: string;
    //配置文件
    FChangeThread: TMultiJSChange;
    FChangeSync: TMultiJSChange;
    //事件相关
  protected
    procedure DisposeHost(const nHost: PMultiJSHost);
    procedure ClearHost(const nFree: Boolean);
    //清理数据
    function GetTunnel(const nID: string; var nHost: PMultiJSHost;
      var nTunnel: PMultiJSTunnel): Boolean;
    //检索通道
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放
    procedure LoadFile(const nFile: string);
    //读取配置
    procedure StartJS;
    procedure StopJS;
    //启停计数
    function AddJS(const nTunnel,nTruck:string; const nDaiNum: Integer;
     const nOnlyDisplay: Boolean = False): Boolean;
    //添加计数
    function DelJS(const nTunnel: string): Boolean;
    //删除计数
    function GetJSStatus(const nList: TStrings): Boolean;
    //计数状态
    property Hosts: TList read FHosts;
    property FileName: string read FFileName;
    property QueryEnable: Boolean read FEnableQuery write FEnableQuery;
    property CountEnable: Boolean read FEnableCount write FEnableCount;
    property ChangeSync: TMultiJSChange read FChangeSync write FChangeSync;
    property ChangeThread: TMultiJSChange read FChangeThread write FChangeThread;
    //属性相关
  end;

var
  gMultiJSManager: TMultiJSManager = nil;
  //全局使用

implementation

const
  cSizeHost         = SizeOf(TMultiJSHost);
  cSizeTunnel       = SizeOf(TMultiJSTunnel);
  cSizeDataSend     = SizeOf(TMultiJSDataSend);
  cSizeDataRecv     = SizeOf(TMultiJSDataRecv);
  cSizePeerRecv     = SizeOf(TMultiJSPeerRecv);
                                             
//------------------------------------------------------------------------------
procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TMultiJSManager, '多道计数管理器', nEvent);
end;  

constructor TMultJSItem.Create(AOwner: TMultiJSManager; nHost: PMultiJSHost);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FOwner := AOwner;
  FHost := nHost;

  FTmpList := TList.Create;
  FBuffer := TThreadList.Create;
  
  FWaiter := TWaitObject.Create;
  FWaiter.Interval := cMultiJS_Interval;

  FClient := TIdTCPClient.Create;
  FClient.ReadTimeout := 5 * 1000;
  FClient.ConnectTimeout := 5 * 1000;
end;

destructor TMultJSItem.Destroy;
var nList: TList;
begin
  FClient.Disconnect;
  FClient.Free;
  
  nList := FBuffer.LockList;
  try
    ClearBuffer(nList);
  finally
    FBuffer.UnlockList;
    FBuffer.Free;
  end;
       
  ClearBuffer(FTmpList);
  FTmpList.Free;

  FWaiter.Free;
  inherited;
end;

procedure TMultJSItem.ClearBuffer(const nList: TList);
var nIdx: Integer;
begin
  for nIdx:=nList.Count - 1 downto 0 do
  begin
    Dispose(PMultiJSDataSend(nList[nIdx]));
    nList.Delete(nIdx);
  end;
end;

//Date: 2012-4-23
//Parm: 通道编号;列表
//Desc: 从nList中删除标识为nTunnel的数据
procedure TMultJSItem.DeleteFromBuffer(nAddr: Byte; nList: TList);
var nIdx: Integer;
    nData: PMultiJSDataSend;
begin
  for nIdx:=nList.Count - 1 downto 0 do
  begin
    nData := nList[nIdx];
    if nData.FData.FAddr = nAddr then
    begin
      Dispose(nData);
      nList.Delete(nIdx);
      Exit;
    end;
  end;
end;

//Desc: 释放线程
procedure TMultJSItem.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

//Desc: 唤醒线程
procedure TMultJSItem.Wakeup;
begin
  FWaiter.Wakeup;
end;

//Desc: 线程体
procedure TMultJSItem.Execute;
var nIdx: Integer;
    nList: TList;
begin
  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Exit;

    try
      if not FClient.Connected then
      begin
        FClient.Host := FHost.FHostIP;
        FClient.Port := FHost.FHostPort;
        FClient.Connect;
      end;
    except
      WriteLog(Format('连接计数器[ %s ]失败', [FHost.FHostIP]));
      FClient.Disconnect;
      Continue;
    end;

    nList := FBuffer.LockList;
    try
      for nIdx:=0 to nList.Count - 1 do
        FTmpList.Add(nList[nIdx]);
      nList.Clear;
    finally
      FBuffer.UnlockList;
    end;

    if (FTmpList.Count < 1) and FOwner.FEnableQuery then
      AddQueryFrame(FTmpList);
    //添加查询帧

    if FTmpList.Count > 0 then
    try
      FClient.Socket.InputBuffer.Clear;
      //清空缓冲

      for nIdx:=0 to FTmpList.Count - 1 do
        SendDataFrame(FTmpList[nIdx]);
      //发送数据帧

      ClearBuffer(FTmpList);
    except
      ClearBuffer(FTmpList);
      FClient.Disconnect;
      
      if Assigned(FClient.IOHandler) then
        FClient.IOHandler.InputBuffer.Clear;
      raise;
    end;
  except
    On E:Exception do
    begin
      WriteLog(Format('Host:[ %s ] %s', [FHost.FHostIP, E.Message]));
    end;
  end;
end;

//Desc: 在nList中添加查询帧
procedure TMultJSItem.AddQueryFrame(const nList: TList);
var nSend: PMultiJSDataSend;
begin
  New(nSend);
  nList.Add(nSend);
  FillChar(nSend^, cSizeDataSend, #0);

  with nSend^ do
  begin
    FHeader[0] := $0A;
    FHeader[1] := $55;
    FAddr := FHost.F485Addr;

    FType := cFrame_Query;
    FEnd := $0D;
  end;
end;

//Desc: 发送数据
procedure TMultJSItem.SendDataFrame(const nData: PMultiJSDataSend);
var nBuf: TIdBytes;
    nSize: Integer;
begin
  nBuf := RawToBytes(nData^, cSizeDataSend);
  FClient.Socket.Write(nBuf);

  nSize := cSizeDataRecv - (cMultiJS_Tunnel - FHost.FTunnelNum) * cSizePeerRecv;
  FClient.Socket.ReadBytes(nBuf, nSize, False);

  BytesToRaw(nBuf, FRecv, nSize);
  ApplyRespondData;
end;

//Desc: 同步当前通道
procedure TMultJSItem.SyncNowTunnel;
begin
  FOwner.FChangeSync(FNowTunnel);
end;

//Desc: 更新袋数变更情况
procedure TMultJSItem.ApplyRespondData;
var nIdx,nInt: Integer;
    nTunnel: PMultiJSTunnel;
begin
  for nIdx:=0 to FHost.FTunnelNum - 1 do
  begin
    nTunnel := GetTunnel(FRecv.FData[nIdx].FAddr);
    if not Assigned(nTunnel) then Continue;

    nInt := StrToInt(FRecv.FData[nIdx].FDai);
    if nTunnel.FHasDone = nInt then Continue;
    nTunnel.FHasDone := nInt;

    if Assigned(FOwner.FChangeThread) then
      FOwner.FChangeThread(nTunnel);
    //thread event

    if Assigned(FOwner.FChangeSync) then
    try 
      FNowTunnel := nTunnel;
      Synchronize(SyncNowTunnel);
    except
      //ignor any error
    end;
  end;
end;

//Date: 2012-4-23
//Parm: 通道号
//Desc: 检索nTunnel通道
function TMultJSItem.GetTunnel(const nTunnel: Byte): PMultiJSTunnel;
var nIdx: Integer;
begin
  Result := nil;

  for nIdx:=0 to FHost.FTunnel.Count - 1 do
  if PMultiJSTunnel(FHost.FTunnel[nIdx]).FTunnel = nTunnel then
  begin
    Result := FHost.FTunnel[nIdx];
    Exit;
  end;
end;

//------------------------------------------------------------------------------
constructor TMultiJSManager.Create;
begin
  FEnableQuery := False;
  FEnableCount := False;
  FHosts := TList.Create;
end;

destructor TMultiJSManager.Destroy;
begin
  StopJS;
  ClearHost(True);
  inherited;
end;

//Desc: 释放nData端口
procedure TMultiJSManager.DisposeHost(const nHost: PMultiJSHost);
var nIdx: Integer;
begin
  for nIdx:=nHost.FTunnel.Count - 1 downto 0 do
  begin
    Dispose(PMultiJSTunnel(nHost.FTunnel[nIdx]));
    nHost.FTunnel.Delete(nIdx);
  end;

  nHost.FTunnel.Free;
  Dispose(nHost);
end;

//Desc: 清理端口数据
procedure TMultiJSManager.ClearHost(const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx:=FHosts.Count - 1 downto 0 do
  begin
    DisposeHost(FHosts[nIdx]);
    FHosts.Delete(nIdx);
  end;

  if nFree then
    FreeAndNil(FHosts);
  //xxxxx
end;

//Desc: 启动计数
procedure TMultiJSManager.StartJS;
var nIdx: Integer;
    nHost: PMultiJSHost;
begin
  if FEnableCount then
  begin
    for nIdx:=0 to FHosts.Count - 1 do
    begin
      nHost := FHosts[nIdx];
      if Assigned(nHost.FReader) then Continue;

      nHost.FReader := TMultJSItem.Create(Self, nHost);
      //new reader
    end;
  end;
end;

//Desc: 停止计数
procedure TMultiJSManager.StopJS;
var nIdx: Integer;
    nHost: PMultiJSHost;
begin
  for nIdx:=0 to FHosts.Count - 1 do
  begin
    nHost := FHosts[nIdx];
    if Assigned(nHost.FReader) then
    begin
      nHost.FReader.StopMe;
      nHost.FReader := nil;
    end;
  end;
end;

//Desc: 读取计数配置
procedure TMultiJSManager.LoadFile(const nFile: string);
var i,nIdx: Integer;
    nNode,nTmp: TXmlNode;
    nXML: TNativeXml;
    nHost: PMultiJSHost;
    nTunnel: PMultiJSTunnel;
begin
  FFileName := nFile;
  nXML := TNativeXml.Create;
  try
    ClearHost(False);
    nXML.LoadFromFile(nFile);

    nTmp := nXML.Root.FindNode('config');
    if Assigned(nTmp) then
    begin
      nIdx := nTmp.NodeByName('query').ValueAsInteger;
      FEnableQuery := nIdx = 1;

      nIdx := nTmp.NodeByName('count').ValueAsInteger;
      FEnableCount := nIdx = 1;
    end;

    for nIdx:=0 to nXML.Root.NodeCount - 1 do
    begin
      nTmp := nXML.Root.Nodes[nIdx];
      if nTmp.Name <> 'item' then Continue;
      
      New(nHost);
      FHosts.Add(nHost);

      with nHost^ do
      begin
        FName := nTmp.AttributeByName['name'];
        nNode := nTmp.NodeByName('param');

        FHostIP := nNode.NodeByName('ip').ValueAsString;
        FHostPort := nNode.NodeByName('port').ValueAsInteger;
        F485Addr := nNode.NodeByName('addr').ValueAsInteger;
        FTunnelNum := nNode.NodeByName('linenum').ValueAsInteger;

        FTunnel := TList.Create;
        FReader := nil;
      end;

      nTmp := nTmp.NodeByName('lines');
      for i:=0 to nTmp.NodeCount - 1 do
      begin
        nNode := nTmp.Nodes[i];
        New(nTunnel);
        nHost.FTunnel.Add(nTunnel);

        with nTunnel^ do
        begin
          FID := nNode.NodeByName('id').ValueAsString;
          FName := nNode.NodeByName('name').ValueAsString;
          FTunnel := nNode.NodeByName('tunnel').ValueAsInteger;
          FDelay := nNode.NodeByName('delay').ValueAsInteger;
        end;
      end;
    end;
  finally
    nXML.Free;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2012-4-23
//Parm: 通道标识
//Desc: 检索nID通道
function TMultiJSManager.GetTunnel(const nID: string; var nHost: PMultiJSHost;
  var nTunnel: PMultiJSTunnel): Boolean;
var i,nIdx: Integer;
    nPHost: PMultiJSHost;
    nPTunnel: PMultiJSTunnel;
begin
  Result := False;

  for i:=0 to FHosts.Count - 1 do
  begin
    nPHost := FHosts[i];
    for nIdx:=0 to nPHost.FTunnel.Count - 1 do
    begin
      nPTunnel := nPHost.FTunnel[nIdx];
      if CompareText(nID, nPTunnel.FID) = 0 then
      begin
        nHost := nPHost;
        nTunnel := nPTunnel;

        Result := True;
        Exit;
      end;
    end;
  end;
end;

//Date: 2012-4-23
//Parm: 通道标识;车牌;袋数;只显示不启动
//Desc: 在nTunnel添加一个计数操作
function TMultiJSManager.AddJS(const nTunnel, nTruck: string;
 const nDaiNum: Integer; const nOnlyDisplay: Boolean): Boolean;
var nStr: string;
    nList: TList;
    nPH: PMultiJSHost;
    nPT: PMultiJSTunnel;
    nSend: PMultiJSDataSend;
begin
  Result := False;
  if not FEnableCount then
  begin
    WriteLog('计数器未开启config.count参数.');
    Exit;
  end;

  if not (GetTunnel(nTunnel, nPH, nPT) and Assigned(nPH.FReader)) then
  begin
    WriteLog(Format('通道号[ %s ]无效.', [nTunnel]));
    Exit;
  end;

  nList := nPH.FReader.FBuffer.LockList;
  try
    nPH.FReader.DeleteFromBuffer(nPT.FTunnel, nList);
    //覆盖未执行命令

    New(nSend);
    nList.Add(nSend);

    FillChar(nSend^, cSizeDataSend, #0);
    //init

    with nSend^ do
    begin
      FHeader[0] := $0A;
      FHeader[1] := $55;
      FAddr := nPH.F485Addr;

      if nOnlyDisplay then
           FType := cFrame_Display
      else FType := cFrame_Control;

      with FData do
      begin
        FAddr := nPT.FTunnel;
        FDelay := nPT.FDelay;

        nStr := Copy(nTruck, 1, cMultiJS_Truck);
        nStr := nStr + StringOfChar(' ', cMultiJS_Truck - Length(nStr));
        StrPCopy(@FTruck[0], nStr);

        nPT.FDaiNum := nDaiNum;
        nStr := IntToStr(nDaiNum);
        nStr := StringOfChar('0', cMultiJS_DaiNum - Length(nStr)) + nStr;
        StrPCopy(@FDai[0], nStr);
      end;

      FEnd := $0D;
    end;

    Result := True;
  finally
    nPH.FReader.FBuffer.UnlockList;
  end;
end;

//Date: 2012-4-23
//Parm: 通道号
//Desc: 停止nTunnel计数
function TMultiJSManager.DelJS(const nTunnel: string): Boolean;
var nList: TList;
    nPH: PMultiJSHost;
    nPT: PMultiJSTunnel;
    nSend: PMultiJSDataSend;
begin
  Result := False;
  if not (GetTunnel(nTunnel, nPH, nPT) and Assigned(nPH.FReader)) then
  begin
    WriteLog(Format('通道号[ %s ]无效.', [nTunnel]));
    Exit;
  end;

  nList := nPH.FReader.FBuffer.LockList;
  try
    nPH.FReader.DeleteFromBuffer(nPT.FTunnel, nList);
    //覆盖未执行命令
    
    New(nSend);
    nList.Add(nSend);

    FillChar(nSend^, cSizeDataSend, #0);
    //init

    with nSend^ do
    begin
      FHeader[0] := $0A;
      FHeader[1] := $55;
      FAddr := nPH.F485Addr;
      FType := cFrame_Clear;

      FData.FAddr := nPT.FTunnel;
      FEnd := $0D;
    end;

    Result := True;
  finally
    nPH.FReader.FBuffer.UnlockList;
  end;
end;

//Date: 2013-07-22
//Parm: 结果列表(tunnel=dai)
//Desc: 获取各通道的计数结果
function TMultiJSManager.GetJSStatus(const nList: TStrings): Boolean;
var i,nIdx: Integer;
    nPHost: PMultiJSHost;
    nPTunnel: PMultiJSTunnel;
begin
  Result := True;
  nList.Clear;

  for i:=0 to FHosts.Count - 1 do
  begin
    nPHost := FHosts[i];
    for nIdx:=0 to nPHost.FTunnel.Count - 1 do
    begin
      nPHost.FReader.FBuffer.LockList;
      try
        nPTunnel := nPHost.FTunnel[nIdx];
        nList.Values[nPTunnel.FID] := IntToStr(nPTunnel.FHasDone);
      finally
        nPHost.FReader.FBuffer.UnlockList;
      end;
    end
  end;
end;

initialization
  gMultiJSManager := TMultiJSManager.Create;
finalization
  FreeAndNil(gMultiJSManager);
end.
