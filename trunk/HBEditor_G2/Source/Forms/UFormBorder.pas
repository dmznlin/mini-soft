{*******************************************************************************
  作者: dmzn@163.com 2010-8-18
  描述: 走马灯边框
*******************************************************************************}
unit UFormBorder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  USysConst, UBoderControl, StdCtrls;

type
  TfFormBorder = class(TForm)
    BtnSend: TButton;
    BtnOK: TButton;
    BtnExit: TButton;
    Group1: TGroupBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditScreen: TComboBox;
    EditDevice: TComboBox;
    Check1: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EditWidth: TComboBox;
    EditEffect: TComboBox;
    EditSpeed: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    EditColor: TComboBox;
    procedure BtnOKClick(Sender: TObject);
    procedure BtnSendClick(Sender: TObject);
    procedure EditColorDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private declarations }
    FScreen: PScreenItem;
    //屏幕对象
    FMovie: TZnBorderControl;
    //节目对象
    procedure InitFormData;
    //初始化
    function ApplySetting: Boolean;
    //应用设置
  public
    { Public declarations }
  end;

function SendBorderToDevice(const nScreen: PScreenItem; const nDevice: Integer;
 const nMovie: TZnBorderControl; var nMsg: string): Boolean;
//发送边框
procedure ShowBorderForm(const nMovie: TZnBorderControl; nScreen: PScreenItem);
//编辑边框

implementation

{$R *.dfm}
uses
  ULibFun, UDataModule, UProtocol, UMgrLang;

const
  cLangID = 'fFormBorder';
  cBorderWidth: array[1..10] of Byte = ($FE, $FC, $F8, $F0, $70, $30, $10, $00,
                                   $55, $77);
  //边框宽度,1-8个点,外加两点间隔三点间隔

//------------------------------------------------------------------------------
//Desc: 编辑nMovie节目的边框
procedure ShowBorderForm(const nMovie: TZnBorderControl; nScreen: PScreenItem);
begin
  with TfFormBorder.Create(Application) do
  begin
    Caption := '边框';
    FScreen := nScreen;
    FMovie := nMovie;
    Position := poScreenCenter;

    InitFormData;
    ShowModal;
    Free;
  end;
end;

//Date: 2010-8-19
//Parm: 屏幕;设备索引;节目;提示信息
//Desc: 向nScreen.nDevice设备发送nMovie的边框
function SendBorderToDevice(const nScreen: PScreenItem; const nDevice: Integer;
 const nMovie: TZnBorderControl; var nMsg: string): Boolean;
var nBool: Boolean;
    nSend: THead_Send_SetBorder;
    nRespond: THead_Respond_SetBorder;
begin
  nMsg := '';
  Result := False;
  FillChar(nSend, SizeOf(nSend), #0);
  
  nSend.FHead := Swap(cHead_DataSend);
  nSend.FLen := Swap(cSize_Head_Send_SetBorder);
  nSend.FCardType := nScreen.FCard;

  if nDevice > 0 then
       nSend.FDevice := Swap(nScreen.FDevice[nDevice].FID)
  else nSend.FDevice := sFlag_BroadCast;

  nSend.FCommand := cCmd_SetBorder;
  if nMovie.HasBorder then
       nSend.FHasBorder := 1
  else nSend.FHasBorder := 0;

  nSend.FEffect := Ord(nMovie.BorderEffect);
  nSend.FSpeed := nMovie.BorderSpeed;
  nSend.FWidth := cBorderWidth[nMovie.BorderWidth];

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
    Comm1.WriteCommData(@nSend, cSize_Head_Send_SetBorder);

    if not WaitForTimeOut(nMsg) then
      raise Exception.Create('');
    //xxxxx

    Move(FDM.FValidBuffer[0], nRespond, cSize_Head_Respond_SetBorder);
    Result := nRespond.FFlag = sFlag_OK;

    if Result then
         nMsg := ML('节目边框设置成功', cLangID)
    else nMsg := ML('节目边框设置失败', cLangID);

    if not nBool then Comm1.StopComm;
  except
    nMsg := ML(nMsg, cLangID);
    if not nBool then Comm1.StopComm;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 初始化
procedure TfFormBorder.InitFormData;
var nStr: string;
    nIdx: Integer;
begin
  gMultiLangManager.SectionID := cLangID;
  gMultiLangManager.TranslateAllCtrl(Self);
  
  EditScreen.Items.Add(Format('%d-%s', [FScreen.FID, FScreen.FName]));
  EditScreen.ItemIndex := 0;

  EditDevice.Items.Add(ML('全部设备'));
  for nIdx:=Low(FScreen.FDevice) to High(FScreen.FDevice) do
  begin
    nStr := Format('%d-%s', [FScreen.FDevice[nIdx].FID, FScreen.FDevice[nIdx].FName]);
    EditDevice.Items.Add(nStr);
  end;

  EditDevice.ItemIndex := 0;
  Check1.Checked := FMovie.HasBorder;
  EditWidth.ItemIndex := FMovie.BorderWidth-1;
  EditEffect.ItemIndex := FMovie.BorderEffect;
  EditSpeed.Text := IntToStr(FMovie.BorderSpeed);

  FillColorCombox(EditColor);
  SetColorComboxIndex(EditColor, FMovie.BorderColor);
end;

//Desc: 应用设置
function TfFormBorder.ApplySetting: Boolean;
begin
  Result := False;
  if (not IsNumber(EditSpeed.Text, False)) or
     (StrToInt(EditSpeed.Text) < 0) or (StrToInt(EditSpeed.Text) > 15) then
  begin
    EditSpeed.SetFocus;
    ShowMsg(ML('请填写有效的速度值'), sHint); Exit;
  end;

  FMovie.BorderWidth := EditWidth.ItemIndex+1;
  FMovie.BorderEffect := EditEffect.ItemIndex;
  FMovie.BorderSpeed := StrToInt(EditSpeed.Text);

  FMovie.HasBorder := Check1.Checked;
  FMovie.BorderColor := Integer(EditColor.Items.Objects[EditColor.ItemIndex]);
  Result := True;
end;

procedure TfFormBorder.BtnOKClick(Sender: TObject);
begin
  if ApplySetting then ModalResult := mrOk;
end;

procedure TfFormBorder.BtnSendClick(Sender: TObject);
var nStr: string;
begin
  if ApplySetting then
  begin
    SendBorderToDevice(FScreen, EditDevice.ItemIndex, FMovie, nStr);
    ShowMsg(nStr, sHint);
  end;
end;

procedure TfFormBorder.EditColorDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var nColor: TColor;
    nCombox: TComboBox;
begin
  if Control is TComboBox then
  begin
    nCombox := TComboBox(Control);
    nColor := Integer(nCombox.Items.Objects[Index]);
    nCombox.Canvas.Brush.Color := nColor;
    nCombox.Canvas.FillRect(Rect);
  end;
end;

end.
