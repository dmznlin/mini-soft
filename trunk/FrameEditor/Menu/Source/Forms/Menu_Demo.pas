{*******************************************************************************
  作者: dmzn@163.com 2007-11-18
  描述: 预览菜单设计结果
*******************************************************************************}
unit Menu_Demo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UMgrMenu, Menus;

type
  TFrmDemo = class(TForm)
    MainMenu1: TMainMenu;
    PopupMenu1: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FManager: TBaseMenuManager;
    procedure CreateMenu(const nMenu: TMenu; const nEntity: string);
    procedure CreateSubMenu(const nPItem: TMenuItem; const nSub: TList);
  public
    { Public declarations }
  end;

procedure ShowPreviewForm(const nMgr: TBaseMenuManager; const nProgID,nEntity: string);
//入口函数

implementation

{$R *.dfm}
uses
  ULibFun;

procedure ShowPreviewForm(const nMgr: TBaseMenuManager; const nProgID,nEntity: string);
begin
  if not nMgr.LoadMenuFromDB(nProgID) then
  begin
    ShowMsg('无法载入该程序的菜单数据', nProgID); Exit;
  end;

  with TFrmDemo.Create(Application) do
  begin
    Caption := '预览';
    FManager := nMgr;

    CreateMenu(MainMenu1, nEntity);
    CreateMenu(PopupMenu1, nEntity);
    ShowModal;
    Free;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2007-11-18
//Parm: 待构建菜单;实体名称
//Desc: 将nEntity实体的菜单项加载到nMenu上
procedure TFrmDemo.CreateMenu(const nMenu: TMenu; const nEntity: string);
var nList: TList;
    i,nCount: integer;
    nItem: TMenuItem;
    nData: PMenuItemData;
begin
  nList := TList.Create;
  try
    if not FManager.GetMenuList(nList, nEntity) then Exit;
    nCount := nList.Count - 1;

    for i:=0 to nCount do
    begin
      nData := nList[i];
      nItem := TMenuItem.Create(nMenu);
      nItem.Caption := nData.FTitle;

      nMenu.Items.Add(nItem);
      if Assigned(nData.FSubMenu) then
        CreateSubMenu(nItem, nData.FSubMenu);
      //加载子菜单
    end;
  finally
    nList.Free;
  end;
end;

//Date: 2007-11-18
//Parm: 父菜单;子菜单项数据列表
//Desc: 依据nSub的数据构建nPItem的子菜单
procedure TFrmDemo.CreateSubMenu(const nPItem: TMenuItem;
  const nSub: TList);
var nItem: TMenuItem;
    i,nCount: integer;
    nData: PMenuItemData;
begin
  nCount := nSub.Count - 1;
  for i:=0 to nCount do
  begin
    nData := nSub[i];
    nItem := TMenuItem.Create(nPItem);
    nItem.Caption := nData.FTitle;

    nPItem.Add(nItem);
    if assigned(nData.FSubMenu) then
      CreateSubMenu(nItem, nData.FSubMenu);
    //多级子菜单加载
  end;
end;

//------------------------------------------------------------------------------
procedure TFrmDemo.FormCreate(Sender: TObject);
begin
  LoadFormConfig(Self);
end;

procedure TFrmDemo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

end.
