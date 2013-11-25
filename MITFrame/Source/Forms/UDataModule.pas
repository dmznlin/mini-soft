{*******************************************************************************
  作者: dmzn@163.com 2013-11-19
  描述: 数据共享模块
*******************************************************************************}
unit UDataModule;

interface

uses
  SysUtils, Classes, ImgList, Controls, XPMan;

type
  TFDM = class(TDataModule)
    ImagesSmall: TImageList;
    ImagesBig: TImageList;
    XPMan1: TXPManifest;
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
