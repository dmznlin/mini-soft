{*******************************************************************************
  作者: dmzn@163.com 2015-06-21
  描述: 会员档案
*******************************************************************************}
unit UFormIOMoney;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxButtonEdit;

type
  TfFormIOMoney = class(TfFormNormal)
    EditPhone: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
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
    EditName: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditMoney: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditMemo: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
    FID,FName: String;
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

class function TfFormIOMoney.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  nP := nParam;

  with TfFormIOMoney.Create(Application) do
  try
    FID := '';
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormIOMoney.FormID: integer;
begin
  Result := cFI_FormChongZhi;
end;

procedure TfFormIOMoney.EditNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
    nP: TFormCommandParam;
begin
  Visible := False;
  try
    FID := '';
    nP.FCommand := cCmd_AddData;
    nP.FParamA := Trim(EditName.Text);

    CreateBaseFormItem(cFI_FormGetMember, '', @nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;
  finally
    Visible := True;
  end;

  nStr := 'Select * From %s Where M_ID=''%s''';
  nStr := Format(nStr, [sTable_Member, nP.FParamB]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then
    begin
      ShowMsg('会员信息已丢失', sHint);
      Exit;
    end;

    FID := nP.FParamB;
    FName := FieldByName('M_Name').AsString;
    EditName.Text := FName;
    ActiveControl := EditMoney;

    EditPhone.Text := FieldByName('M_Phone').AsString;
    EditMIn.Text := Format('%.2f', [FieldByName('M_MoneyIn').AsFloat]);
    EditMOut.Text := Format('%.2f', [FieldByName('M_MoneyOut').AsFloat]);
    EditMFreeze.Text := Format('%.2f', [FieldByName('M_MoneyFreeze').AsFloat]);
    EditTimes.Text := FieldByName('M_Times').AsString;
  end;
end;

function TfFormIOMoney.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
var nVal,nVM: Double;
begin
  Result := True;

  if Sender = EditName then
  begin
    Result := FID <> '';
    nHint := '请先选择会员';
  end;

  if Sender = EditMoney then
  begin
    Result := IsNumber(EditMoney.Text, True);
    nHint := '请填写充值金额';
    if not Result then Exit;

    nVal := StrToFloat(EditMoney.Text);
    nVal := Float2Float(nVal, cPercent, False);
    EditMoney.Text := Format('%.2f', [nVal]);

    if nVal < 0 then
    begin
      nVM := GetMemberValidMoney(FID, True);
      Result := FloatRelation(nVM, -nVal, rtGE);

      if not Result then
      begin
        nHint := '会员名称: %s' + #13#10+
                 '剩余金额: %.2f元' + #13#10+
                 '退款金额: %.2f元' + #13#10#13#10+
                 '退款时不能超出会员的可用金.';
        nHint := Format(nHint, [FName, nVM, -nVal]);

        ShowDlg(nHint, sHint);
        nHint := '';
      end else
      begin
        //nHint := '';
        Result := QueryDlg('确定要退款给会员吗?', sAsk);
      end;
    end;
  end;
end;

procedure TfFormIOMoney.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if not IsDataValid then Exit;

  FDM.ADOConn.BeginTrans;
  try
    nStr := MakeSQLByStr([SF('M_ID', FID),
            SF('M_Type', sFlag_IOType_In),
            SF('M_Money', EditMoney.Text, sfVal),
            SF('M_Man', gSysParam.FUserID),
            SF('M_Date', sField_SQLServer_Now, sfVal),
            SF('M_Memo', EditMemo.Text)
            ], sTable_InOutMoney, '', True);
    FDM.ExecuteSQL(nStr);

    nStr := 'Update %s Set M_MoneyIn=M_MoneyIn+(%s) Where M_ID=''%s''';
    nStr := Format(nStr, [sTable_Member, EditMoney.Text, FID]);
    FDM.ExecuteSQL(nStr);

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOk;
    ShowMsg('保存成功', sHint);

    nStr := IntToStr(FDM.GetFieldMax(sTable_InOutMoney, 'R_ID'));
    PrintMemberInMoney(nStr, True);
    //打印报表
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('保存失败', sHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormIOMoney, TfFormIOMoney.FormID);
end.
