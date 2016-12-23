{*******************************************************************************
  ����: dmzn@163.com 2009-6-25
  ����: ��Ԫģ��

  ��ע: ����ģ������ע������,ֻҪUsesһ�¼���.
*******************************************************************************}
unit USysModule;

interface

uses
  UFrameLog, UFrameSysLog, UFormIncInfo, UFormBackupSQL, UFormRestoreSQL,
  UFormPassword, UFrameTempLog, UFormCollect;

procedure InitSystemObject;
procedure RunSystemObject;
procedure FreeSystemObject;

implementation

uses
  UFormBase, SysUtils, USysLoger, USysConst;

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
  CreateBaseFormItem(cFI_FormCollectData);
end;

//Desc: �ͷ�ϵͳ����
procedure FreeSystemObject;
begin
  FreeAndNil(gSysLoger);
end;

end.
