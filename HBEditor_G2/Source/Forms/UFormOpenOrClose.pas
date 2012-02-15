{*******************************************************************************
  作者: dmzn@163.com 2009-11-10
  描述: 手动开关屏幕
*******************************************************************************}
unit UFormOpenOrClose;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ULibFun, UDataModule, USysConst, UProtocol, StdCtrls, UMgrLang;

type
  TfFormOpenOrClose = class(TForm)
    GroupBox1: TGroupBox;
    BtnTest: TButton;
    BtnExit: TButton;
    Label1: TLabel;
    Label2: TLabel;
    EditScreen: TComboBox;
    EditDevice: TComboBox;
    Label3: TLabel;
    Radio1: TRadioButton;
    Radio2: TRadioButton;
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

function ShowOpenOrCloseForm: Boolean;
//入口函数

implementation

{$R *.dfm}

//Desc: 重置窗口
function ShowOpenOrCloseForm: Boolean;
begin
  with TfFormOpenOrClose.Create(Application) do
  begin
    Caption := ML('开/关屏幕');
    Result := ShowModal = mrOk;
    Free;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormOpenOrClose.FormCreate(Sender: TObject);
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

procedure TfFormOpenOrClose.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

procedure TfFormOpenOrClose.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
//Desc: 读取设备号
procedure TfFormOpenOrClose.EditScreenChange(Sender: TObject);
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
procedure TfFormOpenOrClose.BtnTestClick(Sender: TObject);
var nStr: string;
    nItem: PScreenItem;
    nData: THead_Send_OpenOrClose;
    nRespond: THead_Respond_OpenOrClose;
begin
  if EditScreen.ItemIndex < 0 then
  begin
    EditScreen.SetFocus;
    ShowMsg(ML('请选择待控制的屏幕'), sHint); Exit;
  end;

  nItem := gScreenList[EditScreen.ItemIndex];
  FillChar(nData, cSize_Head_Send_OpenOrClose, #0);

  nData.FHead := Swap(cHead_DataSend);
  nData.FLen := Swap(cSize_Head_Send_OpenOrClose);
  nData.FCardType := nItem.FCard;

  if EditDevice.ItemIndex > 0 then
       nData.FDevice := Swap(nItem.FDevice[EditDevice.ItemIndex - 1].FID)
  else nData.FDevice := sFlag_BroadCast;

  nData.FCommand := cCmd_OpenOrClose;
  if Radio1.Checked then nData.FFlag := 1;

  with FDM do
  try
    BtnTest.Enabled := False;
    nStr := '与控制器通信失败';

    Comm1.StopComm;
    Comm1.CommName := nItem.FPort;
    Comm1.BaudRate := nItem.FBote;

    Comm1.StartComm;
    Sleep(500);

    nStr := '发送数据失败';
    FWaitCommand := nData.FCommand;
    Comm1.WriteCommData(@nData, cSize_Head_Send_OpenOrClose);

    if not WaitForTimeOut(nStr) then
      raise Exception.Create('');
    //xxxxx

    Move(FDM.FValidBuffer[0], nRespond, cSize_Head_Respond_OpenOrClose);
    if nRespond.FFlag = sFlag_OK then
    begin
      ModalResult := mrOk;
      ShowMsg(ML('操作成功'), sHint);
    end else ShowMsg(ML('操作失败'), sHint);

    BtnTest.Enabled := True;
  except
    BtnTest.Enabled := True;
    ShowMsg(ML(nStr), sHint);
  end;
end;

end.
