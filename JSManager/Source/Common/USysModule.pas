{*******************************************************************************
  ����: dmzn@163.com 2009-6-25
  ����: ��Ԫģ��

  ��ע: ����ģ������ע������,ֻҪUsesһ�¼���.
*******************************************************************************}
unit USysModule;

{$I Link.Inc}

interface

uses
  {$IFDEF NetMode}
  UFormJS_Net, {$IFDEF MultiReplay}UMultiJS_Reply{$ELSE}UMultiJS_Net{$ENDIF},
  UFormBackupSQL, UFormRestoreSQL,
  {$ELSE}
  UFormZTParam_M, UFormJS_M, UFormBackupAccess, UFormRestoreAccess,
  {$ENDIF}
  UFrameLog, UFrameSysLog, UFormIncInfo, UFormPassword,
  UFrameStockType, UFormStockType, UFrameTruckInfo, UFormTruckInfo,
  UFrameJSLog, UFrameCustomer, UFormCustomer, UFrameJSItem, UFormJSItem,
  UFrameJSCard;

procedure InitSystemObject;
procedure RunSystemObject;
procedure FreeSystemObject;

implementation

uses
  UMemDataPool, USysLoger, USysConst;

//Desc: ��ʼ��ϵͳ����
procedure InitSystemObject;
begin
  gSysLoger := TSysLoger.Create(gPath + sLogDir);
  //system loger

  {$IFDEF NetMode}
    {$IFDEF MultiReplay}
    if not Assigned(gMemDataManager) then
      gMemDataManager := TMemDataManager.Create;
    if not Assigned(gMultiJSManager) then
      gMultiJSManager := TMultiJSManager.Create;
    {$ENDIF}
  gMultiJSManager.LoadFile(gPath + 'JSQ.xml');
  {$ENDIF}
end;

//Desc: ����ϵͳ����
procedure RunSystemObject;
begin

end;

//Desc: �ͷ�ϵͳ����
procedure FreeSystemObject;
begin

end;

end.
