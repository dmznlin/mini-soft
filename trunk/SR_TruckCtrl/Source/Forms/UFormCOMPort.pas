{*******************************************************************************
  作者: dmzn@163.com 2013-3-9
  描述: 串口管理
*******************************************************************************}
unit UFormCOMPort;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, UFormBase, USysProtocol, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit,
  cxDropDownEdit, cxLabel, cxTextEdit, dxLayoutControl, StdCtrls;

type
  TfFormPort = class(TfFormNormal)
    EditName: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Item5: TdxLayoutItem;
    cxLabel1: TcxLabel;
    EditBaud: TcxComboBox;
    dxLayout1Item6: TdxLayoutItem;
    EditData: TcxComboBox;
    dxLayout1Item7: TdxLayoutItem;
    EditStop: TcxComboBox;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Item9: TdxLayoutItem;
    EditPort: TcxComboBox;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FPort: PCOMParam;
    procedure InitFormData(const nPort: PCOMParam);
    //init ui
    procedure GetParam(const nPort: PCOMParam);
    function PortAdd: Boolean;
    function PortEdit: Boolean;
    class procedure PortDel(const nPort: PCOMParam);
    //port action
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UMgrCOMM, UFormWait, UFormCtrl, UDataModule, CPort,
  CPortTypes, USysLoger, USysConst, USysDB;

procedure WriteLog(const nMsg: string);
begin
  gSysLoger.AddLog(TfFormPort, '串口设备管理', nMsg);
end;

class function TfFormPort.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  nP := nParam;

  case nP.FCommand of
   cCmd_AddData:
    begin
      with TfFormPort.Create(Application) do
      begin
        Caption := '添加 - 串口';
        FPort := nil;
        InitFormData(nil);

        nP.FCommand := cCmd_ModalResult;
        nP.FParamA := ShowModal;
        Free;
      end;
    end;
   cCmd_EditData:
    begin
      with TfFormPort.Create(Application) do
      begin
        Caption := '修改 - 串口';
        FPort := Pointer(Integer(nP.FParamA));
        InitFormData(FPort);

        nP.FCommand := cCmd_ModalResult;
        nP.FParamA := ShowModal;
        Free;
      end;
    end;
   cCmd_DeleteData:
    begin
      TfFormPort.PortDel(Pointer(Integer(nP.FParamA)));
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := mrOk;
    end;
  end;
end;

class function TfFormPort.FormID: integer;
begin
  Result := cFI_FormCOMPort;
end;

procedure TfFormPort.InitFormData(const nPort: PCOMParam);
var nIdx: Integer;
begin
  GetValidCOMPort(EditPort.Properties.Items);
  EditPort.Properties.Sorted := True;
  //port list
  
  for nIdx:=Ord(br110) to Ord(br256000) do
    EditBaud.Properties.Items.Add(BaudRateToStr(TBaudRate(nIdx)));
  //baud rate

  for nIdx:=Ord(dbFive) to Ord(dbEight) do
    EditData.Properties.Items.Add(DataBitsToStr(TDataBits(nIdx)));
  //data bits

  for nIdx:=Ord(sbOneStopBit) to Ord(sbTwoStopBits) do
    EditStop.Properties.Items.Add(StopBitsToStr(TStopBits(nIdx)));
  //stop bits

  if Assigned(nPort) then
  begin
    EditName.Text := nPort.FName;
    EditPort.Text := nPort.FPortName;

    EditBaud.Text := BaudRateToStr(nPort.FBaudRate);
    EditData.Text := DataBitsToStr(nPort.FDataBits);
    EditStop.Text := StopBitsToStr(nPort.FStopBits);
  end else
  begin
    EditBaud.Text := BaudRateToStr(cCOM_BaudRate);
    EditData.Text := DataBitsToStr(cCOM_DataBits);
    EditStop.Text := StopBitsToStr(cCOM_StopBits);
  end;
end;

function TfFormPort.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditName then
  begin
    Result := Trim(EditName.Text) <> '';
    nHint := '请填写设备名称';
  end else

  if Sender = EditPort then
  begin
    Result := Trim(EditPort.Text) <> '';
    nHint := '请填写端口';
  end else

  if Sender is TcxComboBox then
  begin
    Result := (Sender as TcxComboBox).ItemIndex >= 0;
    nHint := '请选择有效参数';
  end;
end;

procedure TfFormPort.GetParam(const nPort: PCOMParam);
begin
  nPort.FName := EditName.Text;
  nPort.FPortName := EditPort.Text;
  nPort.FBaudRate := StrToBaudRate(EditBaud.Text);
  nPort.FDataBits := StrToDataBits(EditData.Text);
  nPort.FStopBits := StrToStopBits(EditStop.Text);
end;

//Desc: 添加端口
function TfFormPort.PortAdd: Boolean;
var nStr,nTmp: string;
    nInt: Integer;
    nPort: TCOMParam;
begin
  Result := False;
  nStr := 'Select C_Name From %s Where C_Port=''%s''';
  nStr := Format(nStr, [sTable_Port, EditPort.Text]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nStr := Format('"%s"使用该端口', [Fields[0].AsString]);
    ShowMsg(nStr, sHint);
    Exit;
  end;

  FDM.ADOConn.BeginTrans;
  try
    nStr := MakeSQLByStr([SF('C_Name', EditName.Text),
            SF('C_Port', EditPort.Text), SF('C_Baund', EditBaud.Text),
            SF('C_DataBits', EditData.Text), SF('C_StopBits', EditStop.Text)],
            sTable_Port, '', True);
    FDM.ExecuteSQL(nStr);

    nInt := FDM.GetFieldMax(sTable_Port, 'R_ID');
    nTmp := FDM.GetSerialID2('', sTable_Port, 'R_ID', 'C_ID', nInt);

    nStr := 'Update %s Set C_ID=''%s'' Where R_ID=%d';
    nStr := Format(nStr, [sTable_Port, nTmp, nInt]);
    FDM.ExecuteSQL(nStr);

    FDM.ADOConn.CommitTrans;
    //apply
    Result := True;

    nPort.FItemID := nTmp;
    GetParam(@nPort);
    
    gDeviceManager.AddParam(nPort);
    gDeviceManager.AdjustDevice;
    ShowMsg('串口添加成功', sHint);
  except
    on E:Exception do
    begin
      FDM.ADOConn.RollbackTrans;
      ShowMsg('添加串口失败', sHint);
      WriteLog(E.Message);
    end;
  end;
end;

//Desc: 修改端口
function TfFormPort.PortEdit: Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select C_Name From %s Where C_ID<>''%s'' And C_Port=''%s''';
  nStr := Format(nStr, [sTable_Port, FPort.FItemID, EditPort.Text]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nStr := Format('"%s"使用该端口', [Fields[0].AsString]);
    ShowMsg(nStr, sHint);
    Exit;
  end;
  
  nStr := Format('C_ID=''%s''', [FPort.FItemID]);
  //where

  nStr := MakeSQLByStr([SF('C_Name', EditName.Text),
          SF('C_Port', EditPort.Text), SF('C_Baund', EditBaud.Text),
          SF('C_DataBits', EditData.Text), SF('C_StopBits', EditStop.Text)],
          sTable_Port, nStr, False);
  //xxxxx
  
  FDM.ExecuteSQL(nStr);
  Result := True;

  GetParam(FPort);
  gDeviceManager.AdjustDevice;
  ShowMsg('保存成功,重启生效', sHint);
end;

//Desc: 删除
class procedure TfFormPort.PortDel(const nPort: PCOMParam);
var nStr: string;
begin
  nStr := Format('确定要删除名称为[ %s ]的串口吗?', [nPort.FName]);
  if not QueryDlg(nStr, sAsk) then Exit;

  nStr := 'Delete From %s Where C_ID=''%s''';
  nStr := Format(nStr, [sTable_Port, nPort.FItemID]);
  FDM.ExecuteSQL(nStr);

  nPort.FCOMValid := False;
  gDeviceManager.AdjustDevice;
  ShowMsg('保存成功,重启生效', sHint);
end;

procedure TfFormPort.BtnOKClick(Sender: TObject);
var nRes: Boolean;
begin
  if IsDataValid then
  begin
    if Assigned(FPort) then
         nRes := PortEdit
    else nRes := PortAdd;

    if nRes then
      ModalResult := mrOk;
    //xxxxx
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormPort, TfFormPort.FormID);
end.
