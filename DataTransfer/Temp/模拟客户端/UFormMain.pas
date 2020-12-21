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
    procedure FormCreate(Sender: TObject);
    procedure IdClient1Connected(Sender: TObject);
    procedure IdClient1Disconnected(Sender: TObject);
    procedure IdClient1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
    procedure Check1Click(Sender: TObject);
    procedure BtnSendClick(Sender: TObject);
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
    FStation := 1010;
    FCommand := cFrame_CMD_UpData;
    FExtCMD := cFrame_Ext_RunData;
  end;

  with nData do
  begin
    I00 := 1;
    I01 := 2;
    I02 := 3;
    PutValFloat(12.1324, VD300);
  end;

  nBuf := BuildRunData(@nFrame, @nData);
  IdClient1.IOHandler.Write(nBuf);
end;

end.
