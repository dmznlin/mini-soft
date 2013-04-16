{*******************************************************************************
  作者: dmzn@163.com 2013-3-7
  描述: 实时监控
*******************************************************************************}
unit UFrameRealTime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  CPort, USysProtocol, dxStatusBar, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ImgList, ExtCtrls,
  cxCheckListBox, cxLabel, Voltmeter, UFrameBase, cxGraphics;

type
  TfFrameRealTimeMon = class(TfFrameBase)
    TimerStart: TTimer;
    ImageList1: TImageList;
    PanelLeft: TPanel;
    PanelRight: TPanel;
    ListDevice: TcxCheckListBox;
    cxLabel1: TcxLabel;
    LabelHint: TcxLabel;
    TimerUI: TTimer;
    VBreakPipe: TVoltmeter;
    VBreakPot: TVoltmeter;
    VTotalPipe: TVoltmeter;
    procedure TimerStartTimer(Sender: TObject);
    procedure TimerUITimer(Sender: TObject);
    procedure PanelLeftResize(Sender: TObject);
  protected
    { Protected declarations }
    FActiveItem: Integer;
    //active index
    FPanel: TdxStatusBarStateIndicatorPanelStyle;
    //status panel
    procedure OnShowFrame; override;
    procedure LoadSystemConfig;
    procedure LoadDeviceConfig;
    //load data
    procedure BuildDeviceList;
    procedure RefreshDeviceStatus;
    //ui data
    procedure OnData(const nData: PDeviceItem);
    //to write db
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  UMgrControl, ULibFun, UDataModule, UMgrDBConn, UMgrConnection, UFormCtrl,
  USysLoger, USysConst, USysDB;

procedure WriteLog(const nMsg: string);
begin
  gSysLoger.AddLog(TfFrameRealTimeMon, '', nMsg);
end;

class function TfFrameRealTimeMon.FrameID: integer;
begin
  Result := cFI_FrameRealTime;
end;

procedure TfFrameRealTimeMon.OnShowFrame;
begin
  FPanel := TdxStatusBarStateIndicatorPanelStyle(gStatusBar.Panels[2].PanelStyle);
  FActiveItem := -1;
  TimerStart.Enabled := True;
end;

//Desc: 延时启动
procedure TfFrameRealTimeMon.TimerStartTimer(Sender: TObject);
begin
  TimerStart.Enabled := False;
  ActionDBConfig(True);

  if CheckDBConnection then
  begin
    gDBConnManager.AddParam(gDBPram);
    //enable param
    
    LoadSystemConfig;
    LoadDeviceConfig;
    BuildDeviceList;
  end;
end;

//Desc: 调整表盘位置
procedure TfFrameRealTimeMon.PanelLeftResize(Sender: TObject);
const
  cInterval = 20;
var
  nL,nT,nInt: Integer;
begin
  nInt := Trunc(PanelLeft.ClientWidth / 2);
  nT := VBreakPipe.Width + VBreakPot.Width + cInterval;
  nL := nInt - Trunc(nT / 2);

  VBreakPipe.Left := nL;
  VBreakPot.Left := nL + VBreakPipe.Width + cInterval;
  VTotalPipe.Left := nInt - Trunc(VTotalPipe.Width / 2);

  nInt := Trunc((PanelLeft.ClientHeight - LabelHint.Height) / 2);
  nL := VBreakPipe.Height + VTotalPipe.Height + cInterval;
  nT := LabelHint.Height + nInt - Trunc(nL / 2);

  VBreakPipe.Top := nT;
  VBreakPot.Top := nT;
  VTotalPipe.Top := nT + VBreakPipe.Height + cInterval;
end;

//Desc: 载入系统参数
procedure TfFrameRealTimeMon.LoadSystemConfig;
var nStr: string;
begin
  with gSysParam do
  begin
    FTrainID    := 'id';
    FPrintSend  := False;
    FPrintRecv  := False;

    FQInterval  := 1000;
    FCollectTM  := 20;
    FResetTime  := 0;
    
    FUIInterval := 20;
    FUIMaxValue := 600;
    FReportPage := 3;

    FChartCount := 5000;
    FChartTime := 10;
  end;

  nStr := 'Select * From %s';
  nStr := Format(nStr, [sTable_SysDict]);

  with FDM.QueryTemp(nStr), gSysParam do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := FieldByName('D_Name').AsString;
      if CompareText(sFlag_TrainID, nStr) = 0 then
        FTrainID := FieldByName('D_Value').AsString;
      //xxxxx

      if CompareText(sFlag_QInterval, nStr) = 0 then
        FQInterval := FieldByName('D_Value').AsInteger;
      //xxxxx

      if CompareText(sFlag_CollectTime, nStr) = 0 then
        FCollectTM := FieldByName('D_Value').AsInteger;
      //xxxxx

      if CompareText(sFlag_ResetTime, nStr) = 0 then
        FResetTime := FieldByName('D_Value').AsInteger;
      //xxxxx

      if CompareText(sFlag_PrintSend, nStr) = 0 then
        FPrintSend := FieldByName('D_Value').AsString = sFlag_Yes;
      //xxxxx

      if CompareText(sFlag_PrintRecv, nStr) = 0 then
        FPrintRecv := FieldByName('D_Value').AsString = sFlag_Yes;
      //xxxxx

      if CompareText(sFlag_UIInterval, nStr) = 0 then
        FUIInterval := FieldByName('D_Value').AsInteger;
      //xxxxx

      if CompareText(sFlag_UIMaxValue, nStr) = 0 then
        FUIMaxValue := FieldByName('D_Value').AsFloat;
      //xxxxx

      if CompareText(sFlag_ChartCount, nStr) = 0 then
        FChartCount := FieldByName('D_Value').AsInteger;
      //xxxxx

      if CompareText(sFlag_ChartTime, nStr) = 0 then
        FChartTime := FieldByName('D_Value').AsInteger;
      //xxxxx

      if CompareText(sFlag_ReportPage, nStr) = 0 then
        FReportPage := FieldByName('D_Value').AsInteger;
      //xxxxx

      Next;
    end;
  end;
end;

//Desc: 载入配置信息
procedure TfFrameRealTimeMon.LoadDeviceConfig;
var nStr: string;
    nPort: TCOMParam;
    nDev: TDeviceItem;
    nCar: TCarriageItem;
begin
  nStr := 'Select * From %s';
  nStr := Format(nStr, [sTable_Port]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    FillChar(nPort, SizeOf(nPort), #0);
    First;

    while not Eof do
    with nPort do
    begin
      FItemID := FieldByName('C_ID').AsString;
      FName := FieldByName('C_Name').AsString;
      FPostion := FieldByName('C_Position').AsInteger;

      FPortName := FieldByName('C_Port').AsString;
      FBaudRate := StrToBaudRate(FieldByName('C_Baund').AsString);
      FDataBits := StrToDataBits(FieldByName('C_DataBits').AsString);
      FStopBits := StrToStopBits(FieldByName('C_StopBits').AsString);

      gDeviceManager.AddParam(nPort);
      Next;
    end;
  end;

  nStr := 'Select * From %s';
  nStr := Format(nStr, [sTable_Device]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    FillChar(nDev, SizeOf(nDev), #0);
    First;

    while not Eof do
    with nDev do
    begin
      FItemID := FieldByName('D_ID').AsString;
      FCOMPort := FieldByName('D_Port').AsString;

      FIndex := FieldByName('D_Index').AsInteger;
      FSerial := FieldByName('D_Serial').AsString;
      FCarriageID := FieldByName('D_Carriage').AsString;

      FColorBreakPipe := FieldByName('D_clBreakPipe').AsInteger;
      FColorBreakPot := FieldByName('D_clBreakPot').AsInteger;
      FColorTotalPipe := FieldByName('D_clTotalPot').AsInteger;

      gDeviceManager.AddDevice(nDev);
      Next;
    end;
  end;

  nStr := 'Select * From %s';
  nStr := Format(nStr, [sTable_Carriage]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    FillChar(nCar, SizeOf(nCar), #0);
    First;

    while not Eof do
    with nCar do
    begin
      FItemID := FieldByName('C_ID').AsString;
      FName := FieldByName('C_Name').AsString;
      FPostion := FieldByName('C_Position').AsInteger;

      FTypeID := FieldByName('C_TypeID').AsInteger;
      FTypeName := FieldByName('C_TypeName').AsString;
      FModeID := FieldByName('C_ModeID').AsInteger;
      FModeName := FieldByName('C_ModeName').AsString;

      gDeviceManager.AddCarriage(nCar);
      Next;
    end;
  end;

  gDeviceManager.AdjustDevice;
  //adjust all

  gPortManager.OnData := OnData;
  if gSysParam.FAutoMin then
    gPortManager.StartReader;
  //启动服务
end;

//Desc: 构建设备列表
procedure TfFrameRealTimeMon.BuildDeviceList;
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

        with ListDevice.Items.Add do
        begin
          Text := nDev.FCarriage.FName;
          ImageIndex := 0;
          Tag := Integer(nDev);
        end;

        FPanel.Indicators.Add.IndicatorType := sitRed;
        //default status
      end;
    end;

    if ListDevice.Items.Count > 0 then
    begin
      ListDevice.ItemIndex := 0;
      TimerUI.Tag := ListDevice.Items[0].Tag;
      TimerUI.Enabled := True;

      VTotalPipe.MaxValue := gSysParam.FUIMaxValue;
      VTotalPipe.Visible := True;

      VBreakPipe.MaxValue := gSysParam.FUIMaxValue;
      VBreakPipe.Visible := True;

      VBreakPot.MaxValue := gSysParam.FUIMaxValue;
      VBreakPot.Visible := True;
    end;
  finally
    gDeviceManager.ReleaseLock;
  end;
end;

//Date: 2013-3-15
//Parm: 数据;个数
//Desc: 在nData中检索最大值
function GetMaxData(const nData: array of TDeviceData; const nNum: Word): Word;
var nIdx: Integer;
begin
  Result := 0;

  for nIdx:=0 to nNum - 1 do
  if nData[nIdx].FData > Result then
  begin
    Result := nData[nIdx].FData;
  end;
end;

//Desc: 刷新数据
procedure TfFrameRealTimeMon.TimerUITimer(Sender: TObject);
var nDev: PDeviceItem;
begin
  if ListDevice.ItemIndex <> FActiveItem then
  begin
    FActiveItem := ListDevice.ItemIndex;
    TimerUI.Tag := ListDevice.Items[FActiveItem].Tag;

    nDev := Pointer(TimerUI.Tag);
    LabelHint.Caption := '设备监测数据: ' + nDev.FCarriage.FName;
  end else nDev := Pointer(TimerUI.Tag);

  VTotalPipe.Value := nDev.FTotalPipe;
  VBreakPipe.Value := GetMaxData(nDev.FBreakPipe, nDev.FBreakPipeNum);
  VBreakPot.Value := GetMaxData(nDev.FBreakPot, nDev.FBreakPotNum);

  RefreshDeviceStatus;
  //update device status
end;

//Desc: 在状态栏构建设备状态指示
procedure TfFrameRealTimeMon.RefreshDeviceStatus;
var nIdx: Integer;
    nList: TList;
    nPort: PCOMParam;
    nDev: PDeviceItem;
begin
  for nIdx:=ListDevice.Count - 1 downto 0 do
  begin
    nDev := Pointer(ListDevice.Items[nIdx].Tag);
    if GetTickCount - nDev.FLastActive > 3 * gSysParam.FQInterval then
    begin
      if FPanel.Indicators[nIdx].IndicatorType <> sitRed then
        WriteLog(Format('设备[%s:%d]离线', [nDev.FCOMPort, nDev.FIndex]));
      //loged

      FPanel.Indicators[nIdx].IndicatorType := sitRed;
      ListDevice.Items[nIdx].ImageIndex := 0;
    end else
    begin
      FPanel.Indicators[nIdx].IndicatorType := sitGreen;
      ListDevice.Items[nIdx].ImageIndex := 1;
    end;
  end;

  nList := gDeviceManager.LockPortList;
  try
    for nIdx:=nList.Count - 1 downto 0 do
    begin
      nPort := PCOMItem(nList[nIdx]).FParam;
      if (nPort.FLastActive > 0) and
         (GetTickCount - nPort.FLastActive > 2 * gSysParam.FQInterval) then
      begin
        nPort.FLastActive := 0;
        WriteLog(nPort.FRunFlag);
      end;
    end;
  finally
    gDeviceManager.ReleaseLock;
  end;
end;

//Desc: 将nData写入数据库
procedure TfFrameRealTimeMon.OnData(const nData: PDeviceItem);
var nStr: string;
    nIdx: Integer;
    nDate: TDateTime;
    nDBConn: PDBWorker;
begin
  nDBConn := gDBConnManager.GetConnection(sProgID, nIdx);
  try
    if not Assigned(nDBConn) then
    begin
      gPortManager.WriteReaderLog('连接HM数据库失败(DBConn Is Null).');
      Exit;
    end;

    if not nDBConn.FConn.Connected then
      nDBConn.FConn.Connected := True;
    //conn db

    nDate := nData.FBreakPipeTimeBase;
    //init time base

    for nIdx:=0 to nData.FBreakPipeNum - 1 do
    begin
      nStr := MakeSQLByStr([SF('P_Train', gSysParam.FTrainID),
              SF('P_Carriage', nData.FCarriageID),
              SF('P_Value', nData.FBreakPipe[nIdx].FData, sfVal),
              SF('P_Number', nData.FBreakPipe[nIdx].FNum, sfVal),
              SF('P_Date', nDate)
              ], sTable_BreakPipe, '', True);
      //xxxxx

      gDBConnManager.WorkerExec(nDBConn, nStr);
      TPortReadManager.IncTime(nDate, nData.FBreakPipe[nIdx].FNum);
    end;

    nDate := nData.FBreakPotTimeBase;
    //init time base

    for nIdx:=0 to nData.FBreakPotNum - 1 do
    begin
      nStr := MakeSQLByStr([SF('P_Train', gSysParam.FTrainID),
              SF('P_Carriage', nData.FCarriageID),
              SF('P_Value', nData.FBreakPot[nIdx].FData, sfVal),
              SF('P_Number', nData.FBreakPot[nIdx].FNum, sfVal),
              SF('P_Date', nDate)
              ], sTable_BreakPot, '', True);
      //xxxxx

      gDBConnManager.WorkerExec(nDBConn, nStr);
      TPortReadManager.IncTime(nDate, nData.FBreakPot[nIdx].FNum);
    end;

    nStr := MakeSQLByStr([SF('P_Train', gSysParam.FTrainID),
            SF('P_Carriage', nData.FCarriageID),
            SF('P_Value', nData.FTotalPipe, sfVal),
            SF('P_Date', nData.FTotalPipeTimeBase)
            ], sTable_TotalPipe, '', True);
    gDBConnManager.WorkerExec(nDBConn, nStr);
  finally
    gDBConnManager.ReleaseConnection(sProgID, nDBConn);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameRealTimeMon, TfFrameRealTimeMon.FrameID);
end.
