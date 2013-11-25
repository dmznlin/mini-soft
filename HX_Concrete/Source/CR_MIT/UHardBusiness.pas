{*******************************************************************************
  作者: dmzn@163.com 2012-4-22
  描述: 硬件动作业务
*******************************************************************************}
unit UHardBusiness;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, SysUtils, IdGlobal, IdSocketHandle, IdUDPServer,
  UMgrDBConn, UMgrHardHelper, U02NReader, UParamManager, UBusinessWorker,
  UBusinessConst, UBusinessPacker, UMgrQueue, UMgrRemoteVoice;

procedure WhenReaderCardArrived(const nReader: THHReaderItem);
//有新卡号到达读头
procedure WhenReaderCardIn(nHost: TReaderHost; nCard: TReaderCard);
//现场读头有新卡号
procedure When2ClientUDPRead(AThread: TIdUDPListenerThread; AData: TIdBytes;
  ABinding: TIdSocketHandle);
//客户端有数据到达

implementation

uses
  ULibFun, NativeXml, UBase64, UFormCtrl, USysDB, USysLoger;

//------------------------------------------------------------------------------
procedure WriteHardHelperLog(const nEvent: string);
begin
  gSysLoger.AddLog(THardwareHelper, '硬件守护辅助', nEvent);
end;

//Date: 2013-07-08
//Parm: 磁卡号
//Desc: 对nCard做进厂处理
procedure MakeTruckIn(const nCard: string);
var nStr: string;
    nIn: TWorkerBusinessCommand;
    nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPacker := nil;
  nWorker := nil;
  try
    nIn.FCommand := cBC_MakeTruckIn;
    nIn.FData := nCard;

    nPacker := gBusinessPackerManager.LockPacker(sBus_BusinessCommand);
    nStr := nPacker.PackIn(@nIn);

    nWorker := gBusinessWorkerManager.LockWorker(sBus_BusinessCommand);
    if not nWorker.WorkActive(nStr) then
    begin
      WriteHardHelperLog(nStr);
    end;
  finally
    gBusinessPackerManager.RelasePacker(nPacker);
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//Date: 2013-07-08
//Parm: 卡号;读头;打印机
//Desc: 对nCard放行出厂
procedure MakeTruckOut(const nCard: string);
var nStr: string;
    nIn: TWorkerBusinessCommand;
    nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPacker := nil;
  nWorker := nil;
  try
    nIn.FCommand := cBC_MakeTruckOut;
    nIn.FData := nCard;

    nPacker := gBusinessPackerManager.LockPacker(sBus_BusinessCommand);
    nStr := nPacker.PackIn(@nIn);

    nWorker := gBusinessWorkerManager.LockWorker(sBus_BusinessCommand);
    if not nWorker.WorkActive(nStr) then
    begin
      WriteHardHelperLog(nStr);
    end;
  finally
    gBusinessPackerManager.RelasePacker(nPacker);
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//Date: 2012-4-22
//Parm: 读头数据
//Desc: 对nReader读到的卡号做具体动作
procedure WhenReaderCardArrived(const nReader: THHReaderItem);
var nStr: string;
    nErrNum: Integer;
    nDBConn: PDBWorker;
begin
  nDBConn := nil;
  {$IFDEF DEBUG}
  WriteHardHelperLog('WhenReaderCardArrived进入.');
  {$ENDIF}

  with gParamManager.ActiveParam^ do
  try
    nDBConn := gDBConnManager.GetConnection(FDB.FID, nErrNum);
    if not Assigned(nDBConn) then
    begin
      WriteHardHelperLog('连接HM数据库失败(DBConn Is Null).');
      Exit;
    end;

    if not nDBConn.FConn.Connected then
      nDBConn.FConn.Connected := True;
    //conn db

    nStr := 'Select C_Card From $TB Where C_Card=''$CD'' or ' +
            'C_Card2=''$CD'' or C_Card3=''$CD''';
    nStr := MacroValue(nStr, [MI('$TB', sTable_Card), MI('$CD', nReader.FCard)]);

    with gDBConnManager.WorkerQuery(nDBConn, nStr) do
    if RecordCount > 0 then
    begin
      nStr := Fields[0].AsString;
    end else
    begin
      nStr := Format('磁卡号[ %s ]匹配失败.', [nReader.FCard]);
      WriteHardHelperLog(nStr);
      Exit;
    end;

    try
      if nReader.FType = rtIn then
      begin
        MakeTruckIn(nStr);
      end else

      if nReader.FType = rtOut then
      begin
        MakeTruckOut(nStr);
      end;
    except
      On E:Exception do
      begin
        WriteHardHelperLog(E.Message);
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBConn);
  end;
end;

//------------------------------------------------------------------------------
procedure WriteNearReaderLog(const nEvent: string);
begin
  gSysLoger.AddLog(T02NReader, '现场近距读卡器', nEvent);
end;

//Date: 2013-07-08
//Parm: 通道号;磁卡
//Desc: 将nCard对应的车号发送客户端
procedure MakeTruck2Client(const nTunnel,nCard: string);
var nStr: string;
    nList: TStrings;
    nIn: TWorkerBusinessCommand;
    nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nList := nil;
  nPacker := nil;
  nWorker := nil;
  try
    nList := TStringList.Create;
    nList.Values['Card'] := nCard;
    nList.Values['Line'] := nTunnel;

    nIn.FCommand := cBC_ReaderCardIn;
    nIn.FData := nList.Text;

    nPacker := gBusinessPackerManager.LockPacker(sBus_BusinessCommand);
    nStr := nPacker.PackIn(@nIn);

    nWorker := gBusinessWorkerManager.LockWorker(sBus_BusinessCommand);
    if not nWorker.WorkActive(nStr) then
    begin
      WriteNearReaderLog(nStr);
    end;
  finally
    nList.Free;
    gBusinessPackerManager.RelasePacker(nPacker);
    gBusinessWorkerManager.RelaseWorkder(nWorker);
  end;
end;

//Date: 2012-07-08
//Parm: 主机;卡号
//Desc: 对nHost.nCard新到卡号作出动作
procedure WhenReaderCardIn(nHost: TReaderHost; nCard: TReaderCard);
begin 
  if nHost.FType = rtOnce then
  begin
    MakeTruck2Client(nHost.FTunnel, nCard.FCard);
  end;
end;

//------------------------------------------------------------------------------
procedure WriteUDPLog(const nEvent: string);
begin
  gSysLoger.AddLog(TIdUDPServer, '客户端UDP服务', nEvent);
end;

//Date: 2013-07-23
//Parm: 车牌号;操作员
//Desc: 将nTruck出队
procedure TruckOutQueue(const nTruck: string; const nUser: string);
var nStr: string;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    nStr := 'Delete From %s Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_ZCTrucks, nTruck]);
    nList.Text := nStr;

    nStr := 'T_Truck=''%s'' And T_NextStatus<>''''';
    nStr := Format(nStr, [nTruck]);

    nStr := MakeSQLByStr([SF('T_Status', sFlag_TruckQOut),
            SF('T_NextStatus', ''),
            SF('T_QueueOut', sField_SQLServer_Now, sfVal),
            SF('T_QOutMan', nUser)], sTable_TruckLog, nStr, False);
    nList.Add(nStr);

    gDBConnManager.ExecSQLs(nList, True, gParamManager.ActiveParam.FDB.FID);
  finally
    nList.Free;
  end;
end;

//Date: 2013-07-23
//Parm: 协议数据
//Desc: 执行叫车动作
procedure CallTruck(const nXMLData: string; nPeer: TIdSocketHandle);
var nStr: string;
    nIdx: Integer;
    nTruck,nTmp: PTruckItem;

    nXML: TNativeXml;
    nNode: TXmlNode;
begin
  nStr := '收到[ %s ]叫车指令.';
  WriteUDPLog(Format(nStr, [nPeer.PeerIP]));
  //loged

  nXML := nil;
  try
    nXML := TNativeXml.Create;
    nXML.ReadFromString(nXMLData);

    nNode := nXML.Root.FindNode('call_truck_row');
    if not Assigned(nNode) then
    begin
      WriteUDPLog('XML数据错误.');
      Exit;
    end;

    gTruckQueueManager.SyncLock.Enter;
    try
      nTruck := nil;
      nStr := nNode.NodeByName('lineid').ValueAsString;

      for nIdx:=0 to gTruckQueueManager.Trucks.Count - 1 do
      begin
        nTmp := gTruckQueueManager.Trucks[nIdx];
        if nTmp.FLine = '' then Continue;

        if CompareText(nTmp.FLine, nStr) = 0 then
        begin
          nTruck := nTmp;
          Break;
        end;
      end;

      if Assigned(nTruck) then
      begin
        nTruck.FCallNum := nTruck.FCallNum + 1;
        if nTruck.FCallNum > cTruckMaxCalledNum then
        begin
          //nStr := nNode.NodeByName('operator').ValueAsString;
          nStr := 'System';
          TruckOutQueue(nTruck.FTruck, nStr);

          gTruckQueueManager.TruckOutQueue(nTruck, False);
          nTruck := nil;
        end;
      end;

      if not Assigned(nTruck) then
      begin
        for nIdx:=0 to gTruckQueueManager.Trucks.Count - 1 do
        begin
          nTmp := gTruckQueueManager.Trucks[nIdx];
          if nTmp.FLine <> '' then Continue;
          nTruck := nTmp;
          
          nTruck.FCallNum := nTruck.FCallNum + 1;
          gTruckQueueManager.QueueChanged := GetTickCount;
          Break;
        end;
      end;

      if Assigned(nTruck) then
      begin
        nTruck.FLine := nNode.NodeByName('lineId').ValueAsString;
        nStr := nNode.NodeByName('linename').ValueAsString;
        nTruck.FLineName := SysUtils.StringReplace(nStr, '#', '号', [rfReplaceAll]);

        nTruck.FTruckSeq := nNode.NodeByName('seq').ValueAsString;
        nTruck.FTaskID := nNode.NodeByName('joid').ValueAsString; 
        nTruck.FCallIP := nNode.NodeByName('ip').ValueAsString;
        nTruck.FCallPort := nNode.NodeByName('port').ValueAsInteger;

        nStr := nTruck.FTruck + '去' + nTruck.FLineName;
        gVoiceHelper.PlayVoice(#9 + nStr);
        //voice truck

        nStr := 'T_Truck=''%s'' And T_NextStatus<>''''';
        nStr := Format(nStr, [nTruck.FTruck]);

        nStr := MakeSQLByStr([SF('T_Status', sFlag_TruckQIn),
                SF('T_NextStatus', sFlag_TruckOut),
                SF('T_Line', nTruck.FLine),
                SF('T_LineName', nTruck.FLineName),
                SF('T_TaskID', nTruck.FTaskID),
                SF('T_QueueIn', sField_SQLServer_Now, sfVal),
                SF('T_QInMan', nNode.NodeByName('operator').ValueAsString)
                ], sTable_TruckLog, nStr, False);
        gDBConnManager.ExecSQL(nStr, gParamManager.ActiveParam.FDB.FID);
      end;
    finally
      gTruckQueueManager.SyncLock.Leave;
    end;
  finally
    nXML.Free;
  end;
end;

//Date: 2013-07-08
//Desc: 客户端发送UDP数据包
procedure When2ClientUDPRead(AThread: TIdUDPListenerThread; AData: TIdBytes;
  ABinding: TIdSocketHandle);
var nStr: string;
begin
  nStr := BytesToString(AData);
  if Length(nStr) < 3 then Exit;

  if (nStr[1] <> Char(cCall_Prefix_1)) or (nStr[2] <> Char(cCall_Prefix_2)) then
  begin
    WriteUDPLog('接收到无效数据包,已丢弃.');
    Exit;
  end;

  try
    if nStr[3] = Char(cCMD_CallTruck) then
    begin
      System.Delete(nStr, 1, 3);
      CallTruck(DecodeBase64(nStr), ABinding);
    end; 
  except
    on E:Exception do
    begin
      WriteUDPLog(E.Message);
    end;
  end;
end;

end.
