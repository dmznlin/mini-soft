{*******************************************************************************
  作者: dmzn@163.com 2023-11-06
  描述: 主单元
*******************************************************************************}
unit UFormMain;

{$I Link.inc}
interface

uses
  Winapi.Windows, System.SysUtils, System.Variants, System.Classes, USysConst,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ComCtrls, System.ImageList, Vcl.ImgList, Vcl.Menus, Vcl.Samples.Spin;

type
  TfFormMain = class(TForm)
    SBar1: TStatusBar;
    Timer1: TTimer;
    HintPanel: TPanel;
    Image1: TImage;
    Image2: TImage;
    HintLabel: TLabel;
    wPage1: TPageControl;
    Sheet1: TTabSheet;
    Sheet2: TTabSheet;
    Panel1: TPanel;
    CheckSrv: TCheckBox;
    CheckShowLog: TCheckBox;
    MemoLog: TMemo;
    Tray1: TTrayIcon;
    PMenu1: TPopupMenu;
    MenuAbout: TMenuItem;
    N1: TMenuItem;
    MenuExit: TMenuItem;
    Timer2: TTimer;
    PMenu2: TPopupMenu;
    MenuCLog: TMenuItem;
    MenuItem2: TMenuItem;
    MenuMStaus: TMenuItem;
    SBoxBase: TScrollBox;
    PanelBase: TPanel;
    Group1: TGroupBox;
    CheckRun: TCheckBox;
    CheckMin: TCheckBox;
    EditPwd: TLabeledEdit;
    Group2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    EditURI: TLabeledEdit;
    EditCType: TLabeledEdit;
    EditAID: TLabeledEdit;
    EditAKey: TLabeledEdit;
    EditRateQT: TSpinEdit;
    Group3: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    EditURI2: TLabeledEdit;
    EditCType2: TLabeledEdit;
    EditRateSL: TSpinEdit;
    Sheet3: TTabSheet;
    ScrollBox1: TScrollBox;
    PanelDevice: TPanel;
    Images1: TImageList;
    TreeDevices: TTreeView;
    PanelDParam: TPanel;
    GroupBox1: TGroupBox;
    Splitter1: TSplitter;
    EditFind: TEdit;
    BtnFind: TButton;
    BtnLoad: TButton;
    EditID: TLabeledEdit;
    EditName: TLabeledEdit;
    EditSN: TLabeledEdit;
    EditPos: TLabeledEdit;
    BtnSave: TButton;
    BtnDel: TButton;
    CheckValid: TCheckBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckRunClick(Sender: TObject);
    procedure EditAKeyExit(Sender: TObject);
    procedure EditRateChange(Sender: TObject);
    procedure wPage1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure CheckShowLogClick(Sender: TObject);
    procedure CheckSrvClick(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure Tray1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure MenuCLogClick(Sender: TObject);
    procedure MenuMStausClick(Sender: TObject);
    procedure Sheet2Resize(Sender: TObject);
    procedure BtnFindClick(Sender: TObject);
    procedure BtnLoadClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure TreeDevicesChange(Sender: TObject; Node: TTreeNode);
    procedure TreeDevicesDblClick(Sender: TObject);
  private
    { Private declarations }
    FCanExit: Boolean;
    {*可退出*}
    procedure SystemConfig(const nLoad: Boolean);
    procedure ShowLog(const nStr: string);
    //显示日志
    procedure BuildDeviceTree(const nFilter: string);
    function FindDeviceNode(const nID: string): TTreeNode;
    function FindDeviceTypeNode(const nType: TDeviceType): TTreeNode;
    function FindSelectNodeType: TDeviceType;
    {*设备清单*}
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  System.IniFiles, System.Win.Registry, Winapi.ShellAPI, UFormInputbox,
  UFormMessagebox, ULibFun, UManagerGroup, UQingTian;

var
  gDataSyncer: TDataSync = nil;
  //同步线程

procedure WriteLog(const nEvent: string);
begin
  gMG.FLogManager.AddLog(TfFormMain, 'TempMonitor', nEvent);
end;

procedure ActionSync(const nStart: Boolean);
begin
  if nStart then
  begin
    if not Assigned(gDataSyncer) then
      gDataSyncer := TDataSync.Create;
    //xxxxx
  end else

  if Assigned(gDataSyncer) then
  begin
    gDataSyncer.StopMe;
    gDataSyncer := nil;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormMain.FormCreate(Sender: TObject);
begin
  gMG.FLogManager.SyncMainUI := True;
  gMG.FLogManager.SyncSimple := ShowLog;
  gMG.FLogManager.StartService();

  wPage1.ActivePage := Sheet1;
  PanelBase.BevelOuter := bvNone;
  PanelDevice.BevelOuter := bvNone;

  FCanExit := False;
  SystemConfig(True);
  TApplicationHelper.LoadFormConfig(Self);
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {$IFNDEF Debug}
  if not FCanExit then
  begin
    Visible := False;
    Action := caNone;
    Exit;
  end;
  {$ENDIF}

  ActionSync(False);
  SystemConfig(False);
  TApplicationHelper.SaveFormConfig(Self);
end;

procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  with TDateTimeHelper do
    SBar1.SimpleText := '※.' + DateTime2Str(Now()) + ' ' + Date2Week();
  //xxxxx
end;

procedure TfFormMain.Timer2Timer(Sender: TObject);
begin
  Timer2.Enabled := False;
  if gSystemParam.FAutoHide then
  begin
    CheckSrv.Checked := True;  //启动服务
    Visible := False;
  end;
end;

procedure TfFormMain.Tray1Click(Sender: TObject);
begin
  if not Visible then
    Visible := True;
  //xxxxx
end;

procedure TfFormMain.MenuAboutClick(Sender: TObject);
begin
  ShellAbout(Handle, PWideChar(Caption), PWideChar(HintLabel.Caption),
    Application.Icon.Handle);
  //xxxxx
end;

procedure TfFormMain.MenuCLogClick(Sender: TObject);
begin
  MemoLog.Clear;
end;

procedure TfFormMain.MenuExitClick(Sender: TObject);
begin
  FCanExit := True;
  Close;
end;

procedure TfFormMain.MenuMStausClick(Sender: TObject);
begin
  gMG.GetManagersStatus(MemoLog.Lines);
end;

//Date: 2018-01-11
//Parm: 读写
//Desc: 处理配置信息
procedure TfFormMain.SystemConfig(const nLoad: Boolean);
const
  sStartKey = 'TempMon';
var
  nStr: string;
  nIni: TIniFile;
  nReg: TRegistry;
begin
  nIni := nil;
  nReg := nil;

  with gSystemParam do
  try
    nIni := TIniFile.Create(TApplicationHelper.gSysConfig);
    //new obj

    if nLoad then
    with nIni do
    begin
      FillChar(gSystemParam, SizeOf(TParamConfig), #0);
      //init first

      FAutoHide := ReadBool('Config', 'MinAfterRun', False);
      FServerURI := ReadString('Config', 'ServerURI', EditURI.Text);
      FContentType := ReadString('Config', 'ContentType', EditCType.Text);
      FAppID := ReadString('Config', 'AppID', EditAID.Text);
      FAppKey := ReadString('Config', 'AppKey', EditAKey.Text);
      FFreshRateQT := ReadInteger('Config', 'FreshRateQT', 60);
      //qingtian

      FSamleeServer := ReadString('Config', 'ServerURI_SL', EditURI2.Text);
      FSamleeCType := ReadString('Config', 'ContentType_SL', EditCType2.Text);
      FFreshRateSL := ReadInteger('Config', 'FreshRateSL', 60);
      //samlee

      nStr := ReadString('Config', 'Password', '');
      if nStr <> '' then
        FAdminPwd := TEncodeHelper.DecodeBase64(nStr);
      //xxxxx

      nReg := TRegistry.Create;
      nReg.RootKey := HKEY_CURRENT_USER;

      nReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
      FAutoRun := nReg.ValueExists(sStartKey);

      CheckRun.Checked := FAutoRun;
      CheckMin.Checked := FAutoHide;
      EditRateQT.Value := FFreshRateQT;
      EditRateSL.Value := FFreshRateSL;
      EditPwd.Text     := FAdminPwd;
      EditURI.Text     := FServerURI;
      EditCType.Text   := FContentType;
      EditAID.Text     := FAppID;
      EditAKey.Text    := FAppKey;
      EditURI2.Text    := FSamleeServer;
      EditCType2.Text  := FSamleeCType;
    end else

    if gSystemParam.FChanged then
    begin
      nStr := TEncodeHelper.EncodeBase64(FAdminPwd);
      nIni.WriteString('Config', 'Password', nStr);
      nIni.WriteString('Config', 'ServerURI', FServerURI);
      nIni.WriteString('Config', 'ContentType', FContentType);
      nIni.WriteString('Config', 'AppID', FAppID);
      nIni.WriteString('Config', 'AppKey', FAppKey);
      nIni.WriteBool('Config', 'MinAfterRun', FAutoHide);
      nIni.WriteInteger('Config', 'FreshRateQT', FFreshRateQT);
      nIni.WriteInteger('Config', 'FreshRateSL', FFreshRateSL);

      nIni.WriteString('Config', 'ServerURI_SL', FSamleeServer);
      nIni.WriteString('Config', 'ContentType_SL', FSamleeCType);
      //samlee

      nReg := TRegistry.Create;
      nReg.RootKey := HKEY_CURRENT_USER;
      nReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);

      if gSystemParam.FAutoRun then
      begin
        nReg.WriteString(sStartKey, Application.ExeName);
      end else
      if nReg.ValueExists(sStartKey) then
        nReg.DeleteValue(sStartKey);
      //xxxxx
    end;

    gSystemParam.FChanged := False;
    //flag
  finally
    nIni.Free;
    nReg.Free;
  end;
end;

//Desc: 显示日志
procedure TfFormMain.ShowLog(const nStr: string);
var
  nIdx: Integer;
begin
  MemoLog.Lines.BeginUpdate;
  try
    MemoLog.Lines.Insert(0, nStr);
    if MemoLog.Lines.Count > 100 then
      for nIdx := MemoLog.Lines.Count - 1 downto 50 do
        MemoLog.Lines.Delete(nIdx);
  finally
    MemoLog.Lines.EndUpdate;
  end;
end;

//Desc: 参数居中
procedure TfFormMain.Sheet2Resize(Sender: TObject);
const nSpace = 3;
var nL: Integer;
begin
  nL := Trunc((PanelBase.Parent.Width - PanelBase.Width) / 2);
  if nL < nSpace then
    nL := nSpace;
  //central base panel

  PanelBase.Left := nL;
  PanelBase.Top := nSpace;

  nL := Trunc((PanelDevice.Parent.Width - PanelDevice.Width) / 2);
  if nL < nSpace then
    nL := nSpace;
  //central base panel

  PanelDevice.Left := nL;
  PanelDevice.Top := nSpace;
  PanelDevice.Height := PanelDevice.Parent.Height - 2 * nSpace;
end;

procedure TfFormMain.CheckShowLogClick(Sender: TObject);
begin
  gMG.FLogManager.SyncMainUI := CheckShowLog.Checked;
end;

procedure TfFormMain.CheckSrvClick(Sender: TObject);
begin
  ActionSync(CheckSrv.Checked);
end;

procedure TfFormMain.CheckRunClick(Sender: TObject);
begin
  gSystemParam.FAutoRun := CheckRun.Checked;
  gSystemParam.FAutoHide := CheckMin.Checked;
  gSystemParam.FChanged := True;
end;

procedure TfFormMain.EditAKeyExit(Sender: TObject);
var nStr: string;
begin
  nStr := Trim(TLabeledEdit(Sender).Text);
  if (Sender = EditPwd) and (nStr <> gSystemParam.FAdminPwd) then
  begin
    gSystemParam.FAdminPwd := nStr;
    gSystemParam.FChanged := True;
  end else

  if (Sender = EditURI) and (nStr <> gSystemParam.FServerURI) then
  begin
    if TStringHelper.CopyRight(nStr, 1) = '/' then
      nStr := TStringHelper.CopyNoRight(nStr, 1);
    //xxxxx

    gSystemParam.FServerURI := nStr;
    gSystemParam.FChanged := True;
  end else

  if (Sender = EditCType) and (nStr <> gSystemParam.FContentType) then
  begin
    gSystemParam.FContentType := nStr;
    gSystemParam.FChanged := True;
  end else

  if (Sender = EditAID) and (nStr <> gSystemParam.FAppID) then
  begin
    gSystemParam.FAppID := nStr;
    gSystemParam.FChanged := True;
  end else

  if (Sender = EditAKey) and (nStr <> gSystemParam.FAppKey) then
  begin
    gSystemParam.FAppKey := nStr;
    gSystemParam.FChanged := True;
  end else

  if (Sender = EditURI2) and (nStr <> gSystemParam.FSamleeServer) then
  begin
    gSystemParam.FSamleeServer := nStr;
    gSystemParam.FChanged := True;
  end else

  if (Sender = EditCType2) and (nStr <> gSystemParam.FSamleeCType) then
  begin
    gSystemParam.FSamleeCType := nStr;
    gSystemParam.FChanged := True;
  end;
end;

procedure TfFormMain.EditRateChange(Sender: TObject);
begin
  if (Sender = EditRateQT) and EditRateQT.Focused then
  begin
    gSystemParam.FFreshRateQT := EditRateQT.Value;
    gSystemParam.FChanged := True;
  end else

  if (Sender = EditRateSL) and EditRateSL.Focused then
  begin
    gSystemParam.FFreshRateSL := EditRateSL.Value;
    gSystemParam.FChanged := True;
  end;
end;

procedure TfFormMain.wPage1Changing(Sender: TObject; var AllowChange: Boolean);
var nStr: string;
begin
  if (wPage1.ActivePage = Sheet1) and (gSystemParam.FAdminPwd <> '') then
  begin
    ShowInputPWDBox('请输入密码:', '管理员', nStr);
    AllowChange := nStr = gSystemParam.FAdminPwd;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2023-11-26
//Desc: 从数据库读取设备清单
procedure LoadDeviceFromDB;
var nStr: string;
    nIdx: Integer;
    nDT: TDeviceType;
begin
  SetLength(gDevices, 0);
  nStr := 'Select r_id,s_type,s_id,s_name,s_sn,s_pos,s_valid From %s ' +
          'order by s_id asc';
  nStr := Format(nStr, [sTable_Sensor]);

  with gMG.FDBManager.DBQuery(nStr) do
  if RecordCount > 0 then
  begin
    SetLength(gDevices, RecordCount);
    nIdx := 0;
    First;

    while not Eof do
    begin
      nStr := FieldByName('s_type').AsString;
      if nStr = sDeviceType[dtSamlee] then
           nDT := dtSamlee
      else nDt := dtQingTian;

      with gDevices[nIdx] do
      begin
        FType        := nDT;
        FRecord      := FieldByName('r_id').AsString;
        FDevice      := FieldByName('s_id').AsString;
        FName        := FieldByName('s_name').AsString;
        FSn          := FieldByName('s_sn').AsString;
        FPos         := FieldByName('s_pos').AsString;
        FValid       := FieldByName('s_valid').AsString <> sFlag_No;

        if FName = '' then
          FName := FDevice; //default
        FDeleted := False;
      end;

      Inc(nIdx);
      Next;
    end;
  end;
end;

//Date: 2023-11-26
//Parm: 过滤id和pos
//Desc: 构建设备列表
procedure TfFormMain.BuildDeviceTree(const nFilter: string);
var nNode: TTreeNode;
    nDi: TDeviceType;
    nExpand: array[dtQingTian..dtSamlee]of Boolean;

  //Desc: 构建设备清单
  procedure BuildChild(const nType: TDeviceType);
  var nIdx: Integer;
  begin
    for nIdx := Low(gDevices) to High(gDevices) do
    with gDevices[nIdx] do
    begin
      if FDeleted or (FType <> nType) then Continue;
      //no match type

      if (nFilter <> '') and
         (Pos(nFilter, UpperCase(FDevice)) < 1) and
         (Pos(nFilter, UpperCase(FName)) < 1) and
         (Pos(nFilter, UpperCase(FPos)) < 1) then Continue;
      //no match id,pos

      with TreeDevices.Items.AddChild(nNode, FName) do
      begin
        if FValid then
             ImageIndex := 0
        else ImageIndex := 1;

        SelectedIndex := ImageIndex;
        Data := Pointer(nIdx);

        if CompareText(FName, EditID.Text) = 0 then
        begin
          MakeVisible;
          Selected := True;
        end;
      end;
    end;
  end;
begin
  TreeDevices.Items.BeginUpdate;
  try
    for nDi := dtQingTian to dtSamlee do
      nExpand[nDi] := False;
    //default

    nNode := TreeDevices.Items.GetFirstNode;
    while Assigned(nNode) do
    begin
      case nNode.ImageIndex of
        sImage_QingTian: nExpand[dtQingTian] := nNode.Expanded;
        sImage_Samlee:   nExpand[dtSamlee]   := nNode.Expanded;
      end;

      nNode := nNode.getNextSibling;
    end;

    TreeDevices.Items.Clear;
    //init

    nNode := TreeDevices.Items.AddChild(nil, '');
    with nNode do
    begin
      ImageIndex := sImage_QingTian;
      SelectedIndex := sImage_QingTian;
      Data := nil;
    end;

    BuildChild(dtQingTian);
    //sub nodes
    nNode.Text := Format('青天仪表(%d个)', [nNode.Count]);
    nNode.Expanded := nExpand[dtQingTian];

    nNode := TreeDevices.Items.AddChild(nil, '');
    with nNode do
    begin
      ImageIndex := sImage_Samlee;
      SelectedIndex := sImage_Samlee;
      Data := nil;
    end;

    BuildChild(dtSamlee);
    //sub nodes
    nNode.Text := Format('三丽温度(%d个)', [nNode.Count]);
    nNode.Expanded := nExpand[dtSamlee];
  finally
    TreeDevices.Items.EndUpdate;
  end;
end;

//Date: 2023-11-26
//Parm: 设备ID
//Desc: 检索nID对应的节点
function TfFormMain.FindDeviceNode(const nID: string): TTreeNode;
var nIdx: Integer;
    nNode: TTreeNode;
begin
  Result := nil;
  nNode := TreeDevices.Items.GetFirstNode;

  while Assigned(nNode) do
  begin
    if Assigned(nNode.Data) then
    begin
      nIdx := Integer(nNode.Data);
      if CompareText(gDevices[nIdx].FDevice, nID) = 0 then
      begin
        Result := nNode;
        Break;
      end;
    end;

    nNode := nNode.GetNext();
  end;
end;

//Date: 2023-11-26
//Parm: 设备类型
//Desc: 检索nType类型的节点
function TfFormMain.FindDeviceTypeNode(const nType: TDeviceType): TTreeNode;
var nNode: TTreeNode;
begin
  Result := nil;
  nNode := TreeDevices.Items.GetFirstNode;

  while Assigned(nNode) do
  begin
    case nType of
     dtQingTian:
       if nNode.ImageIndex = sImage_QingTian then
         Result := nNode;
       //xxxxx
     dtSamlee:
       if nNode.ImageIndex = sImage_Samlee then
         Result := nNode;
       //xxxxx
    end;

    if Assigned(Result) then
      Break;
    nNode := nNode.getNextSibling();
  end;
end;

//Date: 2023-11-26
//Desc: 选中节点的类型
function TfFormMain.FindSelectNodeType: TDeviceType;
var nNode: TTreeNode;
begin
  Result := dtSamlee;
  if not Assigned(TreeDevices.Selected) then Exit;
  //no valid node

  nNode := TreeDevices.Selected;
  while Assigned(nNode.Parent) do
    nNode := nNode.Parent;
  //find top node

  case nNode.ImageIndex of
   sImage_QingTian: Result := dtQingTian;
   sImage_Samlee:   Result := dtSamlee;
  end;
end;

//Desc: 查找
procedure TfFormMain.BtnFindClick(Sender: TObject);
begin
  BuildDeviceTree(UpperCase(EditFind.Text));
end;

//Desc: 刷新列表
procedure TfFormMain.BtnLoadClick(Sender: TObject);
begin
  LoadDeviceFromDB;
  BuildDeviceTree('');
end;

//Desc: 启用编辑
procedure TfFormMain.TreeDevicesChange(Sender: TObject; Node: TTreeNode);
begin
  BtnSave.Enabled := Assigned(Node);
  BtnDel.Enabled := Assigned(Node);
end;

//Desc: 显示信息
procedure TfFormMain.TreeDevicesDblClick(Sender: TObject);
var nIdx: Integer;
begin
  with TreeDevices do
  begin
    if Assigned(Selected) and Assigned(Selected.Data) then
         nIdx := Integer(Selected.Data)
    else Exit;

    with gDevices[nIdx] do
    begin
      EditID.Text := FDevice;
      EditName.Text := FName;
      EditSN.Text := FSn;
      EditPos.Text := FPos;
      CheckValid.Checked := FValid;
    end;
  end;
end;

//Desc: 保存
procedure TfFormMain.BtnSaveClick(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nNode: TTreeNode;
begin
  EditID.Text := Trim(EditID.Text);
  if EditID.Text = '' then
  begin
    ShowMsgBox('请输入设备ID', sFlag_Hint);
    Exit;
  end;

  nIdx := FindDevice(EditID.Text);
  if nIdx < 0 then
  begin
    nIdx := Length(gDevices);
    SetLength(gDevices, nIdx+1);
    //add one

    with gDevices[nIdx] do
    begin
      FRecord := '';
      FDevice := EditID.Text;
      FType := FindSelectNodeType();
    end;
  end;

  with gDevices[nIdx] do
  begin
    FName  := EditName.Text;
    FSn    := EditSN.Text;
    FPos   := EditPos.Text;
    FValid := CheckValid.Checked;

    if FName = '' then
      FName := FDevice;
    //default

    FDeleted := False;
    //del flag
  end;

  //----------------------------------------------------------------------------
  if gDevices[nIdx].FRecord = '' then
  begin
    with gDevices[nIdx],TSQLBuilder do
    nStr := MakeSQLByStr([SF('s_type', sDeviceType[FType]),
      SF('s_id', FDevice),
      SF('s_name', FName),
      SF('s_sn', FSn),
      SF('s_pos', FPos),
      SF('s_valid', SF_IF([sFlag_Yes, sFlag_No], FValid))], sTable_Sensor);
    //insert sql

    gMG.FDBManager.DBExecute(nStr);
    //do write

    nStr := 'select r_id,s_id from %s where s_id=''%s''';
    nStr := Format(nStr, [sTable_Sensor, gDevices[nIdx].FDevice]);
    //try get record

    with gMG.FDBManager.DBQuery(nStr) do
    if (RecordCount > 0) and
       (Fields[1].AsString = gDevices[nIdx].FDevice) then
    begin
      gDevices[nIdx].FRecord := Fields[0].AsString;
    end;
  end else
  begin
    with gDevices[nIdx],TSQLBuilder do
    nStr := MakeSQLByStr([
      SF('s_name', FName),
      SF('s_sn', FSn),
      SF('s_pos', FPos),
      SF('s_valid', SF_IF([sFlag_Yes, sFlag_No], FValid))
    ], sTable_Sensor, 'r_id=' + FRecord, False);
    //update sql

    gMG.FDBManager.DBExecute(nStr);
    //do write
  end;

  with gDevices[nIdx] do
  begin
    nNode := FindDeviceNode(FDevice);
    if not Assigned(nNode) then
    begin
      nNode := TreeDevices.Items.AddChild(FindDeviceTypeNode(FType), FName);
      nNode.Data := Pointer(nIdx);
    end;

    if FValid then
         nNode.ImageIndex := 0
    else nNode.ImageIndex := 1;

    nNode.SelectedIndex := nNode.ImageIndex;
    nNode.Text := FName;
  end;

  ShowMsgBox('保存成功', sFlag_Hint);
end;

procedure TfFormMain.BtnDelClick(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nNode: TTreeNode;
begin
  nIdx := FindDevice(EditID.Text);
  if nIdx < 0 then
  begin
    ShowMsgBox('未找到指定设备', sFlag_Hint);
    Exit;
  end;

  nStr := 'delete from %s where r_id=%s';
  nStr := Format(nStr, [sTable_Sensor, gDevices[nIdx].FRecord]);
  //delete sql
  gMG.FDBManager.DBExecute(nStr);


  nNode := FindDeviceNode(gDevices[nIdx].FDevice);
  if Assigned(nNode) then
    TreeDevices.Items.Delete(nNode);
  //xxxxx

  gDevices[nIdx].FDeleted := True;
  ShowMsgBox('删除成功', sFlag_Hint);
end;

end.

