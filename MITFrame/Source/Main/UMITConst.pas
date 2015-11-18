{*******************************************************************************
  ����: dmzn@163.com 2011-10-22
  ����: ��������
*******************************************************************************}
unit UMITConst;

{$I Link.Inc}
interface

uses
  Windows, SysUtils, Classes, ComCtrls, Forms, IniFiles, USysMAC;

const
  cSBar_Date          = 0;                           //�����������
  cSBar_Time          = 1;                           //ʱ���������
  cSBar_User          = 2;                           //�û��������

const
  {*Frame ID*}
  cFI_FrameRunlog     = $0002;                       //������־
  cFI_FrameSummary    = $0005;                       //��ϢժҪ
  cFI_FrameConfig     = $0006;                       //��������
  cFI_FrameParam      = $0007;                       //��������
  cFI_FramePlugs      = $0008;                       //�������
  cFI_FrameStatus     = $0009;                       //����״̬

  {*Form ID*}
  cFI_FormPack        = $0050;                       //������
  cFI_FormDB          = $0051;                       //���ݿ�
  cFI_FormSAP         = $0052;                       //sap
  cFI_FormPerform     = $0053;                       //��������
  cFI_FormServiceURL  = $0055;                       //�����ַ

  {*Command*}
  cCmd_AdminChanged   = $0001;                       //�����л�
  cCmd_RefreshData    = $0002;                       //ˢ������
  cCmd_ViewSysLog     = $0003;                       //ϵͳ��־

  cCmd_ModalResult    = $1001;                       //Modal����
  cCmd_FormClose      = $1002;                       //�رմ���
  cCmd_AddData        = $1003;                       //�������
  cCmd_EditData       = $1005;                       //�޸�����
  cCmd_ViewData       = $1006;                       //�鿴����

type
  TSysParam = record
    FProgID     : string;                            //�����ʶ
    FAppTitle   : string;                            //�����������ʾ
    FMainTitle  : string;                            //���������
    FHintText   : string;                            //��ʾ�ı�
    FCopyRight  : string;                            //��Ȩ����

    FAppFlag    : string;                            //�����ʶ
    FParam      : string;                            //��������
    FIconFile   : string;                            //ͼ���ļ�

    FAdminPwd   : string;                            //����Ա����
    FIsAdmin    : Boolean;                           //����Ա״̬
    FAdminKeep  : Integer;                           //״̬����

    FLocalIP    : string;                            //����IP
    FLocalMAC   : string;                            //����MAC
    FLocalName  : string;                            //��������

    FDisplayDPI : Integer;                           //��Ļ�ֱ���
    FAutoMin    : Boolean;                           //�Զ���С��
  end;
  //ϵͳ����

var
  gPath: string;                                     //��������·��
  gSysParam:TSysParam;                               //���򻷾�����
  gStatusBar: TStatusBar;                            //ȫ��ʹ��״̬��

procedure InitSystemEnvironment;
//��ʼ��ϵͳ���л����ı���
procedure ActionSysParameter(const nIsRead: Boolean);
//��дϵͳ���ò���

procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
//��״̬����ʾ��Ϣ

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'Bus_MIT';                   //Ĭ�ϱ�ʶ
  sAppTitle           = 'Bus_MIT';                   //�������
  sMainCaption        = 'ͨ���м��';                //�����ڱ���
  sHintText           = 'ͨ���м������';            //��ʾ����

  sHint               = '��ʾ';                      //�Ի������
  sWarn               = '����';                      //==
  sAsk                = 'ѯ��';                      //ѯ�ʶԻ���
  sError              = '����';                      //����Ի���

  sDate               = '����:��%s��';               //����������
  sTime               = 'ʱ��:��%s��';               //������ʱ��
  sUser               = '�û�:��%s��';               //�������û�

  sConfigFile         = 'Config.Ini';                //�������ļ�
  sConfigSec          = 'Config';                    //������С��
  
  sFormConfig         = 'FormInfo.ini';              //��������
  sLogDir             = 'Logs\';                     //��־Ŀ¼
  sLogSyncLock        = 'SyncLock_MIT_CommonMIT';    //��־ͬ����

  sPlugDir            = 'Plugs\';                    //���Ŀ¼
  sInvalidConfig      = '�����ļ���Ч���Ѿ���';    //�����ļ���Ч
  sCloseQuery         = 'ȷ��Ҫ�˳�������?';         //�������˳�
  
implementation

procedure InitSystemEnvironment;
begin
  Randomize;
  ShortDateFormat := 'YYYY-MM-DD';
  gPath := ExtractFilePath(Application.ExeName);
end;

//Desc: ��дϵͳ���ò���
procedure ActionSysParameter(const nIsRead: Boolean);
var nIni: TIniFile;
begin
  nIni := nil;
  try
    nIni := TIniFile.Create(gPath + sConfigFile);
    //config file

    with nIni,gSysParam do
    begin
      if nIsRead then
      begin
        FProgID    := ReadString(sConfigSec, 'ProgID', sProgID);
        //�����ʶ�����������в���          
        FAppTitle  := ReadString(FProgID, 'AppTitle', sAppTitle);
        FMainTitle := ReadString(FProgID, 'MainTitle', sMainCaption);
        FHintText  := ReadString(FProgID, 'HintText', '');

        FCopyRight := ReadString(FProgID, 'CopyRight', '');
        FCopyRight := StringReplace(FCopyRight, '\n', #13#10, [rfReplaceAll]);
        FAppFlag   := ReadString(FProgID, 'AppFlag', 'COMMIT');

        FParam     := ParamStr(1);
        FIconFile  := ReadString(FProgID, 'IconFile', gPath + 'Icons\Icon.ini');
        FIconFile  := StringReplace(FIconFile, '$Path\', gPath, [rfIgnoreCase]);

        FLocalMAC   := MakeActionID_MAC;
        GetLocalIPConfig(FLocalName, FLocalIP);
        FDisplayDPI := GetDeviceCaps(GetDC(0), LOGPIXELSY);
      end;
    end;
  finally
    nIni.Free;
  end; 
end;

//------------------------------------------------------------------------------
//Desc: ��ȫ��״̬�����һ��Panel����ʾnMsg��Ϣ
procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
begin
  if Assigned(gStatusBar) and (gStatusBar.Panels.Count > 0) then
  begin
    gStatusBar.Panels[gStatusBar.Panels.Count - 1].Text := nMsg;
    Application.ProcessMessages;
  end;
end;

//Desc: ������nIdx��Panel����ʾnMsg��Ϣ
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
begin
  if Assigned(gStatusBar) and (gStatusBar.Panels.Count > nIdx) and
     (nIdx > -1) then
  begin
    gStatusBar.Panels[nIdx].Text := nMsg;
    gStatusBar.Panels[nIdx].Width := gStatusBar.Canvas.TextWidth(nMsg) +
                                     Trunc(gSysParam.FDisplayDPI * Length(nMsg) / 50);
    //Application.ProcessMessages;
  end;
end;

end.
