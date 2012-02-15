{*******************************************************************************
  作者: dmzn@163.com 2010-7-20
  描述: 常量定义
*******************************************************************************}
unit ULibConst;

interface

uses Graphics;

const
  cSendInterval_Long = 4200;
  cSendInterval_Short = 1000; //发送超时等待

//------------------------------------------------------------------------------  
type
  TDynamicByteArray = array of Byte;
  TByteData = array[0..7] of Byte;

  TByteInt = record
    FB1,FB2,FB3,FB4: Byte;
  end;

const
  cByteMask: TByteData = (128, 64, 32, 16, 8, 4, 2, 1);

type
  TDynamicBitmapArray = array of TBitmap;
  //图片数组

  PAreaRect = ^TAreaRect;
  TAreaRect = record
    FLeft: Word;
    FTop: Word;
    FWidth: Word;
    FHeight: Word;
  end; //组件区域

  PAreaMode = ^TAreaMode;
  TAreaMode = record
    FEnterMode: Byte;
    FEnterSpeed: Byte;
    FKeepTime: Byte;
    FExitMode: Byte;
    FExitSpeed: Byte;
    FModeSerial: Byte;
    FSingleColor: Byte;
  end; //区域特效

  PAreaFont = ^TAreaFont;
  TAreaFont = record
    FName: array[0..31] of Char;
    FSize: Word;
  end; //字体
  
var
  gSendInterval: Word = cSendInterval_Short; //发送超时

implementation

end.
