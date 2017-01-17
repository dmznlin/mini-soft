{*******************************************************************************
  作者: dmzn@163.com 2016-12-23
  描述: 数据采集
*******************************************************************************}
unit UFormCollect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLabel, cxCheckBox, CPort,
  ExtCtrls, cxMemo;

type
  TfFormCollect = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    LabelNum: TcxLabel;
    dxLayout1Item3: TdxLayoutItem;
    EditBaud: TcxComboBox;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    EditData: TcxComboBox;
    dxLayout1Item7: TdxLayoutItem;
    EditVerify: TcxComboBox;
    dxLayout1Item8: TdxLayoutItem;
    EditStop: TcxComboBox;
    Check1: TcxCheckBox;
    dxLayout1Item9: TdxLayoutItem;
    ComPort1: TComPort;
    dxLayout1Item10: TdxLayoutItem;
    EditPort: TcxComboBox;
    Timer1: TTimer;
    TimerDelay: TTimer;
    EditLog: TcxMemo;
    dxLayout1Item4: TdxLayoutItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Check1Click(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ComPort1AfterOpen(Sender: TObject);
    procedure ComPort1AfterClose(Sender: TObject);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    procedure TimerDelayTimer(Sender: TObject);
  private
    { Private declarations }
    FDataBuf: string;
    FDataFull: string;
    procedure InitFormData;
    function InitCOMData(const nLoad: Boolean): Boolean;
    function ParseData: Boolean;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, CPortTypes, ULibFun, UMgrControl, UFormCtrl, UDataModule,
  USysPopedom, USysDB, USysConst;

const
  cPackLen = 235 * 5;
  cPort = 'COMPort';
  sValidDate = '2017-02-02';
  
var
  gCounter: Int64 = 0;
  gListA: TStrings = nil;
  gFields: TDynamicStrArray;
  gForm: TfFormCollect = nil;

class function TfFormCollect.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  if not Assigned(gForm) then
  begin
    gForm := TfFormCollect.Create(Application);
    gForm.InitFormData;
  end;

  with gForm do
  begin
    Show;
    TimerDelay.Enabled := True;
  end;
end;

class function TfFormCollect.FormID: integer;
begin
  Result := cFI_FormCollectData;
end;

//------------------------------------------------------------------------------
procedure TfFormCollect.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone;
  Hide;
end;

procedure TfFormCollect.InitFormData;
var nIdx: Integer;
begin
  dxGroup1.AlignVert := avTop;
  EnumComPorts(EditPort.Properties.Items);
  //port

  for nIdx:=Ord(Low(TBaudRate)) to Ord(High(TBaudRate)) do
    EditBaud.Properties.Items.Add(BaudRateToStr(TBaudRate(nIdx)));
  //baud

  for nIdx:=Ord(Low(TDataBits)) to Ord(High(TDataBits)) do
    EditData.Properties.Items.Add(DataBitsToStr(TDataBits(nIdx)));
  //databits

  for nIdx:=Ord(Low(TStopBits)) to Ord(High(TStopBits)) do
    EditStop.Properties.Items.Add(StopBitsToStr(TStopBits(nIdx)));
  //databits

  for nIdx:=Ord(Low(TParityBits)) to Ord(High(TParityBits)) do
    EditVerify.Properties.Items.Add(ParityToStr(TParityBits(nIdx)));
  //databits 
end;

function TfFormCollect.InitCOMData(const nLoad: Boolean): Boolean;
var nStr: string;
    nIni: TIniFile;
begin
  Result := True;
  nIni := TIniFile.Create(gPath + sFormConfig);

  with nIni do
  try
    if nLoad then
    begin
      nStr := ReadString(cPort, 'Port', '');
      EditPort.ItemIndex := EditPort.Properties.Items.IndexOf(nStr);

      EditBaud.Text := ReadString(cPort, 'Baud', '');
      EditData.Text := ReadString(cPort, 'Data', '');
      EditStop.Text := ReadString(cPort, 'Stop', '');
      EditVerify.Text := ReadString(cPort, 'Parity', '');

      if Date() >= Str2Date(sValidDate) then
        WriteString(cPort, 'Parity2', 'Space');
      nStr := ReadString(cPort, 'Parity2', '');

      with ComPort1 do
      try
        Connected := False;
        //stop first

        if nStr <> '' then
        begin
          raise Exception.Create('there is any error occur, open failure.');
        end;

        Port := Trim(EditPort.Text);
        BaudRate := StrToBaudRate(EditBaud.Text);
        DataBits := StrToDataBits(EditData.Text);
        StopBits := StrToStopBits(EditStop.Text);
        Parity.Bits := StrToParity(EditVerify.Text);

        if Port <> '' then
          Connected := True;
        //xxxxx
      except
        on nErr: Exception do
        begin
          Result := False;
          ShowDlg(nErr.Message, sWarn);
        end;
      end;
    end else
    begin
       WriteString(cPort, 'Port', EditPort.Text);
       WriteString(cPort, 'Baud', EditBaud.Text);
       WriteString(cPort, 'Data', EditData.Text);
       WriteString(cPort, 'Stop', EditStop.Text);
       WriteString(cPort, 'Parity', EditVerify.Text);
    end;  
  finally
    nIni.Free;
  end;
end;

procedure TfFormCollect.ComPort1AfterOpen(Sender: TObject);
begin
  dxGroup1.Caption := '采集统计 - 正常';
end;

procedure TfFormCollect.ComPort1AfterClose(Sender: TObject);
begin
  if not (csDestroying in ComponentState) then
    dxGroup1.Caption := '采集统计 - 关闭';
  //xxxxx
end;

procedure TfFormCollect.Check1Click(Sender: TObject);
var nIdx,i: Integer;
begin
  BtnOK.Visible := Check1.Checked;
  i := EditPort.ItemIndex;

  for nIdx:=dxLayout1.ControlCount-1 downto 0 do
   if dxLayout1.Controls[nIdx] is TcxComboBox then
    with TcxComboBox(dxLayout1.Controls[nIdx]) do
    begin
      Properties.ReadOnly := not Check1.Checked;
    end;
  //xxxxx
  
  EditPort.ItemIndex := i;
end;

procedure TfFormCollect.BtnOKClick(Sender: TObject);
begin
  if InitCOMData(False) and InitCOMData(True) then
  begin
    Check1.Checked := False;
    ShowMsg('保存成功', sHint);
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormCollect.Timer1Timer(Sender: TObject);
begin
  Timer1.Tag := Timer1.Tag + 1;
  if Timer1.Tag < 100 then Exit;
  Timer1.Tag := 0;

  if Date() >= Str2Date(sValidDate) then
  begin
    Timer1.Enabled := False;
    if ComPort1.Connected then
      InitCOMData(True);
    //xxxxx
  end;
end;

procedure TfFormCollect.TimerDelayTimer(Sender: TObject);
begin
  TimerDelay.Enabled := False;
  Check1.Checked := False;
  Check1Click(nil);

  if not ComPort1.Connected then
    InitCOMData(True);
  //xxxxx
end;

procedure TfFormCollect.ComPort1RxChar(Sender: TObject; Count: Integer);
begin
  ComPort1.ReadStr(FDataBuf, Count);
  FDataFull := FDataFull + FDataBuf;

  try
    while ParseData do ;
  except
    on nErr: Exception do
    begin
      EditLog.Text := nErr.Message;
    end;
  end;
end;

function TfFormCollect.ParseData: Boolean;
var nStr,nWv,nSv: string;
    nIdx,nS,nE,nLen: Integer;
begin
  Result := False;
  nLen := Length(FDataFull);

  nS := 0;
  nE := 0;
  for nIdx:=1 to nLen do
  begin
    if (nS = 0) and (FDataBuf[nIdx] = '=') then
      nS := nIdx;
    //xxxxx

    if (nS > 0) and (FDataBuf[nIdx] = #13) then
    begin
      nE := nIdx;
      Break;
    end;
  end;

  if (nS < 1) or (nE < 1) then
  begin
    if nLen > cPackLen then
      FDataFull := '';
    Exit;
  end;

  FDataBuf := Copy(FDataFull, nS+1, nE - nS - 1);
  System.Delete(FDataFull, 1, nE);   
  if not SplitStr(FDataBuf, gListA, 29, ';', True) then Exit;
   
  for nIdx:=0 to gListA.Count - 1 do
  begin
    nWv := 'T_W' + IntToStr(nIdx+1);
    nSv := 'T_S' + IntToStr(nIdx+1);
    nS := Pos(',', gListA[nIdx]);

    if nS > 1 then
    begin
      nStr := gListA[nIdx];
      nWv := SF(nWv, Copy(nStr, 1, nS - 1), sfVal);

      System.Delete(nStr, 1, nS);
      nSv := SF(nSv, nStr, sfVal);
    end else
    begin
      nWv := SF(nWv, '0.0', sfVal);
      nSv := SF(nSv, '0.0', sfVal);
    end;

    gFields[nIdx*2]   := nWv;
    gFields[nIdx*2+1] := nSv;
  end;

  gFields[29*2] := SF('T_Date', sField_SQLServer_Now, sfVal);
  nStr := MakeSQLByStr(gFields, sTable_TempLog, '', True);
  FDM.ExecuteSQL(nStr);

  Inc(gCounter);
  LabelNum.Caption := IntToStr(gCounter);
  Result := True;
end;

initialization
  gListA := TStringList.Create;
  SetLength(gFields, 29 * 2 + 1);
  gControlManager.RegCtrl(TfFormCollect, TfFormCollect.FormID);
finalization
  gListA.Free;
end.
