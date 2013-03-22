unit Voltmeter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TVoltmeter = class(TCustomControl)
  private
      fRatio:double;
      fNeedleColor:TColor;
  protected
    { Protected declarations }
    fx1,fx2,fy1,fy2,
    fByd,
    fx0,fy0,
    fw,fh,
    fr1,fr2,fr3,
    fvi,fv0,fwvi,fvd,fvu,
    tx1,tx2,ty1,ty2:integer;

    fIsPaint:boolean;

    fMin,fMax,fMid,fvalue,fWarnV,fDownV,fUpV:Double;
    fMeter,fmins,fmaxs,fmids:String;
    fColor:TColor;
    fDecimal:Integer;
    fDecimal2:Integer;
    fWarn,fDisp:Boolean;
    procedure paint; Override;
    procedure SetParameters; virtual;
    procedure setMax(v:double);
    procedure setMin(v:double);
    procedure setValue(v:double);
    procedure setWarnV(v:double);
    procedure setDownV(v:double);
    procedure setUpV(v:double);
    procedure setColor(c:Tcolor);
    procedure setMeter(vs:string);
    procedure DrawNeedle; virtual;
    procedure SetDisp(b:boolean); virtual;
    procedure SetWarn(b:boolean); virtual;
    procedure DrawLabel;
    procedure DrawText; virtual;
  public
    { Public declarations }
    WarnB:boolean;
    constructor create(AOwner:TComponent); override;
  published
    { Published declarations }
    property MaxValue:double read fMax write setMax;
    property MinValue:double read fMin write setMin;
    property Decimal:integer read fDecimal write fDecimal;
    property Decimal2:integer read fDecimal2 write fDecimal2;
    property Value:double    read fValue   write SetValue;
    property Color:Tcolor    read fColor   write SetColor;
    property NeedleColor:TColor read fNeedleColor write fNeedleColor;
    property GageUnit:String read fMeter   write SetMeter;
    Property Warning:boolean read fWarn    write SetWarn;
    Property DispCap:boolean read fDisp    write SetDisp;
    property ZeroValue:integer read fv0 write fv0;
    Property WarnValue:Double read fWarnv write SetWarnv;
    Property DownValue:Double read fDownV write SetDownv;
    Property UpValue:Double read fUpV write SetUpv;
  published
    { Published declarations }
    Property OnClick;
    Property OnDblClick;
    property Caption;
    property Font;
    property Visible;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('RunSoft', [TVoltmeter]);
end;

var
  cosx,sinx: array[-1..181] of Double;

Constructor Tvoltmeter.Create;
begin
     inherited create(Aowner);
     DoubleBuffered := True;
     parentFont:=false;

     width:=190;
     height:=172;
     fDisp:=true;
     SetParameters;
     fv0:=-11;
     fvi:=0;
     fmax:=100;
     fmin:=0;
     fmid:=50;
     fwvi:=0;
     fratio:=180/(fmax-fmin);
     fmins:='0';
     fmaxs:='100';
     fmids:='50';
     fcolor:=clInfoBk;
     fMeter:='V';
     font.Size:=12;
     WarnB:=true;
     fNeedleColor:=clFuchsia;
end;

procedure Tvoltmeter.SetParameters;
begin
     fByd:=4;
     fw:=width-fByd-fByd;
     fh:=fw div 2;
     fx0:=width div 2;
     fy0:=fByd+fh;
     fx1:=fByd;
     fy1:=fByd;
     fx2:=fw+fByd;
     fy2:=fh+fByd+8;
     fr1:=fh;fr2:=fh-5; fr3:=fh-8;

     tx1:=fByd;
     ty1:=fy2+fByd;
     tx2:=width-fByd;
     ty2:=ty1+20;
end;

procedure Tvoltmeter.SetDisp;
begin
     if b=fDisp then exit;
     fdisp:=b;
     if b then height:=200 else height:=162;
     if b then width :=220 else width:=172;
     setParameters;
     invalidate;
end;

procedure Tvoltmeter.SetWarn;
begin
     if b=fWarn then exit;
     fWarn:=b;
     invalidate;
end;

procedure Tvoltmeter.SetValue;
var nvi:integer;
begin
     if fValue=v then
     begin
        //DrawText;
        exit;
     end;
     fValue:=v;
     nvi:=round(fratio*(v-fmin));
     if nvi<-1 then nvi:=-1;
     if nvi>181 then nvi:=181;
     fvi:=nvi;
     //DrawNeedle;
     Invalidate;
end;

procedure Tvoltmeter.SetWarnV;
begin
     fWarnV:=v;
     fWvi:=round(fratio*(v-fmin));
     if fwvi<-1  then fwvi:=-1;
     if fwvi>181 then fwvi:=181;
     Invalidate;
end;

procedure Tvoltmeter.SetDownV;
begin
     fDownV:=v;
     fvD:=round(fratio*(v-fmin));
     if fvD<-1  then fvD:=-1;
     if fvD>181 then fvD:=181;
     Invalidate;
end;

procedure Tvoltmeter.SetUpV;
begin
     fUpV:=v;
     fvU:=round(fratio*(v-fmin));
     if fvU<-1  then fvU:=-1;
     if fvU>181 then fvU:=181;
     Invalidate;
end;

procedure Tvoltmeter.SetMax;
begin
     fMax:=v;
     if fmin>v then fmin:=v-1;
     fmid:=(fmin+fmax)/2;
     fratio:=180/(fmax-fmin);
     fmaxs:=Floattostrf(fmax,fffixed,10,fdecimal);
     fmins:=Floattostrf(fmin,fffixed,10,fdecimal);
     fmids:=Floattostrf(fmid,fffixed,10,fdecimal);
     invalidate;
end;

procedure Tvoltmeter.SetMin;
begin
     fMin:=v;
     if fmax<v then fmax:=v+1;
     fmid:=(fmin+fmax)/2;
     fratio:=180/(fmax-fmin);
     fmaxs:=Floattostrf(fmax,fffixed,10,fdecimal);
     fmins:=Floattostrf(fmin,fffixed,10,fdecimal);
     fmids:=Floattostrf(fmid,fffixed,10,fdecimal);
     invalidate;
end;

procedure Tvoltmeter.SetColor;
begin
     if fColor=c then exit;
     fColor:=c;
     invalidate;
end;

procedure Tvoltmeter.SetMeter;
begin
     fmeter:=vs;
     invalidate;
end;

procedure Tvoltmeter.paint;
var j,x,y,n1,n2,n3,n4:integer;
    vfont:Tfont;
begin
    Inherited;
    canvas.pen.Width:=1;
    canvas.brush.Color:=clBtnface;
    canvas.pen.Color:=clBtnShadow;
    canvas.Rectangle(0,0,width,height);//fx0,fy0,fw+fx0,fh+fy0);
    canvas.pen.Color:=clWhite;
    canvas.MoveTo(width-2,0);
    canvas.LineTo(0,0);
    canvas.LineTo(0,height-1);

    canvas.brush.Color:=fColor;
    canvas.pen.Color:=clWhite;
    canvas.Rectangle(fx1,fy1,fx2,fy2);//fx0,fy0,fw+fx0,fh+fy0);
    canvas.pen.Color:=clBtnShadow;
    canvas.MoveTo(fx2-2,fy1);
    canvas.LineTo(fx1,fy1);
    canvas.LineTo(fx1,fy2-1);

    if fDownv<>fUpv then begin
       x:=fx0-round((fr1-1)*cosx[fvD]);
       y:=fy0-round((fr1-1)*sinx[fvD]);
       n1:=x;
       n2:=y;

       x:=fx0-round((fr1-1)*cosx[fvU]);
       y:=fy0-round((fr1-1)*sinx[fvU]);
       n3:=x;
       n4:=y;

       Canvas.pen.Width:=5;
       Canvas.pen.Color:=clAqua;
       Canvas.Arc(6,6,width-6,width-6,n3,n4,n1,n2);

       Canvas.pen.Width:=3;
       Canvas.pen.Color:=clRed;
       canvas.moveto(n1,n2);
       x:=fx0-round((fr2+1)*cosx[fvD]);
       y:=fy0-round((fr2+1)*sinx[fvD]);
       canvas.lineto(x,y);

       Canvas.pen.Width:=3;
       Canvas.pen.Color:=clRed;
       canvas.moveto(n3,n4);
       x:=fx0-round((fr2+1)*cosx[fvU]);
       y:=fy0-round((fr2+1)*sinx[fvU]);
       canvas.lineto(x,y);
    end;
    {}
    canvas.pen.Width:=1;
    canvas.pen.Color:=0;
    for j:=0 to 18 do begin
        x:=fx0-round(fr1*cosx[j*10]);
        y:=fy0-round(fr1*sinx[j*10]);
        canvas.moveto(x,y);
        x:=fx0-round(fr2*cosx[j*10]);
        y:=fy0-round(fr2*sinx[j*10]);
        canvas.lineto(x,y);
    end;

    if fwvi>0 then begin   // ¾¯½äÖµ
      Canvas.pen.Width:=2;
      Canvas.pen.Color:=clRed;
      x:=fx0-round(fr1*cosx[fwvi]);
      y:=fy0-round(fr1*sinx[fwvi]);
      canvas.moveto(x,y);
      x:=fx0-round(fr2*cosx[fwvi]);
      y:=fy0-round(fr2*sinx[fwvi]);
      canvas.lineto(x,y);
    end;
   {}

    canvas.brush.style:=bsClear;
    canvas.font.color:=clBlack;
    canvas.textout(fx1+8,fy0-5,fmins);
    x:=canvas.TextWidth(fmaxs);
    canvas.textout(fx2-8-x,fy0-5,fmaxs);
    x:=canvas.TextWidth(fmids) div 2;
    canvas.textout(fx0-x,fbyd+6,fmids);
    x:=canvas.TextWidth(fMeter) div 2;
    canvas.textout(fx0-x,fbyd+16,fMeter);
    canvas.brush.style:=bsSolid;

    canvas.pen.Width:=1;
    canvas.brush.Color:=clBlack;
    canvas.pen.Color:=clBlack;
    canvas.Ellipse(fx0-3,fy0-3,fx0+3,fy0+3);

//  DrawText;
    fIsPaint:=False;
    DrawNeedle;
    fIsPaint:=True;

    if fDisp then begin
       canvas.brush.color:=clBtnFace;
       vfont:=Tfont.Create;
       vfont.Assign(canvas.font);
       canvas.font.Assign(font);
       x:=canvas.TextWidth(caption) div 2;
       y:=canvas.TextHeight(caption);
       canvas.textout(fx0-x,height-y-5,caption);
       canvas.font.Assign(vFont);
       vfont.Destroy;
    end;
end;

procedure TVoltmeter.DrawLabel;
var x,y:integer;
begin
    canvas.brush.style:=bsClear;
    canvas.font.color:=clBlack;
    canvas.textout(fx1+8,fy0-5,fmins);
    x:=canvas.TextWidth(fmaxs);
    canvas.textout(fx2-8-x,fy0-5,fmaxs);
    x:=canvas.TextWidth(fmids) div 2;
    canvas.textout(fx0-x,fbyd+6,fmids);
    x:=canvas.TextWidth(fMeter) div 2;
    canvas.textout(fx0-x,fbyd+16,fMeter);
    canvas.brush.style:=bsSolid;

    canvas.pen.Width:=1;
    canvas.brush.Color:=clBlack;
    canvas.pen.Color:=clBlack;
    canvas.Ellipse(fx0-3,fy0-3,fx0+3,fy0+3);
end;

procedure TVoltmeter.DrawNeedle;
   procedure draw(xv:integer; cl:TColor);
   var x,y:integer;
       OldC:Tcolor;
       OldMode:TpenMode;
   begin
       if xv<-1 then xv:=-1;
       if xv>181 then xv:=181;
       fv0:=xv;
       canvas.pen.Width:=2;

       OldC:=canvas.pen.color;
       OldMode:=canvas.pen.Mode;

       canvas.pen.color:=cl;  //fNeedleColor; // clGreen;
       x:=fx0-round(fr3*cosx[xv]);
       y:=fy0-round(fr3*sinx[xv]);

       //canvas.pen.mode:=pmXor;
       canvas.moveto(x,y);
       canvas.lineto(fx0,fy0);

       canvas.pen.mode:=OldMode;
       canvas.pen.color:=OldC;
   end;
begin
     if fIsPaint then draw(fv0,fColor);
     DrawLabel;
     Draw(fVi,fNeedleColor);
     DrawText;
end;

procedure TVoltmeter.DrawText;
var j,ts:integer;
    s:string;
begin
     canvas.font.color:=clBlack;
     inc(j);
     if fWarn
     then begin
          if j>20 then begin
             j:=0;
             if WarnB
             then begin
                  canvas.brush.Color:=clRed;
                  WarnB:=not WarnB;
             end else begin
                  canvas.brush.Color:=fColor;
                  WarnB:=not WarnB;
             end;
          end;
     end
     else canvas.brush.Color:=fColor;
     canvas.pen.Color:=clWhite;
     canvas.Rectangle(tx1,ty1,tx2,ty2);//fx0,fy0,fw+fx0,fh+fy0);
     canvas.pen.Color:=clBtnShadow;
     canvas.MoveTo(tx2-2,ty1);
     canvas.LineTo(tx1,ty1);
     canvas.LineTo(tx1,ty2-1);
     s:=Floattostrf(fvalue,fffixed,10,fDecimal2)+' '+fmeter;
     ts:=(tx2-tx1-canvas.TextWidth(s)) div 2;
     canvas.TextOut(tx1+ts,ty1+3,s);
end;

var
  j: Integer;
initialization
  for j:=0 to 180 do
  begin
    sinx[j]:=Sin(j/180*pi);
    cosx[j]:=cos(j/180*pi);
  end;

  sinx[-1]:=Sin(-5/180*pi);
  sinx[181]:=Sin(185/180*pi);
  cosx[-1]:=Cos(-5/180*pi);
  cosx[181]:=cos(185/180*pi);
end.