{*******************************************************************************
  作者: dmzn@163.com 2010-7-20
  描述: 库函数接口
*******************************************************************************}
unit ULibInterface;

interface

uses
  Windows, Classes, ULibConst;

const
  cLibDLL = 'HBLibrary.dll';

procedure CommPortInit(const nComm: PChar; const nBaudRate: DWORD); stdcall; external cLibDLL;
//初始化端口
function CommPortConn: Boolean; stdcall; external cLibDLL;
function CommPortClose: Boolean; stdcall; external cLibDLL;
//连接和关闭

procedure TransInit(const nCardType,nAreaNum,nInvert: Byte); stdcall; external cLibDLL;
//传输初始化
function TransBegin(const nMsg: PChar): Boolean; stdcall; external cLibDLL;
//传输开始
function TransData(const nRect: PAreaRect; const nMode: PAreaMode;
 const nFont: PAreaFont; const nText,nMsg: PChar): Boolean; stdcall; external cLibDLL;
//传输数据
function TransEnd(const nMsg: PChar): Boolean; stdcall; external cLibDLL;
//传输结束

implementation

end.
