{*******************************************************************************
  ����: dmzn@163.com 2020-12-06
  ����: ����ģ��
*******************************************************************************}
unit UDataModule;

{$I Link.inc}

interface

uses
  Windows, SysUtils, Classes, ComCtrls, SyncObjs, UWaitItem, DB, ADODB,
  UObjectList, UProtocol, UMgrDBConn, IdGlobal, IdSync, IdBaseComponent,
  IdComponent, IdContext, IdCustomTCPServer, IdTCPServer;

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
    FSyncer: PObjectPoolItem;
    //ͬ������
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
    FDBWorker: PDBWorker;
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
    function LockDBWorker: Boolean;
    //��ȡ���ݿ����
    procedure SaveRunData(AContext: TIdContext; const nStation: PStationItem;
      const nData: PFrameData);
    //������������
    procedure QueryRunParams(AContext: TIdContext; const nStation: PStationItem;
      const nData: PFrameData);
    //��ѯ���в���
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
  NativeXml, UMemDataPool, ULibFun, USysLoger, UFormCtrl;

type
  TSyncUI = class(TIdSync)
  private
    FOwner: TFDM;
    FStations: TList;
  protected
    procedure DoSynchronize; override;
    {*ִ��ͬ��*}
  public
    constructor Create(AOwner: TFDM);
    destructor Destroy; override;
    {*�����ͷ�*}
    procedure AddStation(const nStation: PStationItem);
    {*���վ��*}
  end;

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TFDM, '���ݷ���', nEvent);
end;

constructor TSyncUI.Create(AOwner: TFDM);
begin
  inherited Create();
  FOwner := AOwner;
  FStations := TList.Create;
end;

destructor TSyncUI.Destroy;
begin
  FStations.Free;
  inherited;
end;

procedure TSyncUI.DoSynchronize;
var nIdx: Integer;
    nStation: PStationItem;
begin
  FOwner.LockEnter;
  try
    for nIdx:=FStations.Count - 1 downto 0 do
    begin
      nStation := FStations[nIdx];
      if not Assigned(nStation.FListItem) then Continue;

      if nStation.FLastActive < 1 then //��ʱ
      begin
        nStation.FListItem.ImageIndex := 0;
        Continue;
      end;

      with nStation.FListItem do
      begin
        ImageIndex := 1;
        SubItems[2] := IntToStr(nStation.FCommitAll);
        SubItems[3] := nStation.FLastUpdate;
      end;
    end;
  finally
    FOwner.LockLeave;
    FStations.Clear;
  end;
end;

procedure TSyncUI.AddStation(const nStation: PStationItem);
begin
  FStations.Add(nStation);
end;

function NewSyncUI(const nClass: TClass): TObject;
begin
  Result := TSyncUI.Create(FDM);
end;

//------------------------------------------------------------------------------
procedure TFDM.DataModuleCreate(Sender: TObject);
begin
  FDBWriter := nil;
  FDBName := 'main';
  
  FStations := TList.Create;
  FSyncLock := TCriticalSection.Create;

  gMemDataManager := TMemDataManager.Create;
  gObjectPoolManager := TObjectPoolManager.Create;
  gObjectPoolManager.RegClass(TSyncUI, NewSyncUI);

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

    FSyncer := nil;
    try
      DoWriteDB;
      if Assigned(FSyncer) then
        (FSyncer.FObject as TSyncUI).Synchronize;
      //ͬ��������ʾ
    finally
      gObjectPoolManager.ReleaseObject(FSyncer);
    end;
  except
    on nErr: Exception do
    begin
      WriteLog(nErr.Message);
    end;
  end;
end;

procedure TDBWriter.DoWriteDB;
var nIdx: Integer;
    nStation: PStationItem;
begin
  FOwner.LockEnter;
  try
    for nIdx:=FOwner.FStations.Count - 1 downto 0 do
    begin
      nStation := FOwner.FStations[nIdx];
      if nStation.FLastActive < 1 then Continue;

      if GetTickCountDiff(nStation.FLastActive) > 15 * 1000 then
      begin
        if not Assigned(FSyncer) then
          FSyncer := gObjectPoolManager.LockObject(TSyncUI);
        //xxxxx

        nStation.FLastActive := 0;
        (FSyncer.FObject as TSyncUI).AddStation(nStation);
        //��ʱ�б�
      end;
    end;
  finally
    FOwner.LockLeave;
  end;
end;

//------------------------------------------------------------------------------
procedure TFDM.IdServerExecute(AContext: TIdContext);
var nBuf: TIdBytes;
    nData: TFrameData;
    nIdx,nInt: Integer;
    nStation: PStationItem;
    nSync: PObjectPoolItem;
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

    nData.FStation := SwapWordHL(nData.FStation);
    //�����ߵ�λ

    LockEnter;
    try
      nInt := -1;
      nStation := nil;
      
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
    finally
      LockLeave;
    end;
           
    nSync := nil;
    try
      nSync := gObjectPoolManager.LockObject(TSyncUI);
      with nSync.FObject as TSyncUI do
      begin
        AddStation(nStation);
        Synchronize; //ͬ��������ʾ
      end;
    finally
      gObjectPoolManager.ReleaseObject(nSync);
    end;

    FDBWorker := nil;
    try
      case nData.FCommand of
       cFrame_CMD_UpData     : SaveRunData(AContext, nStation, @nData);
       cFrame_CMD_QueryData  : QueryRunParams(AContext, nStation, @nData);
      end;
    finally
      gDBConnManager.ReleaseConnection(FDBWorker);
    end;
  except
    on nErr: Exception do
    begin
      WriteLog(nErr.Message);
    end;
  end;
end;

function TFDM.LockDBWorker: Boolean;
var nErr: Integer;
begin
  if not Assigned(FDBWorker) then
  begin
    FDBWorker := gDBConnManager.GetConnection(FDBName, nErr);
    if not Assigned(FDBWorker) then
      raise Exception.Create(Format('�������ݿ�����ʧ��(Error: %d)', [nErr]));
    //xxxxx
  end;

  Result := Assigned(FDBWorker);
end;

//Date: 2020-12-21
//Parm: �׽���;վ��;֡����
//Desc: ����nData��������
procedure TFDM.SaveRunData(AContext: TIdContext; const nStation: PStationItem;
  const nData: PFrameData);
var nStr: string;
    nRun: TRunData;
begin
  if nData.FExtCMD = cFrame_Ext_RunData then //����ʱ����
  begin
    LockDBWorker;
    Move(nData.FData[0], nRun, cSize_Frame_RunData);

    nStr := MakeSQLByStr([
        SF('D_ID', nStation.FID),
        SF('D_Name', nStation.FName),
        SF('D_Inner', nStation.FInnerID),
        SF('D_Date', 'getDate()', sfVal),

        SF('D_I00', nRun.I00, sfVal),
        SF('D_I01', nRun.I01, sfVal),
        SF('D_I02', nRun.I02, sfVal),

        SF('D_VD300', GetValFloat(nRun.VD300), sfVal),
        SF('D_VD304', GetValFloat(nRun.VD304), sfVal),
        SF('D_VD308', GetValFloat(nRun.VD308), sfVal),
        SF('D_VD312', GetValFloat(nRun.VD312), sfVal),
        SF('D_VD316', GetValFloat(nRun.VD316), sfVal),
        SF('D_VD320', GetValFloat(nRun.VD320), sfVal),
        SF('D_VD324', GetValFloat(nRun.VD324), sfVal),
        SF('D_VD328', GetValFloat(nRun.VD328), sfVal),
        SF('D_VD332', GetValFloat(nRun.VD332), sfVal),
        SF('D_VD336', GetValFloat(nRun.VD336), sfVal),
        SF('D_VD340', GetValFloat(nRun.VD340), sfVal),
        SF('D_VD348', GetValFloat(nRun.VD348), sfVal),
        SF('D_VD352', GetValFloat(nRun.VD352), sfVal),
        SF('D_VD356', GetValFloat(nRun.VD356), sfVal),

        SF('D_V3650', nRun.V3650, sfVal),
        SF('D_V3651', nRun.V3651, sfVal),
        SF('D_V3652', nRun.V3652, sfVal),
        SF('D_V3653', nRun.V3653, sfVal),
        SF('D_V3654', nRun.V3654, sfVal),
        SF('D_V3655', nRun.V3655, sfVal),
        SF('D_V3656', nRun.V3656, sfVal),
        SF('D_V3657', nRun.V3657, sfVal),
        SF('D_V20000', nRun.V20000, sfVal),
        SF('D_V20001', nRun.V20001, sfVal),
        SF('D_V20002', nRun.V20002, sfVal)
      ], sTable_RunData, '', True);
    gDBConnManager.WorkerExec(FDBWorker, nStr);
  end;
end;

//Date: 2020-12-22
//Parm: �׽���;վ��;֡����
//Desc: ��ѯָ��վ
procedure TFDM.QueryRunParams(AContext: TIdContext; const nStation: PStationItem;
  const nData: PFrameData);
var nStr: string;
    nBuf: TIdBytes;
    nFrame: TFrameData;
    nParams: TRunParams;
begin
  if nData.FExtCMD = cFrame_Ext_RunParam then
  begin
    LockDBWorker;
    SetLength(nBuf, 0);
    InitFrameData(nFrame);

    with nFrame do
    begin
      FStation := SwapWordHL(nData.FStation);
      FCommand := cFrame_CMD_QueryData;
      FExtCMD := cFrame_Ext_RunParam;
    end;

    nStr := 'Select Top 1 * From %s Where P_ID=''%d'' Order By P_Date DESC';
    nStr := Format(nStr, [sTable_RunParams, nData.FStation]);

    with gDBConnManager.WorkerQuery(FDBWorker, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nFrame.FDataLen := 0;
        nFrame.FData[0] := cFrame_End;
        
        nBuf := RawToBytes(nFrame, FrameValidLen(@nFrame));
        AContext.Connection.IOHandler.Write(nBuf);
      end;

      InitRunParams(nParams);
      with nParams do
      begin
        PutValFloat(FieldByName('P_VD328').AsFloat, VD328);
        PutValFloat(FieldByName('P_VD332').AsFloat, VD332);
        PutValFloat(FieldByName('P_VD336').AsFloat, VD336);
        PutValFloat(FieldByName('P_VD340').AsFloat, VD340);
        PutValFloat(FieldByName('P_VD348').AsFloat, VD348);
        PutValFloat(FieldByName('P_VD352').AsFloat, VD352);
        PutValFloat(FieldByName('P_VD356').AsFloat, VD356);

        V3650       := FieldByName('P_V3650').AsInteger;
        V20000      := FieldByName('P_V20000').AsInteger;
        V20001      := FieldByName('P_V20001').AsInteger;
        V20002      := FieldByName('P_V20002').AsInteger;
      end;

      nBuf := BuildRunParams(@nFrame, @nParams);
      AContext.Connection.IOHandler.Write(nBuf);
    end;
  end;
end;

end.
