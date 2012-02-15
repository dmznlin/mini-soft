{*******************************************************************************
  作者: dmzn@163.com 2011-6-7
  描述: 采购计划
*******************************************************************************}
unit UFrameBuyPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, IniFiles, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, dxLayoutControl,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameBuyPlan = class(TfFrameNormal)
    EditName: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    cxLevel2: TcxGridLevel;
    cxView2: TcxGridDBTableView;
    EditWeek: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    SQLQuery2: TADOQuery;
    DataSource2: TDataSource;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure EditWeekPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxGrid1ActiveTabChanged(Sender: TcxCustomGrid;
      ALevel: TcxGridLevel);
    procedure cxView2DblClick(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
  private
    { Private declarations }
    FWhereDtl: string;
    //查询条件
    FLoadAll: Boolean;
    //全部载入
    FNowYear,FNowWeek,FWeekName: string;
    //当前周期
    procedure LoadDefaultWeek;
    //默认周期
  protected
    procedure OnCreateFrame; override;
    procedure OnLoadGridConfig(const nIni: TIniFile); override;
    procedure OnSaveGridConfig(const nIni: TIniFile); override;
    procedure OnInitFormData(var nDefault: Boolean; const nWhere: string = '';
     const nQuery: TADOQuery = nil); override;
    procedure AfterInitFormData; override;
    {*基类函数*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, UFormBase,
  USysDataDict, USysGrid, USysBusiness;

class function TfFrameBuyPlan.FrameID: integer;
begin
  Result := cFI_FramePlan;
end;

procedure TfFrameBuyPlan.OnCreateFrame;
begin
  inherited;
  FLoadAll := True;
  FWhereDtl := '';
  LoadDefaultWeek;
end;

procedure TfFrameBuyPlan.OnLoadGridConfig(const nIni: TIniFile);
begin
  if BtnAdd.Enabled then BtnAdd.Tag := 27 else BtnAdd.Tag := 0;
  if BtnEdit.Enabled then BtnEdit.Tag := 27 else BtnEdit.Tag := 0;
  if BtnDel.Enabled then BtnDel.Tag := 27 else BtnDel.Tag := 0;

  cxGrid1.ActiveLevel := cxLevel1;
  cxGrid1ActiveTabChanged(cxGrid1, cxLevel1);
  
  gSysEntityManager.BuildViewColumn(cxView2, 'BuyReq');
  InitTableView(Name, cxView2, nIni);
end;

procedure TfFrameBuyPlan.OnSaveGridConfig(const nIni: TIniFile);
begin
  SaveUserDefineTableView(Name, cxView2, nIni);
end;

//Desc: 载入默认周期
procedure TfFrameBuyPlan.LoadDefaultWeek;
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

//Desc: 关闭
procedure TfFrameBuyPlan.BtnExitClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if not IsBusy then
  begin
    nParam.FCommand := cCmd_FormClose;
    CreateBaseFormItem(cFI_FormStorage, '', @nParam); Close;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 查询数据
procedure TfFrameBuyPlan.OnInitFormData(var nDefault: Boolean;
  const nWhere: string; const nQuery: TADOQuery);
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
  end;

  nDefault := False;
  //no default load

  if FLoadAll or (cxGrid1.ActiveLevel = cxLevel1) then
  begin
    nStr := 'Select pl.*,wk.W_Name,gd.* From $PL pl ' +
            ' Left Join $Week wk On wk.W_NO=pl.P_Week ' +
            ' Left Join $Gd gd On gd.G_ID=pl.P_Goods ';
    //xxxxx

    if FNowWeek <> '' then
      nWeek := Format('Where P_Week=''%s''', [FNowWeek]);
    //xxxxx

    if FWhere = '' then
         nStr := nStr + nWeek
    else nStr := nStr + 'Where ( ' + FWhere + ' )';

    nStr := MacroValue(nStr, [MI('$PL', sTable_BuyPlan),
            MI('$Week', sTable_Weeks), MI('$Gd', sTable_Goods)]);
    FDM.QueryData(SQLQuery, nStr);
  end;

  if FLoadAll or (cxGrid1.ActiveLevel = cxLevel2) then
  begin
    nStr := 'Select req.*,W_Name,D_Name,gd.* From $Req req ' +
            ' Left Join $Week On W_NO=req.R_Week '+
            ' Left Join $Dept On D_ID=req.R_Department ' +
            ' Left Join $Gd gd On gd.G_ID=req.R_Goods ';
    //xxxxx

    if FNowWeek <> '' then
      nWeek := Format('Where R_Week=''%s''', [FNowWeek]);
    //xxxxx

    if FWhereDtl = '' then
         nStr := nStr + nWeek
    else nStr := nStr + 'Where ( ' + FWhereDtl + ' )';

    nStr := MacroValue(nStr, [MI('$Req', sTable_BuyReq),
            MI('$Week', sTable_Weeks), MI('$Dept', sTable_Department),
            MI('$Gd', sTable_Goods)]);
    FDM.QueryData(SQLQuery2, nStr);
  end;
end;

procedure TfFrameBuyPlan.AfterInitFormData;
begin
  FLoadAll := False;
end;

procedure TfFrameBuyPlan.cxGrid1ActiveTabChanged(Sender: TcxCustomGrid;
  ALevel: TcxGridLevel);
begin
  BtnAdd.Enabled := (BtnAdd.Tag > 0) and (ALevel = cxLevel1);
  BtnEdit.Enabled := (BtnEdit.Tag > 0) and (ALevel = cxLevel2);
  BtnDel.Enabled := (BtnDel.Tag > 0) and (ALevel = cxLevel2);
end;

//------------------------------------------------------------------------------
//Desc: 刷新
procedure TfFrameBuyPlan.BtnRefreshClick(Sender: TObject);
begin
  FWhere := '';
  FWhereDtl := '';
  InitFormData();
end;

//Desc: 生成采购计划
procedure TfFrameBuyPlan.BtnAddClick(Sender: TObject);
var nStr: string;
    nParam: TFormCommandParam;
begin
  if FNowWeek = '' then
  begin
    ShowMsg('请先选择周期', sHint); Exit;
  end;

  if IsNextWeekEnable(FNowWeek) or (not IsWeekValid(FNowWeek, nStr)) then
  begin
    ShowMsg('该周期已结束', sHint); Exit;
  end;

  nParam.FCommand := cCmd_AddData;
  nParam.FParamA := FNowWeek;
  nParam.FParamB := FWeekName;
  CreateBaseFormItem(cFI_FormBuyPlan, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: 采购申请
procedure TfFrameBuyPlan.BtnEditClick(Sender: TObject);
var nStr: string;
    nParam: TFormCommandParam;
begin
  if FNowWeek = '' then
  begin
    ShowMsg('请先选择周期', sHint); Exit;
  end;

  if IsNextWeekEnable(FNowWeek) or (not IsWeekValid(FNowWeek, nStr)) then
  begin
    ShowMsg('该周期已结束', sHint); Exit;
  end;

  nParam.FCommand := cCmd_AddData;
  nParam.FParamA := FNowWeek;
  nParam.FParamB := FWeekName;
  CreateBaseFormItem(cFI_FormBuyReq, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData(FWhere);
  end;
end;

//Desc: 删除采购计划项
procedure TfFrameBuyPlan.BtnDelClick(Sender: TObject);
var nStr,nSQL: string;
begin
  if cxView2.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nStr := SQLQuery2.FieldByName('R_Week').AsString;
  if IsNextWeekEnable(nStr) or (not IsWeekValid(nStr, nStr)) then
  begin
    ShowMsg('该周期已结束', sHint); Exit;
  end;

  nStr := SQLQuery2.FieldByName('R_ID').AsString;
  if not QueryDlg('确定要删除编号为[ ' + nStr + ' ]的记录吗?', sAsk) then Exit;

  nSQL := 'Delete From %s Where R_ID=%s';
  nSQL := Format(nSQL, [sTable_BuyReq, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('删除成功', sHint);
end;

//Desc: 执行查询
procedure TfFrameBuyPlan.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := 'G_Name like ''%%%s%%'' Or G_PY Like ''%%%s%%''';
    FWhere := Format(FWhere, [EditName.Text, EditName.Text]);
    FWhereDtl := FWhere;

    FLoadAll := True;
    InitFormData(FWhere);
  end;
end;

//Desc: 修改申请
procedure TfFrameBuyPlan.cxView2DblClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if (BtnEdit.Tag > 0) and (cxView2.DataController.GetSelectedCount > 0) then
  begin
    nParam.FCommand := cCmd_EditData;
    nParam.FParamA := SQLQuery2.FieldByName('R_Week').AsString;
    nParam.FParamB := SQLQuery2.FieldByName('W_Name').AsString;
    nParam.FParamC := SQLQuery2.FieldByName('R_Department').AsString;

    CreateBaseFormItem(cFI_FormBuyReq, PopedomItem, @nParam);
    if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;
  end;
end;

//Desc: 选择周期
procedure TfFrameBuyPlan.EditWeekPropertiesButtonClick(Sender: TObject;
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

    FLoadAll := True;
    InitFormData(FWhere);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameBuyPlan, TfFrameBuyPlan.FrameID);
end.
