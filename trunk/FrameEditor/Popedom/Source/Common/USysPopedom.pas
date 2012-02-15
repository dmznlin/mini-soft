{*******************************************************************************
  作者: dmzn@ylsoft.com 2007-10-09
  描述: 权限管理器
*******************************************************************************}
unit USysPopedom;

interface

uses
  Classes, SysUtils, DB, UDataModule, UMgrPopedom, USysConst;

type
  TSysPopedom = class(TBasePopedomManager)
  protected
    function QuerySQL(const nSQL: string;
      var nDS: TDataSet; var nAutoFree: Boolean): Boolean; override;
    function ExecSQL(const nSQL: string): integer; override;

    function GetItemValue(const nItem: integer): string; override;
    function IsTableExists(const nTable: string): Boolean; override;
  end;

var
  gPopedomManager : TSysPopedom = nil;
  //全局权限管理

implementation

function TSysPopedom.ExecSQL(const nSQL: string): integer;
begin
  FDM.Command.Close;
  FDM.Command.SQL.Text := nSQL;
  Result := FDM.Command.ExecSQL;
end;

function TSysPopedom.GetItemValue(const nItem: integer): string;
begin
  case nItem of
    cPopedomTable_User    : Result := gSysParam.FTableUser;
    cPopedomTable_Group   : Result := gSysParam.FTableGroup;
    cPopedomTable_Popedom : Result := gSysParam.FTablePopedom;
    cPopedomTable_PopItem : Result := gSysParam.FTablePopItem;
  end;
end;

function TSysPopedom.IsTableExists(const nTable: string): Boolean;
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

function TSysPopedom.QuerySQL(const nSQL: string; var nDS: TDataSet;
  var nAutoFree: Boolean): Boolean;
begin
  FDM.SQLQuery.Close;
  FDM.SQLQuery.SQL.Text := nSQL;
  FDM.SQLQuery.Open;

  nDS := FDM.SQLQuery;
  Result := nDS.RecordCount > 0;
end;

initialization
  gPopedomManager := TSysPopedom.Create;
finalization
  FreeAndNil(gPopedomManager);
end.


