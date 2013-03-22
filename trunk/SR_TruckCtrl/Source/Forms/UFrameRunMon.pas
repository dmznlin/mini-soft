{*******************************************************************************
  作者: dmzn@163.com 2013-3-18
  描述: 运行时监控
*******************************************************************************}
unit UFrameRunMon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  USysProtocol, Series, UFrameBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ImgList, ExtCtrls,
  cxSplitter, cxCheckListBox, cxCheckBox, TeeProcs, TeEngine, Chart,
  cxLabel;

type
  TfFrameRunMon = class(TfFrameBase)
    TimerStart: TTimer;
    ImageList1: TImageList;
    PanelLeft: TPanel;
    PanelRight: TPanel;
    ListDevice: TcxCheckListBox;
    cxLabel1: TcxLabel;
    LabelHint: TcxLabel;
    TimerUI: TTimer;
    Chart1: TChart;
    CheckBreakPot: TcxCheckBox;
    CheckBreakPipe: TcxCheckBox;
    CheckTotalPipe: TcxCheckBox;
    cxSplitter1: TcxSplitter;
    procedure TimerStartTimer(Sender: TObject);
    procedure TimerUITimer(Sender: TObject);
    procedure CheckBreakPipeClick(Sender: TObject);
    procedure ListDeviceClick(Sender: TObject);
  protected
    { Protected declarations }
    FDataList: TList;
    procedure OnShowFrame; override;
    procedure OnDestroyFrame; override;
    procedure BuildDeviceList;
    //ui data
    procedure InitDataItem(const nData: Pointer; const nType: TItemType;
     const nSeries: TComponent; const nDev: PDeviceItem);
    procedure AddDataItem(const nDevice: PDeviceItem; const nType: TItemType);
    procedure RemoveDataItem(const nSeries: TObject);
    //数据处理
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  UMgrControl, ULibFun, UMgrConnection, USysConst;

type
  PDataItem = ^TDataItem;
  TDataItem = record
    FItemType: TItemType;
    FLastScan: Int64;
    FSeries: TComponent;
    FDevice: PDeviceItem;
  end;

const
  cImage_Checked  = 0;
  cImage_UnCheck  = 1;

class function TfFrameRunMon.FrameID: integer;
begin
  Result := cFI_FrameRunMon;
end;

procedure TfFrameRunMon.OnShowFrame;
begin
  FDataList := TList.Create;
  TimerStart.Enabled := True;
end;

procedure TfFrameRunMon.OnDestroyFrame;
var nIdx: Integer;
begin
  for nIdx:=FDataList.Count - 1 downto 0 do
  begin
    Dispose(PDataItem(FDataList[nIdx]));
    FDataList.Delete(nIdx);
  end;

  FreeAndNil(FDataList);
end;

//Desc: 延时启动
procedure TfFrameRunMon.TimerStartTimer(Sender: TObject);
begin
  TimerStart.Enabled := False;
  BuildDeviceList;
end;

//------------------------------------------------------------------------------
//Desc: 构建设备列表
procedure TfFrameRunMon.BuildDeviceList;
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
          ImageIndex := cImage_UnCheck;
          Tag := Integer(nDev);
        end;
      end;
    end;
  finally
    gDeviceManager.ReleaseLock;
  end;
end;

//Date: 2013-3-18
//Parm: 数据;节点类型;对象
//Desc: 初始化数据项
procedure TfFrameRunMon.InitDataItem(const nData: Pointer; const nType: TItemType;
  const nSeries: TComponent; const nDev: PDeviceItem);
var nP: PDataItem;
begin
  nP := nData;
  FillChar(nP^, SizeOf(TDataItem), #0);

  nP.FItemType := nType;
  nP.FSeries := nSeries;
  nP.FDevice := nDev;
end;

//Date: 2013-3-18
//Parm: 设备;类型
//Desc: 添加一个nDevice.nType的图标
procedure TfFrameRunMon.AddDataItem(const nDevice: PDeviceItem;
  const nType: TItemType);
var nStr: string;
    nData: PDataItem;
    nSeries: TFastLineSeries;
begin
  case nType of
   itBreakPipe : nStr := Format('%s:%s', [nDevice.FCarriage.FName, sBreakPipe]);
   itBreakPot  : nStr := Format('%s:%s', [nDevice.FCarriage.FName, sBreakPot]);
   itTotalPipe : nStr := Format('%s:%s', [nDevice.FCarriage.FName, sTotalPipe]);
  end;

  nSeries := TFastLineSeries.Create(Chart1);
  nSeries.Title := nStr;
  Chart1.AddSeries(nSeries);

  New(nData);
  nSeries.Tag := FDataList.Add(nData);
  InitDataItem(nData, nType, nSeries, nDevice);
end;

//Date: 2013-3-18
//Parm: 对象
//Desc: 删除nSeries对象的数据节点
procedure TfFrameRunMon.RemoveDataItem(const nSeries: TObject);
var nIdx: Integer;
    nData: PDataItem;
begin
  for nIdx:=FDataList.Count - 1 downto 0 do
  begin
    nData := FDataList[nIdx];
    if nData.FSeries <> nSeries then Continue;

    Dispose(nData);
    FDataList.Delete(nIdx);
  end;

  for nIdx:=FDataList.Count - 1 downto 0 do
  begin
    nData := FDataList[nIdx];
    nData.FSeries.Tag := nIdx;
  end; //adjust index
end;

//Desc: 单击选择
procedure TfFrameRunMon.ListDeviceClick(Sender: TObject);
var nPos: TPoint;
    nIdx: Integer;
    nData: PDataItem;
    nDev: PDeviceItem;
begin
  GetCursorPos(nPos);
  nPos := ListDevice.ScreenToClient(nPos);

  nIdx := ListDevice.ItemAtPos(nPos, True);
  if nIdx < 0 then Exit;

  if ListDevice.Items[nIdx].ImageIndex = cImage_Checked then
       ListDevice.Items[nIdx].ImageIndex := cImage_UnCheck
  else ListDevice.Items[nIdx].ImageIndex := cImage_Checked;

  nDev := Pointer(ListDevice.Items[nIdx].Tag);
  if ListDevice.Items[nIdx].ImageIndex = cImage_Checked then
  begin
    if CheckBreakPipe.Checked then
    begin
      AddDataItem(nDev, itBreakPipe);
    end;

    if CheckBreakPot.Checked then
    begin
      AddDataItem(nDev, itBreakPot);
    end;

    if CheckTotalPipe.Checked then
    begin
      AddDataItem(nDev, itTotalPipe);
    end;
  end else
  begin
    for nIdx:=Chart1.SeriesCount - 1 downto 0 do
    begin
      nData := FDataList[Chart1.Series[nIdx].Tag];
      //data

      if nData.FDevice = nDev then
      begin
        RemoveDataItem(Chart1.Series[nIdx]);
        Chart1.RemoveSeries(Chart1.Series[nIdx]);
      end;
    end;
  end;

  TimerUI.Enabled := Chart1.SeriesCount > 0;
  //ui enable
end;

//Desc: 显示项选择
procedure TfFrameRunMon.CheckBreakPipeClick(Sender: TObject);
var nIdx: Integer;
    nType: TItemType;
    nData: PDataItem;
    nDev: PDeviceItem;
begin
  case (Sender as TComponent).Tag of
   10: nType := itBreakPipe;
   20: nType := itBreakPot;
   30: nType := itTotalPipe else Exit;
  end;

  if (Sender as TcxCheckBox).Checked then
  begin
    for nIdx:=0 to ListDevice.Items.Count - 1 do
    if ListDevice.Items[nIdx].ImageIndex = cImage_Checked then
    begin
      nDev := Pointer(ListDevice.Items[nIdx].Tag);
      AddDataItem(nDev, nType);
    end;
  end else
  begin
    for nIdx:=Chart1.SeriesCount - 1 downto 0 do
    begin
      nData := FDataList[Chart1.Series[nIdx].Tag];
      //data

      if nData.FItemType = nType then
      begin
        RemoveDataItem(Chart1.Series[nIdx]);
        Chart1.RemoveSeries(Chart1.Series[nIdx]);
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2013-3-18
//Parm: 对象;数据;个数
//Desc: 为nSeries添加nData数据
procedure AddSeriesData(const nSeries: TFastLineSeries;
 const nData: array of TDeviceData; const nNum: Word);
var nIdx: Integer;
begin
  for nIdx:=Low(nData) to nNum - 1 do
    nSeries.AddY(nData[nIdx].FData, Time2Str(Now));
  //xxxxx

  if nSeries.YValues.Count > gSysParam.FChartCount then
  begin
    for nIdx:=nSeries.YValues.Count - gSysParam.FChartCount downto 0 do
      nSeries.Delete(0);
    //remove old value
  end;
end;

//Desc: 刷新曲线
procedure TfFrameRunMon.TimerUITimer(Sender: TObject);
var nIdx: integer;
    nData: PDataItem;
    nSeries: TFastLineSeries;
    nArray: array[0..0] of TDeviceData;
begin
  for nIdx:=Chart1.SeriesCount - 1 downto 0 do
  begin
    nSeries := Chart1.Series[nIdx] as TFastLineSeries;
    nData := FDataList[nSeries.Tag];

    if nData.FLastScan = nData.FDevice.FLastActive then Exit;
    //未更新
    nData.FLastScan := nData.FDevice.FLastActive;

    case nData.FItemType of
     itBreakPipe:
      begin
        AddSeriesData(nSeries, nData.FDevice.FBreakPipe,
                               nData.FDevice.FBreakPipeNum);
      end;
     itBreakPot:
      begin
        AddSeriesData(nSeries, nData.FDevice.FBreakPot,
                               nData.FDevice.FBreakPotNum);
      end;
     itTotalPipe:
      begin
        nArray[0].FData := nData.FDevice.FTotalPipe;
        AddSeriesData(nSeries, nArray, 1);
      end;
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameRunMon, TfFrameRunMon.FrameID);
end.
