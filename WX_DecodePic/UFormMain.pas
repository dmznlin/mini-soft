unit UFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, UHotKeyManager,
  Vcl.StdCtrls, Vcl.Forms, Vcl.ExtCtrls, Vcl.Controls, Vcl.ComCtrls,
  System.Classes, Vcl.Graphics;

type
  TfFormMain = class(TForm)
    wPage: TPageControl;
    SheetDecode: TTabSheet;
    SheetSet: TTabSheet;
    GroupBox1: TGroupBox;
    EditSrc: TLabeledEdit;
    EditDest: TLabeledEdit;
    GroupBox2: TGroupBox;
    CheckAuto: TCheckBox;
    EditKeys: TLabeledEdit;
    CheckOpen: TCheckBox;
    HotKey1: THotKeyManager;
    TabSheet1: TTabSheet;
    MemoLog: TMemo;
    EditTime: TLabeledEdit;
    EditHide: TLabeledEdit;
    ListFile: TListBox;
    Panel1: TPanel;
    BtnDecode: TButton;
    BtnClear: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditKeysChange(Sender: TObject);
    procedure HotKey1HotKeyPressed(HotKey: Cardinal; Index: Word);
    procedure BtnClearClick(Sender: TObject);
    procedure BtnDecodeClick(Sender: TObject);
  private
    { Private declarations }
    FHotKeyHide: Cardinal;
    FHotKeyRun: Cardinal;
    //ȫ���ȼ�
    FFiles: TStrings;
    //�ļ��б�
    FDecoding: Boolean;
    //������
    FWindowProc: TWndMethod;
    //ԭ�������
    procedure ConfigAction(const nLoad: Boolean);
    //��д����
    procedure WriteLog(const nEvent: string; const nClear: Boolean = False);
    //��¼��־
    procedure DecodeFolder(const nSrc,nDest: string; const nSearch: Boolean);
    //��������
  public
    { Public declarations }
    procedure NewWindowProc(var nMsg: TMessage);
    procedure WMDROPFILES(var nMsg: TMessage); message WM_DROPFILES;
    //�Ϸ��ļ�
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses
  ULibFun, System.IniFiles, System.Win.Registry, Winapi.ShellAPI, UWXFun;

const
  cConfig = 'Config.ini';
  sAutoStartKey = 'WXPicture';

procedure TfFormMain.ConfigAction(const nLoad: Boolean);
var nIni: TIniFile;
    nReg: TRegistry;
begin
  nReg := nil;
  nIni := nil;
  try
    nIni := TIniFile.Create(TApplicationHelper.gPath + cConfig);
    //init

    if nLoad then
    begin
      TApplicationHelper.LoadFormConfig(Self, nIni);
      EditSrc.Text := nIni.ReadString('Config', 'WXDir', '');
      EditDest.Text := nIni.ReadString('Config', 'SaveDir', '');
      EditTime.Text := nIni.ReadString('Config', 'TimeInterval', '1');

      EditKeys.Text := nIni.ReadString('Config', 'HostKeyRun', 'Ctrl + Alt + F');
      EditHide.Text := nIni.ReadString('Config', 'HotKeyHide', 'Ctrl + Alt + Y');
      CheckOpen.Checked := nIni.ReadBool('Config', 'HotKeyHide', True);

      nReg := TRegistry.Create;
      nReg.RootKey := HKEY_CURRENT_USER;
      nReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);

      CheckAuto.Checked := nReg.ValueExists(sAutoStartKey);
      if CheckAuto.Checked then
        Application.ShowMainForm := False;
      //xxxxx
    end else
    begin
      nIni.WriteString('Config', 'WXDir', EditSrc.Text);
      nIni.WriteString('Config', 'SaveDir', EditDest.Text);
      nIni.WriteString('Config', 'HostKeyRun', EditKeys.Text);
      nIni.WriteString('Config', 'HotKeyHide', EditHide.Text);
      nIni.WriteString('Config', 'TimeInterval', EditTime.Text);

      nIni.WriteBool('Config', 'AutoOpen', CheckOpen.Checked);
      nReg := TRegistry.Create;
      nReg.RootKey := HKEY_CURRENT_USER;

      nReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
      if CheckAuto.Checked then
        nReg.WriteString(sAutoStartKey, Application.ExeName)
      else if nReg.ValueExists(sAutoStartKey) then
        nReg.DeleteValue(sAutoStartKey);
      //xxxxx
    end;
  finally
    nIni.Free;
    nReg.Free;
  end;
end;

procedure TfFormMain.NewWindowProc(var nMsg: TMessage);
begin
  if nMsg.Msg = WM_DROPFILES then
    WMDROPFILES(nMsg); // handle WM_DROPFILES message
  FWindowProc(nMsg);
end;

procedure TfFormMain.FormCreate(Sender: TObject);
begin
  with TApplicationHelper do
  begin
    gPath := ExtractFilePath(Application.ExeName);
    gFormConfig := gPath + cConfig;
  end;

  MemoLog.Clear;
  FDecoding := False;
  wPage.ActivePageIndex := 0;
  FFiles := TStringList.Create;

  FWindowProc := ListFile.WindowProc;
  ListFile.WindowProc := NewWindowProc;
  DragAcceptFiles(ListFile.Handle, True);

  FHotKeyRun := TextToHotKey(EditKeys.Text, False);
  HotKey1.AddHotKey(FHotKeyRun);
  FHotKeyHide := TextToHotKey(EditHide.Text, False);
  HotKey1.AddHotKey(FHotKeyHide);

  ConfigAction(True);
  //load config
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FDecoding then
  begin
    Action := caNone;
    Exit;
  end;

  TApplicationHelper.SaveFormConfig(Self);
  FFiles.Free;

  ListFile.WindowProc := FWindowProc;
  DragAcceptFiles(ListFile.Handle, False);
end;

procedure TfFormMain.EditKeysChange(Sender: TObject);
begin
  if ActiveControl <> Sender then Exit;
  //not user action

  if Sender = EditTime then
  begin
    EditTime.Text := Trim(EditTime.Text);
    if EditTime.Text = '' then Exit;

    if TStringHelper.IsNumber(EditTime.Text, False) then
    begin
      ConfigAction(False);
      EditTime.Font.Color := Font.Color;
    end else
    begin
      EditTime.Font.Color := clRed;
    end;
  end else

  if Sender = EditSrc then
  begin
    if DirectoryExists(EditSrc.Text) then
    begin
      ConfigAction(False);
      EditSrc.Font.Color := Font.Color;
    end else
    begin
      EditSrc.Font.Color := clRed;
    end;
  end else

  if Sender = EditDest then
  begin
    if DirectoryExists(EditDest.Text) then
    begin
      ConfigAction(False);
      EditDest.Font.Color := Font.Color;
    end else
    begin
      EditDest.Font.Color := clRed;
    end;
  end else
  begin
    ConfigAction(False);
    //write config
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormMain.WriteLog(const nEvent: string; const nClear: Boolean);
begin
  if nClear then
    MemoLog.Clear;
  MemoLog.Lines.Add(TDateTimeHelper.Time2Str(Now, True, True) + #9 + nEvent);
end;

//Date: 2020-05-19
//Parm: ԴĿ¼;����󱣴�;�Զ�ɨ��Ŀ¼
//Desc: ��nSrc�з���������ͼƬ����,����nDestĿ¼��
procedure TfFormMain.DecodeFolder(const nSrc,nDest: string;
 const nSearch: Boolean);
var nIdx: Integer;
    nDT: TDateTime;
    nRec: TSearchRec;
begin
  if nSearch then
  begin
    FFiles.Clear;
    nDT := Now() - StrToInt(EditTime.Text) / (24 * 60); //ָ������
    WriteLog(EditSrc.Text, True);

    if FindFirst(nSrc + '*.dat', faAnyFile, nRec) = 0 then
    try
      repeat
        if nRec.TimeStamp >= nDT then
        begin
          FFiles.Add(nSrc + nRec.Name);
          //valid file
        end;
      until FindNext(nRec) <> 0;
    finally
      FindClose(nRec);
    end;
  end;

  if FFiles.Count < 1 then Exit;
  //no match file
  if FindFirst(nDest + '*.*', faAnyFile, nRec) = 0 then
  try
    repeat
      if (nRec.Name = '.') or (nRec.Name = '..') then Continue;
      //���账��

      DeleteFile(nDest + nRec.Name);
      //������ļ�
    until FindNext(nRec) <> 0;
  finally
    FindClose(nRec);
  end;

  for nIdx := 0 to FFiles.Count - 1 do
  begin
    WriteLog(Format('���ڽ���: %d/%d', [nIdx + 1, FFiles.Count]));
    Application.ProcessMessages;
    DecryptWXImgFile(FFiles[nIdx], nDest);
  end;

  if CheckOpen.Checked then
  begin
    ShellExecute(0, 'open' , 'explorer.exe', PChar(nDest), nil, SW_SHOWNORMAL);
    //open dest folder
  end;
end;

//Desc: ִ���ȼ�
procedure TfFormMain.HotKey1HotKeyPressed(HotKey: Cardinal; Index: Word);
var nSrc,nDest: string;
begin
  if HotKey = FHotKeyHide then //��ʾ����
  begin
    Visible := not Visible;
    Exit;
  end;

  if not FDecoding then
  try
    FDecoding := True;
    nSrc := EditSrc.Text;
    if Copy(nSrc, Length(nSrc), 1) <> '\' then
      nSrc := nSrc + '\';
    //xxxxx

    nDest := EditDest.Text;
    if Copy(nDest, Length(nDest), 1) <> '\' then
      nDest := nDest + '\';
    //xxxxx

    DecodeFolder(nSrc, nDest, True);
  finally
    FDecoding := False;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��ק�ļ�
procedure TfFormMain.WMDROPFILES(var nMsg: TMessage);
var nIdx,nInt: Integer;
    nBuf: array[0..255] of Char;
begin
  nInt := DragQueryFile(nMsg.wParam, $FFFFFFFF, nBuf, 255);
  for nIdx := 0 to nInt - 1 do
  begin
    DragQueryFile(nMsg.wParam, nIdx, nBuf, 255);
    if ListFile.Items.IndexOf(nBuf) < 0 then
      ListFile.Items.Add(nBuf);
    //xxxxx
  end;

  DragFinish(nMsg.wParam);
end;

procedure TfFormMain.BtnClearClick(Sender: TObject);
begin
  ListFile.Clear;
end;

procedure TfFormMain.BtnDecodeClick(Sender: TObject);
var nDest: string;
begin
  nDest := EditDest.Text;
  if Copy(nDest, Length(nDest), 1) <> '\' then
    nDest := nDest + '\';
  //xxxxx

  if not FDecoding then
  try
    FDecoding := True;
    wPage.ActivePageIndex := 0;
    WriteLog('�ֶ�����', True);

    FFiles.Clear;
    FFiles.AddStrings(ListFile.Items);
    DecodeFolder('', nDest, False);
  finally
    FDecoding := False;
  end;
end;

end.
