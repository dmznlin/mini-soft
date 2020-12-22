unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient;

type
  TfFormMain = class(TForm)
    Group1: TGroupBox;
    EditIP: TLabeledEdit;
    EditPort: TLabeledEdit;
    Check1: TCheckBox;
    Group2: TGroupBox;
    BtnSend: TButton;
    BtnQuery: TButton;
    Memo1: TMemo;
    IdClient1: TIdTCPClient;
    EditID: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure IdClient1Connected(Sender: TObject);
    procedure IdClient1Disconnected(Sender: TObject);
    procedure IdClient1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
    procedure Check1Click(Sender: TObject);
    procedure BtnSendClick(Sender: TObject);
    procedure BtnQueryClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateControl(const nConn: Boolean);
    //更新状态
    procedure WriteLog(const nEvent: string);
    //记录日志
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  IdGlobal, ULibFun, UProtocol;

procedure TfFormMain.FormCreate(Sender: TObject);
begin
  UpdateControl(False);
end;

procedure TfFormMain.WriteLog(const nEvent: string);
begin
  Memo1.Lines.Insert(0, FormatDateTime('hh:nn:ss.zzz', Now()) + #9 + nEvent);
end;

procedure TfFormMain.UpdateControl(const nConn: Boolean);
begin
  BtnSend.Enabled := nConn;
  BtnQuery.Enabled := nConn;

  if not nConn then
    Check1.Checked := False;
  //xxxxx
end;

procedure TfFormMain.IdClient1Connected(Sender: TObject);
begin
  UpdateControl(True);
end;

procedure TfFormMain.IdClient1Disconnected(Sender: TObject);
begin
  UpdateControl(False);
end;

procedure TfFormMain.IdClient1Status(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
  WriteLog(AStatusText);
end;

procedure TfFormMain.Check1Click(Sender: TObject);
begin
  if ActiveControl <> Check1 then Exit;
  IdClient1.Disconnect;

  if Check1.Checked then
  try
    IdClient1.Host := EditIP.Text;
    IdClient1.Port := StrToInt(EditPort.Text);
    IdClient1.Connect;
  except
    on nErr: Exception do
    begin
      WriteLog(nErr.Message);
      Check1.Checked := False;
    end;
  end;
end;

procedure TfFormMain.BtnSendClick(Sender: TObject);
var nFrame: TFrameData;
    nData: TRunData;
    nBuf: TIdBytes;
begin
  WriteLog('上传数据');
  InitFrameData(nFrame);
  InitRunData(nData);

  with nFrame do
  begin
    FStation := StrToInt(EditID.Text);
    FCommand := cFrame_CMD_UpData;
    FExtCMD := cFrame_Ext_RunData;
  end;

  with nData do
  begin
    I00 := 1;
    I01 := 2;
    I02 := 3;
    PutValFloat(1.1, VD300);
    PutValFloat(1.2, VD304);
    PutValFloat(1.3, VD308);
    PutValFloat(1.4, VD312);
    PutValFloat(1.5, VD316);
    PutValFloat(1.6, VD320);
    PutValFloat(1.7, VD324);
    PutValFloat(1.8, VD328);
    PutValFloat(1.9, VD332);
    PutValFloat(2.0, VD336);
    PutValFloat(2.1, VD340);
    PutValFloat(2.2, VD348);
    PutValFloat(2.3, VD352);
    PutValFloat(2.4, VD356);

    V3650   := 4;
    V3651   := 5;
    V3652   := 6;
    V3653   := 7;
    V3654   := 8;
    V3655   := 9;
    V3656   := 10;
    V3657   := 11;
    V20000  := 12;
    V20001  := 13;
    V20002  := 14;
  end;

  nBuf := BuildRunData(@nFrame, @nData);
  IdClient1.IOHandler.Write(nBuf);
end;

procedure TfFormMain.BtnQueryClick(Sender: TObject);
var nFrame: TFrameData;
    nParams: TRunParams;
    nBuf: TIdBytes;
    nInt: Integer;
begin
  WriteLog('查询数据');
  InitFrameData(nFrame);

  with nFrame do
  begin
    FStation := StrToInt(EditID.Text);
    FCommand := cFrame_CMD_QueryData;
    FExtCMD := cFrame_Ext_RunParam;
    FDataLen := 0;
    FData[0] := cFrame_End;
  end;

  with IdClient1.IOHandler do
  begin
    nBuf := RawToBytes(nFrame, FrameValidLen(@nFrame));
    Write(nBuf);
    
    ReadBytes(nBuf, 8, False);
    //读取协议开始定长数据

    if BytesToString(nBuf, 0, 3, Indy8BitEncoding) <> cFrame_Begin then //帧头无效
    begin
      InputBuffer.Clear;
      Exit;
    end;

    ReadBytes(nBuf, nBuf[7], True);
    //读取数据
    ReadBytes(nBuf, 1, True);
    //读取帧尾

    nInt := Length(nBuf);
    if Char(nBuf[nInt - 1]) <> cFrame_End then //帧尾无效
    begin
      InputBuffer.Clear;
      Exit;
    end;

    WriteLog('查询成功');
  end;
end;

end.
