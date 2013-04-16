{*******************************************************************************
  作者: dmzn@163.com 2013-3-7
  描述: 通讯协议
*******************************************************************************}
unit USysProtocol;

interface

uses
  Windows, Classes, Graphics, SysUtils, SyncObjs, CPortTypes;
  
const
  cHeader_0           = $FE;
  cHeader_1           = $FE;
  cHeader_2           = $FE;                  //起始字节
  cFooter_0           = $FD;                  //结束字节
  cFrameIDMax         = $FC;                  //最大报文
  cAddr_Broadcast     = $7F;                  //广播地址
  
  cFun_Query          = $01;                  //查询指令
  cFun_Repair         = $02;                  //补帧指令
  cFun_SetIndex       = $03;                  //设置地址
  cFun_DevLocate      = $04;                  //装置定位
  cFun_SetTime        = $05;                  //设置时间
  cFun_BreakPipeMin   = $06;                  //制动管零点
  cFun_BreakPipeMax   = $07;                  //制动管满度
  cFun_BreakPotMin    = $08;                  //制动缸零点
  cFun_BreakPotMax    = $09;                  //制动缸满度
  cFun_TotalPipeMin   = $0A;                  //总风管零度
  cFun_TotalPipeMax   = $0B;                  //总风管满度
  cFun_Reset          = $0C;                  //重置数据

type
  PDataItem = ^TDataItem;
  TDataItem = record
    FHeader: array[0..2] of Byte;             //起始符
    FIndex: Byte;                             //地址索引
    FFunction: Byte;                          //功能码
    FDataLen: Byte;                           //数据长度
    FData: array[0..63] of Byte;              //数据
    FCRC: Byte;                               //校验值
    FFooter: Byte;                            //结束符
  end;

  PBufferData = ^TBufferData;
  TBufferData = record
    FUsed: Boolean;                           //是否使用
    FData: PDataItem;                         //数据指针
  end;

  TDataBytes = array of Byte;                 //字节组

const
  cSize_DataItem = SizeOf(TDataItem);         //字节数

type
  TDataBufferManager = class(TObject)
  private
    FBuffer: TList;
    //数据缓存
    FSyncLock: TCriticalSection;
    //同步锁定
  protected
    procedure ClearBuffer(const nFree: Boolean);
    //清理资源
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放
    function LockData: PDataItem;
    procedure ReleaseData(const nData: PDataItem);
    //锁定释放
  end;

//------------------------------------------------------------------------------
const
  cCOM_BaudRate: TBaudRate = br4800;          //波特率
  cCOM_DataBits: TDataBits = dbEight;         //数据位
  cCOM_StopBits: TStopBits = sbOneStopBit;    //停止位

type
  TItemType = (itBreakPipe, itBreakPot, itTotalPipe);
  //项类型
  TItemFlag = (ifRoot, ifPort, ifDevice, ifDeviceUnusedRoot, ifDeviceUnused);
  //项标

  PCarriageItem = ^TCarriageItem;
  TCarriageItem = record
    FItemID: string;                          //车厢标识
    FName: string;                            //车厢名称
    FPostion: Word;                           //车厢位置

    FTypeID: Word;
    FTypeName: string;                        //车厢类型
    FModeID: Word;
    FModeName: string;                        //车厢型号
  end;

  TDeviceData = record
    FNum: Word;                               //个数
    FData: Word;                              //数据
  end;

  PDeviceItem = ^TDeviceItem;
  TDeviceItem = record
    FItemID: string;                          //设备标识
    FCOMPort: string;                         //所在串口
    FIndex: Byte;                             //地址索引
    FSerial: string;                          //装置编号

    FCarriageID: string;                      //车厢标识
    FCarriage: PCarriageItem;                 //所在车厢

    FColorBreakPipe: TColor;
    FColorBreakPot: TColor;
    FColorTotalPipe: TColor;                  //曲线颜色

    FLastActive: Int64;                       //上次活动
    FLastFrameID: Byte;                       //上次帧号
    FDeviceUsed: Boolean;                     //已使用
    FDeviceValid: Boolean;                    //设备有效

    //--------------------------------------------------------------------------
    FTotalPipeTimeBase: TDateTime;            //时间基准
    FTotalPipeTimeNow: TDateTime;             //当前时间
    FTotalPipe: Word;                         //总风管

    FBreakPipeTimeBase: TDateTime;            //时间基准
    FBreakPipeTimeNow: TDateTime;             //当前时间
    FBreakPipeNum: Word;
    FBreakPipe: array[0..31] of TDeviceData;  //制动管

    FBreakPotTimeBase: TDateTime;             //时间基准
    FBreakPotTimeNow: TDateTime;              //当前时间
    FBreakPotNum: Word;
    FBreakPot: array[0..31] of TDeviceData;   //制动缸
  end;

  PCOMParam = ^TCOMParam;
  TCOMParam = record
    FItemID: string;                          //串口标识
    FName: string;                            //串口名称
    FPostion: Word;                           //串口位置

    FPortName: string;                        //通信端口
    FBaudRate: TBaudRate;                     //波特率
    FDataBits: TDataBits;                     //数据位
    FStopBits: TStopBits;                     //停止位

    FRunFlag: string;                         //运行标记
    FLastActive: Int64;                       //上次活动
    FLastQuery: Int64;                        //上次查询
    FCOMValid: Boolean;                       //串口有效
  end;

  PCOMItem = ^TCOMItem;
  TCOMItem = record
    FParam: PCOMParam;                        //串口参数
    FDevices: TList;                          //设备列表
  end;

type
  TDeviceManager = class(TObject)
  private
    FCarriages: TList;
    //车厢列表
    FDevices: TList;
    //设备类表
    FParams: TList;
    //参数列表
    FPorts: TList;
    //串口列表
    FSyncLock: TCriticalSection;
    //同步锁定
  protected
    procedure ClearList(const nFree: Boolean);
    procedure ClearPorts(const nFree: Boolean);
    //释放资源
    function FindCarriage(const nItemID: string): Integer;
    function FindDevice(const nItemID: string): Integer;
    function FindParam(const nPort: string): Integer;
    //检索数据
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放
    procedure AddCarriage(const nItem: TCarriageItem);
    //增删车厢
    procedure AddDevice(const nItem: TDeviceItem);
    //增删设备
    procedure AddParam(const nItem: TCOMParam);
    //增删参数
    procedure AdjustDevice;
    //整理设备
    function LockCarriageList: TList;
    function LockDeviceList: TList;
    function LockPortList: TList;  
    procedure ReleaseLock;
    //设备列表
  end;

var
  gDeviceManager: TDeviceManager = nil;
  gDataManager: TDataBufferManager = nil;
  //全局使用

resourcestring
  sBreakPipe          = '制动管';
  sBreakPot           = '制动缸';
  sTotalPipe          = '总风管';             //部件描述
  
implementation

constructor TDataBufferManager.Create;
begin
  FBuffer := TList.Create;
  FSyncLock := TCriticalSection.Create;
end;

destructor TDataBufferManager.Destroy;
begin
  ClearBuffer(True);
  FreeAndNil(FSyncLock);
  inherited;
end;

//Desc: 清理数据缓冲
procedure TDataBufferManager.ClearBuffer(const nFree: Boolean);
var nIdx: Integer;
    nItem: PBufferData;
begin
  for nIdx:=FBuffer.Count - 1 downto 0 do
  begin
    nItem := FBuffer[nIdx];
    FBuffer.Delete(nIdx);

    Dispose(nItem.FData);
    Dispose(nItem);
  end;

  if nFree then
    FreeAndNil(FBuffer);
  //free list
end;

//Date: 2013-3-7
//Parm: none
//Desc: 锁定数据
function TDataBufferManager.LockData: PDataItem;
var nIdx: Integer;
    nItem: PBufferData;
begin
  Result := nil;
  nItem := nil;
  //init

  FSyncLock.Enter;
  try
    for nIdx:=0 to FBuffer.Count - 1 do
     if not PBufferData(FBuffer[nIdx]).FUsed then
     begin
       nItem := FBuffer[nIdx];
       Break;
     end;
    //not used data

    if not Assigned(nItem) then
    begin
      New(nItem);
      New(nItem.FData);
      FBuffer.Add(nItem);
    end;
  finally
    if Assigned(nItem) then
    begin
      nItem.FUsed := True;
      Result := nItem.FData;
    end;
    FSyncLock.Leave;
  end;   
end;

//Date: 2013-3-7
//Parm: 数据
//Desc: 解除nData锁定
procedure TDataBufferManager.ReleaseData(const nData: PDataItem);
var nIdx: Integer;
    nItem: PBufferData;
begin
  if Assigned(nData) then
  try
    FSyncLock.Enter;
    //sync

    for nIdx:=0 to FBuffer.Count - 1 do
    begin
      nItem := FBuffer[nIdx];
      if nItem.FData = nData then
      begin
        nItem.FUsed := False;
        Exit;
      end;
    end;
  finally
    FSyncLock.Leave;
  end;
end;

//------------------------------------------------------------------------------
constructor TDeviceManager.Create;
begin
  FCarriages := TList.Create;
  FDevices := TList.Create;
  FParams := TList.Create;
  FPorts := TList.Create;

  FSyncLock := TCriticalSection.Create;
  //new lock
end;

destructor TDeviceManager.Destroy;
begin
  ClearList(True);
  ClearPorts(True);
  
  FreeAndNil(FSyncLock);
  inherited;
end;

//Desc: 清理资源
procedure TDeviceManager.ClearList(const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx:=FCarriages.Count - 1 downto 0 do
  begin
    Dispose(PCarriageItem(FCarriages[nIdx]));
    FCarriages.Delete(nIdx);
  end;

  for nIdx:=FDevices.Count - 1 downto 0 do
  begin
    Dispose(PDeviceItem(FDevices[nIdx]));
    FDevices.Delete(nIdx);
  end;

  for nIdx:=FParams.Count - 1 downto 0 do
  begin
    Dispose(PCOMParam(FParams[nIdx]));
    FParams.Delete(nIdx);
  end;

  if nFree then
  begin
    FreeAndNil(FCarriages);
    FreeAndNil(FDevices);
    FreeAndNil(FParams);
  end;
end;

//Date: 2013-3-7
//Desc: 清理端口列表
procedure TDeviceManager.ClearPorts(const nFree: Boolean);
var nIdx: Integer;
    nCOM: PCOMItem;
begin
  for nIdx:=FPorts.Count - 1 downto 0 do
  begin
    nCOM := FPorts[nIdx];
    nCOM.FDevices.Free;

    Dispose(nCOM);
    FPorts.Delete(nIdx);
  end;

  if nFree then
    FreeAndNil(FPorts);
  //free list
end;

//Date: 2013-3-7
//Parm: 车厢标识
//Desc: 依据nItemID检索车厢数据,返回索引
function TDeviceManager.FindCarriage(const nItemID: string): Integer;
var nIdx: Integer;
begin
  Result := -1;

  for nIdx:=FCarriages.Count - 1 downto 0 do
  if CompareText(nItemID, PCarriageItem(FCarriages[nIdx]).FItemID) = 0 then
  begin
    Result := nIdx;
    Break;
  end;
end;

//Date: 2013-3-7
//Parm: 设备标识
//Desc: 依据nItemID检索设备信息,返回索引
function TDeviceManager.FindDevice(const nItemID: string): Integer;
var nIdx: Integer;
begin
  Result := -1;

  for nIdx:=FDevices.Count - 1 downto 0 do
  if CompareText(nItemID, PDeviceItem(FDevices[nIdx]).FItemID) = 0 then
  begin
    Result := nIdx;
    Break;
  end;
end;

//Date: 2013-3-7
//Parm: 参数标识
//Desc: 依据nItemID检索参数,返回索引
function TDeviceManager.FindParam(const nPort: string): Integer;
var nIdx: Integer;
begin
  Result := -1;

  for nIdx:=FParams.Count - 1 downto 0 do
  if CompareText(nPort, PCOMParam(FParams[nIdx]).FPortName) = 0 then
  begin
    Result := nIdx;
    Break;
  end;
end;

//Date: 2013-3-7
//Parm: 车厢数据
//Desc: 添加nItem车厢
procedure TDeviceManager.AddCarriage(const nItem: TCarriageItem);
var nIdx: Integer;
    nP: PCarriageItem;
begin
  FSyncLock.Enter;
  try
    nIdx := FindCarriage(nItem.FItemID);
    if nIdx < 0 then
    begin
      New(nP);
      FCarriages.Add(nP);
    end else nP := FCarriages[nIdx];

    nP^ := nItem;
    //new data
  finally
    FSyncLock.Leave;
  end;
end;

//Date: 2013-3-7
//Parm: 设备数据
//Desc: 添加nItem设备
procedure TDeviceManager.AddDevice(const nItem: TDeviceItem);
var nIdx: Integer;
    nP: PDeviceItem;
begin
  FSyncLock.Enter;
  try
    nIdx := FindDevice(nItem.FItemID);
    if nIdx < 0 then
    begin
      New(nP);
      FDevices.Add(nP);
    end else nP := FDevices[nIdx];

    nP^ := nItem;
    nP.FDeviceValid := True;
  finally
    FSyncLock.Leave;
  end;
end;

//Date: 2013-3-7
//Parm: 串口参数
//Desc: 添加nItem参数
procedure TDeviceManager.AddParam(const nItem: TCOMParam);
var nIdx: Integer;
    nP: PCOMParam;
begin
  FSyncLock.Enter;
  try
    nIdx := FindParam(nItem.FPortName);
    if nIdx < 0 then
    begin
      New(nP);
      FParams.Add(nP);
    end else nP := FParams[nIdx];

    nP^ := nItem;
    nP.FCOMValid := True;
  finally
    FSyncLock.Leave;
  end;
end;

//Desc: 锁定车厢
function TDeviceManager.LockCarriageList: TList;
begin
  FSyncLock.Enter;
  Result := FCarriages;
end;

//Desc: 锁定设备
function TDeviceManager.LockDeviceList: TList;
begin
  FSyncLock.Enter;
  Result := FDevices;
end;

//Desc: 锁定串口
function TDeviceManager.LockPortList: TList;
begin
  FSyncLock.Enter;
  Result := FPorts;
end;

//Desc: 解除锁定
procedure TDeviceManager.ReleaseLock;
begin
  FSyncLock.Leave;
end;

//Date: 2013-3-8
//Parm: 设备;设备列表
//Desc: 检索nDevice在nList中应该插入的位置
function GetDevicePos(const nDevice: PDeviceItem; const nList: TList): Integer;
var nIdx: Integer;
    nP: PCarriageItem;
begin
  Result := nList.Count;
  if not Assigned(nDevice.FCarriage) then Exit;

  for nIdx:=0 to nList.Count - 1 do
  begin
    nP := PDeviceItem(nList[nIdx]).FCarriage;

    if Assigned(nP) and (nP.FPostion > nDevice.FCarriage.FPostion) then
    begin
      Result := nIdx;
      Break;
    end;
  end;
end;

//Date: 2013-3-8
//Parm: 参数项;串口列表
//Desc: 检索nParam在nList中应该插入的位置
function GetParamPos(const nParam: PCOMParam; const nList: TList): Integer;
var nIdx: Integer;
begin
  Result := nList.Count;
  //default is last

  for nIdx:=0 to nList.Count - 1 do
  if PCOMItem(nList[nIdx]).FParam.FPostion > nParam.FPostion then
  begin
    Result := nIdx;
    Break;
  end;
end;

//Desc: 将各种参数关联起来
procedure TDeviceManager.AdjustDevice;
var i,nIdx,nPos: Integer;
    nCOM: PCOMItem;
    nDevice: PDeviceItem;
begin
  FSyncLock.Enter;
  try
    for i:=FDevices.Count - 1 downto 0 do
    begin
      nDevice := FDevices[i];
      nDevice.FDeviceUsed := False;
      nIdx := FindCarriage(nDevice.FCarriageID);

      if nIdx < 0 then
           nDevice.FCarriage := nil
      else nDevice.FCarriage := FCarriages[nIdx];
    end;

    ClearPorts(False);
    //init list
    
    for i:=0 to FParams.Count - 1 do
    begin
      if not PCOMParam(FParams[i]).FCOMValid then Continue;
      //invalid 

      New(nCOM);
      FPorts.Insert(GetParamPos(FParams[i], FPorts), nCOM);

      nCOM.FParam := FParams[i];
      nCOM.FDevices := TList.Create;

      for nIdx:=0 to FDevices.Count - 1 do
      begin
        nDevice := FDevices[nIdx];
        if not nDevice.FDeviceValid then Continue;
        
        if CompareText(nCOM.FParam.FPortName, nDevice.FCOMPort) = 0 then
        begin
          nDevice.FDeviceUsed := Assigned(nDevice.FCarriage);
          nPos := GetDevicePos(nDevice, nCOM.FDevices);
          nCOM.FDevices.Insert(nPos, nDevice);               
        end; //link
      end;
    end;
  finally
    FSyncLock.Leave;
  end;   
end;

initialization
  gDataManager := TDataBufferManager.Create;
  gDeviceManager := TDeviceManager.Create;
finalization
  FreeAndNil(gDeviceManager);
  FreeAndNil(gDataManager);
end.

