unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TfFormMain = class(TForm)
    BtnOK: TButton;
    wPanel: TPanel;
    wPage: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    EditDate: TDateTimePicker;
    EditFile: TEdit;
    TabSheet2: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    EditServer: TEdit;
    EditToken: TEdit;
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun;

var
  gPath: string;
  //全局路径
  gRemoteVerify: Boolean;
  //远程验证

resourcestring
  sSeed   = 'run_key';       //密钥种子名称
  sConfig = 'config.ini';    //配置文件

procedure TfFormMain.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  gPath := ExtractFilePath(Application.ExeName);
  BtnOK.Enabled := IsValidConfigFile(gPath + sConfig, sSeed);
  EditDate.Date := Now() + 365;

  nIni := TIniFile.Create(gPath + sConfig);
  try
    gRemoteVerify := nIni.ReadString('System', 'RemoteVerify', 'Y') <> 'N';
    TabSheet2.TabVisible := gRemoteVerify;
    //默认使用网络授权

    EditFile.Text := nIni.ReadString('System', 'KeyFile', 'Lock.ini');
    EditToken.Text := nIni.ReadString('System', 'AppToken', '');
    EditServer.Text := nIni.ReadString('System', 'ServerURL', '');
  finally
    nIni.Free;
  end;

  if gRemoteVerify then
       wPage.ActivePageIndex := 1
  else wPage.ActivePageIndex := 0;
end;

procedure TfFormMain.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  nStr := ExtractFilePath(Application.ExeName) + 'Lock.ini';
  AddExpireDate(nStr, Date2Str(EditDate.Date), True);
  ShowMessage('已保存: ' + nStr);
end;

end.
