{*******************************************************************************
  作者: dmzn@163.com 2020-12-06
  描述: 数据模块
*******************************************************************************}
unit UDataModule;

{$I Link.inc}

interface

uses
  Windows, SysUtils, Classes, ComCtrls, SyncObjs, UWaitItem, DB, ADODB,
  IdGlobal, IdBaseComponent, IdComponent, IdUDPBase, IdUDPServer, IdContext,
  IdCustomTCPServer, IdTCPServer;

type
  PStationItem = ^TStationItem;
  TStationItem = record
    FID         : string;        //PLC标识
    FName       : string;        //站点名称
    FInnerID    : string;        //内部编号
    FCommitAll  : Cardinal;      //上传次数

    FLastUpdate : string;
    FLastActive : Cardinal;      //上次更新
    FListItem   : TListItem;     //列表节点
  end;
  TStationItems = array of TStationItem;

  TFDM = class;
  TDBWriter = class(TThread)
  private
    FOwner: TFDM;
    //拥有者
    FWaiter: TWaitObject;
    //等待对象
  protected
    procedure Execute; override;
    procedure DoWriteDB;
    //执行写入
  public
    constructor Create(AOwner: TFDM);
    destructor Destroy; override;
    //创建释放
    procedure StopMe;
    //停止服务
  end;

  TServiceParam = record
    FSrvPort  : Integer;      //服务端口
    FDBConn   : string;       //数据连接
  end;

  TFDM = class(TDataModule)
    ADOConn1: TADOConnection;
    IdServer: TIdTCPServer;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure IdServerExecute(AContext: TIdContext);
  private
    { Private declarations }
    FDBName: string;
    FDBWriter: TDBWriter;
    //数据写入
    FParam: TServiceParam;
    //服务参数
    FStations: TList;
    //站点列表
    FSyncLock: TCriticalSection;
    //同步锁定
  protected
    { Protected declarations }
    procedure ClearStations(const nFree: Boolean);
    //清理数据
    function FindStation(const nID: string; const nInnerID: Boolean): Integer;
    //检索数据
  public
    { Public declarations }
    procedure LockEnter;
    procedure LockLeave;
    //同步锁定
    function StartService(const nParam: TServiceParam): Boolean;
    procedure StopService;
    //启停服务
    procedure LoadStation(const nFile: string);
    procedure AddStation(const nData: PStationItem);
    function GetStation(const nID: string; const nData: PStationItem = nil;
      const nInnerID: Boolean = False): Integer;
    //站点业务
    property Stations: TList read FStations;
    //属性相关
  end;

var
  FDM: TFDM;

implementation

{$R *.dfm}

uses
  NativeXml, UMemDataPool, UMgrDBConn, ULibFun, USysLoger, UProtocol;

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TFDM, '数据服务', nEvent);
end;

procedure TFDM.DataModuleCreate(Sender: TObject);
begin
  FDBWriter := nil;
  FDBName := 'main';
  
  FStations := TList.Create;
  FSyncLock := TCriticalSection.Create;

  gMemDataManager := TMemDataManager.Create;
  gDBConnManager := TDBConnManager.Create;
  gDBConnManager.MaxConn := 5;
end;

procedure TFDM.DataModuleDestroy(Sender: TObject);
begin
  StopService;
  ClearStations(True);
  FSyncLock.Free;
end;

procedure TFDM.LockEnter;
begin
  FSyncLock.Enter;
end;

procedure TFDM.LockLeave;
begin
  FSyncLock.Leave;
end;

//Date: 2020-12-07
//Parm: 服务参数
//Desc: 启动服务
function TFDM.StartService(const nParam: TServiceParam): Boolean;
var nDBConn: TDBParam;
begin
  Result := True;
  FParam := nParam;
  try              
    nDBConn.FID := FDBName;
    nDBConn.FConn := nParam.FDBConn;
    gDBConnManager.AddParam(nDBConn);
    
    if not Assigned(FDBWriter) then
      FDBWriter := TDBWriter.Create(Self);
    //xxxxx

    with IdServer do
    begin
      Active := False;
      DefaultPort := nParam.FSrvPort;
      Active := True;
    end;
  except
    on nErr: Exception do
    begin
      Result := False;
      WriteLog(nErr.Message);
    end;
  end;
end;

//Date: 2020-12-07
//Desc: 停止服务
procedure TFDM.StopService;
begin
  IdServer.Active := False;
  if Assigned(FDBWriter) then
  begin
    FDBWriter.StopMe;
    FDBWriter := nil;
  end;
end;

//Date: 2020-12-18
//Parm: 释放对象
//Desc: 清理站点列表
procedure TFDM.ClearStations(const nFree: Boolean);
var nIdx: Integer;
    nItem: PStationItem;
begin
  for nIdx:=FStations.Count - 1 downto 0 do
  begin
    nItem := FStations[nIdx];
    Dispose(nItem);
  end;

  if nFree then
       FreeAndNil(FStations)
  else FStations.Clear;
end;

//Date: 2020-12-18
//Parm: 站点标识;是否内部编号
//Desc: 检索标识为nID的站点索引
function TFDM.FindStation(const nID: string; const nInnerID: Boolean): Integer;
var nIdx: Integer;
    nItem: PStationItem;
begin
  Result := -1;
  for nIdx:=FStations.Count - 1 downto 0 do
  begin
    nItem := FStations[nIdx];
    if (nInnerID and (CompareText(nID, nItem.FInnerID) = 0)) or
       ((not nInnerID) and (CompareText(nID, nItem.FID) = 0)) then
    begin
      Result := nIdx;
      Break;
    end;
  end;
end;

//Date: 2020-12-18
//Parm: 站点标识;站点数据;是否内部编号
//Desc: 读取标识为nID的站点数据,存入nData中
function TFDM.GetStation(const nID: string; const nData: PStationItem;
  const nInnerID: Boolean): Integer;
begin
  LockEnter;
  try
    Result := FindStation(nID, nInnerID);
    if Assigned(nData) and (Result > -1) then
      nData^ := PStationItem(FStations[Result])^;
    //copy data
  finally
    LockLeave;
  end;   
end;

//Date: 2020-12-18
//Parm: 站点数据
//Desc: 添加站点,存在时覆盖
procedure TFDM.AddStation(const nData: PStationItem);
var nIdx: Integer;
    nItem: PStationItem;
begin
  LockEnter;
  try
    nIdx := FindStation(nData.FID, False);
    if nIdx < 0 then
    begin
      New(nItem);
      FStations.Add(nItem);
    end else nItem := FStations[nIdx];

    nItem^ := nData^;
    //copy data
  finally
    LockLeave;
  end;   
end;

//Date: 2020-12-18
//Parm: 配置文件
//Desc: 载入站点数据
procedure TFDM.LoadStation(const nFile: string);
var nIdx: Integer;
    nRoot: TXmlNode;
    nXML: TNativeXml;
                        
    nItem: PStationItem;
    nInit: TStationItem;
begin
  nXML := nil;
  LockEnter;
  try
    ClearStations(False);
    if not FileExists(nFile) then Exit;
    FillChar(nInit, SizeOf(nInit), #0);

    nXML := TNativeXml.Create;
    nXML.LoadFromFile(nFile);
    nRoot := nXML.Root.NodeByNameR('station_plc');

    for nIdx:=0 to nRoot.NodeCount - 1 do
    begin
      New(nItem);
      FStations.Add(nItem);
      nItem^ := nInit;

      with nRoot.Nodes[nIdx] do
      begin
        nItem.FID := AttributeByName['id'];
        nItem.FName := NodeByNameR('name').ValueAsString;
        nItem.FInnerID := NodeByNameR('inner').ValueAsString;
      end;
    end;
  finally
    LockLeave;
    nXML.Free;
  end;
end;

//------------------------------------------------------------------------------
procedure DBWriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TDBWriter, '数据写入', nEvent);
end;

constructor TDBWriter.Create(AOwner: TFDM);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FOwner := AOwner;
  FWaiter := TWaitObject.Create();
  FWaiter.Interval := 3 * 1000;
end;

destructor TDBWriter.Destroy;
begin
  FWaiter.Free;
  inherited;
end;

procedure TDBWriter.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure TDBWriter.Execute;
begin
  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Exit;

    DoWriteDB;
  except
    on nErr: Exception do
    begin
      DBWriteLog(nErr.Message);
    end;
  end;
end;

procedure TDBWriter.DoWriteDB;
begin
  //do nothing
end;

//------------------------------------------------------------------------------
procedure TFDM.IdServerExecute(AContext: TIdContext);
var nBuf: TIdBytes;
    nData: TFrameData;
    nIdx,nInt: Integer;
    nStation: PStationItem;
begin
  with AContext.Connection.IOHandler do
  try
    if InputBufferIsEmpty then
    begin
      CheckForDataOnSource(0);
      CheckForDisconnect();
      if InputBufferIsEmpty then Exit;
    end;

    ReadBytes(nBuf, 8, False);
    //读取协议开始定长数据

    if BytesToString(nBuf, 0, 3, Indy8BitEncoding) <> cFrame_Begin then //帧头无效
    begin
      InputBuffer.Clear;
      Exit;
    end;

    ReadBytes(nBuf, nBuf[7], True);
    //读取数据
    ReadBytes(nBuf, 1, True);
    //读取帧尾

    nInt := Length(nBuf);
    if Char(nBuf[nInt - 1]) <> cFrame_End then //帧尾无效
    begin
      InputBuffer.Clear;
      Exit;
    end;

    BytesToRaw(nBuf, nData, nInt);
    //解析数据结构

    LockEnter;
    try
      nInt := -1;
      for nIdx:=FStations.Count - 1 downto 0 do
      begin
        nStation := FStations[nIdx];
        if nStation.FID = IntToStr(nData.FStation) then
        begin
          nInt := nIdx;
          Break;
        end;
      end;

      if nInt < 0 then
      begin
        WriteLog('无效的设备标识(PLC ID).');
        Exit;
      end;

      Inc(nStation.FCommitAll);
      nStation.FLastActive := GetTickCount();
      nStation.FLastUpdate := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now());

      TIdsync
    finally
      LockLeave;
    end;   
  except
    on nErr: Exception do
    begin
      WriteLog(nErr.Message);
    end;
  end;
end;

end.
