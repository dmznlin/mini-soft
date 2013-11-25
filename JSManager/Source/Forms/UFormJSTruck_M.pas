{*******************************************************************************
  作者: dmzn@163.com 2011-4-29
  描述: 栈台车辆
*******************************************************************************}
unit UFormJSTruck_M;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, UMultiJSCtrl, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Menus,
  cxLabel, cxMCListBox, cxButtons, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  dxLayoutControl, StdCtrls, cxSplitter;

type
  TfFormJSTruck_M = class(TfFormNormal)
    ListPD: TcxMCListBox;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Item4: TdxLayoutItem;
    ListYZ: TcxMCListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dxLayout1Resize(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure ListPDClick(Sender: TObject);
    procedure ListYZDblClick(Sender: TObject);
  private
    { Private declarations }
    FData: TMultiJSPanelData;
    //数据
    FActiveList: TcxMCListBox;
    //活动列表
    procedure InitFormData;
    //初始化
    function MakeData: Boolean;
    //构建数据
  public
    { Public declarations }
    procedure CreateParams(var Params : TCreateParams); override;
    //控制位置
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

function ShowZTTruckForm(var nData: TMultiJSPanelData; nPForm: TForm): Boolean;
//入口函数

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UDataModule, USysConst, USysDB, USysGrid;

var
  gJSForm: TForm;
  //计数窗体

//Desc: 显示选择车辆窗口
function ShowZTTruckForm(var nData: TMultiJSPanelData; nPForm: TForm): Boolean;
begin
  gJSForm := nPForm;

  with TfFormJSTruck_M.Create(Application) do
  try
    Caption := '选择车辆';
    FormStyle := fsStayOnTop;
    FActiveList := nil;
    
    InitFormData;                       
    Result := ShowModal = mrOk;

    if Result then
      nData := FData;
    //xxxxx
  finally
    Free;
  end;
end;

procedure TfFormJSTruck_M.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := gJSForm.Handle;
end;

//------------------------------------------------------------------------------
class function TfFormJSTruck_M.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
end;

class function TfFormJSTruck_M.FormID: integer;
begin
  Result := cFI_FormZTTruck;
end;

procedure TfFormJSTruck_M.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, ListPD, nIni);
    LoadMCListBoxConfig(Name, ListYZ, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormJSTruck_M.FormClose(Sender: TObject;  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, ListPD, nIni);
    SaveMCListBoxConfig(Name, ListYZ, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 初始化界面
procedure TfFormJSTruck_M.InitFormData;
var nStr: string;
    nList: TStrings;
begin
  ListPD.Clear;
  nStr := 'Select * From %s Where L_HasDone=''%s'' Order By L_ID ASC';
  nStr := Format(nStr, [sTable_JSLog, sFlag_No]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := CombinStr([FieldByName('L_TruckNo').AsString,
              FieldByName('L_Stock').AsString,
              FieldByName('L_Weight').AsString,
              FieldByName('L_SerialID').AsString + ' ',
              FieldByName('L_Customer').AsString + ' ',
              FieldByName('L_ID').AsString,
              IntToStr(FieldByName('L_DaiShu').AsInteger)], ListPD.Delimiter);
      ListPD.Items.Add(nStr);

      Next;
    end;
  end;

  ListYZ.Clear;
  nList := nil;

  if gSysDBType = dtSQLServer then
  begin
    nStr := 'Select * From %s Where L_HasDone=''%s'' And L_OKTime>=''%s'' ' +
            'Order By L_TruckNo ASC,L_ID DESC';
  end else
  begin
    nStr := 'Select * From %s Where L_HasDone=''%s'' And L_OKTime>=CDate(''%s'') ' +
            'Order By L_TruckNo ASC,L_ID DESC';
  end;

  nStr := Format(nStr, [sTable_JSLog, sFlag_Yes, DateTime2Str(Now - 1)]);
  //一天以内

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  try
    nList := TStringList.Create;
    First;

    while not Eof do
    begin
      nStr := FieldByName('L_TruckNo').AsString;
      if nList.IndexOf(nStr) < 0 then
      begin
        nList.Add(nStr);
        nStr := CombinStr([FieldByName('L_TruckNo').AsString,
                FieldByName('L_Stock').AsString,
                FieldByName('L_Weight').AsString,
                FieldByName('L_SerialID').AsString + ' ',
                FieldByName('L_Customer').AsString + ' ',
                FieldByName('L_DaiShu').AsString,
                FieldByName('L_BC').AsString,
                FieldByName('L_ID').AsString], ListYZ.Delimiter);
        ListYZ.Items.Add(nStr);
      end;

      Next;
    end;
  finally
    nList.Free;
  end;
end;

//Desc: 调整排队列表高
procedure TfFormJSTruck_M.dxLayout1Resize(Sender: TObject);
begin
  ListPD.Height := Trunc(ClientHeight * 4 / 11);
end;

//Desc: 列表激活
procedure TfFormJSTruck_M.ListPDClick(Sender: TObject);
begin
  FActiveList := Sender as TcxMCListBox;
  if FActiveList.ItemIndex < 0 then FActiveList := nil;
end;

//Desc: 选择数据
procedure TfFormJSTruck_M.ListYZDblClick(Sender: TObject);
begin
  FActiveList := Sender as TcxMCListBox;
  if FActiveList.ItemIndex < 0 then FActiveList := nil;

  if MakeData then ModalResult := mrOk;
end;

//Desc: 构建数据
function TfFormJSTruck_M.MakeData: Boolean;
var nStr: string;
    nList: TStrings;
begin
  Result := Assigned(FActiveList);
  if not Result then Exit;

  nList := TStringList.Create;
  try
    nStr := FActiveList.Items[FActiveList.ItemIndex];
    FillChar(FData, SizeOf(FData), #0);

    if FActiveList = ListPD then
    begin
      Result := SplitStr(nStr, nList, 7, FActiveList.Delimiter);
      if not Result then Exit;

      with FData do
      begin
        FRecordID := nList[5];
        FTruckNo := nList[0];
        FStockName := nList[1];
        FStockNo := nList[3];
        FCustomer := nList[4];
        FHaveDai := StrToInt(nList[6]);

        FIsBC := False;
        FTHValue := StrToFloat(nList[2]);
      end;
    end else

    if FActiveList = ListYZ then
    begin
      Result := SplitStr(nStr, nList, 8, FActiveList.Delimiter);
      if not Result then Exit;

      with FData do
      begin
        FRecordID := nList[7];
        FTruckNo := nList[0];
        FStockName := nList[1];
        FStockNo := nList[3];
        FCustomer := nList[4];
        FHaveDai := 1;

        FIsBC := True;
        FTHValue := StrToFloat(nList[2]);
        FTotalDS := StrToInt(nList[5]);
        FTotalBC := StrToInt(nList[6]); 
      end;
    end
  finally
    nList.Free;
  end;
end;

//Desc: 选择数据
procedure TfFormJSTruck_M.BtnOKClick(Sender: TObject);
begin
  if MakeData then
       ModalResult := mrOk
  else ShowMsg('请选择车辆', sHint);
end;

end.
