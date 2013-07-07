{*******************************************************************************
  作者: dmzn@163.com 2013-07-05
  描述: 站点区域管理
*******************************************************************************}
unit UFrameArea;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  IniFiles, UDataModule, UFormBase, UFrameNormal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxContainer, dxLayoutControl, dxorgchr, ADODB,
  cxLabel, UBitmapPanel, cxSplitter, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin;

type
  TfFrameArea = class(TfFrameNormal)
    Chart1: TdxOrgChart;
    dxLayout1Item1: TdxLayoutItem;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
  private
    { Private declarations }
    FAreaItems: TList;
    FExpandList: TStrings;
    //展开节点
    procedure ClearItemList(const nFree: Boolean);
    //清理资源
    procedure LoadAreaItemsData;
    procedure BuildAreaItemsTree;
    procedure BuildSubTree(const nParent: TdxOcNode);
    procedure InitNodeStyle(const nNode: TdxOcNode);
    //区域结构
    procedure EnumSubNodes(const nParent: TdxOcNode; const nList: TList);
    //枚举节点
  protected
    procedure OnLoadGridConfig(const nIni: TIniFile); override;
    procedure OnSaveGridConfig(const nIni: TIniFile); override;
    procedure OnInitFormData(var nDefault: Boolean; const nWhere: string = '';
     const nQuery: TADOQuery = nil); override;
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  UMgrControl, ULibFun, USysDB, USysConst;

type
  PAreaItem = ^TAreaItem;
  TAreaItem = record
    FID: string;
    FName: string;
    FMIT: string;
    FParent: string;
  end;

class function TfFrameArea.FrameID: integer;
begin
  Result := cFI_FrameArea;
end;

procedure TfFrameArea.OnLoadGridConfig(const nIni: TIniFile);
var nInt: Integer;
begin
  inherited;
  FAreaItems := TList.Create;
  FExpandList := TStringList.Create;

  nInt := nIni.ReadInteger(Name, 'GridHeight', 0);
  if nInt > 0 then cxGrid1.Height := nInt;

  if gSysParam.FSysDBType <> sFlag_DB_HQArea then
  begin
    for nInt:=ToolBar1.ButtonCount - 1 downto 0 do
      ToolBar1.Buttons[nInt].Enabled := False;
    ShowMsg('无效的区域数据库', sHint);
  end;
end;

procedure TfFrameArea.OnSaveGridConfig(const nIni: TIniFile);
begin
  ClearItemList(True);
  FreeAndNil(FExpandList);
  
  inherited;
  nIni.WriteInteger(Name, 'GridHeight', cxGrid1.Height);
end;

procedure TfFrameArea.OnInitFormData(var nDefault: Boolean;
  const nWhere: string; const nQuery: TADOQuery);
begin
  nDefault := False;
  if gSysParam.FSysDBType = sFlag_DB_HQArea then
    BuildAreaItemsTree;
  //xxxxx
end;

//------------------------------------------------------------------------------
//Date: 2013-07-05
//Parm: 释放
//Desc: 释放区域列表
procedure TfFrameArea.ClearItemList(const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx:=FAreaItems.Count - 1 downto 0 do
  begin
    Dispose(PAreaItem(FAreaItems[nIdx]));
    FAreaItems.Delete(nIdx);
  end;

  if nFree then
    FreeAndNil(FAreaItems);
  //xxxxx
end;

//Date: 2013-07-06
//Parm: 父几点；列表
//Desc: 枚举nParent下的所有子节点
procedure TfFrameArea.EnumSubNodes(const nParent: TdxOcNode; const nList: TList);
var nNode: TdxOcNode;
begin
  nNode := nParent.GetFirstChild;
  while Assigned(nNode) do
  begin
    nList.Add(Pointer(nNode));
    EnumSubNodes(nNode, nList);
    nNode := nParent.GetNextChild(nNode);
  end;
end;

//Date: 2013-07-05
//Desc: 读取区域数据
procedure TfFrameArea.LoadAreaItemsData;
var nStr: string;
    nItem: PAreaItem;
begin
  ClearItemList(False);
  nStr := 'Select * From %s Order By A_Index';
  nStr := Format(nStr, [sTable_Area]);

  with FDM.QuerySQL(nStr) do
  begin
    if RecordCount < 1 then Exit;
    First;

    while not Eof do
    begin
      New(nItem);
      FAreaItems.Add(nItem);

      nItem.FID := FieldByName('A_ID').AsString;
      nItem.FName := FieldByName('A_Name').AsString;
      nItem.FMIT := FieldByName('A_MIT').AsString;
      nItem.FParent := FieldByName('A_Parent').AsString;

      Next;
    end;
  end;
end;

procedure TfFrameArea.InitNodeStyle(const nNode: TdxOcNode);
begin
  if nNode.Level = 0 then
  begin
    nNode.Text := '华新商砼';
  end;  
end;

//Date: 2013-07-05
//Desc: 构建区域树
procedure TfFrameArea.BuildAreaItemsTree;
var nIdx: Integer;
    nItem: PAreaItem;
    nNode,nTmp: TdxOcNode;
begin
  Chart1.BeginUpdate;
  try
    FExpandList.Clear;
    nNode := Chart1.GetFirstNode;

    while Assigned(nNode) do
    begin
      if nNode.HasChildren and nNode.Expanded then
      begin
        nItem := nNode.Data;
        if Assigned(nItem) then
          FExpandList.Add(nItem.FID);
        //xxxxx
      end;

      nNode := nNode.GetNext;
    end;

    LoadAreaItemsData;
    //载入数据
    Chart1.Clear;
    
    nNode := Chart1.Add(nil, nil);
    InitNodeStyle(nNode);

    for nIdx:=0 to FAreaItems.Count - 1 do
    begin
      nItem := FAreaItems[nIdx];
      if nItem.FParent <> '' then Continue;

      nTmp := Chart1.AddChild(nNode, nItem);
      nTmp.Text := nItem.FName;
      InitNodeStyle(nTmp);

      BuildSubTree(nTmp);
      //构建子节点
    end;

    nNode := Chart1.GetFirstNode;
    while Assigned(nNode) do
    begin
      if nNode.HasChildren then
      begin
        nItem := nNode.Data;
        if (not Assigned(nItem)) or (FExpandList.IndexOf(nItem.FID) >= 0) then
          nNode.Expand(False);
        //restore
      end;

      nNode := nNode.GetNext;
    end;
  finally
    Chart1.EndUpdate;
  end;
end;

procedure TfFrameArea.BuildSubTree(const nParent: TdxOcNode);
var nIdx: Integer;
    nNode: TdxOcNode;
    nItem,nP: PAreaItem;
begin
  nP := nParent.Data;
  //xxxxx

  for nIdx:=0 to FAreaItems.Count - 1 do
  begin
    nItem := FAreaItems[nIdx];
    if nItem.FParent <> nP.FID then Continue;

    nNode := Chart1.AddChild(nParent, nItem);
    nNode.Text := nItem.FName;
    InitNodeStyle(nNode);

    BuildSubTree(nNode);
    //构建子节点
  end;
end;

procedure TfFrameArea.BtnAddClick(Sender: TObject);
var nStr: string;
    nParam: TFormCommandParam;
begin
  if not Assigned(Chart1.Selected) then
  begin
    ShowMsg('请选择上级节点', sHint); Exit;
  end;

  if Chart1.Selected.Level = 0 then
  begin
    nStr := '';
  end else
  begin
    if PAreaItem(Chart1.Selected.Data).FMIT = '' then
         nStr := PAreaItem(Chart1.Selected.Data).FID
    else nStr := PAreaItem(Chart1.Selected.Parent.Data).FID;
  end;

  nParam.FCommand := cCmd_AddData;
  nParam.FParamA := nStr;
  CreateBaseFormItem(cFI_FormArea, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData();
  end;
end;

procedure TfFrameArea.BtnEditClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if (not Assigned(Chart1.Selected)) or (Chart1.Selected.Level < 1) then
  begin
    ShowMsg('请选择要编辑的节点', sHint); Exit;
  end;

  nParam.FCommand := cCmd_EditData;
  nParam.FParamA := PAreaItem(Chart1.Selected.Data).FID;
  CreateBaseFormItem(cFI_FormArea, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData();
  end;
end;

procedure TfFrameArea.BtnDelClick(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nList: TList;
    nNode: TdxOcNode;
begin
  if (not Assigned(Chart1.Selected)) or (Chart1.Selected.Level < 1) then
  begin
    ShowMsg('请选择要删除的节点', sHint); Exit;
  end;

  nStr := '确定要删除【%s】节点吗？';
  nStr := Format(nStr, [PAreaItem(Chart1.Selected.Data).FName]);
  if not QueryDlg(nStr, sAsk) then Exit;

  nStr := '';
  nList := TList.Create;
  try
    nList.Add(Chart1.Selected);
    EnumSubNodes(Chart1.Selected, nList);

    for nIdx:=0 to nList.Count - 1 do
    begin
      nNode := TdxOcNode(nList[nIdx]);
      if nIdx = 0 then
           nStr := Format('''%s''', [PAreaItem(nNode.Data).FID])
      else nStr := nStr + Format(',''%s''', [PAreaItem(nNode.Data).FID]);
    end;  
  finally
    nList.Free;
  end;

  nStr := Format('Delete From %s Where A_ID In (%s)', [sTable_Area, nStr]);
  FDM.ExecuteSQL(nStr);
  InitFormData();
end;

initialization
  gControlManager.RegCtrl(TfFrameArea, TfFrameArea.FrameID);
end.
