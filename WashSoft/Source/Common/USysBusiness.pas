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

procedure LoadBaseInfoByGroup(const nGroup: string; const nList: TStrings;
 const nClearFirt: Boolean = True);
procedure SaveBaseInfoByGroup(const nGroup,nItem: string;
 const nDel: Boolean = False);
//������Ϣ
function GetSerailID(const nGroup,nObject: string; nUseDate: Boolean): string;
//��ȡ����
function GetMemberValidMoney(const nMemberID: string;
 const nUserFreeze: Boolean = True): Double;
//��ȡ���ý�
function DeleteWashData(const nWashID: string): Boolean;
//ɾ��ϴ�¼�¼

//------------------------------------------------------------------------------
function PrintMemberMoney(const nMID: string; const nAsk: Boolean): Boolean;
function PrintMemberInMoney(const nRID: string; const nAsk: Boolean): Boolean;
//��ӡ��Ա�ʽ�
function PrintWashData(const nID: string; const nAsk: Boolean): Boolean;
//��ӡϴ������

implementation

//Desc: ��¼��־
procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(nEvent);
end;

//Date: 2015-06-28
//Parm: ����;�б�
//Desc: ����nGroup����Ϣ��nList��
procedure LoadBaseInfoByGroup(const nGroup: string; const nList: TStrings;
 const nClearFirt: Boolean);
var nStr: string;
begin
  if nClearFirt then
    nList.Clear;
  //xxxxx

  nStr := 'Select * From %s Where B_Group=''%s'' Order By B_Py ASC,B_Index DESC';
  nStr := Format(nStr, [sTable_BaseInfo, nGroup]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then Exit;
    First;

    while not Eof do
    begin
      nStr := FieldByName('B_Text').AsString;
      nList.Add(nStr);
      Next;
    end;
  end;
end;

//Date: 2015-06-28
//Parm: ����;��;�Ƿ�ɾ��
//Desc: ���ӻ�ɾ��nGroup.nItem��
procedure SaveBaseInfoByGroup(const nGroup,nItem: string;
 const nDel: Boolean = False);
var nStr: string;
begin
  if nDel then
  begin
    nStr := 'Delete From %s Where B_Group=''%s'' And B_Text=''%s''';
    nStr := Format(nStr, [sTable_BaseInfo, nGroup, nItem]);

   FDM.ExecuteSQL(nStr);
    Exit;
  end;

  nStr := 'Select Count(*) From %s Where B_Group=''%s'' And B_Text=''%s''';
  nStr := Format(nStr, [sTable_BaseInfo, nGroup, nItem]);
  if FDM.QueryTemp(nStr).Fields[0].AsInteger > 0 then Exit;

  nStr := MakeSQLByStr([SF('B_Group', nGroup),
          SF('B_Text', nItem),
          SF('B_Py', GetPinYinOfStr(nItem))
          ], sTable_BaseInfo, '', True);
  FDM.ExecuteSQL(nStr);
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
var nStr: string;
    nIdx: Integer;
    nVal: Double;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    Result := True;
    nStr := 'Select D_MID,D_Money,D_HasMoney From %s Where D_ID=''%s''';
    nStr := Format(nStr, [sTable_WashData, nWashID]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then Exit;
      //miss record

      nStr := 'Delete From %s Where D_ID=''%s''';
      nStr := Format(nStr, [sTable_WashData, nWashID]);
      nList.Add(nStr);

      nStr := 'Delete From %s Where D_ID=''%s''';
      nStr := Format(nStr, [sTable_WashDetail, nWashID]);
      nList.Add(nStr);

      nVal := FieldByName('D_Money').AsFloat;
      if FieldByName('D_HasMoney').AsFloat > 0 then
        nVal := 0;
      //δ����

      nStr := 'Update %s Set M_MoneyOut=M_MoneyOut-(%.2f),M_Times=M_Times-1 ' +
              'Where M_ID=''%s''';
      nStr := Format(nStr, [sTable_Member, nVal, FieldByName('D_MID').AsString]);
      nList.Add(nStr);

      if nVal > 0 then
      begin
        nStr := Format('ɾ��ʱ�˿�[ %s ]', [nWashID]);
        nStr := MakeSQLByStr([
                SF('M_ID', FieldByName('D_MID').AsString),
                SF('M_Type', sFlag_IOType_Out),
                SF('M_Money', -nVal, sfVal),
                SF('M_Date', sField_SQLServer_Now, sfVal),
                SF('M_Memo', nStr)
                ], sTable_InOutMoney, '', True);
        nList.Add(nStr)
      end;
    end;

    FDM.ADOConn.BeginTrans;
    try
      for nIdx:=0 to nList.Count - 1 do
        FDM.ExecuteSQL(nList[nIdx]);
      FDM.ADOConn.CommitTrans;
    except
      FDM.ADOConn.RollbackTrans;
      ShowMsg('ɾ��ʧ��,δ֪����', sHint);
    end;   
  finally
    nList.Free;
  end;   
end;

//------------------------------------------------------------------------------
//Desc: ��ӡ��Ա��Ϣ
function PrintMemberMoney(const nMID: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '�Ƿ�Ҫ��ӡ��Ա��Ϣ?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  Result := False;
  nStr := 'Select * From %s Where M_ID=''%s''';
  nStr := Format(nStr, [sTable_Member, nMID]);

  if FDM.QuerySQL(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] �Ļ�Ա����Ч!!';
    nStr := Format(nStr, [nMID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'Member.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'YuE';
  nParam.FValue := GetMemberValidMoney(nMID);
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlQuery;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: ��ӡ��ֵƾ֤
function PrintMemberInMoney(const nRID: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '�Ƿ�Ҫ��ӡ��ֵСƱ?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  Result := False;
  nStr := 'Select a.*,b.* From %s a' +
          ' Left Join %s b On b.M_ID=a.M_ID ' +
          'Where a.R_ID=''%s''';
  nStr := Format(nStr, [sTable_InOutMoney, sTable_Member, nRID]);

  if FDM.QuerySQL(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] �ļ�¼����Ч!!';
    nStr := Format(nStr, [nRID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'IOMoney.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'YuE';
  nStr := FDM.SqlQuery.FieldByName('M_ID').AsString;
  nParam.FValue := GetMemberValidMoney(nStr);
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlQuery;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: ��ӡ���·�ƾ֤
function PrintWashData(const nID: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '�Ƿ�Ҫ��ӡ����СƱ?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  Result := False;
  nStr := 'Select ws.*,M_Name,M_Py,M_Phone From $WS ws ' +
          ' Left Join $MM mm On mm.M_ID=ws.D_MID ' +
          'Where D_ID=''$ID''';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$WS', sTable_WashData),
          MI('$MM', sTable_Member), MI('$ID', nID)]);
  //xxxxx

  if FDM.QuerySQL(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] �ļ�¼����Ч!!';
    nStr := Format(nStr, [nID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'WashData.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'YuE';
  nStr := FDM.SqlQuery.FieldByName('D_MID').AsString;
  nParam.FValue := GetMemberValidMoney(nStr);
  FDR.AddParamItem(nParam);

  nStr := 'Select * From %s Where D_ID=''%s''';
  nStr := Format(nStr, [sTable_WashDetail, nID]);
  FDM.QueryTemp(nStr);

  FDR.Dataset1.DataSet := FDM.SqlQuery;
  FDR.Dataset2.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

end.
