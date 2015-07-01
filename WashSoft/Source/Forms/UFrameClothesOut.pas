{*******************************************************************************
  作者: dmzn@163.com 2015-06-29
  描述: 取衣明细
*******************************************************************************}
unit UFrameClothesOut;

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
  TfFrameClothesOut = class(TfFrameNormal)
    EditName: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    dxLayout1Item2: TdxLayoutItem;
    EditPhone: TcxButtonEdit;
    EditID: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Item3: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    procedure cxButtonEdit1PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
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
  UMgrControl, ULibFun, USysDB, USysConst, UDataModule, USysBusiness,
  UFormDateFilter;
  
class function TfFrameClothesOut.FrameID: integer;
begin
  Result := cFI_FrameClothesOut;
end;

procedure TfFrameClothesOut.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameClothesOut.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFrameClothesOut.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select wo.*,M_Name,M_Py,M_Phone From $WO wo ' +
            ' Left Join $WS ws On ws.D_ID=wo.D_ID ' +
            ' Left Join $MM mm On mm.M_ID=ws.D_MID ';
  //xxxxx

  if nWhere = '' then
       Result := Result + ' Where (wo.D_Date>=''$ST'' and wo.D_Date <''$End'')'
  else Result := Result + ' Where (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$WS', sTable_WashData),
            MI('$WO', sTable_WashOut), MI('$MM', sTable_Member),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

procedure TfFrameClothesOut.cxButtonEdit1PropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    if EditID.Text = '' then Exit;

    FWhere := 'wo.D_ID Like ''%%%s%%''';
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

procedure TfFrameClothesOut.EditDatePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

initialization
  gControlManager.RegCtrl(TfFrameClothesOut, TfFrameClothesOut.FrameID);
end.
