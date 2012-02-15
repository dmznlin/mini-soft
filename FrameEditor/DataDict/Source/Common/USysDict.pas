{*******************************************************************************
  作者: dmzn 2008-8-27
  描述: 字典编辑器
*******************************************************************************}
unit USysDict;

interface

uses
  Windows, Classes, DB, SysUtils, UMgrDataDict, UDataModule,
  USysConst;

type
  TSysEntityManager = class(TBaseEntityManager)
  protected
    function QuerySQL(const nSQL: string;
      var nDS: TDataSet; var nAutoFree: Boolean): Boolean; override;
    function ExecSQL(const nSQL: string): integer; override;

    function GetItemValue(const nItem: integer): string; override;
    function IsTableExists(const nTable: string): Boolean; override;
  end;

var
  gSysEntityManager: TSysEntityManager = nil;
  //全局使用

implementation

function TSysEntityManager.ExecSQL(const nSQL: string): integer;
begin
  FDM.Command.Close;
  FDM.Command.SQL.Text := nSQL;
  Result := FDM.Command.ExecSQL;
end;

function TSysEntityManager.GetItemValue(const nItem: integer): string;
begin
  case nItem of
    cDictTable_Entity    : Result := gSysParam.FTableEntity;
    cDictTable_DataDict  : Result := gSysParam.FTableDict;
  end;
end;

function TSysEntityManager.IsTableExists(const nTable: string): Boolean;
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

function TSysEntityManager.QuerySQL(const nSQL: string; var nDS: TDataSet;
  var nAutoFree: Boolean): Boolean;
begin
  FDM.SQLQuery.Close;
  FDM.SQLQuery.SQL.Text := nSQL;
  FDM.SQLQuery.Open;

  nDS := FDM.SQLQuery;
  Result := nDS.RecordCount > 0;
end;

initialization
  gSysEntityManager := TSysEntityManager.Create;
finalization
  FreeAndNil(gSysEntityManager);
end.
