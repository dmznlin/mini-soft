{*******************************************************************************
  作者: dmzn@163.com 2013-11-24
  描述: 参数管理界面
*******************************************************************************}
unit UFrameParam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UMgrControl, UPlugWorker, UFrameBase, Grids, ValEdit, UZnValueList;

type
  TfFrameParam = class(TfFrameBase)
    ListParam: TZnValueList;
  private
    { Private declarations }
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UPlugConst;

class function TfFrameParam.FrameID: integer;
begin
  Result := cFI_FrameParam;
end;

initialization
  gControlManager.RegCtrl(TfFrameParam, TfFrameParam.FrameID,
                          TPlugWorker.ModuleInfo.FModuleID);
  //reg ui
end.
