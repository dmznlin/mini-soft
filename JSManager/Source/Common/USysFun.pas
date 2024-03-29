{*******************************************************************************
  作者: dmzn@163.com 2007-10-09
  描述: 项目通用函数定义单元
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
  //控件变动

procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
//在状态栏显示信息

procedure InitSystemEnvironment;
//初始化系统运行环境的变量
procedure LoadSysParameter(const nIni: TIniFile = nil);
//载入系统配置参数
function MakeFrameName(const nFrameID: integer): string;
//创建Frame名称

function ReplaceGlobalPath(const nStr: string): string;
//替换nStr中的全局路径

procedure LoadListViewColumn(const nWidths: string; const nLv: TListView);
//载入列表表头宽度
function MakeListViewColumnInfo(const nLv: TListView): string;
//组合列表表头宽度信息
procedure CombinListViewData(const nList: TStrings; nLv: TListView;
 const nAll: Boolean);
//组合选中的项的数据

function GetComPortNames(const nList: TStrings): Boolean;
//Rs232端口

function PrintJSReport(const nID: string; const nAsk: Boolean): Boolean;
//入口函数

implementation

//---------------------------------- 配置运行环境 ------------------------------
//Date: 2007-01-09
//Desc: 初始化运行环境
procedure InitSystemEnvironment;
begin
  Randomize;
  ShortDateFormat := 'YYYY-MM-DD';
  gPath := ExtractFilePath(Application.ExeName);
end;

//Date: 2007-09-13
//Desc: 载入系统配置参数
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
      //程序标识决定以下所有参数
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

//Desc: 依据FrameID生成组件名
function MakeFrameName(const nFrameID: integer): string;
begin
  Result := 'Frame' + IntToStr(nFrameID);
end;

//Desc: 替换nStr中的全局路径
function ReplaceGlobalPath(const nStr: string): string;
var nPath: string;
begin
  nPath := gPath;
  if Copy(nPath, Length(nPath), 1) = '\' then
    System.Delete(nPath, Length(nPath), 1);
  Result := StringReplace(nStr, '$Path', nPath, [rfReplaceAll, rfIgnoreCase]);
end;

//------------------------------------------------------------------------------
//Desc: 在全局状态栏最后一个Panel上显示nMsg消息
procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
begin
  if Assigned(gStatusBar) and (gStatusBar.Panels.Count > 0) then
  begin
    gStatusBar.Panels[gStatusBar.Panels.Count - 1].Text := nMsg;
    Application.ProcessMessages;
  end;
end;

//Desc: 在索引nIdx的Panel上显示nMsg消息
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
//Parm: 宽度信息;列表
//Desc: 载入nList的表头宽度
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
//Parm: 列表
//Desc: 组合nLv的表头宽度信息
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
//Parm: 列表;列表;是否全部组合
//Desc: 组合nLv中的信息,填充到nList中
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
//Parm: 结果列表
//Desc: 通过查注册表获取USB串口
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
//Parm: 列表
//Desc: 获取并口列表
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
      //补充USB转串口
    finally
      FreeMem(nBuffer);
    end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 打印表示为nID的提货记录
function PrintJSReport(const nID: string; const nAsk: Boolean): Boolean;
var nStr: string;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印提货记录?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s Left Join %s On L_Stock=S_ID Where L_ID=%s';
  nStr := Format(nStr, [sTable_JSLog, sTable_StockType, nID]);
  
  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s] 的提货记录已无效!!';
    nStr := Format(nStr, [nID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'Lading.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

end.


