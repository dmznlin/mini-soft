{*******************************************************************************
  作者: dmzn@163.com 2019-09-25
  描述: 
*******************************************************************************}
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IdBaseComponent, IdComponent, IdUDPBase,
  IdUDPServer, IdGlobal, IdSocketHandle, UMgrAliVision;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Check1: TCheckBox;
    Check2: TCheckBox;
    Timer1: TTimer;
    EditIP: TLabeledEdit;
    EditPort: TLabeledEdit;
    UDP1: TIdUDPServer;
    Memo1: TMemo;
    EditTruck: TLabeledEdit;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    LabeledEdit7: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Check1Click(Sender: TObject);
  private
    { Private declarations }
    procedure DoLog(const nEvent: string);
    procedure DoTruckStatusChange(const nPound: PPoundItem);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses UMgrERelayPLC, ULibFun, USysLoger;

var
  gPath: string;

procedure TForm1.FormCreate(Sender: TObject);
begin
  gPath := ExtractFilePath(Application.ExeName);
  gSysLoger := TSysLoger.Create(gPath + 'Logs\');
  gSysLoger.LogEvent := DoLog;
  gSysLoger.LogSync := True;

  gVisionManager := TTruckManager.Create;
  gVisionManager.LoadConfig('D:\Program Files\MyVCL\znlib\Hardware\AliVision.xml');
  gVisionManager.OnStatusChangeEvent := DoTruckStatusChange;
  gVisionManager.EventMode := emMain;
  gVisionManager.StartService;
end;

procedure TForm1.DoLog(const nEvent: string);
begin
  Memo1.Lines.Add(nEvent)
end;

procedure TForm1.Check1Click(Sender: TObject);
begin
  Timer1.Enabled := Check1.Checked or Check2.Checked;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var nStr: string;
begin
  if Check1.Checked then
  begin
    nStr := '{channel: 192168112301, lr_result: <Henan>AF1001}';
    UDP1.Send(EditIP.Text, StrToInt(EditPort.Text), nStr);
  end;

  if Check2.Checked then
  begin
    nStr := '{channel: 192168112301, pd_result: 0}';
    UDP1.Send(EditIP.Text, StrToInt(EditPort.Text), nStr);
  end;
end;

procedure TForm1.DoTruckStatusChange(const nPound: PPoundItem);
var nStr: string;
begin
  case nPound.FStateNow of
   tsNewOn   : nStr := Format('新车牌[ %s ]上磅', [nPound.FTruck]);
   tsLeave   : nStr := Format('车辆[ %s ]离开地磅', [nPound.FTruckPrev]);
   tsNormal  : nStr := Format('车辆[ %s ]状态正常', [nPound.FTruck]);
   tsOut     : nStr := Format('车辆[ %s ]未完全上磅', [nPound.FTruck])
   else        nStr := '';
  end;

  if nStr <> '' then gSysLoger.AddLog(nStr);
end;

end.
