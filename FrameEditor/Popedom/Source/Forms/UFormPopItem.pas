{*******************************************************************************
  作者: dmzn@163.com 2008-8-20
  描述: 管理权限项
*******************************************************************************}
unit UFormPopitem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, ImgList, Menus;

type
  TfFormPopItem = class(TForm)
    Lv1: TListView;
    GroupBox1: TGroupBox;
    BtnExit: TButton;
    Label1: TLabel;
    EditID: TComboBox;
    EditName: TLabeledEdit;
    ImageList1: TImageList;
    BtnSave: TButton;
    PMenu1: TPopupMenu;
    mDelete: TMenuItem;
    mRefresh: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnSaveClick(Sender: TObject);
    procedure Lv1Click(Sender: TObject);
    procedure mRefreshClick(Sender: TObject);
    procedure mDeleteClick(Sender: TObject);
    procedure EditIDKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure LoadPopItems;
    procedure InitFormData;
    {*初始化数据*}

    function BuildValidSQL: string;
    {*构建语句*}
  public
    { Public declarations }
  end;

procedure ShowPopItemSetupForm;
//入口函数

implementation

{$R *.dfm}
uses
  IniFiles, UDataModule, ULibFun, USysFun, USysConst, USysPopedom;

//------------------------------------------------------------------------------
procedure ShowPopItemSetupForm;
begin
  with TfFormPopItem.Create(Application) do
  begin
    Caption := '权限项';
    InitFormData;
    ShowModal;
    Free;
  end;
end;

procedure TfFormPopItem.FormCreate(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    nStr := nIni.ReadString(Name, 'LvWidth', '');
    LoadListViewColumn(nStr, Lv1);
  finally
    nIni.Free;
  end;
end;

procedure TfFormPopItem.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    nIni.WriteString(Name, 'LvWidth', MakeListViewColumnInfo(Lv1));
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 载入权限项
procedure TfFormPopItem.LoadPopItems;
var nStr,nID: string;
    nList: TStrings;
    i,nCount,nPos: integer;
begin
  nList := TStringList.Create;
  try
    if Assigned(Lv1.Selected) then
         nID := Lv1.Selected.Caption
    else nID := '';

    Lv1.Clear;
    gPopedomManager.LoadPopItemList(nList, gSysParam.FProgID);
    nCount := nList.Count - 1;

    for i:=0 to nCount do
    with Lv1.Items.Add do
    begin
      nStr := nList[i];
      nPos := Pos(';', nList[i]);
      //ID;Name

      Caption := Copy(nStr, 1, nPos - 1);
      System.Delete(nStr, 1, nPos);
      SubItems.Add(nStr);

      ImageIndex := 0;
      if Caption = nID then
      begin
        Selected := True;
        MakeVisible(True);
      end;
    end;
  finally
    nList.Free;
  end;
end;

//Desc: 初始化界面
procedure TfFormPopItem.InitFormData;
var i,nCount: integer;
begin
  EditID.Items.Clear;
  nCount := Ord('9');

  for i:=Ord('0') to nCount do
    EditID.Items.Add(Char(i));
  //number

  nCount := Ord('Z');
  for i:=Ord('A') to nCount do
    EditID.Items.Add(Char(i));
  //charactor

  LoadPopItems;
  //popedom items
end;

//Desc: 构建语句
function TfFormPopItem.BuildValidSQL: string;
var nStr: string;
begin
  nStr := 'Select Count(*) From $Table Where P_ID=''$ID'' and P_ProgID=''$PID''';
  nStr := MacroValue(nStr, [MI('$Table', gSysParam.FTablePopItem),
                            MI('$ID', EditID.Text), MI('$PID', gSysParam.FProgID)]);

  FDM.SQLQuery.Close;
  FDM.SQLQuery.SQL.Text := nStr;
  FDM.SQLQuery.Open;

  if FDM.SQLQuery.Fields[0].AsInteger > 0 then
       Result := 'Update $Table Set P_Name=''$Name'' Where P_ID=''$ID'''
  else Result := 'Insert into $Table(P_ID, P_ProgID, P_Name) Values(''$ID'', ''$PID'',''$Name'')';

  Result := MacroValue(Result, [MI('$Table', gSysParam.FTablePopItem),
            MI('$Name', EditName.Text), MI('$ID', EditID.Text),
            MI('$PID', gSysParam.FProgID)]);
  //adjust macro
end;

//Desc: 保存
procedure TfFormPopItem.BtnSaveClick(Sender: TObject);
begin
  if EditID.ItemIndex < 0 then
  begin
    EditID.SetFocus;
    ShowMsg('请选择有效的权限标记', sHint); Exit;
  end;

  BtnSave.Enabled := False;
  try
    FDM.Command.Close;
    FDM.Command.SQL.Text := BuildValidSQL;
    if FDM.Command.ExecSQL > -1 then
    begin
      ShowMsg('保存成功', sHint);
      LoadPopItems;
    end;
  finally
    BtnSave.Enabled := True;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 同步界面
procedure TfFormPopItem.Lv1Click(Sender: TObject);
begin
  if Assigned(Lv1.Selected) then
  begin
    EditID.ItemIndex := EditID.Items.IndexOf(Lv1.Selected.Caption);
    EditName.Text := Lv1.Selected.SubItems[0];
  end;
end;

//Desc: 刷新
procedure TfFormPopItem.mRefreshClick(Sender: TObject);
begin
  LoadPopItems;
end;

//Desc: 删除
procedure TfFormPopItem.mDeleteClick(Sender: TObject);
var nStr: string;
begin
  if Assigned(Lv1.Selected) then
  begin
    nStr := 'Delete From %s Where P_ID=''%s''';
    nStr := Format(nStr, [gSysParam.FTablePopItem, Lv1.Selected.Caption]);

    FDM.Command.Close;
    FDM.Command.SQL.Text := nStr;
    if FDM.Command.ExecSQL > 0 then
    begin
      LoadPopItems;
      ShowMsg('删除成功', sHint);
    end;
  end;
end;

//Desc: 切换焦点
procedure TfFormPopItem.EditIDKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_Return: BtnSave.Click;
    VK_Left: SwitchFocusCtrl(Self, False);
    VK_Right: SwitchFocusCtrl(Self, True);
  end;
end;

end.

