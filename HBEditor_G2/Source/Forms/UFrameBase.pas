{*******************************************************************************
  作者: dmzn 2009-2-11
  描述: 属性编辑器基类
*******************************************************************************}
unit UFrameBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  UMovedControl, UBoderControl, ComCtrls, StdCtrls, ExtCtrls;

type
  TEditorFrameClass = class of TfFrameBase;

  TfFrameBase = class(TFrame)
    Group1: TGroupBox;
    Edit_Name: TLabeledEdit;
    Edit_X: TLabeledEdit;
    Edit_Y: TLabeledEdit;
    Edit_H: TLabeledEdit;
    Edit_W: TLabeledEdit;
    procedure Edit_NameKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_XKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_XChange(Sender: TObject);
    procedure Edit_XExit(Sender: TObject);
    procedure Edit_NameExit(Sender: TObject);
  protected
    FMovedItem: TZnMovedControl;
    {*待编辑对象*}
    FPItem: TZnBorderControl;
    {*容器对象*}
    procedure DoCreate; virtual;
    procedure DoDestroy; virtual;
    {*创建释放*}
    procedure UpdateWindow; virtual;
    {*更新窗口*}
    procedure DoItemMoved(Sender: TObject); virtual;
    procedure DoItemResized(nNewW,nNewH: integer; nIsApplyed: Boolean); virtual;
    {*相关操作*}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {*创建释放*}
    property MovedItem: TZnMovedControl read FMovedItem;
  end;

procedure SetItemEditor(const nItem: TZnMovedControl; const nClass: TEditorFrameClass;
  const nParent: TWinControl);
//入口函数

implementation

{$R *.dfm}
uses
  UFormMain, ULibFun, UMgrLang;
  
//Desc: 在nParent上创建nItem的编辑器,类型为nClass
procedure SetItemEditor(const nItem: TZnMovedControl; const nClass: TEditorFrameClass;
  const nParent: TWinControl);
var nIdx: integer;
    nFrame: TfFrameBase;
begin
  nFrame := nil;
  for nIdx:=nParent.ControlCount - 1 downto 0 do
   if nParent.Controls[nIdx] is nClass then
   begin
     nFrame := nParent.Controls[nIdx] as TfFrameBase; Break;
   end;

  if not Assigned(nFrame) then
  begin
    nFrame := nClass.Create(nParent);
    gMultiLangManager.SectionID := 'FrameItem';
    gMultiLangManager.TranslateAllCtrl(nFrame);
  end; //new frame

  with nFrame do
  begin
    Parent := nParent;
    Align := alClient;

    FMovedItem := nItem;
    nItem.OnMoved := DoItemMoved;
    nItem.OnSizeChanged := DoItemResized;

    if nItem.Parent is TZnBorderControl then
         FPItem := TZnBorderControl(nItem.Parent)
    else FPItem := nil;

    Visible := True;
    UpdateWindow;
    BringToFront;
  end;
end;

//------------------------------------------------------------------------------ 
constructor TfFrameBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoCreate;
end;

destructor TfFrameBase.Destroy;
begin
  DoDestroy;
  inherited;
end;

//Desc: 创建
procedure TfFrameBase.DoCreate;
begin

end;

//Desc: 释放
procedure TfFrameBase.DoDestroy;
begin

end;

//Desc: 更新窗口信息
procedure TfFrameBase.UpdateWindow;
begin
  DoItemMoved(FMovedItem);
  DoItemResized(FMovedItem.Width, FMovedItem.Height, False);
  
  Edit_Name.Text := FMovedItem.ShortName;
  Edit_Name.Modified := False;
end;

//Desc: 更新左上定点坐标(x,y)
procedure TfFrameBase.DoItemMoved(Sender: TObject);
var nX,nY: integer;
begin
  nX := FMovedItem.Left;
  nY := FMovedItem.Top;

  if Assigned(FPItem) then
  begin
    Dec(nX, FPItem.ValidClientRect.Left);
    Dec(nY, FPItem.ValidClientRect.Top);
  end;

  Edit_X.Text := IntToStr(nX); Edit_X.Modified := False;
  Edit_Y.Text := IntToStr(nY); Edit_Y.Modified := False;
end;

//Desc: 更新大小信息
procedure TfFrameBase.DoItemResized(nNewW,nNewH: integer; nIsApplyed: Boolean);
begin
  Edit_H.Text := IntToStr(nNewH); Edit_H.Modified := False;
  Edit_W.Text := IntToStr(nNewW); Edit_W.Modified := False;
end;

//Desc: 更新名称
procedure TfFrameBase.Edit_NameKeyPress(Sender: TObject; var Key: Char);
var nNode: TTreeNode;
begin
  if Key = Char(VK_Return) then
  begin
    Key := #0;
    FMovedItem.ShortName := Edit_Name.Text;
    nNode := fFormMain.GetMovedItemNode(FMovedItem);
    if Assigned(nNode) then nNode.Text := Edit_Name.Text;  
  end;
end;

procedure TfFrameBase.Edit_NameExit(Sender: TObject);
var nChar: Char;
begin
  with TEdit(Sender) do
  begin
    if Modified then
    begin
      nChar := Char(VK_Return);
      Edit_NameKeyPress(Sender, nChar);
    end;
    Modified := False;
  end;
end;

//Desc: 过滤非法字符
procedure TfFrameBase.Edit_XKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Char(VK_Return) then
  begin
    Key := #0;
    Edit_XChange(Sender);
  end else

  if not (Key in ['0'..'9', Char(VK_BACK)]) then
  begin
    Key := #0;
  end;
end;

//Desc: 退出生效
procedure TfFrameBase.Edit_XExit(Sender: TObject);
begin
  with TEdit(Sender) do
  begin
    if Modified then
      Edit_XChange(Sender);
    Modified := False;
  end;
end;

//Desc: 调整位置,宽高
procedure TfFrameBase.Edit_XChange(Sender: TObject);
var nInt,nWH: integer;
    nEdit: TCustomEdit;
begin
  nEdit := TCustomEdit(Sender);
  if not IsNumber(nEdit.Text, False) then Exit;

  nInt := StrToInt(nEdit.Text);
  if nEdit = Edit_X then
  begin
    if Assigned(FPItem) then
    begin
      Inc(nInt, FPItem.ValidClientRect.Left);
      if nInt < FPItem.ValidClientRect.Left then
        nInt := FPItem.ValidClientRect.Left;
      //左边界校正

      if (nInt + FMovedItem.Width) > FPItem.ValidClientRect.Right then
        nInt := FPItem.ValidClientRect.Right - FMovedItem.Width;
      //右边界校正

      nEdit.Text := IntToStr(nInt - FPItem.ValidClientRect.Left);
    end;

    FMovedItem.Left := nInt;
  end;

  if nEdit = Edit_Y then
  begin
    if Assigned(FPItem) then
    begin
      Inc(nInt, FPItem.ValidClientRect.Top);
      if nInt < FPItem.ValidClientRect.Top then
        nInt := FPItem.ValidClientRect.Top;
      //上边界校正

      if (nInt + FMovedItem.Height) > FPItem.ValidClientRect.Bottom then
        nInt := FPItem.ValidClientRect.Bottom - FMovedItem.Height;
      //下边界校正

      nEdit.Text := IntToStr(nInt - FPItem.ValidClientRect.Top);
    end;

    FMovedItem.Top := nInt;
  end else

  if nEdit = Edit_W then
  begin
    if Assigned(FPItem) then
    begin
      nWH := (nInt + FMovedItem.Left) - FPItem.ValidClientRect.Right;
      //超出右边界区域

      if nWH > 0 then
      begin
        if nWH <= FMovedItem.Left - FPItem.ValidClientRect.Left then
             FMovedItem.Left := FMovedItem.Left - nWH
        else FMovedItem.Left := FPItem.ValidClientRect.Left;

        nInt := FPItem.ValidClientRect.Right - FMovedItem.Left;
      end; //宽度校正

      nEdit.Text := IntToStr(nInt);
    end;

    FMovedItem.Width := nInt;
    if Assigned(FMovedItem.OnSizeChanged) then
      FMovedItem.OnSizeChanged(nInt, FMovedItem.Height, True);
    //xxxxx
  end else

  if nEdit = Edit_H then
  begin
    if Assigned(FPItem) then
    begin
      nWH := nInt + FMovedItem.Top - FPItem.ValidClientRect.Bottom;
      //超出下边界区域

      if nWH > 0 then
      begin
        if nWH <= FMovedItem.Top - FPItem.ValidClientRect.Top then
             FMovedItem.Top := FMovedItem.Top - nWH
        else FMovedItem.Top := FPItem.ValidClientRect.Top;

        nInt := FPItem.ValidClientRect.Bottom - FMovedItem.Top;
      end; //高度校正

      nEdit.Text := IntToStr(nInt);
    end;

    FMovedItem.Height := nInt;
    if Assigned(FMovedItem.OnSizeChanged) then
      FMovedItem.OnSizeChanged(FMovedItem.Width, nInt, True);
    //xxxxx
  end;
end;

end.
