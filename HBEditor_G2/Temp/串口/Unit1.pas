unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ToolWin;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses UMgrCOMM;

procedure TForm1.ToolButton1Click(Sender: TObject);
begin
  GetComPortNames(Memo1.Lines);
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
  GetValidCOMPort(Memo1.Lines);
end;

end.
