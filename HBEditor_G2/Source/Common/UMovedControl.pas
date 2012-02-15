{*******************************************************************************
  作者: dmzn 2009-2-2
  描述: 可移动的自绘控件
*******************************************************************************}
unit UMovedControl;

interface

uses
  Windows, Classes, Controls, Graphics, SysUtils, Forms, UBoderControl;

type
  TMarkerType = (mtNone, mtSizeW, mtSizeE, mtSizeN, mtSizeS,
                 mtSizeNW, mtSizeNE, mtSizeSW, mtSizeSE);
  //控制域类型

  TMarker = record
    FRect: TRect;
    //控制区域
    FType: TMarkerType;
    //控制域类型
  end;

  TMarkers = array[0..7] of TMarker;
  //控件的控制域

  TZnMovedStatus = (msNone, msMove, msResize);
  //控件状态

  TOnSizeChanged = procedure (nNewW,nNewH: integer; nIsApplyed: Boolean) of Object;

  TZnMovedControl = class(TGraphicControl)
  private
    FShortName: string;
    {*助记标签*}
    FSelected: Boolean;
    FOldPoint: TPoint;
    FStatus: TZnMovedStatus;
    {*选择移动*}
    FOldW,FOldH: integer;
    FNewW,FNewH: integer;
    FOldT,FOldL: integer;
    FNewT,FNewL: integer;
    FPCanvas: TControlCanvas;
    {*大小区域*}
    FMarkers: TMarkers;
    FActiveMarker: TMarkerType;
    {*变量相关*}
    FModeEnter: Byte;
    FModeExit: Byte;
    //进出场模式
    FSpeedEnter: Byte;
    FSpeedExit: Byte;
    //进出场速度
    FKeedTime: Byte;
    FModeSerial: Byte;
    //停留时间,跟随前屏
    F8Bit_LTWH: Boolean;
    //8bit宽高
    FOnMoved: TNotifyEvent;
    FOnSelected: TNotifyEvent;
    FOnSizeChanged: TOnSizeChanged;
    {*事件相关*}
  protected
    procedure SetSelected(const nValue: Boolean);
    procedure SetMouseCursor(const nPoint: TPoint);
    {*设置鼠标指针*}
    procedure ChangeWidthHeight(const X,Y: integer);
    {*设置宽高*}

    procedure Paint; override;
    {*自绘*}
    procedure Resize;override;
    {*更新控制点*}
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure DoMouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure DoMouseMove(Shift: TShiftState; X, Y: Integer); 
    {*鼠标移动*}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {*创建释放*}
    procedure DoPaint(const nCanvas: TCanvas; const nRect: TRect); virtual;
    {*子类绘制细节*}
  published
    property ShortName: string read FShortName write FShortName;
    property Selected: Boolean read FSelected write SetSelected;
    property OnSelected: TNotifyEvent read FOnSelected write FOnSelected;
    property OnMoved: TNotifyEvent read FOnMoved write FOnMoved;
    property OnSizeChanged: TOnSizeChanged read FOnSizeChanged write FOnSizeChanged;
    {*标准属性*}
    property Byte_LTWH: Boolean read F8Bit_LTWH write F8Bit_LTWH;
    property ModeEnter: Byte read FModeEnter write FModeEnter;
    property ModeExit: Byte read FModeExit write FModeExit;
    property SpeedEnter: Byte read FSpeedEnter write FSpeedEnter;
    property SpeedExit: Byte read FSpeedExit write FSpeedExit;
    property KeedTime: Byte read FKeedTime write FKeedTime;
    property ModeSerial: Byte read FModeSerial write FModeSerial;
    {*扩展相关*}
    property ParentFont;
    property Font;
    property Color;
    property PopupMenu;
    property OnClick;
    property OnDblClick;
    property OnResize; 
    {*基类属性*}
  end;

implementation

const
  MinClientHW = 8;
  //最小宽高

  MarkerClientHW = 3;
  //控制区域的大小,左右边线为宽,上下边线为高,四个定点为正方形
  
  MarkerCursors: array[TMarkerType] of TCursor = (crDefault,
                  crSizeWE, crSizeWE, crSizeNS, crSizeNS, crSizeNWSE,
                  crSizeNESW, crSizeNESW, crSizeNWSE);
  //控制点所对应的鼠标指针

//Date: 2009-02-03
//Name: CreateMarkers
//Parm: 某个方形区域,正常情况下为控件有效区域
//Desc: 为nRect边界添加八个控制点
function CreateMarkers(const nRect: TRect): TMarkers;
begin
  with Result[0], nRect do     //north-west
  begin
    FRect := Rect(Left, Top, Left + MarkerClientHW, Top + MarkerClientHW);
    FType := mtSizeNW;
  end;

  with Result[1], nRect do     //north
  begin
    FRect.TopLeft := Point(Left + MarkerClientHW, Top);
    FRect.BottomRight := Point(Right - MarkerClientHW, Top + MarkerClientHW);
    FType := mtSizeN;
  end;

  with Result[2], nRect do     //north-east
  begin
    FRect.TopLeft := Point(Right - MarkerClientHW, Top);
    FRect.BottomRight := Point(Right, Top + MarkerClientHW);
    FType := mtSizeNE;
  end;

  with Result[3], nRect do     //west
  begin
    FRect.TopLeft := Point(Left, Top + MarkerClientHW);
    FRect.BottomRight := Point(Left + MarkerClientHW, Bottom - MarkerClientHW);
    FType := mtSizeW;
  end;

  with Result[4], nRect do     //east
  begin
    FRect.TopLeft := Point(Right - MarkerClientHW, Top + MarkerClientHW);
    FRect.BottomRight := Point(Right, Bottom - MarkerClientHW);
    FType := mtSizeE;
  end;

  with Result[5], nRect do     //south-west
  begin
    FRect.TopLeft := Point(Left, Bottom - MarkerClientHW);
    FRect.BottomRight := Point(Left + MarkerClientHW, Bottom);
    FType := mtSizeSW;
  end;

  with Result[6], nRect do     //south
  begin
    FRect.TopLeft := Point(Left + MarkerClientHW, Bottom - MarkerClientHW);
    FRect.BottomRight := Point(Right - MarkerClientHW, Bottom);
    FType := mtSizeS;
  end;

  with Result[7], nRect do     //south-east
  begin
    FRect.TopLeft := Point(Right - MarkerClientHW, Bottom - MarkerClientHW);
    FRect.BottomRight := Point(Right, Bottom);
    FType := mtSizeSE;
  end;
end;

//Desc: 依据nPoint设置鼠标的指针,主要针对控制点
procedure TZnMovedControl.SetMouseCursor(const nPoint: TPoint);
  var i: integer;
begin
  FActiveMarker := mtNone;
  if FSelected then
  begin
    for i:=High(FMarkers) downto Low(FMarkers) do
     if PtInRect(FMarkers[i].FRect, nPoint) then
     begin
       FActiveMarker := FMarkers[i].FType; Break;
     end;
  end;

  Cursor := MarkerCursors[FActiveMarker];
end;

//Desc: 依据鼠标位置x,y确定宽高
procedure TZnMovedControl.ChangeWidthHeight(const X, Y: integer);
var nR: TRect;
    nInt: integer;
begin
  if not Assigned(FPCanvas) then Exit;
  FPCanvas.Rectangle(FNewL,FNewT,FNewL+FNewW,FNewT+FNewH);
  {Erase old draw}

  case FActiveMarker of
   mtSizeW,
   mtSizeNW,
   mtSizeSW:
    begin
      FNewW := FOldW - X + FOldPoint.X;
      FNewL := FOldL + X - FOldPoint.X;
    end;
   mtSizeE,
   mtSizeNE,
   mtSizeSE: FNewW := FOldW + X - FOldPoint.X
  end;
  {Calculate New Width}

  case FActiveMarker of
   mtSizeN,
   mtSizeNW,
   mtSizeNE:
    begin
      FNewH := FOldH - Y + FOldPoint.Y;
      FNewT := FOldT + Y - FOldPoint.Y
    end;
   mtSizeS,
   mtSizeSW,
   mtSizeSE: FNewH := FOldH + Y - FOldPoint.Y;
  end;
  {Calculate New Top-Height}

  if (Parent is TZnBorderControl) then
  begin
    nInt := FOldL + FOldW; //右边线
    if nInt - FNewL < MinClientHW then FNewL := nInt - MinClientHW;

    nInt := FOldT + FOldH; //下边线
    if nInt - FNewT < MinClientHW  then FNewT := nInt - MinClientHW;

    nR := TZnBorderControl(Parent).ValidClientRect;
    if FNewL < nR.Left then
    begin
      FNewW := FNewW - (nR.Left - FNewL);
      FNewL := nR.Left;
    end;

    if FNewL + FNewW > nR.Right then
      FNewW := nR.Right - FNewL;
    //xxxxx

    if FNewT < nR.Top then
    begin
      FNewH := FNewH - (nR.Top - FNewT);
      FNewT := nR.Top;
    end;
    
    if FNewT + FNewH > nR.Bottom then
      FNewH := nR.Bottom - FNewT;
    //xxxxx

    if FNewW < MinClientHW then FNewW := MinClientHW;
    if FNewH < MinClientHW then FNewH := MinClientHW;
  end;

  if F8Bit_LTWH then
  begin
    if FNewW mod 8 <> 0 then
    begin
      nInt := FNewW;

      if FNewW > Width then
           FNewW := (Trunc(FNewW / 8) + 1) * 8
      else FNewW := Trunc(FNewW / 8) * 8;

      case FActiveMarker of
       mtSizeW,mtSizeNW,mtSizeSW: FNewL := FNewL + (nInt - FNewW);
      end;
    end;
  {
    if FNewH mod 8 <> 0 then
    begin
      nInt := FNewH;

      if FNewH > Height then
           FNewH := (Trunc(FNewH / 8) + 1) * 8
      else FNewH := Trunc(FNewH / 8) * 8;

      case FActiveMarker of
       mtSizeN,mtSizeNW,mtSizeNE: FNewT := FNewT + (nInt - FNewH);
      end;
    end;
  }
  end;

  FPCanvas.Rectangle(FNewL,FNewT,FNewL+FNewW,FNewT+FNewH);
  {Parent Container Draw Rectangle}
  if Assigned(FOnSizeChanged) then FOnSizeChanged(FNewW, FNewH, False);
end;

//------------------------------------------------------------------------------
constructor TZnMovedControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 64;
  Height := 64;
  Color := clBlack;

  FStatus := msNone;
  FSelected := False;
  FActiveMarker := mtNone;
  
  F8Bit_LTWH := True;
  FModeEnter := 0;
  FModeExit := 0;

  FSpeedEnter := 0;
  FSpeedExit := 0;

  FKeedTime := 0;
  FModeSerial := 1;
end;

destructor TZnMovedControl.Destroy;
begin
  if Assigned(FPCanvas) then FPCanvas.Free;
  inherited;
end;

//Desc: 自绘过程
procedure TZnMovedControl.Paint;
begin
  with Canvas do
  begin
    if FStatus = msNone then
    begin
      DoPaint(Canvas, ClientRect);
    end else   //子类绘制
    begin
      Brush.Color := Color;
      FillRect(ClientRect);
    end;
    
    if Selected then
    begin
      Brush.Style := bsClear;
      Pen.Color := clYellow;
      Pen.Width := 1;
      Rectangle(ClientRect);
    end;
  end;
end;  

//Desc: 子类向nCanvas画布绘制有效内容
procedure TZnMovedControl.DoPaint(const nCanvas: TCanvas; const nRect: TRect);
begin
  nCanvas.Brush.Color := Color;
  nCanvas.FillRect(nRect);
end;

//------------------------------------------------------------------------------
procedure TZnMovedControl.DoMouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Selected := True;
  if Button <> mbLeft then Exit;


  FOldPoint := Point(X, Y);
  if FActiveMarker = mtNone then
  begin
    FStatus := msMove;
  end else
  begin
    FStatus := msReSize;
    FOldT := Top; FOldL := Left;
    FNewT := Top; FNewL := Left;
    FOldW := Width; FOldH := Height;
    FNewW := Width; FNewH := Height;

    if ( Parent <> nil ) and ( FPCanvas = nil) then
    begin
      FPCanvas := TControlCanvas.Create;
      with FPCanvas do
      begin
        Control := Parent;
        Brush.Style := bsClear;
        Pen.Width := 1;
        Pen.Color := clBlack;
        Pen.Style := psSolid;
        Pen.Mode := pmNotXor;
      end;
    end;
    {Create Canvas as Parent.Canvas}

    if Assigned(FPCanvas) then
      FPCanvas.Rectangle(FNewL,FNewT,FNewL+FNewW,FNewT+FNewH);
    {First Rectangle}
  end;
end;

procedure TZnMovedControl.DoMouseMove(Shift: TShiftState; X, Y: Integer);
var nR: TRect;
    nL,nT: Integer;
begin
  if FStatus = msMove then
  begin
    nL := Left + (X - FOldPoint.X);
    nT := Top + (Y - FOldPoint.Y);
    //new position

    if (Parent is TZnBorderControl) then
    begin
      nR := TZnBorderControl(Parent).ValidClientRect;
      if nL < nR.Left then nL := nR.Left;
      if nL + Width > nR.Right then nL := nR.Right - Width;

      if nT < nR.Top then nT := nR.Top;
      if nT + Height > nR.Bottom then nT := nR.Bottom - Height;
    end;

    Left := nL;
    Top := nT;
    Application.ProcessMessages;
    if Assigned(FOnMoved) then FOnMoved(Self);
    Exit;
  end else //组件移动

  if FStatus = msResize then
  begin
    ChangeWidthHeight(X, Y);
  end else //调整大小

  begin
    SetMouseCursor(Point(X, Y));
    {Change Mouse Cursor}
  end;
end;

procedure TZnMovedControl.DoMouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var nR: TRect;
    nL,nT: integer;
begin
  if FStatus = msMove then
  begin
    if F8Bit_LTWH and (Parent is TZnBorderControl) then
    begin
      nR := TZnBorderControl(Parent).ValidClientRect;
      nL := Left - nR.Left;
      nT := Top - nR.Top;

      if nL mod 8 > 4 then
           nL := (Trunc(nL / 8) + 1) * 8
      else nL := Trunc(nL / 8) * 8;

      if nT mod 8 > 4 then
           nT := (Trunc(nT / 8) + 1) * 8
      else nT := Trunc(nT / 8) * 8;

      nL := nL + nR.Left;
      nT := nT + nR.Top;

      if (nL <> Left) or (nT <> Top) then
      begin
        Left := nL;
        Top := nT;
        if Assigned(FOnMoved) then FOnMoved(Self);
      end;
    end;

    Invalidate;
  end else

  if FStatus = msResize then
  begin
    FPCanvas.Rectangle(FNewL,FNewT,FNewL+FNewW,FNewT+FNewH);
    {Erase old draw}
    FreeAndNil(FPCanvas);

    Left := FNewL;
    Top := FNewT;

    if (Width <> FNewW) or (Height <> FNewH) then
    begin
      Width := FNewW;
      Height := FNewH;

      if Assigned(FOnSizeChanged) then
        FOnSizeChanged(FNewW, FNewH, True);
      {*New Form Size*}
    end;
  end;

  FStatus := msNone;
  BringToFront;
end;

procedure TZnMovedControl.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not (ssDouble in Shift) then
    DoMouseDown(Button, Shift, X, Y);
  inherited;
end;

procedure TZnMovedControl.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  DoMouseMove(Shift, X, Y);
  inherited;
end;

procedure TZnMovedControl.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  DoMouseUp(Button, Shift, X, Y);
  inherited;
end;

//------------------------------------------------------------------------------
procedure TZnMovedControl.SetSelected(const nValue: Boolean);
begin
  if nValue <> FSelected then
  begin
    FSelected := nValue;
    Invalidate;
    if Assigned(FOnSelected) then FOnSelected(Self);
  end;
end;

//Desc: 调整区域
procedure TZnMovedControl.Resize;
begin
  inherited;
  FMarkers := CreateMarkers(ClientRect);
end;

end.

