{*******************************************************************************
  作者: dmzn@163.com 2013-3-18
  描述: 查询报表
*******************************************************************************}
unit UFrameReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, USysProtocol, Series, UFrameBase, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, DB, ADODB,
  ExtCtrls, cxCheckBox, TeeProcs, TeEngine, Chart, Grids, DBGrids, cxPC,
  cxDropDownEdit, cxCheckComboBox, cxTextEdit, cxMaskEdit, cxCalendar,
  cxLabel, StdCtrls;

type
  TfFrameReport = class(TfFrameBase)
    Panel2: TPanel;
    Panel1: TPanel;
    BtnNext: TButton;
    cxLabel1: TcxLabel;
    EditTime: TcxDateEdit;
    BtnPre: TButton;
    TimerUI: TTimer;
    wPage: TcxPageControl;
    SheetBreakPipe: TcxTabSheet;
    SheetBreakPot: TcxTabSheet;
    SheetTotalPipe: TcxTabSheet;
    SheetChart: TcxTabSheet;
    DBGrid1: TDBGrid;
    QueryBreakPipe: TADOQuery;
    QueryBreakPot: TADOQuery;
    QueryTotalPipe: TADOQuery;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DataSource3: TDataSource;
    cxLabel2: TcxLabel;
    EditDevice: TcxCheckComboBox;
    Chart1: TChart;
    CheckBreakPipe: TcxCheckBox;
    CheckTotalPipe: TcxCheckBox;
    CheckBreakPot: TcxCheckBox;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    Bevel1: TBevel;
    EditCheck: TcxComboBox;
    procedure TimerUITimer(Sender: TObject);
    procedure CheckBreakPipeClick(Sender: TObject);
    procedure BtnPreClick(Sender: TObject);
    procedure BtnNextClick(Sender: TObject);
    procedure EditTimePropertiesEditValueChanged(Sender: TObject);
    procedure EditTimeKeyPress(Sender: TObject; var Key: Char);
    procedure EditCheckPropertiesChange(Sender: TObject);
    procedure EditDevicePropertiesCloseUp(Sender: TObject);
  protected
    { Protected declarations }
    FLastDevice: string;
    FPageBegin,FPageEnd: TDateTime;
    procedure OnShowFrame; override;
    //inhere
    function BuildDeviceIDList: string;
    procedure LoadDeviceList;
    procedure QueryData(const nQuery: Boolean = True);
    //ui data
    procedure AddChartItem(const nType: TItemType; nInit: Boolean = False);
    //series
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UMgrConnection, UFormWait, USysLoger, USysConst, USysDB;

class function TfFrameReport.FrameID: integer;
begin
  Result := cFI_FrameReport;
end;

procedure TfFrameReport.OnShowFrame;
begin
  TimerUI.Enabled := True;
end;

procedure TfFrameReport.TimerUITimer(Sender: TObject);
begin
  TimerUI.Enabled := False;
  wPage.ActivePageIndex := 0;

  FLastDevice := '';
  LoadDeviceList;

  FPageEnd := Now;
  FPageBegin := FPageEnd - (gSysParam.FReportPage / 24);;
  QueryData(False);
end;

//Desc: 构建设备列表
procedure TfFrameReport.LoadDeviceList;
var i,nIdx: Integer;
    nList: TList;
    nPort: PCOMItem;
    nDev: PDeviceItem;
begin
  nList := gDeviceManager.LockPortList;
  try
    for i:=0 to nList.Count - 1 do
    begin
      nPort := nList[i];
      //xxxxx

      for nIdx:=0 to nPort.FDevices.Count - 1 do
      begin
        nDev := nPort.FDevices[nIdx];
        if not nDev.FDeviceUsed then Continue;

        with EditDevice.Properties.Items.Add do
        begin
          Description := nDev.FCarriage.FName;
          Tag := Integer(nDev);
          EditDevice.States[EditDevice.Properties.Items.Count-1] := cbsUnchecked;
        end;
      end;
    end;
  finally
    gDeviceManager.ReleaseLock;
  end;
end;

//Desc: 设备ID列表,用于SQL in()查询
function TfFrameReport.BuildDeviceIDList: string;
var nIdx: Integer;
    nDev: PDeviceItem;
begin
  Result := '';

  for nIdx:=0 to EditDevice.Properties.Items.Count - 1 do
  if EditDevice.States[nIdx] = cbsChecked then
  begin
    nDev := Pointer(EditDevice.Properties.Items[nIdx].Tag);
    if Trim(nDev.FCarriageID) = '' then Continue;

    if Result = '' then
         Result := Format('''%s''', [nDev.FCarriageID])
    else Result := Result + Format(',''%s''', [nDev.FCarriageID]);
  end;
end;

//Date: 2013-3-18
//Parm: 时间
//Desc: 查询nData前3小时数据
procedure TfFrameReport.QueryData(const nQuery: Boolean);
var nStr,nSQL,nDevs: string;
    nInit: Int64;
begin
  if FPageEnd > Now() then
  begin
    FPageEnd := Now();
    FPageBegin := FPageEnd - (gSysParam.FReportPage / 24);
  end;

  EditTime.Date := FPageEnd;
  if not nQuery then Exit;

  nDevs := BuildDeviceIDList;
  if nDevs = '' then Exit;
  //not device
  
  nInit := GetTickCount;
  try
    ShowWaitForm(ParentForm, '读取数据', True);
    LockWindowUpdate(Handle);

    nStr := 'Select a.*,C_Name From %s a ' +
            ' Left Join %s On C_ID=P_Carriage ' +
            'Where C_ID In (%s) and (P_Date>=''%s'' and P_Date<=''%s'')';
    //xxxxx
  
    nSQL := Format(nStr, [sTable_BreakPipe, sTable_Carriage, nDevs,
            DateTime2Str(FPageBegin), DateTime2Str(FPageEnd)]);
    FDM.QueryData(QueryBreakPipe, nSQL);
    AddChartItem(itBreakPipe, True);

    nSQL := Format(nStr, [sTable_BreakPot, sTable_Carriage, nDevs,
            DateTime2Str(FPageBegin), DateTime2Str(FPageEnd)]);
    FDM.QueryData(QueryBreakPot, nSQL);
    AddChartItem(itBreakPot);

    nSQL := Format(nStr, [sTable_TotalPipe, sTable_Carriage, nDevs,
            DateTime2Str(FPageBegin), DateTime2Str(FPageEnd)]);
    FDM.QueryData(QueryTotalPipe, nSQL);
    AddChartItem(itTotalPipe);
  finally
    Application.ProcessMessages;
    LockWindowUpdate(0);

    if GetTickCount - nInit < 500 then
      Sleep(500);
    CloseWaitForm;
  end;
end;

//Date: 2013-3-18
//Parm: 类型
//Desc: 添加nType类型曲线到Chart
procedure TfFrameReport.AddChartItem(const nType: TItemType; nInit: Boolean);
var nStr: string;
    nIdx: Integer;
    nDS: TDataSet;
    nSeries: TFastLineSeries;
begin
  if nInit then
  begin
    for nIdx:=Chart1.SeriesCount - 1 downto 0 do
      Chart1.RemoveSeries(Chart1.Series[nIdx]);
    //clear
  end;

  case nType of
   itBreakPipe:
    begin
      if not CheckBreakPipe.Checked then Exit;
      nStr := sBreakPipe;
      nDS := QueryBreakPipe;
    end;
   itBreakPot:
    begin
      if not CheckBreakPot.Checked then Exit;
      nDS := QueryBreakPot;
      nStr := sBreakPot;
    end;
   itTotalPipe:
    begin
      if not CheckTotalPipe.Checked then Exit;
      nStr := sTotalPipe;
      nDS := QueryTotalPipe;
    end else Exit;
  end;
  
  nSeries := TFastLineSeries.Create(Chart1);
  nSeries.Title := nStr;
  nSeries.Tag := Ord(nType);
  Chart1.AddSeries(nSeries);

  nDS.First;
  while not nDS.Eof do
  begin
    nSeries.AddY(nDS.FieldByName('P_Value').AsFloat,
                 Time2Str(nDS.FieldByName('P_Date').AsDateTime));
    nDS.Next;
  end;
end;

//Desc: 选择曲线
procedure TfFrameReport.CheckBreakPipeClick(Sender: TObject);
var nIdx: Integer;
    nType: TItemType;
begin
  case (Sender as TComponent).Tag of
   10: nType := itBreakPipe;
   20: nType := itBreakPot;
   30: nType := itTotalPipe else Exit;
  end;

  if (Sender as TcxCheckBox).Checked then
  begin
    AddChartItem(nType);
  end else
  begin
    for nIdx:=Chart1.SeriesCount - 1 downto 0 do
     if Chart1.Series[nIdx].Tag = Ord(nType) then
      Chart1.RemoveSeries(Chart1.Series[nIdx]);
    //remove fixed
  end;
end;

//Desc: 上一页
procedure TfFrameReport.BtnPreClick(Sender: TObject);
begin
  FPageEnd := FPageBegin;
  FPageBegin := FPageEnd - (gSysParam.FReportPage / 24);
  QueryData;
end;

//Desc: 下一页
procedure TfFrameReport.BtnNextClick(Sender: TObject);
begin
  FPageBegin := FPageEnd;
  FPageEnd := FPageBegin + (gSysParam.FReportPage / 24);
  QueryData;
end;

//Desc: 手动填写时间
procedure TfFrameReport.EditTimePropertiesEditValueChanged(Sender: TObject);
begin
  if EditTime.IsFocused then
  begin
    FPageEnd := EditTime.Date;
    if FPageEnd < 0 then Exit;
    
    FPageBegin := FPageEnd - (gSysParam.FReportPage / 24);
    QueryData;
  end;
end;

//Desc: 接受内容
procedure TfFrameReport.EditTimeKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditTimePropertiesEditValueChanged(nil);
  end;
end;

//Desc: 设备控制
procedure TfFrameReport.EditCheckPropertiesChange(Sender: TObject);
var nIdx: Integer;
begin
  for nIdx:=EditDevice.Properties.Items.Count - 1 downto 0 do
  begin
    case EditCheck.ItemIndex of
     0: EditDevice.States[nIdx] := cbsChecked;
     1: EditDevice.States[nIdx] := cbsUnchecked;
     2:
      if EditDevice.States[nIdx] = cbsChecked then
           EditDevice.States[nIdx] := cbsUnchecked
      else EditDevice.States[nIdx] := cbsChecked;
    end;
  end;

  EditDevicePropertiesCloseUp(nil);
  //do query
end;

//Desc: 应用查询条件
procedure TfFrameReport.EditDevicePropertiesCloseUp(Sender: TObject);
var nStr: string;
begin
  nStr := BuildDeviceIDList;
  if nStr = FLastDevice then Exit;
  FLastDevice := nStr;
  
  if not EditCheck.Focused then
    EditCheck.ItemIndex := -1;
  QueryData();
end;

initialization
  gControlManager.RegCtrl(TfFrameReport, TfFrameReport.FrameID);
end.
