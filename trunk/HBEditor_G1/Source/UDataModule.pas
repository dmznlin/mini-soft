{*******************************************************************************
  作者: dmzn@163.com 2010-8-31
  描述: 数据库或数据通讯
*******************************************************************************}
unit UDataModule;

interface

uses
  SysUtils, Classes, Types, dxSkinsCore, dxSkinsDefaultPainters, ImgList,
  Controls, CPort, XPMan, Graphics, UMgrLang, ULibFun, USysConst,
  cxLookAndFeels;

type
  TFDM = class(TDataModule)
    cxLF1: TcxLookAndFeelController;
    XP1: TXPManifest;
    ComPort1: TComPort;
    ImagesBase: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
    function ConnCard(var nNewConn: Boolean; var nHint: string): Boolean;
    {*连接卡*}
    function GetCardWH(var nWH: TPoint; var nHint: string;
      const nRespond: Boolean = False): Boolean;
    {*读取宽高*}
    function SendCardWH(const nWH: TPoint; var nHint: string): Boolean;
    {*设置宽高*}
    function SendClock(var nHint: string): Boolean;
    {*发送时钟*}
  end;

var
  FDM: TFDM;

function RegularInt(const nInt: Integer; const nLen: Integer): string;
//统一长度
function Hex2Normal(const nStr: string; const nLen: Integer = 2): string;
function HexStr(const nByte: Byte): string; overload;
function HexStr(const nStr: string): string; overload;
function HexStr(const nBytes: TDynamicByteArray): string; overload;
//十六进制字符串
procedure ScanWithSingleMode(const nBmp: TBitmap; const nBgColor: TColor;
 var nData: TDynamicByteArray; const nInvertScan: Boolean = False); overload;
function ScanWithSingleMode(const nBmp: TBitmap; const nBgColor: TColor;
 const nInvertScan: Boolean = False): string; overload;
//扫描图片

implementation

{$R *.dfm}

//------------------------------------------------------------------------------
//Desc: 将整数格式化定长,不足者前补0
function RegularInt(const nInt: Integer; const nLen: Integer): string;
begin
  Result := IntToStr(nInt);
  Result := StringOfChar('0', nLen - Length(Result)) + Result;
end;

//Desc: 字节转十六进制
function HexStr(const nByte: Byte): string;
const
  HexDigs: array [0..15] of char = '0123456789abcdef';
var nB1,nB2: Byte;
begin
  nB1 := nByte and $F;
  nB2 := nByte shr 4;
  Result:= HexDigs[nB2] + HexDigs[nB1];
end;

//Desc: 将nBytes转为十六进制字符串
function HexStr(const nBytes: TDynamicByteArray): string;
var nIdx: Integer;
begin
  Result := '';
  for nIdx:=Low(nBytes) to High(nBytes) do
    Result := Result + HexStr(nBytes[nIdx]);
  //xxxxx
end;

//Desc: 将nStr的数字内容转为十六进制内容
function HexStr(const nStr: string): string;
begin
  if IsNumber(nStr, False) then
       Result := HexStr(StrToInt(nStr))
  else Result := '';
end;

//Desc: 将十六进制nStr转为定长十进制
function Hex2Normal(const nStr: string; const nLen: Integer): string;
begin
  Result := '$' + nStr;
  if nLen < 1 then
       Result := IntToStr(StrToInt(Result))
  else Result := RegularInt(StrToInt(Result), nLen);
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
//------------------------------------------------------------------------------
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
procedure ScanWithSingleMode(const nBmp: TBitmap; const nBgColor: TColor;
 var nData: TDynamicByteArray; const nInvertScan: Boolean = False);
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
      if nBmp.Canvas.Pixels[nX, nY] = nBgColor then
           nBuf[nX + 1] := '1'
      else nBuf[nX + 1] := '0';

      if nInvertScan then
       if nBuf[nX + 1] = '0' then
            nBuf[nX + 1] := '1'
       else nBuf[nX + 1] := '0';
    end;

    MakeByteArray(nBuf, nBits);
    CombinByteArray(nBits, nData);
  end;
end;

//Desc: 将nBmp扫描为字符串数据
function ScanWithSingleMode(const nBmp: TBitmap; const nBgColor: TColor;
 const nInvertScan: Boolean = False): string;
var nData: TDynamicByteArray;
begin
  ScanWithSingleMode(nBmp, nBgColor, nData, nInvertScan);
  Result := HexStr(nData);
end;

//------------------------------------------------------------------------------
//Desc: 连接控制卡
function TFDM.ConnCard(var nNewConn: Boolean; var nHint: string): Boolean;
begin
  try
    nNewConn := ComPort1.Connected and (ComPort1.Port = gSysParam.FCOMMPort) and
       (ComPort1.BaudRate = StrToBaudRate(IntToStr(gSysParam.FCOMMBote)));
    nNewConn := not nNewConn;

    if nNewConn then
    begin
      ComPort1.Close;
      ComPort1.Port := gSysParam.FCOMMPort;
      ComPort1.BaudRate := StrToBaudRate(IntToStr(gSysParam.FCOMMBote));
      ComPort1.Open;
    end;

    nHint := '';
    Result := True;

    ComPort1.ClearBuffer(True, True);
    //清空缓冲,避免干扰
  except
    Result := False;
    nHint := ML('连接控制器失败', sMLCommon);
  end;
end;

//Date: 2010-9-5
//Parm: 宽高;是否响应下位机
//Desc: 读取下位机宽高
function TFDM.GetCardWH(var nWH: TPoint; var nHint: string;
  const nRespond: Boolean): Boolean;
var nStr: string;
    nBool: Boolean;
begin
  Result := False;
  nBool := False;
  try
    try
      if not ConnCard(nBool, nHint) then Exit;

      ComPort1.Write('F', 1);
      if (ComPort1.ReadStr(nStr, 3) <> 3) or (nStr[1] <> 'F') then
      begin
        nHint := '本次连接失败'#13'请重新确认连线及电源'; Exit;
      end else nHint := '读取屏幕参数成功';

      nWH.X := Ord(nStr[3]) * 8;
      nWH.Y := Ord(nStr[2]) * 8;

      if not nRespond then
      begin
        Result := True; Exit;
      end;

      //------------------------------------------------------------------------
      if (nWH.X <> gSysParam.FScreenWidth) or (nWH.Y <> gSysParam.FScreenHeight) then
      begin
        nHint := '上位机与卡屏幕尺寸不符'; Exit;
      end;

      ComPort1.ClearBuffer(True, False);
      //清空输入缓冲,避免多余字符干扰

      ComPort1.Write('L', 1);
      Sleep(120);
      //等待下位机处理

      if (ComPort1.ReadStr(nStr, 1) <> 1) or (nStr[1] <> 'L') then
      begin
        nHint := '读取参数同步数据错误'; Exit;
      end;

      Result := True;
    except
      nHint := '与控制器通信错误';
    end;  
  finally
    if nHint <> '' then
      nHint := ML(nHint, sMLCommon);
    //xxxxx

    if nBool then
      ComPort1.Close;
    //xxxxx
  end;
end;

//Desc: 发送时钟数据
function TFDM.SendClock(var nHint: string): Boolean;
var nStr: string;
    nLen: Integer;
    nBool: Boolean;
begin
  Result := False;
  nBool := False;
  try
    try
      if not ConnCard(nBool, nHint) then Exit;

      with gSysParam do
       nStr := FClockChar + FClockMode + FClockPos + FClockYear + FClockMonth +
               FClockDay + FClockWeek + FClockTime + FClockSYear + FClockSMonth +
               FClockSDay + FClockSHour + FClockSMin + FClockSSec + FClockSWeek;
      //时间结构

      nStr := 'R' + nStr + 'Q';
      nLen := Length(nStr);

      if ComPort1.Write(PChar(nStr), nLen) <> nLen then
      begin
        nHint := '时钟数据发送失败'; Exit;
      end;

      if gSysParam.FEnablePD then
      begin
        nStr := 'U' + gSysParam.FPlayDays;
        ComPort1.Write(PChar(nStr), Length(nStr));
      end;

      Result := True;
      nHint := '时钟同步成功';
    except
      nHint := '与控制器通信错误';
    end;  
  finally
    if nHint <> '' then
      nHint := ML(nHint, sMLCommon);
    //xxxxx

    if nBool then
      ComPort1.Close;
    //xxxxx
  end;
end;

//Desc: 设置宽高
function TFDM.SendCardWH(const nWH: TPoint; var nHint: string): Boolean;
var nStr: string;
    nBool: Boolean;
begin
  nHint := '';
  Result := False;

  nBool := True;
  try
    try
      if not ConnCard(nBool, nHint) then Exit;

       nHint := '屏幕宽高无法保存';
      ComPort1.Write('S', 1);
      if (ComPort1.ReadStr(nStr, 1) <> 1) or (nStr <> 'S') then Exit;

      nStr := HexStr(Trunc(nWH.X / 8)) + HexStr(nWH.Y) + 'W';
      ComPort1.Write(PChar(nStr), Length(nStr)); 
      if (ComPort1.ReadStr(nStr, 1) <> 1) or (nStr <> 'W') then Exit;

      Result := True;
      nHint := '屏幕宽高成功保存';
    except
      nHint := '与控制器通信错误';
    end;  
  finally
    if nHint <> '' then
      nHint := ML(nHint, sMLCommon);
    //xxxxx

    if nBool then
      ComPort1.Close;
    //xxxxx
  end;
end;

end.
