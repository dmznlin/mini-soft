{*******************************************************************************
  作者: dmzn@163.com 2013-3-9
  描述: 设置数据库
*******************************************************************************}
unit UFormSetDB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UMgrDBConn, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Menus, cxButtons, cxMemo,
  cxLabel, cxTextEdit, dxLayoutControl, StdCtrls;

type
  TfFormSetDB = class(TfFormNormal)
    EditIP: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditPort: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditDB: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item6: TdxLayoutItem;
    EditUser: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditPwd: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditConn: TcxMemo;
    dxLayout1Item9: TdxLayoutItem;
    BtnTest: TcxButton;
    dxLayout1Item10: TdxLayoutItem;
    procedure BtnTestClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    procedure InitFormData;
    procedure GetParam(var nParam: TDBParam);
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UMgrControl, UFormWait, UDataModule, USysConst;

class function TfFormSetDB.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;

  with TfFormSetDB.Create(Application) do
  begin
    InitFormData;
    ShowModal;
    Free;
  end;
end;

class function TfFormSetDB.FormID: integer;
begin
  Result := cFI_FormSetDB;
end;

procedure TfFormSetDB.InitFormData;
begin
  ActionDBConfig(True);
  with gDBPram do
  begin
    EditIP.Text := FHost;
    EditPort.Text := IntToStr(FPort);
    EditDB.Text := FDB;

    EditUser.Text := FUser;
    EditPwd.Text := FPwd;
    EditConn.Text := FConn;
  end;
end;

//Desc: 收集界面参数
procedure TfFormSetDB.GetParam(var nParam: TDBParam);
begin
  with nParam do
  begin
    FHost := EditIP.Text;
    FPort := StrToInt(EditPort.Text);
    FDB := EditDB.Text;

    FUser := EditUser.Text;
    FPwd := EditPwd.Text;
    FConn := EditConn.Text;
  end;
end;

function TfFormSetDB.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
begin
  Result := True;
  
  if Sender is TcxTextEdit then
  begin
    Result := Trim((Sender as TcxTextEdit).Text) <> '';
    nHint := '请填写内容';
    if not Result then Exit;
  end;

  if Sender = EditPort then
  begin
    Result := IsNumber(EditPort.Text, False);
    nHint := '端口为0-65535数值';
  end;
end;

//Desc: 测试
procedure TfFormSetDB.BtnTestClick(Sender: TObject);
var nParam: TDBParam;
begin
  if IsDataValid then
  try
    GetParam(nParam);
    BtnTest.Enabled := False;
    ShowWaitForm(Self, '连接数据库', True);
                     
    with FDM.Conn_Bak do
    try
      Close;
      ConnectionString := gDBConnManager.MakeDBConnection(nParam);
      Open;

      ShowMsg('测试成功', sHint);
      FDM.Conn_Bak.Close;
    except
      ShowMsg('无法连接数据库', sHint);
    end;  
  finally
    BtnTest.Enabled := True;
    CloseWaitForm;
  end;
end;

procedure TfFormSetDB.BtnOKClick(Sender: TObject);
begin
  if IsDataValid then
  begin
    GetParam(gDBPram);
    ActionDBConfig(False);
    FDM.ADOConn.Connected := False;

    ModalResult := mrOk;
    ShowMsg('配置重启后生效', sHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormSetDB, TfFormSetDB.FormID);
end.
