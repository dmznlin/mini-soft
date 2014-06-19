{*******************************************************************************
  作者: dmzn@163.com 2009-09-13
  描述: 计数操作查询
*******************************************************************************}
unit UFrameJSLog;

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
  TfFrameJSLog = class(TfFrameNormal)
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
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnExitClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    //时间区间
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    procedure InitFormData(const nWhere: string = '';
     const nQuery: TADOQuery = nil); override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
    procedure SummaryItemsGetText(Sender: TcxDataSummaryItem;
      const AValue: Variant; AIsFooter: Boolean; var AText: String);
    //处理摘要
  public
    { Public declarations }
    class function FrameID: integer; override;
    function DealCommand(Sender: TObject; const nCmd: integer): integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormDateFilter, UFormInputbox, UFormBase,
  USysFun, USysConst, USysDB;

class function TfFrameJSLog.FrameID: integer;
begin
  Result := cFI_FrameJSLog;
end;

procedure TfFrameJSLog.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);

  if FStart = FEnd then
    FEnd := FEnd + 1;
  //next day
end;

procedure TfFrameJSLog.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFrameJSLog.DealCommand(Sender: TObject; const nCmd: integer): integer;
begin
  Result := 0;
  
  if nCmd = cCmd_RefreshData then
  begin
    InitFormData(FWhere);
  end;
end;

procedure TfFrameJSLog.InitFormData(const nWhere: string;
  const nQuery: TADOQuery);
var i,nCount: Integer;
begin
  with cxView1.DataController.Summary do
  begin
    nCount := FooterSummaryItems.Count - 1;
    for i:=0 to nCount do
      FooterSummaryItems[i].OnGetText := SummaryItemsGetText;
    //绑定事件
  end;

  inherited;
end;

procedure TfFrameJSLog.BtnExitClick(Sender: TObject);
begin
  inherited;
  Close;
end;

//------------------------------------------------------------------------------
function TfFrameJSLog.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  if gSysDBType = dtSQLServer then
  begin
    Result := 'Select * From %s Where (L_Date>=''%s'' And L_Date<''%s'')';
  end else
  begin
    Result := 'Select * From %s Where (L_Date>=#%s# And L_Date<#%s#)';
  end;

  Result := Format(Result, [sTable_JSLog,
            DateTime2Str(FStart), DateTime2Str(FEnd)]);
  if nWhere <> '' then
    Result := Result + ' And (' + nWhere + ')';
  //xxxxx
end;

//Desc: 日期筛选
procedure TfFrameJSLog.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd, True) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameJSLog.EditTruckPropertiesButtonClick(Sender: TObject;
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

//Desc: 处理破袋率
procedure TfFrameJSLog.SummaryItemsGetText(Sender: TcxDataSummaryItem;
  const AValue: Variant; AIsFooter: Boolean; var AText: String);
var nStr: string;
    i,nCount: integer;
    nDai,nBC: integer;
begin
  nStr := TcxGridDBColumn(TcxGridTableSummaryItem(Sender).Column).DataBinding.FieldName;
  if CompareText(nStr, 'L_PValue') = 0 then
  with cxView1.DataController.Summary do
  begin
    nDai := 0;
    nBC := 0;
    nCount := FooterSummaryItems.Count - 1;

    for i:=0 to nCount do
    try
      nStr := TcxGridDBColumn(TcxGridTableSummaryItem(FooterSummaryItems[i]).Column).DataBinding.FieldName;
      if CompareText(nStr, 'L_DaiShu') = 0 then nDai := FooterSummaryValues[i];
      if CompareText(nStr, 'L_BC') = 0 then nBC := FooterSummaryValues[i];
    except
      //ignor any error
    end;

    if nDai = 0 then
         AText := '0'
    else AText := Format('%.2f%%', [nBC / nDai * 100]);
  end;
end;

//------------------------------------------------------------------------------
//Desc: 快捷菜单
procedure TfFrameJSLog.PMenu1Popup(Sender: TObject);
begin
  N1.Enabled := BtnPrint.Enabled;
  N3.Enabled := BtnEdit.Enabled;
end;

//Desc: 打印凭证
procedure TfFrameJSLog.N1Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('L_ID').AsString;
    PrintJSReport(nStr, False);
  end;
end;

//Desc: 修改批次号
procedure TfFrameJSLog.N3Click(Sender: TObject);
var nStr,nTmp: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nTmp := SQLQuery.FieldByName('L_SerialID').AsString;
    nStr := nTmp;

    if not ShowInputBox('请输入新的批次号:', sHint, nStr, 32) then Exit;
    if CompareText(nStr, nTmp) = 0 then Exit;

    nTmp := 'Update %s Set L_SerialID=''%s'' Where L_ID=%s';
    nTmp := Format(nTmp, [sTable_JSLog, nStr, SQLQuery.FieldByName('L_ID').AsString]);

    FDM.ExecuteSQL(nTmp);
    InitFormData(FWhere);
    ShowMsg('修改成功', sHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameJSLog, TfFrameJSLog.FrameID);
end.
