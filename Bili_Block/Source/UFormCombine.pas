unit UFormCombine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, CheckLst, ExtCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, Menus;

type
  TfFormMain = class(TForm)
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    ListBlack: TListView;
    BtnApply: TButton;
    Label1: TLabel;
    EditFile: TEdit;
    BtnSelect: TButton;
    IdHTTP1: TIdHTTP;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    BtnMake: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BtnSelectClick(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure BtnMakeClick(Sender: TObject);
  private
    { Private declarations }
    FMList: TStrings;
    FWList: TStrings;
    FRemote: TStrings;
    procedure LoadRemoteBlackList();
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
  
  sURL = 'http://bbs.runsoft.online:43110/' +
         '129Lxtnj45HkSnV9cGWmpBMNXffbeiG5RY/img/b_all.txt';
  //xxxxx

procedure TfFormMain.FormCreate(Sender: TObject);
begin
  Randomize;
  ShortDateFormat := 'YYYY-MM-DD';
  gPath := ExtractFilePath(Application.ExeName);

  FMList := TStringList.Create;
  FWList := TStringList.Create;
  FRemote := TStringList.Create;

  InitGlobalVariant(gPath, gPath + 'Config.Ini', gPath + 'Form.Ini');
  LoadFormConfig(Self);

  if FileExists(gPath + sWhiteFile) then
    FWList.LoadFromFile(gPath + sWhiteFile);
  //xxxxx
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  FMList.Free;
  FWList.Free;
  FRemote.Free;
end;

procedure TfFormMain.LoadRemoteBlackList;
var nSS: TStringStream;
begin
  if FRemote.Count > 0 then Exit;
  nSS := nil;

  with TIdHttp.Create(Application) do
  try
    nSS := TStringStream.Create('');
    Get(sURL, nSS);
    FRemote.Text := UTF8ToAnsi( nSS.DataString );
  finally
    nSS.Free;
    Free;
  end;
end;

procedure TfFormMain.BtnSelectClick(Sender: TObject);
begin
  with TOpenDialog.Create(Application) do
  begin
    FileName := EditFile.Text;
    Title := '选择文件';
    Filter := '黑名单(*.txt)|*.txt';
    
    if Execute then
      EditFile.Text := FileName;
    Free;
  end;
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

function GetMName(nStr: string): string;
var nPos: Integer;
begin
  Result := '';
  nPos := Pos(#9, nStr);
  if nPos < 1 then Exit;

  System.Delete(nStr, 1, nPos);
  nStr := TrimLeft(nStr);
  nPos := Pos(#9, nStr);

  if nPos > 0 then
  begin
    Result := Trim(Copy(nStr, 1, nPos));
    if Length(Result) < 1 then
      Result := '';
    //xxxxx
  end;
end;

procedure TfFormMain.BtnApplyClick(Sender: TObject);
var nIdx,i: Integer;
    nStr: string;
    nOK: Boolean;
begin
  if not FileExists(EditFile.Text) then Exit;
  //check valid

  LoadRemoteBlackList();
  //载入远程黑名单
  FMList.LoadFromFile(EditFile.Text);
  //载入本地黑名单

  ListBlack.Items.Clear;
  //清空当前列表

  for nIdx:=0 to FRemote.Count - 1 do
  begin
    nStr := GetMID(FRemote[nIdx]);
    if nStr = '' then Continue;
    //invalid

    nOK := False;
    for i:=0 to FMList.Count - 1 do
    if nStr = GetMID(FMList[i]) then
    begin
      nOK := True;
      Break;
    end;

    if nOK then Continue;
    //已经存在

    with ListBlack.Items.Add do
    begin
      Caption := nStr;
      SubItems.Add(GetMName(FRemote[nIdx]));
      Checked := FWList.IndexOf(nStr) < 0; //不在白名单中
    end;
  end;

  StatusBar1.SimpleText := Format('※.待合并: 共 %d 条记录', [ListBlack.Items.Count]);
end;

procedure TfFormMain.N1Click(Sender: TObject);
var nIdx: Integer;
    nTag: Integer;
begin
  nTag := TComponent(Sender).Tag;
  for nIdx:=0 to ListBlack.Items.Count - 1 do
   with ListBlack.Items[nIdx] do
   begin
     case nTag of
      10: Checked := True;
      20: Checked := False;
      30: Checked := not Checked;
     end;
   end;
end;

procedure TfFormMain.BtnMakeClick(Sender: TObject);
var nStr,nRes: string;
    nIdx: Integer;
    nOK: Boolean;
begin
  nRes := '';
  nOK := False;

  for nIdx:=0 to ListBlack.Items.Count - 1 do
  begin
    nStr := ListBlack.Items[nIdx].Caption;
    if ListBlack.Items[nIdx].Checked then //黑名单成员
    begin
      if nRes = '' then
           nRes := nStr
      else nRes := nRes + ',' + nStr;
    end else //白名单成员
    begin
      if FWList.IndexOf(nStr) < 0 then
      begin
        FWList.Add(nStr);
        nOK := True;
      end;
    end;
  end;

  if nOK then
    FWList.SaveToFile(gPath + sWhiteFile);
  //xxxxx

  if nRes <> '' then
  begin
    Clipboard.AsText := nRes;
    ShowMessage('已复制到粘贴板');
  end;
end;

end.

