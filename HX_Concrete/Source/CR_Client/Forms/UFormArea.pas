{*******************************************************************************
  作者: dmzn@163.com 2013-07-06
  描述: 区域管理
*******************************************************************************}
unit UFormArea;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters, cxContainer,
  cxEdit, cxTextEdit, dxLayoutControl, StdCtrls;

type
  TfFormArea = class(TfFormNormal)
    EditID: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditName: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditURL: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
  private
    { Private declarations }
    FIsAdd: Boolean;
    FAreaID: string;
    //区域标识
    procedure InitFormData(const nID: string);
    //载入数据
  protected
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure GetSaveSQLList(const nList: TStrings); override;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UFormCtrl, UFormBase, UDataModule, USysDB, USysConst;

class function TfFormArea.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormArea.Create(Application) do
    begin
      FAreaID := nP.FParamA;
      FIsAdd := True;
      Caption := '区域 - 添加';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormArea.Create(Application) do
    begin
      FAreaID := nP.FParamA;
      FIsAdd := False;
      Caption := '区域 - 修改';

      InitFormData(FAreaID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
  end;
end;

class function TfFormArea.FormID: integer;
begin
  Result := cFI_FormArea;
end;

procedure TfFormArea.InitFormData(const nID: string);
var nStr: string;
begin
  if nID <> '' then
  begin
    nStr := 'Select * From %s Where A_ID=''%s''';
    nStr := Format(nStr, [sTable_Area, nID]);

    with FDM.QuerySQL(nStr) do
    if RecordCount > 0 then
    begin
      EditID.Text := FieldByName('A_ID').AsString;
      EditName.Text := FieldByName('A_Name').AsString;
      EditURL.Text := FieldByName('A_MIT').AsString;
    end;
  end;
end;

//Desc: 验证数据
function TfFormArea.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nStr: string;
begin
  Result := True;

  if Sender = EditID then
  begin
    Result := Trim(EditID.Text) <> '';
    nHint := '请填写有效编号';
    if not Result then Exit;

    if FIsAdd then
    begin
      nStr := 'Select Count(*) From %s Where A_ID=''%s''';
      nStr := Format(nStr, [sTable_Area, EditID.Text]);
    end else

    if EditID.Text <> FAreaID then
    begin
      nStr := 'Select Count(*) From %s Where A_ID=''%s''';
      nStr := Format(nStr, [sTable_Area, EditID.Text]);
    end else nStr := '';

    if nStr <> '' then
    begin
      with FDM.QuerySQL(nStr) do
      begin
        Result := Fields[0].AsInteger < 1;
        nHint := '该编号区域已存在';
      end;
    end;
  end else

  if Sender = EditName then
  begin
    Result := Trim(EditName.Text) <> '';
    nHint := '请填写区域名称';
  end else

  if Sender = EditURL then
  begin
    nStr := LowerCase(EditURL.Text);
    Result := (nStr = '') or (Pos('http://', nStr) = 1);
    nHint := '服务地址以"http"开头';
  end;
end;

//Desc：保存数据
procedure TfFormArea.GetSaveSQLList(const nList: TStrings);
var nStr: string;
begin
  if FIsAdd then
  begin
    nStr := MakeSQLByStr([SF('A_ID', EditID.Text),
            SF('A_Name', EditName.Text), SF('A_MIT', EditURL.Text),
            SF('A_Parent', FAreaID)], sTable_Area, '', True);
    nList.Add(nStr);
  end else
  begin
    nStr := Format('A_ID=''%s''', [FAreaID]);
    nStr := MakeSQLByStr([SF('A_ID', EditID.Text),
            SF('A_Name', EditName.Text), SF('A_MIT', EditURL.Text)],
            sTable_Area, nStr, False);
    nList.Add(nStr);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormArea, TfFormArea.FormID);
end.
