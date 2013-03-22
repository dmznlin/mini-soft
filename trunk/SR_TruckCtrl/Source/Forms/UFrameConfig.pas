{*******************************************************************************
  作者: dmzn@163.com 2013-3-7
  描述: 实时监控
*******************************************************************************}
unit UFrameConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, StdCtrls, dxorgchr, ExtCtrls;

type
  TfFrameConfig = class(TfFrameBase)
    DeviceList: TdxOrgChart;
    wPanel: TPanel;
    Bevel1: TBevel;
    procedure DeviceListDeletion(Sender: TObject; Node: TdxOcNode);
    procedure DeviceListChange(Sender: TObject; Node: TdxOcNode);
    procedure DeviceListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure DeviceListEndDrag(Sender, Target: TObject; X, Y: Integer);
  protected
    { Protected declarations }
    FExpandList: TStrings;
    //展开节点
    FOldParent: TdxOcNode;
    //原上节点
    procedure OnShowFrame; override;
    procedure OnDestroyFrame; override;
    procedure LoadDeviceList;
    //载入设备
    procedure LoadCOMPorts(const nRoot: TdxOcNode);
    procedure LoadDevices(const nRoot: TdxOcNode; const nList: TList;
     const nUsed: Boolean);
    //载入数据
  public
    { Public declarations }
    class function FrameID: integer; override;
    function DealCommand(Sender: TObject; const nCmd: integer;
      const nParamA: Pointer; const nParamB: Integer): integer; override;
    //deal method
  end;

implementation

{$R *.dfm}

uses
  UMgrControl, ULibFun, UMgrConnection, UMgrOrgChartStyle, UDataModule,
  UFormCtrl, USysProtocol, USysConst, USysDB;

type
  PNodeData = ^TNodeData;
  TNodeData = record
    FType: TItemFlag;
    FCOM: PCOMParam;
    FDevice: PDeviceItem;
  end;

class function TfFrameConfig.FrameID: integer;
begin
  Result := cFI_FrameConfig;
end;

procedure TfFrameConfig.OnShowFrame;
begin
  inherited;
  FExpandList := TStringList.Create;
  gChartStyleManager.LoadConfig(gPath + sStyleConfig);
  gChartStyleManager.LoadChartStyle(sStyleDevList, DeviceList);

  LoadDeviceList;
  DeviceList.FullExpand;
  CreateBaseFrameItem(cFI_FrameSetSystem, wPanel);
end;

procedure TfFrameConfig.OnDestroyFrame;
begin
  inherited;
  FExpandList.Free;
end;

function TfFrameConfig.DealCommand(Sender: TObject; const nCmd: integer;
  const nParamA: Pointer; const nParamB: Integer): integer;
begin
  Result := S_OK;

  if nCmd = cCmd_RefreshDevList then
    LoadDeviceList;
  //refresh
end;

procedure TfFrameConfig.DeviceListDeletion(Sender: TObject;
  Node: TdxOcNode);
begin
  Dispose(PNodeData(Node.Data));
end;

//------------------------------------------------------------------------------
//Desc: 载入设备列表
procedure TfFrameConfig.LoadDeviceList;
var nData: PNodeData;
    nNode: TdxOcNode;
begin
  DeviceList.BeginUpdate;
  try
    FExpandList.Clear;
    nNode := DeviceList.GetFirstNode;

    while Assigned(nNode) do
    begin
      if nNode.HasChildren and nNode.Expanded then
      begin
        nData := nNode.Data;
        FExpandList.Add(IntToStr(Integer(nData.FCOM)));
      end;

      nNode := nNode.GetNext;
    end;

    DeviceList.Clear;
    //init ui

    nNode := DeviceList.Add(nil, nil);
    nNode.Text := '系统设备';

    New(nData);
    nNode.Data := nData;
    
    nData.FType := ifRoot;
    nData.FCOM := Pointer($01);
    gChartStyleManager.LoadNodeStyle(sStyleDevList, Ord(ifRoot), nNode);

    LoadCOMPorts(nNode);
    //load ports

    nNode := DeviceList.GetFirstNode;
    while Assigned(nNode) do
    begin
      if nNode.HasChildren then
      begin
        nData := nNode.Data;
        if FExpandList.IndexOf(IntToStr(Integer(nData.FCOM))) >= 0 then
          nNode.Expand(False);
        //restore
      end;

      nNode := nNode.GetNext;
    end;
  finally
    DeviceList.EndUpdate;
  end;
end;

//Desc: 载入串口列表
procedure TfFrameConfig.LoadCOMPorts(const nRoot: TdxOcNode);
var nIdx: Integer;
    nList: TList;
    nData: PNodeData;
    nNode: TdxOcNode;
    nCOM: PCOMItem;
    nDev: PDeviceItem;
begin
  nList := gDeviceManager.LockPortList;
  try
    for nIdx:=0 to nList.Count - 1 do
    begin
      nCOM := nList[nIdx];
      if not nCOM.FParam.FCOMValid then Continue;

      nNode := DeviceList.AddChild(nRoot, nil);
      nNode.Text := nCOM.FParam.FName;

      New(nData);
      nNode.Data := nData;
      
      nData.FType := ifPort;
      nData.FCOM := nCOM.FParam;
      gChartStyleManager.LoadNodeStyle(sStyleDevList, Ord(ifPort), nNode);

      LoadDevices(nNode, nCOM.FDevices, True);
      //load sub
    end;

    gDeviceManager.ReleaseLock;
    nList := gDeviceManager.LockDeviceList;

    for nIdx:=nList.Count - 1 downto 0 do
    begin
      nDev := nList[nIdx];
      if nDev.FDeviceUsed or (not nDev.FDeviceValid) then Continue;

      nNode := DeviceList.AddChild(nRoot, nil);
      nNode.Text := '无效设备';

      New(nData);
      nNode.Data := nData;

      nData.FType := ifDeviceUnusedRoot;
      nData.FCOM := Pointer($02);
      gChartStyleManager.LoadNodeStyle(sStyleDevList, Ord(ifPort), nNode);

      LoadDevices(nNode, nList, False);
      Break;
    end;
  finally
    gDeviceManager.ReleaseLock;
  end;   
end;

//Desc: 载入设备列表
procedure TfFrameConfig.LoadDevices(const nRoot: TdxOcNode;
  const nList: TList; const nUsed: Boolean);
var nIdx: Integer;
    nD: PDeviceItem;
    nData: PNodeData;
    nNode: TdxOcNode;
begin
  for nIdx:=0 to nList.Count - 1 do
  begin
    nD := nList[nIdx];
    if nUsed then
    begin
      if not (nD.FDeviceUsed and nD.FDeviceValid) then Continue;
      //invalid

      nNode := DeviceList.AddChild(nRoot, nil);
      nNode.Text := nD.FCarriage.FName;

      New(nData);
      nNode.Data := nData;

      nData.FType := ifDevice;
      nData.FCOM := PNodeData(nRoot.Data).FCOM;
      nData.FDevice := nD;
      
      gChartStyleManager.LoadNodeStyle(sStyleDevList, Ord(ifDevice), nNode);
    end else
    begin
      if nD.FDeviceUsed then Continue;
      //invalid

      nNode := DeviceList.AddChild(nRoot, nil);
      nNode.Text := Format('%s-%d', [nD.FCOMPort, nD.FIndex]);

      New(nData);
      nNode.Data := nData;
      
      nData.FType := ifDeviceUnused;
      nData.FDevice := nD;
      gChartStyleManager.LoadNodeStyle(sStyleDevList, Ord(ifDevice), nNode);
    end;
  end;
end;

procedure TfFrameConfig.DeviceListChange(Sender: TObject; Node: TdxOcNode);
var nData: PNodeData;
begin
  if Assigned(Node) and Assigned(Node.Data) then
  begin
    if Assigned(DeviceList.Selected) and (DeviceList.Selected.Level > 0) then
         FOldParent := DeviceList.Selected.Parent
    else FOldParent := nil;

    nData := Node.Data;
    //xxxxx
    
    case nData.FType of
     ifRoot: CreateBaseFrameItem(cFI_FrameSetSystem, wPanel);
     ifPort: CreateBaseFrameItem(cFI_FrameSetPort, wPanel);
     ifDevice,ifDeviceUnused: CreateBaseFrameItem(cFI_FrameSetDevice, wPanel);
    end;

    case nData.FType of
     ifPort: BroadcastFrameCommand(Self, cCmd_ViewPortData, nData.FCOM);
     ifDevice,
     ifDeviceUnused: BroadcastFrameCommand(Self, cCmd_ViewDeviceData,
      nData.FCOM, Integer(nData.FDevice));
    end; //update ui data

    wPanel.Invalidate;
  end;
end;

procedure TfFrameConfig.DeviceListDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var nNode: TdxOcNode;
begin
  Accept := Assigned(FOldParent);
  if not Accept then Exit;

  nNode := DeviceList.GetNodeAt(X, Y);
  if not Assigned(nNode) then Exit;

  Accept := (nNode.Level = DeviceList.Selected.Level) or
            (nNode.Level = FOldParent.Level);
  //同级或上级
end;

procedure TfFrameConfig.DeviceListEndDrag(Sender, Target: TObject; X,
  Y: Integer);
var nStr: string;
    nIdx: Integer;
    nNode: TdxOcNode;
    nData,nP: PNodeData;
begin
  if (not Assigned(DeviceList.Selected)) or
     (DeviceList.Selected.Level < 1) then Exit;
  if DeviceList.Selected.Parent.Level <> FOldParent.Level then Exit;
  //invalid parent

  nData := DeviceList.Selected.Data;
  nP := DeviceList.Selected.Parent.Data;

  if nP.FType = ifPort then
  begin
    nData.FCOM := nP.FCOM;
    nStr := Format('D_ID=''%s''', [nData.FDevice.FItemID]);

    nStr := MakeSQLByStr([SF('D_Port', nP.FCOM.FPortName)], sTable_Device,
     nStr, False);
    FDM.ExecuteSQL(nStr);
  end else

  if nP.FType = ifDeviceUnusedRoot then
  begin
    nData.FType := ifDeviceUnused;
    nStr := Format('D_ID=''%s''', [nData.FDevice.FItemID]);

    nStr := MakeSQLByStr([SF('D_Port', '')], sTable_Device, nStr, False);
    FDM.ExecuteSQL(nStr);
  end;

  nIdx := 0;
  nNode := DeviceList.GetFirstNode;

  while Assigned(nNode) do
  begin
    nData := nNode.Data;
    if nData.FType = ifPort then
    begin
      nStr := Format('C_ID=''%s''', [nData.FCOM.FItemID]);
      nStr := MakeSQLByStr([SF('C_Position', nIdx, sfVal)], sTable_Port,
              nStr, False);
      //xxxxx

      FDM.ExecuteSQL(nStr);
      Inc(nIdx);
    end else

    if nData.FType = ifDevice then
    begin
      nStr := Format('C_ID=''%s''', [nData.FDevice.FCarriageID]);
      nStr := MakeSQLByStr([SF('C_Position', nIdx, sfVal)], sTable_Carriage,
              nStr, False);
      //xxxxx

      FDM.ExecuteSQL(nStr);
      Inc(nIdx);
    end;

    nNode := nNode.GetNext;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameConfig, TfFrameConfig.FrameID);
end.
