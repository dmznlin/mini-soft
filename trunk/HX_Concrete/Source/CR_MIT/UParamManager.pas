{*******************************************************************************
  作者: dmzn@163.com 2012-3-2
  描述: Bus-MIT参数包管理
*******************************************************************************}
unit UParamManager;

interface

uses
  Windows, Classes, SysUtils, IniFiles, UBase64, UMgrDBConn, uROClassFactories;

type
  PPerformParam = ^TPerformParam;
  TPerformParam = record
    FID: string;
    //参数标识
    FPortTCP: Integer;
    FPortHttp: Integer;
    //监听端口
    FPoolSizeSAP: Integer;
    FPoolSizeConn: Integer;
    FPoolSizeBusiness: Integer;
    //连接池
    FPoolBehaviorConn: TROPoolBehavior;
    FPoolBehaviorBusiness: TROPoolBehavior;
    //缓冲模式
    FMaxRecordCount: Integer;
    //最大记录数
    FMonInterval: Integer;
    //守护间隔
    FEnable: Boolean;
    //是否启用
  end;

  TParamType = (ptPack, ptSAP, ptDB, ptPerform);
  //type

  PParamItemPack = ^TParamItemPack;
  TParamItemPack = record
    FItemID: string;           //参数标识
    FEnable: Boolean;          //是否启用

    FNameDB: string;
    FDB: PDBParam;             //db
    FNamePerform: string;
    FPerform: PPerformParam;   //性能
  end;

  TParamManager = class(TObject)
  private
    FFileName: string;
    //文件名
    FModified: Boolean;
    //是否改动
    FActiveName: string;
    FActive: PParamItemPack;
    //激活参数
    FItemDB: array of TDBParam;
    FItemPerform: array of TPerformParam;
    //参数项
    FPacks: array of TParamItemPack;
    //参数包
    procedure UpdateActivePack;
    //更新参数
  public
    constructor Create(const nFile: string);
    destructor Destroy; override;
    //创建释放
    procedure ParamAction(const nIsRead: Boolean; const nFile: string = '');
    //read or write
    function GetParamPack(const nID: string;
      const nActive: Boolean = False): PParamItemPack;
    //active
    function LoadParam(const nList: TStrings; nType: TParamType): Boolean;
    //load list
    procedure InitPack(var nItem: TParamItemPack);
    procedure AddPack(const nItem: TParamItemPack);
    procedure DelPack(const nID: string);
    //packet
    procedure InitDB(var nParam: TDBParam);
    procedure AddDB(const nParam: TDBParam);
    procedure DelDB(const nID: string);
    function GetDB(const nID: string): PDBParam;
    //database
    procedure InitPerform(var nParam: TPerformParam);
    procedure AddPerform(const nParam: TPerformParam);
    procedure DelPerform(const nID: string);
    function GetPerform(const nID: string): PPerformParam;
    //perform
    property FileName: string read FFileName;
    property ActiveParam: PParamItemPack read FActive;
    property Modified: Boolean read FModified write FModified;
    //property 
  end;

var
  gParamManager: TParamManager = nil;
  //全局使用

implementation

resourcestring
  sSection_System        = 'System';
  sSection_Packet        = 'Packet';
  sSection_DB            = 'ParamDB';
  sSection_SAP           = 'ParamSAP';
  sSection_Perform       = 'ParamPerform';

//------------------------------------------------------------------------------
constructor TParamManager.Create(const nFile: string);
begin 
  FActive := nil;
  FActiveName := '';    
  FModified := False;

  FFileName := nFile;
  ParamAction(True);
end;

destructor TParamManager.Destroy;
begin
  if FModified then
    ParamAction(False);
  inherited;
end;

//Date: 2012-3-3
//Parm: 文件名;读写标记
//Desc: 从文件读写参数
procedure TParamManager.ParamAction(const nIsRead: Boolean; const nFile: string);
var nStr: string;
    nIni: TIniFile;
    nList: TStrings;
    nIdx,nInt: Integer;
begin
  if nFile = '' then
       nStr := FFileName
  else nStr := nFile;

  nList := nil;
  nIni := TIniFile.Create(nStr);
  try
    nList := TStringList.Create;

    if nIsRead then
    with nIni do
    begin
      FActive := nil;
      nInt := ReadInteger(sSection_DB, 'Number', 0);
      SetLength(FItemDB, nInt);

      for nIdx:=Low(FItemDB) to High(FItemDB) do
      with FItemDB[nIdx] do
      begin
        InitDB(FItemDB[nIdx]);
        nStr := '_' + IntToStr(nIdx);

        FID   := ReadString(sSection_DB, 'Item' + nStr, FID);
        FHost := ReadString(sSection_DB, 'Host' + nStr, FHost);
        FPort := ReadInteger(sSection_DB, 'Port' + nStr, FPort);
        FDB   := ReadString(sSection_DB, 'DB' + nStr, FDB);

        FUser := ReadString(sSection_DB, 'User' + nStr, FUser);
        FPwd  := ReadString(sSection_DB, 'Password' + nStr, '');
        FPwd  := DecodeBase64(FPwd);
        FConn := ReadString(sSection_DB, 'ConnStr' + nStr, '');
        FConn := DecodeBase64(FConn);

        FEnable := True;
        FNumWorker := ReadInteger(sSection_DB, 'Workder' + nStr, FNumWorker);
      end;

      //------------------------------------------------------------------------
      nInt := ReadInteger(sSection_Perform, 'Number', 0);
      SetLength(FItemPerform, nInt);

      for nIdx:=Low(FItemPerform) to High(FItemPerform) do
      with FItemPerform[nIdx] do
      begin
        InitPerform(FItemPerform[nIdx]);
        nStr := '_' + IntToStr(nIdx);

        FID := ReadString(sSection_Perform, 'Item' + nStr, '');
        FPortTCP := ReadInteger(sSection_Perform, 'PortTCP' + nStr, FPortTCP);
        FPortHttp := ReadInteger(sSection_Perform, 'PortHttp' + nStr, FPortHttp);

        FPoolSizeSAP := ReadInteger(sSection_Perform, 'PoolSizeSAP' + nStr, FPoolSizeSAP);
        FPoolSizeConn := ReadInteger(sSection_Perform, 'PoolSizeConn' + nStr, FPoolSizeConn);
        FPoolSizeBusiness := ReadInteger(sSection_Perform, 'PoolSizeBusiness' + nStr, FPoolSizeBusiness);

        nInt := ReadInteger(sSection_Perform, 'PoolBehaviorConn' + nStr, Ord(FPoolBehaviorConn));
        FPoolBehaviorConn := TROPoolBehavior(nInt);
        nInt := ReadInteger(sSection_Perform, 'PoolBehaviorBus' + nStr, Ord(FPoolBehaviorBusiness));
        FPoolBehaviorBusiness := TROPoolBehavior(nInt);

        FMaxRecordCount := ReadInteger(sSection_Perform, 'MaxRecordCount' + nStr, FMaxRecordCount);
        FMonInterval := ReadInteger(sSection_Perform, 'MonInterval' + nStr, FMonInterval);
        FEnable   := True;
      end;

      //------------------------------------------------------------------------
      nInt := ReadInteger(sSection_Packet, 'Number', 0);
      SetLength(FPacks, nInt);

      for nIdx:=Low(FPacks) to High(FPacks) do
      with FPacks[nIdx] do
      begin
        nStr := '_' + IntToStr(nIdx);
        FItemID := ReadString(sSection_Packet, 'Item' + nStr, '');
        FEnable := True;

        FNameDB  := ReadString(sSection_Packet, 'DB' + nStr, '');
        FDB      := GetDB(FNameDB);
        FNamePerform := ReadString(sSection_Packet, 'Perform' + nStr, '');
        FPerform     := GetPerform(FNamePerform);
      end;
    end else

    with nIni do
    begin
      nInt := 0;
      nIni.EraseSection(sSection_Packet);
      
      for nIdx:=Low(FPacks) to High(FPacks) do
      with FPacks[nIdx] do
      begin
        if not FEnable then Continue;
        nStr := '_' + IntToStr(nInt);
        Inc(nInt);

        WriteString(sSection_Packet, 'Item' + nStr, FItemID);
        if Assigned(FDB) then
          WriteString(sSection_Packet, 'DB' + nStr, FNameDB);
        if Assigned(FPerform) then
          WriteString(sSection_Packet, 'Perform' + nStr, FNamePerform);
      end;
      WriteInteger(sSection_Packet, 'Number', nInt);

      //------------------------------------------------------------------------
      nInt := 0;
      nIni.EraseSection(sSection_DB);

      for nIdx:=Low(FItemDB) to High(FItemDB) do
      with FItemDB[nIdx] do
      begin
        if not FEnable then Continue;
        nStr := '_' + IntToStr(nInt);
        Inc(nInt);

        WriteString(sSection_DB, 'Item' + nStr, FID);
        WriteString(sSection_DB, 'Host' + nStr, FHost);
        WriteInteger(sSection_DB, 'Port' + nStr, FPort);
        WriteString(sSection_DB, 'DB' + nStr, FDB);
        WriteString(sSection_DB, 'User' + nStr, FUser);
        WriteString(sSection_DB, 'Password' + nStr, EncodeBase64(FPwd));
        WriteString(sSection_DB, 'ConnStr' + nStr, EncodeBase64(FConn));
        WriteInteger(sSection_DB, 'Workder' + nStr, FNumWorker);
      end;
      WriteInteger(sSection_DB, 'Number', nInt);

      //------------------------------------------------------------------------
      nInt := 0;
      nIni.EraseSection(sSection_Perform);

      for nIdx:=Low(FItemPerform) to High(FItemPerform) do
      with FItemPerform[nIdx] do
      begin
        if not FEnable then Continue;
        nStr := '_' + IntToStr(nInt);
        Inc(nInt);

        WriteString(sSection_Perform, 'Item' + nStr, FID);
        WriteInteger(sSection_Perform, 'PortTCP' + nStr, FPortTCP);
        WriteInteger(sSection_Perform, 'PortHttp' + nStr, FPortHttp);

        WriteInteger(sSection_Perform, 'PoolSizeSAP' + nStr, FPoolSizeSAP);
        WriteInteger(sSection_Perform, 'PoolSizeConn' + nStr, FPoolSizeConn);
        WriteInteger(sSection_Perform, 'PoolSizeBusiness' + nStr, FPoolSizeBusiness);

        WriteInteger(sSection_Perform, 'PoolBehaviorConn' + nStr, Ord(FPoolBehaviorConn));
        WriteInteger(sSection_Perform, 'PoolBehaviorBus' + nStr, Ord(FPoolBehaviorBusiness));
        WriteInteger(sSection_Perform, 'MaxRecordCount' + nStr, FMaxRecordCount);
        WriteInteger(sSection_Perform, 'MonInterval' + nStr, FMonInterval);
      end;

      WriteInteger(sSection_Perform, 'Number', nInt);
      FModified := (nFile <> '') and (nFile = FFileName);
    end;
  finally
    nList.Free;
    nIni.Free;
  end;
end;

//Desc: 更新激活选项
procedure TParamManager.UpdateActivePack;
begin
  if FActiveName <> '' then
    FActive := GetParamPack(FActiveName);
  //xxxxx

  if Assigned(FActive) then
  with FActive^ do
  begin
    FDB := GetDB(FNameDB);
    FPerform := GetPerform(FNamePerform);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2012-3-5
//Parm: 参数包
//Desc: 初始化nItem
procedure TParamManager.InitPack(var nItem: TParamItemPack);
begin
  with nItem do
  begin
    FNameDB := '';
    FDB := nil;
    FNamePerform := '';
    FPerform := nil;
  end;
end;

//Date: 2012-3-3
//Parm: 参数包
//Desc: 添加nItem到系统中
procedure TParamManager.AddPack(const nItem: TParamItemPack);
var nIdx: Integer;
    nP: PParamItemPack;
begin
  nP := GetParamPack(nItem.FItemID);
  if not Assigned(nP) then
  begin
    nIdx := Length(FPacks);
    SetLength(FPacks, nIdx + 1);
    nP := @FPacks[nIdx];
  end;

  nP^ := nItem;
  nP.FEnable := True;

  UpdateActivePack;
  FModified := True;
end;

procedure TParamManager.DelPack(const nID: string);
var nP: PParamItemPack;
begin
  nP := GetParamPack(nID);
  if Assigned(nP) then
  begin
    nP.FEnable := False;
    FModified := True;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2012-3-3
//Parm: 标识
//Desc: 获取标识为nID的性能参数
function TParamManager.GetPerform(const nID: string): PPerformParam;
var nIdx: Integer;
begin
  Result := nil;

  for nIdx:=Low(FItemPerform) to High(FItemPerform) do
  if FItemPerform[nIdx].FEnable and
     (CompareText(nID, FItemPerform[nIdx].FID) = 0) then
  begin
    Result := @FItemPerform[nIdx];
    Break;
  end;
end;

//Date: 2012-3-5
//Parm: 参数
//Desc: 初始化nItem参数
procedure TParamManager.InitPerform(var nParam: TPerformParam);
begin
  with nParam do
  begin
    FPortTCP := 8081;
    FPortHttp := 8082;

    FPoolSizeSAP := 1;
    FPoolSizeConn := 10;
    FPoolSizeBusiness := 20;

    FPoolBehaviorConn := pbWait;
    FPoolBehaviorBusiness := pbCreateAdditional;

    FMaxRecordCount := 1000;
    FMonInterval := 2000;
  end;
end;

//Date: 2012-3-3
//Parm: 参数
//Desc: 添加nItem参数
procedure TParamManager.AddPerform(const nParam: TPerformParam);
var nIdx: Integer;
    nP: PPerformParam;
begin
  nP := GetPerform(nParam.FID);
  if not Assigned(nP) then
  begin
    nIdx := Length(FItemPerform);
    SetLength(FItemPerform, nIdx + 1);
    nP := @FItemPerform[nIdx];
  end;

  nP^ := nParam;
  nP.FEnable := True;

  UpdateActivePack;
  FModified := True;
end;

//Date: 2012-3-3
//Parm: 标识
//Desc: 删除标识为nID的性能参数
procedure TParamManager.DelPerform(const nID: string);
var nP: PPerformParam;
begin
  nP := GetPerform(nID);
  if Assigned(nP) then
  begin
    nP.FEnable := False;
    FModified := True;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2012-3-3
//Parm: 标识
//Desc: 获取标识为nID的DB参数
function TParamManager.GetDB(const nID: string): PDBParam;
var nIdx: Integer;
begin
  Result := nil;

  for nIdx:=Low(FItemDB) to High(FItemDB) do
  if FItemDB[nIdx].FEnable and (CompareText(nID, FItemDB[nIdx].FID) = 0) then
  begin
    Result := @FItemDB[nIdx];
    Break;
  end;
end;

//Date: 2012-3-5
//Parm: 参数
//Desc: 初始化nParam参数
procedure TParamManager.InitDB(var nParam: TDBParam);
begin
  with nParam do
  begin
    FHost := '127.0.0.1';
    FPort := 1433;
    FDB   := 'DBName';
    FUser := 'sa';
    FPwd  := '';
    FConn := 'Provider=SQLOLEDB.1;Password=$Pwd;Persist Security Info=True;' +
             'User ID=$User;Initial Catalog=$DBName;Data Source=$Host';
    FNumWorker := 20;
  end;
end;

//Date: 2012-3-3
//Parm: 参数
//Desc: 添加数据库参数
procedure TParamManager.AddDB(const nParam: TDBParam);
var nIdx: Integer;
    nP: PDBParam;
begin
  nP := GetDB(nParam.FID);
  if not Assigned(nP) then
  begin
    nIdx := Length(FItemDB);
    SetLength(FItemDB, nIdx + 1);
    nP := @FItemDB[nIdx];
  end;

  nP^ := nParam;
  nP.FEnable := True;

  UpdateActivePack;
  FModified := True;
end;

//Date: 2012-3-3
//Parm: 标识
//Desc: 删除标识为nID的数据库项
procedure TParamManager.DelDB(const nID: string);
var nP: PDBParam;
begin
  nP := GetDB(nID);
  if Assigned(nP) then
  begin
    nP.FEnable := False;
    FModified := True;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2012-3-3
//Parm: 列表;类型
//Desc: 获取nType类型的参数名列表
function TParamManager.LoadParam(const nList: TStrings;
  nType: TParamType): Boolean;
var nIdx: Integer;
begin
  nList.Clear;

  case nType of
   ptPack:
    begin
      for nIdx:=Low(FPacks) to High(FPacks) do
       if FPacks[nIdx].FEnable then
        nList.Add(FPacks[nIdx].FItemID);
    end;
   ptDB:
    begin
      for nIdx:=Low(FItemDB) to High(FItemDB) do
       if FItemDB[nIdx].FEnable then
        nList.Add(FItemDB[nIdx].FID);
    end;
   ptPerform:
    begin
      for nIdx:=Low(FItemPerform) to High(FItemPerform) do
       if FItemPerform[nIdx].FEnable then
        nList.Add(FItemPerform[nIdx].FID);
    end;
  end;

  Result := nList.Count > 0;
end;

//Date: 2012-3-3
//Parm: 参数标识;是否激活
//Desc: 获取标识为nID的参数包
function TParamManager.GetParamPack(const nID: string;
  const nActive: Boolean): PParamItemPack;
var nIdx: Integer;
begin
  Result := nil;

  for nIdx:=Low(FPacks) to High(FPacks) do
  if FPacks[nIdx].FEnable and (CompareText(nID, FPacks[nIdx].FItemID) = 0) then
  begin
    Result := @FPacks[nIdx];
    Break;
  end;

  if nActive then
  begin
    FActive := Result;
    if Assigned(Result) then
      FActiveName := FActive.FItemID;
    //xxxxx
  end;
end;

initialization
  gParamManager := nil;
finalization
  FreeAndNil(gParamManager);
end.
