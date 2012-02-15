{*******************************************************************************
  作者: dmzn 2009-2-11
  描述: 时间编辑器
*******************************************************************************}
unit UFrameTime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UMovedItems, UFrameBase, USysConst, ULibFun, ImgList, ComCtrls, ToolWin,
  Buttons, StdCtrls, ExtCtrls;

type
  TfFrameTime = class(TfFrameBase)
    ImageList1: TImageList;
    Group3: TGroupBox;
    RadioSingle: TRadioButton;
    RadioMulti: TRadioButton;
    GroupBox1: TGroupBox;
    RadioEChar: TRadioButton;
    RadioChar: TRadioButton;
    GroupBox2: TGroupBox;
    RadioNoDate: TRadioButton;
    Radio2Date: TRadioButton;
    GroupBox3: TGroupBox;
    RadioNoWeek: TRadioButton;
    RadioWeek: TRadioButton;
    Radio4Date: TRadioButton;
    GroupBox4: TGroupBox;
    RadioNoTime: TRadioButton;
    RadioTime: TRadioButton;
    procedure RadioSingleClick(Sender: TObject);
    procedure RadioECharClick(Sender: TObject);
    procedure RadioNoDateClick(Sender: TObject);
    procedure RadioNoWeekClick(Sender: TObject);
    procedure RadioNoTimeClick(Sender: TObject);
  protected
    { Private declarations }
    FTimeItem: TTimeMovedItem;
    {*待编辑对象*}
    procedure DoCreate; override;
    procedure UpdateWindow; override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

//Desc: 创建
procedure TfFrameTime.DoCreate;
begin

end;

//Desc: 更新
procedure TfFrameTime.UpdateWindow;
begin
  inherited;
  FTimeItem := TTimeMovedItem(FMovedItem);
  RadioSingle.Checked := FTimeItem.ModeLine = 0;
  RadioMulti.Checked := FTimeItem.ModeLine <> 0;

  RadioEChar.Checked := FTimeItem.ModeChar = 0;
  RadioChar.Checked := FTimeItem.ModeChar <> 0;

  RadioNoDate.Checked := FTimeItem.ModeDate = 0;
  Radio2Date.Checked := FTimeItem.ModeDate = 1;
  Radio4Date.Checked := FTimeItem.ModeDate = 2;

  RadioNoWeek.Checked := FTimeItem.ModeWeek = 0;
  RadioWeek.Checked := FTimeItem.ModeWeek <> 0;

  RadioNoTime.Checked := FTimeItem.ModeTime = 0;
  RadioTime.Checked := FTimeItem.ModeTime <> 0;
end;

//Desc: 单双行显示
procedure TfFrameTime.RadioSingleClick(Sender: TObject);
begin
  if RadioSingle.Checked then
    FTimeItem.ModeLine := 0 else
  if RadioMulti.Checked then
    FTimeItem.ModeLine := 1;
  FTimeItem.Invalidate;
end;

//Desc: 字符模式
procedure TfFrameTime.RadioECharClick(Sender: TObject);
begin
  if RadioEChar.Checked then
    FTimeItem.ModeChar := 0 else
  if RadioChar.Checked then
    FTimeItem.ModeChar := 1;
  FTimeItem.Invalidate;
end;

//Desc: 日期选择
procedure TfFrameTime.RadioNoDateClick(Sender: TObject);
begin
  if RadioNoDate.Checked then
    FTimeItem.ModeDate := 0 else
  if Radio2Date.Checked then
    FTimeItem.ModeDate := 1 else
  if Radio4Date.Checked then
    FTimeItem.ModeDate := 2;
  FTimeItem.Invalidate;
end;

//Desc: 星期选择
procedure TfFrameTime.RadioNoWeekClick(Sender: TObject);
begin
  if RadioNoWeek.Checked then
    FTimeItem.ModeWeek := 0 else
  if RadioWeek.Checked then
    FTimeItem.ModeWeek := 1;
  FTimeItem.Invalidate;
end;

//Desc: 时间选择
procedure TfFrameTime.RadioNoTimeClick(Sender: TObject);
begin
  if RadioNoTime.Checked then
    FTimeItem.ModeTime := 0 else
  if RadioTime.Checked then
    FTimeItem.ModeTime := 1;
  FTimeItem.Invalidate;
end;

end.
