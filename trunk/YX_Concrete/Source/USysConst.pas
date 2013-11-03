{*******************************************************************************
  作者: dmzn@163.com 2013-10-25
  描述: 常量定义
*******************************************************************************}
unit USysConst;

interface

uses
  Windows, DB, Messages, SysUtils, Variants, Classes, ULibFun, ComObj,
  UMgrDBConn, IniFiles;

var
  gPath: string;                                     //程序所在路径
  gLastBackup: Int64 = 0;                            //上次备份
  gLastRestore: Int64 = 0;                           //上次恢复

function IsSystemNormal(const nIni: TIniFile = nil): Boolean;
//状态判定
procedure BackupSystemData;
procedure RestoreSystemData;
//备份恢复
procedure ConfigDBConnection;
//配置链路
procedure AddBackupField(const nID,nTable: string; nReset: Boolean);
procedure ParepareDBWork(const nFullBackup: Boolean);
//准备工作
procedure BackupData(const nID,nTable: string);
//备份数据
procedure CombinePeibiData;
procedure CombineProductData;
//合并数据
procedure RenameTable(const nID: string; const nTables: array of TMacroItem);
//表重命名

resourcestring
  sHint               = '提示';                      //对话框标题
  sWarn               = '警告';                      //==
  sAsk                = '询问';                      //询问对话框
  sError              = '未知错误';                  //错误对话框
  
  sLogDir             = 'Logs\';                     //日志目录
  sLogExt             = '.log';                      //日志扩展名
  sLogField           = #9;                          //记录分隔符

  sConfigFile         = 'Config.Ini';                //主配置文件
  sConfigSec          = 'Config';                    //主配置小节
  sVerifyCode         = ';Verify:';                  //校验码标记

  sFormConfig         = 'FormInfo.ini';              //窗体配置
  sSetupSec           = 'Setup';                     //配置小节
  sDBConfig           = 'DBConn.ini';                //数据连接

  sSCData             = 'SCData';                    //生产数据
  sSCCtrl             = 'SCCtrl';                    //生产控制

  sTable_Product      = 'product';                   //生产表
  sTable_Peibi        = 'peibi';                     //配比表

implementation

uses
  UFormProgress, UFormMain, UFormCtrl, USysLoger;

type
  PPBData = ^TPBData;
  TPBData = record
    FItem: string;         //配比项
    FGuobiao: Double;      //配比国标
    FWuCha: Integer;       //配比浮动值
    FPercent: Integer;     //浮动放大比例
  end;

  PPBItem = ^TPBItem;
  TPBItem = record
    FRecord: string;       //配比记录号
    FPeiBi: string;        //配比编号
    FData: TList;          //数据列表
  end;

var
  gPBItems: TList = nil;
  //配比列表

//Desc: 释放配比项
procedure DisposePBItem(const nItem: PPBItem);
var nIdx: Integer;
begin
  if Assigned(nItem.FData) then
  begin
    for nIdx:=nItem.FData.Count - 1 downto 0 do
    begin
      Dispose(PPBData(nItem.FData[nIdx]));
      nItem.FData.Delete(nIdx);
    end;

    FreeAndNil(nItem.FData);
  end;

  Dispose(nItem);
end;

//Desc: 清理数据
procedure ClearPBList(var nItems: TList; const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx:=nItems.Count - 1 downto 0 do
  begin
    DisposePBItem(nItems[nIdx]);
    nItems.Delete(nIdx);
  end;

  if nFree then
    FreeAndNil(nItems);
  //xxxxx
end;

//Desc: 在nItems中检索配比为nPB的项
function GetPBItem(const nItems: TList; nPB: string; nRrd: Boolean): PPBItem;
var nIdx: Integer;
    nItem: PPBItem;
begin
  Result := nil;
  if not Assigned(nItems) then Exit;

  for nIdx:=nItems.Count - 1 downto 0 do
  begin
    nItem := nItems[nIdx];

    if nRrd then
    begin
      if nItem.FRecord = nPB then Result := nItem;
    end else
    begin
      if nItem.FPeiBi = nPB then Result := nItem;
    end;

    if Assigned(Result) then Break;
    //get result
  end;
end;

//Desc: 在nDataList中检索配比nItem项
function GetPBData(const nDataList: TList; nItem: string): PPBData; overload;
var nIdx: Integer;
begin
  Result := nil;
  if not Assigned(nDataList) then Exit;

  for nIdx:=nDataList.Count - 1 downto 0 do
  if PPBData(nDataList[nIdx]).FItem = nItem then
  begin
    Result := nDataList[nIdx];
    Break;
  end;
end;

//------------------------------------------------------------------------------
procedure WriteLog(const nMsg: string);
begin
  gSysLoger.AddLog(TfFormMain, '主单元', nMsg);
end;

//Desc: 判定是否已启用备份
function IsSystemNormal(const nIni: TIniFile = nil): Boolean;
var nTmp: TIniFile;
begin
  if Assigned(nIni) then
       nTmp := nIni
  else nTmp := TIniFile.Create(gPath + sConfigFile);

  try
    Result := (nTmp.ReadInteger('System', 'SCData', 1) = 0) and
              (nTmp.ReadInteger('System', 'SCCtrl', 1) = 0);
    //xxxxx
  finally
    if not Assigned(nIni) then
      nTmp.Free;
  end;
end;

//Desc: 备份数据
procedure BackupSystemData;
var nInit: Int64;
    nInt: Integer;
    nIni: TIniFile;
    nList: TStrings;
    nWorker: PDBWorker;
    nTables: TDynamicMacroArray;
begin
  if GetTickCount - gLastBackup < 2 * 1000 then
  begin
    ShowMsg('备份完毕', sHint);
    Exit;
  end;

  nIni := nil;
  nWorker := nil;
  nList := nil;
  try
    nInit := GetTickCount;
    ShowProgressForm('备份控制数据');
    try
      nList := TStringList.Create;
      nIni := TIniFile.Create(gPath + sConfigFile);
      nWorker := gDBConnManager.GetConnection(sSCCtrl, nInt);

      if Assigned(nWorker) then
      begin
        if not nWorker.FConn.Connected then
          nWorker.FConn.Connected := True;
        nWorker.FConn.GetTableNames(nList);

        if nList.IndexOf(sTable_Peibi + '_t') >= 0 then
        begin
          if nList.IndexOf(sTable_Peibi) < 0 then
          begin
            SetLength(nTables, 1);
            nTables[0].FMacro := sTable_Peibi + '_t';
            nTables[0].FValue := sTable_Peibi;
          end else
          begin
            SetLength(nTables, 2);
            nTables[0].FMacro := sTable_Peibi;
            nTables[0].FValue := sTable_Peibi + '_b';
            nTables[1].FMacro := sTable_Peibi + '_t';
            nTables[1].FValue := sTable_Peibi;
          end;

          RenameTable(sSCCtrl, nTables);
        end;

        BackupData(sSCCtrl, sTable_Peibi);
        CombinePeibiData;

        nIni.WriteInteger('System', 'SCCtrl', 1);
        SetLength(nTables, 2);

        nTables[0].FMacro := sTable_Peibi;
        nTables[0].FValue := sTable_Peibi + '_t';
        nTables[1].FMacro := sTable_Peibi + '_b';
        nTables[1].FValue := sTable_Peibi;
        RenameTable(sSCCtrl, nTables);
      end;

      gDBConnManager.ReleaseConnection(nWorker);
      nWorker := nil;

      ShowProgressForm('备份生产数据');
      nWorker := gDBConnManager.GetConnection(sSCData, nInt);

      if Assigned(nWorker) then
      begin
        if not nWorker.FConn.Connected then
          nWorker.FConn.Connected := True;
        nWorker.FConn.GetTableNames(nList);

        if nList.IndexOf(sTable_Product + '_t') >= 0 then
        begin
          if nList.IndexOf(sTable_Product) < 0 then
          begin
            SetLength(nTables, 1);
            nTables[0].FMacro := sTable_Product + '_t';
            nTables[0].FValue := sTable_Product;
          end else
          begin
            SetLength(nTables, 2);
            nTables[0].FMacro := sTable_Product;
            nTables[0].FValue := sTable_Product + '_b';
            nTables[1].FMacro := sTable_Product + '_t';
            nTables[1].FValue := sTable_Product;
          end;

          RenameTable(sSCData, nTables);
        end;

        BackupData(sSCData, sTable_Product);
        CombineProductData;

        nIni.WriteInteger('System', 'SCData', 1);
        SetLength(nTables, 2);

        nTables[0].FMacro := sTable_Product;
        nTables[0].FValue := sTable_Product + '_t';
        nTables[1].FMacro := sTable_Product + '_b';
        nTables[1].FValue := sTable_Product;
        RenameTable(sSCData, nTables);
      end; 

      nInit := GetTickCount - nInit;
      if nInit < 500 then
        Sleep(500 - nInit);
      //xxxxx

      gLastBackup := GetTickCount;
      ShowMsg('备份成功', sHint);
    finally
      nList.Free;
      nIni.Free;
      
      CloseProgressForm;
      gDBConnManager.ReleaseConnection(nWorker);
    end;
  except
    on E:Exception do
    begin
      WriteLog(E.Message);
    end;
  end;
end;

//Desc: 恢复数据
procedure RestoreSystemData;
var nInit: Int64;
    nInt: Integer;
    nIni: TIniFile;
    nList: TStrings;
    nWorker: PDBWorker;
    nTables: TDynamicMacroArray;
begin
  if GetTickCount - gLastRestore < 2 * 1000 then
  begin
    ShowMsg('恢复完毕', sHint);
    Exit;
  end;

  nIni := nil;
  nWorker := nil;
  nList := nil;
  try
    nInit := GetTickCount;
    ShowProgressForm('恢复控制数据');
    try
      nList := TStringList.Create;
      nIni := TIniFile.Create(gPath + sConfigFile);
      nWorker := gDBConnManager.GetConnection(sSCCtrl, nInt);

      if Assigned(nWorker) then
      begin
        if not nWorker.FConn.Connected then
          nWorker.FConn.Connected := True;
        nWorker.FConn.GetTableNames(nList);

        if nList.IndexOf(sTable_Peibi + '_t') >= 0 then
        begin
          SetLength(nTables, 2);
          nTables[0].FMacro := sTable_Peibi;
          nTables[0].FValue := sTable_Peibi + '_b';
          nTables[1].FMacro := sTable_Peibi + '_t';
          nTables[1].FValue := sTable_Peibi;

          RenameTable(sSCCtrl, nTables);
        end;

        nIni.WriteInteger('System', 'SCCtrl', 0);
      end;

      gDBConnManager.ReleaseConnection(nWorker);
      nWorker := nil;

      ShowProgressForm('恢复生产数据');
      nWorker := gDBConnManager.GetConnection(sSCData, nInt);

      if Assigned(nWorker) then
      begin
        if not nWorker.FConn.Connected then
          nWorker.FConn.Connected := True;
        nWorker.FConn.GetTableNames(nList);

        if nList.IndexOf(sTable_Product + '_t') >= 0 then
        begin
          SetLength(nTables, 2);  
          nTables[0].FMacro := sTable_Product;
          nTables[0].FValue := sTable_Product + '_b';
          nTables[1].FMacro := sTable_Product + '_t';
          nTables[1].FValue := sTable_Product;

          RenameTable(sSCData, nTables);
        end;

        nIni.WriteInteger('System', 'SCData', 0);
      end; 

      nInit := GetTickCount - nInit;
      if nInit < 500 then
        Sleep(500 - nInit);
      //xxxxx

      gLastRestore := GetTickCount;
      ShowMsg('恢复成功', sHint);
    finally
      nList.Free;
      nIni.Free;
      
      CloseProgressForm;
      gDBConnManager.ReleaseConnection(nWorker);
    end;
  except
    on E:Exception do
    begin
      WriteLog(E.Message);
    end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 配置数据库连接
procedure ConfigDBConnection;
var nIdx: Integer;
    nIni: TIniFile;
    nList: TStrings;
    nParam: TDBParam;
begin
  gDBConnManager.MaxConn := 3;
  nList := nil;

  nIni := TIniFile.Create(gPath + sConfigFile);
  try
    nList := TStringList.Create;
    nIni.ReadSections(nList);

    for nIdx:=0 to nList.Count - 1 do
    if Pos('DBParam', nList[nIdx]) = 1 then
    begin
      with nParam,nIni do
      begin
        FID   := ReadString(nList[nIdx], 'DBFlag', '');
        FHost := ReadString(nList[nIdx], 'DBHost', '');
        FPort := ReadInteger(nList[nIdx], 'DBPort', 0);
        FDB   := ReadString(nList[nIdx], 'DBName', '');
        FUser := ReadString(nList[nIdx], 'DBUser', '');
        FPwd  := ReadString(nList[nIdx], 'DBPwd', '');
        FConn := ReadString(nList[nIdx], 'DBConn', '');

        FEnable    := True;
        FNumWorker := ReadInteger(nList[nIdx], 'DBWorker', 1);;
      end;

      gDBConnManager.AddParam(nParam);
      //新参数
    end;
  finally
    nList.Free;
    nIni.Free;
  end;
end;

//Desc: 准备工作
procedure ParepareDBWork(const nFullBackup: Boolean);
var nInit: Int64;
begin
  ShowProgressForm('备份生产数据');
  try
    nInit := GetTickCount;
    AddBackupField(sSCData, sTable_Product, nFullBackup);
    BackupData(sSCData, sTable_Product);
    
    ShowProgressForm('备份控制数据');
    AddBackupField(sSCCtrl, sTable_Peibi, nFullBackup);
    BackupData(sSCCtrl, sTable_Peibi);

    nInit := GetTickCount - nInit;
    if nInit < 500 then
      Sleep(500 - nInit);
    CloseProgressForm;
  except
    on E:Exception do
    begin
      CloseProgressForm;
      WriteLog(E.Message);
    end;
  end;
end;

//Date: 2013-10-26
//Parm: 数据标识;表名;是否重置
//Desc: 为nTable建立备份字段和索引,并重置标记
procedure AddBackupField(const nID, nTable: string; nReset: Boolean);
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nDS: TDataset;
    nWorker: PDBWorker;
begin
  nWorker := nil;
  nList := nil;
  try
    nStr := Format('Select * From %s Where 1<>1', [nTable]);
    nDS := gDBConnManager.SQLQuery(nStr, nWorker, nID);

    for nIdx:=nDS.FieldCount - 1 downto 0 do
      if CompareStr('B_Backup', nDS.Fields[nIdx].FieldName) = 0 then Break;
    //xxxxx

    if nIdx < 0 then
    begin
      if nTable = sTable_Product then
      begin
        nStr := 'Alter Table %s Add Column B_Backup Char(1) Default "N",' +
                'B_Modify Char(1) Default "N",B_ID Counter';
        nStr := Format(nStr, [nTable]);
        gDBConnManager.WorkerExec(nWorker, nStr);

        nStr := 'Create Index idx_b_%s On %s (B_Backup ASC,B_ID ASC)';
        nStr := Format(nStr, [nTable, nTable]);
        gDBConnManager.WorkerExec(nWorker, nStr);
      end else
      begin
        nStr := 'Alter Table %s Add Column B_Backup Char(1) Default "N",' +
                'B_Modify Char(1) Default "N"';
        nStr := Format(nStr, [nTable]);
        gDBConnManager.WorkerExec(nWorker, nStr);

        nStr := 'Create Index idx_b_%s On %s (B_Backup ASC)';
        nStr := Format(nStr, [nTable, nTable]);
        gDBConnManager.WorkerExec(nWorker, nStr);
      end;

      nReset := True;
      //初次需重置
    end; //备份标记和索引

    nList := TStringList.Create;
    nWorker.FConn.GetTableNames(nList);

    if (nList.IndexOf(nTable + '_b') < 0) and
       (nList.IndexOf(nTable + '_t') < 0) then
    begin
      nStr := 'Select * Into %s_b From %s Where 1<>1';
      nStr := Format(nStr, [nTable, nTable]);
      gDBConnManager.WorkerExec(nWorker, nStr);

      nStr := 'Create Index idx_b_%s On %s_b (B_Backup ASC, B_Modify ASC)';
      nStr := Format(nStr, [nTable, nTable]);
      gDBConnManager.WorkerExec(nWorker, nStr);
    end; //备份表和索引

    if nTable = sTable_Peibi then
    begin
      if nList.IndexOf(nTable + '_g') < 0 then
      begin
        nStr := 'Select * Into %s_g From %s Where 1<>1';
        nStr := Format(nStr, [nTable, nTable]);
        gDBConnManager.WorkerExec(nWorker, nStr);

        nStr := 'Alter Table %s_g Add Column B_Date DateTime,B_Valid Char(1)';
        nStr := Format(nStr, [nTable]);
        gDBConnManager.WorkerExec(nWorker, nStr);

        nStr := 'Create Index idx_b_%s On %s_g (配比编号 ASC,B_Date ASC,B_Valid ASC)';
        nStr := Format(nStr, [nTable, nTable]);
        gDBConnManager.WorkerExec(nWorker, nStr);
      end; //国标

      if nList.IndexOf(nTable + '_w') < 0 then
      begin
        nStr := 'Select * Into %s_w From %s Where 1<>1';
        nStr := Format(nStr, [nTable, nTable]);
        gDBConnManager.WorkerExec(nWorker, nStr);

        nStr := 'Alter Table %s_w Add Column B_Date DateTime,B_Valid Char(1)';
        nStr := Format(nStr, [nTable]);
        gDBConnManager.WorkerExec(nWorker, nStr);

        nStr := 'Create Index idx_b_%s On %s_w (配比编号 ASC,B_Date ASC,B_Valid ASC)';
        nStr := Format(nStr, [nTable, nTable]);
        gDBConnManager.WorkerExec(nWorker, nStr);
      end; //误差
    end;

    if nReset then
    begin
      nStr := 'Update %s Set B_Backup=''N'',B_Modify=''N'' ' +
              'Where B_Backup=''Y'' or B_Backup is null';
      nStr := Format(nStr, [nTable]);
      gDBConnManager.WorkerExec(nWorker, nStr);

      nStr := 'Delete From %s_b';
      nStr := Format(nStr, [nTable]);
      gDBConnManager.WorkerExec(nWorker, nStr);
    end; //重新备份
  finally
    nList.Free;
    gDBConnManager.ReleaseConnection(nWorker);
  end;
end;

//Date: 2013-10-26
//Parm: 连接标识;表名
//Desc: 备份nTable数据库
procedure BackupData(const nID,nTable: string);
var nStr: string;
    nInit: Int64;
    nList: TStrings;
    nErr: Integer;
    nWorker: PDBWorker;
begin
  nWorker := nil;
  nList := nil;
  try
    nWorker := gDBConnManager.GetConnection(nID, nErr);
    if not Assigned(nWorker) then
    begin
      ShowMsg('连接数据库失败', sHint);
      Exit;
    end;

    nList := TStringList.Create;
    if not nWorker.FConn.Connected then
      nWorker.FConn.Connected := True;
    nWorker.FConn.GetTableNames(nList);

    if nList.IndexOf(nTable + '_t') >= 0 then
      Exit;
    //已切换,无法备份

    if nTable = sTable_Product then
    begin
      nStr := 'Insert Into %s_b Select * From %s Where B_Backup=''N'' and(' +
              '生产时间 not in (Select 生产时间 From %s_b Where B_Backup=''N''))';
      nStr := Format(nStr, [nTable, nTable, nTable]);

      nInit := GetTickCount;
      gDBConnManager.WorkerExec(nWorker, nStr);
      WriteLog(Format('备份%s: %d', [nTable, GetTickCount - nInit]));

      nStr := 'Update %s Set B_Backup=''Y'' Where B_Backup=''N'' and (' +
              '生产时间 in (Select 生产时间 From %s_b Where B_Backup=''N''))';
      nStr := Format(nStr, [nTable, nTable]);

      nInit := GetTickCount;
      gDBConnManager.WorkerExec(nWorker, nStr);
      WriteLog(Format('更新标记%s: %d', [nTable, GetTickCount - nInit]));

      nStr := 'Update %s_b Set B_Backup=''Y'' Where B_Backup=''N''';
      nStr := Format(nStr, [nTable]);

      nInit := GetTickCount;
      gDBConnManager.WorkerExec(nWorker, nStr);
      WriteLog(Format('更新标记%s_b: %d', [nTable, GetTickCount - nInit]));
    end else

    if nTable = sTable_Peibi then
    begin
      nStr := 'Insert Into %s_b Select * From %s Where B_Backup=''N'' and(' +
              '配比号 not in (Select 配比号 From %s_b Where B_Backup=''N''))';
      nStr := Format(nStr, [nTable, nTable, nTable]);

      nInit := GetTickCount;
      gDBConnManager.WorkerExec(nWorker, nStr);
      WriteLog(Format('备份%s: %d', [nTable, GetTickCount - nInit]));

      nStr := 'Update %s Set B_Backup=''Y'' Where B_Backup=''N'' and (' +
              '配比号 in (Select 配比号 From %s_b Where B_Backup=''N''))';
      nStr := Format(nStr, [nTable, nTable]);

      nInit := GetTickCount;
      gDBConnManager.WorkerExec(nWorker, nStr);
      WriteLog(Format('更新标记%s: %d', [nTable, GetTickCount - nInit]));

      nStr := 'Update %s_b Set B_Backup=''Y'' Where B_Backup=''N''';
      nStr := Format(nStr, [nTable]);
      
      nInit := GetTickCount;
      gDBConnManager.WorkerExec(nWorker, nStr);
      WriteLog(Format('更新标记%s_b: %d', [nTable, GetTickCount - nInit]));
    end;
  finally
    nList.Free;
    gDBConnManager.ReleaseConnection(nWorker);
  end;
end;

//Desc: 应用配比数据
procedure CombinePeibiData;
var nStr: string;
    nIdx,nLen: Integer;
    nWorker: PDBWorker;
    nMI: TDynamicMacroArray;
begin
  nWorker := nil;
  try
    nStr := 'Select * From %s where 1<>1';
    nStr := Format(nStr, [sTable_Peibi]);

    nLen := 0;
    with gDBConnManager.SQLQuery(nStr, nWorker, sSCCtrl) do
     for nIdx:=0 to FieldCount - 1 do
     begin
       if Fields[nIdx].DataType = ftAutoInc then Continue;
       SetLength(nMI, nLen + 1);

       nMI[nLen].FMacro := 'a.' + Fields[nIdx].FieldName;
       nMI[nLen].FValue := 'b.' + Fields[nIdx].FieldName;
       Inc(nLen);
     end;

    nStr := 'b.B_Valid=''Y'' and a.配比编号=b.配比编号';
    nStr := MakeSQLByMI(nMI, Format('%s_b a,%s_g b', [sTable_Peibi,
            sTable_Peibi]), nStr, False);
    gDBConnManager.WorkerExec(nWorker, nStr);
  finally
    gDBConnManager.ReleaseConnection(nWorker);
  end;
end;

//Desc: 载入配比列表
procedure LoadPBList;
var nStr: string;
    nIdx,nPos: Integer;
    nWorker: PDBWorker;
    nItem: PPBItem;
    nData: PPBData;
begin
  if Assigned(gPBItems) then
       ClearPBList(gPBItems, False)
  else gPBItems := TList.Create;
  
  nWorker := nil;
  try
    nStr := 'Select 配比号,配比编号 From %s';
    nStr := Format(nStr, [sTable_Peibi]);
       
    with gDBConnManager.SQLQuery(nStr, nWorker, sSCCtrl) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        New(nItem);
        gPBItems.Add(nItem);

        nItem.FRecord := Fields[0].AsString;
        nItem.FPeiBi := Fields[1].AsString;
        nItem.FData := nil;

        Next;
      end;
    end;

    //--------------------------------------------------------------------------
    nStr := 'Select * From %s_g Where B_Valid=''Y''';
    nStr := Format(nStr, [sTable_Peibi]);

    with gDBConnManager.WorkerQuery(nWorker, nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := FieldByName('配比编号').AsString;
        nItem := GetPBItem(gPBItems, nStr, False);

        if not Assigned(nItem) then
        begin
          Next;
          Continue;
        end;

        if not Assigned(nItem.FData) then
          nItem.FData := TList.Create;
        //xxxxx

        for nIdx:=FieldCount - 1 downto 0 do
        begin
          nStr := Fields[nIdx].AsString;
          if (nStr = '') or (not IsNumber(nStr, True)) then Continue;

          New(nData);
          nItem.FData.Add(nData);

          nData.FItem := Fields[nIdx].FieldName;
          nData.FGuobiao := StrToFloat(nStr);
          nData.FPercent := 0;
        end;

        Next;
      end;
    end;

    //--------------------------------------------------------------------------
    nStr := 'Select * From %s_w Where B_Valid=''Y''';
    nStr := Format(nStr, [sTable_Peibi]);

    with gDBConnManager.WorkerQuery(nWorker, nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := FieldByName('配比编号').AsString;
        nItem := GetPBItem(gPBItems, nStr, False);

        if not (Assigned(nItem) and Assigned(nItem.FData)) then
        begin
          Next;
          Continue;
        end;

        for nIdx:=FieldCount - 1 downto 0 do
        begin
          nStr := Fields[nIdx].AsString;
          if (nStr = '') or (not IsNumber(nStr, True)) then Continue;

          nData := GetPBData(nItem.FData, Fields[nIdx].FieldName);
          if not Assigned(nData) then Continue;

          nPos := Pos('.', nStr);
          if nPos > 1 then
          begin
            System.Delete(nStr, 1, nPos);
            nStr := '1' + StringOfChar('0', Length(nStr));
            nData.FPercent := StrToInt(nStr);

            if nData.FPercent > 10000 then
              nData.FPercent := 10000;
            //避免过大越界
          end else nData.FPercent := 1;

          nData.FWuCha := Trunc(Fields[nIdx].AsFloat * nData.FPercent);
          //按比例放大误差值
        end;

        Next;
      end;
    end;

    //--------------------------------------------------------------------------
    for nIdx:=gPBItems.Count - 1 downto 0 do
    begin
      nItem := gPBItems[nIdx];
      if not Assigned(nItem.FData) then
      begin
        DisposePBItem(nItem);
        gPBItems.Delete(nIdx);
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nWorker);
  end;
end;

//Desc: 应用产品数据
procedure CombineProductData;
var nStr: string;
    nField: TField;
    nWorker: PDBWorker;
    nVal: Double;
    nIdx,nLen,nInt: Integer;

    nItem: PPBItem;
    nData: PPBData;
    nMI: TDynamicMacroArray;

    //Desc: 获取nStr对应的配比项
    function GetPBItemName(var nStr: string): Integer;
    begin
      Result := 0;
      nInt := Pos('设定', nStr);

      if nInt > 0 then
      begin
        Result := 1;
        nStr := Copy(nStr, 1, nInt - 1);
      end else
      begin
        nInt := Pos('配料', nStr);
        if nInt > 0 then
        begin
          Result := 2;
          nStr := Copy(nStr, 1, nInt - 1);
        end;  
      end;

      if nStr = '粉煤灰一' then
        nStr := '粉煤灰';
      //xxxx
    end;

    procedure ResetVName(var nStr: string);
    begin
      if nStr = '粉煤灰' then
        nStr := '粉煤灰一';
      //xxxx
    end;

    //Desc: 获取nStr项的设定值
    function GetSDValue(const nStr: string): Double;
    var i: Integer;
    begin
      Result := 0;

      for i:=Low(nMI) to High(nMI) do
      if nMI[i].FMacro = nStr then
      begin
        Result := StrToFloat(nMI[i].FValue);
        Break;
      end;
    end;
begin
  nWorker := nil;
  try
    LoadPBList;
    //读取配比列表
    
    nStr := 'Select * From %s_b where B_Modify=''N''';
    nStr := Format(nStr, [sTable_Product]);

    with gDBConnManager.SQLQuery(nStr, nWorker, sSCData) do
    if RecordCount > 0 then
    begin
      Randomize;
      First;

      while not Eof do
      begin
        nStr := FieldByName('配比号').AsString;
        nItem := GetPBItem(gPBItems, nStr, True);

        if not Assigned(nItem) then
        begin
          Next;
          Continue;
        end;

        nLen := 0;
        SetLength(nMI, 0);
        
        for nIdx:=0 to FieldCount - 1 do
        begin
          nStr := Fields[nIdx].AsString;
          if (not IsNumber(nStr, True)) or (StrToFloat(nStr) <= 0) then Continue;
          //未设值不予处理

          nStr := Fields[nIdx].FieldName;
          nInt := GetPBItemName(nStr);

          if nInt = 0 then Continue;
          nData := GetPBData(nItem.FData, nStr);

          if not Assigned(nData) then Continue;
          ResetVName(nStr);
          
          if nInt = 1 then
          begin
            if nData.FWuCha >= 0 then
                 nVal := nData.FGuobiao + Random(nData.FWuCha)/nData.FPercent
            else nVal := nData.FGuobiao - Random(-nData.FWuCha)/nData.FPercent;

            nStr := FloatToStr(nVal);
          end else //设定值使用国标
          begin
            nStr := nStr + '设定';
            nField := FindField(nStr);
            if not (Assigned(nField) and IsNumber(nField.AsString, True)) then Continue;

            nVal := GetSDValue(nStr) + Fields[nIdx].AsFloat - nField.AsFloat;
            if nVal > 0 then
                 nStr := FloatToStr(nVal)
            else Continue;
          end; //配料值使用国标 + 设定差值

          SetLength(nMI, nLen + 1);
          nMI[nLen].FMacro := Fields[nIdx].FieldName;
          nMI[nLen].FValue := nStr;
          Inc(nLen);
        end;

        SetLength(nMI, nLen + 1);
        nMI[nLen].FMacro := 'B_Modify';
        nMI[nLen].FValue := '''Y''';

        nStr := Format('B_ID=%s', [FieldByName('B_ID').AsString]);
        nStr := MakeSQLByMI(nMI, sTable_Product + '_b', nStr, False);
        gDBConnManager.WorkerExec(nWorker, nStr);

        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nWorker);
  end;
end;

//Date: 2013-10-28
//Parm: 连接标识;旧名,新名列表
//Desc: 将nID.nOld更名为nID.nNew
procedure RenameTable(const nID: string;
 const nTables: array of TMacroItem);
var nInit: Int64;
    nIdx: Integer;
    nAccess: OleVariant;
begin
  nAccess := Unassigned;
  try
    nInit := GetTickCount;
    nAccess := CreateOleObject('ADOX.Catalog');
    nAccess.ActiveConnection := gDBConnManager.GetConnectionStr(nID);

    for nIdx:=Low(nTables) to High(nTables) do
      nAccess.Tables[nTables[nIdx].FMacro].Name := nTables[nIdx].FValue;
    WriteLog(Format('Rename %s: %d', [nID, GetTickCount - nInit]));
  finally
    nAccess := Unassigned;
  end;
end;

initialization

finalization
  if Assigned(gPBItems) then
    ClearPBList(gPBItems, True);
  //xxxxx
end.
