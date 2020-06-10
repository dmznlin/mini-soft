{*******************************************************************************
  ����: dmzn@163.com 2011-4-29
  ����: ���������
*******************************************************************************}
unit UFormJS_Net;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormBase, UMultiJSCtrl, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxStatusBar,
  {$IFDEF MultiReplay}UMultiJS_Reply{$ELSE}UMultiJS_Net{$ENDIF};

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
    //����ͼ
    FPerWeight: Word;
    //����
    FLoadPanels: Boolean;
    //������
    FTunnels: array of TMultiJSPanelTunnel;
    //װ����
    procedure LoadTunnelList;
    //���복��
    procedure OnData(const nTunnel: PMultiJSTunnel);
    //��������
    procedure DoOnLoad(Sender: TObject; var nDone: Boolean);
    procedure DoOnStart(Sender: TObject; var nDone: Boolean);
    procedure DoOnStop(Sender: TObject; var nDone: Boolean);
    procedure DoOnDone(Sender: TObject; var nDone: Boolean);
    //��尴ť
  protected
    procedure EnableChanged(var Msg: TMessage); message WM_ENABLE;
    procedure CreateParams(var Params : TCreateParams); override;
    //������
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
  //ȫ��ʹ��

class function TfFormJS_Net.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  if not Assigned(gForm) then
  begin
    gForm := TfFormJS_Net.Create(Application);
    with gForm do
    begin
      Caption := '��������̨';
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

//Desc: ������ͼ��
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

//Desc: �������
procedure TfFormJS_Net.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  VertScrollBar.Position := VertScrollBar.Position - WheelDelta;
end;

//------------------------------------------------------------------------------
//Desc: ��ȡ��Ч��ջ����
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
    if Pos(nKey, gSysParam.FHintText) < 1 then Exit; //��˾����
  end else Exit;

  nStr := 'Select D_Value,D_ParamB From %s Where D_Name=''%s'' And D_Memo=''%s''';;
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ValidDate]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nStr := Format('dmzn_js_%s_%s', [nKey, Date2Str(Fields[0].AsDateTime)]);
    nStr := MD5Print(MD5String(nStr));
    if nStr <> Fields[1].AsString then Exit; //ϵͳ��Ч��

    nInt := Trunc(Fields[0].AsDateTime - Date());
    if nInt < 1 then
    begin
      Result := 0;
      ShowDlg('ϵͳ�ѹ���,����ϵ����Ա!', sHint); Exit;
    end;

    if nInt < 7 then
    begin
      nStr := Format('ϵͳ���� %d �쵽��', [nInt]);
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
    if nStr = Fields[1].AsString then Result := Fields[0].AsInteger; //װ������
  end;
end;

//Desc: ���복���б�
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

//Desc: ���µ��������λ��
procedure TfFormJS_Net.WorkPanelResize(Sender: TObject);
var i,nCount,nL,nT: Integer;
    nInt,nIdx,nNum,nFixL: Integer;
begin
  if not FLoadPanels then Exit;
  //û�������
  if Length(FTunnels) < 1 then Exit;
  //û�����

  with TMultiJSPanel.PanelRect do
  begin
    HorzScrollBar.Position := 0;
    VertScrollBar.Position := 0;

    nInt := Right + cSpace_H_Edge;
    nNum := Trunc((ClientWidth - cSpace_H_Edge) / nInt);

    nIdx := Length(FTunnels);
    if nNum > nIdx then nNum := nIdx;
    if nNum < 1 then nNum := 1;
    //ÿ�������

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
    //�������

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

//Desc: �������
procedure TfFormJS_Net.FormShow(Sender: TObject);
begin
  if not FLoadPanels then
  try
    ShowWaitForm(Application.MainForm, '��ʼ��װ����');
    FPerWeight := GetWeightPerPackage;
    LoadTunnelList;

    FLoadPanels := True;

  finally
    CloseWaitForm;
  end;
end;

//Desc: ���Ʊ���
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
//Desc: �յ�����
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

//Desc: �������
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

         nStr := '����[ %s ]����[ %s ],Ҫ������?';
         nStr := Format(nStr, [UIData.FTruckNo, Tunnel.FPanelName]); 

         if not QueryDlg(nStr, sAsk, Handle) then
         begin
           nDone := (Sender as TMultiJSPanel).UIData.FRecordID <> '';
           Exit;
         end;
       end;
    //forbid multi load

    with (Sender as TMultiJSPanel) do
    begin
      SetData(nData);
      {$IFDEF MultiReplay}
      gMultiJSManager.AddJS(Tunnel.FComm, UIData.FTruckNo, '', UIData.FHaveDai, True);
      {$ELSE}
      gMultiJSManager.AddJS(Tunnel.FComm, UIData.FTruckNo, UIData.FHaveDai, True);
      {$ENDIF}
    end;
  end;
end;

//Desc: ��ʼ����
procedure TfFormJS_Net.DoOnStart(Sender: TObject; var nDone: Boolean);
begin
  with Sender as TMultiJSPanel do
  begin
    {$IFDEF MultiReplay}
    gMultiJSManager.AddJS(Tunnel.FComm, UIData.FTruckNo, '', UIData.FHaveDai);
    {$ELSE}
    gMultiJSManager.AddJS(Tunnel.FComm, UIData.FTruckNo, UIData.FHaveDai);
    {$ENDIF}
  end;
end;

//Desc: ֹͣ����
procedure TfFormJS_Net.DoOnStop(Sender: TObject; var nDone: Boolean);
begin
  DoOnDone(Sender, nDone);
end;

//Desc: װ�����
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
