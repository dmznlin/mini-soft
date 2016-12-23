{*******************************************************************************
  ����: dmzn 2008-9-24
  ����: �������ݹ��ú���

  ��ע:
  &.ʹ��BuildBaseInfoTree��������,��Ҫʵ��Tree.OnDeletetion�¼��ͷ�����
*******************************************************************************}
unit USysDataFun;

interface

uses
  Windows, Classes, ComCtrls, SysUtils, ULibFun, UDataModule, USysDB;

type
  PBaseInfoData = ^TBaseInfoData;
  TBaseInfoData = record
    FID: integer;          //Ψһ���
    FText: string;         //��������
    FPY: string;           //ƴ����д
    FMemo: string;         //��ע��Ϣ
    FGroup: string;        //��Ϣ����

    FIndex: Double;        //��������
    FSub: TList;           //�¼��ڵ�
    FPID: integer;         //�ϼ��ڵ�
    FPText: string;        //�ϼ�����
  end;

function BuildBaseInfoTree(const nTree: TTreeView; const nGroup: string = '';
 const nFilter: string = ''): Boolean;
//��������������
function LoadBaseInfoList(const nInfoList: TList; const nGroup: string): Boolean;
//������������б�
procedure DisposeBaseInfoData(const nData: Pointer);
procedure DisposeBaseInfolist(const nInfoList: TList; const nFree: Boolean);
//�ͷ���Դ

implementation

procedure DisposeBaseInfoData(const nData: Pointer);
var nInfo: PBaseInfoData;
begin
  nInfo := nData;
  if Assigned(nInfo.FSub) then
    nInfo.FSub.Free;
  Dispose(nInfo);
end;

//Desc: �ж�nSub����nFull�е�һ����
function NotSubStr(const nSub,nFull: string): Boolean;
begin
  Result := Pos(LowerCase(nSub), LowerCase(nFull)) < 1;
end;

//------------------------------------------------------------------------------
//Desc: ��nList�м������ΪnID�ļ�¼
function FindBaseInfoData(const nList: TList; const nID: integer): PBaseInfoData;
var i,nCount: integer;
    nData: PBaseInfoData;
begin
  Result := nil;
  if (nID < 1) or (not Assigned(nList)) then Exit;
  nCount := nList.Count - 1;

  for i:=0 to nCount do
  begin
    nData := nList[i];
    if nData.FID = nID then
         Result := nData
    else Result := FindBaseInfoData(nData.FSub, nID);

    if Assigned(Result) then Exit;
  end;
end;

//Desc: ������������б�
function LoadBaseInfoList(const nInfoList: TList; const nGroup: string): Boolean;
var nStr: string;
    nIdx: integer;
    nData: PBaseInfoData;
begin
  Result := False;
  if not Assigned(nInfoList) then Exit;

  nStr := 'Select * From $Base';
  if nGroup <> '' then
    nStr := nStr + ' Where B_Group=''$Group''';
  nStr := nStr + ' Order By B_Index';

  nStr := MacroValue(nStr, [MI('$Base', sTable_BaseInfo), MI('$Group', nGroup)]);
  FDM.QueryTemp(nStr);
  if FDM.SqlTemp.RecordCount < 1 then Exit;

  FDM.SqlTemp.First;
  while not FDM.SqlTemp.Eof do
  begin
    New(nData);
    nInfoList.Add(nData);

    nData.FGroup := FDM.SqlTemp.FieldByName('B_Group').AsString;
    nData.FText := FDM.SqlTemp.FieldByName('B_Text').AsString;
    nData.FPY := FDM.SqlTemp.FieldByName('B_Py').AsString;
    nData.FMemo := FDM.SqlTemp.FieldByName('B_Memo').AsString;

    nData.FID := FDM.SqlTemp.FieldByName('B_ID').AsInteger;
    nData.FIndex := FDM.SqlTemp.FieldByName('B_Index').AsFloat;
    nData.FPID := FDM.SqlTemp.FieldByName('B_PID').AsInteger;

    nData.FSub := nil;
    FDM.SqlTemp.Next;
  end;

  nIdx := 0;
  while nIdx < nInfoList.Count do
  begin
    nData := nInfoList[nIdx];
    nData := FindBaseInfoData(nInfoList, nData.FPID);
    if (not Assigned(nData)) or (nData.FID = nData.FPID) then
    begin
      Inc(nIdx); Continue;
    end;

    if not Assigned(nData.FSub) then
      nData.FSub := TList.Create;
    nData.FSub.Add(nInfoList[nIdx]);
    
    PBaseInfoData(nInfoList[nIdx]).FPText := nData.FText;
    nInfoList.Delete(nIdx);
  end;

  Result := nInfoList.Count > 0;
end;

//Desc: �ͷ�nData�ڵ�
procedure FreeBaseInfoData(const nData: PBaseInfoData);
var i,nCount: integer;
begin
  if Assigned(nData.FSub) then
  begin
    nCount := nData.FSub.Count - 1;
    for i:=0 to nCount do
      FreeBaseInfoData(nData.FSub[i]);
    nData.FSub.Free;
  end;
  Dispose(nData);
end;

//Desc: �ͷ��б�
procedure DisposeBaseInfolist(const nInfoList: TList; const nFree: Boolean);
begin
  while nInfoList.Count > 0 do
  begin
     FreeBaseInfoData(nInfoList[nInfoList.Count - 1]);
     nInfoList.Delete(nInfoList.Count - 1);
  end;
  if nFree then nInfoList.Free;
end;

//Desc: ��nTree�Ϲ����������ϵĲ������,ʹ��nFilter����
function BuildBaseInfoTree(const nTree: TTreeView; const nGroup,nFilter: string): Boolean;
var nSID: integer;
    nList: TStrings;
    nNode: TTreeNode;
    nInfoList: TList;
    i,nCount: integer;
    nData: PBaseInfoData;

    //Desc: ����nSub����nPNode���ӽڵ�
    procedure BuildSubBaseInfoTree(const nPNode: TTreeNode; const nSub: TList);
    var m,nLen: integer;
        nSNode: TTreeNode;
        nSData: PBaseInfoData;
    begin
      nLen := nSub.Count - 1;
      for m:=0 to nLen do
      begin
        nSData := nSub[m];
        nSNode := nTree.Items.AddChild(nPNode, nSData.FText);

        nSNode.Data := nSData;
        nSNode.Selected := nSData.FID = nSID;
        if nSNode.Selected then nSNode.MakeVisible;

        if Assigned(nSData.FSub) then
        begin
          nSNode.ImageIndex := 9;
          BuildSubBaseInfoTree(nSNode, nSData.FSub);
        end else nSNode.ImageIndex := 8;

        nSNode.SelectedIndex := 10;
        nSNode.Expanded := nList.IndexOf(IntToStr(nSData.FID)) > -1;
      end;
    end;
begin
  Result := False;
  nList := TStringList.Create;
  nInfoList := TList.Create;

  nTree.Items.BeginUpdate;
  try
    nCount := nTree.Items.Count - 1;
    for i:=0 to nCount do
    if nTree.Items[i].Expanded then
    begin
      nData := nTree.Items[i].Data;
      nList.Add(IntToStr(nData.FID));
    end;

    if Assigned(nTree.Selected) then
    begin
      nData := nTree.Selected.Data;
      nSID := nData.FID;
    end else nSID := -1;

    nTree.Items.Clear;
    if not LoadBaseInfoList(nInfoList, nGroup) then Exit;
    nCount := nInfoList.Count - 1;

    for i:=0 to nCount do
    begin
      nData := nInfoList[i];
      if (nFilter <> '') and NotSubStr(nFilter, nData.FPY) then
      begin
        FreeBaseInfoData(nData); Continue;
      end;
      nNode := nTree.Items.AddChild(nil, nData.FText);

      nNode.Data := nData;
      nNode.Selected := nData.FID = nSID;
      if nNode.Selected then nNode.MakeVisible;

      if Assigned(nData.FSub) then
      begin
        nNode.ImageIndex := 9;
        BuildSubBaseInfoTree(nNode, nData.FSub);
      end else nNode.ImageIndex := 8;
      
      nNode.SelectedIndex := 10;
      nNode.Expanded := nList.IndexOf(IntToStr(nData.FID)) > -1;
    end;
  finally
    nList.Free;
    nInfoList.Free;
    nTree.Items.EndUpdate;
  end;
end;

end.
