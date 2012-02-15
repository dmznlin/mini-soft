unit UDataModule;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  TFDM = class(TDataModule)
    ADOConn: TADOConnection;
    SQLQuery: TADOQuery;
    SQLTemp: TADOQuery;
    Command: TADOQuery;
    DataSource1: TDataSource;
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
