{*******************************************************************************
  ����: dmzn@163.com 2007-10-09
  ����: ��Ŀͨ�ú������嵥Ԫ
*******************************************************************************}
unit USysFun;

interface

uses
  Windows, Classes, ComCtrls, Controls, Messages, Forms, SysUtils, IniFiles,
  Registry, WinSpool, ULibFun, USysConst, UDataReport, UDataModule, USysDB;

const
  WM_FrameChange = WM_User + $0027;
  
type
  TControlChangeState = (fsNew, fsFree, fsActive);
  TControlChangeEvent = procedure (const nName: string; const nCtrl: TWinControl;
    const nState: TControlChangeState) of object;
  //�ؼ��䶯

procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
//��״̬����ʾ��Ϣ

procedure InitSystemEnvironment;
//��ʼ��ϵͳ���л����ı���
procedure LoadSysParameter(const nIni: TIniFile = nil);
//����ϵͳ���ò���
function MakeFrameName(const nFrameID: integer): string;
//����Frame����

function ReplaceGlobalPath(const nStr: string): string;
//�滻nStr�е�ȫ��·��

procedure LoadListViewColumn(const nWidths: string; const nLv: TListView);
//�����б��ͷ���
function MakeListViewColumnInfo(const nLv: TListView): string;
//����б��ͷ�����Ϣ
procedure CombinListViewData(const nList: TStrings; nLv: TListView;
 const nAll: Boolean);
//���ѡ�е��������

function GetComPortNames(const nList: TStrings): Boolean;
//Rs232�˿�

function PrintJSReport(const nID: string; const nAsk: Boolean): Boolean;
//��ں���

implementation

//---------------------------------- �������л��� ------------------------------
//Date: 2007-01-09
//Desc: ��ʼ�����л���
procedure InitSystemEnvironment;
begin
  Randomize;
  ShortDateFormat := 'YYYY-MM-DD';
  gPath := ExtractFilePath(Application.ExeName);
end;

//Date: 2007-09-13
//Desc: ����ϵͳ���ò���
procedure LoadSysParameter(const nIni: TIniFile = nil);
var nTmp: TIniFile;
begin
  if Assigned(nIni) then
       nTmp := nIni
  else nTmp := TIniFile.Create(gPath + sConfigFile);

  try
    with gSysParam, nTmp do
    begin
      FProgID := ReadString(sConfigSec, 'ProgID', sProgID);
      //�����ʶ�����������в���
      FAppTitle := ReadString(FProgID, 'AppTitle', sAppTitle);
      FMainTitle := ReadString(FProgID, 'MainTitle', sMainCaption);
      FHintText := ReadString(FProgID, 'HintText', '');
      FCopyRight := ReadString(FProgID, 'CopyRight', '');
      FRecMenuMax := ReadInteger(FProgID, 'MaxRecent', cRecMenuMax);

      FIconFile := ReadString(FProgID, 'IconFile', gPath + 'Icons\Icon.ini');
      FIconFile := StringReplace(FIconFile, '$Path\', gPath, [rfIgnoreCase]);
    end;
  finally
    if not Assigned(nIni) then nTmp.Free;
  end;
end;

//Desc: ����FrameID���������
function MakeFrameName(const nFrameID: integer): string;
begin
  Result := 'Frame' + IntToStr(nFrameID);
end;

//Desc: �滻nStr�е�ȫ��·��
function ReplaceGlobalPath(const nStr: string): string;
var nPath: string;
begin
  nPath := gPath;
  if Copy(nPath, Length(nPath), 1) = '\' then
    System.Delete(nPath, Length(nPath), 1);
  Result := StringReplace(nStr, '$Path', nPath, [rfReplaceAll, rfIgnoreCase]);
end;

//------------------------------------------------------------------------------
//Desc: ��ȫ��״̬�����һ��Panel����ʾnMsg��Ϣ
procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
begin
  if Assigned(gStatusBar) and (gStatusBar.Panels.Count > 0) then
  begin
    gStatusBar.Panels[gStatusBar.Panels.Count - 1].Text := nMsg;
    Application.ProcessMessages;
  end;
end;

//Desc: ������nIdx��Panel����ʾnMsg��Ϣ
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
begin
  if Assigned(gStatusBar) and (gStatusBar.Panels.Count > nIdx) and
     (nIdx > -1) then
  begin
    gStatusBar.Panels[nIdx].Text := nMsg;
    gStatusBar.Panels[nIdx].Width := gStatusBar.Canvas.TextWidth(nMsg) + 20;
    Application.ProcessMessages;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2007-11-30
//Parm: �����Ϣ;�б�
//Desc: ����nList�ı�ͷ���
procedure LoadListViewColumn(const nWidths: string; const nLv: TListView);
var nList: TStrings;
    i,nCount: integer;
begin
  if nLv.Columns.Count > 0 then
  begin
    nList := TStringList.Create;
    try
      if SplitStr(nWidths, nList, nLv.Columns.Count, ';') then
      begin
        nCount := nList.Count - 1;
        for i:=0 to nCount do
         if IsNumber(nList[i], False) then
          nLv.Columns[i].Width := StrToInt(nList[i]);
      end;
    finally
      nList.Free;
    end;
  end;
end;

//Date: 2007-11-30
//Parm: �б�
//Desc: ���nLv�ı�ͷ�����Ϣ
function MakeListViewColumnInfo(const nLv: TListView): string;
var i,nCount: integer;
begin
  Result := '';
  nCount := nLv.Columns.Count - 1;

  for i:=0 to nCount do
  if i = nCount then
       Result := Result + IntToStr(nLv.Columns[i].Width)
  else Result := Result + IntToStr(nLv.Columns[i].Width) + ';';
end;

//Date: 2007-11-30
//Parm: �б�;�б�;�Ƿ�ȫ�����
//Desc: ���nLv�е���Ϣ,��䵽nList��
procedure CombinListViewData(const nList: TStrings; nLv: TListView;
 const nAll: Boolean);
var i,nCount: integer;
begin
  nList.Clear;
  nCount := nLv.Items.Count - 1;

  for i:=0 to nCount do
  if nAll or nLv.Items[i].Selected then
  begin
    nList.Add(nLv.Items[i].Caption + sLogField +
      CombinStr(nLv.Items[i].SubItems, sLogField));
    //combine items's data
  end;
end;

//------------------------------------------------------------------------------
//Date: 2009-12-06
//Parm: ����б�
//Desc: ͨ����ע����ȡUSB����
function EnumUSBPort(const nList: TStrings): Boolean;
var nStr: string;
    nReg: TRegistry;
    nTmp: TStrings;
    i,nCount: integer;
begin
  Result := False;
  nTmp := nil;
  nReg := TRegistry.Create;
  try
    nReg.RootKey := HKEY_LOCAL_MACHINE;
    if nReg.OpenKeyReadOnly('HARDWARE\DEVICEMAP\SERIALCOMM\') then
    begin
      nTmp := TStringList.Create;
      nReg.GetValueNames(nTmp);
      nCount := nTmp.Count - 1;

      for i:=0 to nCount do
      begin
        nStr := nReg.ReadString(nTmp[i]);
        if Pos('COM', nStr) = 1 then
        begin
          nStr := 'COM' + IntToStr(SplitIntValue(nStr));
          if nList.IndexOf(nStr) < 0 then nList.Add(nStr);
        end;
      end;

      nReg.CloseKey;
      Result := True;
    end;
  finally
    nTmp.Free;
    nReg.Free;
  end;
end;

//Date: 2009-7-9
//Parm: �б�
//Desc: ��ȡ�����б�
function GetComPortNames(const nList: TStrings): Boolean;
var nStr: string;
    nBuffer: Pointer;
    nInfoPtr: PPortInfo1;
    nIdx,nBytesNeeded,nReturned: DWORD;
begin
  nList.Clear;
  Result := EnumPorts(nil, 1, nil, 0, nBytesNeeded, nReturned);

  if (not Result) and (GetLastError = ERROR_INSUFFICIENT_BUFFER) then
  begin
    GetMem(nBuffer, nBytesNeeded);
    try
      Result := EnumPorts(nil, 1, nBuffer, nBytesNeeded, nBytesNeeded, nReturned);
      for nIdx := 0 to nReturned - 1 do
      begin
        nInfoPtr := PPortInfo1(DWORD(nBuffer) + nIdx * SizeOf(TPortInfo1));
        nStr := nInfoPtr^.pName;

        if Pos('COM', nStr) = 1 then
        begin
          nStr := 'COM' + IntToStr(SplitIntValue(nStr));
          if nList.IndexOf(nStr) < 0 then nList.Add(nStr);
        end;
      end;

      EnumUSBPort(nList);
      //����USBת����
    finally
      FreeMem(nBuffer);
    end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��ӡ��ʾΪnID�������¼
function PrintJSReport(const nID: string; const nAsk: Boolean): Boolean;
var nStr: string;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ�����¼?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s Left Join %s On L_Stock=S_ID Where L_ID=%s';
  nStr := Format(nStr, [sTable_JSLog, sTable_StockType, nID]);
  
  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s] �������¼����Ч!!';
    nStr := Format(nStr, [nID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'Lading.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

end.


