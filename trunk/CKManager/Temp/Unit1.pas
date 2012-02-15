unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ULibFun, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, DB, ADODB, USysLookupAdapter,
  StdCtrls;

type
  TForm1 = class(TForm)
    ADOConnection1: TADOConnection;
    dd: TcxLookupComboBox;
    Button1: TButton;
    cxLookAndFeelController1: TcxLookAndFeelController;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  gLookupComboBoxAdapter := TLookupComboBoxAdapter.Create(ADOConnection1);
end;

procedure TForm1.Button1Click(Sender: TObject);
var nItem: TLookupComboBoxItem;
    nds: TDynamicStrArray;
begin
  SetLength(nds, 2);
  nds[0] := 'C_PY';
  nds[1] := 'C_Name';

  nItem := gLookupComboBoxAdapter.MakeItem(Name, Name+'dd', 'Select * from S_Customer',
           'C_Name', 1, [MI('C_PY', '¼òÐ´'), MI('C_Name', 'Ãû³Æ')], nds);
  gLookupComboBoxAdapter.AddItem(nItem);
  gLookupComboBoxAdapter.BindItem(Name+'dd', dd);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  gLookupComboBoxAdapter.DeleteGroup(Name);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  showmessage(dd.EditValue)
end;

end.
