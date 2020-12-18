{*******************************************************************************
  作者: dmzn@163.com 2020-12-06
  描述: 数据模块
*******************************************************************************}
unit UDataModule;

{$I Link.inc}

interface

uses
  Windows, SysUtils, Classes, SyncObjs, UWaitItem, DB, ADODB,
  IdBaseComponent, IdComponent, IdUDPBase, IdUDPServer;

type
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
    IdServer: TIdUDPServer;
    ADOConn1: TADOConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FDBName: string;
    FDBWriter: TDBWriter;
    //数据写入
    FParam: TServiceParam;
    //服务参数
    FSyncLock: TCriticalSection;
    //同步锁定
  public
    { Public declarations }
    function StartService(const nParam: TServiceParam): Boolean;
    procedure StopService;
    //启停服务
  end;

var
  FDM: TFDM;

implementation

{$R *.dfm}

uses
  UMemDataPool, UMgrDBConn, ULibFun, USysLoger;

procedure TFDM.DataModuleCreate(Sender: TObject);
begin
  FDBWriter := nil;
  FDBName := 'main';
  FSyncLock := TCriticalSection.Create;

  gMemDataManager := TMemDataManager.Create;
  gDBConnManager := TDBConnManager.Create;
end;

procedure TFDM.DataModuleDestroy(Sender: TObject);
begin
  StopService;
  FSyncLock.Free;
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
      gSysLoger.AddLog(TFDM, '数据服务', nErr.Message);
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
  DBWriteLog(Date2Str(now));
end;

end.
