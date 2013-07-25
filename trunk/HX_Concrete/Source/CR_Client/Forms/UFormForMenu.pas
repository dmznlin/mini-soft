{*******************************************************************************
  作者: dmzn@163.com 2013-07-10
  描述: 业务菜单调用入口.

  备注:
  *.由于框架的菜单调用必须是窗体或Frame,不支持函数相应.所以对于无窗体业务,需要
    该窗口的CreateForm调度.
*******************************************************************************}
unit UFormForMenu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormBase;

type
  TfFormForMenu = class(TBaseForm)
  private
    { Private declarations }
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UFormWait, USysBusiness, USysConst;

class function TfFormForMenu.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nCard: string;
    nBool: Boolean;
begin
  Result := nil;
  if nPopedom = 'MAIN_D01' then
    nCard := '进站业务'
  else if nPopedom = 'MAIN_D02' then
    nCard := '出站业务'
  else if nPopedom = 'MAIN_D04' then
    nCard := '司机刷卡';
  //xxxxx

  nCard := GetTruckCard(nCard);
  if nCard = '' then Exit;

  ShowWaitForm(Application.MainForm, '处理业务', True);
  try
    if nPopedom = 'MAIN_D01' then
      nBool := MakeTruckIn(nCard)
    else if nPopedom = 'MAIN_D02' then
      nBool := MakeTruckOut(nCard)
    else if nPopedom = 'MAIN_D04' then
      nBool := MakeTruckResponse(nCard) else nBool := False;
  finally
    CloseWaitForm;
  end;

  if nBool then
    ShowMsg('操作成功', sHint);
  //xxxxx
end;

class function TfFormForMenu.FormID: integer;
begin
  Result := cFI_FormBusiness;
end;

initialization
  gControlManager.RegCtrl(TfFormForMenu, TfFormForMenu.FormID);
finalization

end.
