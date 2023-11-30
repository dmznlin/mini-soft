{*******************************************************************************
  ����: dmzn@163.com 2023-11-06
  ����: ��������
*******************************************************************************}
unit USysConst;

interface

uses
  System.SysUtils;

const
  {*table name*}
  sTable_QingTian = 'nbheat';
  sTable_Samlee   = 'samlee';
  sTable_Sensor   = 'sensor';

  {*flag define*}
  sFlag_Yes       = 'Y';
  sFlag_No        = 'N';
  sFlag_Hint      = '��ʾ';

  {*image index*}
  sImage_QingTian = 4;
  sImage_Samlee   = 5;

type
  TParamConfig = record
    FChanged     : Boolean;                //�ѸĶ�
    FAutoRun     : Boolean;                //������
    FAutoHide    : Boolean;                //����������
    FAdminPwd    : string;                 //��������

    FServerURI   : string;                 //���������
    FContentType : string;                 //ct
    FAppID       : string;                 //ai
    FAppKey      : string;                 //ak
    FFreshRateQT : Integer;                //����ˢ��Ƶ��(��)
    FFreshRateSL : Integer;                //����ˢ��Ƶ��(��)

    FSamleeServer: string;                 //���������ַ
    FSamleeCType : string;                 //ct
  end;

  TDeviceType = (dtQingTian, dtSamlee);
  //�豸����

  TDeviceItem = record
    FType        : TDeviceType;            //�豸����
    FRecord      : string;                 //��¼��
    FDevice      : string;                 //�豸ID
    FName        : string;                 //�豸����
    FSn          : string;                 //sn
    FPos         : string;                 //��װλ��
    FValid       : Boolean;                //�Ƿ���Ч
    FDeleted     : Boolean;                //�Ƿ�ɾ��
  end;

const
  sDeviceType: array[TDeviceType] of string =('nbheat', 'sltemp');
  //�豸��������

var
  gSystemParam: TParamConfig;
  //ϵͳ����
  gDevices: array of TDeviceItem;
  //�豸�嵥

function FindDevice(const nID: string): Integer;
//��ں���

implementation

//Date: 2023-11-26
//Parm: �豸ID
//Desc: ����nID������
function FindDevice(const nID: string): Integer;
var nIdx: Integer;
begin
  Result := -1;

  for nIdx := Low(gDevices) to High(gDevices) do
   with gDevices[nIdx] do
    if (not FDeleted) and (CompareText(FDevice, nID) = 0) then
    begin
      Result := nIdx;
      Break;
    end;
end;

end.
