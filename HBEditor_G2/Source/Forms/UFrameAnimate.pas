{*******************************************************************************
  作者: dmzn 2009-11-28
  描述: 动画编辑器
*******************************************************************************}
unit UFrameAnimate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  UMovedItems, UFrameBase, ULibFun, GIFImage, StdCtrls, ImgList, ComCtrls,
  Dialogs, ToolWin, ExtCtrls, Buttons;

type
  TfFrameAnimate = class(TfFrameBase)
    Group2: TGroupBox;
    ListInfo: TListBox;
    OpenDialog1: TOpenDialog;
    BtnOpen: TSpeedButton;
    Image1: TImage;
    Bevel1: TBevel;
    EditSpeed: TComboBox;
    Label1: TLabel;
    Check1: TCheckBox;
    procedure BtnOpenClick(Sender: TObject);
    procedure EditSpeedChange(Sender: TObject);
    procedure Check1Click(Sender: TObject);
  protected
    { Private declarations }
    FAnimateItem: TAnimateMovedItem;
    {*待编辑对象*}
    procedure UpdateWindow; override;
    {*更新窗口*}
    procedure DoCreate; override;
    procedure DoDestroy; override;
    {*基类动作*}
    procedure OnItemDBClick(Sender: TObject);
    {*组件双击*}
    procedure LoadAnimateInfo;
    {*动画信息*}
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
uses
  USysConst, UMgrLang;

//------------------------------------------------------------------------------
procedure TfFrameAnimate.DoCreate;
begin
  inherited;
end;

//Desc: 释放资源
procedure TfFrameAnimate.DoDestroy;
begin
  inherited;
end;

//Desc: 更新窗口信息
procedure TfFrameAnimate.UpdateWindow;
var nIdx: integer;
begin
  inherited;
  FMovedItem.OnDblClick := OnItemDBClick;
  FAnimateItem := TAnimateMovedItem(FMovedItem);
  Check1.Checked := FAnimateItem.Reverse;

  EditSpeed.Clear;
  for nIdx:=1 to 16 do EditSpeed.Items.Add(IntToStr(nIdx));    
  LoadAnimateInfo;
end;

//------------------------------------------------------------------------------
//Desc: 插入图片
procedure TfFrameAnimate.BtnOpenClick(Sender: TObject);
var nStr: string;
begin
  with TOpenDialog.Create(Application) do
  begin
    Title := ML('选择动画', sMLFrame);
    Filter := ML('动画图片(*.gif)|*.gif');

    if Execute then nStr := FileName else nStr := '';
    Free;
  end;

  if FileExists(nStr) then
  begin
    FAnimateItem.ImageFile := nStr;
    LoadAnimateInfo;
    FAnimateItem.Invalidate;
  end;
end;

//Desc: 图片信息
procedure TfFrameAnimate.LoadAnimateInfo;
begin
  if not EditSpeed.Focused then
    Image1.Visible := False;
  ListInfo.Clear;

  with FAnimateItem,ListInfo do
  if PicNum > 0 then
  begin
    gMultiLangManager.SectionID := sMLFrame;
    Items.Add(Format(ML('动画来源: %s'), [ImageFile]));
    Items.Add(Format(ML('有效帧数: %d'), [PicNum]));
    Items.Add(Format(ML('播放速度: %d帧/秒'), [Speed]));
    Items.Add(Format(ML('原始大小: %d x %d'), [ImageWH.Right, ImageWH.Bottom]));

    EditSpeed.ItemIndex := EditSpeed.Items.IndexOf(IntToStr(Speed));
    Image1.Picture.LoadFromFile(ImageFile);
    Image1.Visible := True;
  end;
end;

procedure TfFrameAnimate.EditSpeedChange(Sender: TObject);
begin
  if EditSpeed.ItemIndex > -1 then
  begin
    FAnimateItem.Speed := StrToInt(EditSpeed.Text);
    LoadAnimateInfo;
  end;
end;

procedure TfFrameAnimate.OnItemDBClick(Sender: TObject);
begin
  BtnOpenClick(nil);
end;

procedure TfFrameAnimate.Check1Click(Sender: TObject);
begin
  FAnimateItem.Reverse := Check1.Checked;
end;

end.
