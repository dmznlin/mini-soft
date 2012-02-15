{*******************************************************************************
  作者: dmzn@163.com 2007-11-11
  描述: 添加,修改(程序标识,实体标识)

  备注:
  &."程序标识"用于标识一个程序的身份.
  &."实体标识"表示一个程序内的某个功能,它包括若干字典项.
  &."程序标识"是"实体标识"等于空的一个特例.
*******************************************************************************}
unit UFormEntity;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFrmEntity = class(TForm)
    BtnSave: TButton;
    Button2: TButton;
    Panel1: TPanel;
    Edit_Entity: TLabeledEdit;
    Edit_Prog: TLabeledEdit;
    Label1: TLabel;
    Edit_Desc: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnSaveClick(Sender: TObject);
    procedure Edit_ProgKeyPress(Sender: TObject; var Key: Char);
  private
    procedure LoadData(const nProgID,nEntity: string);
    {*载入数据*}
  public
    { Public declarations }
  end;

function ShowAddEntityForm: Boolean;
function ShowEditEntityForm(const nProgID,nEntity: string): Boolean;
//入口函数

implementation

{$R *.dfm}
uses
  UMgrDataDict, USysDict, ULibFun, USysConst;

//------------------------------------------------------------------------------
//Date: 2007-11-11
//Desc: 添加实体标识
function ShowAddEntityForm: Boolean;
begin
  with TFrmEntity.Create(Application) do
  begin
    Caption := '添加实体';
    Result := ShowModal = mrOK;
    Free;
  end;
end;

//Date: 2007-11-11
//Parm: 程序标识;实体标识
//Desc: 修改nProgID下的nEntity实体
function ShowEditEntityForm(const nProgID,nEntity: string): Boolean;
begin
  with TFrmEntity.Create(Application) do
  begin
    Caption := '修改实体';
    LoadData(nProgID, nEntity);
    Result := ShowModal = mrOK;
    Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 载入当前实体数据
procedure TFrmEntity.LoadData(const nProgID,nEntity: string);
var nList: TList;
    nIdx: integer;
begin
  Edit_Prog.Text := nProgID;
  Edit_Entity.Text := nEntity;
  
  Edit_Prog.ReadOnly := True;
  Edit_Entity.ReadOnly := True;
  if not gSysEntityManager.LoadProgList then Exit;

  nList := gSysEntityManager.ProgList;
  for nIdx:=nList.Count - 1 downto 0 do
   with PEntityItemData(nList[nIdx])^ do
   if (CompareText(nProgID, FProgID) = 0) and (CompareText(nEntity, FEntity) = 0) then
   begin
     Edit_Desc.Text := FTitle;
   end;
end;

//------------------------------------------------------------------------------
procedure TFrmEntity.FormCreate(Sender: TObject);
begin
  LoadFormConfig(Self);
end;

procedure TFrmEntity.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

//------------------------------------------------------------------------------
//Desc: 跳转焦点
procedure TFrmEntity.Edit_ProgKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

//Desc: 保存实体
procedure TFrmEntity.BtnSaveClick(Sender: TObject);
var nItem: TEntityItemData;
begin
  Edit_Prog.Text := Trim(Edit_Prog.Text);
  Edit_Entity.Text := Trim(Edit_Entity.Text);
  Edit_Desc.Text := Trim(Edit_Desc.Text);

  if (Edit_Prog.Text = '') then
  begin
    ShowMsg('请输入"程序标识"', sHint); Exit;
  end;

  if (Edit_Desc.Text = '') then
  begin
    ShowMsg('请输入"标识描述"', sHint); Exit;
  end;

  nItem.FProgID := Edit_Prog.Text;
  nItem.FEntity := Edit_Entity.Text;
  nItem.FTitle := Edit_Desc.Text;

  if gSysEntityManager.AddEntityToDB(nItem) then
  begin
    ShowMsg('数据提交成功', sHint);
    ModalResult := mrOK;
  end else ShowMsg('数据提交失败', sHint);
end;

end.
