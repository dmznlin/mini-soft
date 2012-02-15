{*******************************************************************************
  作者: dmzn@163.com 2009-11-10
  描述: 控制器状态
*******************************************************************************}
unit UFormStatus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ULibFun, UDataModule, USysConst, UProtocol, StdCtrls, Menus, UMgrLang;

type
  TfFormStatus = class(TForm)
    GroupBox1: TGroupBox;
    BtnExit: TButton;
    Label1: TLabel;
    Label2: TLabel;
    EditScreen: TComboBox;
    EditDevice: TComboBox;
    BtnRead: TButton;
    ListInfo: TListBox;
    Label3: TLabel;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    MICard: TMenuItem;
    MISize: TMenuItem;
    MISync: TMenuItem;
    N5: TMenuItem;
    Group1: TGroupBox;
    BtnSwitchELevel: TButton;
    BtnSaveLevel: TButton;
    BtnSaveMode: TButton;
    BtnSwitchMode: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure EditScreenChange(Sender: TObject);
    procedure BtnReadClick(Sender: TObject);
    procedure MICardClick(Sender: TObject);
    procedure MISyncClick(Sender: TObject);
    procedure BtnSwitchELevelClick(Sender: TObject);
    procedure BtnSwitchModeClick(Sender: TObject);
  private
    { Private declarations }
    FScreen: TScreenItem;
    //界面参数
  public
    { Public declarations }
  end;

function ShowReadStatusForm: Boolean;
//入口函数

implementation

{$R *.dfm}

uses
  IniFiles, UFormSendData, UFormConnTest, UFormScreen, UFormMain;

var
  gForm: TfFormStatus = nil;

const
  cLangID = 'fFormStatus';

//------------------------------------------------------------------------------
//Desc: 状态窗口
function ShowReadStatusForm: Boolean;
begin
  if not Assigned(gForm) then
  begin
    gForm := TfFormStatus.Create(Application);
    gForm.Caption := ML('查看运行状态', cLangID);
    gForm.FormStyle := fsStayOnTop;
  end;

  gForm.Show;
  gForm.BtnRead.SetFocus;
  Result := True;
end;

//------------------------------------------------------------------------------
procedure TfFormStatus.FormCreate(Sender: TObject);
var nIni: TIniFile;
    i,nCount: integer;
    nItem: PScreenItem;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    MICard.Checked := nIni.ReadBool(Name, 'SynCard', True);
    MISize.Checked := nIni.ReadBool(Name, 'SynSize', True);
  finally
    nIni.Free;
  end;

  MISync.Enabled := False;
  Group1.Enabled := False;

  EditScreen.Clear;
  gMultiLangManager.SectionID := Name;
  gMultiLangManager.TranslateAllCtrl(Self);

  nCount := gScreenList.Count - 1; 
  for i:=0 to nCount do
  begin
    nItem := gScreenList[i];
    EditScreen.Items.Add(Format('%d-%s', [nItem.FID, nItem.FName]));
  end;

  if EditScreen.Items.Count > 0 then
  begin
    EditScreen.ItemIndex := 0;
    EditScreenChange(nil);
  end;
end;

procedure TfFormStatus.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    nIni.WriteBool(Name, 'SynCard', MICard.Checked);
    nIni.WriteBool(Name, 'SynSize', MISize.Checked);
  finally
    nIni.Free;
  end;

  Action := caFree;
  gForm := nil;
end;

procedure TfFormStatus.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
//Desc: 读取设备号
procedure TfFormStatus.EditScreenChange(Sender: TObject);
var nStr: string;
    nIdx: integer;
    nItem: PScreenItem;
begin
  MISync.Enabled := False;
  Group1.Enabled := False;
  EditDevice.Clear;
  if EditScreen.ItemIndex < 0 then Exit;

  EditDevice.Items.Add(ML('全部设备', cLangID));
  nItem := gScreenList[EditScreen.ItemIndex];

  for nIdx:=Low(nItem.FDevice) to High(nItem.FDevice) do
  begin
    nStr := Format('%d-%s', [nItem.FDevice[nIdx].FID, nItem.FDevice[nIdx].FName]);
    EditDevice.Items.Add(nStr);
  end;

  EditDevice.ItemIndex := 0;
end;

//Desc: 转nWeek为中文内容
function Week2Text(const nWeek: Byte): string;
begin
  case nWeek of
   0: Result := '天';
   1: Result := '一';
   2: Result := '二';
   3: Result := '三';
   4: Result := '四';
   5: Result := '五';
   6: Result := '六' else Result := 'X';
  end;

  Result := '星期' + Result;
  Result := ML(Result, sMLCommon);
end;

//Desc: 读取状态
procedure TfFormStatus.BtnReadClick(Sender: TObject);
var nStr: string;
    nIdx: integer;
    nItem: PScreenItem;
    nData: THead_Respond_ConnCtrl;
begin
  gMultiLangManager.SectionID := cLangID;
  if EditScreen.ItemIndex < 0 then
  begin
    EditScreen.SetFocus;
    ShowMsg(ML('请选择待查看的屏幕'), sHint); Exit;
  end;

  with FDM do
  try
    ListInfo.Clear;
    BtnRead.Enabled := False;
    nStr := ML('与控制器通信失败');

    nItem := gScreenList[EditScreen.ItemIndex];
    nIdx := EditDevice.ItemIndex - 1;

    Comm1.StopComm;
    Comm1.CommName := nItem.FPort;
    Comm1.BaudRate := nItem.FBote;

    Comm1.StartComm;
    Sleep(500);

    if not ConnectCtrl(nItem, nIdx, nData, nStr, True) then
      raise Exception.Create('');
    //xxxxx

    MISync.Enabled := True;
    Group1.Enabled := True;
    BtnRead.Enabled := True;

    with nData do
    begin
      nStr := '';
      Self.FScreen.FCard := FCardType;

      for nIdx:=Low(cCardList) to High(cCardList) do
      if cCardList[nIdx].FCard = FCardType then
      begin
        nStr := cCardList[nIdx].FName; Break;
      end;

      if nStr = '' then nStr := ML('未知');
      ListInfo.Items.Add(Format(ML('卡 型 号: %s'), [nStr]));

      nStr := Format(ML('设备编号: %d'), [Swap(FDevice)]);
      ListInfo.Items.Add(nStr);

      Self.FScreen.FLenX := FScreen[1]*8;
      Self.FScreen.FLenY := FScreen[0]*8;
      nStr := Format(ML('屏幕大小: %d x %d'), [Self.FScreen.FLenX, Self.FScreen.FLenY]);
      ListInfo.Items.Add(nStr);
      {
      nStr := Format(ML('播放天数: %d'), [Swap(FPlayDays[0])]);
      ListInfo.Items.Add(nStr);

      nStr := Format(ML('剩余天数: %d'), [Swap(FPlayDays[1])]);
      ListInfo.Items.Add(nStr);

      nStr := Format(ML('开屏时间: %d:%d'), [FOpenTime[0], FOpenTime[1]]);
      ListInfo.Items.Add(nStr);

      nStr := Format(ML('关屏时间: %d:%d'), [FCloseTime[0], FCloseTime[1]]);
      ListInfo.Items.Add(nStr);

      nStr := Format(ML('屏幕亮度: %d'), [FBright]);
      ListInfo.Items.Add(nStr);

      nStr := Format(ML('当前时间: %.2d:%.2d:%.2d'), [FNowTime[4], FNowTime[5],
              FNowTime[6]]);
      ListInfo.Items.Add(nStr);

      nStr := Format(ML('当前日期: %.2d-%.2d-%.2d %s'), [FNowTime[0],
              FNowTime[1], FNowTime[2], Week2Text(FNowTime[3])]);
      ListInfo.Items.Add(nStr);  }
    end;
  except
    BtnRead.Enabled := True;
    ShowMsg(nStr, sHint); Exit;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormStatus.MICardClick(Sender: TObject);
begin
  with TMenuItem(Sender) do
    Checked := not Checked;
  //xxxxx
end;

//Desc: 同步参数
procedure TfFormStatus.MISyncClick(Sender: TObject);
begin
  with PScreenItem(gScreenList[EditScreen.ItemIndex])^ do
  begin
    if MISize.Checked then
    begin
      FLenX := FScreen.FLenX;
      FLenY := FScreen.FLenY;
    end;

    if MICard.Checked then
      FCard := FScreen.FCard;
    //xxxxx

    SaveScreenList(gScreenList);
    fFormMain.RefreshScreeListView;
    ShowMsg(ML('参数已同步到当前节目', Name), sHint);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2010-8-19
//Parm: 屏幕;设备索引;保持状态;提示信息
//Desc: 向nScreen.nDevice设备发送电平控制指令
function SendELevelToDevice(const nScreen: PScreenItem; const nDevice: Integer;
 const nKeep: Byte; var nMsg: string): Boolean;
var nBool: Boolean;
    nSend: THead_Send_ELevel;
    nRespond: THead_Respond_ELevel;
begin
  nMsg := '';
  Result := False;
  FillChar(nSend, SizeOf(nSend), #0);
  
  nSend.FHead := Swap(cHead_DataSend);
  nSend.FLen := Swap(cSize_Head_Send_ELevel);
  nSend.FCardType := nScreen.FCard;

  if nDevice > 0 then
       nSend.FDevice := Swap(nScreen.FDevice[nDevice].FID)
  else nSend.FDevice := sFlag_BroadCast;

  nSend.FCommand := cCmd_SetELevel;
  nSend.FKeepMode := nKeep;

  nBool := False;
  nMsg := '与控制器通信失败';

  with FDM do
  try
    nBool := (Comm1.CommName = nScreen.FPort) and (Comm1.Handle > 1);

    if not nBool then
    begin
      Comm1.StopComm;
      Comm1.CommName := nScreen.FPort;
      Comm1.BaudRate := nScreen.FBote;
      
      Comm1.StartComm;
      Sleep(500);
    end; 

    nMsg := '发送数据失败';
    FWaitCommand := nSend.FCommand;
    Comm1.WriteCommData(@nSend, cSize_Head_Send_ELevel);

    if not WaitForTimeOut(nMsg) then
      raise Exception.Create('');
    //xxxxx

    Move(FDM.FValidBuffer[0], nRespond, cSize_Head_Respond_ELevel);
    Result := nRespond.FFlag = sFlag_OK;

    if Result then
         nMsg := ML('操作成功', cLangID)
    else nMsg := ML('操作失败', cLangID);
    
    if not nBool then Comm1.StopComm;
  except
    nMsg := ML(nMsg, cLangID);
    if not nBool then Comm1.StopComm;
  end;
end;

//Date: 2010-8-19
//Parm: 屏幕;设备索引;保持状态;提示信息
//Desc: 向nScreen.nDevice设备发送扫描模式切换
function SendScanModeToDevice(const nScreen: PScreenItem; const nDevice: Integer;
 const nKeep: Byte; var nMsg: string): Boolean;
var nBool: Boolean;
    nSend: THead_Send_ScanMode;
    nRespond: THead_Respond_ScanMode;
begin
  nMsg := '';
  Result := False;
  FillChar(nSend, SizeOf(nSend), #0);
  
  nSend.FHead := Swap(cHead_DataSend);
  nSend.FLen := Swap(cSize_Head_Send_ScanMode);
  nSend.FCardType := nScreen.FCard;

  if nDevice > 0 then
       nSend.FDevice := Swap(nScreen.FDevice[nDevice].FID)
  else nSend.FDevice := sFlag_BroadCast;

  nSend.FCommand := cCmd_SetScanMode;
  nSend.FKeepMode := nKeep;

  nBool := False;
  nMsg := '与控制器通信失败';

  with FDM do
  try
    nBool := (Comm1.CommName = nScreen.FPort) and (Comm1.Handle > 1);

    if not nBool then
    begin
      Comm1.StopComm;
      Comm1.CommName := nScreen.FPort;
      Comm1.BaudRate := nScreen.FBote;
      
      Comm1.StartComm;
      Sleep(500);
    end; 

    nMsg := '发送数据失败';
    FWaitCommand := nSend.FCommand;
    Comm1.WriteCommData(@nSend, cSize_Head_Send_ScanMode);

    if not WaitForTimeOut(nMsg) then
      raise Exception.Create('');
    //xxxxx

    Move(FDM.FValidBuffer[0], nRespond, cSize_Head_Respond_ScanMode);
    Result := nRespond.FFlag = sFlag_OK;

    if Result then
         nMsg := ML('操作成功', cLangID)
    else nMsg := ML('操作失败', cLangID);

    if not nBool then Comm1.StopComm;
  except
    nMsg := ML(nMsg, cLangID);
    if not nBool then Comm1.StopComm;
  end;
end;

//Desc: 电平
procedure TfFormStatus.BtnSwitchELevelClick(Sender: TObject);
var nStr: string;
    nKeep: Byte;
    nBtn: TButton;
begin
  nBtn := Sender as TButton;
  nBtn.Enabled := False;
  try
    if nBtn.Tag = 10 then nKeep := 0 else
    if nBtn.Tag = 20 then nKeep := 1 else nKeep := 0;

    SendELevelToDevice(gScreenList[EditScreen.ItemIndex], EditDevice.ItemIndex,
                       nKeep, nStr);
    ShowMsg(nStr, sHint);
  finally
    nBtn.Enabled := True;
  end;
end;

//Desc: 扫描模式
procedure TfFormStatus.BtnSwitchModeClick(Sender: TObject);
var nStr: string;
    nKeep: Byte;
    nBtn: TButton;
begin
  nBtn := Sender as TButton;
  nBtn.Enabled := False;
  try
    if nBtn.Tag = 10 then nKeep := 0 else
    if nBtn.Tag = 20 then nKeep := 1 else nKeep := 0;

    SendScanModeToDevice(gScreenList[EditScreen.ItemIndex], EditDevice.ItemIndex,
                       nKeep, nStr);
    ShowMsg(nStr, sHint);
  finally
    nBtn.Enabled := True;
  end;
end;

end.
