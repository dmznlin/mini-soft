{*******************************************************************************
  作者: dmzn@163.com 2013-3-7
  描述: 设备设置面板
*******************************************************************************}
unit UFrameSetDevice;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, USysProtocol, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Menus,
  cxTextEdit, StdCtrls, cxButtons, cxLabel, cxGroupBox;

type
  TfFrameDevice = class(TfFrameBase)
    cxLabel1: TcxLabel;
    BtnAdd: TcxButton;
    BtnEdit: TcxButton;
    BtnDel: TcxButton;
    EditName: TcxTextEdit;
    Label1: TLabel;
    EditIndex: TcxTextEdit;
    Label2: TLabel;
    EditSerial: TcxTextEdit;
    Label3: TLabel;
    EditCarriage: TcxTextEdit;
    Label4: TLabel;
    EditCarType: TcxTextEdit;
    Label5: TLabel;
    Label6: TLabel;
    EditPort: TcxTextEdit;
    GroupBreakPipe: TcxGroupBox;
    BtnBreakPipeMin: TcxButton;
    BtnBtnBreakPipeMax: TcxButton;
    GroupBreakPot: TcxGroupBox;
    BtnBreakPotMin: TcxButton;
    BtnBreakPotMax: TcxButton;
    GroupTotalPipe: TcxGroupBox;
    BtnTotalPipeMin: TcxButton;
    BtnTotalPipeMax: TcxButton;
    GroupOther: TcxGroupBox;
    BtnLocate: TcxButton;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnBreakPipeMinClick(Sender: TObject);
    procedure BtnBtnBreakPipeMaxClick(Sender: TObject);
    procedure BtnLocateClick(Sender: TObject);
  private
    { Private declarations }
    FPort: PCOMParam;
    FDev: PDeviceItem;
    procedure SetControlEnable(nParent: TWinControl;const nEnable: Boolean);
  public
    { Public declarations }
    class function FrameID: integer; override;
    function DealCommand(Sender: TObject; const nCmd: integer;
      const nParamA: Pointer; const nParamB: Integer): integer; override;
    //deal method
  end;

implementation

{$R *.dfm}

uses
  UMgrControl, UMgrConnection, ULibFun, UFormBase, UFormWait, USysConst;

class function TfFrameDevice.FrameID: integer;
begin
  Result := cFI_FrameSetDevice;
end;

function TfFrameDevice.DealCommand(Sender: TObject; const nCmd: integer;
  const nParamA: Pointer; const nParamB: Integer): integer;
var nIdx: Integer;
begin
  Result := S_OK;
  if nCmd <> cCmd_ViewDeviceData then Exit;

  FPort := nParamA;
  FDev := Pointer(nParamB);

  EditIndex.Text := IntToStr(FDev.FIndex);
  EditSerial.Text := FDev.FSerial;

  if FDev.FDeviceUsed then
  begin
    EditName.Text := FPort.FName;
    EditPort.Text := FPort.FPortName;
    EditCarriage.Text := FDev.FCarriage.FName;
    EditCarType.Text := FDev.FCarriage.FTypeName;
  end else
  begin
    EditName.Text := 'N/A';
    EditPort.Text := 'N/A';
    EditCarriage.Text := 'N/A';
    EditCarType.Text := 'N/A';
  end;

  for nIdx:=0 to ControlCount - 1 do
   if Controls[nIdx] is TcxGroupBox then
    SetControlEnable(Controls[nIdx] as TcxGroupBox, FDev.FDeviceUsed);
  //check valid
end;

procedure TfFrameDevice.SetControlEnable(nParent: TWinControl;
  const nEnable: Boolean);
var nIdx: Integer;
begin
  for nIdx:=0 to nParent.ControlCount - 1 do
    nParent.Controls[nIdx].Enabled := nEnable;
  //xxxxx
end;

procedure TfFrameDevice.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if CheckDBConnection then
  begin
    nParam.FCommand := cCmd_AddData;
    nParam.FParamA := Integer(FPort);
    CreateBaseFormItem(cFI_FormDevice, '', @nParam);

    if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
      BroadcastFrameCommand(Self, cCmd_RefreshDevList);
    //xxxxx
  end;
end;

procedure TfFrameDevice.BtnEditClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if CheckDBConnection then
  begin
    nParam.FCommand := cCmd_EditData;
    nParam.FParamA := Integer(FPort);
    nParam.FParamB := Integer(FDev);
    CreateBaseFormItem(cFI_FormDevice, '', @nParam);

    if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
      BroadcastFrameCommand(Self, cCmd_RefreshDevList);
    //xxxxx
  end;
end;

procedure TfFrameDevice.BtnDelClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if CheckDBConnection then
  begin
    nParam.FCommand := cCmd_DeleteData;
    nParam.FParamA := Integer(FDev);
    CreateBaseFormItem(cFI_FormDevice, '', @nParam);

    if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
      BroadcastFrameCommand(Self, cCmd_RefreshDevList);
    //xxxxx
  end;
end;

procedure TfFrameDevice.BtnBreakPipeMinClick(Sender: TObject);
var nStr: string;
    nCMD: Byte;
    nInit: Int64;
    nData: TDataBytes;
begin
  nStr := '确定要设置[ %s:%d ]的压力零点吗?';
  nStr := Format(nStr, [FPort.FPortName, FDev.FIndex]);
  if not QueryDlg(nStr, sAsk) then Exit;

  nInit := GetTickCount ;
  (Sender as TcxButton).Enabled := False;
  try
    ShowWaitForm(ParentForm, '设置压力零点', True);
    SetLength(nData, 0);

    case (Sender as TComponent).Tag of
     10: nCMD := cFun_BreakPipeMin;
     20: nCMD := cFun_BreakPotMin;
     30: nCMD := cFun_TotalPipeMin else Exit;
    end;

    if gPortManager.DeviceCommand(FPort.FPortName, FDev.FIndex, nCMD, nData,
     nStr) then
         ShowMsg('操作完成', sHint)
    else ShowMsg(nStr, sHint);
  finally
    if GetTickCount - nInit < 500 then Sleep(500);
    (Sender as TcxButton).Enabled := True;        
    CloseWaitForm;
  end;
end;

procedure TfFrameDevice.BtnBtnBreakPipeMaxClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  case (Sender as TComponent).Tag of
   10: nParam.FCommand := cFun_BreakPipeMax;
   20: nParam.FCommand := cFun_BreakPotMax;
   30: nParam.FCommand := cFun_TotalPipeMax else Exit;
  end;

  nParam.FParamA := Integer(FPort);
  nParam.FParamB := Integer(FDev);
  CreateBaseFormItem(cFI_FormPressMax, '', @nParam);
end;

procedure TfFrameDevice.BtnLocateClick(Sender: TObject);
var nStr: string;
    nInit: Int64;
    nData: TDataBytes;
begin
  nStr := '确定要定位[ %s:%d ]的设备吗?';
  nStr := Format(nStr, [FPort.FPortName, FDev.FIndex]);
  if not QueryDlg(nStr, sAsk) then Exit;

  nInit := GetTickCount;
  try
    BtnLocate.Enabled := False;
    ShowWaitForm(ParentForm, '定位中', True);
    SetLength(nData, 0);

    if gPortManager.DeviceCommand(FPort.FPortName, FDev.FIndex, cFun_DevLocate,
     nData, nStr) then
         ShowMsg('操作完成', sHint)
    else ShowMsg(nStr, sHint);
  finally
    if GetTickCount - nInit < 500 then Sleep(500);
    BtnLocate.Enabled := True;                    
    CloseWaitForm;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameDevice, TfFrameDevice.FrameID);
end.
