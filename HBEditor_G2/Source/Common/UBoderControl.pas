{*******************************************************************************
  作者: dmzn 2009-2-2
  描述: 带边框的自绘控件
*******************************************************************************}
unit UBoderControl;

interface

uses
  Windows, Classes, Controls, ExtCtrls, Graphics, SysUtils;

type
  TZnBorderControl = class(TCustomControl)
  private
    FHasBorder: Boolean;
    //是否边框
    FBorderSpeed: Byte;
    //边框速度
    FBorderWidth: Byte;
    FBorderHeight: Byte;
    //边框宽度
    FBorderColor: TColor;
    //边框颜色
    FBorderEffect: Byte;
    //特效
  protected
    procedure SetBorderColor(const Value: TColor);
    procedure SetBorderWidth(const Value: Byte);
    procedure SetHasBorder(const Value: Boolean);

    procedure PaintLine(const nBegin,nEnd: TPoint);
    procedure PaintBorder;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    function ValidClientRect: TRect;
    property HasBorder: Boolean read FHasBorder write SetHasBorder;
    property BorderSpeed: Byte read FBorderSpeed write FBorderSpeed;
    property BorderWidth: Byte read FBorderWidth write SetBorderWidth;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property BorderEffect: Byte read FBorderEffect write FBorderEffect;
    property OnClick;
    property Font;
  end;

implementation

constructor TZnBorderControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered := True;
  ControlStyle := ControlStyle + [csAcceptsControls];

  FHasBorder := False;
  FBorderSpeed := 5;
  FBorderWidth := 1;
  FBorderHeight := 1;
  FBorderEffect := 0;
  FBorderColor := clYellow;   
end;

procedure TZnBorderControl.SetBorderColor(const Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value; Invalidate;
  end;
end;

procedure TZnBorderControl.SetBorderWidth(const Value: Byte);
begin
  if FBorderWidth <> Value then
  begin
    FBorderWidth := Value; Invalidate;
  end;
end;

procedure TZnBorderControl.SetHasBorder(const Value: Boolean);
begin
  if FHasBorder <> Value then
  begin
    FHasBorder := Value; Invalidate;
  end;
end;

//Desc: 有效区域
function TZnBorderControl.ValidClientRect: TRect;
begin
  Result := ClientRect;
  if FHasBorder then
       InflateRect(Result, -3 - FBorderHeight, -3 - FBorderHeight)
  else InflateRect(Result, -3, -3);
end;

//Desc: 自绘过程
procedure TZnBorderControl.Paint;
begin
  with Canvas do
  begin
    Brush.Color := $00643333;
    FillRect(ClientRect);

    Pen.Width := 1;
    Pen.Style := psSolid;

    Pen.Color := $00C8D0D4;
    MoveTo(0, Height);
    LineTo(0, 0);
    LineTo(Width, 0);
    //左,上

    Pen.Color := clWhite;
    MoveTo(Width, 1);
    LineTo(1, 1);
    LineTo(1, Height);
    //上,左

    Pen.Color := $00C8D0D4;
    MoveTo(2, Height);
    LineTo(2, 2);
    LineTo(Width - 2, 2);
    //左,上

    Pen.Color := $00404040;
    MoveTo(Width - 1, 0);
    LineTo(Width - 1, Height - 1);
    LineTo(0, Height - 1);
    //右,下

    Pen.Color := $00808080;
    MoveTo(1, Height - 2);
    LineTo(Width - 2, Height - 2);
    LineTo(Width - 2, 1);
    //下,右

    Pen.Color := $00C8D0D4;
    MoveTo(Width - 3, 2);
    LineTo(Width - 3, Height - 3);
    LineTo(2, Height - 3);
    //右,下

    if FHasBorder then PaintBorder;
    //绘制边框
  end;
end;

//Desc: 绘制边线
procedure TZnBorderControl.PaintLine(const nBegin,nEnd: TPoint);
var nL,nT: Integer;
begin
  Canvas.MoveTo(nBegin.X, nBegin.Y);

  if nBegin.X = nEnd.X then
  begin
    nL := nBegin.X;
    nT := nBegin.Y + FBorderWidth;

    while nT < nEnd.Y do
    begin
      Canvas.LineTo(nL, nT);
      nT := nT + 8 - FBorderWidth;

      Canvas.MoveTo(nL, nT);
      nT := nT + FBorderWidth;
    end;

    Canvas.LineTo(nEnd.X, nEnd.Y);
  end else

  if nBegin.Y = nEnd.Y then
  begin
    nT := nBegin.Y;
    nL := nBegin.X + FBorderWidth;

    while nL < nEnd.X do
    begin
      Canvas.LineTo(nL, nT);
      nL := nL + 8 - FBorderWidth;

      Canvas.MoveTo(nL, nT);
      nL := nL + FBorderWidth;
    end;

    Canvas.LineTo(nEnd.X, nEnd.Y);
  end;
end;

//Desc: 绘制边框
procedure TZnBorderControl.PaintBorder;
var nR: TRect;
begin
  Canvas.Pen.Color := FBorderColor;
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Width := FBorderHeight;

  nR := ValidClientRect;
  InflateRect(nR, FBorderHeight, FBorderHeight);

  with nR  do
  begin
    PaintLine(Point(Left, Top), Point(Right, Top));
    PaintLine(Point(Left, Bottom-FBorderHeight), Point(Right, Bottom-FBorderHeight));
    PaintLine(Point(Left, Top), Point(Left, Bottom));
    PaintLine(Point(Right-FBorderHeight, Top), Point(Right-FBorderHeight, Bottom));
  end;
end;

end.
