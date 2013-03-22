{*******************************************************************************
  作者: dmzn@163.com 2013-3-7
  描述: 系统设置面板
*******************************************************************************}
unit UFrameSetSystem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, StdCtrls, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxButtons, cxControls, cxContainer, cxEdit,
  cxLabel, cxGroupBox;

type
  TfFrameSystem = class(TfFrameBase)
    BtnSetDB: TcxButton;
    CheckAutoRun: TCheckBox;
    Label1: TLabel;
    CheckAutoMin: TCheckBox;
    Label2: TLabel;
    BtnSetUI: TcxButton;
    cxLabel1: TcxLabel;
    cxGroupBox1: TcxGroupBox;
    BtnAddPort: TcxButton;
    BtnSetAddr: TcxButton;
    BtnTime: TcxButton;
    BtnParam: TcxButton;
    procedure BtnSetDBClick(Sender: TObject);
    procedure BtnAddPortClick(Sender: TObject);
    procedure BtnSetAddrClick(Sender: TObject);
    procedure BtnTimeClick(Sender: TObject);
    procedure CheckAutoRunClick(Sender: TObject);
    procedure BtnParamClick(Sender: TObject);
    procedure BtnSetUIClick(Sender: TObject);
  protected
    { Protected declarations }
    procedure OnShowFrame; override;
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  UMgrControl, ULibFun, UMgrConnection, UFormWait, UFormBase, USysProtocol,
  USysConst;

class function TfFrameSystem.FrameID: integer;
begin
  Result := cFI_FrameSetSystem;
end;

procedure TfFrameSystem.OnShowFrame;
begin
  CheckAutoRun.Checked := gSysParam.FAutoStart;
  CheckAutoMin.Checked := gSysParam.FAutoMin;
end;

procedure TfFrameSystem.CheckAutoRunClick(Sender: TObject);
begin
  gSysParam.FAutoStart := CheckAutoRun.Checked;
  gSysParam.FAutoMin := CheckAutoMin.Checked;
end;

procedure TfFrameSystem.BtnSetDBClick(Sender: TObject);
begin
  CreateBaseFormItem(cFI_FormSetDB);
end;

procedure TfFrameSystem.BtnAddPortClick(Sender: TObject);
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

procedure TfFrameSystem.BtnSetUIClick(Sender: TObject);
begin
  CreateBaseFormItem(cFI_FormChartStyle);
end;

procedure TfFrameSystem.BtnParamClick(Sender: TObject);
begin
  if CheckDBConnection then
    CreateBaseFormItem(cFI_FormSysParam);
  //xxxxx
end;

procedure TfFrameSystem.BtnSetAddrClick(Sender: TObject);
begin
  CreateBaseFormItem(cFI_FormSetIndex);
end;

//------------------------------------------------------------------------------
//Date: 2013-3-14
//Desc: 获取当前时间
procedure GetNowTime(nData: PByte);
var nStr: string;
    nY,nM,nD,nH,nMin,nS,nMS: Word;
begin
  DecodeDate(Date(), nY, nM, nD);
  DecodeTime(Time(), nH, nMin, nS, nMS);

  nStr := IntToStr(nY);
  System.Delete(nStr, 1, 2);

  nData^ := StrToInt(nStr);
  Inc(nData); nData^ := nM;
  Inc(nData); nData^ := nD;
  Inc(nData); nData^ := nH;
  Inc(nData); nData^ := nMin;
  Inc(nData); nData^ := nS;
end;

//Desc: 校时
procedure TfFrameSystem.BtnTimeClick(Sender: TObject);
var nStr: string;
    i,nIdx: Integer;
    nList: TList;
    nPort: PCOMItem;
    nDev: PDeviceItem;
    nData: TDataBytes;
begin
  nStr := '确定要执行校时吗?';
  if not QueryDlg(nStr, sAsk) then Exit;

  nList := gDeviceManager.LockPortList;
  try
    BtnTime.Enabled := False;
    ShowWaitForm(ParentForm, '校时中', True);    

    for nIdx:=0 to nList.Count - 1 do
    begin
      nPort := nList[nIdx];
      if nPort.FDevices.Count < 1 then Continue;

      nStr := '';
      for i:=0 to nPort.FDevices.Count - 1 do
      begin
        nDev := nPort.FDevices[i];
        nStr := nStr + Char(nDev.FIndex);
      end;

      i := Length(nStr);
      SetLength(nData, i + 6);
      StrPCopy(@nData[0], nStr);

      GetNowTime(@nData[i]);
      //get time

      if not gPortManager.DeviceCommand(nPort.FParam.FPortName, 0, cFun_SetTime,
         nData, nStr) then
      begin
        ShowMsg(nStr, nPort.FParam.FName);
        Exit;
      end;

      ShowMsg('校时完成', sHint);
    end;
  finally
    gDeviceManager.ReleaseLock;
    BtnTime.Enabled := True;
    CloseWaitForm;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameSystem, TfFrameSystem.FrameID);
end.
