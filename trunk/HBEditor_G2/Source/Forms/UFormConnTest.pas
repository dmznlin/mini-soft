{*******************************************************************************
  作者: dmzn@163.com 2009-11-10
  描述: 连接测试
*******************************************************************************}
unit UFormConnTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ULibFun, UDataModule, USysConst, UProtocol, StdCtrls, UMgrLang;

type
  TfFormConnTest = class(TForm)
    GroupBox1: TGroupBox;
    BtnTest: TButton;
    BtnExit: TButton;
    Label1: TLabel;
    Label2: TLabel;
    EditScreen: TComboBox;
    EditDevice: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure EditScreenChange(Sender: TObject);
    procedure BtnTestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowConnTestForm: Boolean;
function ConnectCtrl(const nScreen: PScreenItem; const nIdx: Integer;
  var nRespond: THead_Respond_ConnCtrl; var nHint: string): Boolean; overload;
function ConnectCtrl(const nScreen: PScreenItem; const nIdx: Integer;
  var nRespond: THead_Respond_ConnCtrl; var nHint: string;
  const nCircleCheck: Boolean): Boolean; overload;
//入口函数

implementation

{$R *.dfm}

//Desc: 连接测试窗口
function ShowConnTestForm: Boolean;
begin
  with TfFormConnTest.Create(Application) do
  begin
    Caption := ML('连接测试');
    Result := ShowModal = mrOk;
    Free;
  end;
end;

//Desc: 连接nScreen屏的第nIdx个设备
function ConnectCtrl(const nScreen: PScreenItem; const nIdx: Integer;
  var nRespond: THead_Respond_ConnCtrl; var nHint: string): Boolean;
var nStr: string;
    nData: THead_Send_ConnCtrl;
begin
  Result := False;
  FillChar(nData, cSize_Head_Send_ConnCtrl, #0);

  nData.FHead := Swap(cHead_DataSend);
  nData.FLen := Swap(cSize_Head_Send_ConnCtrl);
  nData.FCardType := nScreen.FCard;

  if nIdx > -1 then
       nData.FDevice := Swap(nScreen.FDevice[nIdx].FID)
  else nData.FDevice := sFlag_BroadCast;
  nData.FCommand := cCmd_ConnCtrl;

  with FDM do
  try
    nHint := ML('发送数据失败');
    FWaitCommand := nData.FCommand;
    if not Comm1.WriteCommData(@nData, cSize_Head_Send_ConnCtrl) then Exit;

    nHint := ML('连接控制器超时');
    if not WaitForTimeOut(nStr) then Exit;

    Move(FDM.FValidBuffer[0], nRespond, cSize_Head_Respond_ConnCtrl);
    nHint := '';
    Result := True;
  except
    //ignor any error
  end;
end;

function ConnectCtrl(const nScreen: PScreenItem; const nIdx: Integer;
  var nRespond: THead_Respond_ConnCtrl; var nHint: string;
  const nCircleCheck: Boolean): Boolean;
var nCard: Byte;
begin
  Result := ConnectCtrl(nScreen, nIdx, nRespond, nHint);
  if Result  then Exit;

  nCard := nScreen.FCard;
  try
    nScreen.FCard := (nScreen.FCard + 1) mod 4;
    Result := ConnectCtrl(nScreen, nIdx, nRespond, nHint);
    if Result  then Exit;

    nScreen.FCard := (nScreen.FCard + 2) mod 4;
    Result := ConnectCtrl(nScreen, nIdx, nRespond, nHint);
    if Result  then Exit;

    nScreen.FCard := (nScreen.FCard + 3) mod 4;
    Result := ConnectCtrl(nScreen, nIdx, nRespond, nHint);
  finally
    nScreen.FCard := nCard;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormConnTest.FormCreate(Sender: TObject);
var i,nCount: integer;
    nItem: PScreenItem;
begin
  LoadFormConfig(Self);
  gMultiLangManager.SectionID := Name;
  gMultiLangManager.TranslateAllCtrl(Self);

  EditScreen.Clear;
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

procedure TfFormConnTest.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

procedure TfFormConnTest.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
//Desc: 读取设备号
procedure TfFormConnTest.EditScreenChange(Sender: TObject);
var nStr: string;
    nIdx: integer;
    nItem: PScreenItem;
begin
  EditDevice.Clear;
  if EditScreen.ItemIndex < 0 then Exit;

  EditDevice.Items.Add(ML('全部设备'));
  nItem := gScreenList[EditScreen.ItemIndex];

  for nIdx:=Low(nItem.FDevice) to High(nItem.FDevice) do
  begin
    nStr := Format('%d-%s', [nItem.FDevice[nIdx].FID, nItem.FDevice[nIdx].FName]);
    EditDevice.Items.Add(nStr);
  end;

  EditDevice.ItemIndex := 0;
end;

//Desc: 测试
procedure TfFormConnTest.BtnTestClick(Sender: TObject);
var nStr: string;
    nItem: PScreenItem;
    nData: THead_Respond_ConnCtrl;
begin
  if EditScreen.ItemIndex < 0 then
  begin
    EditScreen.SetFocus;
    ShowMsg(ML('请选择待测试的屏幕'), sHint); Exit;
  end;

  BtnTest.Enabled := False;
  try
    nItem := gScreenList[EditScreen.ItemIndex];
    nStr := ML('与控制器通信失败');

    with FDM do
    begin
      Comm1.StopComm;
      Comm1.CommName := nItem.FPort;
      Comm1.BaudRate := nItem.FBote;

      Comm1.StartComm;
      Sleep(500);
    end;

    if ConnectCtrl(nItem, EditDevice.ItemIndex - 1, nData, nStr, True) then
    begin
      nStr := Format(ML('行x列: %dx%d'), [nData.FScreen[0]*8,
                                          nData.FScreen[1]*8]);
      ShowMsg(ML('连接测试成功'), nStr);
      ModalResult := mrOk;
    end else ShowMsg(nStr, sHint);

    BtnTest.Enabled := True;
    FDM.Comm1.StopComm;
  except
    BtnTest.Enabled := True;
    FDM.Comm1.StopComm;
    ShowMsg(nStr, sHint);
  end;
end;

end.
