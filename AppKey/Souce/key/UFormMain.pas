unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP;

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
    Http1: TIdHTTP;
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
  DateUtils, IniFiles, ULibFun, ZnMD5, superobject;

var
  gPath: string;
  //全局路径
  gRemoteVerify: Boolean;
  //远程验证

resourcestring
  sSeed   = 'run_key';       //密钥种子名称
  sConfig = 'config.ini';    //配置文件

function StreamToString(mStream : TStream) : AnsiString;
var
  I : Integer;
begin
  Result := '';
  if not Assigned(mStream) then Exit;
    SetLength(Result , mStream.Size);
  for I := 0 to Pred(mStream.Size) do
  try
    mStream.Position := I;
    mStream.Read(Result[Succ(I)] , 1);
  except
    Result := '';
  end;
end;

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
    nObj: ISuperObject;
    nSS: TStringStream;
begin
  if not FileExists(gPath + EditFile.Text) then
  begin
    nStr := Format('请复制秘钥文件 %s 到当前目录', [EditFile.Text]);
    ShowMessage(nStr);
    Exit;
  end;

  if not gRemoteVerify then //本地授权
  begin
    AddExpireDate(gPath + EditFile.Text, Date2Str(EditDate.Date), True);
    ShowMessage('已保存: ' + gPath + EditFile.Text);
    Exit;
  end;

  if not IsSystemExpire(gPath + EditFile.Text) then
  begin
    nStr := Format('秘钥文件 %s 已正确授权,是否继续?', [EditFile.Text]);
    if not QueryDlg(nStr, '询问', Handle) then Exit;
  end;

  nObj := nil;
  BtnOK.Enabled := False;
  nSS := TStringStream.Create('');
  try
    nStr := '/CheckToken?token=' + EditToken.Text;
    Http1.Get(EditServer.Text + nStr, nSS);

    nObj := SO(UTF8ToAnsi(nSS.DataString));
    if nObj.I['res'] <> 0 then //result代码
    begin
      ShowMessage(nObj.S['msg']);
      Exit;
    end;

    nStr := nObj.S['now'];
    if SecondsBetween(Now(), StrToDateTime(nStr)) > 60 then
    begin
      nStr := '本地时钟与服务器相差过大:' + StringOfChar(' ', 32) + #13#10#13#10 +
              '※.本地: ' + DateTime2Str(Now) + #13#10 +
              '※.远程: ' + nStr;
      ShowMessage(nStr);
      Exit;
    end;

    nStr := nObj.S['log'];
    if nStr <> '' then
      nStr := StringReplace(nStr, '|', #13#10, [rfReplaceAll]);
    //整理日志

    nStr := '应用: ' + nObj.S['app'] + #13#10 +
            '可用: ' + nObj.S['has'] + #13#10 +
            '日志: ' + #13#10 + nStr + #13#10#13#10 +
            '继续授权点"是",取消授权点"否"' + StringOfChar(' ', 32);
    if not QueryDlg(nStr, '询问', Handle) then Exit;

    //--------------------------------------------------------------------------
    nStr := DateTime2Str(IncSecond(Now, -60));
    nStr := Copy(nStr, 1, Length(nStr) - 2) + '30';
    //1分钟内第30秒

    nStr := EditToken.Text + '_' + nStr;
    //流水原始数据
    nStr := MD5Print(MD5String(nStr));

    nStr := Format('/UseToken?token=%s&id=%s', [EditToken.Text, nStr]);
    nSS.Size := 0;
    Http1.Get(EditServer.Text + nStr, nSS);

    nObj := nil;
    nObj := SO(UTF8ToAnsi(nSS.DataString));
    if nObj.I['res'] <> 0 then //result代码
    begin
      ShowMessage(nObj.S['msg']);
      Exit;
    end;

    AddExpireDate(gPath + EditFile.Text, Date2Str(EditDate.Date), True);
    ShowMessage('已保存: ' + gPath + EditFile.Text);
  finally
    BtnOK.Enabled := True;
    nSS.Free;
    nObj := nil;
  end;
end;

end.
