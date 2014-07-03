{*******************************************************************************
  作者: dmzn@163.com 2009-09-13
  描述: 管理磁卡
*******************************************************************************}
unit UFrameJSCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, dxLayoutControl, cxMaskEdit,
  cxButtonEdit, cxTextEdit, ADODB, cxContainer, cxLabel, cxGridLevel,
  cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, ComCtrls, ToolWin, Menus,
  cxLookAndFeels, cxLookAndFeelPainters, UBitmapPanel, cxSplitter,
  dxSkinsCore, dxSkinsDefaultPainters;

type
  TfFrameCard = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditStock: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditCus: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    cxTextEdit5: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    //时间区间
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormDateFilter, UFormInputbox, UFormBase,
  USysFun, USysConst, USysDB;

class function TfFrameCard.FrameID: integer;
begin
  Result := cFI_FrameCard;
end;

procedure TfFrameCard.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameCard.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//------------------------------------------------------------------------------
function TfFrameCard.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select * From %s Where (L_BillDate>=''%s'') And (L_BillDate<''%s'')';
  Result := Format(Result, [sTable_JSItem, Date2Str(FStart), Date2Str(FEnd+1)]);

  if nWhere <> '' then
    Result := Result + ' And (' + nWhere + ')';
  //xxxxx
end;

//Desc: 日期筛选
procedure TfFrameCard.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameCard.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditTruck then
  begin
    FWhere := 'L_TruckNo Like ''%' + EditTruck.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditStock then
  begin
    FWhere := 'L_StockID Like ''%%%s%%'' Or L_Stock Like ''%%%s%%''';
    FWhere := Format(FWhere, [EditStock.Text, EditStock.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCus then
  begin
    FWhere := 'L_Customer Like ''%' + EditCus.Text + '%''';
    InitFormData(FWhere);
  end;
end;

//------------------------------------------------------------------------------
//Desc: 清理无效记录
procedure TfFrameCard.BtnEditClick(Sender: TObject);
var nStr: string;
begin
  nStr := '将清理开单超过24小时的单据,要继续吗?';
  if not QueryDlg(nStr, sAsk) then Exit;

  nStr := 'Delete From %s Where L_BillDate<%s-1';
  nStr := Format(nStr, [sTable_JSItem, sField_SQLServer_Now]);
  FDM.ExecuteSQL(nStr);

  InitFormData(FWhere);
  ShowMsg('清理完毕', sHint);
end;

//Desc: 删除发货单
procedure TfFrameCard.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('L_Customer').AsString;
  if not QueryDlg('确定要删除客户[ ' + nStr + ' ]的发货单吗?', sAsk) then Exit;

  nStr := 'Delete From %s Where L_Bill=''%s''';
  nStr := Format(nStr, [sTable_JSItem, SQLQuery.FieldByName('L_Bill').AsString]);
  FDM.ExecuteSQL(nStr);

  InitFormData(FWhere);
  ShowMsg('删除成功', sHint);
end;

procedure TfFrameCard.BtnAddClick(Sender: TObject);
var nStr,nCard: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要办卡的记录', sHint); Exit;
  end;

  nCard := '';
  if not ShowInputBox('请输入磁卡号:', '办卡', nCard, 15) then Exit;

  nStr := Format('Update %s Set L_Card='''' Where L_Card=''%s''',
          [sTable_JSItem, nCard]);
  FDM.ExecuteSQL(nStr);

  nStr := Format('Update %s Set L_Card=''%s'' Where L_Bill=''%s''',
          [sTable_JSItem, nCard, SQLQuery.FieldByName('L_Bill').AsString]);
  //xxxxx

  FDM.ExecuteSQL(nStr);
  InitFormData(FWhere);
end;

initialization
  gControlManager.RegCtrl(TfFrameCard, TfFrameCard.FrameID);
end.
