{*******************************************************************************
  作者: dmzn@163.com 2015-06-21
  描述: 资金明细
*******************************************************************************}
unit UFrameIOMoney;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, dxLayoutControl,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameIOMoney = class(TfFrameNormal)
    EditName: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    dxLayout1Item2: TdxLayoutItem;
    EditPhone: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    procedure cxButtonEdit1PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
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
  UMgrControl, ULibFun, USysDB, USysConst, UDataModule, UFormDateFilter;
  
class function TfFrameIOMoney.FrameID: integer;
begin
  Result := cFI_FrameChongZhi;
end;

procedure TfFrameIOMoney.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameIOMoney.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFrameIOMoney.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select io.*,M_Name,M_Py,M_Phone From $IO io ' +
            ' Left Join $MM mm On mm.M_ID=io.M_ID ';
  //xxxxx

  if nWhere = '' then
       Result := Result + ' Where (io.M_Date>=''$ST'' and io.M_Date <''$End'')'
  else Result := Result + ' Where (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$IO', sTable_InOutMoney),
            MI('$MM', sTable_Member),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

procedure TfFrameIOMoney.cxButtonEdit1PropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
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

procedure TfFrameIOMoney.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormChongZhi, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

procedure TfFrameIOMoney.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

initialization
  gControlManager.RegCtrl(TfFrameIOMoney, TfFrameIOMoney.FrameID);
end.
