{*******************************************************************************
  作者: dmzn 2009-2-8
  描述: 带渐变色的标题栏
*******************************************************************************}
unit UTitleBar;

interface

uses
  Windows, Classes, Controls, Graphics;

type
  TTitleStyle = (tsHorz, tsVert);
  //水平,垂直

  TZnTitleBar = class(TGraphicControl)
  private
    FTitle: string;
    FStyle: TTitleStyle;
    FNewFont: TFont;

    FActive: Boolean;
    FBackImage: TBitmap;
    FColorS,FColorE: TColor;
  protected
    procedure PaintBackgroud;
    procedure Paint; override;
    procedure SetStyle(const nStyle: TTitleStyle);
    procedure SetActive(const nValue: Boolean);
    procedure CreateLogicFont;
    procedure DestroyLogicFont;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Font;
    property Active: Boolean read FActive write SetActive;
    property ColorStart: TColor read FColorS write FColorS;
    property ColorEnd: TColor read FColorE write FColorE;
    property Title: string read FTitle write FTitle;
    property Style: TTitleStyle read FStyle write SetStyle;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('RunSoft', [TZnTitleBar]);
end;

constructor TZnTitleBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 21;
  Height := 21;

  FNewFont := nil;
  FTitle := 'Title';
  FStyle := tsHorz;

  FActive := False;
  FColorS := $818181;
  FColorE := $C0C0C0;
  FBackImage := TBitmap.Create;
end;

destructor TZnTitleBar.Destroy;
begin
  DestroyLogicFont;
  FBackImage.Free;
  inherited;
end;

procedure TZnTitleBar.SetStyle(const nStyle: TTitleStyle);
begin
  if FStyle <> nStyle then
  begin
    FStyle := nStyle;
    if FStyle = tsVert then CreateLogicFont;
    if FStyle = tsHorz then DestroyLogicFont;
  end;
end;

procedure TZnTitleBar.SetActive(const nValue: Boolean);
var nColor: TColor;
begin
  if nValue <> FActive then
  begin
    FActive := nValue;
    if FActive then
    begin
      FColorS := $6A240A;
      FColorE := $EFC9A5;
    end else
    begin
      FColorS := $818181;
      FColorE := $C0C0C0;
    end;

    if FStyle = tsVert then
    begin
      nColor := FColorS;
      FColorS := FColorE;
      FColorE := nColor;
    end;
    Invalidate;
  end;
end;

//Desc: 创建逻辑字体
procedure TZnTitleBar.CreateLogicFont;
var nFont: TLogFont;
begin
  if not Assigned(FNewFont) then
    FNewFont := TFont.Create;
  FNewFont.Assign(Font);

  GetObject(Font.Handle, SizeOf(nFont), @nFont);
  nFont.lfEscapement := 90 * 10;
  nFont.lfPitchAndFamily := FIXED_PITCH or FF_DONTCARE;
  FNewFont.Handle := CreateFontIndirect(nFont);
end;

//Desc: 释放逻辑字体
procedure TZnTitleBar.DestroyLogicFont;
begin
  if Assigned(FNewFont) then
  begin
    FNewFont.Free;
    FNewFont := nil;
  end;
end;

//Desc: 绘制
procedure TZnTitleBar.Paint;
var nL,nT: integer;
begin
  if FStyle = tsVert then
  begin
    PaintBackgroud;
    Canvas.Font.Assign(FNewFont);
    SetBKMode(Canvas.Handle, TransParent);

    nL := Round((Width - Canvas.TextHeight(FTitle)) / 2 );
    nT := ClientRect.Bottom - 2;
    Canvas.TextOut(nL, nT, FTitle);
  end else

  if FStyle = tsHorz then
  begin
    PaintBackgroud;
    Canvas.Font.Assign(Font);
    SetBKMode(Canvas.Handle, TransParent);

    nT := Round((Height - Canvas.TextHeight(FTitle)) / 2 );
    Canvas.TextOut(ClientRect.Left + 2, nT, FTitle); 
  end;
end;

//Desc: 绘制背景
procedure TZnTitleBar.PaintBackgroud;
var I: integer;
    nR,nG,nB:Byte;
    nColorRect:TRect;

    FromR, FromG, FromB : Integer;
    DiffR, DiffG, DiffB : Integer;
begin
  FBackImage.Width := Width;
  FBackImage.Height := Height;

  FromR := FColorS and $000000ff;
  FromG := (FColorS shr 8) and $000000ff;
  FromB := (FColorS shr 16) and $000000ff;
  DiffR := (FColorE and $000000ff) - FromR;
  DiffG := ((FColorE shr 8) and $000000ff) - FromG;
  DiffB := ((FColorE shr 16) and $000000ff) - FromB;

  if FStyle = tsHorz then
  begin
    nColorRect.Top := 0;
    nColorRect.Bottom := FBackImage.Height;
    
    for I := 0 to 255 do
    begin
      nColorRect.Left := MulDiv (I, FBackImage.Width, 256);
      nColorRect.Right := MulDiv (I + 1, FBackImage.Width, 256);
      nR := FromR + MulDiv(I, Diffr, 255);
      nG := FromG + MulDiv(I, Diffg, 255);
      nB := FromB + MulDiv(I, Diffb, 255);
      FBackImage.Canvas.Brush.Color := RGB(nR, nG, nB);
      FBackImage.Canvas.FillRect(nColorRect);
    end;
  end else

  if FStyle = tsVert then
  begin
    nColorRect.Left := 0;
    nColorRect.Right := FBackImage.Width;

    for I := 0 to 255 do
    begin
      nColorRect.Top:= MulDiv (I, FBackImage.Height, 256);
      nColorRect.Bottom:= MulDiv (I + 1, FBackImage.Height, 256);
      nR := Fromr + MulDiv(I, Diffr, 255);
      nG := Fromg + MulDiv(I, Diffg, 255);
      nB := Fromb + MulDiv(I, Diffb, 255);
      FBackImage.Canvas.Brush.Color := RGB(nR, nG, nB);
      FBackImage.Canvas.FillRect(nColorRect);
    end;
  end;

  Canvas.StretchDraw(ClientRect, FBackImage);
end;

end.
