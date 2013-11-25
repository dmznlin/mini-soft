{*******************************************************************************
  作者: dmzn@163.com 2013-11-19
  描述: 中间件通用框架主单元
*******************************************************************************}
unit UFormMain;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UTrayIcon, UcxChinese, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinsdxNavBar2Painter, cxContainer, cxEdit,
  ExtCtrls, ComCtrls, cxLabel, dxNavBarCollns, cxClasses, dxNavBarBase,
  dxNavBar, StdCtrls;

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
    NavGroup1: TdxNavBarGroup;
    NavGroup2: TdxNavBarGroup;
    NavGroup3: TdxNavBarGroup;
    NavItem1: TdxNavBarItem;
    NavItem2: TdxNavBarItem;
    Button1: TButton;
    procedure Timer2Timer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FTrayIcon: TTrayIcon;
    {*状态栏图标*}
  protected
    procedure SetHintText(const nLabel: TcxLabel);
    {*提示信息*}
    procedure FormLoadConfig;
    procedure FormSaveConfig;
    {*配置信息*}
    procedure InitSystemObject;
    procedure RunSystemObject;
    procedure FreeSystemObject;
    {*系统对象*}
    procedure WMRestoreForm(var nMsg: TMessage); message WM_User + $0001;
    {*恢复状态*}
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UFormWait, UFrameBase, UMgrPlug, UROModule, UMITConst,
  UMgrParam, USysLoger, UPlugConst;

//------------------------------------------------------------------------------
//Date: 2007-10-15
//Parm: 标签
//Desc: 在nLabel上显示提示信息
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
    Caption := sHintText;
    Left := PanelTitle.Width - Width - 12;
    Top := (PanelTitle.Height - Height) div 2 + 2;
  end;
end;
       
//Desc: 载入配置
procedure TfFormMain.FormLoadConfig;
var nStr: string;
    nIni: TIniFile;
begin
  dxNavBar1.Width := ImgLeft.Width - 65;
  PanelTitle.Height := ImgLeft.Picture.Height;
  //宽度校正,使用不同放大比例的屏幕

  SetHintText(LabelHint);
  PanelTitle.DoubleBuffered := True; 
  gStatusBar := sBar;

  nStr := Format(sDate, [DateToStr(Now)]);
  StatusBarMsg(nStr, cSBar_Date);
  nStr := Format(sTime, [TimeToStr(Now)]);
  StatusBarMsg(nStr, cSBar_Time);

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;
end;

//Desc: 保存窗体配置
procedure TfFormMain.FormSaveConfig;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;

  ActionSysParameter(False);
end;

//Desc: 初始化系统对象
procedure TfFormMain.InitSystemObject;
begin
  gSysLoger := TSysLoger.Create(gPath + sLogDir, sLogSyncLock);
  //日志管理器
  gParamManager := TParamManager.Create(gPath + 'Parameters.xml');
  //参数管理器
  gPlugManager := TPlugManager.Create;
  gPlugManager.LoadPlugsInDirectory(gPath + 'Plugs');
  //插件管理器
end;

//Desc: 运行系统对象
procedure TfFormMain.RunSystemObject;
var nParam: TPlugRunParameter;
begin
  with nParam do
  begin
    FAppHandle := Application.Handle;
    FMainForm  := Self.Handle;
  end;

  gPlugManager.RunSystemObject(@nParam);
end;

//Desc: 释放系统对象
procedure TfFormMain.FreeSystemObject;
begin

end;

procedure TfFormMain.FormCreate(Sender: TObject);
var nStr: string;
begin
  InitSystemEnvironment;
  ActionSysParameter(True);

  Application.Title := gSysParam.FAppTitle;
  InitGlobalVariant(gPath, gPath + sConfigFile, gPath + sFormConfig);

  nStr := GetFileVersionStr(Application.ExeName);
  if nStr <> '' then
  begin
    nStr := Copy(nStr, 1, Pos('.', nStr) - 1);
    Caption := gSysParam.FMainTitle + ' V' + nStr;
  end else Caption := gSysParam.FMainTitle;

  FormLoadConfig;
  //load config
  
  InitSystemObject;
  //system object

  RunSystemObject;
  //run object
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
var nStr: string;
begin
  ShowWaitForm(Self, '正在退出系统');
  try
    Application.ProcessMessages;

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
//Desc: 任务栏日期,时间
procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  sBar.Panels[cSBar_Date].Text := Format(sDate, [DateToStr(Now)]);
  sBar.Panels[cSBar_Time].Text := Format(sTime, [TimeToStr(Now)]);
end;

//Desc: 恢复窗体状态
procedure TfFormMain.WMRestoreForm(var nMsg: TMessage);
begin
  if Assigned(FTrayIcon) then FTrayIcon.Restore;
end;

//Desc: 延时处理系统逻辑
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

end.
