{*******************************************************************************
  ����: dmzn@163.com 2023-11-06
  ����: ��������
*******************************************************************************}
unit USysConst;

interface

type
  TParamConfig = record
    FChanged: Boolean; //�ѸĶ�
    FAutoRun: Boolean; //������
    FAutoHide: Boolean; //����������
    FAdminPwd: string;  //��������

    FServerURI: string;  //���������
    FContentType: string; //ct
    FAppID: string;  //ai
    FAppKey: string;  //ak
    FFreshRate: Integer; //ˢ��Ƶ��(��)
  end;

var
  gSystemParam: TParamConfig;
  //ϵͳ����

implementation

end.
