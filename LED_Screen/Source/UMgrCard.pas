{*******************************************************************************
  作者: dmzn@ylsoft.com 2011-03-13
  描述: LED控制卡管理
*******************************************************************************}
unit UMgrCard;

interface

uses
  Windows, SysUtils, Classes, IniFiles, NativeXml, UWaitItem, ULibFun,
  USysConst, UBase64;

const
  //重发次数
  cSend_TryNum                 = 3;

  //临时内容文件
  cSend_File                   = 'run.txt';
            
  //控制器通讯模式
  SEND_MODE_COMM               = 0;
  SEND_MODE_NET                = 2;
  
  //用户发送信息命令表
  SEND_CMD_PARAMETER           = $A1FF; //加载屏参数。
  SEND_CMD_SCREENSCAN          = $A1FE; //设置扫描方式。
  SEND_CMD_SENDALLPROGRAM      = $A1F0; //发送所有节目信息。
  SEND_CMD_POWERON             = $A2FF; //强制开机
  SEND_CMD_POWEROFF            = $A2FE; //强制关机
  SEND_CMD_TIMERPOWERONOFF     = $A2FD; //定时开关机
  SEND_CMD_CANCEL_TIMERPOWERONOFF = $A2FC; //取消定时开关机
  SEND_CMD_RESIVETIME          = $A2FB; //校正时间。
  SEND_CMD_ADJUSTLIGHT         = $A2FA; //亮度调整。

  //通讯错误返回代码值
  RETURN_NOERROR               = 0;
  RETURN_ERROR_AERETYPE        = $F7;
  RETURN_ERROR_RA_SCREENNO     = $F8;
  RETURN_ERROR_NOFIND_AREAFILE = $F9;
  RETURN_ERROR_NOFIND_AREA     = $FA;
  RETURN_ERROR_NOFIND_PROGRAM  = $FB;
  RETURN_ERROR_NOFIND_SCREENNO = $FC;
  RETURN_ERROR_NOW_SENDING     = $FD;
  RETURN_ERROR_OTHER           = $FF;

  //控制器类型
  CONTROLLER_TYPE_FOURTH    = $40;
  CONTROLLER_TYPE_WILDCARD  = $FFFE;
  CONTROLLER_TYPE_3T        = $10;
  CONTROLLER_TYPE_3A        = $20;
  CONTROLLER_TYPE_3A1       = $21;
  CONTROLLER_TYPE_3A2       = $22;
  CONTROLLER_TYPE_3M        = $30;

  CONTROLLER_TYPE_4A1       = $0141;
  CONTROLLER_TYPE_4A2       = $0241;
  CONTROLLER_TYPE_4A3       = $0341;
  CONTROLLER_TYPE_4AQ       = $1041;
  CONTROLLER_TYPE_4A        = $0041;

  CONTROLLER_TYPE_4M1       = $0142;
  CONTROLLER_TYPE_4M        = $0042;
  CONTROLLER_TYPE_4MC       = $0C42;

  CONTROLLER_TYPE_4C        = $0043;
  CONTROLLER_TYPE_4E1       = $0144;
  CONTROLLER_TYPE_4E        = $0044;

type
  TCardCode = record
    FCode: Word;
    FDesc: string;
  end;

const
  cCardEffects: array[0..39] of TCardCode = (
             (FCode: $00; FDesc:'随机显示'),
             (FCode: $01; FDesc:'静态'),
             (FCode: $02; FDesc:'快速打出'),
             (FCode: $03; FDesc:'向左移动'),
             (FCode: $04; FDesc:'向左连移'),
             (FCode: $05; FDesc:'向上移动'),
             (FCode: $06; FDesc:'向上连移'),
             (FCode: $07; FDesc:'闪烁'),
             (FCode: $08; FDesc:'飘雪'),
             (FCode: $09; FDesc:'冒泡'),
             (FCode: $0A; FDesc:'中间移出'),
             (FCode: $0B; FDesc:'左右移入'),
             (FCode: $0C; FDesc:'左右交叉移入'),
             (FCode: $0D; FDesc:'上下交叉移入'),
             (FCode: $0E; FDesc:'画卷闭合'),
             (FCode: $0F; FDesc:'画卷打开'),
             (FCode: $10; FDesc:'向左拉伸'),
             (FCode: $11; FDesc:'向右拉伸'),
             (FCode: $12; FDesc:'向上拉伸'),
             (FCode: $13; FDesc:'向下拉伸'),
             (FCode: $14; FDesc:'向左镭射'),
             (FCode: $15; FDesc:'向右镭射'),
             (FCode: $16; FDesc:'向上镭射'),
             (FCode: $17; FDesc:'向下镭射'),
             (FCode: $18; FDesc:'左右交叉拉幕'),
             (FCode: $19; FDesc:'上下交叉拉幕'),
             (FCode: $1A; FDesc:'分散左拉'),
             (FCode: $1B; FDesc:'水平百页'),
             (FCode: $1D; FDesc:'向左拉幕'),
             (FCode: $1E; FDesc:'向右拉幕'),
             (FCode: $1F; FDesc:'向上拉幕'),
             (FCode: $20; FDesc:'向下拉幕'),
             (FCode: $21; FDesc:'左右闭合'),
             (FCode: $22; FDesc:'左右对开'),
             (FCode: $23; FDesc:'上下闭合'),
             (FCode: $24; FDesc:'上下对开'),
             (FCode: $25; FDesc:'向右连移'),
             (FCode: $26; FDesc:'向右连移'),
             (FCode: $27; FDesc:'向下移动'),
             (FCode: $28; FDesc:'向下连移'));
  //系统支持的特效

  cCardList: array[0..1] of TCardCode = (
             (FCode:CONTROLLER_TYPE_4M; FDesc:'BX-4M'),
             (FCode:CONTROLLER_TYPE_4M1; FDesc:'BX-4M1'));
  //系统支持的卡列表

  cCardScreens: array[0..2] of TCardCode = ((FCode:1; FDesc:'小屏'),
             (FCode:2; FDesc:'中屏'), (FCode:3; FDesc:'大屏'));
  //系统支持的屏幕类型

type
  TCardStatus = (csNormal, csSending, csDone);
  //正常;发送;发送结束

  PCardItem = ^TCardItem;
  TCardItem = record
    FType: Integer;         //类型
    FSerial: string;        //编号
    FName: string;          //名称

    FCard: Integer;         //控制器
    FDataOE: Byte;          //OE设定
    FIP: string;            //IP
    FPort: Integer;         //端口
    FWidth: Integer;        //宽度
    FHeight: Integer;       //高度
    FSpeed: Integer;        //运行
    FKeep: Integer;         //停留

    FEffect: Integer;       //特效
    FFontName: string;      //字体
    FFontSize: Integer;     //大小
    FFontBold: Byte;        //加粗

    FCounter: Byte;         //计数
    FStatus: TCardStatus;   //状态
    FLatUpdate: string;     //更新时间
  end;

  TCardMessage = procedure (const nItem: TCardItem; const nMsg: string) of Object;
  //消息状态

  TCardManager = class;
  TCardSendThread = class(TThread)
  private
    FOwner: TCardManager;
    //拥有者
    FWaiter: TWaitObject;
    //等待对象
    FNowItem: PCardItem;
    //当前对象
    FMessage: string;
    //提示消息

    FFileOpt: TStrings;
    //文件对象
    FBusy: Boolean;
    //运行状态
    FXML: TNativeXml;
    FFileName: string;
    //数据内容
  protected
    procedure Execute; override;
    procedure DoExecute;
    //执行线程
    procedure SyncHintMsg;
    procedure DoHintMsg(const nMsg: string; const nStatus: TCardStatus = csNormal);
    //提示消息
    function SendData(const nData: TXmlNode): Boolean;
    //发送内容
  public
    constructor Create(AOwner: TCardManager);
    destructor Destroy; override;
    //创建释放
    function Start(const nFile: string): Boolean;
    procedure Stop;
    //启动停止
  end;

  TCardManager = class(TObject)
  private
    FCards: TList;
    //卡列表     
    FFileName: string;
    //存储文件
    FChanged: Boolean;
    //内容改变
    FSender: TCardSendThread;
    //发送线程
    FMessage: TCardMessage;
    //消息状态
  protected
    procedure ClearList(const nFree: Boolean);
    //清理资源
    function FindCard(const nSerial: string): Integer;
    //检索卡
    function LoadFile(const nFile: string): Boolean;
    function SaveFile(const nFile: string): Boolean;
    //载入保存
    procedure SetFileName(const nFile: string);
    //设置文件
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放
    procedure AddCard(const nCard: TCardItem);
    procedure DelCard(const nSerial: string);
    //添加删除
    function SendData(const nFile: string): Boolean;
    //发送数据
    function GetErrorDesc(const nErr: Integer): string;
    //错误描述
    property Cards: TList read FCards;
    property FileName: string read FFileName write SetFileName;
    property OnMessage: TCardMessage read FMessage write FMessage;
    //属性相关
  end;

var
  gCardManager: TCardManager = nil;
  //全局使用

implementation

const
  cDLL = 'BX_IV.dll';

function AddScreen(nControlType, nScreenNo, nWidth, nHeight, nScreenType, 
  nPixelMode: Integer; nDataDA, nDataOE: Integer; nRowOrder, nFreqPar: Integer; 
  pCom: PChar; nBaud: Integer;
  pSocketIP: PChar; nSocketPort: Integer): integer; stdcall; external cDLL;
//添加、设置显示屏
function AddScreenProgram(nScreenNo, nProgramType: Integer; nPlayLength: Integer;
  nStartYear, nStartMonth, nStartDay, nEndYear, nEndMonth, nEndDay: Integer;
  nMonPlay, nTuesPlay, nWedPlay, nThursPlay, bFriPlay, nSatPlay, 
  nSunPlay: integer; nStartHour, nStartMinute, nEndHour,
  nEndMinute: Integer): Integer; stdcall; external cDLL;
//向指定显示屏添加节目
function AddScreenProgramBmpTextArea(nScreenNo, nProgramOrd: Integer;
  nX, nY, nWidth, nHeight: integer): Integer; stdcall; external cDLL;
//向指定显示屏指定节目添加图文区域
function AddScreenProgramAreaBmpTextFile(nScreenNo, nProgramOrd,
  nAreaOrd: Integer; pFileName: PChar; pFontName: PChar; nFontSize, nBold, 
  nFontColor: Integer; nStunt, nRunSpeed,
  nShowTime: Integer): Integer; stdcall; external cDLL;
//向指定显示屏指定节目指定区域添加文件
function DeleteScreen(nScreenNo: Integer): Integer; stdcall; external cDLL;
//删除指定显示屏
function DeleteScreenProgram(nScreenNo,
  nProgramOrd: Integer): Integer; stdcall; external cDLL;
//删除指定显示屏指定节目
function DeleteScreenProgramArea(nScreenNo, nProgramOrd,
  nAreaOrd: Integer): Integer; stdcall; external cDLL;
//删除指定显示屏指定节目的指定区域
function DeleteScreenProgramAreaBmpTextFile(nScreenNo, nProgramOrd, nAreaOrd,
  nFileOrd: Integer): Integer; stdcall; external cDLL;
//删除指定显示屏指定节目指定图文区域的指定文件
function SendScreenInfo(nScreenNo, nSendMode, nSendCmd,
  nOtherParam1: Integer): Integer; stdcall; external cDLL;
//发送相应命令到显示屏

//------------------------------------------------------------------------------
constructor TCardSendThread.Create(AOwner: TCardManager);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FOwner := AOwner;
  FFileOpt := TStringList.Create;

  FXML := TNativeXml.Create;
  FWaiter := TWaitObject.Create;
end;

destructor TCardSendThread.Destroy;
begin
  FWaiter.Free;
  FXML.Free;
  FFileOpt.Free;
  inherited;
end;

//Desc: 停止(外部调用)
procedure TCardSendThread.Stop;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure TCardSendThread.DoHintMsg(const nMsg: string; const nStatus: TCardStatus);
begin
  FMessage := nMsg;
  FNowItem.FStatus := nStatus;
  Synchronize(SyncHintMsg);
end;

procedure TCardSendThread.SyncHintMsg;
begin
  if Assigned(FOwner.FMessage) then
    FOwner.FMessage(FNowItem^, FMessage);
  //hint message
end;

//Desc: 启动线程
function TCardSendThread.Start(const nFile: string): Boolean;
begin
  Result := (not FBusy) and FileExists(nFile);
  if not Result then Exit;

  try
    FXML.LoadFromFile(nFile);
    FFileName := nFile;
    FWaiter.Wakeup;
  except
    Result := False;
  end;
end;

procedure TCardSendThread.Execute;
var nIdx: Integer;
begin
  FBusy := False;

  while True do
  try
    FWaiter.EnterWait;
    if Terminated then Break;

    for nIdx:=FOwner.FCards.Count - 1 downto 0 do
    begin
      FNowItem := FOwner.Cards[nIdx];
      FNowItem.FCounter := 0;
    end;
    
    FBusy := True;
    DoExecute;
    FBusy := False;
  except
    Sleep(500);
    FBusy := False;
    //maybe any error
  end;
end;

//Desc: 执行发送
procedure TCardSendThread.DoExecute;
var nStr: string;
    nNode: TXmlNode;
    i,nLen,nIdx: Integer;
begin
  while not Terminated do
  try
    nLen := 0;
    
    for nIdx:=FOwner.FCards.Count - 1 downto 0 do
    begin
      if Terminated then Break;
      FNowItem := FOwner.FCards[nIdx];

      if FNowItem.FCounter < cSend_TryNum then
      begin
        Inc(nLen); Break;
      end;
    end;

    if nLen < 1 then Exit;
    //has send all

    for nIdx:=FOwner.FCards.Count - 1 downto 0 do
    begin
      if Terminated then Break;
      FNowItem := FOwner.FCards[nIdx];
      if FNowItem.FCounter >= cSend_TryNum then Continue;
      
      DoHintMsg('开始发送', csSending);
      FNowItem.FLatUpdate := '';
      
      Inc(FNowItem.FCounter);
      nLen := FXML.Root.NodeCount - 1;

      for i:=0 to nLen do
      begin
        nNode := FXML.Root.Nodes[i];

        if nNode.HasAttribute('ID') then
        begin
          nStr := nNode.AttributeByName['ID'];
          if (nStr = FNowItem.FSerial) and SendData(nNode) then
          begin
            FNowItem.FCounter := cSend_TryNum; Break;
          end;
        end else

        if nNode.HasAttribute('type') then
        begin
          nStr := nNode.AttributeByName['type'];
          if IsNumber(nStr, False) and (StrToInt(nStr) = FNowItem.FType) and
             SendData(nNode) then
          begin
            FNowItem.FCounter := cSend_TryNum; Break;
          end;
        end;
      end;

      if FNowItem.FCounter >= cSend_TryNum then
        DoHintMsg('发送完毕', csDone);
      //xxxxx
    end;
  except
    //ignor any error
  end;
end;

//Desc: 向FNowItem发送nData数据
function TCardSendThread.SendData(const nData: TXmlNode): Boolean;
var nRes: Integer;
    nNode: TXmlNode;
begin
  Result := False;
  nNode := nData.FindNode('Content');

  if (not Assigned(nNode)) or (nNode.ValueAsString = '') then
  begin
    DoHintMsg('内容节点无效'); Exit;
  end;

  with FNowItem^,FOwner do
  try
    nRes := DeleteScreen(1);
    DoHintMsg(Format('DeleteScreen:%s', [GetErrorDesc(nRes)]));
    if (nRes<>RETURN_NOERROR) and (nRes<>RETURN_ERROR_NOFIND_SCREENNO) then Exit;

    nRes := AddScreen(FCard, 1, FWidth, FHeight, 1, 2, 0, FDataOE, 0, 0, 
            'COM1', 9600, PChar(FIP), FPort);
    DoHintMsg(Format('AddScreen:%s', [GetErrorDesc(nRes)]));
    if nRes <> RETURN_NOERROR then Exit;

    nRes := AddScreenProgram(1, 0, 0, 65535, 11, 26, 2011, 11, 26, 1, 1, 1,
            1, 1, 1, 1, 0, 0, 23, 59);
    DoHintMsg(Format('AddScreenProgram:%s', [GetErrorDesc(nRes)]));
    if nRes <> RETURN_NOERROR then Exit;

    nRes := AddScreenProgramBmpTextArea(1, 0, 0, 0, FWidth, FHeight);
    DoHintMsg(Format('AddScreenProgramBmpTextArea:%s', [GetErrorDesc(nRes)]));
    if nRes <> RETURN_NOERROR then Exit;

    if nNode.HasAttribute('encode') and (nNode.AttributeByName['encode'] = 'y') then
         FFileOpt.Text := DecodeBase64(nNode.ValueAsString)
    else FFileOpt.Text := nNode.ValueAsString;

    FFileOpt.SaveToFile(gPath + cSend_File);
    Sleep(100);
    //wait I/O

    nRes := AddScreenProgramAreaBmpTextFile(1, 0, 0, PChar(gPath + cSend_File),
            PChar(FFontName), FFontSize, FFontBold, 1, FEffect, FSpeed, FKeep);
    DoHintMsg(Format('AddScreenProgramAreaBmpTextFile:%s', [GetErrorDesc(nRes)]));
    if nRes <> RETURN_NOERROR then Exit;

    nRes := SendScreenInfo(1, SEND_MODE_NET, SEND_CMD_SENDALLPROGRAM, 0);
    DoHintMsg(Format('SendScreenInfo:%s', [GetErrorDesc(nRes)]));
  except
    //ignor any error
  end;

  Result := True;
  FNowItem.FLatUpdate := Time2Str(Now);
end;

//------------------------------------------------------------------------------
constructor TCardManager.Create;
begin
  FFileName := '';
  FChanged := False;
  FCards := TList.Create;
  FSender := TCardSendThread.Create(Self);
end;

destructor TCardManager.Destroy;
begin
  FSender.Stop;
  //stop thread

  if FChanged and (FFileName <> '') then
    SaveFile(FFileName);
  ClearList(True);
  inherited;
end;

procedure TCardManager.ClearList(const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx:=FCards.Count - 1 downto 0 do
  begin
    Dispose(PCardItem(FCards[nIdx]));
    FCards.Delete(nIdx);
  end;

  if nFree then FreeAndNil(FCards);
end;

function TCardManager.FindCard(const nSerial: string): Integer;
var nIdx: Integer;
begin
  Result := -1;

  for nIdx:=FCards.Count - 1 downto 0 do
  if CompareText(PCardItem(FCards[nIdx]).FSerial, nSerial) = 0 then
  begin
    Result := nIdx; Break;
  end;
end;

procedure TCardManager.AddCard(const nCard: TCardItem);
var nIdx: Integer;
    nItem: PCardItem;
begin
  nIdx := FindCard(nCard.FSerial);
  if nIdx < 0 then
  begin
    New(nItem);
    FCards.Add(nItem);
    FillChar(nItem^, SizeOf(TCardItem), #0);
  end else nItem := FCards[nIdx];

  with nItem^ do
  begin
    FType := nCard.FType;
    FSerial := nCard.FSerial;
    FName := nCard.FName;

    FCard := nCard.FCard;
    FDataOE := nCard.FDataOE;
    FIP := nCard.FIP;
    FPort := nCard.FPort;
    FWidth := nCard.FWidth;
    FHeight := nCard.FHeight;

    FSpeed := nCard.FSpeed;
    FKeep := nCard.FKeep;
    FEffect := nCard.FEffect;
    FFontName := nCard.FFontName;
    FFontSize := nCard.FFontSize;
    FFontBold := nCard.FFontBold; 
  end;

  FChanged := True;
end;

procedure TCardManager.DelCard(const nSerial: string);
var nIdx: Integer;
begin
  nIdx := FindCard(nSerial);
  if nIdx > -1 then
  begin
    Dispose(PCardItem(FCards[nIdx]));
    FCards.Delete(nIdx);
  end;

  FChanged := True;
end;

procedure TCardManager.SetFileName(const nFile: string);
begin
  if (nFile <> FFileName) and LoadFile(nFile) then FFileName := nFile;
end;

function TCardManager.LoadFile(const nFile: string): Boolean;
var nIni: TIniFile;
    nList: TStrings;
    i,nLen: Integer;
    nItem: PCardItem;
begin
  nIni := nil;
  nList := nil;
  try
    nIni := TIniFile.Create(nFile);
    nList := TStringList.Create;
    nIni.ReadSections(nList);

    nLen := nList.Count - 1;
    ClearList(False);
    FChanged := False;

    for i:=0 to nLen do
    if nIni.ReadString(nList[i], 'Flag', '') = nList[i] then
    begin
      New(nItem);
      FCards.Add(nItem);

      with nItem^,nIni do
      begin
        FType := ReadInteger(nList[i], 'Type', 0);
        FSerial := ReadString(nList[i], 'Serial', '');
        FName := ReadString(nList[i], 'Name', '');
        FCard := ReadInteger(nList[i], 'Card', 0);
        FDataOE := ReadInteger(nList[i], 'DataOE', 0);
        FIP := ReadString(nList[i], 'IP', '');
        FPort := ReadInteger(nList[i], 'Port', 0);
        FWidth := ReadInteger(nList[i], 'Width', 0);
        FHeight := ReadInteger(nList[i], 'Height', 0);
        FSpeed := ReadInteger(nList[i], 'Speed', 0);
        FKeep := ReadInteger(nList[i], 'Keep', 0);
        FEffect := ReadInteger(nList[i], 'Effect', 0);
        FFontName := ReadString(nList[i], 'FontName', '宋体');
        FFontSize := ReadInteger(nList[i], 'FontSize', 9);
        FFontBold := ReadInteger(nList[i], 'FontBold', 0);
      end;  
    end;        
    
    Result := True;
  except
    Result := False;
  end;

  nList.Free;
  nIni.Free;
end;

function TCardManager.SaveFile(const nFile: string): Boolean;
var nStr: string;
    nIni: TIniFile;
    nList: TStrings;
    i,nLen: Integer;
begin
  nIni := nil;
  nList := nil;
  try
    nIni := TIniFile.Create(nFile);
    nList := TStringList.Create;

    nIni.ReadSections(nList);
    nLen := nList.Count - 1;
      
    for i:=0 to nLen do
     if nIni.ReadString(nList[i], 'Flag', '') = nList[i] then
      nIni.EraseSection(nList[i]);
    //清理卡

    nLen := FCards.Count - 1;
    for i:=0 to nLen do
    begin
      nStr := Format('Card_%d', [i]);
      nIni.WriteString(nStr, 'Flag', nStr);

      with PCardItem(FCards[i])^,nIni do
      begin
        WriteInteger(nStr, 'Type', FType);
        WriteString(nStr, 'Serial', FSerial);
        WriteString(nStr, 'Name', FName);
        WriteInteger(nStr, 'Card', FCard);
        WriteInteger(nStr, 'DataOE', FDataOE);
        WriteString(nStr, 'IP', FIP);
        WriteInteger(nStr, 'Port', FPort);
        WriteInteger(nStr, 'Width', FWidth);
        WriteInteger(nStr, 'Height', FHeight);
        WriteInteger(nStr, 'Speed', FSpeed);
        WriteInteger(nStr, 'Keep', FKeep);
        WriteInteger(nStr, 'Effect', FEffect);

        WriteString(nStr, 'FontName', FFontName);
        WriteInteger(nStr, 'FontSize', FFontSize);
        WriteInteger(nStr, 'FontBold', FFontBold);
      end;
    end;

    FChanged := False;
    Result := True;   
  except
    Result := False;
  end;

  nList.Free;
  nIni.Free;
end;

//------------------------------------------------------------------------------
function TCardManager.GetErrorDesc(const nErr: Integer): string;
begin
  case nErr of
    RETURN_ERROR_AERETYPE: Result := '区域类型错误,在添加、删除图文区域' +
                      '文件时区域类型出错返回此类型错误.';
    RETURN_ERROR_RA_SCREENNO: Result := '已经有该显示屏信息,如要重新' +
                      '设定请先DeleteScreen删除该显示屏再添加.';
    RETURN_ERROR_NOFIND_AREAFILE: Result := '没有找到有效的区域文件';
    RETURN_ERROR_NOFIND_AREA: Result := '没有找到有效的显示区域,可以' +
                        '使用AddScreenProgramBmpTextArea添加区域信息.';
    RETURN_ERROR_NOFIND_PROGRAM: Result := '没有找到有效的显示屏节目.可以' +
                        '使用AddScreenProgram函数添加指定节目.';
    RETURN_ERROR_NOFIND_SCREENNO: Result := '系统内没有查找到该显示屏,可以' +
                        '使用AddScreen函数添加显示屏.';
    RETURN_ERROR_NOW_SENDING: Result := '系统内正在向该显示屏通讯,请稍后再通讯.';
    RETURN_ERROR_OTHER: Result := '其它错误.';
    RETURN_NOERROR: Result := '操作成功' else Result := '未定义的错误.';
  end;
end;

//Desc: 发送数据文件
function TCardManager.SendData(const nFile: string): Boolean;
begin
  Result := FSender.Start(nFile);
end;

initialization
  gCardManager := TCardManager.Create;
finalization
  FreeAndNil(gCardManager);
end.


