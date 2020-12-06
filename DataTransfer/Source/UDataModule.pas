{*******************************************************************************
  作者: dmzn@163.com 2020-12-06
  描述: 数据模块
*******************************************************************************}
unit UDataModule;

{$I Link.inc}

interface

uses
  Windows, SysUtils, Classes, SyncObjs, UWaitItem, ULibFun;

type
  TFDM = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FDM: TFDM;

implementation

{$R *.dfm}

end.
