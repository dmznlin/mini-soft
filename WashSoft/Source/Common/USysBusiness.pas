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

procedure LoadBaseInfoByGroup(const nGroup: string; const nList: TStrings;
 const nClearFirt: Boolean = True);
procedure SaveBaseInfoByGroup(const nGroup,nItem: string;
 const nDel: Boolean = False);
//基础信息
function GetSerailID(const nGroup,nObject: string; nUseDate: Boolean): string;
//获取串号
function GetMemberValidMoney(const nMemberID: string;
 const nUserFreeze: Boolean = True): Double;
//获取可用金
function DeleteWashData(const nWashID: string): Boolean;
//删除洗衣记录

//------------------------------------------------------------------------------
function PrintMemberMoney(const nMID: string; const nAsk: Boolean): Boolean;
function PrintMemberInMoney(const nRID: string; const nAsk: Boolean): Boolean;
//打印会员资金
function PrintWashData(const nID: string; const nAsk: Boolean): Boolean;
//打印洗衣数据

implementation

//Desc: 记录日志
procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(nEvent);
end;

//Date: 2015-06-28
//Parm: 分组;列表
//Desc: 载入nGroup的信息到nList中
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
//Parm: 分组;项;是否删除
//Desc: 增加或删除nGroup.nItem项
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
      //未付款

      nStr := 'Update %s Set M_MoneyOut=M_MoneyOut-(%.2f),M_Times=M_Times-1 ' +
              'Where M_ID=''%s''';
      nStr := Format(nStr, [sTable_Member, nVal, FieldByName('D_MID').AsString]);
      nList.Add(nStr);

      if nVal > 0 then
      begin
        nStr := Format('删除时退款[ %s ]', [nWashID]);
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
      ShowMsg('删除失败,未知错误', sHint);
    end;   
  finally
    nList.Free;
  end;   
end;

//------------------------------------------------------------------------------
//Desc: 打印会员信息
function PrintMemberMoney(const nMID: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '是否要打印会员信息?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  Result := False;
  nStr := 'Select * From %s Where M_ID=''%s''';
  nStr := Format(nStr, [sTable_Member, nMID]);

  if FDM.QuerySQL(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s ] 的会员已无效!!';
    nStr := Format(nStr, [nMID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'Member.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'YuE';
  nParam.FValue := GetMemberValidMoney(nMID);
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlQuery;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: 打印充值凭证
function PrintMemberInMoney(const nRID: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '是否要打印充值小票?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  Result := False;
  nStr := 'Select a.*,b.* From %s a' +
          ' Left Join %s b On b.M_ID=a.M_ID ' +
          'Where a.R_ID=''%s''';
  nStr := Format(nStr, [sTable_InOutMoney, sTable_Member, nRID]);

  if FDM.QuerySQL(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s ] 的记录已无效!!';
    nStr := Format(nStr, [nRID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'IOMoney.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
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

//Desc: 打印收衣服凭证
function PrintWashData(const nID: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '是否要打印衣物小票?';
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
    nStr := '编号为[ %s ] 的记录已无效!!';
    nStr := Format(nStr, [nID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'WashData.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
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
