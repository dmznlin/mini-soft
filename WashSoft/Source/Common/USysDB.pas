{*******************************************************************************
  ����: dmzn@163.com 2008-08-07
  ����: ϵͳ���ݿⳣ������

  ��ע:
  *.�Զ�����SQL���,֧�ֱ���:$Inc,����;$Float,����;$Integer=sFlag_Integer;
    $Decimal=sFlag_Decimal;$Image,��������
*******************************************************************************}
unit USysDB;

{$I Link.inc}
interface

uses
  SysUtils, Classes;

const
  cSysDatabaseName: array[0..4] of String = (
     'Access', 'SQL', 'MySQL', 'Oracle', 'DB2');
  //db names

type
  TSysDatabaseType = (dtAccess, dtSQLServer, dtMySQL, dtOracle, dtDB2);
  //db types

  PSysTableItem = ^TSysTableItem;
  TSysTableItem = record
    FTable: string;
    FNewSQL: string;
  end;
  //ϵͳ����

var
  gSysTableList: TList = nil;                        //ϵͳ������
  gSysDBType: TSysDatabaseType = dtSQLServer;        //ϵͳ��������

//------------------------------------------------------------------------------
const
  //�����ֶ�
  sField_Access_AutoInc          = 'Counter';
  sField_SQLServer_AutoInc       = 'Integer IDENTITY (1,1) PRIMARY KEY';

  //С���ֶ�
  sField_Access_Decimal          = 'Float';
  sField_SQLServer_Decimal       = 'Decimal(15, 5)';

  //ͼƬ�ֶ�
  sField_Access_Image            = 'OLEObject';
  sField_SQLServer_Image         = 'Image';

  //�������
  sField_SQLServer_Now           = 'getDate()';

ResourceString     
  {*Ȩ����*}
  sPopedom_Read       = 'A';                         //���
  sPopedom_Add        = 'B';                         //���
  sPopedom_Edit       = 'C';                         //�޸�
  sPopedom_Delete     = 'D';                         //ɾ��
  sPopedom_Preview    = 'E';                         //Ԥ��
  sPopedom_Print      = 'F';                         //��ӡ
  sPopedom_Export     = 'G';                         //����

  {*��ر��*}
  sFlag_Yes           = 'Y';                         //��
  sFlag_No            = 'N';                         //��
  sFlag_Enabled       = 'Y';                         //����
  sFlag_Disabled      = 'N';                         //����

  sFlag_Integer       = 'I';                         //����
  sFlag_Decimal       = 'D';                         //С��

  sFlag_IOType_In     = 'C';                         //��ֵ
  sFlag_IOType_Out    = 'X';                         //����

  sFlag_GroupUnit     = 'Unit';                      //��λ
  sFlag_GroupColor    = 'Color';                     //��ɫ
  sFlag_GroupType     = 'Type';                      //����

  sFlag_BusGroup      = 'BusFunction';               //ҵ�������
  sFlag_MemberID      = 'ID_Member';                 //��Ա���
  sFlag_WashTypeID    = 'ID_WashType';               //��������
  sFlag_WashData      = 'ID_WashData';               //ϴ�¼�¼

  {*���ݱ�*}
  sTable_Group        = 'Sys_Group';                 //�û���
  sTable_User         = 'Sys_User';                  //�û���
  sTable_Menu         = 'Sys_Menu';                  //�˵���
  sTable_Popedom      = 'Sys_Popedom';               //Ȩ�ޱ�
  sTable_PopItem      = 'Sys_PopItem';               //Ȩ����
  sTable_Entity       = 'Sys_Entity';                //�ֵ�ʵ��
  sTable_DictItem     = 'Sys_DataDict';              //�ֵ���ϸ

  sTable_SysDict      = 'Sys_Dict';                  //ϵͳ�ֵ�
  sTable_ExtInfo      = 'Sys_ExtInfo';               //������Ϣ
  sTable_SysLog       = 'Sys_EventLog';              //ϵͳ��־
  sTable_BaseInfo     = 'Sys_BaseInfo';              //������Ϣ
  sTable_SerialBase   = 'Sys_SerialBase';            //��������

  sTable_Member       = 'W_Member';                  //��Ա��
  sTable_InOutMoney   = 'W_InOutMoney';              //�ʽ���ϸ
  sTable_WashType     = 'W_WashType';                //��������
  sTable_WashData     = 'W_WashData';                //ϴ������
  sTable_WashDetail   = 'W_WashDetail';              //������ϸ

  {*�½���*}
  sSQL_NewSysDict = 'Create Table $Table(D_ID $Inc, D_Name varChar(15),' +
       'D_Desc varChar(30), D_Value varChar(50), D_Memo varChar(20),' +
       'D_ParamA $Float, D_ParamB varChar(50), D_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   ϵͳ�ֵ�: SysDict
   *.D_ID: ���
   *.D_Name: ����
   *.D_Desc: ����
   *.D_Value: ȡֵ
   *.D_Memo: �����Ϣ
   *.D_ParamA: �������
   *.D_ParamB: �ַ�����
   *.D_Index: ��ʾ����
  -----------------------------------------------------------------------------}
  
  sSQL_NewExtInfo = 'Create Table $Table(I_ID $Inc, I_Group varChar(20),' +
       'I_ItemID varChar(20), I_Item varChar(30), I_Info varChar(500),' +
       'I_ParamA $Float, I_ParamB varChar(50), I_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   ��չ��Ϣ��: ExtInfo
   *.I_ID: ���
   *.I_Group: ��Ϣ����
   *.I_ItemID: ��Ϣ��ʶ
   *.I_Item: ��Ϣ��
   *.I_Info: ��Ϣ����
   *.I_ParamA: �������
   *.I_ParamB: �ַ�����
   *.I_Memo: ��ע��Ϣ
   *.I_Index: ��ʾ����
  -----------------------------------------------------------------------------}
  
  sSQL_NewSysLog = 'Create Table $Table(L_ID $Inc, L_Date DateTime,' +
       'L_Man varChar(32),L_Group varChar(20), L_ItemID varChar(20),' +
       'L_KeyID varChar(20), L_Event varChar(220))';
  {-----------------------------------------------------------------------------
   ϵͳ��־: SysLog
   *.L_ID: ���
   *.L_Date: ��������
   *.L_Man: ������
   *.L_Group: ��Ϣ����
   *.L_ItemID: ��Ϣ��ʶ
   *.L_KeyID: ������ʶ
   *.L_Event: �¼�
  -----------------------------------------------------------------------------}

  sSQL_NewBaseInfo = 'Create Table $Table(B_ID $Inc, B_Group varChar(15),' +
       'B_Text varChar(100), B_Py varChar(25), B_Memo varChar(50),' +
       'B_PID Integer, B_Index Float)';
  {-----------------------------------------------------------------------------
   ������Ϣ��: BaseInfo
   *.B_ID: ���
   *.B_Group: ����
   *.B_Text: ����
   *.B_Py: ƴ����д
   *.B_Memo: ��ע��Ϣ
   *.B_PID: �ϼ��ڵ�
   *.B_Index: ����˳��
  -----------------------------------------------------------------------------}

  sSQL_NewSerialBase = 'Create Table $Table(R_ID $Inc, B_Group varChar(15),' +
       'B_Object varChar(32), B_Prefix varChar(25), B_IDLen Integer,' +
       'B_Base Integer, B_Date DateTime)';
  {-----------------------------------------------------------------------------
   ���б�Ż�����: SerialBase
   *.R_ID: ���
   *.B_Group: ����
   *.B_Object: ����
   *.B_Prefix: ǰ׺
   *.B_IDLen: ��ų�
   *.B_Base: ����
   *.B_Date: �ο�����
  -----------------------------------------------------------------------------}

  sSQL_NewMember = 'Create Table $Table(R_ID $Inc, M_ID varChar(16),' +
       'M_Name varChar(32), M_Py varChar(32),' +
       'M_Phone varChar(32), M_Times Integer,' +
       'M_MoneyIn $Float, M_MoneyOut $Float, M_MoneyFreeze $Float,' +
       'M_JiFen $Float, M_ZheKou $Float)';
  {-----------------------------------------------------------------------------
   ��Ա��: Member
   *.R_ID: ���
   *.M_ID: ����
   *.M_Name: ����
   *.M_Py: ƴ��
   *.M_Phone: �ֻ���
   *.M_MoneyIn: ��ֵ���
   *.M_MoneyOut: ���ѽ��
   *.M_MoneyFreeze: ������
   *.M_Times: ���Ѵ���
   *.M_JiFen: ����
   *.M_ZheKou: �ۿ�
  -----------------------------------------------------------------------------}

  sSQL_NewInOutMoney = 'Create Table $Table(R_ID $Inc, M_ID varChar(16),' +
       'M_Type Char(1), M_Money $Float, M_Date DateTime, M_Memo varChar(100))';
  {-----------------------------------------------------------------------------
   �ʽ���ϸ: InOutMoney
   *.R_ID: ���
   *.M_ID: ��ʶ
   *.M_Type: ����
   *.M_Money: ���
   *.M_Date: ����
   *.M_Memo: ����
  -----------------------------------------------------------------------------}

  sSQL_NewWashType = 'Create Table $Table(R_ID $Inc, T_ID varChar(16),' +
       'T_Name varChar(32), T_Py varChar(32), T_Unit varChar(16),' +
       'T_WashType varChar(16), T_Price $Float, T_Memo varChar(100))';
  {-----------------------------------------------------------------------------
   �����: WashType
   *.R_ID: ���
   *.T_ID: ��ʶ
   *.T_Name,T_Py: ����
   *.T_Unit: ��λ
   *.T_WashType: ϴ������(��/ˮ)
   *.T_Price: �����۸�
   *.T_Memo: ��ע
  -----------------------------------------------------------------------------}

  sSQL_NewWashData = 'Create Table $Table(R_ID $Inc, D_ID varChar(16),' +
       'D_MID varChar(16), D_Number Integer, D_HasNumber Integer,' +
       'D_YSMoney $Float, D_Money $Float, D_HasMoney $Float,' +
       'D_Man varChar(16), D_Date DateTime, D_Memo varChar(100))';
  {-----------------------------------------------------------------------------
   ϴ�¼�¼: WashType
   *.R_ID: ���
   *.D_ID: ��ʶ
   *.D_MID: ��Ա��
   *.D_Number: ����
   *.D_HasNumber: ʣ��
   *.D_YSMoney: Ӧ��
   *.D_Money: ʵ��
   *.D_HasMoney: ʣ��
   *.D_Man: �ռ���
   *.D_Date: ʱ��
   *.D_Memo: ��ע
  -----------------------------------------------------------------------------}

  sSQL_NewWashDetail = 'Create Table $Table(R_ID $Inc, D_ID varChar(16),' +
       'D_TID varChar(16), D_Name varChar(32), D_Py varChar(32), ' +
       'D_Unit varChar(16),D_WashType varChar(16), D_Color varChar(16), ' +
       'D_Number Integer, D_HasNumber Integer,D_Memo varChar(100))';
  {-----------------------------------------------------------------------------
   ������ϸ: WashDetail
   *.R_ID: ���
   *.D_ID: �ϼܺ�
   *.D_TID: ���ͺ�
   *.D_Name: ����
   *.D_Py: ƴ��
   *.D_Unit: ��λ
   *.D_WashType: ��/ˮ
   *.D_Number: ����
   *.D_HasNumber: ʣ��
   *.D_Color: ��ɫ
   *.D_Memo: ��ע
  -----------------------------------------------------------------------------}

implementation

//------------------------------------------------------------------------------
//Desc: ���ϵͳ����
procedure AddSysTableItem(const nTable,nNewSQL: string);
var nP: PSysTableItem;
begin
  New(nP);
  gSysTableList.Add(nP);

  nP.FTable := nTable;
  nP.FNewSQL := nNewSQL;
end;

//Desc: ϵͳ��
procedure InitSysTableList;
begin
  gSysTableList := TList.Create;

  AddSysTableItem(sTable_SysDict, sSQL_NewSysDict);
  AddSysTableItem(sTable_ExtInfo, sSQL_NewExtInfo);
  AddSysTableItem(sTable_SysLog, sSQL_NewSysLog);
  
  AddSysTableItem(sTable_BaseInfo, sSQL_NewBaseInfo);
  AddSysTableItem(sTable_SerialBase, sSQL_NewSerialBase);

  AddSysTableItem(sTable_Member, sSQL_NewMember);
  AddSysTableItem(sTable_InOutMoney, sSQL_NewInOutMoney);
  AddSysTableItem(sTable_WashType, sSQL_NewWashType);
  AddSysTableItem(sTable_WashData, sSQL_NewWashData);
  AddSysTableItem(sTable_WashDetail, sSQL_NewWashDetail);
end;

//Desc: ����ϵͳ��
procedure ClearSysTableList;
var nIdx: integer;
begin
  for nIdx:= gSysTableList.Count - 1 downto 0 do
  begin
    Dispose(PSysTableItem(gSysTableList[nIdx]));
    gSysTableList.Delete(nIdx);
  end;

  FreeAndNil(gSysTableList);
end;

initialization
  InitSysTableList;
finalization
  ClearSysTableList;
end.


