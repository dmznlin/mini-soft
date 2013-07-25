{*******************************************************************************
  作者: dmzn@163.com 2012-03-26
  描述: 出入车辆查询
*******************************************************************************}
unit UFrameQueryTruck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxContainer, Menus, dxLayoutControl, cxMaskEdit, cxButtonEdit,
  cxTextEdit, ADODB, cxLabel, UBitmapPanel, cxSplitter, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin;

type
  TfFrameTruckQuery = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditTask: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditCustomer: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    //时间区间
    FFilteDate: Boolean;
    //筛选日期
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    procedure AfterInitFormData; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UFormDateFilter, USysConst, USysDB, USysBusiness,
  UBusinessConst;

class function TfFrameTruckQuery.FrameID: integer;
begin
  Result := cFI_FrameTruckQuery;
end;

procedure TfFrameTruckQuery.OnCreateFrame;
begin
  inherited;
  FFilteDate := True;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameTruckQuery.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//------------------------------------------------------------------------------
function TfFrameTruckQuery.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select tl.* From $TL tl ';
  //xxxxx

  if FFilteDate then
    Result := Result + 'Where ((T_InTime>=''$S'' and T_InTime <''$End'') Or ' +
            '(T_OutTime>=''$S'' and T_OutTime <''$End''))';
  //xxxxx

  if nWhere <> '' then
    if FFilteDate then
         Result := Result + ' And (' + nWhere + ')'
    else Result := Result + ' Where (' + nWhere + ')';
  //xxxxx

  Result := MacroValue(Result, [MI('$TL', sTable_TruckLog),
            MI('$S', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

procedure TfFrameTruckQuery.AfterInitFormData;
begin
  FFilteDate := True;
  inherited;         
end;

//Desc: 日期筛选
procedure TfFrameTruckQuery.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameTruckQuery.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := 'T_Truck like ''%' + EditTruck.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditTask then
  begin
    EditTask.Text := Trim(EditTask.Text);
    if EditTask.Text = '' then Exit;

    FWhere := 'T_TaskID like ''%' + EditTask.Text + '%''';
    InitFormData(FWhere);
  end;
end;

//Desc: 快捷菜单
procedure TfFrameTruckQuery.N1Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
    10: //显示全部
     begin
       FWhere := '';
       InitFormData;
     end;
    20: //未出厂
     begin
       FFilteDate := False;
       FWhere := 'T_NextStatus<>''''';
       InitFormData(FWhere);
     end;
    30: //已出厂
     begin
       FWhere := '';
       InitFormData('T_NextStatus=''''');
     end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameTruckQuery, TfFrameTruckQuery.FrameID);
end.
