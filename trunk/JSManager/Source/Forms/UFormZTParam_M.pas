{*******************************************************************************
  作者: dmzn@163.com 2011-4-29
  描述: 多道计数器参数
*******************************************************************************}
unit UFormZTParam_M;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  Menus, cxLabel, cxMCListBox, cxButtons, cxTextEdit, cxMaskEdit,
  cxDropDownEdit;

type
  TfFormZTParam_M = class(TfFormNormal)
    dxLayout1Item3: TdxLayoutItem;
    PortList1: TcxComboBox;
    dxLayout1Item4: TdxLayoutItem;
    EditDesc: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditNum: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditDelay: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    BtnAdd: TcxButton;
    dxLayout1Item8: TdxLayoutItem;
    BtnDel: TcxButton;
    dxLayout1Item9: TdxLayoutItem;
    ListTunnel: TcxMCListBox;
    dxLayout1Item10: TdxLayoutItem;
    cxLabel3: TcxLabel;
    dxLayout1Item11: TdxLayoutItem;
    EditWeight: TcxTextEdit;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Item12: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Group7: TdxLayoutGroup;
    dxLayout1Group6: TdxLayoutGroup;
    dxLayout1Group8: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    procedure FormDestroy(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure ListTunnelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    procedure InitFormData;
    //初始化
    procedure SaveZTParam(const nAll: Boolean);
    //保存参数
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

function LoadZTList(const nList: TStrings): Boolean;
function LoadForbidZtock(const nList: TStrings): Boolean;
function GetWeightPerPackage: Double;
//入口函数

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UMgrCOMM, UDataModule, USysConst, USysDB,
   USysGrid;

resourcestring
  sZTParam = 'ZTParam';
  
//------------------------------------------------------------------------------
//Desc: 读取栈台列表
function LoadZTList(const nList: TStrings): Boolean;
var nStr: string;
    nIdx: integer;
    nIni: TIniFile;
begin
  nList.Clear;
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nIdx := 0;

    while True do
    begin
      nStr := nIni.ReadString(sZTParam, 'Line' + IntToStr(nIdx), '');
      if nStr <> '' then
      begin
        nList.Add(nStr);
        Inc(nIdx);
      end else Break;
    end;

    Result := nList.Count > 0;
  finally
    nIni.Free;
  end;
end;

//Desc: 读取被屏蔽品种
function LoadForbidZtock(const nList: TStrings): Boolean;
var nStr: string;
    nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nStr := nIni.ReadString(sZTParam, 'StockForbid', '');
    Result := SplitStr(nStr, nList, 0, ';');
  finally
    nIni.Free;
  end;
end;

//Desc: 获取每袋重量
function GetWeightPerPackage: Double;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    Result := nIni.ReadInteger(sZTParam, 'PerWeight', 0);
    if Result < 1 then Result := 1;
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
class function TfFormZTParam_M.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;

  with TfFormZTParam_M.Create(Application) do
  try
    Caption := '栈台参数';
    BtnOK.Enabled := gSysParam.FIsAdmin;
    
    InitFormData;                       
    ShowModal;
  finally
    Free;
  end;
end;

class function TfFormZTParam_M.FormID: integer;
begin
  Result := cFI_FormZTParam;
end;

procedure TfFormZTParam_M.FormDestroy(Sender: TObject);
begin
  SaveMCListBoxConfig(Name, ListTunnel);
end;

//------------------------------------------------------------------------------
//Desc: 初始化界面
procedure TfFormZTParam_M.InitFormData;
begin
  LoadZTList(ListTunnel.Items);
  LoadMCListBoxConfig(Name, ListTunnel);

  GetValidCOMPort(PortList1.Properties.Items);
  EditWeight.Text := FloatToStr(GetWeightPerPackage);
end;

//Desc: 保存参数
procedure TfFormZTParam_M.SaveZTParam(const nAll: Boolean);
var nIni: TIniFile;
    i,nCount: integer;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    if nAll then
    begin
      nIni.EraseSection(sZTParam);
      nIni.WriteString(sZTParam, 'PerWeight', EditWeight.Text);
    end;

    if not nAll then Exit;

    nCount := ListTunnel.Items.Count - 1;
    for i:=0 to nCount do
      nIni.WriteString(sZTParam, 'Line' + IntToStr(i), ListTunnel.Items[i]);
    //xxxxx
  finally
    nIni.Free;
  end;
end;

//Desc: 添加道
procedure TfFormZTParam_M.BtnAddClick(Sender: TObject);
var nIdx: Integer;
    nList: TStrings;
begin
  PortList1.Text := Trim(PortList1.Text);
  if PortList1.Text = '' then
  begin
    PortList1.SetFocus;
    ShowMsg('请输入有效的端口', sHint); Exit;
  end;

  EditDesc.Text := Trim(EditDesc.Text);
  if EditDesc.Text = '' then
  begin
    EditDesc.SetFocus;
    ShowMsg('请输入有效内容', sHint); Exit;
  end;

  if not IsNumber(EditNum.Text, False) then
  begin
    EditNum.SetFocus;
    ShowMsg('请输入有效的编号', sHint); Exit;
  end;

  if not IsNumber(EditDelay.Text, False) then
  begin
    EditDelay.SetFocus;
    ShowMsg('请输入有效的延迟', sHint); Exit;
  end;

  nList := TStringList.Create;
  try
    for nIdx:=ListTunnel.Items.Count - 1 downto 0 do
    begin
      if not SplitStr(ListTunnel.Items[nIdx], nList, 4, ';') then Continue;
      if (CompareText(PortList1.Text, nList[1]) = 0) and
         (EditNum.Text = nList[2]) then
      begin
        ListTunnel.Items[nIdx] := EditDesc.Text + ';' + PortList1.Text + ';' +
                                  EditNum.Text + ';' + EditDelay.Text;
        Exit;
      end;
    end;
  finally
    nList.Free;
  end;

  ListTunnel.Items.Add(EditDesc.Text + ';' + PortList1.Text + ';' +
                       EditNum.Text + ';' + EditDelay.Text);
  //xxxxx
end;

//Desc: 删除道号
procedure TfFormZTParam_M.BtnDelClick(Sender: TObject);
begin
  if ListTunnel.ItemIndex > -1 then
       ListTunnel.DeleteSelected
  else ShowMsg('请选择要删除的记录', sHint);
end;

//Desc: 显示选中
procedure TfFormZTParam_M.ListTunnelClick(Sender: TObject);
var nList: TStrings;
begin
  nList := TStringList.Create;
  try
    if SplitStr(ListTunnel.Items[ListTunnel.ItemIndex], nList, 4, ';') then
    begin
      EditDesc.Text := nList[0];
      PortList1.Text := nList[1];
      EditNum.Text := nList[2];
      EditDelay.Text := nList[3];
    end;
  finally
    nList.Free;
  end;
end;

//Desc: 保存
procedure TfFormZTParam_M.BtnOKClick(Sender: TObject);
begin
  if (not IsNumber(EditWeight.Text, True)) or
     (StrToFloat(EditWeight.Text) < 0) then
  begin
    EditWeight.SetFocus;
    ShowMsg('请输入有效的袋重值', sHint); Exit;
  end;

  SaveZTParam(True);
  ModalResult := mrOK;
  ShowMsg('参数已保存', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormZTParam_M, TfFormZTParam_M.FormID);
end.
