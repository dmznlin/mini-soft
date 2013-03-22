{*******************************************************************************
  作者: dmzn@163.com 2013-3-7
  描述: 柱状图显示
*******************************************************************************}
unit UFrameHistogram;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  UFrameBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, StdCtrls, ExtCtrls,
  cxProgressBar, cxLabel;

type
  TfFrameHistogram = class(TfFrameBase)
    TimerStart: TTimer;
    PanelBreakPipe: TPanel;
    cxLabel2: TcxLabel;
    PanelTotalPipe: TPanel;
    cxLabel1: TcxLabel;
    PanelBreakPot: TPanel;
    cxLabel3: TcxLabel;
    PanelStyle: TPanel;
    cxLabel4: TcxLabel;
    PBar: TcxProgressBar;
    LabelStyle: TcxLabel;
    TimerUI: TTimer;
    BtnExit: TButton;
    procedure TimerStartTimer(Sender: TObject);
    procedure TimerUITimer(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
  protected
    { Protected declarations }
    procedure OnShowFrame; override;
    procedure BuildDeviceUI(const nParent: TWinControl);
    //build ui
    procedure ScanDeviceData(const nParent: TWinControl);
    //display data
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  UMgrControl, ULibFun, USysProtocol, USysConst;

class function TfFrameHistogram.FrameID: integer;
begin
  Result := cFI_FrameHistogram;
end;

procedure TfFrameHistogram.OnShowFrame;
begin
  TimerStart.Enabled := True;
end;

procedure TfFrameHistogram.BtnExitClick(Sender: TObject);
begin
  Close();
end;

//Desc: 延时启动
procedure TfFrameHistogram.TimerStartTimer(Sender: TObject);
begin
  TimerStart.Enabled := False;
  TimerUI.Enabled := True;
  
  BuildDeviceUI(PanelBreakPipe);
  BuildDeviceUI(PanelBreakPot);
  BuildDeviceUI(PanelTotalPipe);
end;

//Desc: 构建界面元素
procedure TfFrameHistogram.BuildDeviceUI;
var nList: TList;
    nPort: PCOMItem;
    nDev: PDeviceItem;
    nBar: TcxProgressBar;
    i,nIdx,nLeft,nMin: Integer;
begin
  nList := gDeviceManager.LockPortList;
  try
    nLeft := PBar.Left;
    //init pos
    
    for i:=0 to nList.Count - 1 do
    begin
      nPort := nList[i];
      //xxxxx

      for nIdx:=0 to nPort.FDevices.Count - 1 do
      begin
        nDev := nPort.FDevices[nIdx];
        if not nDev.FDeviceUsed then Continue;

        nBar := TcxProgressBar.Create(nParent);
        with nBar do
        begin
          AutoSize := False;
          Style.Assign(PBar.Style);
          Properties.Assign(PBar.Properties);
          //look style

          Top := PBar.Top;
          Left := nLeft;
          Width := PBar.Width;
          Height := PBar.Height;

          Properties.Max := gSysParam.FUIMaxValue;
          Position := 0;
          Properties.Text := FloatToStr(Position);

          Inc(nLeft, gSysParam.FUIInterval);
          Parent := nParent;
          Tag := Integer(nDev);
        end;

        with TcxLabel.Create(nParent) do
        begin
          Style.Assign(LabelStyle.Style);
          Properties.Assign(LabelStyle.Properties);
          //look style

          Caption := nDev.FCarriage.FName;
          Top := LabelStyle.Top;
          Parent := nParent;

          nMin := nBar.Left + Trunc(nBar.Width / 2);
          Left := nMin - Trunc(Width / 2);
          Tag := Integer(nPort);
        end;
      end;
    end;
  finally
    gDeviceManager.ReleaseLock;
  end;
end;

//Desc: 扫描状态
procedure TfFrameHistogram.TimerUITimer(Sender: TObject);
begin
  ScanDeviceData(PanelBreakPipe);
  ScanDeviceData(PanelBreakPot);
  ScanDeviceData(PanelTotalPipe);
end;

//Date: 2013-3-15
//Parm: 数据;个数
//Desc: 在nData中检索最大值
function GetMaxData(const nData: array of TDeviceData; const nNum: Word): Word;
var nIdx: Integer;
begin
  Result := 0;

  for nIdx:=0 to nNum - 1 do
  if nData[nIdx].FData > Result then
  begin
    Result := nData[nIdx].FData;
  end;
end;

//Desc: 更新界面数据
procedure TfFrameHistogram.ScanDeviceData(const nParent: TWinControl);
var nIdx: Integer;
    nDev: PDeviceItem;
    nBar: TcxProgressBar;
begin
  nBar := nil;
  //to ignor warn
  
  for nIdx:=nParent.ControlCount - 1 downto 0 do
  begin
    if nParent.Controls[nIdx] is TcxProgressBar then
         nBar := nParent.Controls[nIdx] as TcxProgressBar
    else Continue;

    nDev := Pointer((nParent.Controls[nIdx] as TComponent).Tag);
    if nParent = PanelBreakPipe then
      nBar.Position := GetMaxData(nDev.FBreakPipe, nDev.FBreakPipeNum);
    //xxxxx

    if nParent = PanelBreakPot then
      nBar.Position := GetMaxData(nDev.FBreakPot, nDev.FBreakPotNum);
    //xxxxx

    if nParent = PanelTotalPipe then
      nBar.Position := nDev.FTotalPipe;
    nBar.Properties.Text := FloatToStr(nBar.Position);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameHistogram, TfFrameHistogram.FrameID);
end.
