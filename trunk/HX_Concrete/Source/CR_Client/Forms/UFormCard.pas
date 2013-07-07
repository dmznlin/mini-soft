{*******************************************************************************
  作者: dmzn@163.com 2012-4-5
  描述: 关联磁卡
*******************************************************************************}
unit UFormCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  CPort, CPortTypes, UFormNormal, UFormBase, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxTextEdit,
  dxLayoutControl, StdCtrls, cxGraphics;

type
  TfFormCard = class(TfFormNormal)
    EditBill: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item5: TdxLayoutItem;
    EditCard: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    ComPort1: TComPort;
    procedure BtnOKClick(Sender: TObject);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditCardKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FBuffer: string;
    //接收缓冲
    FParam: PFormCommandParam;
    procedure InitFormData;
    procedure ActionComPort(const nStop: Boolean);
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, USysBusiness, USmallFunc, USysConst;

type
  TReaderType = (ptT800, pt8142);
  //表头类型

  TReaderItem = record
    FType: TReaderType;
    FPort: string;
    FBaud: string;
    FDataBit: Integer;
    FStopBit: Integer;
    FCheckMode: Integer;
  end;

var
  gReaderItem: TReaderItem;
  //全局使用

class function TfFormCard.FormID: integer;
begin
  Result := cFI_FormMakeCard;
end;

class function TfFormCard.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;

  with TfFormCard.Create(Application) do
  try
    FParam := nParam;
    InitFormData;
    ActionComPort(False);

    FParam.FCommand := cCmd_ModalResult;
    FParam.FParamA := ShowModal;
  finally
    Free;
  end;
end;

procedure TfFormCard.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ActionComPort(True);
end;

procedure TfFormCard.InitFormData;
begin
  ActiveControl := EditCard;
  EditBill.Text := FParam.FParamA;
  EditTruck.Text := FParam.FParamB;
end;

//Desc: 串口操作
procedure TfFormCard.ActionComPort(const nStop: Boolean);
var nInt: Integer;
    nIni: TIniFile;
begin
  if nStop then
  begin
    ComPort1.Close;
    Exit;
  end;

  with ComPort1 do
  begin
    with Timeouts do
    begin
      ReadTotalConstant := 100;
      ReadTotalMultiplier := 10;
    end;

    nIni := TIniFile.Create(gPath + 'Reader.Ini');
    with gReaderItem do
    try
      nInt := nIni.ReadInteger('Param', 'Type', 1);
      FType := TReaderType(nInt - 1);

      FPort := nIni.ReadString('Param', 'Port', '');
      FBaud := nIni.ReadString('Param', 'Rate', '4800');
      FDataBit := nIni.ReadInteger('Param', 'DataBit', 8);
      FStopBit := nIni.ReadInteger('Param', 'StopBit', 0);
      FCheckMode := nIni.ReadInteger('Param', 'CheckMode', 0);

      Port := FPort;
      BaudRate := StrToBaudRate(FBaud);

      case FDataBit of
       5: DataBits := dbFive;
       6: DataBits := dbSix;
       7: DataBits :=  dbSeven else DataBits := dbEight;
      end;

      case FStopBit of
       2: StopBits := sbTwoStopBits;
       15: StopBits := sbOne5StopBits
       else StopBits := sbOneStopBit;
      end;
    finally
      nIni.Free;
    end;

    ComPort1.Open;
  end;
end;

procedure TfFormCard.ComPort1RxChar(Sender: TObject; Count: Integer);
var nStr: string;
    nIdx,nLen: Integer;
begin
  ComPort1.ReadStr(nStr, Count);
  FBuffer := FBuffer + nStr;

  nLen := Length(FBuffer);
  if nLen < 7 then Exit;

  for nIdx:=1 to nLen do
  begin
    if (FBuffer[nIdx] <> #$AA) or (nLen - nIdx < 6) then Continue;
    if (FBuffer[nIdx+1] <> #$FF) or (FBuffer[nIdx+2] <> #$00) then Continue;

    nStr := Copy(FBuffer, nIdx+3, 4);
    EditCard.Text := ParseCardNO(nStr, True); 

    FBuffer := '';
    Exit;
  end;
end;

procedure TfFormCard.EditCardKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    BtnOK.Click;
  end else OnCtrlKeyPress(Sender, Key);
end;

//Desc: 保存磁卡
procedure TfFormCard.BtnOKClick(Sender: TObject);
begin
  EditCard.Text := Trim(EditCard.Text);
  if EditCard.Text = '' then
  begin
    ActiveControl := EditCard;
    EditCard.SelectAll;

    ShowMsg('请输入有效卡号', sHint);
    Exit;
  end;

  if SaveBillCard(EditBill.Text, EditTruck.Text, EditCard.Text) then
    ModalResult := mrOk;
  //done
end;

initialization
  gControlManager.RegCtrl(TfFormCard, TfFormCard.FormID);
end.
