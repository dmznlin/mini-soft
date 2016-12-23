{*******************************************************************************
  作者: dmzn@163.com 2016-12-23
  描述: 温湿度日志
*******************************************************************************}
unit UFrameTempLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameTemplog = class(TfFrameNormal)
    EditSMemo: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    {*时间区间*}
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    {*基类函数*}
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, UFormBase,
  UFormDateFilter;

//------------------------------------------------------------------------------
class function TfFrameTemplog.FrameID: integer;
begin
  Result := cFI_FrameTemplog;
end;

procedure TfFrameTemplog.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameTemplog.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//------------------------------------------------------------------------------
//Desc: 数据查询SQL
function TfFrameTemplog.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  Result := 'Select * From $TL ';

  if nWhere = '' then
       Result := Result + 'Where (T_Date>=''$S'' and T_Date <''$E'')'
  else Result := Result + 'Where (' + nWhere + ')';
  
  Result := MacroValue(Result, [MI('$TL', sTable_TempLog),
            MI('$S', Date2Str(FStart)), MI('$E', Date2Str(FEnd + 1))]);
  //xxxxx                                                                        )
end;

//Desc: 日期筛选
procedure TfFrameTemplog.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

initialization
  gControlManager.RegCtrl(TfFrameTemplog, TfFrameTemplog.FrameID);
end.
