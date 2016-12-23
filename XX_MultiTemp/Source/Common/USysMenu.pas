unit USysMenu;

interface

uses
  Windows, Classes, DB, Menus, SysUtils, UDataModule, UMgrMenu, USysDB,
  USysConst, USysPopedom;

type
  TSysMenuManager = class(TBaseMenuManager)
  protected
    function QuerySQL(const nSQL: string;
      var nDS: TDataSet; var nAutoFree: Boolean): Boolean; override;
    function ExecSQL(const nSQL: string): integer; override;

    function GetItemValue(const nItem: integer): string; override;
    function IsTableExists(const nTable: string): Boolean; override;
    {*��������*}
    procedure BuildSubMenu(const nMenu: TMenu; const nPItem: TMenuItem;
     const nSub: TList; const nEvent: TNotifyEvent);
    {*�����Ӳ˵�*}
    procedure EnumSubList(const nList,nSub: TList);
    {*ö���Ӳ˵���*}
  public
    function BuildMenu(const nMenu: TMenu; const nEntity: string;
     const nEvent: TNotifyEvent): Boolean;
    {*����ָ���˵�*}
    function BuildMenuItemList(const nMenuID: string;
      const nList: TList): Boolean; overload;
    function BuildMenuItemList(const nList: TList): Boolean; overload;
    {*��ȡ�˵����б�*}

    function IsValidProgID: Boolean;
    {*��ǰ��ʶ�Ƿ���Ч*}
    function MenuName(const nEntity,nMenuID: string): string;
    {*�����˵���*}
  end;

var
  gMenuManager: TSysMenuManager = nil;
  //ȫ�ֲ˵�������

ResourceString
  //���˵�ʵ����
  sEntity_MenuMain   = 'MAIN';

  //���µ�¼
  sMenuItem_ReLoad   = 'SYSRELOAD';

  //�ر�ϵͳ
  sMenuItem_Close    = 'SYSCLOSE';

  cMenuFlag_SS       = '|';        //�ָ��,Split Symbol
  cMenuFlag_NSS      = '_';        //�ָ���,Name Split Symbol
  cMenuFlag_Open     = 'EX';       //Execute,ִ������
  
  cMenuFlag_UF       = 'UF';       //���ù���,usually function
  cMenuFlag_NB       = 'NB';       //����ʾ�ڵ�������,No Navbar
  cMenuFlag_NR       = 'NR';       //����ʾ�����ʹ�õ�����,NoRecent

implementation

function TSysMenuManager.ExecSQL(const nSQL: string): integer;
begin
  FDM.Command.Close;
  FDM.Command.SQL.Text := nSQL;
  Result := FDM.Command.ExecSQL;
end;

function TSysMenuManager.GetItemValue(const nItem: integer): string;
begin
  case nItem of
    cMenuTable_Menu: Result := sTable_Menu;
  end;
end;

function TSysMenuManager.IsTableExists(const nTable: string): Boolean;
var nList: TStrings;
begin
  nList := TStringList.Create;
  try
    FDM.ADOConn.GetTableNames(nList);
    Result := nList.IndexOf(nTable) > 0;
  finally
    nList.Free;
  end;
end;

function TSysMenuManager.QuerySQL(const nSQL: string; var nDS: TDataSet;
  var nAutoFree: Boolean): Boolean;
begin
  FDM.SqlTemp.Close;
  FDM.SqlTemp.SQL.Text := nSQL;
  FDM.SqlTemp.Open;

  nDS := FDM.SqlTemp;
  Result := FDM.SqlTemp.RecordCount > 0;
end;

//Date: 2008-09-18
//Desc: �жϵ�ǰ�����ʶ�Ƿ�Ϸ�
function TSysMenuManager.IsValidProgID: Boolean;
var nList: TList;
    i,nCount: integer;
    nItem: PMenuItemData;
begin
  Result := False;
  nList := Self.GetProgList;
  nCount := nList.Count - 1;

  for i:=0 to nCount do
  begin
    nItem := nList[i];
    if nItem.FProgID = gSysParam.FProgID then
    begin
      Result := True; Break;
    end;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2008-09-18
//Parm: ����б�
//Desc: ö�ٵ�ǰ����û���Ӳ˵��Ĳ˵���,����nList��
function TSysMenuManager.BuildMenuItemList(const nList: TList): Boolean;
begin
  Result := False;
  if Assigned(nList) then
  begin
    nList.Clear;
    EnumSubList(nList, TopMenus);
    Result := nList.Count > 0;
  end;
end;

//Date: 2009-5-26
//Parm: �˵�ID;����б�
//Desc: ö��nMenuID����û���Ӳ˵��Ĳ˵���,����nList��
function TSysMenuManager.BuildMenuItemList(const nMenuID: string;
  const nList: TList): Boolean;
var nP: PMenuItemData;
begin
  Result := False;
  if Assigned(nList) then
  begin
    nList.Clear;
    nP := GetMenuItem(sEntity_MenuMain, nMenuID);
    
    if Assigned(nP) and Assigned(nP.FSubMenu) then
      EnumSubList(nList, nP.FSubMenu);
    Result := nList.Count > 0;
  end;
end;

//Date: 2007-11-26
//Parm: ����б�;�Ӳ˵��б�
//Desc: ��nSub�Ӳ˵�������û���Ӳ˵��������nList��
procedure TSysMenuManager.EnumSubList(const nList, nSub: TList);
var i,nCount: integer;
    nData: PMenuItemData;
begin
  nCount := nSub.Count - 1;
  for i:=0 to nCount do
  begin
    nData := nSub[i];
    if (nData.FMenuID = '') or (nData.FTitle = '-') then Continue;
    
    if Assigned(nData.FSubMenu) then
         EnumSubList(nList, nData.FSubMenu)
    else nList.Add(nData);
  end;
end;

//------------------------------------------------------------------------------
//Desc: ����ʵ��nEntity��nMenuID�˵�����齨����
function TSysMenuManager.MenuName(const nEntity, nMenuID: string): string;
begin
  Result := nEntity + cMenuFlag_NSS + nMenuID;
end;

//Date: 2008-09-18
//Parm: ���˵�;�ϼ��˵�;�Ӳ˵��б�;�¼�
//Desc: ��nSub��ӵ�nPItem,ͬʱ�����¼�nEvent
procedure TSysMenuManager.BuildSubMenu(const nMenu: TMenu;
  const nPItem: TMenuItem; const nSub: TList; const nEvent: TNotifyEvent);
var nStr: string;
    nItem: TMenuItem;
    i,nCount: integer;
    nData: PMenuItemData;
begin
  nCount := nSub.Count  - 1;
  for i:=0 to nCount do
  begin
    nData := nSub[i];
    nStr := MenuName(nData.FEntity, nData.FMenuID);
    if nData.FTitle <> '-' then
      if not gPopedomManager.HasPopedom(nStr, sPopedom_Read) then Continue;

    nItem := TMenuItem.Create(nMenu);

    nItem.Name := nStr;
    nItem.OnClick := nEvent;
    nItem.Caption := nData.FTitle;

    nPItem.Add(nItem);
    if Assigned(nData.FSubMenu) then
      BuildSubMenu(nMenu, nItem, nData.FSubMenu, nEvent);
  end; 
end;

//Date: 2008-09-18
//Parm: ���˵�;ʵ���ʶ;�¼�
//Desc: ��ʵ��ΪnEntity�Ĳ˵������뵽nMenu��,ͬʱ�����¼�nEvent
function TSysMenuManager.BuildMenu(const nMenu: TMenu;
  const nEntity: string; const nEvent: TNotifyEvent): Boolean;
var nStr: string;
    nList: TList;
    nItem: TMenuItem;
    i,nCount: integer;
    nData: PMenuItemData;
begin
  Result := False;
  nMenu.Items.Clear;
  nList := TList.Create;
  try
    if GetMenuList(nList, nEntity) then
    begin
      nCount := nList.Count - 1;
      for i:=0 to nCount do
      begin
        nData := nList[i];
        nStr := MenuName(nData.FEntity, nData.FMenuID);
        if nData.FTitle <> '-' then
          if not gPopedomManager.HasPopedom(nStr, sPopedom_Read) then Continue;

        nItem := TMenuItem.Create(nMenu);  
        nItem.Name := nStr;
        nItem.Caption := nData.FTitle;

        nItem.OnClick := nEvent;
        nItem.ImageIndex := nData.FImgIndex;
        nMenu.Items.Add(nItem);
        
        if Assigned(nData.FSubMenu) then
          BuildSubMenu(nMenu, nItem, nData.FSubMenu, nEvent);
      end;

      Result := True;
    end;
  finally
    nList.Free;
  end;
end;

initialization
  gMenuManager := TSysMenuManager.Create;
finalization
  FreeAndNil(gMenuManager);
end.
