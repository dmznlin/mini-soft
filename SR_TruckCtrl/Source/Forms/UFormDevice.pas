{*******************************************************************************
  作者: dmzn@163.com 2013-3-9
  描述: 设备管理
*******************************************************************************}
unit UFormDevice;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, UFormBase, USysProtocol, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit,
  cxDropDownEdit, cxLabel, cxTextEdit, dxLayoutControl, StdCtrls;

type
  TfFormDevice = class(TfFormNormal)
    EditIndex: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditCarName: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Item5: TdxLayoutItem;
    cxLabel1: TcxLabel;
    EditCarType: TcxComboBox;
    dxLayout1Item6: TdxLayoutItem;
    EditCarMode: TcxComboBox;
    dxLayout1Item7: TdxLayoutItem;
    EditCar: TcxComboBox;
    dxLayout1Item8: TdxLayoutItem;
    EditSerial: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditPort: TcxComboBox;
    dxLayout1Item10: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure EditCarPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FPort: PCOMParam;
    FDevice: PDeviceItem;
    procedure InitFormData(const nDevice: PDeviceItem);
    //init ui
    procedure GetParam(const nDevice: PDeviceItem; const nCar: PCarriageItem);
    procedure CarAction(const nCar: PCarriageItem);
    //car
    function DeviceAdd: Boolean;
    function DeviceEdit: Boolean;
    class procedure DeviceDel(const nDevice: PDeviceItem);
    //deivce action
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
  ULibFun, UMgrControl, UFormWait, UFormCtrl, UDataModule, USysLoger,
  USysConst, USysDB;

procedure WriteLog(const nMsg: string);
begin
  gSysLoger.AddLog(TfFormDevice, '串口设备管理', nMsg);
end;

class function TfFormDevice.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  nP := nParam;

  case nP.FCommand of
   cCmd_AddData:
    begin
      with TfFormDevice.Create(Application) do
      begin
        Caption := '添加 - 设备';
        FPort := Pointer(Integer(nP.FParamA));
        FDevice := nil;
        InitFormData(nil);

        nP.FCommand := cCmd_ModalResult;
        nP.FParamA := ShowModal;
        Free;
      end;
    end;
   cCmd_EditData:
    begin
      with TfFormDevice.Create(Application) do
      begin
        Caption := '修改 - 设备';
        FPort := Pointer(Integer(nP.FParamA));
        FDevice := Pointer(Integer(nP.FParamB));
        InitFormData(FDevice);

        nP.FCommand := cCmd_ModalResult;
        nP.FParamA := ShowModal;
        Free;
      end;
    end;
   cCmd_DeleteData:
    begin
      TfFormDevice.DeviceDel(Pointer(Integer(nP.FParamA)));
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := mrOk;
    end;
  end;
end;

class function TfFormDevice.FormID: integer;
begin
  Result := cFI_FormDevice;
end;

procedure TfFormDevice.InitFormData(const nDevice: PDeviceItem);
var nStr: string;
    nIdx: Integer;
    nList: TList;
    nPort: PCOMItem;
    nCar: PCarriageItem;
begin
  nList := gDeviceManager.LockPortList;
  try
    for nIdx:=0 to nList.Count - 1 do
    with EditPort.Properties do
    begin
      nPort := nList[nIdx];
      if nPort.FParam.FCOMValid then
        Items.AddObject(nPort.FParam.FName, TObject(nPort.FParam));
      //xxxxx
    end;

    gDeviceManager.ReleaseLock;
    nList := gDeviceManager.LockCarriageList;
    EditCar.Properties.Items.AddObject('新车厢', nil);

    for nIdx:=0 to nList.Count - 1 do
    with EditCar.Properties do
    begin
      nCar := nList[nIdx];
      Items.AddObject(nCar.FName, TObject(nCar));
    end;
  finally
    gDeviceManager.ReleaseLock;
  end;

//------------------------------------------------------------------------------
  nStr := MacroValue(sQuery_SysDict, [MI('$Name', sFlag_CarType),
          MI('$Table', sTable_SysDict)]);
  //xxxxx

  with FDM.QueryTemp(nStr),EditCarType do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := FieldByName('D_Memo').AsString;
      nIdx := FieldByName('D_Value').AsInteger;
      Properties.Items.AddObject(nStr, Pointer(nIdx));

      Next;
    end;
  end;

  nStr := MacroValue(sQuery_SysDict, [MI('$Name', sFlag_CarMode),
          MI('$Table', sTable_SysDict)]);
  //xxxxx

  with FDM.QueryTemp(nStr),EditCarMode do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := FieldByName('D_Memo').AsString;
      nIdx := FieldByName('D_Value').AsInteger;
      Properties.Items.AddObject(nStr, Pointer(nIdx));

      Next;
    end;
  end;

//------------------------------------------------------------------------------
  with EditPort do
    ItemIndex := Properties.Items.IndexOfObject(TObject(FPort));
  //xxxxx

  if Assigned(FDevice) then
  begin
    EditIndex.Text := IntToStr(FDevice.FIndex);
    EditSerial.Text := FDevice.FSerial;

    with EditCar do
      ItemIndex := Properties.Items.IndexOfObject(TObject(FDevice.FCarriage));
    //xxxxx
  end;
end;

procedure TfFormDevice.EditCarPropertiesChange(Sender: TObject);
var nCar: PCarriageItem;
begin
  if EditCar.ItemIndex >= 0 then
  begin
    nCar := Pointer(EditCar.Properties.Items.Objects[EditCar.ItemIndex]);
    if not Assigned(nCar) then Exit;

    EditCarName.Text := nCar.FName;
    with EditCarType do
      ItemIndex := Properties.Items.IndexOfObject(Pointer(nCar.FTypeID));
    //xxxxx

    with EditCarMode do
      ItemIndex := Properties.Items.IndexOfObject(Pointer(nCar.FModeID));
    //xxxxx
  end;
end;

function TfFormDevice.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditPort then
  begin
    Result := EditPort.ItemIndex >= 0;
    nHint := '请选择有效的串口';
  end else

  if Sender = EditIndex then
  begin
    Result := IsNumber(EditIndex.Text, False);
    nHint := '索引为从0开始的整数';
  end else

  if Sender = EditCar then
  begin
    Result := EditCar.ItemIndex >= 0;
    nHint := '请选择设备所在车厢';
  end else

  if Sender = EditCarName then
  begin
    Result := EditCarName.Text <> '';
    nHint := '请填写车厢名称';
  end else

  if (Sender = EditCarType) or (Sender = EditCarMode) then
  begin
    Result := (Sender as TcxComboBox).ItemIndex >= 0;
    nHint := '请选择有效参数';
  end;
end;

procedure TfFormDevice.GetParam(const nDevice: PDeviceItem;
 const nCar: PCarriageItem);
var nPort: PCOMParam;
    nPCar: PCarriageItem;
begin
  if Assigned(FDevice) then
    nDevice^ := FDevice^;
  //old value

  with EditPort do
    nPort := Pointer(Properties.Items.Objects[ItemIndex]);
  nDevice.FCOMPort := nPort.FPortName;

  nDevice.FIndex := StrToInt(EditIndex.Text);
  nDevice.FSerial := EditSerial.Text;

  with EditCar do
  begin
    nPCar := Pointer(Properties.Items.Objects[ItemIndex]);
    if not Assigned(nPCar) then
    begin
      nCar.FItemID := '';
      nCar.FPostion := 0;
    end else nCar^ := nPCar^;
  end;

  nCar.FName := EditCarName.Text;
  //new name

  with EditCarType do
  begin
    nCar.FTypeID := Integer(Properties.Items.Objects[ItemIndex]);
    nCar.FTypeName := EditCarType.Text;
  end;

  with EditCarMode do
  begin
    nCar.FModeID := Integer(Properties.Items.Objects[ItemIndex]);
    nCar.FModeName := EditCarType.Text;
  end;
end;

//Desc: 新建或修改车厢数据
procedure TfFormDevice.CarAction(const nCar: PCarriageItem);
var nStr: string;
    nInt: Integer;
begin
  if nCar.FItemID = '' then
  begin
    nStr := MakeSQLByStr([SF('C_Name', nCar.FName),
            SF('C_TypeID', nCar.FTypeID), SF('C_TypeName', nCar.FTypeName),
            SF('C_ModeID', nCar.FModeID), SF('C_ModeName', nCar.FModeName)],
            sTable_Carriage, '', True);
    FDM.ExecuteSQL(nStr);

    nInt := FDM.GetFieldMax(sTable_Carriage, 'R_ID');
    nCar.FItemID := FDM.GetSerialID2('', sTable_Carriage, 'R_ID', 'C_ID', nInt);

    nStr := 'Update %s Set C_ID=''%s'' Where R_ID=%d';
    nStr := Format(nStr, [sTable_Carriage, nCar.FItemID, nInt]);
    FDM.ExecuteSQL(nStr);
  end else
  begin
    nStr := Format('C_ID=''%s''', [nCar.FItemID]);
    nStr := MakeSQLByStr([SF('C_Name', nCar.FName),
            SF('C_TypeID', nCar.FTypeID), SF('C_TypeName', nCar.FTypeName),
            SF('C_ModeID', nCar.FModeID), SF('C_ModeName', nCar.FModeName)],
            sTable_Carriage, nStr, False);
    FDM.ExecuteSQL(nStr);
  end;
end;

//Desc: 添加设备
function TfFormDevice.DeviceAdd: Boolean;
var nStr: string;
    nInt: Integer;
    nDev: TDeviceItem;
    nCar: TCarriageItem;
begin
  Result := False;
  GetParam(@nDev, @nCar);

  nStr := 'Select Count(*) From %s Where D_Port=''%s'' And D_Index=%d';
  nStr := Format(nStr, [sTable_Device, nDev.FCOMPort, nDev.FIndex]);

  with FDM.QueryTemp(nStr) do
  if Fields[0].AsInteger > 0 then
  begin
    ShowMsg('该串口下已有该地址', sHint);
    Exit;
  end;

  FDM.ADOConn.BeginTrans;
  try
    CarAction(@nCar);
    //save car
    nDev.FCarriageID := nCar.FItemID;
    //new car

    nStr := MakeSQLByStr([SF('D_Port', nDev.FCOMPort),
            SF('D_Serial', nDev.FSerial), SF('D_Index', nDev.FIndex),
            SF('D_Carriage', nCar.FItemID)], sTable_Device, '', True);
    FDM.ExecuteSQL(nStr);

    nInt := FDM.GetFieldMax(sTable_Device, 'R_ID');
    nDev.FItemID := FDM.GetSerialID2('', sTable_Device, 'R_ID', 'D_ID', nInt);

    nStr := 'Update %s Set D_ID=''%s'' Where R_ID=%d';
    nStr := Format(nStr, [sTable_Device, nDev.FItemID, nInt]);
    FDM.ExecuteSQL(nStr);

    FDM.ADOConn.CommitTrans;
    //apply
    Result := True;

    gDeviceManager.AddCarriage(nCar);
    gDeviceManager.AddDevice(nDev);
    gDeviceManager.AdjustDevice;
    ShowMsg('添加成功,重启生效', sHint);
  except
    on E:Exception do
    begin
      FDM.ADOConn.RollbackTrans;
      ShowMsg('添加设备失败', sHint);
      WriteLog(E.Message);
    end;
  end;
end;

//Desc: 修改设备
function TfFormDevice.DeviceEdit: Boolean;
var nStr: string;
    nDev: TDeviceItem;
    nCar: TCarriageItem;
begin
  Result := False;
  GetParam(@nDev, @nCar);

  nStr := 'Select Count(*) From %s ' +
          'Where D_ID<>''%s'' And D_Port=''%s'' And D_Index=%d';
  nStr := Format(nStr, [sTable_Device, FDevice.FItemID, nDev.FCOMPort, nDev.FIndex]);

  with FDM.QueryTemp(nStr) do
  if Fields[0].AsInteger > 0 then
  begin
    ShowMsg('该串口下已有该地址', sHint);
    Exit;
  end;

  FDM.ADOConn.BeginTrans;
  try
    CarAction(@nCar);
    //save car
    nDev.FCarriageID := nCar.FItemID;
    //new car

    nStr := Format('D_ID=''%s''', [FDevice.FItemID]);
    nStr := MakeSQLByStr([SF('D_Port', nDev.FCOMPort),
            SF('D_Serial', nDev.FSerial), SF('D_Index', nDev.FIndex),
            SF('D_Carriage', nCar.FItemID)],sTable_Device, nStr, False);
    FDM.ExecuteSQL(nStr);

    FDM.ADOConn.CommitTrans;
    //apply
    Result := True;

    gDeviceManager.AddCarriage(nCar);
    gDeviceManager.AddDevice(nDev);
    gDeviceManager.AdjustDevice;
    ShowMsg('保存成功,重启生效', sHint);
  except
    on E:Exception do
    begin
      FDM.ADOConn.RollbackTrans;
      ShowMsg('保存设备失败', sHint);
      WriteLog(E.Message);
    end;
  end;
end;

//Desc: 删除设备
class procedure TfFormDevice.DeviceDel(const nDevice: PDeviceItem);
var nStr: string;
begin
  if nDevice.FDeviceUsed then
       nStr := Format('确定要删除[ %s ]的设备吗?', [nDevice.FCarriage.FName])
  else nStr := '确定要删除该设备吗?';   
  if not QueryDlg(nStr, sAsk) then Exit;

  nStr := 'Delete From %s Where D_ID=''%s''';
  nStr := Format(nStr, [sTable_Device, nDevice.FItemID]);
  FDM.ExecuteSQL(nStr);

  if nDevice.FDeviceUsed then
  begin
    nStr := 'Delete From %s Where C_ID=''%s''';
    nStr := Format(nStr, [sTable_Carriage, nDevice.FCarriageID]);
    FDM.ExecuteSQL(nStr);
  end;

  nDevice.FDeviceValid := False;
  gDeviceManager.AdjustDevice;
  ShowMsg('保存成功,重启生效', sHint);
end;

procedure TfFormDevice.BtnOKClick(Sender: TObject);
var nRes: Boolean;
begin
  if IsDataValid then
  begin
    if Assigned(FDevice) then
         nRes := DeviceEdit
    else nRes := DeviceAdd;

    if nRes then
      ModalResult := mrOk;
    //xxxxx
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormDevice, TfFormDevice.FormID);
end.
