{*******************************************************************************
  ����: dmzn@163.com 2009-6-13
  ����: ���ݱ��ݴ���
*******************************************************************************}
unit UFormBackupSQL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, dxLayoutControl, cxControls, StdCtrls, cxMemo, cxContainer,
  cxEdit, cxTextEdit, UFormBase;

type
  TfFormBackupSQL = class(TBaseForm)
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
  IniFiles, ULibFun, UMgrControl, UFormConn, UFormWait, USysDB, USysConst;

//------------------------------------------------------------------------------
//Desc: ���ݱ��ݴ���
class function TfFormBackupSQL.CreateForm;
begin
  Result := nil;
  if gSysDBType <> dtSQLServer then
  begin
    ShowMsg('�ù���֧��SQLServer���ݿ�', sHint); Exit;
  end;

  with TfFormBackupSQL.Create(Application) do
  begin
    Caption := '���ݱ���';
    ShowModal;
    Free;
  end;
end;

class function TfFormBackupSQL.FormID: integer;
begin
  Result := cFI_FormBackup;
end;

procedure TfFormBackupSQL.FormCreate(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  nStr := gPath + sBackupDir;
  if not DirectoryExists(nStr) then ForceDirectories(nStr);

  nIni := TIniFile.Create(nStr + sBackupFile);
  try
    EditLastName.Text := nIni.ReadString('Setup', 'LastName', '��');
    EditLastTime.Text := nIni.ReadString('Setup', 'LastTime', '��');
    EditTime.Text := DateTimeToStr(Now);
  finally
    nIni.Free;
  end;
end;

procedure TfFormBackupSQL.BtnExitClick(Sender: TObject);
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

//Desc: ��ʼ����
procedure TfFormBackupSQL.BtnOKClick(Sender: TObject);
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

  nList := TStringList.Create;
  try
    LoadConnecteDBConfig(nList);

    nStr := 'Backup Database %s To Disk=''%s''';
    nFile := MakeBackFile;
    nStr := Format(nStr, [nList.Values[sConn_Key_DBCatalog], nFile]);
  finally
    nList.Free;
  end;

  nIni := nil;
  ShowWaitForm(Self, '���ڱ���');
  try
    FDM.ExecuteSQL(nStr);

    nIni := TIniFile.Create(gPath + sBackupDir + sBackupFile);
    nIni.WriteString('Setup', 'LastName', EditName.Text);
    nIni.WriteString('Setup', 'LastTime', EditTime.Text);

    nStr := cSysDatabaseName[Ord(dtSQLServer)] + '_' + FloatToStr(Now);
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
  gControlManager.RegCtrl(TfFormBackupSQL, TfFormBackupSQL.FormID);
end.
