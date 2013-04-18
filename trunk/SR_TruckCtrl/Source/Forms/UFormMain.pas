{*******************************************************************************
  作者: dmzn@163.com 2013-3-7
  描述: 系统主单元,负责调用其它模块
*******************************************************************************}
unit UFormMain;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UcxChinese, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  ExtCtrls, ImgList, dxStatusBar, cxPC, StdCtrls;

type
  TfFormMain = class(TForm)
    HintPanel: TPanel;
    img1: TImage;
    img2: TImage;
    lblHintLabel: TLabel;
    wPage: TcxTabControl;
    SBar: TdxStatusBar;
    Image1: TImageList;
    Timer1: TTimer;
    procedure wPageResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure wPageChange(Sender: TObject);
    procedure wPageCanClose(Sender: TObject; var ACanClose: Boolean);
  private
    { Private declarations }
    procedure FormLoadConfig;
    procedure FormSaveConfig;
    {*配置信息*}
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  IniFiles, UFormWait, ULibFun, UFrameBase, USysModule, USysConst;

//Desc: 载入配置
procedure TfFormMain.FormLoadConfig;
var nStr: string;
    nIni: TIniFile;
begin
  HintPanel.DoubleBuffered := True;
  gStatusBar := sBar;

  nStr := Format(sDate, [DateToStr(Now)]);
  StatusBarMsg(nStr, cSBar_Date);
  nStr := Format(sTime, [TimeToStr(Now)]);
  StatusBarMsg(nStr, cSBar_Time);

  wPage.TabIndex := 0;
  CreateBaseFrameItem(cFI_FrameRealTime, Self, alClient);
  //创建核心面板

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

  InitSystemObject;
  //system object

  FormLoadConfig;
  //载入配置

  RunSystemObject(Handle);
  //run them
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ShowWaitForm(Self, '正在退出系统');
  try
    Application.ProcessMessages;
    FormSaveConfig;
    //窗体配置

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

//Desc: 调整标签宽度
procedure TfFormMain.wPageResize(Sender: TObject);
var nTab: TcxTabControl;
begin
  nTab := Sender as TcxTabControl;
  nTab.TabWidth := Trunc(nTab.ClientWidth / nTab.Tabs.Count) - 10;
end;

//Desc: 面板对应的FrameID
function TabLinkedFrame(const nTab: Integer): Integer;
begin
  case nTab of
   0: Result := cFI_FrameRealTime;
   1: Result := cFI_FrameRunMon;
   2: Result := cFI_FrameReport;
   3: Result := cFI_FrameRunlog;
   4: Result := cFI_FrameConfig else Result := -1;
  end;
end;

//Desc: 动态载入面板
procedure TfFormMain.wPageChange(Sender: TObject);
begin
  LockWindowUpdate(Handle);
  try
    CreateBaseFrameItem(TabLinkedFrame(wPage.TabIndex), Self);
    //new frame

    if wPage.TabIndex = 0 then
         wPage.Options := wPage.Options - [pcoCloseButton]
    else wPage.Options := wPage.Options + [pcoCloseButton];
  finally
    Application.ProcessMessages;
    LockWindowUpdate(0);
  end;
end;

procedure TfFormMain.wPageCanClose(Sender: TObject;
  var ACanClose: Boolean);
var nIdx: Integer;
    nFrame: TfFrameBase;
begin
  ACanClose := False;

  for nIdx:=ControlCount - 1 downto 0 do
  if Controls[nIdx] is TfFrameBase then
  begin
    nFrame := Controls[nIdx] as TfFrameBase;
    if nFrame.FrameID = TabLinkedFrame(wPage.TabIndex) then
    begin
      nFrame.Close();
      wPage.TabIndex := 0;
      Break;
    end;
  end;
end;

end.
