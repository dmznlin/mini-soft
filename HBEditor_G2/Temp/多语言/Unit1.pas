unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ComCtrls, ToolWin, ExtCtrls, Buttons,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxMCListBox, cxEdit, cxButtons, cxPC, dxNavBarCollns,
  cxClasses, dxNavBarBase, dxNavBar, cxGroupBox, cxRadioGroup,
  dxLayoutControl, cxTextEdit, cxCheckBox, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinsdxNavBar2Painter;

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
    cxMCListBox1: TcxMCListBox;
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    cxTextEdit1: TcxTextEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    cxRadioGroup1: TcxRadioGroup;
    cxGroupBox1: TcxGroupBox;
    dxNavBar1: TdxNavBar;
    dxNavBar1Group1: TdxNavBarGroup;
    dxNavBar1Item1: TdxNavBarItem;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    cxButton1: TcxButton;
    Button4: TButton;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    StaticText1: TStaticText;
    cxCheckBox1: TcxCheckBox;
    Button5: TButton;
    dxLayoutControl1Item2: TdxLayoutItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses UMgrLang, UObjectList;

procedure TForm1.FormCreate(Sender: TObject);
begin
  gObjectPoolManager := TObjectPoolManager.Create;
  gMultiLangManager := TMultiLangManager.Create;
  Edit1.Text := ExtractFilePath(Application.ExeName) + 'Lang.xml';
end;

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
    AutoNewNode := False;
    LoadLangFile(Edit1.Text);
    
    Memo1.Lines.Add('”Ô—‘:' + LangID);
    LangID := 'en';
    NowLang := 'cn';
    SectionID := 'fFormMain';
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  gMultiLangManager.TranslateAllCtrl(Self);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  gMultiLangManager.RegItem('TcxMCListBox', 'HeaderSections.Text');
end;

procedure TForm1.Button5Click(Sender: TObject);
var nStr: string;
begin

  nStr := Format(' ±º‰: %s,%s', [DateToStr(now), TimeToStr(now)]);
  cxTextEdit1.Text := gMultiLangManager.GetTextByText(nStr, '', '', False)
end;

end.
