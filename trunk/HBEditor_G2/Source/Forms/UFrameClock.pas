{*******************************************************************************
  作者: dmzn 2009-11-28
  描述: 模拟时钟
*******************************************************************************}
unit UFrameClock;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  UMovedItems, UFrameBase, ULibFun, GIFImage, StdCtrls, ImgList, ComCtrls,
  Dialogs, ToolWin, ExtCtrls, Buttons;

type
  TfFrameClock = class(TfFrameBase)
    Group2: TGroupBox;
    OpenDialog1: TOpenDialog;
    BtnOpen: TSpeedButton;
    Label3: TLabel;
    ListColorH: TComboBox;
    Label1: TLabel;
    ListColorM: TComboBox;
    Label2: TLabel;
    ListColorS: TComboBox;
    EditOX: TLabeledEdit;
    EditOY: TLabeledEdit;
    CheckAuto: TCheckBox;
    Image1: TImage;
    Bevel1: TBevel;
    procedure BtnOpenClick(Sender: TObject);
    procedure ListColorHDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ListColorHChange(Sender: TObject);
    procedure CheckAutoClick(Sender: TObject);
    procedure EditOXChange(Sender: TObject);
    procedure Edit_XKeyPress(Sender: TObject; var Key: Char);
  protected
    { Private declarations }
    FClockItem: TClockMovedItem;
    {*待编辑对象*}
    FColorDefine: TBitmap;
    {*自定义颜色*}
    procedure UpdateWindow; override;
    {*更新窗口*}
    procedure DoCreate; override;
    procedure DoDestroy; override;
    {*基类动作*}
    procedure DoItemResized(nNewW,nNewH: integer; nIsApplyed: Boolean); override;
    {*大小变更*}
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
uses
  USysConst, UMgrLang;

//------------------------------------------------------------------------------
procedure TfFrameClock.DoCreate;
begin
  inherited;
  FillColorCombox(ListColorH);
  FillColorCombox(ListColorM);
  FillColorCombox(ListColorS);
end;

//Desc: 释放资源
procedure TfFrameClock.DoDestroy;
begin
  if Assigned(FColorDefine) then
    FColorDefine.Free;
  inherited;
end;

procedure AdjustColorDefine(const nList: TComboBox);
var nIdx: Integer;
begin
  nIdx := nList.Items.Count -1;
  if nIdx > -1 then
  begin
    if gIsFullColor then
    begin
      if nList.Items.Objects[nIdx] <> TObject(0) then
        nList.Items.AddObject('', TObject(0));
      if nList.ItemIndex < 0 then nList.ItemIndex := nIdx;
    end else

    if nList.Items.Objects[nIdx] = TObject(0) then
      nList.Items.Delete(nIdx);
    //xxxxx
  end;
end;

//Desc: 更新窗口信息
procedure TfFrameClock.UpdateWindow;
begin
  inherited;
  FClockItem := TClockMovedItem(FMovedItem);

  EditOX.Text := IntToStr(FClockItem.DotPoint.X);
  EditOY.Text := IntToStr(FClockItem.DotPoint.Y);

  CheckAuto.Checked := FClockItem.AutoDot;
  CheckAutoClick(nil);

  SetColorComboxIndex(ListColorH, FClockItem.ColorHour);
  SetColorComboxIndex(ListColorM, FClockItem.ColorMin);
  SetColorComboxIndex(ListColorS, FClockItem.ColorSec);

  AdjustColorDefine(ListColorH);
  AdjustColorDefine(ListColorM);
  AdjustColorDefine(ListColorS);
  Image1.Picture := FClockItem.Image;
end;

//------------------------------------------------------------------------------
procedure TfFrameClock.ListColorHDrawItem(Control: TWinControl;
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

procedure TfFrameClock.Edit_XKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', Char(VK_BACK)]) then
  begin
    Key := #0;
  end;
end;

//Desc: 插入图片
procedure TfFrameClock.BtnOpenClick(Sender: TObject);
var nStr: string;
begin
  with TOpenDialog.Create(Application) do
  begin
    Title := ML('表盘图片', sMLFrame);
    Filter := ML('图片(*.bmp,*.jpg)|*.bmp;*.jpg');

    if Execute then nStr := FileName else nStr := '';
    Free;
  end;

  if FileExists(nStr) then
  begin
    FClockItem.Image.LoadFromFile(nStr);
    Image1.Picture := FClockItem.Image;
  end;
end;

//Desc: 调整颜色
procedure TfFrameClock.ListColorHChange(Sender: TObject);
var nColor: TColor;
    nCombox: TComboBox;
begin
  nCombox := TComboBox(Sender);
  if nCombox.ItemIndex < 0 then Exit;
  nColor := Integer(nCombox.Items.Objects[nCombox.ItemIndex]);

  if nColor < 1 then
  begin
    if nCombox = ListColorH then nColor := FClockItem.ColorHour else
    if nCombox = ListColorM then nColor := FClockItem.ColorMin else
    if nCombox = ListColorS then nColor := FClockItem.ColorSec;

    with TColorDialog.Create(Application) do
    begin
      Color := nColor;
      Options := Options + [cdFullOpen];

      if Execute then nColor := Color else nColor := -1;
      Free;
    end;

    if nColor < 0 then Exit;
  end;

  if nCombox = ListColorH then FClockItem.ColorHour := nColor else
  if nCombox = ListColorM then FClockItem.ColorMin := nColor else
  if nCombox = ListColorS then FClockItem.ColorSec := nColor;

  FClockItem.Invalidate;
end;

procedure TfFrameClock.CheckAutoClick(Sender: TObject);
begin
  FClockItem.AutoDot := CheckAuto.Checked;
  EditOX.Enabled := not FClockItem.AutoDot;
  EditOY.Enabled := not FClockItem.AutoDot;
  FClockItem.Invalidate;
end;

procedure TfFrameClock.EditOXChange(Sender: TObject);
var nP: TPoint;
    nInt: Integer;
    nEdit: TCustomEdit;
begin
  nEdit := TCustomEdit(Sender);
  if not IsNumber(nEdit.Text, False) then Exit;

  nP := FClockItem.DotPoint;
  nInt := StrToInt(nEdit.Text);

  if nEdit = EditOX then nP.X := nInt;
  if nEdit = EditOY then nP.Y := nInt; FClockItem.DotPoint := nP;
  FClockItem.Invalidate;
end;

procedure TfFrameClock.DoItemResized(nNewW, nNewH: integer;
  nIsApplyed: Boolean);
begin
  if nIsApplyed then
  begin
    EditOX.Text := IntToStr(FClockItem.DotPoint.X);
    EditOY.Text := IntToStr(FClockItem.DotPoint.Y);
  end;
  inherited;
end;

end.
