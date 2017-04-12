unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ZnHideForm, UTrayIcon, Menus, ExtCtrls, ComCtrls, StdCtrls;

type
  TFileItem = record
    FFrom: string;
    FDest: string;
  end;

  TFileItems = array of TFileItem;
  
  TfFormMain = class(TForm)
    ZnHideForm1: TZnHideForm;
    TrayIcon1: TTrayIcon;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    wPage: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ListKey: TListBox;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    ListBox2: TListBox;
    Panel1: TPanel;
    BtnClear: TButton;
    BtnRestore: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure ListKeyDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListKeyEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure BtnClearClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure BtnRestoreClick(Sender: TObject);
  private
    { Private declarations }
    FCloseMe: Boolean;
    FKeyChanged: Boolean;
    FKeyLastItem: Integer;
    FFileItems: TFileItems;
    procedure KeyWord(const nLoad: Boolean);
    procedure DrawItemLine(const nIdx: Integer; const nColor: TColor);
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  ShlObj, ShellAPI, ULibFun, UFormInputbox;

var
  gPath: string;
  gDesktop: string;
  //全局使用

resourcestring
  sConfile = 'Config.ini';
  sKeyword = 'Keywords.txt';
  sHint = '提示';

function GetDesktopFolder: string;
var nBuf: PChar;
begin
  Result := '';
  GetMem(nBuf, MAX_PATH);
  try
    if ShGetSpecialFolderPath(GetDesktopWindow, nBuf, CSIDL_DESKTOP, False) then
    begin
      SetString(Result, nBuf, StrLen(nBuf));
      if Copy(Result, Length(Result), 1) <> '\' then
        Result := Result + '\';
      //xxxxx
    end;
  finally
    FreeMem(nBuf);    
  end;
end; 

//------------------------------------------------------------------------------
procedure TfFormMain.FormCreate(Sender: TObject);
begin
  FCloseMe := False;
  FKeyChanged := False;
  FKeyLastItem := -1;

  gPath := ExtractFilePath(Application.ExeName);
  InitGlobalVariant(gPath, gPath + sConfile, gPath + sConfile);
  gDesktop := GetDesktopFolder;

  KeyWord(True);
  LoadFormConfig(Self);
  
  BtnRestore.Left := Panel1.ClientRect.Right - 8 - BtnRestore.Width;
  BtnClear.Left := BtnRestore.Left - 8 - BtnClear.Width;
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FCloseMe then
  begin
    if FKeyChanged then
      KeyWord(False);
    SaveFormConfig(Self);
  end else
  begin
    Action := caNone;
    TrayIcon1.Minimize;
  end;
end;

procedure TfFormMain.N1Click(Sender: TObject);
begin
  FCloseMe := True;
  Close;
end;

procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  StatusBar1.SimpleText := DateTime2Str(Now) + ' ' + Date2Week();
end;

//------------------------------------------------------------------------------
procedure TfFormMain.KeyWord(const nLoad: Boolean);
var nStr: string;
begin
  nStr := gPath + sKeyword;
  if nLoad then
  begin
    ListKey.Clear;      
    if FileExists(nStr) then
      ListKey.Items.LoadFromFile(nStr);
    FKeyChanged := False;
  end else
  begin
    ListKey.Items.SaveToFile(nStr);
    FKeyChanged := False;
  end;
end;

procedure TfFormMain.N2Click(Sender: TObject);
var nStr: string;
begin
  while True do
  begin
    if not ShowInputBox('关键词:', '', nStr) then Break;
    nStr := Trim(nStr);
    if nStr = '' then Continue;

    if ListKey.Items.IndexOf(nStr) >= 0 then
    begin
      ShowMsg('关键词已存在', sHint);
      Continue;
    end;

    ListKey.Items.Add(nStr);
    FKeyChanged := True;
    Break;
  end;
end;

procedure TfFormMain.N3Click(Sender: TObject);
begin
  if ListKey.ItemIndex >= 0 then
  begin
    ListKey.Items.Delete(ListKey.ItemIndex);
    FKeyChanged := True;
  end;
end;

procedure TfFormMain.DrawItemLine(const nIdx: Integer; const nColor: TColor);
var nRect: TRect;
begin
  nRect := ListKey.ItemRect(nIdx);
  with ListKey.Canvas do
  begin
    Pen.Color := nColor;
    Pen.Width := 1;
    MoveTo(nRect.Left + 5, nRect.Top);
    LineTo(nRect.Right - 5, nRect.Top);
  end;
end;

procedure TfFormMain.ListKeyDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var nIdx: Integer;
begin
  nIdx := ListKey.ItemAtPos(Point(X, Y), True);
  Accept := nIdx >= 0;

  if not Accept then
  begin
    if FKeyLastItem >= 0 then
      DrawItemLine(FKeyLastItem, ListKey.Color);
    FKeyLastItem := -1;
    Exit;
  end;
  if nIdx = FKeyLastItem then Exit;

  if FKeyLastItem >= 0 then
    DrawItemLine(FKeyLastItem, ListKey.Color);
  //old one

  FKeyLastItem := nIdx;
  DrawItemLine(FKeyLastItem, clBlue);
end;

procedure TfFormMain.ListKeyEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  if (ListKey.ItemIndex >= 0) and (FKeyLastItem >= 0) and
     (ListKey.ItemIndex <> FKeyLastItem) then
  begin
    ListKey.Items.Insert(FKeyLastItem, ListKey.Items[ListKey.ItemIndex]);
    ListKey.Items.Delete(ListKey.ItemIndex);
    FKeyChanged := True;
  end else
  begin
    if FKeyLastItem >= 0 then
      DrawItemLine(FKeyLastItem, ListKey.Color);
    //xxxxx
  end;

  FKeyLastItem := -1;
end;

function XCopy(const nFrom,nDest: string): Boolean;
var nData: TShFileOpStruct;
begin
  with nData do
  begin
    pFrom := PChar(nFrom + #0#0);
    pTo := PChar(nDest + #0#0);
    wFunc := FO_MOVE;

    Wnd := Application.Handle;
    lpszProgressTitle := '整理中';
    fAnyOperationsAborted := False;
    
    fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_MULTIDESTFILES or
              FOF_NOCONFIRMMKDIR;
    //xxxxx
  end;

  Result := ShFileOperation(nData) = 0;
end;

procedure TfFormMain.BtnClearClick(Sender: TObject);
var nKey: string;
    nIdx: Integer;
    nRet: TSearchRec;
    nRes: Integer;
begin
  if ListKey.ItemIndex < 0 then
  begin
    ShowMsg('请选择关键词', sHint);
    Exit;
  end;

  nKey := LowerCase(ListKey.Items[ListKey.ItemIndex]);
  SetLength(FFileItems, 0);
  nRes := FindFirst(gDesktop + '*.*', faAnyFile, nRet);

  try
    while nRes = 0 do
    begin
      if (Pos(nKey, LowerCase(nRet.Name)) > 0) and
         (CompareText(nRet.Name, nKey) <> 0) then
      begin
        nIdx := Length(FFileItems);
        SetLength(FFileItems, nIdx + 1);

        with FFileItems[nIdx] do
        begin
          FFrom := gDesktop + nRet.Name;
          FDest := gDesktop + nKey + '\' + nRet.Name;
        end;
      end;

      nRes := FindNext(nRet);
    end;
  finally
    FindClose(nRet);
  end;

  for nIdx:=Low(FFileItems) to High(FFileItems) do
   with FFileItems[nIdx] do
    XCopy(FFrom, FDest);
  //xxxxx

  nKey := gDesktop + nKey;
  if DirectoryExists(nKey) then
    FileSetAttr(nKey, faReadOnly or faHidden);
  ShowMsg('整理完毕', sHint);
end;

procedure TfFormMain.BtnRestoreClick(Sender: TObject);
var nKey: string;
    nIdx: Integer;
    nRet: TSearchRec;
    nRes: Integer;
begin
  if ListKey.ItemIndex < 0 then
  begin
    ShowMsg('请选择关键词', sHint);
    Exit;
  end;

  nKey := LowerCase(ListKey.Items[ListKey.ItemIndex]);
  SetLength(FFileItems, 0);
  nRes := FindFirst(gDesktop + nKey + '\*.*', faAnyFile, nRet);

  try
    while nRes = 0 do
    begin
      if Pos(nKey, LowerCase(nRet.Name)) > 0 then
      begin
        nIdx := Length(FFileItems);
        SetLength(FFileItems, nIdx + 1);

        with FFileItems[nIdx] do
        begin
          FFrom := gDesktop + nKey + '\' + nRet.Name;
          FDest := gDesktop + nRet.Name;
        end;
      end;

      nRes := FindNext(nRet);
    end;
  finally
    FindClose(nRet);
  end;

  for nIdx:=Low(FFileItems) to High(FFileItems) do
   with FFileItems[nIdx] do
    XCopy(FFrom, FDest);
  ShowMsg('整理完毕', sHint);
end;

end.
