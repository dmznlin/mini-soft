{*******************************************************************************
  作者: dmzn@163.com 2011-04-27
  描述: 多道计数器界面控制组件
*******************************************************************************}
unit UMultiJSCtrl;

interface

uses
  Windows, Classes, Controls, Forms, Graphics, SysUtils, ULibFun, cxGroupBox,
  cxLabel, cxEdit, cxControls, cxTextEdit, cxProgressBar, cxGraphics, 
  cxButtons, cxImage;

type
  TMultiJSPanelTunnel = record
    FComm: string;             //端口
    FTunnel: Word;             //通道
    FDelay: Word;              //延迟
    FPanelName: string;        //名称
    FStatus: string;           //状态
  end;

  TMultiJSPanelData = record
    FRecordID: string;         //标记
    FTruckNo: string;          //车牌号
    FStockName: string;        //品种名
    FStockNo: string;          //批次号
    FCustomer: string;         //客户名

    FIsBC: Boolean;            //是否补差
    FTHValue: Double;          //提货量
    FHaveDai: integer;         //待装数量
    FHasDone: integer;         //已装数量

    FTotalDS: Integer;         //已装应提
    FTotalBC: integer;         //已装补差
  end;

  TMultiJSEvent = procedure (Sender: TObject; var nDone: Boolean) of object;
  //外部事件

  TMultiJSPanel = class(TcxGroupBox)
  private
    FTunnel: TMultiJSPanelTunnel;
    //通道配置
    FData: TMultiJSPanelData;
    //关联数据
    FPerWeight: Word;
    //带重参数
    FStatus: TcxLabel;
    //状态显示
    FCtrlLabel: TcxLabel;
    //控制标签
    FTruckNo: TcxTextEdit;
    //车牌号
    FStockName: TcxTextEdit;
    FStockNo: TcxTextEdit;
    //品种,批次
    FCustomer: TcxTextEdit;
    //客户名称
    FStockValue: TcxTextEdit;
    FStockDS: TcxTextEdit;
    FStockTotalDS: TcxTextEdit;
    //量,袋数
    FProgress: TcxProgressBar;
    //装车进度
    FLockImage: TcxImage;
    //锁定图片
    FBtnLoad: TcxButton;
    FBtnStart: TcxButton;
    FBtnStop: TcxButton;
    //控制按钮
    FOnLoad: TMultiJSEvent;
    FOnStart: TMultiJSEvent;
    FOnStop: TMultiJSEvent;
    FOnDone: TMultiJSEvent;
    //事件相关
  protected
    procedure SetParent(AParent: TWinControl); override;
    //父容器
    procedure UpdateJSStatus(const nStatus: string);
    //计数状态
    procedure UpdateLockStatus(const nLock: Boolean);
    //锁定状态
    procedure OnLockClick(Sender: TObject);
    //锁定点击
    procedure OnEditChange(Sender: TObject);
    //内容变动
    procedure OnBtnClick(Sender: TObject);
    //按钮点击
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //创建释放
    procedure AdjustPostion;
    //校正位置
    class function PanelRect: TRect;
    //面板大小
    procedure SetTunnel(const nTunnel: TMultiJSPanelTunnel);
    procedure SetData(const nData: TMultiJSPanelData);
    //设置数据
    procedure JSProgress(const nHasDone: Integer; const nUp: Boolean = False);
    //装车进度
    property UIData: TMultiJSPanelData read FData;
    property Tunnel: TMultiJSPanelTunnel read FTunnel;
    property PerWeight: Word read FPerWeight write FPerWeight;
    property OnLoad: TMultiJSEvent read FOnLoad write FOnLoad;
    property OnStart: TMultiJSEvent read FOnStart write FOnStart;
    property OnStop: TMultiJSEvent read FOnStop write FOnStop;
    property OnDone: TMultiJSEvent read FOnDone write FOnDone;
    //属性相关
  end;

const
  cSpace_V_Edit = 8;             //垂直方向两行间距
  cSpace_H_Edge = 12;            //水平方向边距
  cSpace_H_LabelEdit = 2;        //水平方向标签与文本框间距
  cSpace_V_LabelEdit = 2;        //垂直方向标签与文本框间距

resourcestring
  sStatus_Idle = '空闲';
  sStatus_Busy = '装车中';
  sStatus_Done = '装车完成';
  
implementation

{$R bmp.res}

//------------------------------------------------------------------------------
constructor TMultiJSPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered := True;
  Transparent := True;

  with PanelRect do
  begin
    Width := Right;
    Height := Bottom;
  end;

  FPerWeight := 50;
  FillChar(FData, SizeOf(FData), #0);
end;

destructor TMultiJSPanel.Destroy;
begin

  inherited;
end;

//Desc: 面板大小
class function TMultiJSPanel.PanelRect: TRect;
begin
  Result := Rect(0, 0, 275, 372);
end;

//Desc: 标签组
procedure LabelGroup(const nP: TcxControl; var nL,nT: Integer; const nLable: string;
  const nEdit: TcxTextEdit; const nProgress: TcxProgressBar = nil);
begin
  with TcxLabel.Create(nP) do
  begin
    Parent := nP;
    Left := nL;
    Top := nT + cSpace_V_LabelEdit;

    with Style do
    begin
      TextColor := clBlack;
    end;

    Caption := nLable;
    AutoSize := True;
    Transparent := True;
    nL := Left + Width + cSpace_H_LabelEdit;
  end;

  if Assigned(nEdit) then
  with nEdit do
  begin
    Parent := nP;
    Left := nL;
    Top := nT;

    Text := '';
    Properties.ReadOnly := True;

    with Style do
    begin
      Edges := [bBottom];
      TextColor := $00408000; 
    end;

    with StyleFocused do
    begin
      Color := clInfoBk;
      TextColor := $00408000;
    end;

    nL := cSpace_H_Edge;
    nT := nT + Height + cSpace_V_Edit;
  end;

  if Assigned(nProgress) then
  with nProgress do
  begin
    Parent := nP;
    Left := nL;
    Top := nT;

    with Properties do
    begin
      Text := '0/0';
      ShowTextStyle := cxtsText;

      AnimationSpeed := 1;
      BarStyle := cxbsAnimation;
      BeginColor := $008080FF;
    end;

    with Style do
    begin
      Edges := [];
      TextColor := clWhite;
    end;

    nL := cSpace_H_Edge;
    nT := nT + Height + cSpace_V_Edit;
  end;
end;

//Desc: 按钮组
procedure BtnGroup(const nP: TcxControl; var nL,nT: Integer; const nBtn: TcxButton;
  const nText: string; const nResour: string = '');
begin
  with nBtn do
  begin
    Parent := nP;
    Left := nL;
    Top := nT;

    Width := 65;
    Height := 25;

    Caption := nText;
    if nResour <> '' then
      Glyph.LoadFromResourceName(HInstance, nResour);
    //xxxx

    nL := cSpace_H_Edge;
    nT := Top + Height + cSpace_V_Edit;
  end;
end;

procedure TMultiJSPanel.SetParent(AParent: TWinControl);
var nL,nT: Integer;
begin
  inherited SetParent(AParent);
  if csDestroying in ComponentState then Exit;

  FStatus := TcxLabel.Create(Self);
  //状态标签
  with FStatus do
  begin
    Parent := Self;
    Align := alTop;

    AutoSize := False;
    Height := 45;
    UpdateJSStatus(sStatus_Idle);
    
    with Properties do
    begin
      Alignment.Horz := taCenter;
      Alignment.Vert := taVCenter;

      LabelStyle := cxlsRaised;
      LineOptions.Alignment := cxllaBottom;
      LineOptions.Visible := True;
    end;

    with Style do
    begin
      Font.Size := 22;
      TextColor := clBlack;
    end;

    Transparent := True;
    nL := cSpace_H_Edge;
    nT := Top + FStatus.Height + cSpace_V_Edit;
  end;

  //----------------------------------------------------------------------------
  FTruckNo := TcxTextEdit.Create(Self);
  LabelGroup(Self, nL, nT, '车牌号码:', FTruckNo);

  FStockName := TcxTextEdit.Create(Self);
  LabelGroup(Self, nL, nT, '品种名称:', FStockName);

  FStockNo := TcxTextEdit.Create(Self);
  LabelGroup(Self, nL, nT, '批次编号:', FStockNo);

  FCustomer := TcxTextEdit.Create(Self);
  LabelGroup(Self, nL, nT, '客户名称:', FCustomer);
  
  FLockImage := TcxImage.Create(Self);
  with FLockImage do
  begin
    Parent := Self;
    Top := nT;          
    AutoSize := True;

    Transparent := True;
    Properties.GraphicTransparency := gtTransparent;

    Style.Edges := [];
    OnClick := OnLockClick;

    UpdateLockStatus(True);
    nT := nT + FLockImage.Height + 1;
  end;

  FStockValue := TcxTextEdit.Create(Self);
  FStockValue.Properties.OnChange := OnEditChange;
  LabelGroup(Self, nL, nT, '提货(吨):', FStockValue);

  FStockDS := TcxTextEdit.Create(Self);
  FStockDS.Properties.OnChange := OnEditChange;
  LabelGroup(Self, nL, nT, '应提袋数:', FStockDS);

  FStockTotalDS := TcxTextEdit.Create(Self);
  LabelGroup(Self, nL, nT, '合计已装:', FStockTotalDS);

  FProgress := TcxProgressBar.Create(Self);
  LabelGroup(Self, nL, nT, '装车进度:', nil, FProgress);

  //----------------------------------------------------------------------------
  FCtrlLabel := TcxLabel.Create(Self);
  //控制标签
  with FCtrlLabel do
  begin
    Parent := Self;
    Left := nL;
    Top := nT;

    AutoSize := False;
    Height := 22;
    Caption := '控制';

    with Properties do
    begin
      Alignment.Horz := taCenter;
      Alignment.Vert := taVCenter;

      LabelStyle := cxlsRaised;
      LineOptions.Alignment := cxllaCenter;
      LineOptions.Visible := True;
    end;

    with Style do
    begin
      TextColor := clBlack;
    end;  

    Transparent := True;
    nL := cSpace_H_Edge;
    nT := Top + Height;
  end;

  FBtnLoad := TcxButton.Create(Self);
  FBtnLoad.OnClick := OnBtnClick;
  BtnGroup(Self, nL, nT, FBtnLoad, '载入', 'load');
  nT := FBtnLoad.Top;

  FBtnStart := TcxButton.Create(Self);
  FBtnStart.Enabled := False;
  FBtnStart.OnClick := OnBtnClick; 
  BtnGroup(Self, nL, nT, FBtnStart, '启动', 'run');
  nT := FBtnStart.Top;
  
  FBtnStop := TcxButton.Create(Self);
  FBtnStop.Enabled := False;
  FBtnStop.OnClick := OnBtnClick;
  BtnGroup(Self, nL, nT, FBtnStop, '停止', 'stop');
end;

//Desc: 依据面板大小调整位置
procedure TMultiJSPanel.AdjustPostion;
var nL,nW: Integer;
    nCtrl: TcxControl;
begin
  for nL:=ControlCount - 1 downto 0 do
  if (Controls[nL] is TcxTextEdit) or (Controls[nL] is TcxProgressBar) then
  begin
    nCtrl := Controls[nL] as TcxControl;
    nCtrl.Width := ClientRect.Right - cSpace_H_Edge - nCtrl.Left;
  end; //文本框等

  FLockImage.Left := ClientRect.Right - cSpace_H_Edge - FLockImage.Width;
  //锁定图片

  FCtrlLabel.Left := ClientRect.Left + 2;
  FCtrlLabel.Width := ClientWidth - 4;
  //控制标签

  nW := FBtnLoad.Width + FBtnStart.Width + FBtnStop.Width + cSpace_H_Edge * 3;
  nL := Trunc((ClientWidth - nW) / 2);

  FBtnLoad.Left := nL;
  nL := nL + FBtnLoad.Width + cSpace_H_Edge;

  FBtnStart.Left := nL;
  nL := nL + FBtnStart.Width;
  FBtnStop.Left := nL + cSpace_H_Edge;
end;

//Desc: 设置数据
procedure TMultiJSPanel.SetData(const nData: TMultiJSPanelData);
var nVal: Double;
begin
  if nData.FRecordID <> FData.FRecordID then
  begin
    FData := nData;  
    FTruckNo.Text := FData.FTruckNo;
    FCustomer.Text := FData.FCustomer;

    FStockName.Text := FData.FStockName;
    FStockNo.Text := FData.FStockNo;

    if FData.FHaveDai < 1 then
    begin
      nVal := FData.FTHValue * 1000;
      FData.FHaveDai := Trunc(nVal / FPerWeight);
    end;
    
    FData.FHasDone := 0;
    JSProgress(0, True);
    UpdateJSStatus(sStatus_Idle);
    
    if FData.FTotalBC > 0 then
      FData.FIsBC := True;
    UpdateLockStatus(not FData.FIsBC);
  end;
end;

//Desc: 设置通道
procedure TMultiJSPanel.SetTunnel(const nTunnel: TMultiJSPanelTunnel);
begin
  if FTunnel.FStatus <> sStatus_Busy then
  begin
    FTunnel := nTunnel;
    Caption := '名称:【' + FTunnel.FPanelName + '】';
  end;
end;

//Desc: 更新计数状态
procedure TMultiJSPanel.UpdateJSStatus(const nStatus: string);
begin
  FStatus.Caption := nStatus;
  FTunnel.FStatus := nStatus;

  if nStatus = sStatus_Idle then
  begin
    with FStatus.Properties do
    begin
      Depth := 7;
      LabelEffect := cxleNormal;
      LabelStyle := cxlsLowered;
    end;

    with FStatus.Style do
    begin
      TextColor := clBlack;
      Font.Style := Font.Style - [fsBold];
    end;
  end else
  begin
    with FStatus.Properties do
    begin
      Depth := 7;
      LabelEffect := cxleFun;
      LabelStyle := cxlsLowered;
      ShadowedColor := clGray;
    end;

    with FStatus.Style do
    begin
      TextColor := clGreen;
      Font.Style := Font.Style + [fsBold];
    end;
  end;
end;

//Desc: 更新锁定状态
procedure TMultiJSPanel.UpdateLockStatus(const nLock: Boolean);
begin
  if Assigned(FStockDS) then FStockDS.Properties.ReadOnly := nLock;
  if Assigned(FStockValue) then FStockValue.Properties.ReadOnly := nLock;

  if nLock then
       FLockImage.Picture.Bitmap.LoadFromResourceName(HInstance, 'lock')
  else FLockImage.Picture.Bitmap.LoadFromResourceName(HInstance, 'unlock');
end;

//Desc: 切换手动袋数
procedure TMultiJSPanel.OnLockClick(Sender: TObject);
var nStr: string;
    nBool: Boolean;
begin
  if FTunnel.FStatus = sStatus_Busy then Exit;
  nBool := FStockDS.Properties.ReadOnly;

  if nBool then
       nStr := '确定要手工输入提货袋数吗?'
  else nStr := '确定要关闭手工输入袋数吗?';

  if QueryDlg(nStr, '询问') then
  begin
    if nBool then
         nBool := False
    else nBool := True;
  end;

  FStockDS.SetFocus;
  UpdateLockStatus(nBool);
end;

//Desc: 提货与袋数相互切换
procedure TMultiJSPanel.OnEditChange(Sender: TObject);
var nVal: Double;
    nEdit: TcxTextEdit;
begin
  if not (Sender is TcxTextEdit) then Exit;
  nEdit := Sender as TcxTextEdit;

  if nEdit.IsFocused and IsNumber(nEdit.Text, nEdit = FStockValue) then
  begin
    if nEdit = FStockValue then
    begin
      nVal := StrToFloat(nEdit.Text)  * 1000;
      FStockDS.Text := Format('%d', [Trunc(nVal / FPerWeight)]);
    end else

    if nEdit = FStockDS then
    begin
      //nVal := (StrToInt(nEdit.Text) * FPerWeight) / 1000;
      //FStockValue.Text := Format('%.2f', [nVal]);
    end;

    FData.FTHValue := StrToFloat(FStockValue.Text);
    FData.FHaveDai := StrToInt(FStockDS.Text);      
    FData.FHasDone := 0;
    JSProgress(-1, True);
  end;
end;

//Desc: 按钮点击
procedure TMultiJSPanel.OnBtnClick(Sender: TObject);
var nBool: Boolean;
begin
  if Sender = FBtnLoad then
  begin
    nBool := True;
    if Assigned(FOnLoad) then FOnLoad(Self, nBool);
    FBtnStart.Enabled := nBool;
  end else

  if Sender = FBtnStart then
  begin
    if FData.FHasDone >= FData.FHaveDai then
    begin
      ShowMsg('本次提货已完成', '提示'); Exit;
    end;

    nBool := True;
    if Assigned(FOnStart) then FOnStart(Self, nBool);

    if nBool then
    begin
      FBtnLoad.Enabled := False;
      FBtnStart.Enabled := False;
      FBtnStop.Enabled := True;

      UpdateJSStatus(sStatus_Busy);
      UpdateLockStatus(True);
    end;
  end else

  if Sender = FBtnStop then
  begin
    if not QueryDlg('确定要停止装车吗?', '') then Exit;
    //query action

    nBool := True;
    if Assigned(FOnStop) then FOnStop(Self, nBool);

    if nBool then
    begin
      FBtnLoad.Enabled := True;
      FBtnStart.Enabled := True;
      FBtnStop.Enabled := False;
      UpdateJSStatus(sStatus_Idle);

      with FData do
      if FHasDone > 0 then
      begin
        FHaveDai := FHaveDai - FHasDone;
        FTHValue := FHaveDai * FPerWeight / 1000;
        
        FHasDone := 0;
        JSProgress(0, True);

        nBool := True;
        if Assigned(FOnDone) then FOnDone(Self, nBool);
      end;
    end;
  end;
end;

//Desc: 设置进度
procedure TMultiJSPanel.JSProgress(const nHasDone: Integer; const nUp: Boolean);
var nInt: Integer;
    nBool: Boolean;
begin
  with FProgress,FData do
  begin
    if nUp then
    begin
      Properties.Min := 0;
      Properties.Max := FHaveDai;

      if nHasDone <> -1 then
      begin
        FStockDS.Text := IntToStr(FHaveDai);
        FStockValue.Text := Format('%.2f', [FTHValue]);
      end;

      FStockTotalDS.Text := IntToStr(FTotalDS + FTotalBC);
      //count total
    end;

    if (UIData.FRecordID = '') and (nHasDone > 0) then
    begin
      FStatus.Caption := IntToStr(nHasDone);
      Exit;
    end;

    if FStatus.Caption <> sStatus_Busy then Exit;
    //action only running
  
    Position := nHasDone;
    Properties.Text := Format('%d/%d', [nHasDone, FHaveDai]);

    nInt := nHasDone - FHasDone; //本次装车袋数
    if nInt < 1 then Exit;
    FHasDone := nHasDone;

    if FIsBC then
         FTotalBC := FTotalBC + nInt
    else FTotalDS := FTotalDS + nInt;

    FStockTotalDS.Text := IntToStr(FTotalDS + FTotalBC);
    //应提 + 补差

    if FHasDone >= FHaveDai then
    begin
      nBool := True;
      if Assigned(FOnDone) then FOnDone(Self, nBool);

      if nBool then
      begin
        FBtnLoad.Enabled := True;
        FBtnStart.Enabled := True;
        FBtnStop.Enabled := False;

        FData.FIsBC := True;
        UpdateJSStatus(sStatus_Done);
        UpdateLockStatus(False);
      end;
    end;
  end;
end;

end.
