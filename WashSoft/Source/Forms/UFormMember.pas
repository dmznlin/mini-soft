{*******************************************************************************
  作者: dmzn@163.com 2015-06-18
  描述: 会员档案
*******************************************************************************}
unit UFormMember;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxTextEdit;

type
  TfFormMember = class(TfFormNormal)
    EditName: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditPhone: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditJiFen: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditZheKou: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    EditMIn: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditMFreeze: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditMOut: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditTimes: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FID: String;
    procedure InitFormData;
  public
    { Public declarations }
    class function FormID: integer; override;
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}
uses
  UMgrControl, ULibFun, USysDB, USysConst, UDataModule, UFormCtrl, USysBusiness;

class function TfFormMember.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  nP := nParam;

  with TfFormMember.Create(Application) do
  try
    if nP.FCommand = cCmd_AddData then
    begin
      FID := '';
      Caption := '会员 - 添加';
    end else

    if nP.FCommand = cCmd_EditData then
    begin
      FID := nP.FParamA;
      Caption := '会员 - 修改';
    end;

    InitFormData;
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormMember.FormID: integer;
begin
  Result := cFI_FormMember;
end;

procedure TfFormMember.InitFormData;
var nStr: string;
begin
  dxGroup1.AlignVert := avTop;
  dxGroup2.AlignVert := avClient;

  ResetHintAllForm(Self, 'T', sTable_Member);
  //重置表名称

  if FID <> '' then
  begin
    nStr := 'Select * From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_Member, FID]);
    LoadDataToCtrl(FDM.QueryTemp(nStr), Self);
  end;
end;

function TfFormMember.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
var nVal: Double;
begin
  Result := True;

  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    nHint := '请填写会员名';
    Result := EditName.Text <> '';
  end;

  if Sender = EditJiFen then
  begin
    Result := IsNumber(EditJiFen.Text, True);
    nHint := '积分为>=0的数';
  end;

  if Sender = EditZheKou then
  begin
    Result := IsNumber(EditZheKou.Text, True);
    nHint := '折扣为>0并且<=1的数';

    if Result then
    begin
      nVal := StrToFloat(EditZheKou.Text);
      Result := (nVal <= 1) and (nVal > 0);
    end;
  end;
end;

procedure TfFormMember.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if not IsDataValid then Exit;

  if FID = '' then
  begin
    nStr := MakeSQLByStr([
            SF('M_ID', GetSerailID(sFlag_BusGroup, sFlag_MemberID, True)),
            SF('M_Name', EditName.Text),
            SF('M_Py', GetPinYinOfStr(EditName.Text)),
            SF('M_Phone', EditPhone.Text),
            SF('M_MoneyIn', 0, sfVal),
            SF('M_MoneyOut', 0, sfVal),
            SF('M_MoneyFreeze', 0, sfVal),
            SF('M_Times', 0, sfVal),
            SF('M_JiFen', EditJiFen.Text, sfVal),
            SF('M_ZheKou', EditZheKou.Text, sfVal)
            ], sTable_Member, '', True);
    //xxxxx
  end else
  begin
    nStr := MakeSQLByStr([SF('M_Name', EditName.Text),
            SF('M_Py', GetPinYinOfStr(EditName.Text)),
            SF('M_Phone', EditPhone.Text),
            SF('M_JiFen', EditJiFen.Text, sfVal),
            SF('M_ZheKou', EditZheKou.Text, sfVal)
            ], sTable_Member, SF('R_ID', FID), False);
    //xxxxx
  end;

  FDM.ExecuteSQL(nStr);
  ModalResult := mrOk;
  ShowMsg('保存成功', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormMember, TfFormMember.FormID);
end.
