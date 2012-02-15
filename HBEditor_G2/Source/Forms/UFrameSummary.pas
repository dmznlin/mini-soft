{*******************************************************************************
  作者: dmzn 2009-2-9
  描述: 显示屏摘要信息
*******************************************************************************}
unit UFrameSummary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  USysConst, IniFiles, UMgrLang, Grids, StdCtrls;

type
  TfFrameSummary = class(TFrame)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit4: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Edit2: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit5: TEdit;
    Label6: TLabel;
    Edit6: TEdit;
    ListBox1: TListBox;
    procedure ListBox1Exit(Sender: TObject);
  private
    { Private declarations }
    procedure LoadScreen(const nScreen: PScreenItem);
    //载入屏信息
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

procedure ShowScreenSummary(const nScreen: PScreenItem; const nParent: TWinControl);
//入口函数

implementation

{$R *.dfm}

//Desc: 显示屏幕摘要信息
procedure ShowScreenSummary(const nScreen: PScreenItem; const nParent: TWinControl);
var nIdx: integer;
    nFrame: TfFrameSummary;
begin
  nFrame := nil;
  for nIdx:=nParent.ControlCount - 1 downto 0 do
   if nParent.Controls[nIdx] is TfFrameSummary then
   begin
     nFrame := nParent.Controls[nIdx] as TfFrameSummary; Break;
   end;

  if not Assigned(nFrame) then
  begin
    nFrame := TfFrameSummary.Create(nParent);
    gMultiLangManager.SectionID := 'FrameItem';
    gMultiLangManager.TranslateAllCtrl(nFrame);
  end; //new frame

  with nFrame do
  begin
    Parent := nParent;
    Align := alClient;

    BringToFront;
    LoadScreen(nScreen);
  end;
end;

constructor TfFrameSummary.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TfFrameSummary.Destroy;
begin
  inherited;
end;

//------------------------------------------------------------------------------
procedure TfFrameSummary.ListBox1Exit(Sender: TObject);
begin
  ListBox1.ItemIndex := - 1;
end;

//Desc: 载入nScreen的信息
procedure TfFrameSummary.LoadScreen(const nScreen: PScreenItem);
var nStr: string;
    nIdx: integer;
begin
  Edit1.Text := nScreen.FName;
  case nScreen.FType of
    stSingle : Edit2.Text := '单色';
    stDouble : Edit2.Text := '双色';
    stFull   : Edit2.Text := '全彩' else Edit2.Text := '未知';
  end;

  Edit2.Text := ML(Edit2.Text, sMLFrame);
  Edit3.Text := Format('%d x %d', [nScreen.FLenY, nScreen.FLenX]);
  nIdx := CardItemIndex(nScreen.FCard);

  if nIdx < 0 then
       Edit4.Text := '未知'
  else Edit4.Text := cCardList[nIdx].FName;

  Edit2.Text := ML(Edit2.Text);
  Edit5.Text := nScreen.FPort;
  Edit6.Text := IntToStr(nScreen.FBote);

  ListBox1.Clear;
  for nIdx:=Low(nScreen.FDevice) to High(nScreen.FDevice) do
  with nScreen.FDevice[nIdx] do
  begin
    nStr := Format(ML('设备号:%-5d 名称:%-10s'),[FID, FName]);
    ListBox1.Items.Add(nStr);
  end;
end;

end.
