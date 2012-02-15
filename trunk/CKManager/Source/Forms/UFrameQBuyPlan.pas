{*******************************************************************************
  作者: dmzn@163.com 2011-6-7
  描述: 生产原料入库
*******************************************************************************}
unit UFrameQBuyPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, ADODB, cxContainer, cxLabel,
  dxLayoutControl, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxTextEdit, cxMaskEdit, cxButtonEdit, UBitmapPanel,
  cxSplitter, Menus, cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFrameQBuyPlan = class(TfFrameNormal)
    EditName: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    dxLayout1Item5: TdxLayoutItem;
    EditWeek: TcxButtonEdit;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditWeekPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
    FNowYear,FNowWeek,FWeekName: string;
    //当前周期
    procedure LoadDefaultWeek;
    //默认周期
  protected
    procedure OnCreateFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    //基类方法
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, UFormBase, USysBusiness;

class function TfFrameQBuyPlan.FrameID: integer;
begin
  Result := cFI_FrameQBuyPlan;
end;

procedure TfFrameQBuyPlan.OnCreateFrame;
begin
  inherited;
  LoadDefaultWeek;
end;

//------------------------------------------------------------------------------
//Desc: 数据查询SQL
function TfFrameQBuyPlan.InitFormDataSQL(const nWhere: string): string;
var nInt: Integer;
    nStr,nWeek: string;
begin
  if (FNowYear = '') and (FNowWeek = '') then
  begin
    EditWeek.Text := '请选择采购周期'; Exit;
  end;

  nStr := '年份:[ %s ] 周期:[ %s ]';
  EditWeek.Text := Format(nStr, [FNowYear, FWeekName]);

  if FNowWeek = '' then
  begin
    nWeek := 'Where (W_Begin>=''$S'' and ' +
             'W_Begin<''$E'') or (W_End>=''$S'' and W_End<''$E'') ' +
             'Order By W_Begin';
    nInt := StrToInt(FNowYear);

    nWeek := MacroValue(nWeek, [MI('$W', sTable_Weeks),
            MI('$S', IntToStr(nInt)), MI('$E', IntToStr(nInt+1))]);
    //xxxxx
  end else nWeek := Format('Where P_Week=''%s''', [FNowWeek]);

  Result := 'Select pl.*,wk.W_Name,gd.* From $PL pl ' +
            ' Left Join $Week wk On wk.W_NO=pl.P_Week ' +
            ' Left Join $Gd gd On gd.G_ID=pl.P_Goods ';
  //xxxxx

  if FWhere = '' then
       Result := Result + nWeek
  else Result := Result + 'Where ( ' + FWhere + ' )';

  Result := MacroValue(Result, [MI('$PL', sTable_BuyPlan),
          MI('$Week', sTable_Weeks), MI('$Gd', sTable_Goods)]);
  //xxxxx
end;

//Desc: 载入默认周期
procedure TfFrameQBuyPlan.LoadDefaultWeek;
var nP: TFormCommandParam;
begin
  FNowYear := '';
  FNowWeek := '';
  FWeekName := '';
  nP.FCommand := cCmd_GetData;

  nP.FParamA := FNowYear;
  nP.FParamB := FNowWeek;
  nP.FParamE := sFlag_Yes;
  CreateBaseFormItem(cFI_FormGetWeek, PopedomItem, @nP);

  if nP.FCommand = cCmd_ModalResult then
  begin
    FNowYear := nP.FParamB;
    FNowWeek := nP.FParamC;
    FWeekName := nP.FParamD;
  end;
end;

//Desc: 执行查询
procedure TfFrameQBuyPlan.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := 'G_Name like ''%%%s%%'' Or G_PY Like ''%%%s%%''';
    FWhere := Format(FWhere, [EditName.Text, EditName.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 选择周期
procedure TfFrameQBuyPlan.EditWeekPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_GetData;
  nP.FParamA := FNowYear;
  nP.FParamB := FNowWeek;
  CreateBaseFormItem(cFI_FormGetWeek, PopedomItem, @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    FNowYear := nP.FParamB;
    FNowWeek := nP.FParamC;
    FWeekName := nP.FParamD;

    InitFormData(FWhere);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameQBuyPlan, TfFrameQBuyPlan.FrameID);
end.
