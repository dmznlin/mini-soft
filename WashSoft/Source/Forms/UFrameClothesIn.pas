{*******************************************************************************
  作者: dmzn@163.com 2015-06-23
  描述: 会员管理
*******************************************************************************}
unit UFrameClothesIn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, dxLayoutControl,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, Menus;

type
  TfFrameClothesIn = class(TfFrameNormal)
    EditName: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    dxLayout1Item2: TdxLayoutItem;
    EditPhone: TcxButtonEdit;
    EditID: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Item3: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure cxButtonEdit1PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FStart,FEnd: TDate;
    {*时间区间*}
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    {*基类函数*}
    function InitFormDataSQL(const nWhere: string): string; override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  UMgrControl, ULibFun, USysDB, USysConst, UDataModule, USysBusiness,
  UFormDateFilter;
  
class function TfFrameClothesIn.FrameID: integer;
begin
  Result := cFI_FrameClothesIn;
end;

procedure TfFrameClothesIn.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameClothesIn.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFrameClothesIn.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select ws.*,M_Name,M_Py,M_Phone From $WS ws ' +
            ' Left Join $MM mm On mm.M_ID=ws.D_MID ';
  //xxxxx

  if nWhere = '' then
       Result := Result + ' Where (ws.D_Date>=''$ST'' and ws.D_Date <''$End'')'
  else Result := Result + ' Where (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$WS', sTable_WashData),
            MI('$MM', sTable_Member),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

procedure TfFrameClothesIn.cxButtonEdit1PropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    if EditID.Text = '' then Exit;

    FWhere := 'D_ID Like ''%%%s%%''';
    FWhere := Format(FWhere, [EditID.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := 'M_Name Like ''%%%s%%'' Or M_Py Like ''%%%s%%''';
    FWhere := Format(FWhere, [EditName.Text, EditName.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditPhone then
  begin
    EditPhone.Text := Trim(EditPhone.Text);
    if EditPhone.Text = '' then Exit;

    FWhere := 'M_Phone Like ''%%%s%%''';
    FWhere := Format(FWhere, [EditPhone.Text]);
    InitFormData(FWhere);
  end;
end;

procedure TfFrameClothesIn.N3Click(Sender: TObject);
begin
  FWhere := 'D_HasMoney > 0';
  InitFormData(FWhere);
end;

procedure TfFrameClothesIn.N4Click(Sender: TObject);
begin
  FWhere := 'D_HasNumber > 0';
  InitFormData(FWhere);
end;

procedure TfFrameClothesIn.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormWashData, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

procedure TfFrameClothesIn.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择洗衣记录', sHint);
    Exit;
  end;

  if SQLQuery.FieldByName('D_HasNumber').AsInteger < 1 then
  begin
    ShowMsg('该单已经结束', sHint);
    Exit;
  end;

  nP.FCommand := cCmd_EditData;
  nP.FParamA := SQLQuery.FieldByName('D_ID').AsString;
  CreateBaseFormItem(cFI_FormWashOut, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData(FWhere);
  end;
end;

procedure TfFrameClothesIn.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    if SQLQuery.FieldByName('D_HasNumber').AsInteger < 1 then
    begin
      ShowMsg('该单已经结束', sHint);
      Exit;
    end;

    nStr := SQLQuery.FieldByName('D_ID').AsString;
    nStr := Format('确定要删除编号为[ %s ]记录吗?', [nStr]);
    if not QueryDlg(nStr, sAsk) then Exit;

    if DeleteWashData(SQLQuery.FieldByName('D_ID').AsString) then
    begin
      InitFormData(FWhere);
      ShowMsg('删除成功', sHint);
    end;
  end;
end;

procedure TfFrameClothesIn.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

procedure TfFrameClothesIn.N1Click(Sender: TObject);
begin
  if cxView1.DataController.GetSelectedCount > 0 then
    PrintWashData(SQLQuery.FieldByName('D_ID').AsString, False);
  //xxxxx
end;

initialization
  gControlManager.RegCtrl(TfFrameClothesIn, TfFrameClothesIn.FrameID);
end.
