{*******************************************************************************
  ����: dmzn@163.com 2009-6-25
  ����: ��Ԫģ��

  ��ע: ����ģ������ע������,ֻҪUsesһ�¼���.
*******************************************************************************}
unit USysModule;

interface

uses
  UFrameLog, UFrameSysLog, UFormIncInfo, UFormBackupSQL, UFormRestoreSQL,
  UFormPassword, UFrameMember, UFormMember, UFormGetMember, UFrameIOMoney,
  UFormIOMoney, UFrameWashType, UFormWashType, UFrameClothesIn, UFormWashData;

procedure InitSystemObject;
procedure RunSystemObject;
procedure FreeSystemObject;

implementation

uses
  SysUtils, USysLoger, USysConst;

//Desc: ��ʼ��ϵͳ����
procedure InitSystemObject;
begin
  if not Assigned(gSysLoger) then
    gSysLoger := TSysLoger.Create(gPath + sLogDir);
  //system loger
end;

//Desc: ����ϵͳ����
procedure RunSystemObject;
begin

end;

//Desc: �ͷ�ϵͳ����
procedure FreeSystemObject;
begin
  FreeAndNil(gSysLoger);
end;

end.
