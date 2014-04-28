unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Memo1: TMemo;
    Edit1: TEdit;
    Edit3: TEdit;
    Button4: TButton;
    Button5: TButton;
    Edit2: TEdit;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  cLib = 'JSLib.dll';
  
function JSLoadConfig(const nConfigFile: PChar): Boolean; stdcall; external cLib;
//载入配置
procedure JSServiceStart; stdcall;   external cLib;
procedure JSServiceStop; stdcall;   external cLib;
//启停服务
function JSStart(const nTunnel,nTruck: PChar; const nDaiNum: Integer): Boolean; stdcall;  external cLib;
//添加计数
function JSStop(const nTunnel: PChar): Boolean; stdcall;  external cLib;
//停止计数
function JSStatus(const nStatus: PChar): Integer; stdcall;  external cLib;
//计数状态

//------------------------------------------------------------------------------
procedure TForm1.Button2Click(Sender: TObject);
var nStr: string;
begin
  nStr := FormatDateTime('YYYY-MM-DD', Now);
  nStr := ExtractFilePath(Application.ExeName) + 'Logs\' + nStr + '.log';
  Memo1.Lines.LoadFromFile(nStr);
end;

procedure TForm1.Button1Click(Sender: TObject);
var nStr: string;
begin
  nStr := ExtractFilePath(Application.ExeName) + 'JSQ.xml';
  JSLoadConfig(PChar(nStr));
end;

procedure TForm1.Button3Click(Sender: TObject);
var nTunnel,nTruck: string;
begin
  nTunnel := Edit1.Text;
  nTruck := Edit2.Text;
  JSStart(PChar(nTunnel), PChar(nTruck), StrToInt(Edit3.Text));
end;

procedure TForm1.Button4Click(Sender: TObject);
var nTunnel: string;
begin
  nTunnel := Edit1.Text;
  JSStop(PChar(nTunnel));
end;

procedure TForm1.Button5Click(Sender: TObject);
var nStr: string;
    nInt: Integer;
begin
  SetLength(nStr, 255);
  nInt := JSStatus(PChar(nStr));
  SetLength(nStr, nInt+1);
  Memo1.Text := nStr;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
var i: Integer;
begin
  if CheckBox1.Checked then
       JSServiceStart
  else JSServiceStop;

  for i:=Panel1.ControlCount - 1 downto 0 do
   if Panel1.Controls[i].Tag = 10 then
    Panel1.Controls[i].Enabled := CheckBox1.Checked;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  JSServiceStop;
end;

end.
