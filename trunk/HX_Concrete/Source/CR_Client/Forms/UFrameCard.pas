{*******************************************************************************
  作者: dmzn@163.com 2012-04-07
  描述: 办理磁卡
*******************************************************************************}
unit UFrameCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  IniFiles, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxContainer, Menus, dxLayoutControl, cxMaskEdit, cxButtonEdit,
  cxTextEdit, ADODB, cxLabel, UBitmapPanel, cxSplitter, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin, UFrameNormal;

type
  TfFrameCard = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    cxLevel2: TcxGridLevel;
    cxView2: TcxGridDBTableView;
    DataSource2: TDataSource;
    SQLNo1: TADOQuery;
    PMenu2: TPopupMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure cxGrid1ActiveTabChanged(Sender: TcxCustomGrid;
      ALevel: TcxGridLevel);
    procedure N2Click(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure cxView2DblClick(Sender: TObject);
  private
    { Private declarations }
  protected
    FWhereNo: string;
    //未开条件
    FStart,FEnd: TDate;
    //时间区间
    FQueryHas,FQueryNo: Boolean;
    //查询开关
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    procedure OnLoadGridConfig(const nIni: TIniFile); override;
    procedure OnSaveGridConfig(const nIni: TIniFile); override;
    procedure OnInitFormData(var nDefault: Boolean; const nWhere: string = '';
     const nQuery: TADOQuery = nil); override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysBusiness, UFormBase, UDataModule, USysDataDict,
  USysConst, USysDB, USysGrid, UFormDateFilter;

//------------------------------------------------------------------------------
class function TfFrameCard.FrameID: integer;
begin
  Result := cFI_FrameTruckCard;
end;

procedure TfFrameCard.OnCreateFrame;
begin
  inherited;
  FWhereNo := '';
  FWhere := '1=1';
  
  FQueryNo := True;
  FQueryHas := True;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameCard.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

procedure TfFrameCard.OnLoadGridConfig(const nIni: TIniFile);
begin
  if BtnAdd.Enabled then
       BtnAdd.Tag := 10
  else BtnAdd.Tag := 0;

  if BtnEdit.Enabled then
       BtnEdit.Tag := 10
  else BtnEdit.Tag := 0;

  if BtnDel.Enabled then
       BtnDel.Tag := 10
  else BtnDel.Tag := 0;

  cxGrid1.ActiveLevel := cxLevel2;
  cxGrid1ActiveTabChanged(cxGrid1, cxGrid1.ActiveLevel);

  gSysEntityManager.BuildViewColumn(cxView2, 'MAIN_NOCARD');
  InitTableView(Name, cxView2, nIni);
end;

procedure TfFrameCard.OnSaveGridConfig(const nIni: TIniFile);
begin
  SaveUserDefineTableView(Name, cxView2, nIni);
end;

procedure TfFrameCard.OnInitFormData(var nDefault: Boolean;
  const nWhere: string; const nQuery: TADOQuery);
var nStr: string;
begin
  nDefault := False;
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  if FQueryHas then
  begin
    nStr := 'Select * From $BC ';
    if FWhere = '' then
         nStr := nStr + 'Where (C_Date>=''$S'' and C_Date<''$End'')'
    else nStr := nStr + 'Where (' + FWhere + ')';

    nStr := MacroValue(nStr, [MI('$BC', sTable_Card),
            MI('$S', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
    FDM.QueryData(SQLQuery, nStr);
  end;

  if not FQueryNo then Exit;
  nStr := 'Select * From $TR Where ENNAME Not In (' +
          'Select IsNull(C_TruckNo,'''') From $BC)';

  if FWhereNo <> '' then
    nStr := nStr + ' And (' + FWhereNo + ')';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$TR', sTable_Truck), MI('$BC', sTable_Card)]);
  FDM.QueryData(SQLNo1, nStr);
end;

//------------------------------------------------------------------------------
procedure TfFrameCard.cxGrid1ActiveTabChanged(Sender: TcxCustomGrid;
  ALevel: TcxGridLevel);
begin
  BtnEdit.Enabled := (BtnEdit.Tag > 0) and (cxGrid1.ActiveView = cxView1);
  BtnDel.Enabled := (BtnDel.Tag > 0) and (cxGrid1.ActiveView = cxView1);
end;

//Desc: 刷新
procedure TfFrameCard.BtnRefreshClick(Sender: TObject);
begin
  FWhere := '1=1';
  FWhereNo := '';
  FQueryNo := True;
  FQueryHas := True;
  InitFormData(FWhere);
end;

//Desc: 办理
procedure TfFrameCard.BtnAddClick(Sender: TObject);
var nTruck: string;
begin
  if BtnAdd.Enabled then
       nTruck := ''
  else Exit;

  if cxGrid1.ActiveView = cxView2 then
  begin
    if cxView2.DataController.GetSelectedCount < 1 then
    begin
      ShowMsg('请选择要办卡的车辆', sHint); Exit;
    end;

    nTruck := SQLNo1.FieldByName('ENNAME').AsString;
  end;

  if SetTruckCard(nTruck) then 
  begin
    FQueryNo := cxGrid1.ActiveView = cxView2;
    FQueryHas := True;
    InitFormData(FWhere);
  end;
end;

//Desc 删除
procedure TfFrameCard.BtnDelClick(Sender: TObject);
var nStr,nSQL: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的磁卡', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('C_Status').AsString;
  if (nStr <> sFlag_CardIdle) and (nStr <> sFlag_CardInvalid) then
  begin
    ShowMsg('空闲或注销卡允许删除', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('C_Freeze').AsString;
  if nStr = sFlag_Yes then
  begin
    ShowMsg('该卡已经被冻结', sHint); Exit;
  end;

  nSQL := '确定要对卡[ %s ]执行删除操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Delete From %s Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_Card, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('删除操作成功', sHint);
end;

//Desc: 快捷菜单
procedure TfFrameCard.N2Click(Sender: TObject);
begin
  BtnAddClick(nil);
end;

//Desc: 双击办理卡片
procedure TfFrameCard.cxView2DblClick(Sender: TObject);
begin
  if cxView2.DataController.GetSelectedCount > 0 then BtnAddClick(nil);
end;

//Desc: 日期筛选
procedure TfFrameCard.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then
  begin
    cxGrid1.ActiveLevel := cxLevel1;
    FWhere := '';
    InitFormData(FWhere);
  end;
end;

//Desc: 执行查询
procedure TfFrameCard.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    FQueryNo := False;
    FQueryHas := True;

    FWhere := 'C_Card like ''%' + EditCard.Text + '%''';
    FWhereNo := '';
    InitFormData(FWhere);
    cxGrid1.ActiveLevel := cxLevel1;
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FQueryNo := True;
    FQueryHas := True;

    FWhere := 'C_TruckNo like ''%' + EditTruck.Text + '%''';
    FWhereNo := 'ENNAME like ''%' + EditTruck.Text + '%''';
    InitFormData(FWhere);

    if SQLQuery.RecordCount > 0 then
      cxGrid1.ActiveLevel := cxLevel1
    else
    if SQLNo1.RecordCount > 0 then
      cxGrid1.ActiveLevel := cxLevel2;
    //xxxxx
  end;
end;

//Desc: 查询全部未办理
procedure TfFrameCard.N4Click(Sender: TObject);
begin
  FQueryNo := True;
  FQueryHas := False;

  FWhereNo := '1=1';
  InitFormData(FWhere);
end;

//Desc: 无效磁卡
procedure TfFrameCard.N5Click(Sender: TObject);
begin
  FQueryNo := False;
  FQueryHas := True;

  FWhere := 'L_ID Is Null';
  InitFormData(FWhere);
end;

//Desc: 全部磁卡
procedure TfFrameCard.N6Click(Sender: TObject);
begin
  FQueryNo := False;
  FQueryHas := True;

  FWhere := '1=1';
  InitFormData(FWhere);
end;

//Desc: 冻结磁卡
procedure TfFrameCard.N8Click(Sender: TObject);
begin
  FQueryNo := False;
  FQueryHas := True;

  FWhere := 'C_Freeze=''%s''';
  FWhere := Format(FWhere, [sFlag_Yes]);
  InitFormData(FWhere);
end;

//------------------------------------------------------------------------------
//Desc: 控制菜单项
procedure TfFrameCard.PMenu1Popup(Sender: TObject);
var nStr: string;
    i,nCount: integer;
begin
  nCount := PMenu1.Items.Count - 1;
  for i:=0 to nCount do
    PMenu1.Items[i].Enabled := False;
  //xxxxx
  
  N1.Enabled := True;
  N17.Enabled := cxView1.DataController.GetSelectedCount > 0;
  //备注信息

  if (cxView1.DataController.GetSelectedCount > 0) and BtnAdd.Enabled then
  begin
    nStr := SQLQuery.FieldByName('C_Status').AsString;
    N9.Enabled := nStr = sFlag_CardUsed;
    //使用中的卡可以挂失
    N10.Enabled := nStr = sFlag_CardLoss;
    //已挂失卡可以解挂失
    N11.Enabled := nStr = sFlag_CardLoss;
    //已挂失卡可以补办卡
    N12.Enabled := nStr <> sFlag_CardInvalid;
    //可随时销卡
  end;

  if (cxView1.DataController.GetSelectedCount > 0) and BtnEdit.Enabled then
  begin
    nStr := SQLQuery.FieldByName('C_Freeze').AsString;
    N14.Enabled := nStr <> sFlag_Yes;   //冻结
    N15.Enabled := nStr = sFlag_Yes;    //解除
  end;
end;

//Desc: 挂失磁卡
procedure TfFrameCard.N9Click(Sender: TObject);
var nStr,nSQL: string;
begin
  nSQL := '确定要对卡[ %s ]执行挂失操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Update %s Set C_Status=''%s'' Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_Card, sFlag_CardLoss, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('挂失操作成功', sHint);
end;

//Desc: 解除挂失
procedure TfFrameCard.N10Click(Sender: TObject);
var nStr,nSQL: string;
begin
  nSQL := '确定要对卡[ %s ]执行解除挂失操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Update %s Set C_Status=''%s'' Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_Card, sFlag_CardUsed, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('解除挂失操作成功', sHint);
end;

//Desc: 补办磁卡
procedure TfFrameCard.N11Click(Sender: TObject);
var nTruck: string;
begin
  nTruck := SQLQuery.FieldByName('C_TruckNo').AsString;

  if SetTruckCard(nTruck) then
  begin
    InitFormData(FWhere);
    ShowMsg('补卡操作成功', sHint);
  end;
end;

//Desc: 注销磁卡
procedure TfFrameCard.N12Click(Sender: TObject);
var nStr,nCard: string;
begin
  nCard := SQLQuery.FieldByName('C_Card').AsString;
  nStr := Format('确定要对卡[ %s ]执行销卡操作吗?', [nCard]);
  if not QueryDlg(nStr, sAsk) then Exit;

  if LogoutBillCard(nCard) then
  begin
    InitFormData(FWhere);
    ShowMsg('注销操作成功', sHint);
  end;
end;

//Desc: 冻结磁卡
procedure TfFrameCard.N14Click(Sender: TObject);
var nStr,nSQL: string;
begin
  nSQL := '确定要对卡[ %s ]执行冻结操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Update %s Set C_Freeze=''%s'' Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_Card, sFlag_Yes, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('冻结操作成功', sHint);
end;

//Desc: 解除冻结
procedure TfFrameCard.N15Click(Sender: TObject);
var nStr,nSQL: string;
begin
  nSQL := '确定要对卡[ %s ]执行解除冻结操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Update %s Set C_Freeze=''%s'' Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_Card, sFlag_No, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('解除冻结操作成功', sHint);
end;

//Desc: 修改备注
procedure TfFrameCard.N17Click(Sender: TObject);
var nStr: string;
    nP: TFormCommandParam;
begin
  if BtnEdit.Enabled then
  begin
    nP.FCommand := cCmd_EditData;
    nP.FParamA := SQLQuery.FieldByName('C_Memo').AsString;
    nP.FParamB := 500;

    nStr := SQLQuery.FieldByName('R_ID').AsString;
    nP.FParamC := 'Update %s Set C_Memo=''$Memo'' Where R_ID=%s';
    nP.FParamC := Format(nP.FParamC, [sTable_Card, nStr]);

    CreateBaseFormItem(cFI_FormMemo, '', @nP);
    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
      InitFormData(FWhere);
    //xxxxx
  end else
  begin
    nP.FCommand := cCmd_ViewData;
    nP.FParamA := SQLQuery.FieldByName('C_Memo').AsString;
    CreateBaseFormItem(cFI_FormMemo, '', @nP);
  end;;
end;

initialization
  gControlManager.RegCtrl(TfFrameCard, TfFrameCard.FrameID);
end.
