{*******************************************************************************
  作者: dmzn@163.com 2012-2-24
  描述: 运行参数
*******************************************************************************}
unit UFrameParam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, StdCtrls, ExtCtrls, ComCtrls, ImgList, Menus,
  CheckLst, Buttons;

type
  TfFrameParam = class(TfFrameBase)
    ImageList1: TImageList;
    wPage: TPageControl;
    TabSheet1: TTabSheet;
    Group1: TGroupBox;
    Label1: TLabel;
    CheckAutoMin: TCheckBox;
    CheckAutoRun: TCheckBox;
    TabSheet3: TTabSheet;
    Label2: TLabel;
    GroupPack: TGroupBox;
    ListPack: TCheckListBox;
    Label3: TLabel;
    TabSheet4: TTabSheet;
    Bevel1: TBevel;
    Label4: TLabel;
    Label6: TLabel;
    NamesDB: TComboBox;
    Label7: TLabel;
    NamesPerform: TComboBox;
    EditPack: TLabeledEdit;
    BtnAddPack: TSpeedButton;
    BtnDelPack: TSpeedButton;
    GroupDB: TGroupBox;
    Label10: TLabel;
    Bevel3: TBevel;
    Label11: TLabel;
    BtnAddDB: TSpeedButton;
    BtnDelDB: TSpeedButton;
    ListDB: TCheckListBox;
    EditDB: TLabeledEdit;
    LabeledEdit12: TLabeledEdit;
    LabeledEdit13: TLabeledEdit;
    LabeledEdit14: TLabeledEdit;
    LabeledEdit15: TLabeledEdit;
    LabeledEdit16: TLabeledEdit;
    LabeledEdit17: TLabeledEdit;
    MemoConn: TMemo;
    Label12: TLabel;
    GroupPerform: TGroupBox;
    Label13: TLabel;
    Bevel4: TBevel;
    Label14: TLabel;
    BtnAddPerform: TSpeedButton;
    BtnDelPerform: TSpeedButton;
    ListPerform: TCheckListBox;
    EditPerform: TLabeledEdit;
    LabeledEdit18: TLabeledEdit;
    LabeledEdit19: TLabeledEdit;
    LabeledEdit20: TLabeledEdit;
    LabeledEdit21: TLabeledEdit;
    LabeledEdit22: TLabeledEdit;
    Label15: TLabel;
    EditBehConn: TComboBox;
    Label16: TLabel;
    EditBehBus: TComboBox;
    LabeledEdit11: TLabeledEdit;
    LabeledEdit23: TLabeledEdit;
    procedure CheckAutoRunClick(Sender: TObject);
    procedure BtnAddDBClick(Sender: TObject);
    procedure BtnDelDBClick(Sender: TObject);
    procedure ListDBClick(Sender: TObject);
    procedure EditDBChange(Sender: TObject);
    procedure BtnAddPerformClick(Sender: TObject);
    procedure BtnDelPerformClick(Sender: TObject);
    procedure ListPerformClick(Sender: TObject);
    procedure EditPerformChange(Sender: TObject);
    procedure wPageChange(Sender: TObject);
    procedure BtnAddPackClick(Sender: TObject);
    procedure BtnDelPackClick(Sender: TObject);
    procedure ListPackClick(Sender: TObject);
    procedure EditPackChange(Sender: TObject);
    procedure ListPackClickCheck(Sender: TObject);
  private
    { Private declarations }
    function GetEditText(const nFlag: string): string;
    procedure SetEditText(const nFlag,nText: string);
    //读写内容
    procedure CheckItem(const nID: string; const nList: TCheckListBox);
    //选中指定项
  public
    { Public declarations }
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UMgrDBConn, USysShareMem, UParamManager,
  USysLoger, USmallFunc, UMITConst, uROClassFactories;

class function TfFrameParam.FrameID: integer;
begin
  Result := cFI_FrameParam;
end;

procedure TfFrameParam.OnCreateFrame;
begin
  inherited;
  Name := MakeFrameName(FrameID);

  wPage.ActivePage := TabSheet1;
  CheckAutoMin.Checked := gSysParam.FAutoMin;
  CheckAutoRun.Checked := gSysParam.FAutoStart;

  with gParamManager do
  begin
    LoadParam(NamesDB.Items, ptDB);
    LoadParam(NamesPerform.Items, ptPerform);

    LoadParam(ListPack.Items, ptPack);
    ListPackClickCheck(ListPack);

    LoadParam(ListDB.Items, ptDB);
    ListPackClickCheck(ListDB);

    LoadParam(ListPerform.Items, ptPerform);
    ListPackClickCheck(ListPerform);
  end;
end;

procedure TfFrameParam.OnDestroyFrame;
begin

  inherited;
end;

//------------------------------------------------------------------------------
procedure TfFrameParam.CheckAutoRunClick(Sender: TObject);
begin
  if Sender = CheckAutoMin then
    gSysParam.FAutoMin := CheckAutoMin.Checked;
  if Sender = CheckAutoRun then
    gSysParam.FAutoStart := CheckAutoRun.Checked;
end;

//Desc: 更新列表
procedure TfFrameParam.wPageChange(Sender: TObject);
begin
  if (wPage.ActivePage = TabSheet1) and gParamManager.Modified then
  begin
    gParamManager.LoadParam(NamesDB.Items, ptDB);
    gParamManager.LoadParam(NamesPerform.Items, ptPerform);
    gParamManager.ParamAction(False);
  end;
end;

//Desc: 屏蔽选择
procedure TfFrameParam.ListPackClickCheck(Sender: TObject);
var nStr: string;
begin
  with gParamManager do
  begin
    nStr := '';

    if Sender = ListPack then
    begin
      if Assigned(ActiveParam) then
        nStr := ActiveParam.FItemID;
      CheckItem(nStr, ListPack);
    end;

    if Sender = ListDB then
    begin
      if Assigned(ActiveParam) and Assigned(ActiveParam.FDB) then
        nStr := ActiveParam.FDB.FID;
      CheckItem(nStr, ListDB);
    end;

    if Sender = ListPerform then
    begin
      if Assigned(ActiveParam) and Assigned(ActiveParam.FPerform) then
        nStr := ActiveParam.FPerform.FID;
      CheckItem(nStr, ListPerform);
    end;
  end;
end;

//Date: 2012-2-24
//Parm: 标识;标题
//Desc: 设置标识为nFlag的文本为nText
procedure TfFrameParam.SetEditText(const nFlag, nText: string);
var nIdx: Integer;
    nCtrl: TWinControl;
begin
  if nFlag[1] = 'D' then nCtrl := GroupDB else
  if nFlag[1] = 'P' then nCtrl := GroupPerform else Exit;

  for nIdx:=nCtrl.ControlCount - 1 downto 0 do
  if nCtrl.Controls[nIdx].Hint = nFlag then
  begin
    if nCtrl.Controls[nIdx] is TEdit then
      TEdit(nCtrl.Controls[nIdx]).Text := nText else
    if nCtrl.Controls[nIdx] is TLabeledEdit then
      TLabeledEdit(nCtrl.Controls[nIdx]).Text := nText;
    Break;
  end;
end;

//Date: 2012-3-4
//Parm: 标识
//Desc: 获取nFlag的文本内容
function TfFrameParam.GetEditText(const nFlag: string): string;
var nIdx: Integer;
    nCtrl: TWinControl;
begin
  Result := '';
  if nFlag[1] = 'D' then nCtrl := GroupDB else
  if nFlag[1] = 'P' then nCtrl := GroupPerform else Exit;

  for nIdx:=nCtrl.ControlCount - 1 downto 0 do
  if nCtrl.Controls[nIdx].Hint = nFlag then
  begin
    if nCtrl.Controls[nIdx] is TEdit then
      Result := TEdit(nCtrl.Controls[nIdx]).Text  else
    if nCtrl.Controls[nIdx] is TLabeledEdit then
      Result := TLabeledEdit(nCtrl.Controls[nIdx]).Text;
    Break;
  end;
end;

//Date: 2012-3-4
//Parm: 标识;列表
//Desc: 在nList中选中标识为nID的项
procedure TfFrameParam.CheckItem(const nID: string; const nList: TCheckListBox);
var nIdx: Integer;
begin
  for nIdx:=nList.Count - 1 downto 0 do
   nList.Checked[nIdx] := CompareText(nID, nList.Items[nIdx]) = 0;
  //xxxxx
end;

//------------------------------------------------------------------------------
//Desc: 添加DB参数
procedure TfFrameParam.BtnAddDBClick(Sender: TObject);
var nP: PDBParam;
    nDB: TDBParam;
begin
  nDB.FID := '新建参数';
  nP := gParamManager.GetDB(nDB.FID);

  if not Assigned(nP) then
  with gParamManager do
  begin
    InitDB(nDB);
    AddDB(nDB);
    LoadParam(ListDB.Items, ptDB);

    if Assigned(ActiveParam) and Assigned(ActiveParam.FDB) then
      CheckItem(ActiveParam.FDB.FID, ListDB);
    //xxxxx
  end;
end;

//Desc: 删除DB参数
procedure TfFrameParam.BtnDelDBClick(Sender: TObject);
var nIdx: Integer;
begin
  nIdx := ListDB.ItemIndex;
  if nIdx < 0 then Exit;

  with gParamManager do
  begin
    DelDB(ListDB.Items[ListDB.ItemIndex]);
    LoadParam(ListDB.Items, ptDB);

    if Assigned(ActiveParam) and Assigned(ActiveParam.FDB) then
      CheckItem(ActiveParam.FDB.FID, ListDB);
    //xxxxx

    if nIdx >= ListDB.Count then Dec(nIdx);
    if nIdx > -1 then
    begin
      ListDB.ItemIndex := nIdx;
      ListDBClick(nil);
    end;
  end;
end;

//Desc: 显示DB参数
procedure TfFrameParam.ListDBClick(Sender: TObject);
var nP: PDBParam;
begin
  if ListDB.ItemIndex > -1 then
  begin
    nP := gParamManager.GetDB(ListDB.Items[ListDB.ItemIndex]);
    if not Assigned(nP) then Exit;

    with nP^ do
    begin
      SetEditText('D.1', FID);
      SetEditText('D.2', FHost);
      SetEditText('D.3', IntToStr(FPort));
      SetEditText('D.4', FDB);
      SetEditText('D.5', FUser);
      SetEditText('D.6', FPwd);
      SetEditText('D.7', IntToStr(FNumWorker));
      MemoConn.Text := FConn;
    end;
  end;
end;

//Desc: 数据生效
procedure TfFrameParam.EditDBChange(Sender: TObject);
var nP: PDBParam;
    nCtrl: TWinControl;
begin
  if ListDB.ItemIndex > -1 then
  begin
    nCtrl := TWinControl(Sender);
    if not nCtrl.Focused then Exit;

    nP := gParamManager.GetDB(ListDB.Items[ListDB.ItemIndex]);
    if not Assigned(nP) then Exit;

    with nP^ do
    begin
      FID     := GetEditText('D.1');
      FHost   := GetEditText('D.2');

      if (nCtrl.Hint = 'D.3') and IsNumber(TLabeledEdit(nCtrl).Text, False) then
        FPort   := StrToInt(GetEditText('D.3'));
      //xxxxx

      FDB     := GetEditText('D.4');
      FUser   := GetEditText('D.5');
      FPwd    := GetEditText('D.6');

      if (nCtrl.Hint = 'D.7') and IsNumber(TLabeledEdit(nCtrl).Text, False) then
        FNumWorker := StrToInt(GetEditText('D.7'));
      FConn   := MemoConn.Text;

      gParamManager.Modified := True;
      if nCtrl.Hint = 'D.1' then
        ListDB.Items[ListDB.ItemIndex] := FID;
      //xxxxx
    end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 添加Perform参数
procedure TfFrameParam.BtnAddPerformClick(Sender: TObject);
var nP: PPerformParam;
    nPerform: TPerformParam;
begin
  nPerform.FID := '新建参数';
  nP := gParamManager.GetPerform(nPerform.FID);

  if not Assigned(nP) then
  with gParamManager do
  begin
    InitPerform(nPerform);
    AddPerform(nPerform);
    LoadParam(ListPerform.Items, ptPerform);

    if Assigned(ActiveParam) and Assigned(ActiveParam.FPerform) then
      CheckItem(ActiveParam.FPerform.FID, ListPerform);
    //xxxxx
  end;
end;

//Desc: 删除Perform参数
procedure TfFrameParam.BtnDelPerformClick(Sender: TObject);
var nIdx: Integer;
begin
  nIdx := ListPerform.ItemIndex;
  if nIdx < 0 then Exit;

  with gParamManager do
  begin
    DelPerform(ListPerform.Items[ListPerform.ItemIndex]);
    LoadParam(ListPerform.Items, ptPerform);

    if Assigned(ActiveParam) and Assigned(ActiveParam.FPerform) then
      CheckItem(ActiveParam.FPerform.FID, ListPerform);
    //xxxxx

    if nIdx >= ListDB.Count then Dec(nIdx);
    if nIdx > -1 then
    begin
      ListPerform.ItemIndex := nIdx;
      ListPerformClick(nil);
    end;
  end;
end;

procedure TfFrameParam.ListPerformClick(Sender: TObject);
var nP: PPerformParam;
begin
  if ListPerform.ItemIndex > -1 then
  begin
    nP := gParamManager.GetPerform(ListPerform.Items[ListPerform.ItemIndex]);
    if not Assigned(nP) then Exit;

    with nP^ do
    begin
      SetEditText('P.1', FID);
      SetEditText('P.2', IntToStr(FMonInterval));
      SetEditText('P.3', IntToStr(FPortTCP));
      SetEditText('P.4', IntToStr(FPortHttp));
      SetEditText('P.5', IntToStr(FPoolSizeConn));
      SetEditText('P.6', IntToStr(FPoolSizeBusiness));
      SetEditText('P.7', IntToStr(FPoolSizeSAP));
      SetEditText('P.8', IntToStr(FMaxRecordCount));

      EditBehConn.ItemIndex := Ord(FPoolBehaviorConn);
      EditBehBus.ItemIndex := Ord(FPoolBehaviorBusiness);
    end;
  end;
end;

//Desc: 参数生效
procedure TfFrameParam.EditPerformChange(Sender: TObject);
var nP: PPerformParam;
    nCtrl: TWinControl;
begin
  if ListPerform.ItemIndex > -1 then
  begin
    nCtrl := TWinControl(Sender);
    if not nCtrl.Focused then Exit;

    nP := gParamManager.GetPerform(ListPerform.Items[ListPerform.ItemIndex]);
    if not Assigned(nP) then Exit;

    with nP^ do
    begin
      FID := GetEditText('P.1');
      if (nCtrl.Hint = 'P.2') and IsNumber(TLabeledEdit(nCtrl).Text, False) then
        FMonInterval := StrToInt(GetEditText('P.2'));
      //xxxxx

      if (nCtrl.Hint = 'P.3') and IsNumber(TLabeledEdit(nCtrl).Text, False) then
        FPortTCP := StrToInt(GetEditText('P.3'));
      if (nCtrl.Hint = 'P.4') and IsNumber(TLabeledEdit(nCtrl).Text, False) then
        FPortHttp := StrToInt(GetEditText('P.4'));
      if (nCtrl.Hint = 'P.5') and IsNumber(TLabeledEdit(nCtrl).Text, False) then
        FPoolSizeConn := StrToInt(GetEditText('P.5'));
      if (nCtrl.Hint = 'P.6') and IsNumber(TLabeledEdit(nCtrl).Text, False) then
        FPoolSizeBusiness := StrToInt(GetEditText('P.6'));
      if (nCtrl.Hint = 'P.7') and IsNumber(TLabeledEdit(nCtrl).Text, False) then
        FPoolSizeSAP := StrToInt(GetEditText('P.7'));
      if (nCtrl.Hint = 'P.8') and IsNumber(TLabeledEdit(nCtrl).Text, False) then
        FMaxRecordCount := StrToInt(GetEditText('P.8'));

      FPoolBehaviorConn := TROPoolBehavior(EditBehConn.ItemIndex);
      FPoolBehaviorBusiness := TROPoolBehavior(EditBehBus.ItemIndex);

      gParamManager.Modified := True;
      if nCtrl.Hint = 'P.1' then
        ListPerform.Items[ListPerform.ItemIndex] := FID;
      //xxxxx
    end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 添加Pack参数
procedure TfFrameParam.BtnAddPackClick(Sender: TObject);
var nP: PParamItemPack;
    nPack: TParamItemPack;
begin
  nPack.FItemID := '新建参数';
  nP := gParamManager.GetParamPack(nPack.FItemID);

  if not Assigned(nP) then
  with gParamManager do
  begin
    InitPack(nPack);
    AddPack(nPack);
    LoadParam(ListPack.Items, ptPack);

    if Assigned(ActiveParam) then
      CheckItem(ActiveParam.FItemID, ListPack);
    //xxxxx
  end;
end;

//Desc: 删除Pack参数
procedure TfFrameParam.BtnDelPackClick(Sender: TObject);
var nIdx: Integer;
begin
  nIdx := ListPack.ItemIndex;
  if nIdx < 0 then Exit;

  with gParamManager do
  begin
    DelPack(ListPack.Items[ListPack.ItemIndex]);
    LoadParam(ListPack.Items, ptPack);

    if Assigned(ActiveParam) then
      CheckItem(ActiveParam.FItemID, ListPack);
    //xxxxx

    if nIdx >= ListPack.Count then Dec(nIdx);
    if nIdx > -1 then
    begin
      ListPack.ItemIndex := nIdx;
      ListPackClick(nil);
    end;
  end;
end;

//Desc: 显示内容
procedure TfFrameParam.ListPackClick(Sender: TObject);
var nP: PParamItemPack;
begin
  if ListPack.ItemIndex > -1 then
  begin
    nP := gParamManager.GetParamPack(ListPack.Items[ListPack.ItemIndex]);
    if not Assigned(nP) then Exit;

    with nP^ do
    begin
      EditPack.Text := FItemID;
      NamesDB.ItemIndex := NamesDB.Items.IndexOf(FNameDB);
      NamesPerform.ItemIndex := NamesPerform.Items.IndexOf(FNamePerform);
    end;
  end;
end;

//Desc: 内容生效
procedure TfFrameParam.EditPackChange(Sender: TObject);
var nP: PParamItemPack;
    nCtrl: TWinControl;
begin
  if ListPack.ItemIndex > -1 then
  begin
    nCtrl := TWinControl(Sender);
    if not nCtrl.Focused then Exit;

    nP := gParamManager.GetParamPack(ListPack.Items[ListPack.ItemIndex]);
    if not Assigned(nP) then Exit;

    with nP^ do
    begin
      FItemID := EditPack.Text;
      FNameDB := NamesDB.Text;
      FDB := gParamManager.GetDB(FNameDB);

      FNamePerform := NamesPerform.Text;
      FPerform := gParamManager.GetPerform(FNamePerform);

      gParamManager.Modified := True;
      if nCtrl = EditPack then
        ListPack.Items[ListPack.ItemIndex] := FItemID;
      //xxxxx
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameParam, TfFrameParam.FrameID);
end.
