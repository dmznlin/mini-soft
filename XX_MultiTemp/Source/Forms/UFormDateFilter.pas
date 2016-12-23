{*******************************************************************************
  ����: dmzn@163.com 2009-6-5
  ����: ����ɸѡ��
*******************************************************************************}
unit UFormDateFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, StdCtrls, dxLayoutControl, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxControls;

type
  TfFormDateFilter = class(TForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    EditStart: TcxDateEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    EditEnd: TcxDateEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    BtnOK: TButton;
    dxLayoutControl1Item3: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item4: TdxLayoutItem;
    dxLayoutControl1Group2: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowDateFilterForm(var nStart,nEnd: TDate; nTime: Boolean = False): Boolean;
procedure InitDateRange(const nID: string; var nS,nE: TDate);
procedure SaveDateRange(const nID: string; const nS,nE: TDate);
//��ں���

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, USysConst;

//Date: 2009-6-5
//Parm: ��ʼ����;��������
//Desc: ��ʾʱ���ɸѡ����
function ShowDateFilterForm(var nStart,nEnd: TDate; nTime: Boolean): Boolean;
begin
  with TfFormDateFilter.Create(Application) do
  begin
    Caption := '����ɸѡ';
    EditStart.Date := nStart;
    EditEnd.Date := nEnd;

    if nTime then
    begin
      EditStart.Properties.Kind := ckDateTime;
      EditEnd.Properties.Kind := ckDateTime;
    end else
    begin
      EditStart.Properties.Kind := ckDate;
      EditEnd.Properties.Kind := ckDate;
    end;

    Result := ShowModal = mrOK;
    if Result then
    begin
      nStart := EditStart.Date;
      nEnd := EditEnd.Date;
    end;
    Free;
  end;
end;

//Desc: ����nID��ʶ����������
procedure InitDateRange(const nID: string; var nS,nE: TDate);
var nStr: string;
    nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nStr := nIni.ReadString(nID, 'DateRange_Last', '');
    if nStr = Date2Str(Now) then
    begin
      nStr := nIni.ReadString(nID, 'DateRange_S', Date2Str(Now));
      nS := Str2Date(nStr);

      nStr := nIni.ReadString(nID, 'DateRange_E', Date2Str(Now));
      nE := Str2Date(nStr);
    end else
    begin
      nS := Date; nE := Date;
    end;
  finally
    nIni.Free;
  end;
end;

//Desc: �������������nID��ʶ��
procedure SaveDateRange(const nID: string; const nS,nE: TDate);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nIni.WriteString(nID, 'DateRange_S', Date2Str(nS));
    nIni.WriteString(nID, 'DateRange_E', Date2Str(nE));
    nIni.WriteString(nID, 'DateRange_Last', Date2Str(Now));
  finally
    nIni.Free;
  end;
end;

//Desc: ����ѡ��
procedure TfFormDateFilter.BtnOKClick(Sender: TObject);
begin
  if EditEnd.Date < EditStart.Date then
  begin
    EditEnd.SetFocus;
    ShowMsg('�������ڲ���С�ڿ�ʼ����', sHint);
  end else ModalResult := mrOK;
end;

end.
