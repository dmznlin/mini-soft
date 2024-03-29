{*******************************************************************************
  作者: dmzn@163.com 2020-12-20
  描述: 通讯协议定义
*******************************************************************************}
unit UProtocol;

interface

uses
  Windows, Classes, SysUtils, IdGlobal, ULibFun;
  
const
  cFrame_Begin  = Char($FF) + Char($FF) + Char($FF);  //帧头
  cFrame_End    = Char($FE);                          //帧尾

  {*功能码*}
  cFrame_CMD_UpData       = $01;              //数据上传
  cFrame_CMD_QueryData    = $02;              //数据查询

  {*扩展码*}
  cFrame_Ext_RunData      = $01;              //运行状态数据
  cFrame_Ext_RunParam     = $01;              //运行参数数据
  
type
  TValFloat = array[0..3] of Char;            //浮点值
  THexFloat = record                          //IEEE754浮点值转换
    case Byte of
      0: (AsHex: TValFloat);
      1: (AsFloat: Single);
  end;

  PFrameData = ^TFrameData;
  TFrameData = packed record
    FHeader     : array[0..2] of Char;        //帧头
    FStation    : Word;                       //设备ID
    FCommand    : Byte;                       //功能码
    FExtCMD     : Byte;                       //扩展码
    FDataLen    : Byte;                       //数据长度
    FData       : array[0..255] of Char;      //数据
    FEnd        : Char;                       //帧尾
  end;

  PRunData = ^TRunData;
  TRunData = packed record
    I00         : Byte;                       //断电
    I01         : Byte;                       //开到位
    I02         : Byte;                       //关到位
    VD300       : TValFloat;                  //瞬时流量
    VD304       : TValFloat;                  //温度
    VD308       : TValFloat;                  //压力
    VD312       : TValFloat;                  //累计流量
    VD316       : TValFloat;                  //压差
    VD320       : TValFloat;                  //热量
    VD324       : TValFloat;                  //累计热量
    VD328       : TValFloat;                  //温度高限设定
    VD332       : TValFloat;                  //温度低限设定
    VD336       : TValFloat;                  //压力高限设定
    VD340       : TValFloat;                  //压力低限设定
    VD348       : TValFloat;                  //单价
    VD352       : TValFloat;                  //余额
    VD356       : TValFloat;                  //余额低设定
    V3650       : Byte;                       //阀门自动
    V3651       : Byte;                       //温度高报警
    V3652       : Byte;                       //温度低报警
    V3653       : Byte;                       //压力高报警
    V3654       : Byte;                       //压力低报警
    V3655       : Byte;                       //总报警
    V3656       : Byte;                       //余额低报警
    V3657       : Byte;                       //开阀无流量报警
    V20000      : Byte;                       //手动开阀
    V20001      : Byte;                       //手动关阀
    V20002      : Byte;                       //阀门中停
  end;

  PRunParams = ^TRunParams;
  TRunParams = packed record
    VD328       : TValFloat;                  //温度高限设定
    VD332       : TValFloat;                  //温度低限设定
    VD336       : TValFloat;                  //压力高限设定
    VD340       : TValFloat;                  //压力低限设定
    VD348       : TValFloat;                  //单价
    VD352       : TValFloat;                  //余额
    VD356       : TValFloat;                  //余额低设定
    V3650       : Byte;                       //阀门自动
    V20000      : Byte;                       //手动开阀
    V20001      : Byte;                       //手动关阀
    V20002      : Byte;                       //阀门中停
  end;

const
  cSize_Frame_All         = SizeOf(TFrameData);
  cSize_Frame_RunData     = SizeOf(TRunData);
  cSize_Frame_RunParams   = SizeOf(TRunParams);
  cSize_Record_ValFloat   = SizeOf(TValFloat);

const
  sTable_RunData          = 'D_RunData';
  sTable_RunParams        = 'D_RunParams';

function SwapWordHL(const nVal: Word): Word;
//双字节
procedure PutValFloat(const nVal: Single; var nFloat: TValFloat);
function GetValFloat(const nFloat: TValFloat): Single;
//转换浮点数
procedure InitFrameData(var nData: TFrameData);
procedure InitRunData(var nData: TRunData);
procedure InitRunParams(var nData: TRunParams);
//初始化数据
function FrameValidLen(const nData: PFrameData): Integer;
function BuildRunData(const nFrame: PFrameData; const nRun: PRunData): TIdBytes;
function BuildRunParams(const nFrame: PFrameData; const nParams: PRunParams): TIdBytes;
//构建发送缓冲

implementation

//Date: 2020-12-23
//Desc: 交换Word值的高低字节
function SwapWordHL(const nVal: Word): Word;
var nL,nH: Byte;
begin
  nL := Lo(nVal);
  nH := Hi(nVal);
  Result := MakeWord(nH, nL);
end;

//Date: 2020-12-23
//Parm: 4字节浮点数
//Desc: 交换nFloat的高低字节
procedure SwapFloatHL(var nFloat: TValFloat);
var nCH: Char;
    nL,nH: Integer;
begin
  nL := Low(nFloat);
  nH := High(nFloat);
  
  while nL < nH do
  begin
    nCH := nFloat[nL];
    nFloat[nL] := nFloat[nH];
    nFloat[nH] := nCH;

    Inc(nL);
    Dec(nH);
  end;
end;

//Date: 2020-12-20
//Parm: 浮点值;浮点结构
//Desc: 将nVal存入nFloat中
procedure PutValFloat(const nVal: Single; var nFloat: TValFloat);
var nHF: THexFloat;
begin
  nHF.AsFloat := nVal;
  nFloat := nHF.AsHex;
  SwapFloatHL(nFloat);
end;

//Date: 2020-12-20
//Parm: 浮点结构
//Desc: 计算nFloat的值
function GetValFloat(const nFloat: TValFloat): Single;
var nHF: THexFloat;
begin
  nHF.AsHex := nFloat;
  SwapFloatHL(nHF.AsHex);
  Result := nHF.AsFloat;
end;

//Date: 2020-12-20
//Parm: 帧数据
//Desc: 初始化nData
procedure InitFrameData(var nData: TFrameData);
begin
  FillChar(nData, cSize_Frame_All, #0);
  with nData do
  begin
    FHeader := cFrame_Begin;
    FEnd    := cFrame_End;
  end;
end;

procedure InitRunData(var nData: TRunData);
var nInit: TRunData;
begin
  FillChar(nInit, cSize_Frame_RunData, #0);
  nData := nInit;
end;

procedure InitRunParams(var nData: TRunParams);
var nInit: TRunParams;
begin
  FillChar(nInit, cSize_Frame_RunParams, #0);
  nData := nInit;
end;

//Date: 2020-12-20
//Parm: 帧数据
//Desc: 计算nData的有效数据大小
function FrameValidLen(const nData: PFrameData): Integer;
begin
  Result := 5 + 3 + nData.FDataLen + 1;
end;

//Date: 2020-12-20
//Parm: 帧数据;运行数据
//Desc: 将nFrame + nRun打包为发送缓冲
function BuildRunData(const nFrame: PFrameData; const nRun: PRunData): TIdBytes;
begin
  Move(nRun^, nFrame.FData[0], cSize_Frame_RunData);
  //合并进数据区

  nFrame.FData[cSize_Frame_RunData] := cFrame_End;
  //补帧尾

  nFrame.FDataLen := cSize_Frame_RunData;
  Result := RawToBytes(nFrame^, FrameValidLen(nFrame));
end;

//Date: 2020-12-20
//Parm: 帧数据;运行参数
//Desc: 将nFrame + nParams打包为发送缓冲
function BuildRunParams(const nFrame: PFrameData; const nParams: PRunParams): TIdBytes;
begin
  Move(nParams^, nFrame.FData[0], cSize_Frame_RunParams);
  //合并进数据区

  nFrame.FData[cSize_Frame_RunParams] := cFrame_End;
  //补帧尾

  nFrame.FDataLen := cSize_Frame_RunParams;
  Result := RawToBytes(nFrame^, FrameValidLen(nFrame));
end;

end.
