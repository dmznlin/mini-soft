{*******************************************************************************
  作者: dmzn@163.com 2009-9-14
  描述: 计数窗口
*******************************************************************************}
unit UFormJS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxGraphics,
  cxMemo, cxButtonEdit, cxLabel, cxTextEdit, cxContainer, cxEdit,
  cxMaskEdit, cxDropDownEdit, SPComm;

type
  TDaiData = record
    FNowDai: integer;         //待装数量
    FHasDone: integer;        //已装数量
    
    FTotalDS: Integer;        //已装应提
    FTotalBC: integer;        //已装补差
    FSavedDS: integer;        //已存应提
    FSavedBC: Integer;        //已存补差
  end;

  TfFormJS = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    EditZT: TcxComboBox;
    dxLayout1Item3: TdxLayoutItem;
    EditTruck: TcxComboBox;
    dxLayout1Item4: TdxLayoutItem;
    EditStock: TcxComboBox;
    dxLayout1Item5: TdxLayoutItem;
    EditSID: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditWeight: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditNum: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditNumNow: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    EditHas: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    BtnStart: TButton;
    dxLayout1Item12: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Item13: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    cxLabel1: TcxLabel;
    dxLayout1Item14: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    EditCus: TcxComboBox;
    dxLayout1Item15: TdxLayoutItem;
    dxLayout1Group7: TdxLayoutGroup;
    CommJS: TComm;
    dxLayout1Group4: TdxLayoutGroup;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditStockPropertiesChange(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure CommJSReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormCreate(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure EditCusKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditWeightPropertiesEditValueChanged(Sender: TObject);
    procedure EditNumPropertiesEditValueChanged(Sender: TObject);
  private
    { Private declarations }
  protected
    FRecordID: string;
    //记录编号
    FPerWeight: Double;
    //袋重
    FIsBC: Boolean;
    //是否补差
    FData: TDaiData;
    //装车数据
    FLastTime: Int64;
    //上次时间
    procedure InitFormData(const nID: string);
    //初始化数据
    procedure LockCtrl(const nLock: Boolean);
    procedure SetZhuangCheMode(const nIsBC: Boolean);
    procedure SetCtrlStatus(const nEnable: Boolean);
    //设置状态
    function SetJsqData: Boolean;
    //设置计数器
    function SaveJSData: Boolean;
    //保存数据
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

function PrintJSReport(const nID: string; const nAsk: Boolean): Boolean;
//入口函数

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UAdjustForm, UFormZTParam, USysConst, USysDB,
  UDataModule, UDataReport, UFormInputbox, UFormBase, UFrameBase, UFormCtrl,
  UFormWait;

var
  gFormCount: integer = 0;
  //窗体计数

//------------------------------------------------------------------------------
class function TfFormJS.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;

  with TfFormJS.Create(Application) do
  begin
    Inc(gFormCount);
    Caption := Format('计数窗口:[ %d ]', [gFormCount]);
    FormStyle := fsStayOnTop;

    if Assigned(nParam) then
         FRecordID := PFormCommandParam(nParam).FParamA
    else FRecordID := '';
    
    InitFormData(FRecordID);
    Show;
  end;
end;

//Desc: 打印表示为nID的提货记录
function PrintJSReport(const nID: string; const nAsk: Boolean): Boolean;
var nStr: string;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印提货记录?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s,%s Where L_Stock=S_ID And L_ID=%s';
  nStr := Format(nStr, [sTable_StockType, sTable_JSLog, nID]);
  
  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s] 的提货记录已无效!!';
    nStr := Format(nStr, [nID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'Lading.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//------------------------------------------------------------------------------
class function TfFormJS.FormID: integer;
begin
  Result := cFI_FormJSForm;
end;

procedure TfFormJS.FormCreate(Sender: TObject);
begin
  inherited;
  FIsBC := False;

  FillChar(FData, SizeOf(FData), #0);
  ResetHintAllCtrl(Self, 'T', sTable_JSLog);
end;

procedure TfFormJS.FormClose(Sender: TObject; var Action: TCloseAction);
var nStr: string;
    nIni: TIniFile;
begin
  if CommJS.Handle <> 0 then
  begin
    nStr := '确定要退出计数窗口吗?';
    if not QueryDlg(nStr, sAsk, Handle) then
    begin
      Action := caNone; Exit;
    end;
  end;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nStr := GetCtrlData(EditZT);
    nIni.WriteString(ClassName, 'ZTName', nStr);
  finally
    nIni.Free;
  end;

  CommJS.StopComm;
  SaveJSData;
  ReleaseCtrlData(Self);
  inherited;
end;

//------------------------------------------------------------------------------
//Desc: 设置组件状态
procedure TfFormJS.SetCtrlStatus(const nEnable: Boolean);
begin
  EditSID.Enabled := nEnable;
  EditWeight.Enabled := nEnable;
  EditNum.Enabled := nEnable;
end;

//Desc: 锁定界面控件
procedure TfFormJS.LockCtrl(const nLock: Boolean);
begin
  EditTruck.Properties.ReadOnly := nLock;
  EditCus.Properties.ReadOnly := nLock;
  EditStock.Properties.ReadOnly := nLock;
  EditSID.Properties.ReadOnly := nLock;
  EditWeight.Properties.ReadOnly := nLock;
  EditNum.Properties.ReadOnly := nLock;
end;

//Desc: 设置装车模式
procedure TfFormJS.SetZhuangCheMode(const nIsBC: Boolean);
begin
  FIsBC := nIsBC;
  EditNum.Text := '0';
  EditWeight.Text := '0';

  EditNum.Properties.ReadOnly := False;
  EditWeight.Properties.ReadOnly := False;

  if nIsBC then
  begin
    dxLayout1Item7.Caption := '补 差 量:';
    dxLayout1Item8.Caption := '补差袋数:';
  end else
  begin
    dxLayout1Item7.Caption := '提 货 量:';
    dxLayout1Item8.Caption := '应提袋数:';
  end;
end;

//Desc: 初始化数据
procedure TfFormJS.InitFormData(const nID: string);
var nStr: string;
    nIni: TIniFile;
begin
  BtnOK.Enabled := False;
  BtnStart.Enabled := False;

  SetCtrlStatus(False);
  LoadZTList(EditZT.Properties.Items, False);
  AdjustStringsItem(EditZT.Properties.Items, False);
  //栈台列表

  if EditTruck.Properties.Items.Count < 1 then
  begin
    nStr := 'Select Distinct T_TruckNo From %s Order By T_TruckNo';
    nStr := Format(nStr, [sTable_TruckInfo]);
    FDM.FillStringsData(EditTruck.Properties.Items, nStr);
  end;

  if EditCus.Properties.Items.Count < 1 then
  begin
    nStr := 'Select Distinct C_Name From %s Order By C_Name';
    nStr := Format(nStr, [sTable_Customer]);
    FDM.FillStringsData(EditCus.Properties.Items, nStr);
  end;

  if EditStock.Properties.Items.Count < 1 then
  begin
    nStr := 'S_ID=Select S_ID,S_Name From %s Order By S_ID';
    nStr := Format(nStr, [sTable_StockType]);

    FDM.FillStringsData(EditStock.Properties.Items, nStr, -1, '、');
    AdjustStringsItem(EditStock.Properties.Items, False);
  end;

  if nID <> '' then
  begin
    LockCtrl(True);
    //锁定控件

    nStr := 'Select * From %s Where L_ID=%s';
    nStr := Format(nStr, [sTable_JSLog, nID]);
    LoadDataToForm(FDM.QuerySQL(nStr), Self, sTable_JSLog);

    EditWeight.Text := FDM.SqlQuery.FieldByName('L_Weight').AsString;
    EditCus.Text := FDM.SqlQuery.FieldByName('L_Customer').AsString;
    EditTruck.Text := FDM.SqlQuery.FieldByName('L_TruckNo').AsString;

    FData.FSavedBC := FDM.SqlQuery.FieldByName('L_BC').AsInteger;
    FData.FTotalBC := FData.FSavedBC;
    FData.FSavedDS := FDM.SqlQuery.FieldByName('L_DaiShu').AsInteger;
    FData.FTotalDS := FData.FSavedDS;
    
    if FDM.SqlQuery.FieldByName('L_DaiShu').AsInteger > 0 then
      SetZhuangCheMode(True);
    //xxxxx
  end;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nStr := nIni.ReadString(ClassName, 'ZTName', '');
    SetCtrlData(EditZT, nStr);
  finally
    nIni.Free;
  end;
end;

//Desc: 选择品种
procedure TfFormJS.EditStockPropertiesChange(Sender: TObject);
var nStr: string;
begin
  FPerWeight := 0;
  SetCtrlStatus(False);
  if EditStock.ItemIndex < 0 then Exit;

  nStr := 'Select S_Weight From %s Where S_ID=''%s''';
  nStr := Format(nStr, [sTable_StockType, GetCtrlData(EditStock)]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    FPerWeight := Fields[0].AsFloat;
    if FPerWeight <=0 then
    begin
      ShowMsg('该品种袋重参数错误!', sHint); Exit;
    end;
  end else
  begin
    ShowMsg('该品种已无效', sHint); Exit;
  end;

  SetCtrlStatus(True);
end;

//Desc: 计算袋数
procedure TfFormJS.EditWeightPropertiesEditValueChanged(Sender: TObject);
var nInt: integer;
begin
  if FPerWeight > 0 then
  if IsNumber(EditWeight.Text, True) then
  begin
    nInt := Round(StrToFloat(EditWeight.Text) * 1000 / FPerWeight);
    EditNum.Text := IntToStr(nInt);

    if FRecordID = '' then
         BtnOK.Enabled := nInt > 0
    else BtnStart.Enabled := nInt > 0;
  end else
  begin
    EditWeight.Text := '0';
    BtnStart.Enabled := False;
  end;
end;

//Desc: 计算吨数
procedure TfFormJS.EditNumPropertiesEditValueChanged(Sender: TObject);
var nValue: Double;
begin
  if FPerWeight > 0 then
  if IsNumber(EditNum.Text, False) then
  begin
    nValue := StrToInt(EditNum.Text) * FPerWeight / 1000;
    EditWeight.Text := FloatToStr(nValue);

    if FRecordID = '' then
         BtnOK.Enabled := nValue > 0
    else BtnStart.Enabled := nValue > 0;
  end else
  begin
    EditNum.Text := '0';
    BtnStart.Enabled := False;
  end;
end;

//Desc: 开始计数或补差
function TfFormJS.SetJsqData: Boolean;
var nInt: Integer;
    nBuf,nVer: Byte;
    nStr,nErr: string;
begin
  Result := False;
  if Length(EditTruck.Text) < 3 then
  begin
    EditTruck.SetFocus;
    ShowMsg('车牌号应该大于三位', sHint); Exit;
  end;

  if EditZT.ItemIndex < 0 then
  begin
    EditZT.SetFocus;
    ShowMsg('请选择提货的栈台', sHint); Exit;
  end;

  try
    if CommJS.Handle < 1 then
    begin
      nErr := '与计数器通信失败';
      CommJS.CommName := GetCtrlData(EditZT);
      CommJS.StartComm;
      Sleep(1000);
    end;

    nErr := '发送车牌号失败';
    nStr := Copy(EditTruck.Text, Length(EditTruck.Text) - 2, 3);

    nVer := 0;
    nBuf := Ord('@');
    //ComJsq.WriteCommData(@nBuf, 1);

    for nInt:=1 to Length(nStr) do
    begin
      nBuf := Ord(nStr[nInt]) - 48;
      nVer := nVer + nBuf;
      CommJS.WriteCommData(@nBuf, 1);
    end;

    nErr := '发送袋数失败';
    nStr := IntToStr(FData.FNowDai);
    nStr := StringOfChar('0', 4 - Length(nStr)) + nStr;
    //四位补全

    for nInt:=1 to Length(nStr) do
    begin
      nBuf := Ord(nStr[nInt]) - 48;
      nVer := nVer + nBuf;
      CommJS.WriteCommData(@nBuf, 1);
    end;

    CommJS.WriteCommData(@nVer, 1);
    nBuf := 13;
    CommJS.WriteCommData(@nBuf, 1);

    Sleep(1000);
    Result := True;
  except
    ShowMsg(nErr, sHint); Exit;
  end;          
end;

//Desc: 反馈数据
procedure TfFormJS.CommJSReceiveData(Sender: TObject; Buffer: Pointer;
  BufferLength: Word);
var nStr: string;
    nInt: integer;
    nBuf: array of Char;
begin
  if BufferLength < 1 then
       Exit
  else nStr := '';

  SetLength(nBuf, BufferLength);
  Move(Buffer^, (@nBuf[0])^, BufferLength);

  for nInt:=BufferLength - 1 downto 0 do
  if nBuf[nInt] = #13 then
  begin
    if nInt < 5 then Exit;
    
    nStr := IntToStr(Ord(nBuf[nInt-4])) +
            IntToStr(Ord(nBuf[nInt-3])) +
            IntToStr(Ord(nBuf[nInt-2])) + IntToStr(Ord(nBuf[nInt-1]));
    Break;
  end;

  if IsNumber(nStr, False) then
  with FData do
  begin
    nInt := FNowDai - StrToInt(nStr);
    if nInt < 0 then Exit;

    FHasDone := FHasDone + nInt;
    if FIsBC then
         FTotalBC := FTotalBC + nInt
    else FTotalDS := FTotalDS + nInt;

    FNowDai := StrToInt(nStr);
    //更新计数器当前值

    nStr := '合计已装[ %d ]袋 当前已装[ %d ]袋';
    nStr := Format(nStr, [FTotalDS + FTotalBC, FHasDone]);
    EditHas.Text := nStr;   

    if FData.FNowDai = 0 then
    begin
      nStr := '应装[ %d ]袋,已经完成!!';
      nStr := Format(nStr, [FHasDone]);
      EditNumNow.Text := nStr;

      if not FIsBC then FIsBC := True;
      SetZhuangCheMode(FIsBC);
      
      FLastTime := GetTickCount;
      TComm(Sender).StopComm;
    end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 检索客户
procedure TfFormJS.EditCusKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var nStr: string;
begin
  if Key = 13 then
  begin
    Key := 0;
    nStr := 'Select C_Name From %s Where C_ID Like ''%%%s%%'' Or ' +
            'C_Name Like ''%%%s%%'' Or C_PY Like ''%%%s%%''';
    nStr := Format(nStr, [sTable_Customer, EditCus.Text, EditCus.Text, EditCus.Text]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      EditCus.Text := Fields[0].AsString;
    end;
  end;
end;

//Desc: 开始计数
procedure TfFormJS.BtnStartClick(Sender: TObject);
var nStr: string;
begin
  if FIsBC then
  begin
    FData.FNowDai := StrToInt(EditNum.Text);
    nStr := '补差提货,应装[ %d ]袋';
    EditNumNow.Text := Format(nStr, [FData.FNowDai]);
  end else
  begin
    FData.FNowDai := StrToInt(EditNum.Text);
    nStr := '正常提货,应装[ %d ]袋';
    EditNumNow.Text := Format(nStr, [FData.FNowDai]);
  end;

  if FData.FNowDai < 1 then
  begin
    ShowMsg('袋数无效,无法计数', sHint); Exit;
  end;

  FData.FHasDone := 0;
  EditHas.Text := '';
  Application.ProcessMessages;

  if GetTickCount - FLastTime < 3 * 1000 then
    Sleep(1500);
  //上次完成时间不足3秒,等待
  BtnStart.Enabled := not SetJsqData;
  if not BtnStart.Enabled then LockCtrl(True);
end;

//Desc: 保存提货记录
procedure TfFormJS.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if Length(EditTruck.Text) < 3 then
  begin
    EditTruck.SetFocus;
    ShowMsg('车牌号应该大于三位', sHint); Exit;
  end;

  if EditZT.ItemIndex < 0 then
  begin
    EditZT.SetFocus;
    ShowMsg('请选择提货的栈台', sHint); Exit;
  end;
  
  nStr := 'Insert Into $Tb(L_TruckNo,L_Stock,L_SerialID,L_Weight,L_DaiShu,' +
          'L_BC,L_PValue,L_ZTLine,L_Customer,L_Date,L_Man,L_HasDone,L_Memo) ' +
          'Values(''$No'', ''$Stock'', ''$SID'', $Wht, 0, 0, 0, ''$ZT'',' +
          '''$Cus'', ''$Date'', ''$Man'', ''$FN'', ''$Memo'')';

  nStr := MacroValue(nStr, [MI('$Tb', sTable_JSLog), MI('$No', EditTruck.Text),
          MI('$Stock', GetCtrlData(EditStock)), MI('$SID', EditSID.Text),
          MI('$Wht', EditWeight.Text), MI('$Cus', EditCus.Text),
          MI('$ZT', Copy(EditZT.Text, Pos('.', EditZT.Text) + 1, MaxInt)),
          MI('$Date', DateTime2Str(Now)), MI('$Man', gSysParam.FUserID),
          MI('$FN', sFlag_No), MI('$Memo', EditMemo.Text)]);
  try
    FDM.ExecuteSQL(nStr);
    FRecordID := IntToStr(FDM.GetFieldMax(sTable_JSLog, 'L_ID'));

    BtnOK.Enabled := False;
    BroadcastFrameCommand(Self, cCmd_RefreshData);

    LockCtrl(True);
    BtnStart.Enabled := True;
    ShowMsg('已成功保存', sHint);
  except
    ShowMsg('保存数据失败', sWarn);
  end;
end;

//Desc: 保存提货数据
function TfFormJS.SaveJSData: Boolean;
var nStr,nPV: string;
begin
  Result := True;
  if (FData.FTotalDS <> FData.FSavedDS) or
     (FData.FTotalBC <> FData.FSavedBC) then
  begin
    if FData.FTotalDS = 0 then
         nPV := '0.00'
    else nPV := Format('%.2f', [FData.FTotalBC / FData.FTotalDS * 100]);

    nStr := 'Update %s Set L_DaiShu=%d,L_BC=%d,L_PValue=%s,L_HasDone=''%s'' '+
            'Where L_ID=%s';
    nStr := Format(nStr, [sTable_JSLog, FData.FTotalDS, FData.FTotalBC,
            nPV, sFlag_Yes, FRecordID]);

    Result := FDM.ExecuteSQL(nStr) > 0;
    if Result then
    begin
      FData.FSavedDS := FData.FTotalDS;
      FData.FSavedBC := FData.FTotalBC;
      BroadcastFrameCommand(Self, cCmd_RefreshData);
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormJS, TfFormJS.FormID);
end.
