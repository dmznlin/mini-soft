{*******************************************************************************
  ����: dmzn@163.com 2009-8-4
  ����: ������ģ��
*******************************************************************************}
unit UDataReport;

{$I Link.Inc}
interface

uses
  SysUtils, Classes, frxClass, frxDesgn, frxDBSet, frxCross, frxRich,
  frxGradient, UHotKeyManager, UFormInputbox;

type
  PReportParamItem = ^TReportParamItem;
  TReportParamItem = record
    FName: string;
    FValue: Variant;
  end;

  TFDR = class(TDataModule)
    Report1: TfrxReport;
    Dataset1: TfrxDBDataset;
    Dataset2: TfrxDBDataset;
    Dataset3: TfrxDBDataset;
    Designer1: TfrxDesigner;
    Rich1: TfrxRichObject;
    Cross1: TfrxCrossObject;
    UserDS1: TfrxUserDataSet;
    Gradient1: TfrxGradientObject;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure Report1GetValue(const VarName: String; var Value: Variant);
    procedure Report1AfterPrintReport(Sender: TObject);
  private
    { Private declarations }
    FParamList: TList;
    {*�����б�*}
    FReportFile: string;
    {*�����ļ�*}
    FHotKey: Cardinal;
    FHotKeyOver: Boolean;
    FHotKeyMgr: THotKeyManager;
    {*�����ȼ�*}
    FPrintSuccess: Boolean;
    {*�ɹ���ӡ*}
    procedure DisposeParamItem(const nItem: PReportParamItem);
    procedure ClearParamList(const nFree: Boolean);
    {*������Դ*}
    procedure DoHotKeyHotKeyPressed(HotKey: Cardinal; Index: Word);
    {*�ȼ�����*}
  public
    { Public declarations }
    procedure ShowReport;
    procedure DesignReport;
    function PrintReport: Boolean;
    function LoadReportFile(const nFile: string): Boolean;
    {*�������*}
    function AddParamItem(const nItem: TReportParamItem): Integer;
    function DeleteParamItem(const nName: string): Integer;
    procedure ClearParamItems;
    {*��������*}
    function GetParamItemIndex(const nName: string): integer;
    {*��������*}
    property ParamList: TList read FParamList;
    property ReportFile: string read FReportFile;
    property MainReport: TfrxReport read Report1;
    property PrintSuccess: Boolean read FPrintSuccess;
    property DatasetA: TfrxDBDataset read Dataset1;
    property DatasetB: TfrxDBDataset read Dataset2;
    property DatasetC: TfrxDBDataset read Dataset3;
    property UserDatasetA: TfrxUserDataSet read UserDS1;
    {*�������*}
  end;

var
  FDR: TFDR;

implementation

{$R *.dfm}

procedure TFDR.DataModuleCreate(Sender: TObject);
begin
  {$IFDEF TrialVersion}
  with Report1.PreviewOptions do
    Buttons := Buttons - [pbPrint];
  //trial version no print
  {$ENDIF}

  FParamList := TList.Create;
  FHotKeyOver := True;

  FHotKeyMgr := THotKeyManager.Create(Self);
  FHotKeyMgr.OnHotKeyPressed := DoHotKeyHotKeyPressed;

  FHotKey := TextToHotKey('Ctrl + Alt + D', False);
  FHotKeyMgr.AddHotKey(FHotKey);
end;

procedure TFDR.DataModuleDestroy(Sender: TObject);
begin
  ClearParamList(True);
end;

//------------------------------------------------------------------------------
//Desc: �ͷŲ�����
procedure TFDR.DisposeParamItem(const nItem: PReportParamItem);
begin
  Dispose(nItem);
end;

//Desc: ��������б�
procedure TFDR.ClearParamList(const nFree: Boolean);
var nIdx: integer;
begin
  for nIdx:=FParamList.Count - 1 downto 0 do
  begin
    DisposeParamItem(FParamList[nIdx]);
    FParamList.Delete(nIdx);
  end;

  if nFree then FParamList.Free;
end;

//Desc: ��ղ���
procedure TFDR.ClearParamItems;
begin
  ClearParamList(False);
end;

//Desc: ��Ӳ�����
function TFDR.AddParamItem(const nItem: TReportParamItem): Integer;
var nP: PReportParamItem;
begin
  Result := GetParamItemIndex(nItem.FName);
  if Result < 0 then
  begin
    New(nP);
    Result := FParamList.Add(nP);
  end;

  with PReportParamItem(FParamList[Result])^ do
  begin
    FName := nItem.FName;
    FValue := nItem.FValue;
  end;
end;

//Desc: ɾ��nName����
function TFDR.DeleteParamItem(const nName: string): Integer;
begin
  Result := GetParamItemIndex(nName);
  if Result > -1 then
  begin
    DisposeParamItem(FParamList[Result]);
    FParamList.Delete(Result);
  end;
end;

//Desc: ��ȡnName����������λ��
function TFDR.GetParamItemIndex(const nName: string): integer;
var nIdx,nLen: integer;
begin
  Result := -1;
  nLen := FParamList.Count - 1;

  for nIdx:=0 to nLen do
  if CompareText(nName, PReportParamItem(FParamList[nIdx]).FName) = 0 then
  begin
    Result := nIdx; Break;
  end;
end;

//Desc: ����nFile�����ļ�
function TFDR.LoadReportFile(const nFile: string): Boolean;
begin
  Result := nFile = FReportFile;
  
  if not Result  then
  try
    if FileExists(nFile) then
    begin
      Result := Report1.LoadFromFile(nFile);
      FReportFile := nFile;
    end else Result := False;
  except
    Result := False;
  end;
end;

//Desc: ��Ʊ���
procedure TFDR.DesignReport;
begin
  FPrintSuccess := False;
  Report1.DesignReport;
end;

//Desc: Ԥ������
procedure TFDR.ShowReport;
begin
  FPrintSuccess := False;
  Report1.ShowReport;
end;

//Desc: ��ӡ����
function TFDR.PrintReport: Boolean;
var nBool: Boolean;
begin
  nBool := Report1.PrintOptions.ShowDialog;
  Report1.PrintOptions.ShowDialog := False;
  try
    Report1.PrepareReport;
    Result := Report1.Print;
  finally
    Report1.PrintOptions.ShowDialog := nBool;
  end;
end;

//Desc: ��ȡ
procedure TFDR.Report1GetValue(const VarName: String; var Value: Variant);
var nIdx: integer;
begin
  nIdx := GetParamItemIndex(VarName);
  if nIdx < 0 then
  begin
    Value := '-';
  end else
  begin
    Value := PReportParamItem(FParamList[nIdx]).FValue;
  end;
end;

//Desc: ������ӡ����
procedure TFDR.Report1AfterPrintReport(Sender: TObject);
begin
  FPrintSuccess := True;
end;

//Desc: ��Ʊ���
procedure TFDR.DoHotKeyHotKeyPressed(HotKey: Cardinal; Index: Word);
var nStr: string;
begin
  if FHotKeyOver and (HotKey = FHotKey) then
  try
    FHotKeyOver := False;
    {$IFNDEF DEBUG}
    if ShowInputPWDBox('�������������:', '���������', nStr) and
       (nStr = 'admin_dmzn') then
    {$ENDIF} DesignReport;
  finally
    FHotKeyOver := True;
  end;
end;

end.
