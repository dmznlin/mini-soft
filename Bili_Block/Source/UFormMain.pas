{*******************************************************************************
  作者: dmzn@dmzn.com 2025-12-12
  描述: 用于管理和生成B站黑名单
*******************************************************************************} 
unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ToolWin, ComCtrls, StdCtrls, ExtCtrls, ImgList, cxGraphics;

type
  TfFormMain = class(TForm)
    wPage: TPageControl;
    SheetOK: TTabSheet;
    SheetWill: TTabSheet;
    ToolBar1: TToolBar;
    BtnEData: TToolButton;
    BtnEList: TToolButton;
    SBar1: TStatusBar;
    cxImageList1: TcxImageList;
    Bevel1: TBevel;
    ToolButton3: TToolButton;
    BtnCombin: TToolButton;
    MemoOK: TMemo;
    MemoWill: TMemo;
    TabSheet1: TTabSheet;
    MemoGood: TMemo;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    Label1: TLabel;
    EditTag: TEdit;
    BtnSearch: TButton;
    MemoQuery: TMemo;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BtnCombinClick(Sender: TObject);
    procedure BtnEDataClick(Sender: TObject);
    procedure BtnEListClick(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FMList: TStrings;
    FWList: TStrings;
    procedure LoadMList(const nList: TStrings; nType: Byte);
    procedure UpdateStatus;
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses Clipbrd, ULibFun;

var
  gPath: string;
  //全局使用

const
  sBlackFile = 'BList.txt';
  sWhiteFile = 'BWhite.txt';

procedure TfFormMain.FormCreate(Sender: TObject);
begin
  Randomize;
  ShortDateFormat := 'YYYY-MM-DD';
  gPath := ExtractFilePath(Application.ExeName);

  FMList := TStringList.Create;
  FWList := TStringList.Create;
  wPage.ActivePageIndex := 0;
  
  InitGlobalVariant(gPath, gPath + 'Config.Ini', gPath + 'Form.Ini');
  LoadFormConfig(Self);

  if FileExists(gPath + sBlackFile) then
  begin
    MemoOK.Lines.LoadFromFile(gPath + sBlackFile);
    LoadMList(MemoOK.Lines, 0);
    UpdateStatus();
  end;

  if FileExists(gPath + sWhiteFile) then
  begin
    MemoGood.Lines.LoadFromFile(gPath + sWhiteFile);
    //load white file
    LoadMList(MemoGood.Lines, 1);
  end;
end;


procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  FMList.Free;
  FWList.Free;
end;

procedure TfFormMain.UpdateStatus;
begin
  SBar1.SimpleText := Format('※.合计: 共 %d 条,白名单 %d 条', [FMList.Count,
    FWList.Count]);
  //xxxxx
end;

function GetMID(const nStr: string): string;
var nPos: Integer;
begin
  nPos := Pos(#9, nStr);
  if nPos > 0 then
  begin
    Result := Trim(Copy(nStr, 1, nPos));
    if Length(Result) < 5 then
      Result := '';
    //xxxxx
  end else Result := '';
end;

procedure TfFormMain.LoadMList(const nList: TStrings; nType: Byte);
var nIdx: Integer;
    nStr: string;
begin
  case nType of
   1:
    FWList.Clear
   else
    FMList.Clear;
  end;

  for nIdx:=0 to nList.Count - 1 do
  begin
    nStr := GetMID(nList[nIdx]);
    if nStr <> '' then
    begin
      case nType of
       1:
        FWList.Add(nStr)
       else
        FMList.Add(nStr);
      end;
    end;

    //xxxxx
  end;
end;

procedure TfFormMain.BtnCombinClick(Sender: TObject);
var nIdx: Integer;
    nStr: string;
    nTag: string;
    nOK: Boolean;
begin
  nOK := False;
  nTag := DateTimeSerial();

  for nIdx:=0 to MemoWill.Lines.Count - 1 do
  begin
    nStr := GetMID(MemoWill.Lines[nIdx]);
    if (nStr = '') or (FMList.IndexOf(nStr) >= 0) or (FWList.IndexOf(nStr) >= 0) then Continue;

    FMList.Add(nStr);
    //add list
    UpdateStatus();
    
    MemoOK.Lines.Add(MemoWill.Lines[nIdx] + #9 + nTag);
    //add data
    nOK := True;
  end;

  if nOK then
  begin
    MemoOK.Lines.SaveToFile(gPath + sBlackFile);
    ShowMsg('合并完毕', '成功');
  end;
end;

procedure TfFormMain.BtnEDataClick(Sender: TObject);
begin
  Clipboard.AsText := CombinStr(FMList, ',', False);
  ShowMsg('已导出至粘贴板', '成功');
end;

procedure TfFormMain.BtnEListClick(Sender: TObject);
var nIdx: Integer;
    nStr: string;
    nRes,nID,nName,nPic: string;
    nPos: Integer;
begin
  nRes := '';
  //init

  for nIdx:=0 to MemoOK.Lines.Count - 1 do
  begin
    nStr := TrimLeft(MemoOK.Lines[nIdx]);
    nPos := Pos(#9, nStr);
    if nPos < 5 then Continue;

    nID := TrimRight(Copy(nStr, 1, nPos));
    System.Delete(nStr, 1, nPos);

    nStr := TrimLeft(nStr);
    nPos := Pos(#9, nStr);
    if nPos < 2 then Continue;

    nName := TrimRight(Copy(nStr, 1, nPos));
    System.Delete(nStr, 1, nPos);

    nStr := TrimLeft(nStr);
    nPos := Pos(#9, nStr);
    if nPos < 2 then Continue;

    nPic := TrimRight(Copy(nStr, 1, nPos));
    nRes := nRes + Format('![](%s =32x32) %s &emsp;', [nPic, nName]);
  end;

  Clipboard.AsText := nRes;
  ShowMsg('已导出至粘贴板', '成功');
end;

procedure TfFormMain.BtnSearchClick(Sender: TObject);
var nIdx: Integer;
begin
  if EditTag.Text = '' then
  begin
    EditTag.SetFocus;
    ShowMsg('填写Tag', '提示');
    Exit;
  end;

  MemoQuery.Clear;
  for nIdx:=0 to MemoOK.Lines.Count - 1 do
   if Pos(EditTag.Text, MemoOK.Lines[nIdx]) >= 1 then
    MemoQuery.Lines.Add(MemoOK.Lines[nIdx]);
end;

procedure TfFormMain.Button1Click(Sender: TObject);
var nIdx: Integer;
    nOK: Boolean;
begin
  if EditTag.Text = '' then
  begin
    EditTag.SetFocus;
    ShowMsg('填写Tag', '提示');
    Exit;
  end;

  nOK := False;
  for nIdx:=MemoOK.Lines.Count - 1 downto 0 do
   if Pos(EditTag.Text, MemoOK.Lines[nIdx]) >= 1 then
   begin
     MemoOK.Lines.Delete(nIdx);
     nOK := True;
   end;

  if nOK then
  begin
    LoadMList(MemoOK.Lines, 0);
    MemoOK.Lines.SaveToFile(gPath + sBlackFile);
    UpdateStatus();
    ShowMsg('移除完毕', '成功');
  end;
end;

end.

