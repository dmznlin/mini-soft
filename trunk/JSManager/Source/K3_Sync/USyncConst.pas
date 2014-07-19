{*******************************************************************************
  作者: dmzn@163.com 2014-06-16
  描述: 常量定义
*******************************************************************************}
unit USyncConst;

interface

uses
  Windows, Classes, SysUtils, DB, UMgrDBConn, UFormCtrl, UWaitItem, ULibFun,
  USysLoger, USysDB;

type
  TSyncThread = class(TThread)
  private
    FStrings: TStrings;
    //字符列表
    FWaiter: TWaitObject;
    //等待对象
    FLastClearAll: TDateTime;
    //上次清理
  protected
    procedure SyncClearAll;
    procedure SyncBill;
    procedure SyncReport;
    procedure Execute; override;
    //执行同步
    procedure InitK3_DB(const nTable: string);
    //初始化
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放
    procedure StopMe;
    //停止同步
  end;
  
var
  gPath: string;
  gSyncer: TSyncThread = nil;

//------------------------------------------------------------------------------
ResourceString
  sHint               = '提示';                      //对话框标题
  sWarn               = '警告';                      //==
  sAsk                = '询问';                      //询问对话框
  sError              = '未知错误';                  //错误对话框

  sDate               = '日期:【%s】';               //任务栏日期
  sTime               = '时间:【%s】';               //任务栏时间
  sUser               = '用户:【%s】';               //任务栏用户

  sLogDir             = 'Logs\';                     //日志目录
  sLogExt             = '.log';                      //日志扩展名
  sLogField           = #9;                          //记录分隔符

  sConfigFile         = 'Config.Ini';                //主配置文件
  sConfigSec          = 'Config';                    //主配置小节
  sVerifyCode         = ';Verify:';                  //校验码标记

  sFormConfig         = 'FormInfo.ini';              //窗体配置
  sSetupSec           = 'Setup';                     //配置小节
  sDBConfig           = 'DBConn.ini';                //数据连接

  sDB_K3              = 'k3_db';
  sDB_JS              = 'js_db';                     //数据库
  
  sTable_K3_Bill      = 'ICStockBillEntry';          //出库单
  sTable_K3_Stock     = 't_ICItem';                  //物料表

  sPerform            = 'perform';                   //性能配置
  sCloseQuery         = '确定要退出程序吗?';         //主窗口退出

implementation

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TSyncThread, 'K3同步线程', nEvent);
end;

constructor TSyncThread.Create;
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FStrings := TStringList.Create;
  FWaiter := TWaitObject.Create;
  FWaiter.Interval := Trunc(3.5 * 1000);
end;

destructor TSyncThread.Destroy;
begin
  FWaiter.Free;
  FStrings.Free;
  inherited;
end;

procedure TSyncThread.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure TSyncThread.Execute;
begin
  InitK3_DB(sTable_K3_Bill);
  //InitK3_DB(sTable_K3_Stock);
  FLastClearAll := Now;

  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Exit;

    SyncBill;
    SyncReport;
    SyncClearAll;
  except
    on E: Exception do
    begin
      WriteLog(E.Message);
    end;
  end;
end;

//Desc: 初始化K3结构
procedure TSyncThread.InitK3_DB(const nTable: string);
var nStr: string;
    nIdx: Integer;
    nDS: TDataset;
    nWorker: PDBWorker;
begin
  try
    nWorker := nil;
    try
      nStr := Format('Select * From %s Where 1<>1', [nTable]);
      nDS := gDBConnManager.SQLQuery(nStr, nWorker, sDB_K3);

      for nIdx:=nDS.FieldCount - 1 downto 0 do
        if CompareStr('B_Backup', nDS.Fields[nIdx].FieldName) = 0 then Break;
      //xxxxx

      if nIdx < 0 then
      begin
        nStr := 'Alter Table %s Add B_Backup Char(1) Default ''N''';
        nStr := Format(nStr, [nTable]);
        gDBConnManager.WorkerExec(nWorker, nStr);

        nStr := 'Create Index idx_b_%s On %s (B_Backup ASC)';
        nStr := Format(nStr, [nTable, nTable]);
        gDBConnManager.WorkerExec(nWorker, nStr);
      end; //备份标记和索引
    finally
      gDBConnManager.ReleaseConnection(nWorker);
    end;
  except
    on E:Exception do
    begin
      WriteLog(E.Message);
    end;
  end;
end;

//Desc: 同步交货单
procedure TSyncThread.SyncBill;
var nStr: string;
    nK3: PDBWorker;
    nListK3,nListJS: TStrings;
begin
  nK3 := nil;
  nListK3 := nil;
  nListJS := nil;
  try
    nStr := 'Select u1.FInterID,v1.FDate,v1.FBillNo, t4.FItemID as FCusID,' +
            't4.FName as FCusName, t14.FItemID ,t14.FName as FItemName,' +
            'v1.FHeadSelfB0144 as FTruck,v1.FHeadSelfB0145 as FDriver,' +
            'u1.FQty From ICStockBill v1 ' +
            '  Inner Join ICStockBillEntry u1 on v1.FInterID=u1.FInterID ' +
            '  Inner Join t_Organization t4 on v1.FSupplyID=t4.FItemID ' +
            '  Inner Join t_ICItem t14 on u1.FItemID=t14.FItemID ' +
            'Where u1.B_Backup=''N'' And v1.FTranType=21 And ' +
            '  t14.FName Like ''%袋%''';
    //未同步袋装交货单

    with gDBConnManager.SQLQuery(nStr, nK3, sDB_K3) do
    if RecordCount > 0 then
    begin
      nListK3 := TStringList.Create;
      nListJS := TStringList.Create;
      First;

      while not Eof do
      begin
        nStr := MakeSQLByStr([SF('L_CusID', FieldByName('FCusID').AsString),
                SF('L_Customer', FieldByName('FCusName').AsString),
                SF('L_StockID', FieldByName('FItemID').AsString),
                SF('L_Stock', FieldByName('FItemName').AsString),
                SF('L_TruckNo', FieldByName('FTruck').AsString),
                SF('L_Driver', FieldByName('FDriver').AsString),
                SF('L_Weight', FieldByName('FQty').AsFloat),
                SF('L_Bill', FieldByName('FBillNo').AsString),
                SF('L_BillDate', sField_SQLServer_Now, sfVal)
                ], sTable_JSItem, '', True);
        nListJS.Add(nStr);

        nStr := 'Update %s Set B_Backup=''Y'' Where FInterID=%s ';
        nStr := Format(nStr, [sTable_K3_Bill, FieldByName('FInterID').AsString]);
        nListK3.Add(nStr);

        Next;
      end;

      gDBConnManager.ExecSQLs(nListJS, True, sDB_JS);
      gDBConnManager.ExecSQLs(nListK3, True, sDB_K3);
    end;
  finally
    nListK3.Free;
    nListJS.Free;    
    gDBConnManager.ReleaseConnection(nK3);
  end;
end;

//Desc: 同步报表
procedure TSyncThread.SyncReport;
var nStr: string;
    nK3: PDBWorker;
    nListK3,nListJS: TStrings;
begin
  nK3 := nil;
  nListK3 := nil;
  nListJS := nil;
  try
    nStr := 'Select u1.FInterID,v1.FDate, v1.FBillNo, t4.FItemID as FCusID,' +
            't4.FName as FCusName, t14.FItemID ,t14.FName as FItemName,' +
            'v1.FHeadSelfB0144 as FTruck,v1.FHeadSelfB0145 as FDriver,' +
            'v1.FHeadSelfB0146 as FMTime,v1.FHeadSelfB0148 as FMValue,' +
            'v1.FHeadSelfB0149 as FPValue,u1.FQty From ICStockBill v1 ' +
            '  Inner Join ICStockBillEntry u1 on v1.FInterID=u1.FInterID ' +
            '  Inner Join t_Organization t4 on v1.FSupplyID=t4.FItemID ' +
            '  Inner Join t_ICItem t14 on u1.FItemID=t14.FItemID ' +
            'Where u1.B_Backup=''N'' And v1.FTranType=21 And ' +
            '  v1.FHeadSelfB0146 Is Not Null And v1.FHeadSelfB0148 > 0';
    //未同步已过磅散装交货单

    with gDBConnManager.SQLQuery(nStr, nK3, sDB_K3) do
    if RecordCount > 0 then
    begin
      nListK3 := TStringList.Create;
      nListJS := TStringList.Create;

      FStrings.Clear;
      First;

      while not Eof do
      begin
        nStr := DateTime2Str(FieldByName('FMTime').AsDateTime);
        //称毛时间

        if FStrings.IndexOf(nStr) < 0 then
        begin
          FStrings.Add(nStr);
          //filter flag
        end else
        begin
          Next;
          Continue;
        end;

        nStr := MakeSQLByStr([SF('L_CusID', FieldByName('FCusID').AsString),
                SF('L_Customer', FieldByName('FCusName').AsString),
                SF('L_StockID', FieldByName('FItemID').AsString),
                SF('L_Stock', FieldByName('FItemName').AsString),
                SF('L_TruckNo', FieldByName('FTruck').AsString),
                SF('L_Weight', FieldByName('FQty').AsFloat),
                SF('L_PPValue', FieldByName('FPValue').AsFloat),
                SF('L_PMTime', nStr),
                SF('L_PMValue', FieldByName('FMValue').AsFloat),
                SF('L_Bill', FieldByName('FBillNo').AsString),
                SF('L_BillDate', nStr),
                SF('L_HasDone', sFlag_Yes),
                SF('L_OKTime', nStr),
                SF('L_Date', nStr),
                SF('L_Memo', 'K3自动同步')
                ], sTable_JSLog, '', True);
        nListJS.Add(nStr);

        nStr := 'Update %s Set B_Backup=''Y'' Where FInterID=%s ';
        nStr := Format(nStr, [sTable_K3_Bill, FieldByName('FInterID').AsString]);

        nListK3.Add(nStr);
        Next;
      end;

      gDBConnManager.ExecSQLs(nListJS, True, sDB_JS);
      gDBConnManager.ExecSQLs(nListK3, True, sDB_K3);
    end;
  finally
    nListK3.Free;
    nListJS.Free;    
    gDBConnManager.ReleaseConnection(nK3);
  end;
end;

//Desc: 清理所有过期数据
procedure TSyncThread.SyncClearAll;
var nStr: string;
begin
  if Now - FLastClearAll >= 1 then
  begin
    FLastClearAll := Now;
    nStr := 'Update %s Set B_Backup=''Y'' Where B_Backup=''N''';
    //xxxxx

    nStr := Format(nStr, [sTable_K3_Bill]);
    gDBConnManager.ExecSQL(nStr, sDB_K3);
  end;
end;

end.
