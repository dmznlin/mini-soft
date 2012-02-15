{*******************************************************************************
  作者: dmzn@163.com 2011-6-7
  描述: 库存盘点
*******************************************************************************}
unit UFrameQKuCun;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, ADODB, cxContainer, cxLabel,
  dxLayoutControl, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxTextEdit, cxMaskEdit, cxButtonEdit, UBitmapPanel,
  cxSplitter, Menus, cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFrameQKuCun = class(TfFrameNormal)
    EditName: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit5: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    procedure BtnAddClick(Sender: TObject);
    procedure EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
    FStart,FEnd: TDate;
    //时间区间
  protected
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    //基类方法
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, UFormBase,
  USysBusiness, UFormDateFilter, UFormWait;

class function TfFrameQKuCun.FrameID: integer;
begin
  Result := cFI_FrameQKuCun;
end;

procedure TfFrameQKuCun.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameQKuCun.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//------------------------------------------------------------------------------
//Desc: 数据查询SQL
function TfFrameQKuCun.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select S_Name,kc.*,gd.*,(K_RuKu-K_ChuKu) as K_KuCun From $KC kc ' +
            ' Left Join $ST st On st.S_ID=K_Storage ' +
            ' Left Join $GD gd On gd.G_ID=K_Goods ' +
            'Where (K_Date>=''$SR'' and K_Date <''$End'')';
  Result := MacroValue(Result, [MI('$KC', sTable_KuCun),
            MI('$ST', sTable_Storage), MI('$GD', sTable_Goods),
            MI('$SR', Date2Str(FStart)), MI('$End', Date2Str(FEnd+1))]);
  //xxxxx

  if nWhere <> '' then
    Result := Result + ' And (' + nWhere + ')';
  //xxxxx
end;

//Desc: 盘库
procedure TfFrameQKuCun.BtnAddClick(Sender: TObject);
var nStr,nRK,nCK: string;
begin
  nStr := '系统将盘点今天的库存.' + #13#10 +
          '该操作可能需要一些时间,要继续吗?';
  if not QueryDlg(nStr, sAsk, Handle) then Exit;

  ShowWaitForm(Application.MainForm, '盘点库存');
  try
    Sleep(720);
    ShowWaitForm(Application.MainForm, '1/5');
    
    nStr := 'Delete From ' + sTable_KuCunTmp;
    FDM.ExecuteSQL(nStr);
    ShowWaitForm(Application.MainForm, '2/5');
    
    nRK := 'Select B_Storage,B_Goods,B_Num From $BP ' +
           ' Union All ' +
           'Select Y_Storage,Y_Goods,Y_Num From $YL ';
    nRK := MacroValue(nRK, [MI('$BP', sTable_BeiPin), MI('$YL', sTable_YuanLiao)]);
    //xxxxx

    nStr := 'Select B_Storage,B_Goods,Sum(B_Num) as B_RuKu From (%s) t ' +
            'Group By B_Storage,B_Goods';
    nRK := Format(nStr, [nRK]);
    //入库合计

    nStr := 'Select rk.*,''%s'' as K_Man,%s as K_Date From (%s) rk';
    nRK := Format(nStr, [gSysParam.FUserID, FDM.SQLServerNow, nRK]);
    //合并日期

    nStr := 'Insert Into %s(K_Storage,K_Goods,K_RuKu,K_Man,K_Date) ' +
            'Select * From (%s) t';
    nStr := Format(nStr, [sTable_KuCunTmp, nRK]);
    FDM.ExecuteSQL(nStr);
    ShowWaitForm(Application.MainForm, '3/5');
    
    nCK := 'Select D_RStorage,D_Goods,Sum(D_Num) as D_ChuKu From %s ' +
           'Group By D_RStorage,D_Goods';
    nCK := Format(nCK, [sTable_ChuKuDtl]);
    //出库合计

    nStr := 'Update %s Set K_ChuKu=IsNull(D_ChuKu,0) From (%s) ck ' +
            'Where D_RStorage=K_Storage and D_Goods=K_Goods';
    nStr := Format(nStr, [sTable_KuCunTmp, nCK]);
    FDM.ExecuteSQL(nStr);

    FDM.ADOConn.BeginTrans;
    try
      ShowWaitForm(Application.MainForm, '4/5');
      nCK := Date2Str(FDM.ServerNow);

      nStr := 'Delete From %s Where K_Date>=''%s'' And K_Date<''%s''';
      nStr := Format(nStr, [sTable_KuCun, nCK, Date2Str(Str2Date(nCK)+1)]);
      FDM.ExecuteSQL(nStr);
      //清理当天库存

      ShowWaitForm(Application.MainForm, '5/5');
      nStr := 'Insert Into %s(K_Storage,K_Goods,K_RuKu,K_ChuKu,K_Man,K_Date) ' +
              'Select K_Storage,K_Goods,K_RuKu,K_ChuKu,K_Man,K_Date From %s';
      nStr := Format(nStr, [sTable_KuCun, sTable_KuCunTmp]);
      FDM.ExecuteSQL(nStr);

      FDM.ADOConn.CommitTrans;
      InitFormData(FWhere);
      ShowMsg('库存盘点完毕', sHint);
    except
      FDM.ADOConn.RollbackTrans;
      ShowMsg('盘点库存失败', sError);
    end;
  finally
    CloseWaitForm;
  end;
end;

//Desc: 选择时间
procedure TfFrameQKuCun.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameQKuCun.EditNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := 'G_Name like ''%%%s%%'' Or G_PY Like ''%%%s%%''';
    FWhere := Format(FWhere, [EditName.Text, EditName.Text]);
    InitFormData(FWhere);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameQKuCun, TfFrameQKuCun.FrameID);
end.
