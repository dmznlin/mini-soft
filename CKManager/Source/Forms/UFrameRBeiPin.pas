{*******************************************************************************
  作者: dmzn@163.com 2011-6-7
  描述: 备品备件入库
*******************************************************************************}
unit UFrameRBeiPin;

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
  TfFrameRBeiPin = class(TfFrameNormal)
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
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
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

class function TfFrameRBeiPin.FrameID: integer;
begin
  Result := cFI_FrameRBeiPin;
end;

procedure TfFrameRBeiPin.OnCreateFrame;
begin
  inherited;
  LoadDefaultWeek;
end;

//Desc: 关闭
procedure TfFrameRBeiPin.BtnExitClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if not IsBusy then
  begin
    nParam.FCommand := cCmd_FormClose;
    CreateBaseFormItem(cFI_FormRBeiPin, '', @nParam); Close;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 数据查询SQL
function TfFrameRBeiPin.InitFormDataSQL(const nWhere: string): string;
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
  end else nWeek := Format('Where B_Week=''%s''', [FNowWeek]);

  Result := 'Select W_Name,S_Name,S_Owner,P_Name,bp.*,gs.* From %s bp' +
            ' Left Join %s wk On wk.W_NO=bp.B_Week ' +
            ' Left Join %s gs On gs.G_ID=bp.B_Goods ' +
            ' Left Join %s st On st.S_ID=bp.B_Storage ' +
            ' Left Join %s pr On pr.P_ID=bp.B_Provider ';
  Result := Format(Result, [sTable_BeiPin, sTable_Weeks, sTable_Goods,
            sTable_Storage, sTable_Provider]);
  //xxxxx

  if FWhere = '' then
       Result := Result + nWeek
  else Result := Result + 'Where ( ' + FWhere + ' )';
end;

//Desc: 载入默认周期
procedure TfFrameRBeiPin.LoadDefaultWeek;
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

//Desc: 添加
procedure TfFrameRBeiPin.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if FNowWeek = '' then
  begin
    ShowMsg('请选择采购周期', sHint); Exit;
  end;

  if IsNextWeekEnable(FNowWeek) then
  begin
    ShowMsg('该周期已结束', sHint); Exit;
  end;

  nParam.FCommand := cCmd_AddData;
  nParam.FParamA := FNowWeek;
  CreateBaseFormItem(cFI_FormRBeiPin, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: 删除
procedure TfFrameRBeiPin.BtnDelClick(Sender: TObject);
var nStr,nSQL: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('B_Week').AsString;
  if IsNextWeekEnable(nStr) then
  begin
    ShowMsg('该周期已结束', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('R_ID').AsString;
  if not QueryDlg('确定要删除编号为[ ' + nStr + ' ]入库记录吗?', sAsk) then Exit;

  FDM.ADOConn.BeginTrans;
  with SQLQuery do
  try
    nStr := FieldByName('R_ID').AsString;
    nSQL := 'Delete From %s Where R_ID=%s';
    nSQL := Format(nSQL, [sTable_BeiPin, nStr]);
    FDM.ExecuteSQL(nSQL);
    {
    nSQL := 'Update %s Set P_Done=P_Done-%s Where P_Week=''%s'' and P_Goods=''%s''';
    nSQL := Format(nSQL, [sTable_BuyPlan, FieldByName('B_Num').AsString,
            FieldByName('B_Week').AsString, FieldByName('B_Goods').AsString]);
    FDM.ExecuteSQL(nSQL);
    }
    FDM.ADOConn.CommitTrans;
    InitFormData(FWhere);
    ShowMsg('已成功删除记录', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('删除操作失败', sError);
  end;
end;

//Desc: 执行查询
procedure TfFrameRBeiPin.EditIDPropertiesButtonClick(Sender: TObject;
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
procedure TfFrameRBeiPin.EditWeekPropertiesButtonClick(Sender: TObject;
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
  gControlManager.RegCtrl(TfFrameRBeiPin, TfFrameRBeiPin.FrameID);
end.
