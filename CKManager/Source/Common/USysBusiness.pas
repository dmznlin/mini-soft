{*******************************************************************************
  作者: dmzn@163.com 2010-3-8
  描述: 系统业务处理
*******************************************************************************}
unit USysBusiness;

interface

uses
  Windows, Classes, Controls, SysUtils, ULibFun, UAdjustForm, UFormCtrl, DB,
  UDataModule, USysDB;

function AdjustHintToRead(const nHint: string): string;
//调整提示内容

function LoadItemExtInfo(const nInfo: TStrings; const nFlag,nID: string;
 const nDelimiter: string = ';'): Boolean;
//读取扩展信息
function SaveItemExtInfo(const nInfo: TStrings; const nFlag,nID: string;
 const nClearFirst: Boolean = False; const nDelimiter: string = ';'): Boolean;
//保存扩展信息

function IsWeekValid(const nWeek: string; var nHint: string): Boolean;
//周期是否有效
function IsWeekHasEnable(const nWeek: string): Boolean;
//周期是否启用
function IsNextWeekEnable(const nWeek: string): Boolean;
//下一周期是否启用
function IsPreWeekOver(const nWeek: string): Integer;
//上一周期是否结束

implementation

//Desc: 调整nHint为易读的格式
function AdjustHintToRead(const nHint: string): string;
var nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    nList.Text := nHint;
    for nIdx:=0 to nList.Count - 1 do
      nList[nIdx] := '※.' + nList[nIdx];
    Result := nList.Text;
  finally
    nList.Free;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2011-6-11
//Parm: 信息项;分类标识;记录标识;信息分隔符
//Desc: 读取nFlag.nID的扩展信息,放入nInfo中
function LoadItemExtInfo(const nInfo: TStrings; const nFlag,nID: string;
 const nDelimiter: string = ';'): Boolean;
var nStr: string;
begin
  nInfo.Clear;
  nStr := MacroValue(sQuery_ExtInfo, [MI('$Table', sTable_ExtInfo),
                     MI('$Group', nFlag), MI('$ID', nID)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := FieldByName('I_Item').AsString + nDelimiter +
              FieldByName('I_Info').AsString;
      nInfo.Add(nStr);
        
      Next;
    end;
  end;

  Result := nInfo.Count > 0;
end;

//Date: 2011-6-11
//Parm: 信息项;分类标识;记录标识;是否先清理;信息分隔符
//Desc: 存放nFlag.nID的扩展信息nInfo
function SaveItemExtInfo(const nInfo: TStrings; const nFlag,nID: string;
 const nClearFirst: Boolean; const nDelimiter: string): Boolean;
var nBool: Boolean;
    i,nCount,nPos: integer;
    nStr,nSQL,nTmp: string;
begin
  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    if nClearFirst then
    begin
      nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
      nSQL := Format(nSQL, [sTable_ExtInfo, nFlag, nID]);
      FDM.ExecuteSQL(nSQL);
    end;

    nCount := nInfo.Count - 1;
    for i:=0 to nCount do
    begin
      nStr := nInfo[i];
      nPos := Pos(nDelimiter, nStr);

      nTmp := Copy(nStr, 1, nPos - 1);
      System.Delete(nStr, 1, nPos + Length(nDelimiter) - 1);

      nSQL := 'Insert Into %s(I_Group, I_ItemID, I_Item, I_Info) ' +
              'Values(''%s'', ''%s'', ''%s'', ''%s'')';
      nSQL := Format(nSQL, [sTable_ExtInfo, nFlag, nID, nTmp, nStr]);
      FDM.ExecuteSQL(nSQL);
    end;

    if not nBool then
      FDM.ADOConn.CommitTrans;
    Result := True;
  except
    if not nBool then
      FDM.ADOConn.RollbackTrans;
    Result := False;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 检测nWeek是否存在或过期
function IsWeekValid(const nWeek: string; var nHint: string): Boolean;
var nStr: string;
begin
  nStr := 'Select W_End,$Now From $W Where W_NO=''$NO''';
  nStr := MacroValue(nStr, [MI('$W', sTable_Weeks),
          MI('$Now', FDM.SQLServerNow), MI('$NO', nWeek)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsDateTime + 1 > Fields[1].AsDateTime;
    if not Result then
      nHint := '该周期已结束';
    //xxxxx
  end else
  begin
    Result := False;
    nHint := '该周期已无效';
  end;
end;

//Desc: 检查nWeek是否已开始
function IsWeekHasEnable(const nWeek: string): Boolean;
var nStr: string;
begin
  nStr := 'Select Top 1 * From $PL Where P_Week=''$NO''';
  nStr := MacroValue(nStr, [MI('$PL', sTable_BuyPlan), MI('$NO', nWeek)]);
  Result := FDM.QueryTemp(nStr).RecordCount > 0;
end;

//Desc: 检测nWeek后面的周期是否已开始
function IsNextWeekEnable(const nWeek: string): Boolean;
var nStr: string;
begin
  nStr := 'Select Top 1 * From $PL Where P_Week In ' +
          '( Select W_NO From $W Where W_Begin > (' +
          '  Select Top 1 W_Begin From $W Where W_NO=''$NO''))';
  nStr := MacroValue(nStr, [MI('$PL', sTable_BuyPlan),
          MI('$W', sTable_Weeks), MI('$NO', nWeek)]);
  Result := FDM.QueryTemp(nStr).RecordCount > 0;
end;

//Desc: 检测nWee前面的周期是否已完成
function IsPreWeekOver(const nWeek: string): Integer;
var nStr: string;
begin
  nStr := 'Select Count(*) From $Req Where (R_ReqValue<>R_KValue) And ' +
          '(R_Week In ( Select W_NO From $W Where W_Begin < (' +
          '  Select Top 1 W_Begin From $W Where W_NO=''$NO'')))';
  nStr := MacroValue(nStr, [MI('$Req', sTable_BuyReq),
          MI('$W', sTable_Weeks), MI('$NO', nWeek)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsInteger
  else Result := 0;
end;

end.
