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
    Group2: TGroupBox;
    Label1: TLabel;
    ListFont: TComboBox;
    ListSize: TComboBox;
    FixColor: TComboBox;
    ToolBar1: TToolBar;
    BtnBold: TToolButton;
    BtnItalic: TToolButton;
    BtnUnder: TToolButton;
    ImageList1: TImageList;
    Group3: TGroupBox;
    Edit_Fix: TLabeledEdit;
    Edit_Date: TEdit;
    DateColor: TComboBox;
    CheckDate: TCheckBox;
    Edit_Week: TEdit;
    WeekColor: TComboBox;
    CheckWeek: TCheckBox;
    Edit_Time: TEdit;
    TimeColor: TComboBox;
    CheckTime: TCheckBox;
    RadioSingle: TRadioButton;
    RadioMulti: TRadioButton;
    Bevel1: TBevel;
    procedure FixColorDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure CheckDateClick(Sender: TObject);
    procedure RadioSingleClick(Sender: TObject);
    procedure BtnBoldClick(Sender: TObject);
    procedure ListFontChange(Sender: TObject);
    procedure FixColorChange(Sender: TObject);
    procedure Edit_FixKeyPress(Sender: TObject; var Key: Char);
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
var i: integer;
begin
  ListFont.Items.Assign(Screen.Fonts); 
  ListSize.Clear;
  for i:=5 to 124 do ListSize.Items.Add(IntToStr(i));

  FillColorCombox(FixColor);
  FillColorCombox(DateColor);
  FillColorCombox(WeekColor);
  FillColorCombox(TimeColor);
end;

//Desc: 更新
procedure TfFrameTime.UpdateWindow;
begin
  inherited;
  FTimeItem := TTimeMovedItem(FMovedItem);
  ListFont.ItemIndex := ListFont.Items.IndexOf(FTimeItem.Font.Name);
  ListSize.ItemIndex := ListSize.Items.IndexOf(IntToStr(FTimeItem.Font.Size));

  BtnBold.Down := fsBold in FTimeItem.Font.Style;
  BtnItalic.Down := fsItalic in FTimeItem.Font.Style;
  BtnUnder.Down := fsUnderline in FTimeItem.Font.Style;

  RadioSingle.Checked := FTimeItem.TextStyle = tsSingle;
  RadioMulti.Checked := FTimeItem.TextStyle = tsMulti;

  SetColorComboxIndex(FixColor, FTimeItem.FixColor);
  SetColorComboxIndex(DateColor, FTimeItem.DateColor);
  SetColorComboxIndex(WeekColor, FTimeItem.WeekColor);
  SetColorComboxIndex(TimeColor, FTimeItem.TimeColor);

  //----------------------------------------------------------------------------
  Edit_Fix.Text := FTimeItem.FixText;
  Edit_Date.Text := FTimeItem.DateText;
  Edit_Week.Text := FTimeItem.WeekText;
  Edit_Time.Text := FTimeItem.TimeText;

  CheckDate.Checked := toDate in FTimeItem.Options;
  CheckDateClick(CheckDate);
  CheckWeek.Checked := toWeek in FTimeItem.Options;
  CheckDateClick(CheckWeek);
  CheckTime.Checked := toTime in FTimeItem.Options;
  CheckDateClick(CheckTime);
end;

procedure TfFrameTime.FixColorDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var nColor: TColor;
    nCombox: TComboBox;
begin
  if Control is TComboBox then
  begin
    nCombox := TComboBox(Control);
    nColor := Integer(nCombox.Items.Objects[Index]);
    nCombox.Canvas.Brush.Color := nColor;
    nCombox.Canvas.FillRect(Rect);
  end;
end;

//Desc: 处理界面Enabled状态
procedure TfFrameTime.CheckDateClick(Sender: TObject);
var nIdx,nTag: integer;
    nEnabled: Boolean;
    nCtrl: TWinControl;
begin
  if Sender is TWinControl then
  begin
    nCtrl := Sender as TWinControl;
    nTag := nCtrl.Tag;

    if Sender is TCheckBox then
         nEnabled := (Sender as TCheckBox).Checked
    else Exit;

    nCtrl := nCtrl.Parent;
    if not Assigned(nCtrl) then Exit;

    for nIdx:=nCtrl.ControlCount - 1 downto 0 do
     if (nCtrl.Controls[nIdx].Tag = nTag) and (nCtrl.Controls[nIdx] <> Sender) then
      nCtrl.Controls[nIdx].Enabled := nEnabled;

    //--------------------------------------------------------------------------
    if Sender = CheckDate then
    begin
      if nEnabled then
           FTimeItem.Options := FTimeItem.Options + [toDate]
      else FTimeItem.Options := FTimeItem.Options - [toDate];
    end else
    if Sender = CheckWeek then
    begin
      if nEnabled then
           FTimeItem.Options := FTimeItem.Options + [toWeek]
      else FTimeItem.Options := FTimeItem.Options - [toWeek];
    end else
    if Sender = CheckTime then
    begin
      if nEnabled then
           FTimeItem.Options := FTimeItem.Options + [toTime]
      else FTimeItem.Options := FTimeItem.Options - [toTime];
    end;

    FTimeItem.Invalidate;
  end;
end;

//Desc: 单双行显示
procedure TfFrameTime.RadioSingleClick(Sender: TObject);
begin
  if RadioSingle.Checked then
    FTimeItem.TextStyle := tsSingle else
  if RadioMulti.Checked then
    FTimeItem.TextStyle := tsMulti;
  FTimeItem.Invalidate;
end;

//Desc: 字体风格
procedure TfFrameTime.BtnBoldClick(Sender: TObject);
var nButton: TToolButton;
begin
  nButton := TToolButton(Sender);

  with FTimeItem.Font do
  begin
    if nButton = BtnBold then
    begin
      if nButton.Down then
           Style := Style + [fsBold]
      else Style := Style - [fsBold];
    end else

    if nButton = BtnItalic then
    begin
      if nButton.Down then
           Style := Style + [fsItalic]
      else Style := Style - [fsItalic];
    end else

    if nButton = BtnUnder then
    begin
      if nButton.Down then
           Style := Style + [fsUnderline]
      else Style := Style - [fsUnderline];
    end;
  end;
end;

//Desc: 字体,大小
procedure TfFrameTime.ListFontChange(Sender: TObject);
var nCombox: TComboBox;
begin
  nCombox := TComboBox(Sender);
  if nCombox = ListFont then
  begin
    FTimeItem.Font.Name := nCombox.Text;
  end else

  if nCombox = ListSize then
  begin
    if IsNumber(nCombox.Text, False) then
      FTimeItem.Font.Size := StrToInt(nCombox.Text);
  end;
end;

//Desc: 颜色下拉框
procedure TfFrameTime.FixColorChange(Sender: TObject);
var nColor: TColor;
    nCombox: TComboBox;
begin
  nCombox := TComboBox(Sender);
  if nCombox.ItemIndex > -1 then
       nColor := Integer(nCombox.Items.Objects[nCombox.ItemIndex])
  else Exit;

  if nCombox = FixColor then
    FTimeItem.FixColor := nColor else
  if nCombox = DateColor then
    FTimeItem.DateColor := nColor else
  if nCombox = WeekColor then
    FTimeItem.WeekColor := nColor else
  if nCombox = TimeColor then
    FTimeItem.TimeColor := nColor;
  FTimeItem.Invalidate;
end;

//Desc: 文本
procedure TfFrameTime.Edit_FixKeyPress(Sender: TObject; var Key: Char);
var nStr: string;
begin
  if Ord(Key) <> VK_Return then Exit;
  if not (Sender is TCustomEdit) then Exit;

  nStr := (Sender as TCustomEdit).Text;
  if Sender = Edit_Fix then
    FTimeItem.FixText := nStr else
  if Sender = Edit_Date then
    FTimeItem.DateText := nStr else
  if Sender = Edit_Week then
    FTimeItem.WeekText := nStr else
  if Sender = Edit_Time then
    FTimeItem.TimeText := nStr;
    
  Key := #0;
  FTimeItem.Invalidate;
end;

end.
