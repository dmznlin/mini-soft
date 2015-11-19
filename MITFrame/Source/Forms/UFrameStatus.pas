{*******************************************************************************
  ����: dmzn@163.com 2015-11-18
  ����: ���ж����ڴ�״̬
*******************************************************************************}
unit UFrameStatus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameBase, ExtCtrls, StdCtrls;

type
  TfFrameStatus = class(TfFrameBase)
    Panel1: TPanel;
    MemoStatus: TMemo;
    Bevel1: TBevel;
    Check1: TCheckBox;
    BtnClear: TButton;
    BtnCopy: TButton;
    Timer1: TTimer;
    procedure BtnCopyClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure Check1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UBaseObject, UMITConst;

class function TfFrameStatus.FrameID: integer;
begin
  Result := cFI_FrameStatus;
end;

procedure TfFrameStatus.BtnCopyClick(Sender: TObject);
begin
  MemoStatus.CopyToClipboard;
  ShowMsg('�Ѹ��Ƶ�ճ����', sHint);
end;

procedure TfFrameStatus.BtnClearClick(Sender: TObject);
begin
  MemoStatus.Lines.BeginUpdate;
  MemoStatus.Clear;
  MemoStatus.Lines.EndUpdate;
end;

procedure TfFrameStatus.Check1Click(Sender: TObject);
begin
  Timer1.Enabled := Check1.Checked;
end;

procedure TfFrameStatus.Timer1Timer(Sender: TObject);
begin
  if not Check1.Checked then
    Timer1.Enabled := False;
  //xxxxx

  if ParentForm.Active and (Parent.Controls[Parent.ControlCount - 1] = Self) then
    gCommonObjectManager.GetStatus(MemoStatus.Lines);
  //�����弤��,��λ�����ϲ�
end;

initialization
  gControlManager.RegCtrl(TfFrameStatus, TfFrameStatus.FrameID);
end.
