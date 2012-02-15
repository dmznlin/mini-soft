{*******************************************************************************
  作者: dmzn 2008-9-3
  描述: 编辑特定方式的数据
*******************************************************************************}
unit UFormDataEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Grids, ValEdit, ExtCtrls, Buttons, ImgList;

type
  TDataEditStyle = set of (dsText, dsList);
  //编辑风格

  TfFormDataEdit = class(TForm)
    wPage: TPageControl;
    Sheet1: TTabSheet;
    Sheet2: TTabSheet;
    BtnOK: TButton;
    BtnExit: TButton;
    Edit_Text: TMemo;
    Edit_List: TListView;
    Edit_Data: TLabeledEdit;
    Edit_Display: TLabeledEdit;
    BtnSave: TSpeedButton;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnSaveClick(Sender: TObject);
    procedure Edit_ListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit_ListKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_DataKeyPress(Sender: TObject; var Key: Char);
    procedure wPageChange(Sender: TObject);
  private
    { Private declarations }
    FEditStyle: TDataEditStyle;
    {*格式化方式*}
    procedure LoadEditData(const nData: string);
    {*载入数据*}
    function GetEditResult: string;
    {*格式化数据*}
  public
    { Public declarations }
  end;

function ShowDataEditForm(const nStyle: TDataEditStyle; var nData: string;
  const nMaxLen: integer = 0): Boolean;
//入口函数

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, USysFun, USysConst;

//Desc: 显示编辑格式化数据窗口
function ShowDataEditForm(const nStyle: TDataEditStyle; var nData: string;
  const nMaxLen: integer = 0): Boolean;
begin
  with TfFormDataEdit.Create(Application) do
  begin
    FEditStyle := nStyle;
    Caption := '编辑数据';
    Edit_Text.MaxLength := nMaxLen;

    LoadEditData(nData);
    Result := ShowModal = mrOK;
    if Result then nData := GetEditResult;
    Free;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormDataEdit.FormCreate(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self);
    nStr := nIni.ReadString(Name, 'ListWidth', '');
    if nStr <> '' then LoadListViewColumn(nStr, Edit_List);
  finally
    nIni.Free;
  end;
end;

procedure TfFormDataEdit.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self);
    nIni.WriteString(Name, 'ListWidth', MakeListViewColumnInfo(Edit_List));
  finally
    nIni.Free;
  end;
end;

//Desc: 载入nData数据
procedure TfFormDataEdit.LoadEditData(const nData: string);
var nList: TStrings;
    i,nCount,nPos: integer;
begin
  Sheet1.TabVisible := dsList in FEditStyle;
  Sheet2.TabVisible := dsText in FEditStyle;

  if dsText in FEditStyle then
  begin
    Edit_Text.Text := nData;
  end;

  if dsList in FEditStyle then
  begin
    Edit_List.Clear;
    nList := TStringList.Create;
    try
      nList.Text := StringReplace(nData, ';', #13, [rfReplaceAll]);
      nCount := nList.Count - 1;

      for i:=0 to nCount do
      begin
        nPos := Pos('=', nList[i]);
        if nPos > 0 then
        with Edit_List.Items.Add do
        begin
          ImageIndex := 0;
          Caption := Copy(nList[i], 1, nPos - 1);
          SubItems.Add(Copy(nList[i], nPos + 1, MaxInt));
        end;
      end;
    finally
      nList.Free;
    end;
  end;
end;

//Desc: 载入nData数据到界面 
function TfFormDataEdit.GetEditResult: string;
var nStr: string;
    i,nCount: integer;
begin
  Result := '';
  if wPage.ActivePage = Sheet2 then
  begin
    Result := Trim(Edit_Text.Text);
  end else

  if wPage.ActivePage = Sheet1 then
  begin
    nCount := Edit_List.Items.Count - 1;
    for i:=0 to nCount do
    with Edit_List do
    begin
      nStr := Items[i].Caption + '=' + Items[i].SubItems[0];
      if Result = '' then
           Result := nStr
      else Result := Result + ';' + nStr;
    end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 提交数据到列表
procedure TfFormDataEdit.BtnSaveClick(Sender: TObject);
var i,nCount: integer;
begin
  Edit_Data.SetFocus;
  nCount := Edit_List.Items.Count - 1;
  
  for i:=0 to nCount do
   if Edit_List.Items[i].Caption = Edit_Data.Text then
   begin
     Edit_List.Items[i].SubItems[0] := Edit_Display.Text; Exit;
   end;

  with Edit_List.Items.Add do
  begin
    ImageIndex := 0;
    Caption := Edit_Data.Text;
    SubItems.Add(Edit_Display.Text);
  end;
end;

//Desc: 显示选中记录
procedure TfFormDataEdit.Edit_ListSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if Selected then
  begin
    Edit_Data.Text := Item.Caption;
    Edit_Display.Text := Item.SubItems[0];
  end;
end;

//Desc: 删除记录
procedure TfFormDataEdit.Edit_ListKeyPress(Sender: TObject; var Key: Char);
var nIdx: integer;
begin
  if ((Key = 'D') or (Key = 'd')) and Assigned(Edit_List.Selected) then
  begin
    Key := #0;
    nIdx := Edit_List.Selected.Index;
    Edit_List.Selected.Delete;

    if nIdx < Edit_List.Items.Count then
      Edit_List.Items[nIdx].Selected := True;
    //new item
  end;
end;

//Desc: 切换焦点
procedure TfFormDataEdit.Edit_DataKeyPress(Sender: TObject; var Key: Char);
begin
  case Ord(Key) of
    VK_Return:
      begin
        if Sender = Edit_Display then
             BtnSave.Click
        else SwitchFocusCtrl(Self, True);
      end;
    VK_Left,VK_UP: SwitchFocusCtrl(Self, False);
    VK_Right,VK_Down: SwitchFocusCtrl(Self, True);
  end;

  case Ord(Key) of
    VK_Return,VK_Left,VK_UP,VK_Right,VK_Down: Key := #0;
  end;
end;

//Desc: 切换焦点
procedure TfFormDataEdit.wPageChange(Sender: TObject);
begin
  if wPage.ActivePage = Sheet1 then
  begin
    Edit_Data.SetFocus;
  end else

  if wPage.ActivePage = Sheet2 then
  begin
    Edit_Text.SetFocus;
  end;
end;

end.
