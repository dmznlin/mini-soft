{$DEFINE debug}
//����ģʽ

{$DEFINE COM_MIT}
//����ϵͳģʽ

//ͨ���м��
{$IFDEF COM_MIT}
  {$DEFINE DBPool}
  //�������ݿ�֧��
  {.$DEFINE SAP}
  //����SAP֧��
  {.$DEFINE ClientMon}
  //֧���ػ�����
{$ENDIF}

//ҵ���м��
{$IFDEF BUS_MIT}
  {$DEFINE DBPool}
  //�������ݿ�֧��
  {.$DEFINE SAP}
  //����SAP֧��
  {.$DEFINE ClientMon}
  //֧���ػ�����
{$ENDIF}

//SAP�м��
{$IFDEF SAP_MIT}
  {.$DEFINE DBPool}
  //�������ݿ�֧��
  {$DEFINE SAP}
  //����SAP֧�� 
  {.$DEFINE ClientMon}
  //֧���ػ�����
{$ENDIF}

{$DEFINE cxLibrary42}
//Ver4.2���뻷��