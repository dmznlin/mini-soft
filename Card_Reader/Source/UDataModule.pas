{*******************************************************************************
  作者: dmzn@163.com 2009-5-20
  描述: 数据库连接、操作相关 
*******************************************************************************}
unit UDataModule;

{$I Link.Inc}
interface

uses
  Windows, Graphics, SysUtils, Classes, IniFiles, CPort, UWaitItem, NativeXml,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient;

type
  TReaderType = (rtIn, rtOut);
  //里,外

  PReaderItem = ^TReaderItem;
  TReaderItem = record
    FID: string[36];
    FName: string[36];
    FType: TReaderType;
    FGroup: Integer;
    FAddrNo: Integer;
  end;

  TCardAction = record
    FCardNo: string;
    FTime: TDateTime;
    FReader: PReaderItem;
  end;

  PCardLog = ^TCardLog;
  TCardLog = record
    FCardNo: array[0..31] of Char;
    FAction: Byte;
    FTime: TDateTime;
  end;

  TFDM = class;
  TCardSender = class(TThread)
  private
    FOwner: TFDM;
    //拥有者
    FBuffer: TList;
    //发送缓冲
    FUser,FPwd: string;
    //用户名,密码
    FClient: TIdTCPClient;
    //客户端
    FWaiter: TWaitObject;
    //等待对象
    FMsg: string;
    //日志信息
    FXML: TNativeXml;
    //文档对象
    FStream: TMemoryStream;
    //流对象
  protected
    function DoExecute: Boolean;
    procedure Execute; override;
    //执行动作
    procedure ShowLog(const nMsg: string);
    procedure DoShowLog;
    //显示日志
  public
    constructor Create(const nOwner: TFDM);
    destructor Destroy; override;
    //创建释放
    procedure StopMe;
    //停止线程
  end;

  TFDM = class(TDataModule)
    IdClient1: TIdTCPClient;
    ComPort1: TComPort;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
  private
    { Private declarations }
    FReaders: TList;
    //读头列表
    FCardLen: Integer;
    //卡号长度
    FTimeLen: TDateTime;
    //配对超时
    FActions: array of TCardAction;
    //动作列表
    FRcvData: string;
    //接受数据
    FBuffer: TThreadList;
    //发送缓冲
    FSender: TCardSender;
    //发送对象
  protected
    procedure ClearBuffer(const nList: TList);
    procedure ClearReaders(const nFreeMe: Boolean);
    //清理资源
    function FindReader(const nID: string): Integer; overload;
    function FindReader(const nAddr: Integer): Integer; overload;
    //检索读头
    function FindAction(const nCardNo: string): Integer;
    //检索动作
    procedure DoFindCard(const nCardData: string);
    //处理数据
  public
    { Public declarations }
    procedure AddReader(const nReader: PReaderItem);
    procedure DelReader(const nID: string);
    //添加删除
    procedure LoadReaders(const nIni: TIniFile);
    procedure SaveReaders(const nIni: TIniFile);
    //载入保存
    function StartService(var nHint: string): Boolean;
    procedure StopService;
    //启停服务
    property Readers: TList read FReaders;
    //属性相关
  end;

var
  FDM: TFDM;

implementation

{$R *.dfm}

uses
  ULibFun, UFormMain;

const
  cBufferMax = 1000;
  //最大发送缓冲

//------------------------------------------------------------------------------
procedure TFDM.DataModuleCreate(Sender: TObject);
begin
  FReaders := TList.Create;
  FBuffer := TThreadList.Create;
end;

procedure TFDM.DataModuleDestroy(Sender: TObject);
begin
  StopService;
  ClearReaders(True);
  FBuffer.Free;
end;

procedure TFDM.ClearReaders(const nFreeMe: Boolean);
var nIdx: Integer;
begin
  for nIdx:=FReaders.Count - 1 downto 0 do
  begin
    Dispose(PReaderItem(FReaders[nIdx]));
    FReaders.Delete(nIdx);
  end;

  if nFreeMe then FreeAndNil(FReaders);
end;

procedure TFDM.ClearBuffer(const nList: TList);
var nIdx: Integer;
begin
  for nIdx:=nList.Count - 1 downto 0 do
  begin
    Dispose(PCardLog(nList[nIdx]));
    nList.Delete(nIdx);
  end;
end;

function TFDM.FindReader(const nID: string): Integer;
var nIdx: Integer;
begin
  Result := -1;

  for nIdx:=FReaders.Count - 1 downto 0 do
  if CompareText(PReaderItem(FReaders[nIdx]).FID, nID) = 0 then
  begin
    Result := nIdx; Break;
  end;
end;

function TFDM.FindReader(const nAddr: Integer): Integer;
var nIdx: Integer;
begin
  Result := -1;

  for nIdx:=FReaders.Count - 1 downto 0 do
  if PReaderItem(FReaders[nIdx]).FAddrNo = nAddr then
  begin
    Result := nIdx; Break;
  end;
end;

function TFDM.FindAction(const nCardNo: string): Integer;
var nIdx: Integer;
begin
  Result := -1;

  for nIdx:=Low(FActions) to High(FActions) do
  if FActions[nIdx].FCardNo = nCardNo then
  begin
    Result := nIdx; Break;
  end;
end;

procedure TFDM.AddReader(const nReader: PReaderItem);
var nIdx: Integer;
begin
  nIdx := FindReader(nReader.FID);
  if nIdx > -1 then
  begin
    Dispose(PReaderItem(FReaders[nIdx]));
    FReaders[nIdx] := nReader;
  end else FReaders.Add(nReader);
end;

procedure TFDM.DelReader(const nID: string);
var nIdx: Integer;
begin
  nIdx := FindReader(nID);
  if nIdx > -1 then
  begin
    Dispose(PReaderItem(FReaders[nIdx]));
    FReaders.Delete(nIdx);
  end;
end;

procedure TFDM.LoadReaders(const nIni: TIniFile);
var nStr: string;
    nIdx: Integer;
    nReader: PReaderItem;
begin
  ClearReaders(False);
  nIdx := nIni.ReadInteger('Readers', 'Number', 0);

  while nIdx > 0 do
  begin
    New(nReader);
    FReaders.Add(nReader);

    Dec(nIdx);
    nStr := 'Reader_' + IntToStr(nIdx);

    nReader.FID := nIni.ReadString(nStr, 'Serial', 'id');
    nReader.FName := nIni.ReadString(nStr, 'Name', '');
    nReader.FType := TReaderType(nIni.ReadInteger(nStr, 'Type', Ord(rtIn)));
    nReader.FGroup := nIni.ReadInteger(nStr, 'Group', 0);
    nReader.FAddrNo := nIni.ReadInteger(nStr, 'Addr', 0);
  end;
end;

procedure TFDM.SaveReaders(const nIni: TIniFile);
var nStr: string;
    nIdx: Integer;
begin
  for nIdx:=FReaders.Count - 1 downto 0 do
  with PReaderItem(FReaders[nIdx])^ do
  begin
    nStr := 'Reader_' + IntToStr(nIdx);
    nIni.WriteString(nStr, 'Serial', FID);
    nIni.WriteString(nStr, 'Name', FName);
    nIni.WriteInteger(nStr, 'Type', Ord(FType));
    nIni.WriteInteger(nStr, 'Group', FGroup);
    nIni.WriteInteger(nStr, 'Addr', FAddrNo);
  end;
  nIni.WriteInteger('Readers', 'Number', FReaders.Count);
end;

//------------------------------------------------------------------------------
//Desc: 启动服务
function TFDM.StartService(var nHint: string): Boolean;
begin
  with fFormMain do
  begin
    nHint := '启动成功';
    Result := True;

    SetLength(FActions, 0);
    FCardLen := StrToInt(EditNoLen.Text);
    FTimeLen := StrToInt(EditTimeLen.Text) / (60 * 24);

    with IdClient1 do
    begin
      Host := EditIP.Text;
      Port := StrToInt(EditPort.Text);

      ReadTimeout := 5 * 1000;
      try
        Connect;
      except
        Result := False;
        nHint := '无法连接到服务器'; Exit;
      end;
    end;

    with ComPort1 do
    begin
      Close;
      Port := EditComm.Text;
      BaudRate := StrToBaudRate(EditBaud.Text);

      try
        Open;
      except
        Result := False;
        nHint := '无法打开指定串口'; Exit;
      end;
    end;

    if Assigned(FSender) then
    begin
      Result := False;
      nHint := '发送线程逻辑错误'; Exit;
    end;

    FSender := TCardSender.Create(Self);
    //发送线程
  end;
end;

procedure TFDM.StopService;
begin
  ComPort1.Close;
  //停止串口
  SetLength(FActions, 0);
  //清空动作

  if Assigned(FSender) then
  begin
    FSender.StopMe;
    FreeAndNil(FSender);
  end;
  //停止发送

  try
    ClearBuffer(FBuffer.LockList);
  finally
    FBuffer.UnlockList;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 读取到卡号
procedure TFDM.ComPort1RxChar(Sender: TObject; Count: Integer);
var nStr: string;
    nIdx,nLen,nS,nE: Integer;
begin
  ComPort1.ReadStr(nStr, Count);
  FRcvData := FRcvData + nStr;
  nLen := Length(FRcvData);

  nS := 1;
  nE := 0;
  try
    for nIdx:=1 to nLen do
    begin
      if FRcvData[nIdx] = #2 then
      begin
        nS := nIdx;
      end else

      if FRcvData[nIdx] = #13 then
      begin
        nE := nIdx;
        if nE - nS >= FCardLen then
          DoFindCard(Copy(FRcvData, nS + 1, nE - nS - 3));
        //xxxxx
      end;
    end;
  finally
    if nE > 0 then
      System.Delete(FRcvData, 1, nE);
    //xxxxx
  end;
end;

//Desc: 转换nCardNo格式
function ConvertCardNo(const nCardNo: string; const nCardLen: Integer): string;
begin
  Result := IntToStr(StrToInt('$' + nCardNo));
  Result := StringOfChar('0', nCardLen - Length(Result)) + Result;
end;

//Desc: 处理采集到的数据(addr + card)
procedure TFDM.DoFindCard(const nCardData: string);
var nLog: PCardLog;
    nStr,nCardNo: string;
    nIdx,nInt,nLen: Integer;
begin
  nLen := Length(nCardData);
  nStr := Copy(nCardData, 1, nLen - FCardLen);
  if not IsNumber(nStr, False) then Exit;

  nInt := FindReader(StrToInt(nStr));
  if nInt < 0 then Exit;

  nCardNo := Copy(nCardData, nLen - FCardLen + 1, FCardLen);
  nCardNo := ConvertCardNo(nCardNo, FCardLen);

  if fFormMain.CheckLogs.Checked then
  begin
    nStr := '采集:[ %s ] 地址:[ %d ] 卡号:[ %s ]';
    nStr := Format(nStr, [nCardData, PReaderItem(FReaders[nInt]).FAddrNo, nCardNo]);
    fFormMain.ShowLog(nStr);
  end;
  
  nIdx := FindAction(nCardNo);
  if (nIdx < 0) or
     //无历史动作
     (Now - FActions[nIdx].FTime >= FTimeLen) or
     //配对超时
     (PReaderItem(FReaders[nInt]).FGroup <> FActions[nIdx].FReader.FGroup) or
     //不是同一分组
     (PReaderItem(FReaders[nInt]).FType = FActions[nIdx].FReader.FType) then
     //同组同类型
  begin
    if nIdx < 0 then
    begin
      nIdx := Length(FActions);
      SetLength(FActions, nIdx+1);
    end;

    with FActions[nIdx] do
    begin
      FCardNo := nCardNo;
      FTime := Now;
      FReader := FReaders[nInt];
    end;

    Exit;
  end;

  with PReaderItem(FReaders[nInt])^, FActions[nIdx], fFormMain do
  begin
    nStr := DateTime2Str(Now);
    if FType = rtIn then
         ShowRunStatus(nStr, nCardNo, '进门(in)', FReader.FName + ' -> ' + FName)
    else ShowRunStatus(nStr, nCardNo, '出门(out)', FName + ' <- ' + FReader.FName);

    with FBuffer.LockList do
    try
      if Count >= cBufferMax then
      begin
        fFormMain.ShowLog('主进程发送缓冲溢出');
        Exit;
      end;

      New(nLog);
      Add(nLog);

      StrPCopy(@nLog.FCardNo[0], nCardNo);
      nLog.FAction := Ord(FType);
      nLog.FTime := Now;
    finally
      FBuffer.UnlockList;
    end;
  end;
end;

//------------------------------------------------------------------------------
constructor TCardSender.Create(const nOwner: TFDM);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FOwner := nOwner;
  FClient := FOwner.IdClient1;
  FUser := fFormMain.EditUser.Text;
  FPwd := fFormMain.EditPwd.Text;

  FWaiter := TWaitObject.Create;
  FWaiter.Interval := 5 * 1000;
  
  FBuffer := TList.Create;
  FXML := TNativeXml.Create;
  FStream := TMemoryStream.Create;
end;

destructor TCardSender.Destroy;
begin 
  FBuffer.Free;
  FXML.Free;
  FStream.Free;
  FWaiter.Free;
  inherited;
end;

procedure TCardSender.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;
  WaitFor;
end;

procedure TCardSender.ShowLog(const nMsg: string);
begin
  FMsg := nMsg;
  Synchronize(DoShowLog);
end;

procedure TCardSender.DoShowLog;
begin
  fFormMain.ShowLog(FMsg);
end;

procedure TCardSender.Execute;
var nList: TList;
    nIdx: Integer;
begin
  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Break;

    if FBuffer.Count > cBufferMax then
    begin
      FOwner.ClearBuffer(FBuffer);
      ShowLog('主线程发送缓冲溢出');
    end;

    nList := FOwner.FBuffer.LockList;
    try
      for nIdx:=nList.Count - 1 downto 0 do
        FBuffer.Add(nList[nIdx]);
      nList.Clear;
    finally
      FOwner.FBuffer.UnlockList;
    end;

    if (FBuffer.Count > 0) and DoExecute then
      FOwner.ClearBuffer(FBuffer);
    //发送数据
  except
    //ignor any error
  end;

  FOwner.ClearBuffer(FBuffer);
  FClient.Disconnect;
end;

function TCardSender.DoExecute: Boolean;
var nIdx: Integer;
    nNode: TXmlNode;
begin
  Result := False;
  if not FClient.Connected then
  try
    FClient.Connect;
  except
    on E:Exception do
    begin
      ShowLog('连接服务器失败: ' + E.Message);
      Exit;
    end;
  end;

  with FXML do
  begin
    Clear;
    //XmlFormat := xfReadable;

    EncodingString := 'gb2312';
    VersionString := '1.0';
    Root.Name := 'CardItems';

    with Root.NodeNew('Verify') do
    begin
      NodeNew('User').ValueAsString := FUser;
      NodeNew('Password').ValueAsString := FPwd;
    end;

    nNode := Root.NodeNew('Items');
    //item node
    
    for nIdx:=FBuffer.Count - 1 downto 0 do
    with PCardLog(FBuffer[nIdx])^, nNode.NodeNew('Item') do
    begin
      NodeNew('CardNo').ValueAsString := FCardNo;
      NodeNew('Action').ValueAsInteger := FAction;
      NodeNew('Time').ValueAsString := DateTime2Str(FTime);
    end;
  end;

  FXML.SaveToStream(FStream);
  FClient.Socket.Write(FStream, FStream.Size, True);

  if FClient.Socket.ReadByte() = 0 then
       ShowLog('主线程发送完毕,远程已接收!')
  else ShowLog('主线程发送完毕,远程拒收!!');
  Result := True;
end;

end.
