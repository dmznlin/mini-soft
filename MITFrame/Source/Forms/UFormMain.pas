{*******************************************************************************
  ����: dmzn@163.com 2013-11-19
  ����: �м��ͨ�ÿ������Ԫ
*******************************************************************************}
unit UFormMain;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UTrayIcon, UcxChinese, UMgrPlug, cxGraphics, cxControls,
  cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinsdxNavBar2Painter, cxContainer, cxEdit,
  ExtCtrls, ComCtrls, cxLabel, dxNavBarCollns, cxClasses, dxNavBarBase,
  dxNavBar, cxLookAndFeels;

type
  TfFormMain = class(TForm)
    PanelTitle: TPanel;
    ImgLeft: TImage;
    ImgClient: TImage;
    LabelHint: TcxLabel;
    SBar: TStatusBar;
    Timer1: TTimer;
    Timer2: TTimer;
    PanelWork: TPanel;
    dxNavBar1: TdxNavBar;
    BarGroup1: TdxNavBarGroup;
    BarGroup2: TdxNavBarGroup;
    BarGroup3: TdxNavBarGroup;
    SysSummary: TdxNavBarItem;
    SysRunlog: TdxNavBarItem;
    SysConfig: TdxNavBarItem;
    SysRunParam: TdxNavBarItem;
    BarGroup4: TdxNavBarGroup;
    BarGroup4Control: TdxNavBarGroupControl;
    LabelCopy: TcxLabel;
    LabelAdmin: TcxLabel;
    Timer3: TTimer;
    SysService: TdxNavBarItem;
    Timer4: TTimer;
    SysPlugs: TdxNavBarItem;
    SysStatus: TdxNavBarItem;
    procedure Timer2Timer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SysSummaryClick(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure LabelAdminClick(Sender: TObject);
    procedure SysServiceClick(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
  private
    { Private declarations }
    FTrayIcon: TTrayIcon;
    {*״̬��ͼ��*}
  protected
    procedure SetHintText(const nLabel: TcxLabel);
    {*��ʾ��Ϣ*}
    procedure DoMenuClick(Sender: TObject);
    {*�˵��¼�*}
    procedure FormLoadConfig;
    procedure FormSaveConfig;
    {*������Ϣ*}
    procedure PMRestoreForm(var nMsg: TMessage); message PM_RestoreForm;
    procedure PMRefreshMenu(var nMsg: TMessage); message PM_RefreshMenu;
    {*��Ϣ����*}
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UBase64, UROModule, USysLoger, UFormWait, UFormInputbox,
  UFrameBase, UFormBase, UMITModule, UMITConst;

//------------------------------------------------------------------------------
//Date: 2007-10-15
//Parm: ��ǩ
//Desc: ��nLabel����ʾ��ʾ��Ϣ
procedure TfFormMain.SetHintText(const nLabel: TcxLabel);
begin
  with nLabel.Properties do
  begin
    Depth := 2;
    ShadowedColor := clGray;

    LabelEffect := cxleCool;
    LabelStyle := cxlsNormal;
  end;

  with nLabel.Style do
  begin
    Font.Color := clWhite;
    Font.Size := 15;
    //Font.Style := Font.Style + [fsBold];
  end;
              
  with nLabel do
  begin
    Caption := gSysParam.FHintText;
    Left := PanelTitle.Width - Width - 12;
    Top := (PanelTitle.Height - Height) div 2 + 2;
  end;
end;
       
//Desc: ��������
procedure TfFormMain.FormLoadConfig;
var nStr: string;
    nIni: TIniFile;
begin
  dxNavBar1.Width := ImgLeft.Width - 65;
  PanelTitle.Height := ImgLeft.Picture.Height;
  //���У��,ʹ�ò�ͬ�Ŵ��������Ļ

  gStatusBar := sBar;
  PanelTitle.DoubleBuffered := True; 

  SetHintText(LabelHint);
  LabelCopy.Caption := gSysParam.FCopyRight;
  BarGroup4Control.Height := LabelCopy.Height + LabelAdmin.Height + 8 * 2;

  nStr := Format(sDate, [DateToStr(Now)]);
  StatusBarMsg(nStr, cSBar_Date);
  nStr := Format(sTime, [TimeToStr(Now)]);
  StatusBarMsg(nStr, cSBar_Time);

  FDM.LoadSystemIcons(gSysParam.FIconFile);
  //����ͼ��
  CreateBaseFrameItem(cFI_FrameSummary, PanelWork);
  //���������

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    with gSysParam do
    begin
      FIsAdmin := False;
      FAdminPwd := nIni.ReadString('System', 'AdminPwd', '');
      FAdminPwd := DecodeBase64(FAdminPwd);

      FAdminKeep := nIni.ReadInteger('System', 'AdminKeep', 60);
      FAutoMin := nIni.ReadBool('System', 'AutoMin', False);
    end;

     LoadFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;
end;

//Desc: ���洰������
procedure TfFormMain.FormSaveConfig;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    with gSysParam do
    begin
      nIni.WriteString('System', 'AdminPwd', EncodeBase64(FAdminPwd));
      nIni.WriteInteger('System', 'AdminKeep', FAdminKeep);
      nIni.WriteBool('System', 'AutoMin', FAutoMin);
    end;

    SaveFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;

  ActionSysParameter(False);
end;

procedure TfFormMain.FormCreate(Sender: TObject);
var nStr: string;
begin
  Application.Title := gSysParam.FAppTitle;
  InitGlobalVariant(gPath, gPath + sConfigFile, gPath + sFormConfig);

  nStr := GetFileVersionStr(Application.ExeName);
  if nStr <> '' then
  begin
    nStr := Copy(nStr, 1, Pos('.', nStr) - 1);
    Caption := gSysParam.FMainTitle + ' V' + nStr;
  end else Caption := gSysParam.FMainTitle;

  nStr := ChangeFileExt(Application.ExeName, '.ico');
  if FileExists(nStr) then
    Application.Icon.LoadFromFile(nStr);
  //change app icon

  FormLoadConfig;
  //load config
  
  InitSystemObject(Handle);
  //system object

  RunSystemObject;
  //run object
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
var nStr: string;
begin
  ShowWaitForm(Self, '�����˳�ϵͳ', True);
  try
    ROModule.ActiveServer([stTcp, stHttp], False, nStr);
    //stop server

    FormSaveConfig;
    //save config

    FreeSystemObject;
    //system object
                             
    {$IFNDEF debug}
    Sleep(2200);
    {$ENDIF}
  finally
    CloseWaitForm;
  end;
end;

//------------------------------------------------------------------------------
//Desc: �ָ�����״̬
procedure TfFormMain.PMRestoreForm(var nMsg: TMessage);
begin
  if Assigned(FTrayIcon) then FTrayIcon.Restore;
end;

//Desc: ����������,ʱ��
procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  sBar.Panels[cSBar_Date].Text := Format(sDate, [DateToStr(Now)]);
  sBar.Panels[cSBar_Time].Text := Format(sTime, [TimeToStr(Now)]);
end;

//Desc: ��ʱ����ϵͳ�߼�
procedure TfFormMain.Timer2Timer(Sender: TObject);
begin
  Timer2.Enabled := (FTrayIcon = nil);
  //verify timer's valid

  if not Assigned(FTrayIcon) then
  begin
    if FindWindow('Shell_TrayWnd', nil) > 0 then
    begin
      FTrayIcon := TTrayIcon.Create(Self);
      FTrayIcon.Hint := gSysParam.FAppTitle;
      FTrayIcon.Visible := True;
    end;
  end;
end;

//Desc: ��ʱ��������
procedure TfFormMain.Timer4Timer(Sender: TObject);
begin
  Timer4.Enabled := False;
  //once

  if gSysParam.FAutoMin and (not ROModule.IsServiceRun) then
  begin
    SysService.OnClick(nil);
    //try to start

    {$IFNDEF DEBUG}
    if ROModule.IsServiceRun then
      PostMessage(Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
    //xxxxx
    {$ENDIF}
  end;
end;

//Desc: ��ʱ�˳�����Ա״̬
procedure TfFormMain.Timer3Timer(Sender: TObject);
begin
  Timer3.Tag := Timer3.Tag - 1;
  if Timer3.Tag > 0 then
  begin
    LabelAdmin.Caption := Format('����״̬: %d ', [Timer3.Tag]);
  end else
  begin
    Timer3.Enabled := False;
    LabelAdmin.Caption := '����Ա��¼ ';
    LabelAdmin.Hint := '����������״̬';

    gSysParam.FIsAdmin := False;
    PostMessage(Handle, PM_RefreshMenu, PM_RM_OnlyStatus, 0);
    BroadcastFrameCommand(nil, cCmd_AdminChanged);
  end;  
end;

//Desc: ����Ա��¼
procedure TfFormMain.LabelAdminClick(Sender: TObject);
var nStr: string;
begin
  if Timer3.Tag > 0 then
  begin
    LabelAdmin.Caption := '';
    Timer3.Tag := 0;
    Exit;
  end;

  while ShowInputPWDBox('���������Ա����:', '��¼', nStr) do
  begin
    if nStr = gSysParam.FAdminPwd then
    begin
      Timer3.Tag := gSysParam.FAdminKeep;
      Timer3.Enabled := True;

      LabelAdmin.Caption := '';
      LabelAdmin.Hint := '���ע������Ա';

      gSysParam.FIsAdmin := True;
      PostMessage(Handle, PM_RefreshMenu, PM_RM_OnlyStatus, 0);
      BroadcastFrameCommand(nil, cCmd_AdminChanged);
      
      ShowMsg('����Ա��¼�ɹ�', sHint);
      Break;
    end else ShowMsg('�������,��������', sHint);
  end;
end;

//Desc: ��׼�˵�����
procedure TfFormMain.SysSummaryClick(Sender: TObject);
begin
  LockWindowUpdate(PanelWork.Handle);
  try
    if Sender = SysSummary then
      CreateBaseFrameItem(cFI_FrameSummary, PanelWork) else
    if Sender = SysRunlog then
      CreateBaseFrameItem(cFI_FrameRunlog, PanelWork) else
    if Sender = SysConfig then
      CreateBaseFrameItem(cFI_FrameConfig, PanelWork) else
    if Sender = SysRunParam then
      CreateBaseFrameItem(cFI_FrameParam, PanelWork) else
    if Sender = SysPlugs then
      CreateBaseFrameItem(cFI_FramePlugs, PanelWork) else
    if Sender = SysStatus then
      CreateBaseFrameItem(cFI_FrameStatus, PanelWork);
  finally
    LockWindowUpdate(0);
  end;
end;

//Desc: ��������
procedure TfFormMain.SysServiceClick(Sender: TObject);
var nStr: string;
begin
  if ROModule.ActiveServer([stHttp], not ROModule.IsServiceRun, nStr) then
       PostMessage(Handle, PM_RefreshMenu, PM_RM_OnlyStatus, 0)
  else ShowMsg('��������ʧ��', '�������־');
end;

//Desc: ˢ�²˵�
procedure TfFormMain.PMRefreshMenu(var nMsg: TMessage);
var nIdx: Integer;
    nItem: TdxNavBarItem;
    nMenus: TPlugMenuItems;
begin
  if csDestroying in ComponentState then Exit;
  //filter

  with dxNavBar1 do
   for nIdx:=Groups.Count - 1 downto 0 do
    Groups[nIdx].LargeImageIndex := FDM.IconIndex(Groups[nIdx].Name);
  //image index

  for nIdx:=dxNavBar1.Items.Count - 1 downto 0 do
  begin
    if (nMsg.WParam = PM_RM_FullStatus) and
       Assigned(BarGroup3.FindLink(dxNavBar1.Items[nIdx])) then
    begin
      BarGroup3.RemoveLinks(dxNavBar1.Items[nIdx]);
      dxNavBar1.Items.Delete(nIdx);
    end else

    with dxNavBar1 do
    begin
      if Items[nIdx] = SysService then
      begin
        Items[nIdx].Enabled := gSysParam.FIsAdmin;
        //xxxxx
        
        if ROModule.IsServiceRun then
             Items[nIdx].Caption := 'ֹͣ����'
        else Items[nIdx].Caption := '��������';
      end;

      Items[nIdx].SmallImageIndex := FDM.IconIndex(Items[nIdx].Name);
      //update icon
    end;
  end;

  if nMsg.WParam <> PM_RM_FullStatus then Exit;
  SetLength(nMenus, 0);
  nMenus := gPlugManager.GetMenuItems(True);
  
  for nIdx:=Low(nMenus) to High(nMenus) do
  begin
    nItem := dxNavBar1.Items.Add;

    with nItem,nMenus[nIdx] do
    begin
      Name := FName;
      Caption := FCaption;
      Tag := FFormID;

      OnClick := DoMenuClick;
      SmallImageIndex := FDM.IconIndex(FName);
      BarGroup3.CreateLink(nItem);

      if FDefault then
        DoMenuClick(nItem);
      //click
    end;
  end;
end;

//Desc: ��չ�˵�����
procedure TfFormMain.DoMenuClick(Sender: TObject);
var nStr: string;
begin
  nStr := BoolToStr(gSysParam.FIsAdmin, True);
  CreateBaseFormItem(TdxNavBarItem(Sender).Tag, nStr);
end;

end.
