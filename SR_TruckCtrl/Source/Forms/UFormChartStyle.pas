{*******************************************************************************
  作者: dmzn@163.com 2013-3-20
  描述: 界面风格配置
*******************************************************************************}
unit UFormChartStyle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit,
  cxLabel, cxTextEdit, dxLayoutControl, StdCtrls, cxCheckBox, dxorgchr,
  cxColorComboBox, cxSpinEdit, cxImageComboBox, ExtCtrls;

type
  TfFormChartStyle = class(TfFormNormal)
    dxLayout1Item5: TdxLayoutItem;
    cxLabel1: TcxLabel;
    DeviceList: TdxOrgChart;
    dxLayout1Item4: TdxLayoutItem;
    EditWidth: TcxSpinEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditHeight: TcxSpinEdit;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    EditColor: TcxColorComboBox;
    dxLayout1Item7: TdxLayoutItem;
    EditShape: TcxComboBox;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    EditImage: TcxImageComboBox;
    dxLayout1Item9: TdxLayoutItem;
    EditAlign: TcxComboBox;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Item11: TdxLayoutItem;
    EditIndentY: TcxSpinEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditIndentX: TcxSpinEdit;
    dxLayout1Item13: TdxLayoutItem;
    EditLineColor: TcxColorComboBox;
    dxLayout1Group6: TdxLayoutGroup;
    dxLayout1Group7: TdxLayoutGroup;
    dxLayout1Item14: TdxLayoutItem;
    EditLineWidth: TcxSpinEdit;
    dxLayout1Group8: TdxLayoutGroup;
    procedure DeviceListCollapsing(Sender: TObject; Node: TdxOcNode;
      var Allow: Boolean);
    procedure EditIndentYPropertiesChange(Sender: TObject);
    procedure EditWidthPropertiesChange(Sender: TObject);
    procedure DeviceListChange(Sender: TObject; Node: TdxOcNode);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Protected declarations }
    procedure InitFormData;
    function GetLevelNode(const nLevel: Integer): TdxOcNode;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UFormCtrl, UMgrOrgChartStyle, USysProtocol, USysConst;

class function TfFormChartStyle.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;

  with TfFormChartStyle.Create(Application) do
  begin
    InitFormData();
    ShowModal;
    Free;
  end;
end;

class function TfFormChartStyle.FormID: integer;
begin
  Result := cFI_FormChartStyle;
end;

procedure TfFormChartStyle.InitFormData;
var nNode: TdxOcNode;
begin
  gChartStyleManager.LoadChartStyle(sStyleDevList, DeviceList);
  nNode := DeviceList.GetFirstNode;

  while Assigned(nNode) do
  begin
    case nNode.Level of
     0: gChartStyleManager.LoadNodeStyle(sStyleDevList, Ord(ifRoot), nNode);
     1: gChartStyleManager.LoadNodeStyle(sStyleDevList, Ord(ifPort), nNode);
     2: gChartStyleManager.LoadNodeStyle(sStyleDevList, Ord(ifDevice), nNode);
    end;

    nNode := nNode.GetNext;
  end;

  with DeviceList do
  begin
    Items[0].Selected := True;
    DeviceListChange(nil, Items[0]);
    FullExpand;
    
    EditIndentX.Value := IndentX;
    EditIndentY.Value := IndentY;

    EditLineColor.ColorValue := LineColor;
    EditLineWidth.Value := LineWidth;
  end;
end;

procedure TfFormChartStyle.DeviceListCollapsing(Sender: TObject;
  Node: TdxOcNode; var Allow: Boolean);
begin
  Allow := False;
end;

procedure TfFormChartStyle.EditIndentYPropertiesChange(Sender: TObject);
begin
  if (Sender as TWinControl).Focused then
  with DeviceList do
  begin
    IndentX :=  EditIndentX.Value;
    IndentY := EditIndentY.Value;

    LineColor := EditLineColor.ColorValue;
    LineWidth := EditLineWidth.Value;
  end;
end;

procedure TfFormChartStyle.EditWidthPropertiesChange(Sender: TObject);
var nNode: TdxOcNode;
begin
  if not (Sender as TWinControl).Focused then Exit;
  nNode := DeviceList.GetFirstNode;

  while Assigned(nNode) do
  begin
    if nNode.Level <> DeviceList.Selected.Level then
    begin
      nNode := nNode.GetNext;
      Continue;
    end;

    with nNode do
    begin
      Width := EditWidth.Value;
      Height := EditHeight.Value;
      Color := EditColor.ColorValue;
      Shape := TdxOcShape(EditShape.ItemIndex);
    end;

    nNode := nNode.GetNext;
  end;
end;

procedure TfFormChartStyle.DeviceListChange(Sender: TObject;
  Node: TdxOcNode);
begin
  if (csLoading in ComponentState) or (csDestroying in ComponentState) or
     (not Assigned(Node)) then Exit;
  //invalid

  with Node do
  begin
    EditWidth.Value := Width;
    EditHeight.Value := Height;
    EditColor.ColorValue := Color;
    EditShape.ItemIndex := Ord(Shape);
  end;
end;

function TfFormChartStyle.GetLevelNode(const nLevel: Integer): TdxOcNode;
begin
  Result := DeviceList.GetFirstNode;

  while Assigned(Result) do
  begin
    if Result.Level = nLevel then
         Break
    else Result := Result.GetNext;
  end;
end;

procedure TfFormChartStyle.BtnOKClick(Sender: TObject);
var nChart: TOrgChartStyle;
    nNode: TOrgNodeStyle;
begin
  with nChart do
  begin
    FName := sStyleDevList;
    FIndentX := DeviceList.IndentX;
    FIndentY := DeviceList.IndentY;
    FLineColor := DeviceList.LineColor;
    FLineWidth := DeviceList.LineWidth;

    gChartStyleManager.AddChart(nChart);
    //chart
  end;

  nNode.FType := Ord(ifRoot);
  GetLevelNode(0).GetNodeInfo(nNode.FStyle);
  gChartStyleManager.AddNode(sStyleDevList, nNode);

  nNode.FType := Ord(ifPort);
  GetLevelNode(1).GetNodeInfo(nNode.FStyle);
  gChartStyleManager.AddNode(sStyleDevList, nNode);

  nNode.FType := Ord(ifDevice);
  GetLevelNode(2).GetNodeInfo(nNode.FStyle);
  gChartStyleManager.AddNode(sStyleDevList, nNode);

  ModalResult := mrOk;
  ShowMsg('重启生效', sHint);
  gChartStyleManager.SaveConfig(gPath + sStyleConfig);
end;

initialization
  gControlManager.RegCtrl(TfFormChartStyle, TfFormChartStyle.FormID);
end.
