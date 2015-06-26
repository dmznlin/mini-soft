{*******************************************************************************
  ����: dmzn@163.com 2015-06-21
  ����: ϵͳҵ����
*******************************************************************************}
unit USysBusiness;

interface
{$I Link.inc}
uses
  Windows, DB, Classes, Controls, SysUtils, ULibFun, UFormCtrl, UDataModule,
  UDataReport, USysConst, USysDB, USysLoger;

function GetSerailID(const nGroup,nObject: string; nUseDate: Boolean): string;
//��ȡ����
function GetMemberValidMoney(const nMemberID: string;
 const nUserFreeze: Boolean = True): Double;
//��ȡ���ý�
function DeleteWashData(const nWashID: string): Boolean;
//ɾ��ϴ�¼�¼

implementation

//Desc: ��¼��־
procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(nEvent);
end;

//Date: 2012-3-25
//Desc: �������������б��
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
        nStr := 'û��[ %s.%s ]�ı�������.';
        nStr := Format(nStr, [nGroup, nObject]);

        FDM.ADOConn.RollbackTrans;
        raise Exception.Create(nStr);
      end;

      nP := FieldByName('B_Prefix').AsString;
      nB := FieldByName('B_Base').AsString;
      nInt := FieldByName('B_IDLen').AsInteger;

      if nUseDate then //�����ڱ���
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
//Parm: ��ԱID��;ʹ�ö����
//Desc: ��ȡnMemberID�Ŀ��ý�
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
      nStr := '��Ա[ %s ]������.';
      nStr := Format(nStr,  [nMemberID]);
      raise Exception.Create(nStr);
    end;

    Result := FieldByName('M_MoneyIn').AsFloat -
              FieldByName('M_MoneyOut').AsFloat;
    //��� = ��ֵ - ����

    if nUserFreeze then
      Result := Result + FieldByName('M_MoneyFreeze').AsFloat;
    Result := Float2Float(Result, cPercent, False);
  end;
end;

//Date: 2015-06-25
//Parm: ���¼�¼
//Desc: ɾ��ϴ�¼�¼
function DeleteWashData(const nWashID: string): Boolean;
begin

end;

end.
