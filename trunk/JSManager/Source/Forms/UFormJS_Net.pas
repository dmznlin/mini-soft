{*******************************************************************************
  作者: dmzn@163.com 2011-4-29
  描述: 多道计数器
*******************************************************************************}
unit UFormJS_Net;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormBase, UMultiJS_Net, UMultiJSCtrl, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxStatusBar;

type
  TfFormJS_Net = class(TBaseForm)
    dxStatusBar1: TdxStatusBar;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure WorkPanelResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
    FBGImage: TBitmap;
    //背景图
    FPerWeight: Word;
    //袋重
    FLoadPanels: Boolean;
    //载入标记
    FTunnels: array of TMultiJSPanelTunnel;
    //装车道
    procedure LoadTunnelList;
    //载入车道
    procedure OnData(const nTunnel: PMultiJSTunnel);
    //计数数据
    procedure DoOnLoad(Sender: TObject; var nDone: Boolean);
    procedure DoOnStart(Sender: TObject; var nDone: Boolean);
    procedure DoOnStop(Sender: TObject; var nDone: Boolean);
    procedure DoOnDone(Sender: TObject; var nDone: Boolean);
    //面板按钮
  protected
    procedure EnableChanged(var Msg: TMessage); message WM_ENABLE;
    procedure CreateParams(var Params : TCreateParams); override;
    //任务栏
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UMgrControl, UDataModule, USysConst, UFormWait,
  UFormZTParam_M, UFormJSTruck_M, USysDB, USysGrid, ZnMD5;

var
  gForm: TfFormJS_Net;
  //全局使用

class function TfFormJS_Net.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  if not Assigned(gForm) then
  begin
    gForm := TfFormJS_Net.Create(Application);
    with gForm do
    begin
      Caption := '计数控制台';
      //FormStyle := fsStayOnTop;
      Position := poDesigned;
    end;
  end;

  with gForm do
  begin
    if not Showing then Show;
    WindowState := wsNormal;
  end;
end;

class function TfFormJS_Net.FormID: integer;
begin
  Result := cFI_FormJSForm;
end;

procedure TfFormJS_Net.FormCreate(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  DoubleBuffered := True;
  FLoadPanels := False;
  FBGImage := nil;

  gMultiJSManager.ChangeSync := OnData;
  gMultiJSManager.StartJS;
  //for net_mode js manager

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    nStr := nIni.ReadString(Name, 'BGImage', '');
    nStr := MacroValue(nStr, [MI('$Path/', gPath)]);

    if FileExists(nStr) then
    begin
      FBGImage := TBitmap.Create;
      FBGImage.LoadFromFile(nStr);
    end;
  finally
    nIni.Free;
  end;
end;

procedure TfFormJS_Net.FormClose(Sender: TObject; var Action: TCloseAction);
var nIdx: Integer;
begin
  for nIdx:=ControlCount - 1 downto 0 do
   if Controls[nIdx] is TMultiJSPanel then
    if (Controls[nIdx] as TMultiJSPanel).Tunnel.FStatus = sStatus_Busy then
  begin
    Action := caMinimize; Exit;
  end;

  gMultiJSManager.StopJS;
  //stop it

  SaveFormConfig(Self);
  FBGImage.Free;
  
  Action := caFree;
  gForm := nil;
end;

//Desc: 任务栏图标
procedure TfFormJS_Net.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := GetDesktopWindow;
  //Params.ExStyle := Params.ExStyle or WS_EX_TOOLWINDOW;
end;

procedure TfFormJS_Net.EnableChanged(var Msg: TMessage);
begin
  inherited;
  if not Active then
    EnableWindow(Handle, True);
  //has mouse focus
end;

//Desc: 处理鼠标
procedure TfFormJS_Net.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  VertScrollBar.Position := VertScrollBar.Position - WheelDelta;
end;

//------------------------------------------------------------------------------
//Desc: 获取有效的栈道数
function GetTunnelCount: Integer;
var nInt: Integer;
    nStr,nKey: string;
begin
  Result := 1;
  nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';;
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_KeyName]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nKey := Fields[0].AsString;
    if Pos(nKey, gSysParam.FHintText) < 1 then Exit; //公司名称
  end else Exit;

  nStr := 'Select D_Value,D_ParamB From %s Where D_Name=''%s'' And D_Memo=''%s''';;
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ValidDate]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nStr := Format('dmzn_js_%s_%s', [nKey, Date2Str(Fields[0].AsDateTime)]);
    nStr := MD5Print(MD5String(nStr));
    if nStr <> Fields[1].AsString then Exit; //系统有效期

    nInt := Trunc(Fields[0].AsDateTime - Date());
    if nInt < 1 then
    begin
      Result := 0;
      ShowDlg('系统已过期,请联系管理员!', sHint); Exit;
    end;

    if nInt < 7 then
    begin
      nStr := Format('系统还有 %d 天到期', [nInt]);
      ShowMsg(nStr, sHint);
    end;
  end else Exit;

  nStr := 'Select D_Value,D_ParamB From %s Where D_Name=''%s'' And D_Memo=''%s''';;
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_Tunnel]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nStr := Format('dmzn_js_%s_%s', [nKey, Fields[0].AsString]);
    nStr := MD5Print(MD5String(nStr));
    if nStr = Fields[1].AsString then Result := Fields[0].AsInteger; //装车道数
  end;
end;

//Desc: 载入车道列表
procedure TfFormJS_Net.LoadTunnelList;
var i,nIdx,nLen: Integer;
    nHost: PMultiJSHost;
    nTunnel: PMultiJSTunnel;
begin
  SetLength(FTunnels, 0);
  for i:=0 to gMultiJSManager.Hosts.Count - 1 do
  begin
    nHost := gMultiJSManager.Hosts[i];
    for nIdx:=0 to nHost.FTunnel.Count - 1 do
    begin
      nLen := Length(FTunnels);
      SetLength(FTunnels, nLen + 1);
      FillChar(FTunnels[nLen], SizeOf(TMultiJSPanelTunnel), #0);

      nTunnel := nHost.FTunnel[nIdx];
      with FTunnels[nLen] do
      begin
        FPanelName := nTunnel.FName;
        FComm := nTunnel.FID;
        FTunnel := nTunnel.FTunnel;
        FDelay := nTunnel.FDelay;
      end;
    end;
  end;

  i := Length(FTunnels);
  nLen := GetTunnelCount;

  if i < nLen then
    nLen := i;
  SetLength(FTunnels, nLen);

  nLen := High(FTunnels);
  if nLen < 0 then Exit;

  for i:=Low(FTunnels) to nLen do
  begin
    with TMultiJSPanel.Create(Self) do
    begin
      Parent := Self;
      OnLoad := DoOnLoad;
      OnStart := DoOnStart;
      OnStop := DoOnStop;
      OnDone := DoOndone;

      PerWeight := FPerWeight;
      AdjustPostion;
      SetTunnel(FTunnels[i]);
    end;
  end;
end;

//Desc: 重新调整个组件位置
procedure TfFormJS_Net.WorkPanelResize(Sender: TObject);
var i,nCount,nL,nT: Integer;
    nInt,nIdx,nNum,nFixL: Integer;
begin
  if not FLoadPanels then Exit;
  //没创建完毕
  if Length(FTunnels) < 1 then Exit;
  //没有组件

  with TMultiJSPanel.PanelRect do
  begin
    HorzScrollBar.Position := 0;
    VertScrollBar.Position := 0;

    nInt := Right + cSpace_H_Edge;
    nNum := Trunc((ClientWidth - cSpace_H_Edge) / nInt);

    nIdx := Length(FTunnels);
    if nNum > nIdx then nNum := nIdx;
    if nNum < 1 then nNum := 1;
    //每行面板数

    nInt := nInt * nNum;
    if (ClientWidth - cSpace_H_Edge) <= nInt then
    begin
      nFixL := cSpace_H_Edge;
    end else //fill form
    begin
      nInt := (ClientWidth + cSpace_H_Edge) - nInt;
      nFixL := Trunc(nInt / 2) ;
    end; //center form

    nCount := Length(FTunnels);
    i := Trunc(nCount / nNum);
    if nCount mod nNum <> 0 then Inc(i);
    //面板行数

    nInt := (Bottom + cSpace_H_Edge) * i;
    if (ClientHeight - cSpace_H_Edge) <= nInt then
    begin
      nT := cSpace_H_Edge;
    end else //fill form
    begin
      nInt := ClientHeight - nInt;
      nT := Trunc(nInt / 2);
    end; //center form
  end;

  nIdx := 0;
  nL := nFixL;
  nCount := ControlCount - 1;

  for i:=0 to nCount do
  begin
    if not (Controls[i] is TMultiJSPanel) then Continue;
    //only jspanel

    Controls[i].Left := nL;
    Controls[i].Top := nT;

    nL := nL + TMultiJSPanel.PanelRect.Right + cSpace_H_Edge;
    Inc(nIdx);

    if nIdx = nNum then
    begin
      nIdx := 0;
      nL := nFixL;
      nT := nT + TMultiJSPanel.PanelRect.Bottom + cSpace_H_Edge;
    end;
  end;
end;

//Desc: 载入面板
procedure TfFormJS_Net.FormShow(Sender: TObject);
begin
  if not FLoadPanels then
  try
    ShowWaitForm(Application.MainForm, '初始化装车线');
    FPerWeight := GetWeightPerPackage;
    LoadTunnelList;

    FLoadPanels := True;

  finally
    CloseWaitForm;
  end;
end;

//Desc: 绘制背景
procedure TfFormJS_Net.FormPaint(Sender: TObject);
var nX,nY: integer;
begin
  if Assigned(FBGImage) and (FBGImage.Width > 0) then
  begin
    nX := -Random(FBGImage.Width);
    while nX < Width do
    begin
      nY := -Random(FBGImage.Height);

      while nY < Height do
      begin
        Canvas.Draw(nX, nY, FBGImage);
        Inc(nY, FBGImage.Height);
      end;

      Inc(nX, FBGImage.Width);
    end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 收到数据
procedure TfFormJS_Net.OnData(const nTunnel: PMultiJSTunnel);
var nIdx: Integer;
begin
  for nIdx:=ControlCount - 1 downto 0 do
   if Controls[nIdx] is TMultiJSPanel then
    with (Controls[nIdx] as TMultiJSPanel) do
    begin
      if nTunnel.FID <> Tunnel.FComm then Continue;
      if Tunnel.FTunnel = nTunnel.FTunnel then JSProgress(nTunnel.FHasDone);
    end;
end;

//Desc: 载入计数
procedure TfFormJS_Net.DoOnLoad(Sender: TObject; var nDone: Boolean);
var nStr: string;
    nIdx: Integer;
    nData: TMultiJSPanelData;
begin
  nDone := ShowZTTruckForm(nData, Self);
  if nDone then
  begin
    for nIdx:=ControlCount - 1 downto 0 do
     if Controls[nIdx] is TMultiJSPanel then
      with Controls[nIdx] as TMultiJSPanel do
       if nData.FRecordID = UIData.FRecordID then
       begin
         if Self.Controls[nIdx] = Sender then Exit;
         //self is ignor

         nStr := '车辆[ %s ]已在[ %s ],要继续吗?';
         nStr := Format(nStr, [UIData.FTruckNo, Tunnel.FPanelName]); 

         if not QueryDlg(nStr, sAsk, Handle) then
         begin
           nDone := (Sender as TMultiJSPanel).UIData.FRecordID <> '';
           Exit;
         end;
       end;
    //forbid multi load

    (Sender as TMultiJSPanel).SetData(nData);
  end;
end;

//Desc: 开始计数
procedure TfFormJS_Net.DoOnStart(Sender: TObject; var nDone: Boolean);
begin
  with Sender as TMultiJSPanel do
  begin
    gMultiJSManager.AddJS(Tunnel.FComm, UIData.FTruckNo, UIData.FHaveDai);
  end;
end;

//Desc: 停止计数
procedure TfFormJS_Net.DoOnStop(Sender: TObject; var nDone: Boolean);
begin
  DoOnDone(Sender, nDone);
end;

//Desc: 装车完毕
procedure TfFormJS_Net.DoOnDone(Sender: TObject; var nDone: Boolean);
var nStr: string;
begin
  with Sender as TMultiJSPanel do
  try
    gMultiJSManager.DelJS(Tunnel.FComm);
    //stop js

    nStr := 'Update $TB Set L_DaiShu=$DS,L_BC=$BC,L_ZTLine=''$ZT'',' +
            'L_HasDone=''$Yes'',L_OKTime=''$Now'' Where L_ID=$ID';
    nStr := MacroValue(nStr, [MI('$TB', sTable_JSLog), MI('$Yes', sFlag_Yes),
            MI('$ZT', Tunnel.FPanelName), MI('$DS', IntToStr(UIData.FTotalDS)),
            MI('$BC', IntToStr(UIData.FTotalBC)), MI('$ID', UIData.FRecordID),
            MI('$Now', DateTime2Str(Now))]);
    FDM.ExecuteSQL(nStr);
  except
    //ignor any error
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormJS_Net, TfFormJS_Net.FormID);
end.
