{*******************************************************************************
  作者: dmzn@163.com 2007-11-11
  描述: 添加,修改菜单项
*******************************************************************************}
unit Menu_AddNew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFrmNew = class(TForm)
    BtnSave: TButton;
    BtnExit: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    Edit_Menu: TLabeledEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit_ProgID: TComboBox;
    Edit_Entity: TComboBox;
    Label4: TLabel;
    Edit_PMenu: TComboBox;
    Edit_Title: TLabeledEdit;
    Edit_Img: TLabeledEdit;
    Edit_Flag: TLabeledEdit;
    Edit_Action: TLabeledEdit;
    Edit_Filter: TLabeledEdit;
    Edit_Order: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit_ProgIDChange(Sender: TObject);
    procedure Edit_EntityChange(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure Edit_MenuKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FProgID,FEntity,FMenuID: string;
    {*标识*}
    FLastProg,FLastEntity: string;
    {*避免重复载入标记*}
    procedure InitFormData;
    {*初始化界面*}
    procedure LoadComboxData(const nBox: TComboBox);
    {*载入下拉框数据*}
    procedure LoadItemData;
    {*载入菜单项*}
  public
    { Public declarations }
  end;

function ShowAddItemForm: Boolean;
function ShowEditItemForm(const nProgID,nEntity,nItemID: string): Boolean;
//入口函数

implementation

{$R *.dfm}
uses
  UFormCtrl, UAdjustForm, Menu_DM, Menu_Const, ULibFun;

var
  gProgID: string = '';
  gEntity: string = '';
  gPMenu: string = '';
  //上次操作的实体和父级菜单

ResourceString
  sSelectMenu = 'Select * From %s Where M_ProgID=''%s'' and ' +
                'M_Entity=''%s'' and M_MenuID=''%s''';
  //查询菜单
  sSelectEntity = 'M_Entity=Select M_Entity,M_Title From %s Where ' +
                  'M_ProgID=''%s'' and M_Entity<>'''' and M_MenuID=''''';
  //查询实体
  sSelectPMenu = 'M_MenuID=Select M_MenuID,M_Title From %s Where ' +
                 'M_ProgID=''%s'' and M_Entity=''%s'' and M_MenuID<>''''';
  //查询实体下菜单

//------------------------------------------------------------------------------
//Date: 2007-11-11
//Desc: 添加菜单项
function ShowAddItemForm: Boolean;
begin
  with TFrmNew.Create(Application) do
  begin
    FProgID := '';
    FEntity := '';
    FMenuID := '';
    Caption := '添加菜单项';

    InitFormData;
    Result := ShowModal = mrOK;
    Free;
  end;
end;

//Date: 2007-11-11
//Parm: 程序标识;实体标识;菜单标识
//Desc: 修改nProgID程序下nEntity实体中的nItemId菜单项
function ShowEditItemForm(const nProgID,nEntity,nItemID: string): Boolean;
begin
  with TFrmNew.Create(Application) do
  begin
    Caption := '修改菜单项';
    FProgID := nProgiD;
    FEntity := nEntity;
    FMenuID := nItemID;

    InitFormData;
    Result := ShowModal = mrOK;
    Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 依据nBox.Item提供的SQL填充数据
procedure TFrmNew.LoadComboxData(const nBox: TComboBox);
var nPos: integer;
    nStr,nSQL: string;
begin
  nBox.Text := '';
  nSQL := nBox.Items.Text;
  nPos := Pos('=', nSQL);

  nStr := Copy(nSQL, 1, nPos - 1);
  System.Delete(nSQL, 1, nPos);
  nSQL := MacroValue(nSQL, [MI('$Menu', gMenuTable)]);
  //前缀,SQL语句

  FDM.SQLTemp.Close;
  FDM.SQLTemp.SQL.Text := nSQL;
  FDM.SQLTemp.Open;
  LoadDataToList(FDM.SQLTemp, nBox.Items, nStr);
end;

//Desc: 初始化界面数据
procedure TFrmNew.InitFormData;
var i,nCount: integer;
begin
  nCount := ComponentCount - 1;
  for i:=0 to nCount do
   if (Components[i] is TComboBox) and IsFixRelation(Components[i], 'C') then
   begin
     LoadComboxData(Components[i] as TComboBox);
     AdjustComboBox(Components[i] as TComboBox, False);
   end;

  if FProgID = '' then
  begin
    if gProgID <> '' then
      SetCtrlData(Edit_ProgID, gProgID);
    Edit_ProgID.OnChange(nil);

    if gEntity <> '' then
    begin
      SetCtrlData(Edit_Entity, gEntity);
      Edit_Entity.OnChange(nil);
    end;
    
    if gPMenu <> '' then
      SetCtrlData(Edit_PMenu, gPMenu);
  end else
  begin
    LoadItemData;
    EnableNUComponent(Self, False);
  end; //修改时载入数据
end;

//Date: 2007-11-12
//Parm: 程序标识;实体标识;菜单标识
//Desc: 载入nProgID.nEntity.nItemID菜单项的数据
procedure TFrmNew.LoadItemData;
var nStr,nEntity,nPMenu: string;
begin
  nStr := Format(sSelectMenu, [gMenuTable, FProgID, FEntity, FMenuID]);
  FDM.SQLTemp.Close;
  FDM.SQLTemp.SQL.Text := nStr;
  FDM.SQLTemp.Open;

  if FDM.SQLTemp.RecordCount = 0 then Exit;
  LoadDataToForm(FDM.SQLTemp, Self);
  //载入数据到窗体

  nEntity := FDM.SQLTemp.FieldByName('M_Entity').AsString;
  nPMenu := FDM.SQLTemp.FieldByName('M_PMenu').AsString;
  nStr := FDM.SQLTemp.FieldByName('M_ProgID').AsString;

  SetCtrlData(Edit_ProgID, nStr);
  Edit_ProgID.OnChange(nil);                //由程序标识更新实体标识

  SetCtrlData(Edit_Entity, nEntity);
  Edit_Entity.OnChange(nil);
  SetCtrlData(Edit_PMenu, nPMenu);          //设置上级菜单
end;

//------------------------------------------------------------------------------
procedure TFrmNew.FormCreate(Sender: TObject);
begin
  LoadFormConfig(Self);
  ResetHintAllForm(Self, 'Menu', gMenuTable);
end;

procedure TFrmNew.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  ReleaseCtrlData(Self);
end;

//------------------------------------------------------------------------------
//Desc: 跳转焦点
procedure TFrmNew.Edit_MenuKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN,VK_DOWN: SwitchFocusCtrl(Self, True);
    VK_UP: SwitchFocusCtrl(Self, False);
  end;
end;

//Desc: 依据程序标识切换实体标识
procedure TFrmNew.Edit_ProgIDChange(Sender: TObject);
var nStr: string;
begin
  nStr := GetCtrlData(Edit_ProgID);
  if nStr = '' then
  begin
    AdjustComboBox(Edit_Entity, True);
    FLastProg := '';
  end;

  if nStr <> FLastProg then
  begin
    AdjustComboBox(Edit_Entity, True);
    Edit_Entity.Items.Text := Format(sSelectEntity, [gMenuTable, nStr]);
    LoadComboxData(Edit_Entity);

    AdjustComboBox(Edit_Entity, False);
    FLastProg := nStr;
    Edit_Entity.OnChange(nil);
  end;
end;

//Desc: 依据实体切换菜单列表
procedure TFrmNew.Edit_EntityChange(Sender: TObject);
var nProgID,nEntity: string;
begin
  nProgID := GetCtrlData(Edit_ProgID);
  nEntity := GetCtrlData(Edit_Entity);

  if nEntity = '' then
  begin
    AdjustComboBox(Edit_PMenu, True);
    FLastEntity := ''; Exit;
  end;

  if nEntity <> FLastEntity then
  begin
    AdjustComboBox(Edit_PMenu, True);
    Edit_PMenu.Items.Text := Format(sSelectPMenu, [gMenuTable, nProgID, nEntity]);
    LoadComboxData(Edit_PMenu);

    AdjustComboBox(Edit_PMenu, False);
    FLastEntity := nEntity;
  end;
end;

//Desc: 保存
procedure TFrmNew.BtnSaveClick(Sender: TObject);
var nStr,nSQL: string;
begin
  if not IsValidFormData(Self, gMenuTable) then Exit;
  //数据校验不正确
  if GetCtrlData(Edit_Menu) = GetCtrlData(Edit_PMenu) then
  begin
    ShowMsg('菜单自身不能作为父菜单', sHint); Exit;
  end;

  if Edit_ProgID.Enabled then
  begin
    gProgID := GetCtrlData(Edit_ProgID);
    gEntity := GetCtrlData(Edit_Entity);
    gPMenu := GetCtrlData(Edit_PMenu);
    nStr := Format(sSelectMenu, [gMenuTable, gProgID, gEntity, GetCtrlData(Edit_Menu)]);

    FDM.SQLTemp.Close;
    FDM.SQLTemp.SQL.Text := nStr;
    FDM.SQLTemp.Open;

    if FDM.SQLTemp.RecordCount > 0 then
    begin
      ShowMsg('该菜单项已经存在', sHint); Exit;
    end;

    nSQL := MakeSQLByForm(Self, gMenuTable, '', True);
  end else//添加菜单项
  
  begin
    nStr := 'M_ProgID=''%s'' and M_Entity=''%s'' and M_MenuID=''%s''';
    nStr := Format(nStr, [FProgID, FEntity, FMenuID]);
    nSQL := MakeSQLByForm(Self, gMenuTable, nStr, False);
  end; //修改菜单项

  FDM.SQLCmd.Close;
  FDM.SQLCmd.SQL.Text := nSQL;
  if FDM.SQLCmd.ExecSQL > 0 then
  begin
    ShowMsg('数据提交成功', sHint);
    ModalResult := mrOK;
  end else ShowMsg('数据好像提交失败', sHint);
end;

end.
