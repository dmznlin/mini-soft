{*******************************************************************************
  作者: dmzn@163.com 2007-11-08
  描述: 数据模块 
*******************************************************************************}
unit Menu_DM;

interface

uses
  SysUtils, Classes, DB, ADODB, ImgList, Controls;

type
  TFDM = class(TDataModule)
    Connection1: TADOConnection;
    SQLQuery: TADOQuery;
    SQLCmd: TADOQuery;
    SQLTemp: TADOQuery;
    ImageList1: TImageList;
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
