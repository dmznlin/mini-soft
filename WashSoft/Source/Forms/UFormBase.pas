{*******************************************************************************
  ����: dmzn@163.com 2009-6-13
  ����: Form����,ʵ��ͳһ�ĺ�������
*******************************************************************************}
unit UFormBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, cxButtonEdit, UMgrControl, ULibFun;

type
  TBaseFormClass = class of TBaseForm;
  //������

  PFormCommandParam = ^TFormCommandParam;
  TFormCommandParam = record
    FCommand: integer;
    FParamA: Variant;
    FParamB: Variant;
    FParamC: Variant;
    FParamD: Variant;
    FParamE: Variant;
  end;

  TBaseForm = class(TForm)
  private
    { Private declarations }
    FPopedom: string;
    {*Ȩ����*}
    FAutoFocusCtrl: Boolean;
    {*�Զ�����*}
  protected
    { Protected declarations }
    procedure SetPopedom(const nItem: string);
    procedure OnLoadPopedom; virtual;
    {*Ȩ�����*}
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {*�����ͷ�*}
    class function DealCommand(Sender: TObject;
      const nCmd: integer): integer; virtual;
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; virtual;
    class function FormID: integer; virtual; abstract;
    {*��ʶ*}
    property AutoFocusCtrl: Boolean read FAutoFocusCtrl write FAutoFocusCtrl;
    property PopedomItem: string read FPopedom write SetPopedom; 
    {*�������*}
  published
    { Published declarations }
    procedure OnFormKeyDown(Sender: TObject; var Key: Word;
     Shift: TShiftState); virtual;
    procedure OnCtrlKeyDown(Sender: TObject; var Key: Word;
     Shift: TShiftState); virtual;
    procedure OnCtrlKeyPress(Sender: TObject; var Key: Char);
    {*��������*}
  end;

function CreateBaseFormItem(const nFormID: Integer; const nPopedom: string = '';
 const nParam: Pointer = nil): TWinControl;
function BroadcastFormCommand(Sender: TObject; const nCmd:integer): integer;
//��ں���

implementation

{$R *.dfm}

//------------------------------------------------------------------------------
//Desc: ������㲥�����е�BaseForm��
function BroadcastFormCommand(Sender: TObject; const nCmd:integer): integer;
var nList: TList;
    i,nCount: integer;
    nItem: PControlItem;
begin
  nList := TList.Create;
  try
    Result := 0;
    if not gControlManager.GetCtrls(nList) then Exit;

    nCount := nList.Count - 1;
    for i:=0 to nCount do
    begin
      nItem := nList[i];
      if nItem.FClass.InheritsFrom(TBaseForm) then
        Result := Result or TBaseFormClass(nItem.FClass).DealCommand(Sender, nCmd);
      //broadcast command and combine then result
    end;
  finally
    nList.Free;
  end;
end;

//Date: 2009-6-13
//Parm: ����ID;Ȩ����;��������
//Desc: ������ʶΪnFormID�Ĵ���ʵ��
function CreateBaseFormItem(const nFormID: Integer; const nPopedom: string = '';
 const nParam: Pointer = nil): TWinControl;
var nItem: PControlItem;
begin
  Result := nil;
  nItem := gControlManager.GetCtrl(nFormID);
  if Assigned(nItem) and nItem.FClass.InheritsFrom(TBaseForm) then
  begin
    Result := TBaseFormClass(nItem.FClass).CreateForm(nPopedom, nParam);
    if Assigned(Result) and (Result is TBaseForm) then
      TBaseForm(Result).PopedomItem := nPopedom;
  end;
end;

//------------------------------------------------------------------------------
constructor TBaseForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAutoFocusCtrl := True;
  OnKeyDown := OnFormKeyDown;
end;

procedure TBaseForm.OnFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0; Close;
  end;

  if FAutoFocusCtrl then
    OnCtrlKeyDown(Sender, Key, Shift);
  //�����
end;

//Desc: �������
procedure TBaseForm.OnCtrlKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssCtrl in Shift then
  begin
    case Key of
     VK_DOWN:
      begin
        Key := 0; SwitchFocusCtrl(Self, True);
      end;
     VK_UP:
      begin
        Key := 0; SwitchFocusCtrl(Self, False);
      end;
    end;
  end;
end;

//Desc: �����
procedure TBaseForm.OnCtrlKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = Char(VK_RETURN)) and (Sender is TcxButtonEdit) then
  begin
    Key := #0;
    if Assigned(TcxButtonEdit(Sender).Properties.OnButtonClick) then
    begin
      TcxButtonEdit(Sender).Properties.OnButtonClick(Sender, 0);
      TcxButtonEdit(Sender).SelectAll;
    end; Exit;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2009-6-13
//Parm: Ȩ��;����
//Desc: ����Formʵ��
class function TBaseForm.CreateForm(const nPopedom: string = '';
 const nParam: Pointer = nil): TWinControl;
begin
  Result := nil;
end;

//Desc: ʩ��ʵ��
destructor TBaseForm.Destroy;
begin
  gControlManager.FreeCtrl(FormID, False);
  inherited;
end;

//Desc: ����Ȩ����
procedure TBaseForm.SetPopedom(const nItem: string);
begin
  if FPopedom <> nItem then
  begin
    FPopedom := nItem;
    OnLoadPopedom;
  end;
end;

//Desc: ����Ȩ��
procedure TBaseForm.OnLoadPopedom;
begin

end;

//Desc: ��������
class function TBaseForm.DealCommand;
begin
  Result := -1;
end;

end.
