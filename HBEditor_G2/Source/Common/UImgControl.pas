{*******************************************************************************
  作者: dmzn 2009-2-2
  描述: 带图片平铺功能的自绘组件
*******************************************************************************}
unit UImgControl;

interface

uses
  Windows, Classes, Controls, Graphics, SysUtils;

type
  TZnImageControl = class(TGraphicControl)
  private
    FImage: TPicture;
  protected
    procedure Paint; override;
    procedure SetImage(const nImage: TPicture);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Color;
    property Image: TPicture read FImage write SetImage;
    property OnClick;
  end;

implementation

constructor TZnImageControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Color := clWhite;
  FImage := TPicture.Create;
end;

destructor TZnImageControl.Destroy;
begin
  FImage.Free;
  inherited;
end;

//Desc: 自绘过程
procedure TZnImageControl.Paint;
var nL,nT: integer;
begin
  if FImage.Width < 1 then
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect(ClientRect); Exit;
  end;

  nL := 0;
  while nL < Width do
  begin
    nT := 0;
    while nT < Height do
    begin
      Canvas.Draw(nL, nT, FImage.Graphic);
      Inc(nT, FImage.Height);
    end;

    Inc(nL, FImage.Width);
  end;
end;

//Desc: 设置图片
procedure TZnImageControl.SetImage(const nImage: TPicture);
begin
  FImage.Assign(nImage);
end;

end.
