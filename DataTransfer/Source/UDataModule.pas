{*******************************************************************************
  ����: dmzn@163.com 2020-12-06
  ����: ����ģ��
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
    FID         : string;        //PLC��ʶ
    FName       : string;        //վ������
    FInnerID    : string;        //�ڲ����
    FCommitAll  : Cardinal;      //�ϴ�����

    FLastUpdate : string;
    FLastActive : Cardinal;      //�ϴθ���
    FListItem   : TListItem;     //�б�ڵ�
  end;
  TStationItems = array of TStationItem;

  TFDM = class;
  TDBWriter = class(TThread)
  private
    FOwner: TFDM;
    //ӵ����
    FWaiter: TWaitObject;
    //�ȴ�����
  protected
    procedure Execute; override;
    procedure DoWriteDB;
    //ִ��д��
  public
    constructor Create(AOwner: TFDM);
    destructor Destroy; override;
    //�����ͷ�
    procedure StopMe;
    //ֹͣ����
  end;

  TServiceParam = record
    FSrvPort  : Integer;      //����˿�
    FDBConn   : string;       //��������
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
    //����д��
    FParam: TServiceParam;
    //�������
    FStations: TList;
    //վ���б�
    FSyncLock: TCriticalSection;
    //ͬ������
  protected
    { Protected declarations }
    procedure ClearStations(const nFree: Boolean);
    //��������
    function FindStation(const nID: string; const nInnerID: Boolean): Integer;
    //��������
  public
    { Public declarations }
    procedure LockEnter;
    procedure LockLeave;
    //ͬ������
    function StartService(const nParam: TServiceParam): Boolean;
    procedure StopService;
    //��ͣ����
    procedure LoadStation(const nFile: string);
    procedure AddStation(const nData: PStationItem);
    function GetStation(const nID: string; const nData: PStationItem = nil;
      const nInnerID: Boolean = False): Integer;
    //վ��ҵ��
    property Stations: TList read FStations;
    //�������
  end;

var
  FDM: TFDM;

implementation

{$R *.dfm}

uses
  NativeXml, UMemDataPool, UMgrDBConn, ULibFun, USysLoger, UProtocol;

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TFDM, '���ݷ���', nEvent);
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
//Parm: �������
//Desc: ��������
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
//Desc: ֹͣ����
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
//Parm: �ͷŶ���
//Desc: ����վ���б�
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
//Parm: վ���ʶ;�Ƿ��ڲ����
//Desc: ������ʶΪnID��վ������
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
//Parm: վ���ʶ;վ������;�Ƿ��ڲ����
//Desc: ��ȡ��ʶΪnID��վ������,����nData��
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
//Parm: վ������
//Desc: ���վ��,����ʱ����
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
//Parm: �����ļ�
//Desc: ����վ������
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
  gSysLoger.AddLog(TDBWriter, '����д��', nEvent);
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
    //��ȡЭ�鿪ʼ��������

    if BytesToString(nBuf, 0, 3, Indy8BitEncoding) <> cFrame_Begin then //֡ͷ��Ч
    begin
      InputBuffer.Clear;
      Exit;
    end;

    ReadBytes(nBuf, nBuf[7], True);
    //��ȡ����
    ReadBytes(nBuf, 1, True);
    //��ȡ֡β

    nInt := Length(nBuf);
    if Char(nBuf[nInt - 1]) <> cFrame_End then //֡β��Ч
    begin
      InputBuffer.Clear;
      Exit;
    end;

    BytesToRaw(nBuf, nData, nInt);
    //�������ݽṹ

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
        WriteLog('��Ч���豸��ʶ(PLC ID).');
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
