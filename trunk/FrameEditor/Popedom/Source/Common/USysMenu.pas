{*******************************************************************************
  作者: dmzn@ylsoft.com 2007-11-20
  描述: 监控系统菜单管理单元

  约定:
  &.TMenuItemData.FFlag
   1.该标记用来设定菜单项的一些行为,它包括用"|"来分割的一组标识.
   2.NB:标识该菜单项显示在Navbar导航栏上
*******************************************************************************}
unit USysMenu;

interface

uses
  Windows, Classes, DB, SysUtils, UMgrMenu, ULibFun, USysConst, USysPopedom,
  UDataModule;

const
  cMenuFlag_SS   = '|';        //分割符,Split Symbol
  cMenuFlag_NB   = 'NB';       //显示在导航栏上,Navbar
  cMenuFlag_NSS  = '_';        //分隔符,Name Split Symbol

type
  TMenuManager = class(TBaseMenuManager)
  protected
    function QuerySQL(const nSQL: string;
      var nDS: TDataSet; var nAutoFree: Boolean): Boolean; override;
    {*查询*}
    function ExecSQL(const nSQL: string): integer; override;
    {*执行写操作*}

    function GetItemValue(const nItem: integer): string; override;
    function IsTableExists(const nTable: string): Boolean; override;
    {*查询表*}
  public
    function MenuName(const nEntity,nMenuID: string): string;
    {*构建菜单名*}
  end;

var
  gMenuManager: TMenuManager = nil;
  //全局菜单管理器

implementation

//------------------------------------------------------------------------------
//Desc: 执行SQL语句
function TMenuManager.ExecSQL(const nSQL: string): integer;
begin
  FDM.Command.Close;
  FDM.Command.SQL.Text := nSQL;
  Result := FDM.Command.ExecSQL;
end;

//Desc: 检测nTable表是否存在
function TMenuManager.IsTableExists(const nTable: string): Boolean;
var nList: TStrings;
begin
  nList := TStringList.Create;
  try
    FDM.ADOConn.GetTableNames(nList);
    Result := nList.IndexOf(nTable) > -1;
  finally
    nList.Free;
  end;
end;

//Desc: 执行SQL查询
function TMenuManager.QuerySQL(const nSQL: string; var nDS: TDataSet;
  var nAutoFree: Boolean): Boolean;
begin
  FDM.SQLQuery.Close;
  FDM.SQLQuery.SQL.Text := nSQL;
  FDM.SQLQuery.Open;

  nDS := FDM.SQLQuery;
  Result := nDS.RecordCount > 0;
end;

//Desc: 构建实体nEntity中nMenuID菜单项的组建名称
function TMenuManager.MenuName(const nEntity, nMenuID: string): string;
begin
  Result := nEntity + cMenuFlag_NSS + nMenuID;
end;

function TMenuManager.GetItemValue(const nItem: integer): string;
begin
  Result := gSysParam.FTableMenu;
end;

initialization
  gMenuManager := TMenuManager.Create;
finalization
  FreeAndNil(gMenuManager);
end.
