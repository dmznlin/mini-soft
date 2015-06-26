{*******************************************************************************
  ����: dmzn@163.com 2009-6-13
  ����: ���ݱ��ݴ���
*******************************************************************************}
unit UFormBackupAccess;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, dxLayoutControl, cxControls, StdCtrls, cxMemo, cxContainer,
  cxEdit, cxTextEdit, UFormBase;

type
  TfFormBackupAccess = class(TBaseForm)
    dxLayout1Group_Root: TdxLayoutGroup;
    dxLayout1: TdxLayoutControl;
    dxLayout1Group1: TdxLayoutGroup;
    EditLastName: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditName: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Item3: TdxLayoutItem;
    EditLastTime: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditTime: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    BtnOK: TButton;
    dxLayout1Item6: TdxLayoutItem;
    BtnExit: TButton;
    dxLayout1Item7: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    //����ʵ��
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ZLIBEX, ULibFun, UMgrControl, UFormConn, UFormWait, USysDB,
  USysConst;

//------------------------------------------------------------------------------
//Desc: ���ݱ��ݴ���
class function TfFormBackupAccess.CreateForm;
begin
  Result := nil;
  if gSysDBType <> dtAccess then
  begin
    ShowMsg('�ù���ֻ֧�ֵ������ݿ�', sHint); Exit;
  end;

  with TfFormBackupAccess.Create(Application) do
  begin
    Caption := '���ݱ���';
    ShowModal;
    Free;
  end;
end;

class function TfFormBackupAccess.FormID: integer;
begin
  Result := cFI_FormBackup;
end;

procedure TfFormBackupAccess.FormCreate(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  nStr := gPath + sBackupDir;
  if not DirectoryExists(nStr) then ForceDirectories(nStr);

  nIni := TIniFile.Create(nStr + sBackupFile);
  try
    EditLastName.Text := nIni.ReadString('Setup', 'LastName', '��');
    EditLastTime.Text := nIni.ReadString('Setup', 'LastTime', '��');
    EditTime.Text := DateTime2Str(Now);
  finally
    nIni.Free;
  end;
end;

procedure TfFormBackupAccess.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
//Desc: ���������ļ���
function MakeBackFile: string;
begin
  Result := FloatToStr(Now);
  Result := StringReplace(Result, '.', '', []);
  Result := gPath + sBackupDir + Result + '.bak';

  while FileExists(Result) do
    Result := MakeBackFile;
  //xxxxx
end;

//Desc: �滻�س���
function FixedEnterKey(const nText: string): string;
begin
  Result := StringReplace(nText, #13#10, '|:)', [rfReplaceAll]); 
end;

//Date: 2009-9-16
//Parm: Դ�ļ�;Ŀ���ļ�
//Desc: ��nSourceѹ������nDest·��
function ZipFileForBackup(const nSource, nDest: string): Boolean;
const
  nBufSize = $F000;
var
  nLeft: Int64;
  nSStream: TFileStream;
  nDStream: TFileStream;
  nZipStream: TZCompressionStream;
  nBuf: array [0..nBufSize] of Byte;
begin
  nSStream := nil;
  nDStream := nil;
  nZipStream := nil;
  try
    nSStream := TFileStream.Create(nSource, fmOpenRead or fmShareDenyNone);
    nSStream.Seek(0, soFromBeginning);
    nLeft := nSStream.Size;

    nDStream := TFileStream.Create(nDest, fmCreate);
    nZipStream := TZCompressionStream.Create(nDStream, zcDefault);

    while nLeft > 0 do
    begin
      if nLeft > nBufSize then
      begin
        nSStream.Read(nBuf, nBufSize);
        nZipStream.Write(nBuf, nBufSize);
      end else
      begin
        nSStream.Read(nBuf, nLeft);
        nZipStream.Write(nBuf, nLeft);
      end;

      nLeft := nLeft - nBufSize;
    end;

    Result := True;
  finally
    nZipStream.Free;
    nSStream.Free;
    nDStream.Free;
  end;
end;

//Desc: ��ʼ����
procedure TfFormBackupAccess.BtnOKClick(Sender: TObject);
var nIni: TIniFile;
    nList: TStrings;
    nStr,nFile: string;
begin
  EditName.Text := Trim(EditName.Text);
  if EditName.Text = '' then
  begin
    EditName.SetFocus;
    ShowMsg('����д��Ч�ı�������', sHint); Exit;
  end;

  nStr := '���ݲ�����Ҫ�Ͽ����ݿ�,��ɺ����ӻ��Զ��ָ�!!' + #13#10 +
          '���ָ�ʧ��,�����µ�½��ϵͳ.';
  ShowDlg(nStr, sHint, Handle);
  
  nList := TStringList.Create;
  try
    LoadConnecteDBConfig(nList);
    nStr := nList.Values[sConn_Key_PathValue];
    if nStr = '' then nStr := gPath;

    if Copy(nStr, Length(nStr), 1) = '\' then
      System.Delete(nStr, Length(nStr), 1);
    //xxxxx

    nFile := nList.Values[sConn_Key_DBFile];
    nStr := StringReplace(nFile, sConn_Path, nStr, [rfReplaceAll, rfIgnoreCase]);
    nFile := MakeBackFile;
  finally
    nList.Free;
  end;

  nIni := nil;
  ShowWaitForm(Self, '���ڱ���');
  try
    FDM.ADOConn.Connected := False;
    ZipFileForBackup(nStr, nFile);
    FDM.ADOConn.Connected := True;

    nIni := TIniFile.Create(gPath + sBackupDir + sBackupFile);
    nIni.WriteString('Setup', 'LastName', EditName.Text);
    nIni.WriteString('Setup', 'LastTime', EditTime.Text);

    nStr := cSysDatabaseName[Ord(dtAccess)] + '_' + FloatToStr(Now);
    nIni.WriteString(nStr, 'BackName', EditName.Text);
    nIni.WriteString(nStr, 'BackTime', EditTime.Text);
    nIni.WriteString(nStr, 'BackMemo', FixedEnterKey(EditMemo.Text));
    nIni.WriteString(nStr, 'BackFile', nFile);

    nIni.Free;
    ModalResult := mrOk;

    CloseWaitForm;
    ShowMsg('���ݱ��ݳɹ�', sHint);
  except
    if Assigned(nIni) then nIni.Free;
    CloseWaitForm;
    ShowMsg('ִ�б��ݲ���ʧ��', 'δ֪����');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormBackupAccess, TfFormBackupAccess.FormID);
end.
