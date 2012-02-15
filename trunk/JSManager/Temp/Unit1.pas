unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UMultiJSCtrl, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxGroupBox, cxLabel, cxTextEdit, Menus, StdCtrls,
  cxButtons, cxProgressBar, UBitmapPanel, UTransEdit, ComCtrls, cxImage,
  cxGraphics;

type
  TForm1 = class(TForm)
    cxGroupBox2: TcxGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    cxTextEdit2: TcxTextEdit;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    cxProgressBar2: TcxProgressBar;
    cxButton4: TcxButton;
    cxButton5: TcxButton;
    cxButton6: TcxButton;
    cxLookAndFeelController1: TcxLookAndFeelController;
    cxImage1: TcxImage;
    procedure cxButton4Click(Sender: TObject);
    procedure cxImage1Click(Sender: TObject);
    procedure cxButton5Click(Sender: TObject);
    procedure cxButton6Click(Sender: TObject);
  private
    { Private declarations }
    FPos: Integer;
    FPanel: TMultiJSPanel;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
procedure TForm1.cxButton4Click(Sender: TObject);
var nData: TMultiJSPanelData;
    nTunnel: TMultiJSPanelTunnel;
begin
  DoubleBuffered := True;

  nData.FRecordID := '10';
  nData.FTruckNo := '豫A-122';
  nData.FStockName := '袋装_复合32.5';
  nData.FStockNo := 'cx_222';
  nData.FTHValue := 2;
  nData.FCustomer := '南水北调工程第二工程局';

  nTunnel.FPanelName := '1车道';
  //nData.FIsBC := True;

  FPanel := TMultiJSPanel.Create(Application);
  with FPanel  do
  begin
    Parent := Self;
    Left := Self.Tag;
    Top := cxGroupBox2.Top;

    AdjustPostion;
    PerWeight := 50;
    SetData(nData);
    SetTunnel(nTunnel);
  end;

  Tag := Tag + TMultiJSPanel.PanelRect.Right + 10;
end;

procedure TForm1.cxImage1Click(Sender: TObject);
begin
  showmessage('done')
end;

procedure TForm1.cxButton5Click(Sender: TObject);
begin
  FPos := FPos + 1;
  FPanel.JSProgress(FPos);
end;

procedure TForm1.cxButton6Click(Sender: TObject);
begin
  FPos := 0;
  
end;

end.
