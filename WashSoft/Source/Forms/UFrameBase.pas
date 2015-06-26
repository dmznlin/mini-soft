{*******************************************************************************
  ����: dmzn@163.com 2009-5-22
  ����: Frame����,ʵ��ͳһ�ĺ�������
*******************************************************************************}
unit UFrameBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

const
  WM_FrameChange = WM_User + $0027;
  
type
  TControlChangeState = (fsNew, fsFree, fsActive);
  TControlChangeEvent = procedure (const nName: string; const nCtrl: TWinControl;
    const nState: TControlChangeState) of object;
  //�ؼ��䶯
  
  PFrameCommandParam = ^TFrameCommandParam;
  TFrameCommandParam = record
    FCommand: integer;
    FParamA: Variant;
    FParamB: Variant;
    FParamC: Variant;
    FParamD: Variant;
    FParamE: Variant;
  end;
  
  TBaseFrame = class(TFrame)
  private
    procedure SetPopedom(const nItem: string);
    function GetParentForm: Boolean;
    procedure CMRelease(var Message: TMessage); message CM_RELEASE;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
  protected
    { Protected declarations }
    FParentForm: TForm;
    {���ڴ���}
    FIsBusy: Boolean;
    {*��æ״̬*}
    FPopedom: string;
    {*Ȩ����*}
    procedure SetZOrder(TopMost: Boolean); override;
    {*λ���л�*}
    function FrameTitle: string; virtual;
    procedure OnCreateFrame; virtual;
    procedure OnShowFrame; virtual;
    procedure OnDestroyFrame; virtual;
    procedure DoOnClose(var nAction: TCloseAction); virtual;
    procedure OnLoadPopedom; virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {*�����ͷ�*}
    procedure Close(const nEvent: Boolean = True);
    {*�ر�*}
    function DealCommand(Sender: TObject; const nCmd: integer): integer; virtual;
    {*��������*}
    class function GetCtrlParentForm(const nCtrl: TWinControl): TForm;
    {*��ȡ����*}
    class function MakeFrameName(const nFrameID: integer): string;
    class function FrameID: integer; virtual; abstract;
    {*��ʶ*}
    property ParentForm: TForm read FParentForm;
    property PopedomItem: string read FPopedom write SetPopedom;
    property IsBusy: Boolean read FIsBusy write FIsBusy;
    {*����*}
  end;

function CreateBaseFrameItem(const nFrameID: Integer; const nParent: TWinControl;
 const nPopedom: string = ''): TBaseFrame;
function BroadcastFrameCommand(Sender: TObject; const nCmd:integer): integer;
procedure SetFrameChangeEvent(const nCallBack: TControlChangeEvent);
//��ں���

implementation

{$R *.dfm}
uses
  UMgrControl;

var
  gFrameChange: TControlChangeEvent = nil;
  //Frame�䶯

procedure SetFrameChangeEvent(const nCallBack: TControlChangeEvent);
begin
  gFrameChange := nCallBack;
end;

//Desc: ������㲥�����е�Frame��
function BroadcastFrameCommand(Sender: TObject; const nCmd:integer): integer;
var nList: TList;
    i,nCount: integer;
begin
  nList := TList.Create;
  try
    Result := 0;
    if not gControlManager.GetAllInstance(nList) then Exit;

    nCount := nList.Count - 1;
    for i:=0 to nCount do
     if TObject(nList[i]) is TBaseFrame then
      Result := Result + TBaseFrame(nList[i]).DealCommand(Sender, nCmd);
    //broadcast command and combine then result
  finally
    nList.Free;
  end;
end;

//Date: 2009-6-13
//Parm: FrameID;������;Ȩ����
//Desc: ������ʶΪnFormID��Frameʵ��
function CreateBaseFrameItem(const nFrameID: Integer; const nParent: TWinControl;
 const nPopedom: string = ''): TBaseFrame;
var nCtrl: TWinControl;
begin
  Result := nil;
  nCtrl := gControlManager.NewCtrl2(nFrameID, nParent);
  
  if Assigned(nCtrl) and (nCtrl is TBaseFrame) then
       Result := nCtrl as TBaseFrame
  else Exit;

  Result.PopedomItem := nPopedom;
  Result.BringToFront;
end;

//------------------------------------------------------------------------------
constructor TBaseFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Name := MakeFrameName(FrameID);
  
  if not GetParentForm then
    raise Exception.Create('Invalid Frame Owner');
  //no parent isn't invalid

  if Assigned(gFrameChange) then
    gFrameChange(FrameTitle, Self, fsNew);
  //xxxxx

  FIsBusy := False;
  OnCreateFrame;
end;

destructor TBaseFrame.Destroy;
begin
  if Assigned(gFrameChange) then
    gFrameChange(FrameTitle, Self, fsFree);
  //xxxxx

  OnDestroyFrame;
  gControlManager.FreeCtrl(FrameID, False);
  inherited;
end;

//Desc: �ر�
procedure TBaseFrame.Close;
var nAction: TCloseAction;
begin
  nAction := caFree;
  if nEvent then DoOnClose(nAction);

  if nAction = caFree then
  begin
    PostMessage(Handle, CM_RELEASE, 0, 0);
  end else //�ͷ�
  if nAction = caHide then
  begin
    Visible := False;
  end; //����
end;

//Desc: �ر�ʱ�ͷ�
procedure TBaseFrame.CMRelease(var Message: TMessage);
begin
  inherited;
  Free;
end;

//Desc: ����FrameID���������
class function TBaseFrame.MakeFrameName(const nFrameID: integer): string;
begin
  Result := 'Frame' + IntToStr(nFrameID);
end;

//Desc: ���Z��λ�ñ䶯
procedure TBaseFrame.SetZOrder(TopMost: Boolean);
begin
  inherited;
  if Assigned(gFrameChange) then
    gFrameChange(FrameTitle, Self, fsActive);
  //xxxxx
end;

//Desc: ��ʾʱ����
procedure TBaseFrame.CMShowingChanged(var Message: TMessage);
begin
  inherited;
  if Showing then OnShowFrame;
end;

//Desc: ��ѯnCtrl���ڴ���
class function TBaseFrame.GetCtrlParentForm(const nCtrl: TWinControl): TForm;
var nTmp: TWinControl;
begin
  Result := nil;
  nTmp := nCtrl;

  while Assigned(nTmp) do
  if nTmp is TForm then
  begin
    Result := nTmp as TForm;
    Break;
  end else nTmp := nTmp.Parent;
end;

//Desc: �������ڴ���
function TBaseFrame.GetParentForm: Boolean;
begin
  if Owner is TWinControl then
       FParentForm := GetCtrlParentForm(Owner as TWinControl)
  else FParentForm := nil;

  Result := Assigned(FParentForm);
end;

//Desc: ����Ȩ����
procedure TBaseFrame.SetPopedom(const nItem: string);
begin
  if FPopedom <> nItem then
  begin
    FPopedom := nItem;
    OnLoadPopedom;
  end;
end;

//Desc: �ر�
procedure TBaseFrame.DoOnClose(var nAction: TCloseAction);
begin

end;

function TBaseFrame.FrameTitle: string;
begin
  Result := Name;
end;

//Desc: ��ʾ
procedure TBaseFrame.OnShowFrame;
begin

end;

//Desc: ����Ȩ��
procedure TBaseFrame.OnLoadPopedom;
begin

end;

//Desc: ����
procedure TBaseFrame.OnCreateFrame;
begin

end;

//Desc: �ͷ�
procedure TBaseFrame.OnDestroyFrame;
begin

end;

//Desc: ��������
function TBaseFrame.DealCommand(Sender: TObject; const nCmd: integer): integer;
begin
  Result := -1;
end;

end.
