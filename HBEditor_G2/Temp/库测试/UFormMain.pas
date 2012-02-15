unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfFormMain = class(TForm)
    GroupBox1: TGroupBox;
    Edit1: TLabeledEdit;
    Edit2: TLabeledEdit;
    BtnConn: TButton;
    BtnClose: TButton;
    GroupBox2: TGroupBox;
    EditType: TLabeledEdit;
    EditNum: TLabeledEdit;
    EditArea: TLabeledEdit;
    EditFont: TLabeledEdit;
    EditMode: TLabeledEdit;
    EditText: TLabeledEdit;
    BtnSend: TButton;
    procedure BtnConnClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnSendClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses ULibInterface, ULibFun, ULibConst;

procedure TfFormMain.BtnConnClick(Sender: TObject);
begin
  CommPortInit(PChar(Edit1.Text), StrToInt(Edit2.Text));
  if CommPortConn then
       ShowMsg('done', 'OK')
  else ShowMsg('error', 'hint');
end;

procedure TfFormMain.BtnCloseClick(Sender: TObject);
begin
  if CommPortClose then
       ShowMsg('done', '')
  else ShowMsg('error', '');
end;

procedure TfFormMain.BtnSendClick(Sender: TObject);
var nStr: string;
    nOpen: Boolean;
    nList: TStrings;
    nArea: TAreaRect;
    nMode: TAreaMode;
    nFont: TAreaFont;
begin
  nOpen := False;
  nList := TStringList.Create;
  try
    TransInit(StrToInt(EditType.Text), StrToInt(EditNum.Text), 0);
    //初始化传输参数.反转参数为1时,表示反色

    SetLength(nStr, 255);
    nOpen := TransBegin(PChar(nStr));

    if not nOpen then
    begin
     ShowMsg(nStr, ''); Exit;
    end; //开启传输失败

    if not SplitStr(EditArea.Text, nList, 4, ',') then
    begin
      ShowMsg('无效的区域信息', ''); Exit;
    end; //拆分区域信息

    nArea.FLeft := StrToInt(nList[0]);
    nArea.FTop := StrToInt(nList[1]);
    nArea.FWidth := StrToInt(nList[2]);
    nArea.FHeight := StrToInt(nList[3]);

    if not SplitStr(EditFont.Text, nList, 2, ',') then
    begin
      ShowMsg('无效的字体信息', ''); Exit;
    end; //拆分字体信息

    StrPCopy(@nFont.FName[0], nList[0]);
    nFont.FSize := StrToInt(nList[1]);

    if not SplitStr(EditMode.Text, nList, 7, ',') then
    begin
      ShowMsg('无效的模式信息', ''); Exit;
    end; //特效模式

    with nMode do
    begin
      FEnterMode := StrToInt(nList[0]);
      FEnterSpeed := StrToInt(nList[1]);
      FKeepTime := StrToInt(nList[2]);
      FExitMode := StrToInt(nList[3]);
      FExitSpeed := StrToInt(nList[4]);
      FModeSerial := StrToInt(nList[5]);
      FSingleColor := StrToInt(nList[6]);
    end;

    SetLength(nStr, 255);
    TransData(@nArea, @nMode, @nFont, PChar(EditText.Text), PChar(nStr));
    ShowMsg(nStr, ''); //发送数据
  finally
    nList.Free;
    if nOpen then   //一旦开启必须关闭
    begin
      SetLength(nStr, 255);
      if not TransEnd(PChar(nStr)) then ShowMsg(nStr, '');
    end;
  end;
end;

end.
