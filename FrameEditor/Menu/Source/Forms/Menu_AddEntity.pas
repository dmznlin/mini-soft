{*******************************************************************************
  作者: dmzn@163.com 2007-11-11
  描述: 添加,修改(程序标识,实体标识)

  备注:
  &."程序标识"用于标识一个程序的身份.
  &."实体标识"表示一个程序内的某个菜单,它包括若干菜单项.
  &."程序标识"是"实体标识"等于空的一个特例.
  &."提示标识"是"菜单标识"等于空的一个特了.
*******************************************************************************}
unit Menu_AddEntity;

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
    { Private declarations }
    FProgID,FEntity: string;
    {*标识*}
    procedure LoadData;
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
  Menu_DM, Menu_Const, ULibFun;

ResourceString
  sSelectEntity = 'Select M_ProgID,M_Entity,M_Title From %s where ' +
                  'M_ProgID=''%s'' and M_Entity=''%s''';
  //查询制定实体
  sInsertEntity = 'Insert into %s(M_ProgID,M_Entity,M_Title,M_MenuID,M_NewOrder) ' +
                  'Values(''%s'',''%s'',''%s'', '''', 0)';
  //追加实体
  sUpdateEntity = 'Update %s Set M_Title=''%s'' where M_ProgID=''%s'' and ' +
                  'M_Entity=''%s'' and M_MenuID=''''';
  //更新实体

//------------------------------------------------------------------------------
//Date: 2007-11-11
//Desc: 添加实体标识
function ShowAddEntityForm: Boolean;
begin
  with TFrmEntity.Create(Application) do
  begin
    FProgID := '';
    FEntity := '';
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
    FProgID := nProgID;
    FEntity := nEntity;
    Caption := '修改实体';

    LoadData;
    Result := ShowModal = mrOK;
    Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 载入当前实体数据
procedure TFrmEntity.LoadData;
begin
  FDM.SQLTemp.Close;
  FDM.SQLTemp.SQL.Text := Format(sSelectEntity, [gMenuTable, FProgID, FEntity]);
  FDM.SQLTemp.Open;

  if FDM.SQLTemp.RecordCount > 0 then
  begin
    Edit_Prog.Text := FProgID;
    Edit_Entity.Text := FEntity;
    Edit_Desc.Text := FDM.SQLTemp.FieldByName('M_Title').AsString;
  end else ShowMsg('无法定位指定"实体"', sHint);

  Edit_Prog.ReadOnly := True;
  Edit_Entity.ReadOnly := True;
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
var nStr: string;
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

  if not Edit_Prog.ReadOnly then
  begin
    nStr := Format(sSelectEntity, [gMenuTable, Edit_Prog.Text, Edit_Entity.Text]);
    FDM.SQLTemp.Close;                                                            
    FDM.SQLTemp.SQL.Text := nStr;
    FDM.SQLTemp.Open;

    if FDM.SQLTemp.RecordCount > 0 then
    begin
      ShowMsg('该实体已经存在', sHint); Exit;
    end;
  end;

  if Edit_Prog.ReadOnly then
       nStr := Format(sUpdateEntity, [gMenuTable, Edit_Desc.Text, Edit_Prog.Text, Edit_Entity.Text])
  else nStr := Format(sInsertEntity, [gMenuTable, Edit_Prog.Text, Edit_Entity.Text, Edit_Desc.Text]);

  FDM.SQLCmd.Close;
  FDM.SQLCmd.SQL.Text := nStr;
  if FDM.SQLCmd.ExecSQL > 0 then
  begin
    ShowMsg('数据提交成功', sHint);
    ModalResult := mrOK;
  end else ShowMsg('数据好像提交失败', sHint);
end;

end.
