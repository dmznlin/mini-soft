{*******************************************************************************
  作者: dmzn 2009-2-9
  描述: 文本编辑器
*******************************************************************************}
unit UFrameText;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  UMovedItems, UFrameBase, ImgList, Dialogs, ComCtrls, ToolWin, StdCtrls,
  Buttons, ExtCtrls;

type
  TfFrameText = class(TfFrameBase)
    Group2: TGroupBox;
    Label1: TLabel;
    ListFont: TComboBox;
    Label2: TLabel;
    ListSize: TComboBox;
    Label3: TLabel;
    ListColor: TComboBox;
    BtnOpen: TSpeedButton;
    MemoText: TMemo;
    ToolBar1: TToolBar;
    BtnBold: TToolButton;
    BtnItalic: TToolButton;
    BtnUnder: TToolButton;
    ImageList1: TImageList;
    Group3: TGroupBox;
    Label4: TLabel;
    EditEnter: TComboBox;
    Label5: TLabel;
    EditExit: TComboBox;
    Label6: TLabel;
    EditESpeed: TEdit;
    Label7: TLabel;
    EditESeepd2: TEdit;
    Label8: TLabel;
    EditKeep: TEdit;
    Check1: TCheckBox;
    Label9: TLabel;
    Label10: TLabel;
    procedure ListColorDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ListFontChange(Sender: TObject);
    procedure BtnBoldClick(Sender: TObject);
    procedure MemoTextKeyPress(Sender: TObject; var Key: Char);
    procedure BtnOpenClick(Sender: TObject);
    procedure EditEnterChange(Sender: TObject);
    procedure EditESpeedChange(Sender: TObject);
    procedure Check1Click(Sender: TObject);
    procedure MemoTextExit(Sender: TObject);
  protected
    { Private declarations }
    FTextItem: TTextMovedItem;
    {*待编辑对象*}
    FColorDefine: TBitmap;
    {*自定义颜色*}
    procedure UpdateWindow; override;
    {*更新窗口*}
    procedure DoCreate; override;
    procedure DoDestroy; override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses ULibFun, USysConst, UMgrLang;

//Desc: 创建
procedure TfFrameText.DoCreate;
var i: integer;
begin
  inherited;
  ListFont.Items.Assign(Screen.Fonts);

  ListSize.Clear;
  for i:=5 to 124 do ListSize.Items.Add(IntToStr(i));
  FillColorCombox(ListColor);

  EditEnter.Clear;
  for i:=Low(cEnterMode) to High(cEnterMode) do
    EditEnter.Items.Add(ML(cEnterMode[i].FText));
  //xxxxx

  EditExit.Clear;
  for i:=Low(cExitMode) to High(cExitMode) do
    EditExit.Items.Add(ML(cExitMode[i].FText));
  //xxxxx
end;

procedure TfFrameText.DoDestroy;
begin
  if Assigned(FColorDefine) then
    FColorDefine.Free;
  inherited;
end;

//Desc: 更新窗口信息
procedure TfFrameText.UpdateWindow;
var nIdx: Integer;
begin
  inherited;
  FTextItem := TTextMovedItem(FMovedItem);
  MemoText.Text := FTextItem.Text;

  ListFont.ItemIndex := ListFont.Items.IndexOf(FTextItem.Font.Name);
  ListSize.ItemIndex := ListSize.Items.IndexOf(IntToStr(FTextItem.Font.Size));

  nIdx := ListColor.Items.Count -1;
  if nIdx > -1 then
  begin
    if gIsFullColor then
    begin
      if ListColor.Items.Objects[nIdx] <> TObject(0) then
        ListColor.Items.AddObject('', TObject(0));
      //xxxxx
    end else

    if ListColor.Items.Objects[nIdx] = TObject(0) then
      ListColor.Items.Delete(nIdx);
    //xxxxx
  end;

  SetColorComboxIndex(ListColor, FTextItem.Font.Color);
  if (ListColor.ItemIndex < 0) and gIsFullColor then
    SetColorComboxIndex(ListColor, 0);
  //xxxxx
  
  BtnBold.Down := fsBold in FTextItem.Font.Style;
  BtnItalic.Down := fsItalic in FTextItem.Font.Style;
  BtnUnder.Down := fsUnderline in FTextItem.Font.Style;

  EditEnter.ItemIndex := FTextItem.ModeEnter;
  EditExit.ItemIndex := FTextItem.ModeExit;
  EditESpeed.Text := IntToStr(FTextItem.SpeedEnter);
  EditESeepd2.Text := IntToStr(FTextItem.SpeedExit);
  EditKeep.Text := IntToStr(FTextItem.KeedTime);
  Check1.Checked := FTextItem.ModeSerial = 1;
end;

procedure TfFrameText.ListColorDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var nInt: Integer;
    nColor: TColor;
    nCombox: TComboBox;
begin
  if Control is TComboBox then
  begin
    nCombox := TComboBox(Control);
    nColor := Integer(nCombox.Items.Objects[Index]);

    with nCombox do
    begin
      if nColor > 0 then
      begin
        Canvas.Brush.Color := nColor;
        Canvas.FillRect(Rect);
      end else
      begin
        if not Assigned(FColorDefine) then
        begin
          FColorDefine := TBitmap.Create;
          FColorDefine.Width := Rect.Right - Rect.Left;
          FColorDefine.Height := Rect.Bottom - Rect.Top;

          for nInt:=0 to FColorDefine.Width do
          begin
            nColor := RGB(Random(255), Random(255), Random(255));
            FColorDefine.Canvas.MoveTo(nInt, 0);
            FColorDefine.Canvas.Pen.Color := nColor;
            FColorDefine.Canvas.LineTo(nInt, FColorDefine.Height);
          end;
        end;

        Canvas.StretchDraw(Rect, FColorDefine);
      end;
    end;
  end;
end;

//Desc: 字体,颜色,大小
procedure TfFrameText.ListFontChange(Sender: TObject);
var nColor: TColor;
    nCombox: TComboBox;
begin
  nCombox := TComboBox(Sender);
  if nCombox = ListFont then
  begin
    FTextItem.Font.Name := nCombox.Text;
  end else

  if nCombox = ListSize then
  begin
    if IsNumber(nCombox.Text, False) then
      FTextItem.Font.Size := StrToInt(nCombox.Text);
  end else

  if (nCombox = ListColor) and (ListColor.ItemIndex > -1) then
  begin
    nColor := Integer(ListColor.Items.Objects[ListColor.ItemIndex]);
    if nColor < 1 then
    begin
      with TColorDialog.Create(Application) do
      begin
        Color := FTextItem.Font.Color;
        Options := Options + [cdFullOpen];
        
        if Execute then nColor := Color else nColor := -1;
        Free;
      end;

      if nColor < 0 then Exit;
    end;

    FTextItem.Font.Color := nColor;
  end;

  FTextItem.Invalidate;
end;
                
//Desc: 字体风格
procedure TfFrameText.BtnBoldClick(Sender: TObject);
var nButton: TToolButton;
begin
  nButton := TToolButton(Sender);

  with FTextItem.Font do
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

  FTextItem.Invalidate;
end;

//Desc: 处理回车键,立刻生效
procedure TfFrameText.MemoTextKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Char(VK_Return) then
  begin
    Key := #0;
    MemoTextExit(nil);
  end;
end;

//Desc: 改变文本内容
procedure TfFrameText.MemoTextExit(Sender: TObject);
begin
  if MemoText.Modified then
  begin
    FTextItem.Text := MemoText.Text;
    FTextItem.Invalidate;
  end;
  MemoText.Modified := False;
end;

//Desc: 载入文本
procedure TfFrameText.BtnOpenClick(Sender: TObject);
var nStr: string;
    nList: TStrings;
begin
  with TOpenDialog.Create(Application) do
  begin
    Title := ML('打开', sMLFrame);
    Filter := ML('文本文件(*.txt)|*.txt');

    if Execute then nStr := FileName else nStr := '';
    Free;
  end;

  if not FileExists(nStr) then Exit;
  nList := TStringList.Create;
  try
    nList.LoadFromFile(nStr);
    nStr := StringReplace(nList.Text, #13, '', [rfReplaceAll]);
    nStr := StringReplace(nStr, #10, '', [rfReplaceAll]);

    MemoText.Text := nStr;
    FTextItem.Text := nStr; FTextItem.Invalidate;
    MemoText.Modified := False;
  finally
    nList.Free;
  end;
end;

//Desc: 进出场模式
procedure TfFrameText.EditEnterChange(Sender: TObject);
begin
  if Sender = EditEnter then
    FTextItem.ModeEnter := EditEnter.ItemIndex;
  if Sender = EditExit then
    FTextItem.ModeExit := EditExit.ItemIndex;
end;

//Desc: 时间
procedure TfFrameText.EditESpeedChange(Sender: TObject);
var nInt: Integer;
begin
  if IsNumber(TEdit(Sender).Text, False) then
       nInt := StrToInt(TEdit(Sender).Text)
  else Exit;

  if ((Sender = EditESpeed) or (Sender = EditESeepd2)) and
     (nInt > 15) then TEdit(Sender).Text := '0';

  if (Sender = EditKeep) and (nInt > 127) then
    TEdit(Sender).Text := '0';
  nInt := StrToInt(TEdit(Sender).Text);

  if Sender = EditESpeed then FTextItem.SpeedEnter := nInt else
  if Sender = EditESeepd2 then FTextItem.SpeedExit := nInt else
  if Sender = EditKeep then FTextItem.KeedTime := nInt;
end;

//Desc: 跟随前屏
procedure TfFrameText.Check1Click(Sender: TObject);
begin
  if Check1.Checked then
       FTextItem.ModeSerial := 1
  else FTextItem.ModeSerial := 0;
end;

end.
