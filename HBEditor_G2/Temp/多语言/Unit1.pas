unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ComCtrls, ToolWin, ExtCtrls, Buttons;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Memo1: TMemo;
    Edit1: TEdit;
    Button2: TButton;
    Button3: TButton;
    PopupMenu1: TPopupMenu;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    Button1: TButton;
    N10: TMenuItem;
    N11: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses UMgrLang;

procedure TForm1.Button1Click(Sender: TObject);
var i: integer;
begin
  with gMultiLangManager do
  begin
    for i:=Low(LangItems) to High(LangItems) do
     Memo1.Lines.Add(LangItems[i].FName);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  with gMultiLangManager do
  begin
    LoadLangFile(Edit1.Text);
    Memo1.Lines.Add('”Ô—‘:' + LangID);
    LangID := 'en';
    NowLang := 'jc';
    SectionID := 'fFormMain';
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  gMultiLangManager.TranslateComponent(Self);
end;

end.
