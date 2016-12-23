{*******************************************************************************
  ����: dmzn@163.com 2008-8-7
  ����: ���ڴ���
*******************************************************************************}
unit UFormAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TfFormAbout = class(TForm)
    wPanel: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Copyright: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label_Ver: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Label4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowAboutForm;
//��ں���

implementation

{$R *.dfm}
uses
  ShellAPI, ULibFun, USysConst, USysFun;

//------------------------------------------------------------------------------
//Desc: ����
procedure ShowAboutForm;
begin
  with TfFormAbout.Create(Application) do
  begin
    Caption := '����';
    ShowModal;
    Free;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormAbout.FormCreate(Sender: TObject);
var nStr: string;
begin
  ProductName.Caption := gSysParam.FAppTitle;
  ProductName.Left := Round((wPanel.Width - ProgramIcon.Left - ProgramIcon.Width) /2); 

  nStr := GetFileVersionStr(Application.ExeName);
  if nStr <> '' then Label_Ver.Caption := 'V' + nStr;
end;

//Desc: ������
procedure TfFormAbout.Label4Click(Sender: TObject);
var nStr: string;
begin
  nStr := Label4.Caption;
  ShellExecute(GetDesktopWindow, nil, PChar(nStr), nil, nil, SW_ShowNormal)
end;

end.
