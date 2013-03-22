{*******************************************************************************
  作者: dmzn@163.com 2013-3-20
  描述: 系统参数设置
*******************************************************************************}
unit UFormSysParam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit,
  cxLabel, cxTextEdit, dxLayoutControl, StdCtrls, cxCheckBox;

type
  TfFormSysParam = class(TfFormNormal)
    EditTrainID: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditUIInterval: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Item5: TdxLayoutItem;
    cxLabel1: TcxLabel;
    EditQInterval: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditUIMax: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditChartCount: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditPage: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    CheckSend: TcxCheckBox;
    dxLayout1Item10: TdxLayoutItem;
    CheckRecv: TcxCheckBox;
    dxLayout1Item11: TdxLayoutItem;
    dxLayout1Item12: TdxLayoutItem;
    cxLabel2: TcxLabel;
  protected
    { Protected declarations }
    procedure InitFormData;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure GetSaveSQLList(const nList: TStrings); override;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UFormCtrl, UDataModule, USysLoger, USysConst, USysDB;

class function TfFormSysParam.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;

  with TfFormSysParam.Create(Application) do
  begin
    InitFormData();
    ShowModal;
    Free;
  end;
end;

class function TfFormSysParam.FormID: integer;
begin
  Result := cFI_FormSysParam;
end;

procedure TfFormSysParam.InitFormData;
begin
  with gSysParam do
  begin
    EditTrainID.Text := FTrainID;
    EditQInterval.Text := IntToStr(FQInterval);
    CheckSend.Checked := FPrintSend;
    CheckRecv.Checked := FPrintRecv;

    EditUIInterval.Text := IntToStr(FUIInterval);
    EditUIMax.Text := IntToStr(Trunc(FUIMaxValue));
    EditChartCount.Text := IntToStr(FChartCount);
    EditPage.Text := IntToStr(FReportPage);
  end;
end;

function TfFormSysParam.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditTrainID then
  begin
    Result := Trim(EditTrainID.Text) <> '';
    nHint := '请填写车辆标识';
  end else

  if Sender = EditQInterval then
  begin
    Result := IsNumber(EditQInterval.Text, False) and
              (StrToInt(EditQInterval.Text) >= 2000);
    nHint := '间隔应大于2000毫秒';
  end else

  if Sender = EditPage then
  begin
    Result := IsNumber(EditPage.Text, False) and
              (StrToInt(EditPage.Text) >= 1) and
              (StrToInt(EditPage.Text) <= 24);
    nHint := '分页介于1-24小时';
  end else

  if Sender = EditUIInterval then
  begin
    Result := IsNumber(EditUIInterval.Text, False) and
              (StrToInt(EditUIInterval.Text) >= 10);
    nHint := '间距应大于10';
  end else

  if Sender = EditUIMax then
  begin
    Result := IsNumber(EditUIMax.Text, False) and
              (StrToInt(EditUIMax.Text) >= 100);
    nHint := '上限应大于100';
  end else

  if Sender = EditChartCount then
  begin
    Result := IsNumber(EditChartCount.Text, False) and
              (StrToInt(EditChartCount.Text) >= 500);
    nHint := '点数上限应大于500';
  end else
end;

function BoolYN(const nVal: Boolean): string;
begin
  if nVal then
       Result := sFlag_Yes
  else Result := sFlag_No;
end;

procedure TfFormSysParam.GetSaveSQLList(const nList: TStrings);
var nStr: string;
begin
  with gSysParam do
  begin
    FTrainID    := EditTrainID.Text;
    FQInterval  := StrToInt(EditQInterval.Text);
    FPrintSend  := CheckSend.Checked;
    FPrintRecv  := CheckRecv.Checked;

    FUIInterval := StrToInt(EditUIInterval.Text);
    FUIMaxValue := StrToInt(EditUIMax.Text);
    FChartCount := StrToInt(EditChartCount.Text);
    FReportPage := StrToInt(EditPage.Text);

    nStr := Format('D_Name=''%s''', [sFlag_TrainID]);
    nStr := MakeSQLByStr([SF('D_Value', FTrainID)], sTable_SysDict, nStr, False);
    nList.Add(nStr);

    nStr := Format('D_Name=''%s''', [sFlag_QInterval]);
    nStr := MakeSQLByStr([SF('D_Value', FQInterval)], sTable_SysDict, nStr, False);
    nList.Add(nStr);

    nStr := Format('D_Name=''%s''', [sFlag_PrintSend]);
    nStr := MakeSQLByStr([SF('D_Value', BoolYN(FPrintSend))], sTable_SysDict, nStr, False);
    nList.Add(nStr);

    nStr := Format('D_Name=''%s''', [sFlag_PrintRecv]);
    nStr := MakeSQLByStr([SF('D_Value', BoolYN(FPrintRecv))], sTable_SysDict, nStr, False);
    nList.Add(nStr);

    nStr := Format('D_Name=''%s''', [sFlag_UIInterval]);
    nStr := MakeSQLByStr([SF('D_Value', FUIInterval)], sTable_SysDict, nStr, False);
    nList.Add(nStr);

    nStr := Format('D_Name=''%s''', [sFlag_UIMaxValue]);
    nStr := MakeSQLByStr([SF('D_Value', FUIMaxValue)], sTable_SysDict, nStr, False);
    nList.Add(nStr);

    nStr := Format('D_Name=''%s''', [sFlag_ChartCount]);
    nStr := MakeSQLByStr([SF('D_Value', FChartCount)], sTable_SysDict, nStr, False);
    nList.Add(nStr);

    nStr := Format('D_Name=''%s''', [sFlag_ReportPage]);
    nStr := MakeSQLByStr([SF('D_Value', FReportPage)], sTable_SysDict, nStr, False);
    nList.Add(nStr);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormSysParam, TfFormSysParam.FormID);
end.
