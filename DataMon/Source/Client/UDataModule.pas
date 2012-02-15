{*******************************************************************************
  作者: dmzn@163.com 2011-5-30
  描述: 远程数据模块
*******************************************************************************}
unit UDataModule;

{$I Link.inc}
interface

uses
  Windows, SysUtils, Classes, SyncObjs, UWaitItem, ULibFun, MMSystem, uROClient,
  uROWinInetHttpChannel, uROBinMessage, UMgrMCGS, DataMon_Intf, USysConst;

type
  TFDM = class;
  TRemoteSender = class(TThread)
  private
    FOwner: TFDM;
    //拥有者
    FWaiter: TWaitObject;
    //等待对象
    FList: TStrings;
    //内容列表
    FLastSend: Cardinal;
    //上次发送
  protected
    procedure DoExecute;
    procedure Execute; override;
    //线程体
    procedure DoWarn;
    //警告音
  public
    constructor Create(AOwner: TFDM);
    destructor Destroy; override;
    //创建释放
    procedure Stop;
    //停止线程
  end;

  TRemoteParam = record
    FURL: string;                  //远程地址
    FWarnSound: string;            //报警声音
    FWarnInterval: Cardinal;       //报警间隔
  end;

  TFDM = class(TDataModule)
    ROChannel1: TROWinInetHTTPChannel;
    ROBin1: TROBinMessage;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FParam: TRemoteParam;
    //参数
    FRemote: IDataService;
    //远程服务
    FSyncer: TCriticalSection;
    //同步锁
    FBufIdx: Integer;
    FBufLen: Integer;
    FBuffer: TMCGSParamItems;
    //缓冲区
    FSender: TRemoteSender;
    //发送线程
  public
    { Public declarations }
    procedure StartSender(const nParam: TRemoteParam);
    procedure StopSender;
    //启动停止
    procedure OnData(const nData: TMCGSParamItem);
    //获取数据
    function CheckURL(const nURL: string): Boolean;
    //校验地址
  end;

var
  FDM: TFDM;

implementation

{$R *.dfm}

const
  cBufSize = 1000;

procedure TFDM.DataModuleCreate(Sender: TObject);
begin
  FSyncer := TCriticalSection.Create;
  FRemote := CoDataService.Create(ROBin1, ROChannel1);
end;

procedure TFDM.DataModuleDestroy(Sender: TObject);
begin
  FRemote := nil;
  FSyncer.Free;
end;

function TFDM.CheckURL(const nURL: string): Boolean;
begin
  try
    ROChannel1.TargetURL := nURL;
    Result := FRemote.UpdateDataStrs('');
  except
    Result := False;
  end;
end;

procedure TFDM.StartSender(const nParam: TRemoteParam);
begin
  FParam := nParam;
  FParam.FWarnInterval := nParam.FWarnInterval * 1000;

  gMCGSManager.OnData := OnData;
  ROChannel1.TargetURL := FParam.FURL;

  FBufIdx := 0;
  FBufLen := 0;
  SetLength(FBuffer, cBufSize);

  if not Assigned(FSender) then
    FSender := TRemoteSender.Create(Self);
  //xxxxx
end;

procedure TFDM.StopSender;
begin
  if Assigned(FSender) then
  begin
    FSender.Stop;
    FSender := nil;
  end;
end;

procedure TFDM.OnData(const nData: TMCGSParamItem);
begin
  FSyncer.Enter;
  try
    FBuffer[FBufIdx] := nData;
    Inc(FBufIdx);
    Inc(FBufLen);

    if FBufIdx >= cBufSize then FBufIdx := 0;
    if FBufLen > cBufSize then FBufLen := cBufSize;

    {$IFDEF debug}
    ShowSyncLog('Data: ' + IntToStr(FBufLen));
    {$ENDIF}
  finally
    FSyncer.Leave;
  end;
end;

//------------------------------------------------------------------------------
constructor TRemoteSender.Create(AOwner: TFDM);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FOwner := AOwner;
  FList := TStringList.Create;

  FWaiter := TWaitObject.Create;
  FWaiter.Interval := 3 * 1000;
end;

destructor TRemoteSender.Destroy;
begin
  FWaiter.Free;
  FList.Free;
  inherited;
end;

procedure TRemoteSender.Stop;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure TRemoteSender.DoWarn;
begin
  with FOwner do
   if FParam.FWarnSound <> '' then
    PlaySound(PChar(FParam.FWarnSound), 0, SND_ASYNC or SND_LOOP);
  //sound
end;

procedure TRemoteSender.Execute;
begin
  FLastSend := GetTickCount;
  //send now

  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Exit;

    if FOwner.FBufLen > 0 then
         DoExecute
    else FLastSend := GetTickCount;

    if GetTickCount - FLastSend >= FOwner.FParam.FWarnInterval then
    begin
      Synchronize(DoWarn);
      FLastSend := GetTickCount;
    end;
    //do warn
  except
    //ignor any error
  end;
end;

procedure TRemoteSender.DoExecute;
var nIdx: Integer;
begin 
  with FOwner do
  try
    FList.Clear;
    FSyncer.Enter;
    
    for nIdx:=0 to FBufLen -1 do
    with FBuffer[nIdx] do
    begin
      FList.Add(Format('%s:%s:%d:%.2f:%.2f:%.2f:%.2f:%.2f:%.2f:%.2f:%.2f:' +
          '%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:' +        //13-Frs4
          '%.2f:%.2f:%.2f:%.2f:%.2f:%d:%d:%.2f:%d:%d:' +     //10-Fhot
          '%.2f:%.2f:%.2f:%.2f:%.2f:%.2f:%.2f:%.2f:%.2f',    //9-Fccr
          [FCH,FDH,                     //场号,栋号
          FSerial,                      //栋号顺序
          Fw1,Fw2,Fw3,Fw4,              //温度
          Fs1,Fs2,Fs3,Fs4,              //湿度
          Ffj1,Ffj2,Ffj3,Ffj4,Ffj5,     //风机
          Ffjo,Ffjc,		                //风机起停
          Ftfjb,                        //通风级别
          Ftfbj,                        //通风报警
          Frs1,Frs2,Frs3,Frs4,          //热水
          Frld,Frlh,                    //日龄
          Fllt,Fllk,	                  //料量
          Frll,		                      //日料量
          Fslt,fslk,	                  //水量
          Fsww,	                        //室外温度
          Fcold,	                      //凉
          Fhot,	                        //热
          Fweight,                      //体重
          Fmw,                          //目标温度
          Faq,	                        //氨气
          Ffy1,Ffy2,	                  //负压
          Fslkd,                        //水帘开度
          Fslb,                         //水帘泵
          Fccl,Fccr                     //侧窗
          ]));
    end; //data list

    FBufIdx := 0;
    FBufLen := 0;
  finally
    FSyncer.Leave;
  end;

  if FList.Count < 1 then
  begin
    FLastSend := GetTickCount;
    Exit;
  end;

  {$IFDEF debug}
  ShowSyncLog(Format('Sender: %d:::%d', [FList.Count, FOwner.FBufLen]));
  {$ENDIF}

  nIdx := 0;
  while nIdx < 3 do
  try 
    FOwner.FRemote.UpdateDataStrs(CombinStr(FList, '|'));
    FLastSend := GetTickCount;
    Break;
  except
    on E:Exception do
    begin
      Inc(nIdx);
      FWaiter.EnterWait;
      if Terminated then Exit;

      {$IFDEF debug}
      ShowSyncLog('Sender: ' + E.Message);
      {$ENDIF}
    end;
  end;
end;

end.
