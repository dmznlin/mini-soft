{*******************************************************************************
  作者: dmzn@163.com 2015-06-21
  描述: 系统业务处理
*******************************************************************************}
unit USysBusiness;

interface
{$I Link.inc}
uses
  Windows, DB, Classes, Controls, SysUtils, ULibFun, UFormCtrl, UDataModule,
  UDataReport, USysConst, USysDB, USysLoger;

function GetSerailID(const nGroup,nObject: string; nUseDate: Boolean): string;
//获取串号
function GetMemberValidMoney(const nMemberID: string;
 const nUserFreeze: Boolean = True): Double;
//获取可用金
function DeleteWashData(const nWashID: string): Boolean;
//删除洗衣记录

implementation

//Desc: 记录日志
procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(nEvent);
end;

//Date: 2012-3-25
//Desc: 按规则生成序列编号
function GetSerailID(const nGroup,nObject: string; nUseDate: Boolean): string;
var nInt: Integer;
    nStr,nP,nB: string;
begin
  FDM.ADOConn.BeginTrans;
  try
    nStr := 'Update %s Set B_Base=B_Base+1 ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sTable_SerialBase, nGroup, nObject]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Select B_Prefix,B_IDLen,B_Base,B_Date,%s as B_Now From %s ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sField_SQLServer_Now, sTable_SerialBase,
            nGroup, nObject]);
    //xxxxx

    with FDM.QuerySQL(nStr) do
    begin
      if RecordCount < 1 then
      begin
        nStr := '没有[ %s.%s ]的编码配置.';
        nStr := Format(nStr, [nGroup, nObject]);

        FDM.ADOConn.RollbackTrans;
        raise Exception.Create(nStr);
      end;

      nP := FieldByName('B_Prefix').AsString;
      nB := FieldByName('B_Base').AsString;
      nInt := FieldByName('B_IDLen').AsInteger;

      if nUseDate then //按日期编码
      begin
        nStr := Date2Str(FieldByName('B_Date').AsDateTime, False);
        //old date

        if (nStr <> Date2Str(FieldByName('B_Now').AsDateTime, False)) and
           (FieldByName('B_Now').AsDateTime > FieldByName('B_Date').AsDateTime) then
        begin
          nStr := 'Update %s Set B_Base=1,B_Date=%s ' +
                  'Where B_Group=''%s'' And B_Object=''%s''';
          nStr := Format(nStr, [sTable_SerialBase, sField_SQLServer_Now,
                  nGroup, nObject]);
          FDM.ExecuteSQL(nStr);

          nB := '1';
          nStr := Date2Str(FieldByName('B_Now').AsDateTime, False);
          //now date
        end;

        System.Delete(nStr, 1, 2);
        //yymmdd
        nInt := nInt - Length(nP) - Length(nStr) - Length(nB);
        Result := nP + nStr + StringOfChar('0', nInt) + nB;
      end else
      begin
        nInt := nInt - Length(nP) - Length(nB);
        nStr := StringOfChar('0', nInt);
        Result := nP + nStr + nB;
      end;
    end;

    FDM.ADOConn.CommitTrans;
  except
    FDM.ADOConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2015-06-23
//Parm: 会员ID号;使用冻结金
//Desc: 获取nMemberID的可用金
function GetMemberValidMoney(const nMemberID: string;
 const nUserFreeze: Boolean): Double;
var nStr: string;
begin
  nStr := 'Select * From %s Where M_ID=''%s''';
  nStr := Format(nStr, [sTable_Member, nMemberID]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then
    begin
      nStr := '会员[ %s ]不存在.';
      nStr := Format(nStr,  [nMemberID]);
      raise Exception.Create(nStr);
    end;

    Result := FieldByName('M_MoneyIn').AsFloat -
              FieldByName('M_MoneyOut').AsFloat;
    //余额 = 充值 - 消费

    if nUserFreeze then
      Result := Result + FieldByName('M_MoneyFreeze').AsFloat;
    Result := Float2Float(Result, cPercent, False);
  end;
end;

//Date: 2015-06-25
//Parm: 收衣记录
//Desc: 删除洗衣记录
function DeleteWashData(const nWashID: string): Boolean;
begin

end;

end.
