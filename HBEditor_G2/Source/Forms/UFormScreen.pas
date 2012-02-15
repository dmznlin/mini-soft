{*******************************************************************************
  作者: dmzn@163.com 2009-11-03
  描述: 设置屏幕参数
*******************************************************************************}
unit UFormScreen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons;

type
  TfFormScreen = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    wPage: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    BtnSave: TButton;
    BtnExit: TButton;
    BtnAdd: TSpeedButton;
    BtnDel: TSpeedButton;
    ListDevice: TListView;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    EditCard: TComboBox;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    EditName: TEdit;
    Label4: TLabel;
    EditPort: TComboBox;
    Label5: TLabel;
    EditBote: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    EditX: TEdit;
    EditY: TEdit;
    Label8: TLabel;
    EditType: TComboBox;
    Label9: TLabel;
    EditSID: TEdit;
    Label10: TLabel;
    EditSName: TEdit;
    BtnAdd2: TSpeedButton;
    BtnDel2: TSpeedButton;
    GroupBox3: TGroupBox;
    Check1: TCheckBox;
    BtnSet: TBitBtn;
    Label11: TLabel;
    EditConn: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnAdd2Click(Sender: TObject);
    procedure BtnDel2Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure EditTypeChange(Sender: TObject);
    procedure BtnSetClick(Sender: TObject);
    procedure EditConnChange(Sender: TObject);
  private
    { Private declarations }
    FScreenList: TList;
    //屏幕列表
    procedure InitFormData;
    //初始化数据
    procedure LoadScreens;
    //载入屏列表
    function IsValid: Boolean;
    //校验数据
    procedure OnTrans(const nItem: TComponent; var nNext: Boolean);
  public
    { Public declarations }
  end;

function ShowScreenSetupForm: Boolean;
function LoadScreenList(const nList: TList): Boolean;
function SaveScreenList(const nList: TList): Boolean;

procedure ClearScreenList(const nList: TList; const nFree: Boolean); 
function FindScreenIndex(const nList: TList; const nID: Integer = 0;
 const nName: string = ''): Integer;
//入口函数

implementation

{$R *.dfm}

uses
  IniFiles, Registry, ULibFun, UForminputbox, UBase64, UMgrCOMM, UDataModule,
  UAdjustForm, USysConst, UProtocol, UMgrLang, UDataSaved;

//------------------------------------------------------------------------------
//Desc: 设置屏参
function ShowScreenSetupForm: Boolean;
var nStr,nPwd0,nPwd1,nPwd2: string;
begin
  Result := False;
  if ShowInputPWDBox(ML('请输入管理密码:', 'Common'), sAsk, nStr, 15) then
  begin
    with TIniFile.Create(gPath + sConfigFile) do
    try
      nPwd0 := ReadString('Setup', 'AdminPwd0', '');
      nPwd1 := ReadString('Setup', 'AdminPwd1', '');
      nPwd2 := ReadString('Setup', 'AdminPwd2', '');
    finally
      Free;
    end;

    nStr := EncodeBase64(nStr);
    if (nPwd0 <> nStr) and (nPwd1 <> nStr) and (nPwd2 <> nStr) then
    begin
      ShowMsg(ML('管理密码无效', 'Common'), sHint); Exit
    end;
  end else Exit;

  with TfFormScreen.Create(Application) do
  begin
    Caption := ML('设置屏参');
    InitFormData;

    Result := ShowModal = mrOk;
    Free;
  end;
end;

//Desc: 复制屏幕项
procedure CopyScreenItem(const nFrom,nTo: PScreenItem);
var nIdx,nLen: Integer;
begin
  with nFrom^ do
  begin
    nTo.FID := FID;
    nTo.FName := FName;
    nTo.FCard := FCard;
    nTo.FLenX := FLenX;
    nTo.FLenY := FLenY;
    nTo.FType := FType;
    nTo.FPort := FPort;
    nTo.FBote := FBote;

    nLen := High(FDevice);
    SetLength(nTo.FDevice, nLen + 1);

    for nIdx:=Low(FDevice) to nLen do
    begin
      nTo.FDevice[nIdx].FID := FDevice[nIdx].FID;
      nTo.FDevice[nIdx].FName := FDevice[nIdx].FName;
    end;
  end;
end;

//Desc: 载入屏列表
function LoadScreenList(const nList: TList): Boolean;
var nStr: string;
    nIni: TIniFile;
    nSList,nSList2: TStrings;
    nItem: PScreenItem;
    i,nCount,nIdx,nLen: Integer;
begin
  if FileExists(gDataManager.DataFile) then
  begin
    if Length(gDataManager.Screens) > 0 then
    begin
      ClearScreenList(nList, False);
      nCount := High(gDataManager.Screens);

      for i:=Low(gDataManager.Screens) to nCount do
      begin
        New(nItem);
        nList.Add(nItem);
        CopyScreenItem(@gDataManager.Screens[i], nItem);
      end;
    end else
    begin
      nCount := gScreenList.Count - 1;
      for i:=0 to nCount do
      begin
        New(nItem);
        nList.Add(nItem);
        CopyScreenItem(gScreenList[i], nItem);
      end;
    end;

    Result := nList.Count > 0;
    Exit;
  end;

  nIni := TIniFile.Create(gPath + sScreenConfig);
  nSList := TStringList.Create;
  nSList2 := TStringList.Create;
  try
    ClearScreenList(nList, False);
    nIni.ReadSections(nSList);

    nCount := nSList.Count - 1;
    for i:=0 to nCount do
    begin
      New(nItem);
      nList.Add(nItem);

      nItem.FID := i;
      nItem.FName := nIni.ReadString(nSList[i], 'Name', '');
      nItem.FCard := nIni.ReadInteger(nSList[i], 'Card', 1);
      nItem.FLenX := nIni.ReadInteger(nSList[i], 'LenX', 600);
      nItem.FLenY := nIni.ReadInteger(nSList[i], 'LenY', 400);
      nItem.FType := TScreenType(nIni.ReadInteger(nSList[i], 'Type', 1));
      nItem.FPort := nIni.ReadString(nSList[i], 'Port', '');
      nItem.FBote := nIni.ReadInteger(nSList[i], 'Bote', 1200);

      nIni.ReadSection(nSList[i], nSList2);
      //读取子项

      for nIdx:=0 to nSList2.Count-1 do
      if Pos('D_', nSList2[nIdx]) = 1 then
      begin
        nStr := nSList2[nIdx];
        System.Delete(nStr, 1, 2);
        if not IsNumber(nStr, False) then Continue;

        nLen := Length(nItem.FDevice);
        SetLength(nItem.FDevice, nLen + 1);

        nItem.FDevice[nLen].FID := StrToInt(nStr);
        nStr := nIni.ReadString(nSList[i], nSList2[nIdx], '');
        nItem.FDevice[nLen].FName := nStr;
      end;
    end;

    Result := nList.Count > 0;
  finally
    nSList.Free;
    nSList2.Free;
    nIni.Free;
  end;
end;

//Desc: 保存屏列表
function SaveScreenList(const nList: TList): Boolean;
var nStr: string;
    nIni: TIniFile;
    nSList: TStrings;
    i,nCount,nIdx: Integer;
    nItem: PScreenItem;
begin
  Result := True;
  nIni := TIniFile.Create(gPath + sScreenConfig);
  nSList := TStringList.Create;
  try
    nIni.ReadSections(nSList);
    nCount := nSList.Count - 1;

    for i:=0 to nCount do
      nIni.EraseSection(nSList[i]);
    //xxxxx

    nCount := nList.Count - 1;
    for i:=0 to nCount do
    begin
      nItem := nList[i];
      nStr := 'Screen' + IntToStr(i);

      nIni.WriteString(nStr, 'Name', nItem.FName);
      nIni.WriteInteger(nStr, 'Card', nItem.FCard);
      nIni.WriteInteger(nStr, 'LenX', nItem.FLenX);
      nIni.WriteInteger(nStr, 'LenY', nItem.FLenY);
      nIni.WriteInteger(nStr, 'Type', Ord(nItem.FType));
      nIni.WriteString(nStr, 'Port', nItem.FPort);
      nIni.WriteInteger(nStr, 'Bote', nItem.FBote);

      for nIdx:=Low(nItem.FDevice) to High(nItem.FDevice) do
      if nItem.FDevice[nIdx].FID > -1 then
        nIni.WriteString(nStr, 'D_' + IntToStr(nItem.FDevice[nIdx].FID),
          nItem.FDevice[nIdx].FName);
      //xxxxx

      if not FileExists(gDataManager.DataFile) then Continue;
      if i<gScreenList.Count then CopyScreenItem(nItem, gScreenList[i]);
      //更新已载入文件
    end;
  finally
    nSList.Free;
    nIni.Free;
  end;
end;

//Desc: 清理数据
procedure ClearScreenList(const nList: TList; const nFree: Boolean);
var nIdx: integer;
    nItem: PScreenItem;
begin
  for nIdx:=nList.Count - 1 downto 0 do
  begin
    nItem := nList[nIdx];
    Dispose(nItem);
    nList.Delete(nIdx);
  end;

  if nFree then nList.Free;
end;

//Desc: 检索屏
function FindScreenIndex(const nList: TList; const nID: Integer = 0;
 const nName: string = ''): Integer;
var nIdx: integer;
    nItem: PScreenItem;
begin
  Result := -1;
  for nIdx:=nList.Count - 1 downto 0 do
  begin
    nItem := nList[nIdx];
    if ((nID <> 0) and (nItem.FID = nID)) or
       ((nName <> '') and (nItem.FName = nName)) then
    begin
      Result := nIdx; Break;
    end;  
  end;
end;

procedure TfFormScreen.FormCreate(Sender: TObject);
begin
  FScreenList := TList.Create;
  gMultiLangManager.SectionID := Name;

  gMultiLangManager.OnTransItem := OnTrans;
  gMultiLangManager.TranslateAllCtrl(Self);
  gMultiLangManager.OnTransItem := nil;
end;

procedure TfFormScreen.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ClearScreenList(FScreenList, True);
  ReleaseCtrlData(TabSheet1);
end;

procedure TfFormScreen.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 翻译
procedure TfFormScreen.OnTrans(const nItem: TComponent; var nNext: Boolean);
var nIdx: Integer;
begin
  if nItem = ListDevice then
  begin
    nNext := False;
    for nIdx:=ListDevice.Columns.Count - 1 downto 0 do
      ListDevice.Columns[nIdx].Caption := ML(ListDevice.Columns[nIdx].Caption);
    //xxxxx
  end;
end;

//------------------------------------------------------------------------------
//Date: 2009-11-03
//Desc: 初始化界面
procedure TfFormScreen.InitFormData;
var nIdx: integer;
begin
  EditCard.Clear;
  BtnAdd.Enabled := not FileExists(gDataManager.DataFile);
  BtnDel.Enabled := BtnAdd.Enabled;

  for nIdx:=Low(cCardList) to High(cCardList) do
   with cCardList[nIdx] do
    EditCard.Items.Add(Format('%d=%s', [FCard, FName]));
  //xxxxx

  for nIdx:=Low(cConnList) to High(cConnList) do
   with cConnList[nIdx] do
    EditConn.Items.Add(Format('%d=%s', [Ord(FType), ML(FName)]));
  //xxxxx

  for nIdx:=EditType.Items.Count - 1 downto 0 do
    EditType.Items[nIdx] := ML(EditType.Items[nIdx]);
  //xxxxx

  GetValidCOMPort(EditPort.Items);
  AdjustCtrlData(TabSheet1);

  LoadScreenList(FScreenList);
  LoadScreens;
  wPage.ActivePageIndex := 0;
end;

//Desc: 载入屏列表
procedure TfFormScreen.LoadScreens;
var nStr: string;
    i,nCount: integer;
    nItem: PScreenItem;  
begin
  ListBox1.Clear;
  nCount := FScreenList.Count - 1;

  for i:=0 to nCount do
  begin
    nItem := FScreenList[i];
    nItem.FID := i;
    
    nStr := Format('%d-%s', [nItem.FID, nItem.FName]);
    ListBox1.Items.Add(nStr);
  end;

  if ListBox1.Items.Count > 0 then
  begin
    ListBox1.ItemIndex := 0;
    ListBox1Click(nil);
  end;
end;

function TfFormScreen.IsValid: Boolean;
begin
  Result := False;
  wPage.ActivePageIndex := 0;

  if EditCard.ItemIndex < 0 then
  begin
    EditCard.SetFocus;
    ShowMsg(ML('请选择有效的组件'), sHint); Exit;
  end;

  if EditType.ItemIndex < 0 then
  begin
    EditType.SetFocus;
    ShowMsg(ML('请选择有效的类型'), sHint); Exit;
  end;

  if not IsNumber(EditX.Text, False) then
  begin
    EditX.SetFocus;
    ShowMsg(ML('请填写有效的数值'), sHint); Exit;
  end;

  if not IsNumber(EditY.Text, False) then
  begin
    EditY.SetFocus;
    ShowMsg(ML('请填写有效的数值'), sHint); Exit;
  end;

  if EditPort.ItemIndex < 0 then
  begin
    EditPort.SetFocus;
    ShowMsg(ML('请选择有效的端口'), sHint); Exit;
  end;

  if EditBote.ItemIndex < 0 then
  begin
    EditBote.SetFocus;
    ShowMsg(ML('请选择有效的波特率'), sHint); Exit;
  end;

  Result := True;
end;

procedure TfFormScreen.EditConnChange(Sender: TObject);
begin
  EditConn.ItemIndex := 0;
end;

procedure TfFormScreen.EditTypeChange(Sender: TObject);
var nItem: PScreenItem;
begin
  if (ActiveControl = Sender) and (ListBox1.ItemIndex > -1) and IsValid then
  begin
    nItem := FScreenList[ListBox1.ItemIndex];
    nItem.FName := EditName.Text;
    nItem.FCard := StrToInt(GetCtrlData(EditCard));
    nItem.FLenX := StrToInt(EditX.Text);
    nItem.FLenY := StrToInt(EditY.Text);
    nItem.FType := TScreenType(EditType.ItemIndex);
    nItem.FPort := EditPort.Text;
    nItem.FBote := StrToInt(EditBote.Text);
  end;
end;

//Desc: 添加
procedure TfFormScreen.BtnAddClick(Sender: TObject);
var nItem: PScreenItem;
    i,nCount: integer;
begin
  if not IsValid then Exit;
  New(nItem);
  FScreenList.Add(nItem);

  nItem.FName := EditName.Text;
  nItem.FCard := StrToInt(GetCtrlData(EditCard));
  nItem.FLenX := StrToInt(EditX.Text);
  nItem.FLenY := StrToInt(EditY.Text);
  nItem.FType := TScreenType(EditType.ItemIndex);
  nItem.FPort := EditPort.Text;
  nItem.FBote := StrToInt(EditBote.Text);

  nCount := ListDevice.Items.Count - 1;
  SetLength(nItem.FDevice, nCount + 1);

  for i:=0 to nCount do
  begin
    nItem.FDevice[i].FID := StrToInt(ListDevice.Items[i].Caption);
    nItem.FDevice[i].FName := ListDevice.Items[i].SubItems[0];
  end;

  LoadScreens;
end;

//Desc: 删除
procedure TfFormScreen.BtnDelClick(Sender: TObject);
var nIdx: integer;
begin
  nIdx := ListBox1.ItemIndex;
  if nIdx > -1 then
  begin
    Dispose(PScreenItem(FScreenList[nIdx]));
    FScreenList.Delete(nIdx);
  end;

  if nIdx > 0 then Dec(nIdx) else nIdx := 0;
  ListBox1.ItemIndex := nIdx;
  LoadScreens;
end;

//Desc: 添加设备
procedure TfFormScreen.BtnAdd2Click(Sender: TObject);
var nLen: Integer;
    nItem: PScreenItem;
begin
  if not IsNumber(EditSID.Text, False) then
  begin
    EditSID.SetFocus;
    ShowMsg(ML('请填写有效的设备号'), sHint); Exit;
  end;

  with ListDevice.Items.Add do
  begin
    Caption := EditSID.Text;
    SubItems.Add(EditSName.Text);

    if ListBox1.ItemIndex > -1 then
    begin
      nItem := FScreenList[ListBox1.ItemIndex];
      nLen := Length(nItem.FDevice);

      SetLength(nItem.FDevice, nLen + 1);
      nItem.FDevice[nLen].FID := StrToInt(EditSID.Text);
      nItem.FDevice[nLen].FName := EditSName.Text;
    end;

    EditSName.SetFocus;
    EditSID.Text := IntToStr(StrToInt(EditSID.Text) + 1);
  end;
end;

procedure TfFormScreen.BtnDel2Click(Sender: TObject);
var nIdx: integer;
    nItem: PScreenItem;
begin
  if Assigned(ListDevice.Selected) then
  begin
    if ListBox1.ItemIndex > -1 then
    begin
      nItem := FScreenList[ListBox1.ItemIndex];
      for nIdx:=Low(nItem.FDevice) to High(nItem.FDevice) do
       if nItem.FDevice[nIdx].FID = StrToInt(ListDevice.Selected.Caption) then
         nItem.FDevice[nIdx].FID := -1;
    end;

    nIdx := ListDevice.ItemIndex;
    ListDevice.DeleteSelected;

    if nIdx > ListDevice.Items.Count - 1 then Dec(nIdx);
    if nIdx > -1 then ListDevice.ItemIndex := nIdx;
  end;
end;

//Desc: 显示明细
procedure TfFormScreen.ListBox1Click(Sender: TObject);
var nItem: PScreenItem;
    nIdx: integer;
begin
  if ListBox1.ItemIndex < 0 then Exit;
  wPage.ActivePageIndex := 0;
  nItem := FScreenList[ListBox1.ItemIndex];

  EditName.Text := nItem.FName;
  SetCtrlData(EditCard, IntToStr(nItem.FCard));

  EditX.Text := IntToStr(nItem.FLenX);
  EditY.Text := IntToStr(nItem.FLenY);
  EditType.ItemIndex := Ord(nItem.FType);
  EditPort.ItemIndex := EditPort.Items.IndexOf(nItem.FPort);
  EditBote.ItemIndex := EditBote.Items.IndexOf(IntToStr(nItem.FBote));

  ListDevice.Items.Clear;
  for nIdx:=Low(nItem.FDevice) to High(nItem.FDevice) do
   if nItem.FDevice[nIdx].FID > -1 then
   with ListDevice.Items.Add do
   begin
     Caption := IntToStr(nItem.FDevice[nIdx].FID);
     SubItems.Add(nItem.FDevice[nIdx].FName);
   end;
end;

procedure TfFormScreen.BtnSaveClick(Sender: TObject);
begin
  SaveScreenList(FScreenList);
  ModalResult := mrOk;
end;

//Desc: 同步设备编号
procedure TfFormScreen.BtnSetClick(Sender: TObject);
var nStr: string;
    nItem: PScreenItem;
    nData: THead_Send_SetDeviceNo;
    nRespond: THead_Respond_SetDeviceNo;
begin
  if ListBox1.ItemIndex < 0 then
  begin
    ListBox1.SetFocus;
    ShowMsg(ML('屏幕参数无效'), sHint); Exit;
  end;

  if ListDevice.ItemIndex < 0 then
  begin
    ListDevice.SetFocus;
    ShowMsg(ML('请选择待同步的设备'), sHint); Exit;
  end;

  nItem := gScreenList[ListBox1.ItemIndex];
  FillChar(nData, cSize_Head_Send_SetDeviceNo, #0);

  nData.FHead := Swap(cHead_DataSend);
  nData.FLen := Swap(cSize_Head_Send_SetDeviceNo);
  nData.FCardType := nItem.FCard;

  nData.FNo := StrToInt(ListDevice.Selected.Caption);
  nData.FNo := Swap(nData.FNo);
  nData.FCommand := cCmd_SetDeviceNo;

  with FDM do
  try
    BtnSet.Enabled := False;
    nStr := ML('与控制器通信失败');

    Comm1.StopComm;
    Comm1.CommName := nItem.FPort;
    Comm1.BaudRate := nItem.FBote;

    Comm1.StartComm;
    Sleep(500);

    nStr := ML('发送数据失败');
    FWaitCommand := nData.FCommand;
    Comm1.WriteCommData(@nData, cSize_Head_Send_SetDeviceNo);

    if not WaitForTimeOut(nStr) then
      raise Exception.Create('');
    //xxxxx

    Move(FDM.FValidBuffer[0], nRespond, cSize_Head_Respond_SetDeviceNo);
    if nRespond.FFlag = sFlag_OK then
         ShowMsg(ML('设备编号更新成功'), sHint)
    else ShowMsg(ML('设备编号更新失败'), sHint);

    if Check1.Checked then
      ListDevice.ItemIndex := ListDevice.ItemIndex + 1;
    BtnSet.Enabled := True;
  except
    BtnSet.Enabled := True;
    ShowMsg(nStr, sHint);
  end;
end;

end.
