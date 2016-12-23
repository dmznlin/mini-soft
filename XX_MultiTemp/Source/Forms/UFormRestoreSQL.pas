{*******************************************************************************
  ����: dmzn@163.com 2009-6-13
  ����: ���ݻ�ԭ����
*******************************************************************************}
unit UFormRestoreSQL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, dxLayoutControl, cxControls, StdCtrls, cxMemo, cxContainer,
  cxEdit, cxTextEdit, cxMCListBox, Menus, UFormBase;

type
  TfFormRestoreSQL = class(TBaseForm)
    dxLayout1Group_Root: TdxLayoutGroup;
    dxLayout1: TdxLayoutControl;
    dxLayout1Group1: TdxLayoutGroup;
    EditName: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Item3: TdxLayoutItem;
    EditTime: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    BtnOK: TButton;
    dxLayout1Item6: TdxLayoutItem;
    BtnExit: TButton;
    dxLayout1Item7: TdxLayoutItem;
    BackList1: TcxMCListBox;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BackList1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
  private
    { Private declarations }
    FDataFile: string;
    //�����ļ�
    procedure LoadBackList;
    //���뱸��
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UFormConn, UFormWait, USysDB, USysConst;

//------------------------------------------------------------------------------
//Desc: ���ݻ�ԭ����
class function TfFormRestoreSQL.CreateForm;
begin
  Result := nil;
  if gSysDBType = dtAccess then
  begin
    ShowMsg('�ù���֧��SQLServer���ݿ�', sHint); Exit;
  end;

  with TfFormRestoreSQL.Create(Application) do
  begin
    Caption := '���ݻ�ԭ';
    ShowModal;
    Free;
  end;
end;

class function TfFormRestoreSQL.FormID: integer;
begin
  Result := cFI_FormRestore;
end;

procedure TfFormRestoreSQL.FormCreate(Sender: TObject);
begin
  LoadBackList;
end;

procedure TfFormRestoreSQL.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------  .
//Desc: ���뱸���б�
procedure TfFormRestoreSQL.LoadBackList;
var nStr: string;
    nIni: TIniFile;
    nList: TStrings;
    i,nCount: integer;
begin
  nStr := gPath + sBackupDir;
  if not DirectoryExists(nStr) then ForceDirectories(nStr);

  nIni := TIniFile.Create(nStr + sBackupFile);
  nList := TStringList.Create;
  try
    nIni.ReadSections(nList);
    BackList1.Clear;

    nCount := nList.Count - 1;
    for i:=0 to nCount do
    begin
      if Pos(cSysDatabaseName[Ord(dtSQLServer)], nList[i]) < 1 then Continue;
      //��SQL Sever����

      nStr := nIni.ReadString(nList[i], 'BackName', '');
      if nStr = '' then Continue;

      nStr := nList[i] + BackList1.Delimiter +
              nStr + BackList1.Delimiter +
              nIni.ReadString(nList[i], 'BackTime', ' ') + BackList1.Delimiter +
              nIni.ReadString(nList[i], 'BackMemo', ' ') + BackList1.Delimiter +
              nIni.ReadString(nList[i], 'BackFile', ' ');
      BackList1.Items.Add(nStr);
    end;
  finally
    nList.Free;
    nIni.Free;
  end;
end;

//Desc: ˢ��
procedure TfFormRestoreSQL.N1Click(Sender: TObject);
begin
  LoadBackList;
end;

//Desc: ɾ������
procedure TfFormRestoreSQL.N2Click(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
    nList: TStrings;
begin
  if BackList1.ItemIndex < 0 then Exit;
  nIni := nil;
  nList := TStringList.Create;
  try
    nStr := BackList1.Items[BackList1.ItemIndex];
    if not SplitStr(nStr, nList, 5, BackList1.Delimiter) then Exit;

    nStr := '��������ɾ���󽫲��ɻָ�!!' + #13#10 +
            'ȷ��Ҫɾ������[ %s ]��?';
    nStr := Format(nStr, [nList[1]]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := nList[4];
    if (not FileExists(nStr)) or DeleteFile(nStr) then
    begin
      nIni := TIniFile.Create(gPath + sBackupDir + sBackupFile);
      nIni.EraseSection(nList[0]);

      LoadBackList;
      ShowMsg('�����ѳɹ�ɾ��', sHint);
    end;
  finally
    nList.Free;
    if Assigned(nIni) then nIni.Free;
  end;
end;

//Desc: �滻�س���
function FixedEnterKey(const nText: string): string;
begin
  Result := StringReplace(nText, '|:)', #13#10, [rfReplaceAll]);
end;

//Desc: ��ʾ����ϸ��
procedure TfFormRestoreSQL.BackList1Click(Sender: TObject);
var nStr: string;
    nList: TStrings;
begin
  if BackList1.ItemIndex < 0 then Exit;
  nList := TStringList.Create;
  try
    nStr := BackList1.Items[BackList1.ItemIndex];
    if not SplitStr(nStr, nList, 5, BackList1.Delimiter) then Exit;

    EditName.Text := nList[1];
    EditTime.Text := nList[2];
    EditMemo.Text := FixedEnterKey(nList[3]);
    FDataFile := nList[4];
  finally
    nList.Free;
  end;
end;

//Desc: ��ʼ����
procedure TfFormRestoreSQL.BtnOKClick(Sender: TObject);
var nStr: string;
    nList: TStrings;
begin
  if BackList1.ItemIndex < 0 then
  begin
    BackList1.SetFocus;
    ShowMsg('��ѡ����Ч�ı���', sHint); Exit;
  end;

  if not FileExists(FDataFile) then
  begin
    ShowMsg('�ñ����Ѿ�ʧЧ', sHint); Exit;
  end;

  nStr := '���е����ݽ��������Ҳ��ɻָ�!!' + #13#10 +
          'ȷ��Ҫ��ԭ������?';
  if not QueryDlg(nStr, sAsk) then Exit;

  nList := TStringList.Create;
  try
    LoadConnecteDBConfig(nList);

    nStr := 'Use Master' + #13#10 +
            'Alter Database $DB Set OffLine with RollBack Immediate' + #13#10 +
            'Restore Database $DB From Disk=''$File'' ' +
            'With File=1, Replace' + #13#10 +
            'Alter DataBase $DB Set Online With RollBack Immediate';
    nStr := MacroValue(nStr, [MI('$DB', nList.Values[sConn_Key_DBCatalog]),
                              MI('$File', FDataFile)]);
  finally
    nList.Free;
  end;

  ShowWaitForm(Self, '���ڻ�ԭ');
  try
    FDM.ExecuteSQL(nStr);
    FDM.ADOConn.Close;
    FDM.ADOConn.Connected := True;

    ModalResult := mrOk;
    CloseWaitForm;
    ShowMsg('���ݻ�ԭ�ɹ�', sHint);
  except
    CloseWaitForm;
    ShowMsg('ִ�л�ԭ����ʧ��', 'δ֪����');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormRestoreSQL, TfFormRestoreSQL.FormID);
end.
