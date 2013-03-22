{*******************************************************************************
  作者: dmzn@163.com 2013-3-7
  描述: 串口设置面板
*******************************************************************************}
unit UFrameSetPort;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, USysProtocol, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Menus,
  cxTextEdit, StdCtrls, cxButtons, cxLabel, cxGroupBox;

type
  TfFramePort = class(TfFrameBase)
    cxLabel1: TcxLabel;
    BtnAdd: TcxButton;
    BtnEdit: TcxButton;
    BtnDel: TcxButton;
    EditName: TcxTextEdit;
    Label1: TLabel;
    EditPort: TcxTextEdit;
    Label2: TLabel;
    EditBaund: TcxTextEdit;
    Label3: TLabel;
    EditData: TcxTextEdit;
    Label4: TLabel;
    EditStop: TcxTextEdit;
    Label5: TLabel;
    cxGroupBox1: TcxGroupBox;
    BtnAddDev: TcxButton;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnAddDevClick(Sender: TObject);
  private
    { Private declarations }
    FPort: PCOMParam;
    //port
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
  UMgrControl, UMgrConnection, ULibFun, UFormBase, UFormWait, CPort,
  CPortTypes, USysConst;

class function TfFramePort.FrameID: integer;
begin
  Result := cFI_FrameSetPort;
end;

function TfFramePort.DealCommand(Sender: TObject; const nCmd: integer;
  const nParamA: Pointer; const nParamB: Integer): integer;
var nInt: Integer;
begin
  Result := S_OK;
  if nCmd <> cCmd_ViewPortData then Exit;

  FPort := nParamA;
  EditName.Text := FPort.FName;
  EditPort.Text := FPort.FPortName;

  nInt := Ord(FPort.FBaudRate);
  if (nInt >= Ord(br110)) and (nInt <= Ord(br256000)) then
       EditBaund.Text := BaudRateToStr(FPort.FBaudRate)
  else EditBaund.Text := 'Error';

  nInt := Ord(FPort.FDataBits);
  if (nInt >= Ord(dbFive)) and (nInt <= Ord(dbEight)) then
       EditData.Text := DataBitsToStr(FPort.FDataBits)
  else EditData.Text := 'Error';

  nInt := Ord(FPort.FStopBits);
  if (nInt >= Ord(sbOneStopBit)) and (nInt <= Ord(sbTwoStopBits)) then
       EditStop.Text := StopBitsToStr(FPort.FStopBits)
  else EditStop.Text := 'Error';
end;

//Desc: 添加
procedure TfFramePort.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if CheckDBConnection then
  begin
    nParam.FCommand := cCmd_AddData;
    CreateBaseFormItem(cFI_FormCOMPort, '', @nParam);

    if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
      BroadcastFrameCommand(Self, cCmd_RefreshDevList);
    //xxxxx
  end;
end;

//Desc: 修改
procedure TfFramePort.BtnEditClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if CheckDBConnection then
  begin
    nParam.FCommand := cCmd_EditData;
    nParam.FParamA := Integer(FPort);
    CreateBaseFormItem(cFI_FormCOMPort, '', @nParam);

    if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
      BroadcastFrameCommand(Self, cCmd_RefreshDevList);
    //xxxxx
  end;
end;

//Desc: 删除
procedure TfFramePort.BtnDelClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if CheckDBConnection then
  begin
    nParam.FCommand := cCmd_DeleteData;
    nParam.FParamA := Integer(FPort);
    CreateBaseFormItem(cFI_FormCOMPort, '', @nParam);

    if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
      BroadcastFrameCommand(Self, cCmd_RefreshDevList);
    //xxxxx
  end;
end;

//Desc: 添加设备
procedure TfFramePort.BtnAddDevClick(Sender: TObject);
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

initialization
  gControlManager.RegCtrl(TfFramePort, TfFramePort.FrameID);
end.
