{*******************************************************************************
  作者: dmzn@163.com 2011-01-23
  描述: 采购周期
*******************************************************************************}
unit UFormWeeks;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxButtonEdit, cxLabel, cxTextEdit, cxContainer, cxEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TfFormWeeks = class(TfFormNormal)
    dxLayout1Item4: TdxLayoutItem;
    EditName: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditMemo: TcxMemo;
    EditStart: TcxDateEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditEnd: TcxDateEdit;
    dxLayout1Item5: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FRecordID: string;
    //记录编号
    procedure InitFormData(const nID: string);
    //载入数据
    function SetData(Sender: TObject; const nData: string): Boolean;
    //设置数据
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UFormBase, UMgrControl, UDataModule, UFormCtrl, USysDB, USysConst,
  USysBusiness;

class function TfFormWeeks.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormWeeks.Create(Application) do
    begin
      Caption := '采购周期 - 添加';
      FRecordID := '';
      InitFormData(FRecordID);

      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormWeeks.Create(Application) do
    begin
      Caption := '采购周期 - 修改';
      FRecordID := nP.FParamA;
      InitFormData(FRecordID);

      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
  end;
end;

class function TfFormWeeks.FormID: integer;
begin
  Result := cFI_FormWeeks;
end;

procedure TfFormWeeks.FormCreate(Sender: TObject);
begin
  LoadFormConfig(Self);
end;

procedure TfFormWeeks.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  Action := caFree;
end;

//------------------------------------------------------------------------------
function TfFormWeeks.SetData(Sender: TObject; const nData: string): Boolean;
begin
  Result := False;

  if Sender = EditStart then
  begin
    EditStart.Date := Str2DateTime(nData);
    Result := True;
  end else

  if Sender = EditEnd then
  begin
    EditEnd.Date := Str2DateTime(nData);
    Result := True;
  end;
end;

procedure TfFormWeeks.InitFormData(const nID: string);
var nStr: string;
    nY,nM,nD: Word;
begin
  ActiveControl := EditName;
  
  if nID = '' then
  begin
    nStr := 'Select Top 1 W_End From %s Order By W_End DESC';
    nStr := Format(nStr, [sTable_Weeks]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      EditStart.Date := Fields[0].AsDateTime + 1;
    end else
    begin
      DecodeDate(Now, nY, nM, nD);
      EditStart.Date := EncodeDate(nY, nM, 1);
    end;

    DecodeDate(EditStart.Date, nY, nM, nD);
    Inc(nM);

    if nM > 12 then
    begin
      nM := 1; Inc(nY);
    end;
    EditEnd.Date := EncodeDate(nY, nM, 1) - 1;
  end else
  begin
    nStr := 'Select * From %s Where W_NO=''%s''';
    nStr := Format(nStr, [sTable_Weeks, nID]);
    LoadDataToCtrl(FDM.QueryTemp(nStr), Self, '', SetData);
  end;
end;

function TfFormWeeks.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
var nStr,nTmp: string;
begin
  Result := True;

  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    Result := EditName.Text <> '';
    nHint := '请填写有效的名称';
  end else

  if Sender = EditStart then
  begin
    Result := EditStart.Date <= EditEnd.Date;
    nHint := '结束日期应大于开始日期';
    if not Result then Exit;

    nStr := 'Select * From $W Where ((W_Begin<=''$S'' and W_End>=''$S'') or ' +
            '(W_Begin>=''$S'' and W_End<=''$E'') or (W_Begin<=''$E'' and ' +
            'W_End>=''$E'') or (W_Begin<=''$S'' and W_End>=''$E''))';
    nStr := MacroValue(nStr, [MI('$W', sTable_Weeks),
            MI('$S', Date2Str(EditStart.Date)), MI('$E', Date2Str(EditEnd.Date))]);
    //xxxxx

    if FRecordID <> '' then
      nStr := nStr + Format(' And W_No<>''%s''', [FRecordID]);
    //xxxxx

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      nStr := '';
      First;

      while not Eof  do
      begin
        nTmp := '开始:%s 结束:%s 名称: %s' + #32#32#13#10;
        nTmp := Format(nTmp, [Date2Str(FieldByName('W_Begin').AsDateTime),
                Date2Str(FieldByName('W_End').AsDateTime),
                FieldByName('W_Name').AsString]);
        //xxxxx
        
        nStr := nStr + nTmp;
        Next;
      end;

      nHint := '';
      Result := False;

      nStr := '本周期与以下周期时间上有交叉,会影响库存的统计.' +
              #13#10#13#10 + AdjustHintToRead(nStr) + #13#10 +
              '请修改"开始、结束"日期后再保存.';
      ShowDlg(nStr, sHint);
    end;
  end;
end;

//Desc: 保存
procedure TfFormWeeks.BtnOKClick(Sender: TObject);
var nStr: string;
    nInt: Integer;
begin
  if not IsDataValid then Exit;

  if FRecordID = '' then
  begin
    nStr := MakeSQLByStr([Format('W_Name=''%s''', [EditName.Text]),
            Format('W_Begin=''%s''', [Date2Str(EditStart.Date)]),
            Format('W_End=''%s''', [Date2Str(EditEnd.Date)]),
            Format('W_Memo=''%s''', [EditMemo.Text]),
            Format('W_Man=''%s''', [gSysParam.FUserID]),
            Format('W_Date=%s', [FDM.SQLServerNow])], sTable_Weeks, '', True);
  end else
  begin
    if IsWeekHasEnable(FRecordID) then
    begin
      nStr := '该周期已生效,只能保存除"开始,结束"日期以外的内容.' + #13#10 +
                '是否继续?';
      //xxxxx

      if not QueryDlg(nStr, sAsk) then Exit;
      nInt := 1;
    end else nInt := 0;

    nStr := Format('W_NO=''%s''', [FRecordID]);
    if nInt > 0 then
         nStr := MakeSQLByStr([Format('W_Name=''%s''', [EditName.Text]),
                 Format('W_Memo=''%s''', [EditMemo.Text])],
                 sTable_Weeks, nStr, False)
    else nStr := MakeSQLByStr([Format('W_Name=''%s''', [EditName.Text]),
                 Format('W_Memo=''%s''', [EditMemo.Text]),
                 Format('W_Begin=''%s''', [Date2Str(EditStart.Date)]),
                 Format('W_End=''%s''', [Date2Str(EditEnd.Date)])],
                 sTable_Weeks, nStr, False);
  end;

  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nStr);
    if FRecordID = '' then
    begin
      nInt := FDM.GetFieldMax(sTable_Weeks, 'W_ID');
      nStr := FDM.GetSerialID2('', sTable_Weeks, 'W_ID', 'W_NO', nInt);

      nStr := Format('Update %s Set W_No=''%s'' Where W_ID=%d', [
              sTable_Weeks, nStr, nInt]);
      FDM.ExecuteSQL(nStr);
    end;

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOK;
    ShowMsg('记录保存成功', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('记录保存失败', sError);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormWeeks, TfFormWeeks.FormID);
end.
