{*******************************************************************************
  作者: dmzn@163.com 2010-7-21
  描述: 库功能实现部分
*******************************************************************************}
unit UDataModule;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, UProtocol, ULibConst, SPComm,
  CPort, CPortTypes;

type
  TFDM = class(TDataModule)
    CPort1: TComPort;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure CPort1RxChar(Sender: TObject; Count: Integer);
  private
    { Private declarations }
    FBuffer: array of Byte;
    //接收缓存
    procedure CommReceiveData(const nBuf: PChar; const nBufLen: Word);
    //处理数据
  public
    { Public declarations }
    FWaitCommand: Integer;
    //等待命令字
    FWaitResult: Boolean;
    //等待对象
    FValidBuffer: array of Byte;
    //有效数据
    function WaitForTimeOut(var nMsg: string): Boolean;
    //等待超时
  end;

var
  FDM: TFDM;

procedure CommPortInit(const nComm: PChar; const nBaudRate: DWORD); stdcall;
//初始化端口
function CommPortConn: Boolean; stdcall;
function CommPortClose: Boolean; stdcall;
//连接和关闭

procedure TransInit(const nCardType,nAreaNum,nInvert: Byte); stdcall;
//传输初始化
function TransBegin(const nMsg: PChar): Boolean; stdcall;
//传输开始
function TransData(const nRect: PAreaRect; const nMode: PAreaMode;
 const nFont: PAreaFont; const nText,nMsg: PChar): Boolean; stdcall;
//传输数据
function TransEnd(const nMsg: PChar): Boolean; stdcall;
//传输结束

implementation

{$R *.dfm}

type
  TCardItem = record
    FCardType: Byte;
    FAreaNum: Byte;
    FInvert: Boolean;
  end;

var
  gCardItem: TCardItem;
  //卡参数

//------------------------------------------------------------------------------
//Date: 2010-7-20
//Parm: 端口;波特率
//Desc: 初始化串口配置
procedure CommPortInit(const nComm: PChar; const nBaudRate: DWORD);
begin
  with FDM.CPort1 do
  begin
    Close;
    Port := nComm;
    BaudRate := StrToBaudRate(IntToStr(nBaudRate));
  end;
end;

//Desc: 连接
function CommPortConn: Boolean;
begin
  with FDM.CPort1 do
  try
    Close;
    //close first;
    Open;
    Result := Connected;
  except
    Result := False;
  end;
end;

//Desc: 关闭连接
function CommPortClose: Boolean;
begin
  try
    FDM.CPort1.Close;
    Result := not FDM.CPort1.Connected;
  except
    Result := False;
  end;
end;

//Date: 2010-7-20
//Parm: 卡类型;区域个数;反转扫描
//Desc: 初始化传输参数
procedure TransInit(const nCardType,nAreaNum,nInvert: Byte);
begin
  FillChar(gCardItem, SizeOf(gCardItem), #0);
  gCardItem.FCardType := nCardType;
  gCardItem.FAreaNum := nAreaNum;
  gCardItem.FInvert := nInvert = 1;
end;

//Date: 2010-7-20
//Parm: [out]提示信息
//Desc: 开启传输
function TransBegin(const nMsg: PChar): Boolean;
var nStr: string;
    nData: THead_Send_DataBegin;
    nRespond: THead_Respond_DataBegin;
begin
  Result := False;
  FillChar(nData, cSize_Head_Send_DataBegin, #0);

  nData.FHead := Swap(cHead_DataSend);
  nData.FLen := Swap(cSize_Head_Send_DataBegin);
  nData.FCardType := gCardItem.FCardType;

  nData.FDevice := sFlag_BroadCast;
  nData.FAreaNum := gCardItem.FAreaNum;
  nData.FCommand := cCmd_DataBegin;  

  with FDM do
  try
    FWaitCommand := nData.FCommand;
    CPort1.ClearBuffer(True, True);
    Result := CPort1.Write(@nData, cSize_Head_Send_DataBegin) =
                                   cSize_Head_Send_DataBegin;
    //xxxxx

    if not Result then
    begin
      nStr := '"开始帧"数据发送失败,无法打开传输模式!!';
      StrPCopy(nMsg, nStr); Exit;
    end;

    Result := WaitForTimeOut(nStr);
    if not Result then
    begin
      nStr := '等待"开始帧"响应超时,无法打开传输模式!!';
      StrPCopy(nMsg, nStr);  Exit;
    end;

    Move(FDM.FValidBuffer[0], nRespond, cSize_Head_Respond_DataBegin);
    Result := nRespond.FFlag = sFlag_OK;

    if Result then
    begin
      nStr := '打开传输模式,开始发送数据!';
      StrPCopy(nMsg, nStr);
    end else
    begin
      nStr := '"开始帧"发送成功,但下位机打开传输模式失败!!';
      StrPCopy(nMsg, nStr);
    end;
  except
    StrPCopy(nMsg, '无法打开传输模式');
  end;
end;

//------------------------------------------------------------------------------
//Desc: 用nData构建一个字节
function MakeByte(const nData: TByteData): Byte;
var i,nLen: integer;
begin
  Result := 255;
  nLen := High(nData);

  for i:=Low(nData) to nLen do
  if nData[i] = 1 then
       Result := Result or cByteMask[i]
  else Result := Result and (255 xor cByteMask[i]);
end;

//Desc: 将nData放入nByte字节组中
procedure CharToByte(const nData: string; var nByte: TByteData);
var nIdx: integer;
begin
  for nIdx:=1 to 8 do
    nByte[nIdx - 1] := StrToInt(nData[nIdx]);
end;

//Desc: 用nData构建nArray字节组
procedure MakeByteArray(const nData: string; var nArray: TDynamicByteArray);
var nStr: string;
    nBit: TByteData;
    i,nIdx,nLen: integer;
begin
  nLen := Length(nData);
  if nLen mod 8 = 0 then
       nStr := nData
  else nStr := nData + StringOfChar('0', 8 - nLen mod 8);

  nLen := Length(nStr);
  i := nLen div 8;
  SetLength(nArray, i);

  nIdx := 0;
  for i:=1 to nLen do
   if i mod 8 = 0 then
   begin
     CharToByte(Copy(nStr, nIdx * 8 + 1, 8), nBit);
     nArray[nIdx] := MakeByte(nBit);
     Inc(nIdx);
   end;
end;

//Desc: 合并nS数据到nD中
procedure CombinByteArray(var nS,nD: TDynamicByteArray);
var nInt,nLen: integer;
begin
  nInt := Length(nS);
  nLen := Length(nD);
  
  SetLength(nD, nInt + nLen);
  Move(nS[Low(nS)], nD[nLen], nInt);
end;

//Desc: 使用单色编码扫描nBmp,存入nData缓冲中
procedure ScanWithSingleMode(const nBmp: TBitmap; var nData: TDynamicByteArray);
var nBuf: string;
    nX,nY: integer;
    nBits: TDynamicByteArray;
begin
  SetLength(nData, 0);
  SetLength(nBuf, nBmp.Width);

  for nY :=0 to nBmp.Height - 1 do
  begin
    for nX:=0 to nBmp.Width - 1 do
    begin
      if nBmp.Canvas.Pixels[nX, nY] = clBlack then
           nBuf[nX + 1] := '1'
      else nBuf[nX + 1] := '0';

      if gCardItem.FInvert then
       if nBuf[nX + 1] = '0' then
            nBuf[nX + 1] := '1'
       else nBuf[nX + 1] := '0';
    end;

    MakeByteArray(nBuf, nBits);
    CombinByteArray(nBits, nData);
  end;
end;

//Desc: 将nFont赋予nCanvas画布
procedure AssignCanvasFont(const nCanvas: TCanvas; const nFont: TAreaFont);
begin
  with nCanvas do
  begin
    Font.Color := clRed;
    Font.Name := nFont.FName;
    Font.Size := nFont.FSize;
    SetBkMode(Handle, TRANSPARENT);
  end;
end;

//Desc: 将nBmp按照nW,nH大小拆分,结果存入nData中.
procedure SplitPicture(const nBmp: TBitmap; const nW,nH: Integer;
 var nData: TDynamicBitmapArray);
var nSR,nDR: TRect;
    nL,nT,nIdx: integer;
begin
  nT := 0;
  while nT < nBmp.Height do
  begin
    nL := 0;

    while nL < nBmp.Width do
    begin
      nIdx := Length(nData);
      SetLength(nData, nIdx + 1);

      nData[nIdx] := TBitmap.Create;
      nData[nIdx].Width := nW;
      nData[nIdx].Height := nH;

      nSR := Rect(nL, nT, nL + nW, nT + nH);
      nDR := Rect(0, 0, nW, nH);

      nData[nIdx].Canvas.CopyRect(nDR, nBmp.Canvas, nSR);
      //复制区域图片
      Inc(nL, nW); 
    end;

    Inc(nT, nH);
  end;
end;

//Desc: 将nText绘制到一组图片中,存入nData
procedure DrawText(const nRect: TAreaRect; const nFont: TAreaFont;
 const nText: string; var nData: TDynamicBitmapArray);
var nStr: WideString;
    nBigBuf: TDynamicBitmapArray;
    nPos,nLen,nL,nT,nW,nBufIdx: integer;
begin
  nStr := nText;
  SetLength(nData, 0);

  SetLength(nBigBuf, 1);
  nBigBuf[0] := TBitmap.Create;
  try
    with nBigBuf[0] do
    begin
      AssignCanvasFont(Canvas, nFont);
      nW := Canvas.TextWidth(nStr);
      //内容宽度

      nL := Trunc(nW / nRect.FWidth);
      if (nW mod nRect.FWidth) <> 0 then Inc(nL);
      //需要分的屏幕数

      nT := Trunc(4096 / nRect.FWidth);
      if nT > nL then nT := nL;
      //单张图片需分屏数

      Height := nRect.FHeight;
      Width := nRect.FWidth * nT;
      //图片大小

      Canvas.Brush.Color := clBlack;
      Canvas.FillRect(Rect(0, 0, Width, Height));

      nT := Canvas.TextHeight(nStr);
      nT := Trunc((nRect.FHeight - nT) / 2);
      //绘制纵向居中
    end;             

    nL := 0;
    //绘制起点
    nPos := 1;
    //文本索引
    nBufIdx := 0;
    //缓冲索引
    nLen := Length(nStr);

    while nPos <= nLen do
    with nBigBuf[nBufIdx] do
    begin
      Canvas.TextOut(nL, nT, nStr[nPos]);
      Inc(nL, Canvas.TextWidth(nStr[nPos]));
      Inc(nPos);

      if nPos <= nLen then
           nW := Canvas.TextWidth(nStr[nPos])
      else nW := 0;

      if nL + nW > Width then
      begin
        nL := 0;
        Inc(nBufIdx);

        SetLength(nBigBuf, nBufIdx+1);
        nBigBuf[nBufIdx] := TBitmap.Create;
        nBigBuf[nBufIdx].Width := nBigBuf[0].Width;
        nBigBuf[nBufIdx].Height := nBigBuf[0].Height;

        nBigBuf[nBufIdx].Canvas.Brush.Color := clBlack;
        nBigBuf[nBufIdx].Canvas.FillRect(Rect(0, 0, Width, Height));
        AssignCanvasFont(Canvas, nFont);
      end;
    end;

    //--------------------------------------------------------------------------
    for nBufIdx:=Low(nBigBuf) to High(nBigBuf) do
      SplitPicture(nBigBuf[nBufIdx], nRect.FWidth, nRect.FHeight, nData);
    //分屏
  finally
    for nBufIdx:=Low(nBigBuf) to High(nBigBuf) do
      nBigBuf[nBufIdx].Free;
    //xxxxx
  end;
end;

//Date: 2010-7-20
//Parm: 区域;模式;字体;内容
//Desc: 在nRect区域内,用nMode模式显示nText内容
function TransData(const nRect: PAreaRect; const nMode: PAreaMode;
 const nFont: PAreaFont; const nText,nMsg: PChar): Boolean;
var nStr: string;
    nIdx: Integer;
    nBuf: TDynamicBitmapArray;

    nCRC: Word;
    nData: TDynamicByteArray;
    nSend: THead_Send_PicData;
    nRespond: THead_Respond_PicData;
begin
  Result := False;
  StrPCopy(nMsg, '');

  nStr := StrPas(nText);
  if nStr = '' then Exit;

  try
    DrawText(nRect^, nFont^, nStr, nBuf);
    if Length(nBuf) < 1 then
    begin
      StrPCopy(nMsg, '无法扫描文本内容,操作终止!'); Exit;
    end;

    //--------------------------------------------------------------------------
    FillChar(nSend, cSize_Head_Send_PicData, #0);
    nSend.FHead := Swap(cHead_DataSend);
    nSend.FCardType := gCardItem.FCardType;
    nSend.FCommand := cCmd_SendPicData;

    nSend.FDevice := sFlag_BroadCast;
    nSend.FAllID := Swap(Length(nBuf));
    nSend.FLevel := 0;
    nSend.FIndexID := 0;

    nSend.FPosX := Swap(nRect.FLeft);
    nSend.FPosY := Swap(nRect.FTop);
    nSend.FWidth := Swap(nRect.FWidth);
    nSend.FHeight := Swap(nRect.FHeight);

    for nIdx:=Low(nBuf) to High(nBuf) do
    try
      ScanWithSingleMode(nBuf[nIdx], nData);
      nSend.FNowID := Swap(nIdx);
      nSend.FLen := Swap(Length(nData) + cSize_Head_Send_PicData + 2);
      //调整协议数据

      nSend.FMode[0] := nMode.FEnterMode;
      nSend.FMode[1] := nMode.FEnterSpeed;
      nSend.FMode[2] := nMode.FKeepTime;
      nSend.FMode[3] := nMode.FExitMode;
      nSend.FMode[4] := nMode.FExitSpeed;
      nSend.FMode[5] := nMode.FModeSerial;
      nSend.FMode[6] := 1;
      //填充模式

      FDM.FWaitCommand := nSend.FCommand;
      Result := FDM.CPort1.Write(@nSend, cSize_Head_Send_PicData) > 0;

      if Result then
        Result := FDM.CPort1.Write(@nData[Low(nData)], Length(nData)) > 0;
      //图片数据

      if Result then
      begin
        nCRC := 0;
        Result := FDM.CPort1.Write(@nCRC, SizeOf(nCRC)) > 0;
      end;
      //校验位

      if not Result then
      begin
        nStr := '第[ %d ]幕数据发送失败!!';
        StrPCopy(nMsg, Format(nStr, [nIdx])); Break;
      end;

      Result := FDM.WaitForTimeOut(nStr);
      if not Result then
      begin
        nStr := '发送第[ %d ]幕数据时下位机无响应!!';
        StrPCopy(nMsg, Format(nStr, [nIdx])); Break;
      end;

      Move(FDM.FValidBuffer[0], nRespond, cSize_Head_Respond_PicData);
      Result := nRespond.FFlag = sFlag_OK;
      //结果判定
      
      if not Result then
      begin
        nStr := '第[ %d ]幕数据已成功发送,但下位机处理异常!!';
        StrPCopy(nMsg, Format(nStr, [nIdx])); Break;
      end;
    except
      nStr := '发送第[ %d ]幕数据时发生错误!!';
      StrPCopy(nMsg, Format(nStr, [nIdx])); Break;
    end;
  finally
    for nIdx:=Low(nBuf) to High(nBuf) do
      nBuf[nIdx].Free;
    //xxxxx
  end;
end;

//Date: 2010-7-20
//Parm: [out]提示信息
//Desc: 关闭传输
function TransEnd(const nMsg: PChar): Boolean;
var nStr: string;
    nSend: THead_Send_DataEnd;
    nRespond: THead_Respond_DataEnd;
begin
  Result := False;
  FillChar(nSend, cSize_Head_Send_DataEnd, #0);

  nSend.FHead := Swap(cHead_DataSend);
  nSend.FLen := Swap(cSize_Head_Send_DataEnd);
  nSend.FCardType := gCardItem.FCardType;
  nSend.FCommand := cCmd_DataEnd;
  nSend.FDevice := sFlag_BroadCast;

  with FDM do
  try
    FWaitCommand := nSend.FCommand;
    CPort1.ClearBuffer(True, True);
    Result := CPort1.Write(@nSend, cSize_Head_Send_DataEnd) =
                                   cSize_Head_Send_DataEnd;
    //xxxxx

    if not Result then
    begin
      nStr := '"结束帧"数据发送失败,无法关闭传输模式!!';
      StrPCopy(nMsg, nStr); Exit;
    end;

    Result := WaitForTimeOut(nStr);
    if not Result then
    begin
      nStr := '等待"结束帧"响应超时,无法关闭传输模式!!';
      StrPCopy(nMsg, nStr); Exit;
    end;

    Move(FDM.FValidBuffer[0], nRespond, cSize_Head_Respond_DataEnd);
    Result := nRespond.FFlag = sFlag_OK;

    if Result then
    begin
      nStr := '关闭传输模式,数据发送完毕!';
      StrPCopy(nMsg, nStr);
    end else
    begin
      nStr := '"结束帧"发送成功,但下位机关闭传输模式失败!!';
      StrPCopy(nMsg, nStr);
    end;
  except
    StrPCopy(nMsg, '无法关闭传输模式');
  end;
end;

//------------------------------------------------------------------------------
procedure TFDM.DataModuleCreate(Sender: TObject);
begin
  //nothing
end;

procedure TFDM.DataModuleDestroy(Sender: TObject);
begin
  CPort1.Close;
end;

//Date: 2009-11-16
//Parm: 错误提示信息
//Desc: 重复进入等待,直到接收到有效数据
function TFDM.WaitForTimeOut(var nMsg: string): Boolean;
var nInit: Int64;
begin
  Result := False;
  nMsg := '与控制器通信超时';

  FWaitResult := False;
  nInit := GetTickCount;

  while GetTickCount - nInit < gSendInterval do
  begin
    Application.ProcessMessages;
    Result := FWaitResult;

    if Result then
         Break
    else Sleep(1);
  end;
end;

//Desc: 读取数据
procedure TFDM.CPort1RxChar(Sender: TObject; Count: Integer);
var nBuf: array of Char;
begin
  SetLength(nBuf, Count);
  CPort1.Read(@nBuf[0], Count);
  CommReceiveData(@nBuf[0], Count);
end;

//Date: 2010-7-21
//Parm: 数据;大小
//Desc: 处理受到的数据
procedure TFDM.CommReceiveData(const nBuf: PChar; const nBufLen: Word);
var nLen: integer;
    i,nCount: integer;
    nBase: THead_Respond_Base;
begin
  nLen := Length(FBuffer);
  SetLength(FBuffer, nLen + nBufLen);
  Move(nBuf^, FBuffer[nLen], nBufLen);

  nCount := High(FBuffer) - cSize_Respond_Base;
  //保留基本协议头的长度

  for i:=Low(FBuffer) to nCount do
  if (FBuffer[i] = cHead_DataRecv_Hi) and (FBuffer[i+1] = cHead_DataRecv_Low) then
  begin
    Move(FBuffer[i], nBase, cSize_Respond_Base);
    //取基本协议头

    case nBase.FCommand of
      cCmd_ConnCtrl:      //控制器链接
        nLen := cSize_Head_Respond_ConnCtrl;
      cCmd_SetDeviceNo:   //设置设备号
        nLen := cSize_Head_Respond_SetDeviceNo;
      cCmd_ResetCtrl:     //复位控制器
        nLen := cSize_Head_Respond_ResetCtrl;
      cCmd_SetBright:     //设置亮度
        nLen := cSize_Head_Respond_SetBright;
      cCmd_SetBrightTime: //时段亮度
        nLen := cSize_Head_Respond_SetBrightTime;
      cCmd_AdjustTime:    //校准时间
        nLen := cSize_Head_Respond_AdjustTime;
      cCmd_OpenOrClose:   //开关屏幕
        nLen := cSize_Head_Respond_OpenOrClose;
      cCmd_OCTime:        //开关时间
        nLen := cSize_Head_Respond_OCTime;
      cCmd_PlayDays:      //播放天数
        nLen := cSize_Head_Respond_PlayDays;
      cCmd_ReadStatus:    //读取状态
        nLen := cSize_Head_Respond_ReadStatus;
      cCmd_SetScreenWH:   //屏幕宽高
        nLen := cSize_Head_Respond_SetScreenWH;
      cCmd_DataBegin:     //起始帧
        nLen := cSize_Head_Respond_DataBegin;
      cCmd_DataEnd:       //结束帧
        nLen := cSize_Head_Respond_DataEnd;
      cCmd_SendPicData:   //图片数据
        nLen := cSize_Head_Respond_PicData;
      cCmd_SendSimuClock:   //模拟时钟
        nLen := cSize_Head_Respond_Clock;
      cCmd_SendAnimate:   //动画数据
        nLen := cSize_Head_Respond_Animate
      else
      begin               //无法识别指令
        SetLength(FBuffer, 0); Exit;
      end;
    end;

    if Length(FBuffer) - i >= nLen then
    begin
      if nBase.FCommand = FWaitCommand then
      begin
        FWaitCommand := -1;
        SetLength(FValidBuffer, nLen);

        Move(FBuffer[i], FValidBuffer[0], nLen);
        FWaitResult := True;
      end;

      SetLength(FBuffer, 0);
      Break;
    end;
  end;

  if nLen > 100 then
    SetLength(FBuffer, 0);
  //超长则清空
end;

initialization
  //FDM := TFDM.Create(nil);
  Application.CreateForm(TFDM, FDM);
finalization
  FDM.Free;
end.
