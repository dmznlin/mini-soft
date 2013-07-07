{*******************************************************************************
  作者: dmzn@163.com 2012-2-24
  描述: 信息摘要
*******************************************************************************}
unit UFrameSummary;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, ImgList, ExtCtrls, ComCtrls, StdCtrls;

type
  TfFrameSummary = class(TfFrameBase)
    Group1: TGroupBox;
    CheckService: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    TimerMon: TTimer;
    TimerStart: TTimer;
    Group2: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Group3: TGroupBox;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    procedure TimerMonTimer(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
    procedure CheckServiceClick(Sender: TObject);
  private
    { Private declarations }
    FCounter: Integer;
    //计数
    FStopFlag: Boolean;
    //停止标记
    procedure WriteLog(const nLog: string);
    //记录日志
    procedure SetLable(const nFlag,nText: string);
    //设置标题
  public
    { Public declarations }
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UMgrDBConn, USysShareMem, USysLoger,
  UParamManager, UROModule, UMITConst, USmallFunc;

class function TfFrameSummary.FrameID: integer;
begin
  Result := cFI_FrameSummary;
end;

procedure TfFrameSummary.OnCreateFrame;
begin
  Name := MakeFrameName(FrameID);
  FStopFlag := False;
  CheckService.Caption := sStartServerHint;
end;

procedure TfFrameSummary.OnDestroyFrame;
begin
  
end;

//Desc: 记录日志
procedure TfFrameSummary.WriteLog(const nLog: string);
begin
  gSysLoger.AddLog(TfFrameSummary, '运行时摘要', nLog);
end;

//------------------------------------------------------------------------------
//Date: 2012-2-24
//Parm: 标识;标题
//Desc: 设置标识为nFlag的标题为nText
procedure TfFrameSummary.SetLable(const nFlag, nText: string);
var nIdx: Integer;
    nCtrl: TWinControl;
begin
  if nFlag[1] = 'A' then nCtrl := Group2 else
  if nFlag[1] = 'B' then nCtrl := Group3 else
  if nFlag[1] = 'C' then nCtrl := Group1 else Exit;

  for nIdx:=nCtrl.ControlCount - 1 downto 0 do
  if (nCtrl.Controls[nIdx] is TLabel) and
     (TLabel(nCtrl.Controls[nIdx]).Hint = nFlag) then
  begin
    TLabel(nCtrl.Controls[nIdx]).Caption := nText;
    Break;
  end;
end;

//Desc: 刷新服务状态
procedure TfFrameSummary.TimerMonTimer(Sender: TObject);
begin
  {$IFNDEF DEBUG}
  if not Application.Active then Exit;
  {$ENDIF}
  Inc(FCounter);

  with gDBConnManager.Status do
  begin
    SetLable('B.1', Format('%d 次', [FNumObjRequest]));
    SetLable('B.2', Format('%d 次', [FNumObjRequestErr]));
    SetLable('B.3', Format('%d 个', [FNumConnParam]));
    SetLable('B.4', Format('%d 个', [FNumConnItem]));
    SetLable('B.5', Format('%d 个', [FNumConnObj]));

    SetLable('B.6', Format('%d 个', [FNumObjConned]));
    SetLable('B.7', Format('%d 次', [FNumObjReUsed]));
    SetLable('B.8', Format('%d 个', [FNumObjWait]));
    SetLable('B.9', Format('%d 个', [FNumWaitMax]));
    SetLable('B.10', Format('%s', [DateTime2Str(FNumMaxTime)]));
  end;

  with ROModule.LockModuleStatus^ do
  try
    if FSrvTCP or FSrvHttp then
         SetLable('C.1', '已启动')
    else SetLable('C.1', '关闭');

    if gSysParam.FProgID = '' then
         SetLable('C.2', '无')
    else SetLable('C.2', gSysParam.FProgID);

    if FSrvTCP then
         SetLable('C.3', '已启动')
    else SetLable('C.3', '关闭');

    if FSrvHttp then
         SetLable('C.4', '已启动')
    else SetLable('C.4', '关闭');

    if Assigned(gParamManager.ActiveParam) and
       Assigned(gParamManager.ActiveParam.FPerform) then
    begin
      SetLable('C.5', IntToStr(gParamManager.ActiveParam.FPerform.FPortTCP));
      SetLable('C.9', IntToStr(gParamManager.ActiveParam.FPerform.FPortHttp));
    end else
    begin
      SetLable('C.5', '未知');
      SetLable('C.9', '未知');
    end;

    SetLable('C.6', Format('%d 次', [FNumTCPTotal]));
    SetLable('C.7', Format('%d 个', [FNumTCPActive]));
    SetLable('C.8', Format('%d 个', [FNumTCPMax]));

    SetLable('C.10', Format('%d 次', [FNumHttpTotal]));
    SetLable('C.11', Format('%d 个', [FNumHttpActive]));
    SetLable('C.12', Format('%d 个', [FNumHttpMax]));

    SetLable('C.13', Format('%d 次', [FNumConnection]));
    SetLable('C.14', Format('%d 次', [FNumBusiness]));
    SetLable('C.15', Format('%d 次', [FNumActionError]));
  finally
    ROModule.ReleaseStatusLock;
  end;

  if FCounter >= 5 then
  begin
    FCounter := 0;
    //LoadProcessList;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 延时启动
procedure TfFrameSummary.TimerStartTimer(Sender: TObject);
begin
  TimerStart.Enabled := False;
  {$IFDEF DEBUG}
  CheckService.Checked := True;
  {$ELSE}
  CheckService.Checked := gSysParam.FAutoMin;
  {$ENDIF}

  if gSysParam.FAutoMin and CheckService.Checked then
    SendMessage(ParentForm.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
  //xxxxx
end;

//Desc: 启动服务
procedure TfFrameSummary.CheckServiceClick(Sender: TObject);
var nStr: string;
begin
  if CheckService.Checked then
  begin
    if FStopFlag then Exit;

    with gParamManager do
    CheckService.Checked := Assigned(ActiveParam) and
                            Assigned(ActiveParam.FDB) and
                            Assigned(ActiveParam.FPerform);
    //xxxxx

    if not CheckService.Checked then
    begin
      WriteLog('无效的启动参数(ActiveParam),请检查参数配置.');
      Exit;
    end;

    CheckService.Checked := ROModule.ActiveServer([stHttp], True, nStr);
    //start
  end else
  begin
    if not ROModule.ActiveServer([stTcp, stHttp], False, nStr) then
    begin
      FStopFlag := True;
      CheckService.Checked := True;
      FStopFlag := False;

      ShowDlg(nStr, sWarn, ParentForm.Handle);
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameSummary, TfFrameSummary.FrameID);
end.
