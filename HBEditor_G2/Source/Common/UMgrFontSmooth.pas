{*******************************************************************************
  作者: dmzn@163.com 2010-06-25
  描述: 开启/关闭系统"平滑字体边缘"功能
*******************************************************************************}
unit UMgrFontSmooth;

interface

uses
  Windows, Classes, Messages, Registry, SysUtils;

type
  TSmoothFontSwitch = class
  private
    FInitSmooth: Boolean;
    //系统状态
    function DoSmooth(const nOpen: Boolean): Boolean;
    //执行操作
  public
    constructor Create;
    destructor Destroy; override;
    function OpenSmooth: Boolean;
    function CloseSmooth: Boolean;
  end;

var
  gSmoothSwitcher: TSmoothFontSwitch = nil;
  //全局使用

implementation

//Desc: 创建
constructor TSmoothFontSwitch.Create;
begin
  SystemParametersInfo(SPI_GETFONTSMOOTHING, 0, @FInitSmooth, 0);
end;

//Desc: 释放
destructor TSmoothFontSwitch.Destroy;
begin
  OpenSmooth;
  inherited;
end;

//Desc: 启用或关闭平滑显示
function TSmoothFontSwitch.DoSmooth(const nOpen: Boolean): Boolean;
begin
  if (not nOpen) or FInitSmooth then
       Result := SystemParametersInfo(SPI_SETFONTSMOOTHING, Byte(nOpen), nil, SPIF_UPDATEINIFILE)
  else Result := False;
end;

//Desc: 启用平滑显示
function TSmoothFontSwitch.OpenSmooth: Boolean;
begin
  Result := DoSmooth(True);
end;

//Desc: 关闭平滑显示
function TSmoothFontSwitch.CloseSmooth: Boolean;
begin
  Result := DoSmooth(False);
end;

initialization
  gSmoothSwitcher := TSmoothFontSwitch.Create;
finalization
  FreeAndNil(gSmoothSwitcher);
end.
