{*******************************************************************************
  作者: dmzn@163.com 2009-10-16
  描述: 排队车辆管理
*******************************************************************************}
unit UFrameJSItem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, dxLayoutControl, cxTextEdit,
  cxMaskEdit, cxButtonEdit, ADODB, cxContainer, cxLabel, cxGridLevel,
  cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, ComCtrls, ToolWin,
  cxLookAndFeels, cxLookAndFeelPainters, UBitmapPanel, cxSplitter;

type
  TfFrameJSItem = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditStock: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditCus: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    cxTextEdit5: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
  protected
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
    function DealCommand(Sender: TObject; const nCmd: integer): integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UFormBase, UFrameBase, UDataModule;

class function TfFrameJSItem.FrameID: integer;
begin
  Result := cFI_FrameJSItem;
end;

function TfFrameJSItem.DealCommand(Sender: TObject; const nCmd: integer): integer;
begin
  Result := 0;
  
  if nCmd = cCmd_RefreshData then
  begin
    InitFormData(FWhere);
  end;
end;

procedure TfFrameJSItem.BtnExitClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if not IsBusy then
  begin
    nParam.FCommand := cCmd_FormClose;
    CreateBaseFormItem(cFI_FormJSItem, '', @nParam); Close;
  end;
end;

function TfFrameJSItem.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From %s Where L_HasDone=''%s''';
  Result := Format(Result, [sTable_JSLog, sFlag_No]);
  
  if nWhere <> '' then
    Result := Result + ' And (' + nWhere + ')';
  //xxxxx
end;

//------------------------------------------------------------------------------
procedure TfFrameJSItem.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  nParam.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormJSItem, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
    BroadcastFrameCommand(Self, cCmd_RefreshData);
  //xxxxx
end;

procedure TfFrameJSItem.BtnEditClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;

  nParam.FCommand := cCmd_EditData;
  nParam.FParamA := SQLQuery.FieldByName('L_ID').AsString;
  CreateBaseFormItem(cFI_FormJSItem, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
    BroadcastFrameCommand(Self, cCmd_RefreshData);
  //xxxxx
end;

procedure TfFrameJSItem.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的提货记录', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('L_ID').AsString;
  if not QueryDlg('确定要删除该记录吗?', sAsk, Handle) then Exit;
  nStr := Format('Delete From %s Where L_ID=%s', [sTable_JSLog, nStr]);

  FDM.ExecuteSQL(nStr);
  BroadcastFrameCommand(Self, cCmd_RefreshData);
  ShowMsg('已成功删除', sHint);
end;

procedure TfFrameJSItem.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditTruck then
  begin
    FWhere := 'L_TruckNo Like ''%' + EditTruck.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditStock then
  begin
    FWhere := 'S_ID Like ''%%%s%%'' Or S_Name Like ''%%%s%%''';
    FWhere := Format(FWhere, [EditStock.Text, EditStock.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCus then
  begin
    FWhere := 'L_Customer Like ''%' + EditCus.Text + '%''';
    InitFormData(FWhere);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameJSItem, TfFrameJSItem.FrameID);
end.
