{*******************************************************************************
  作者: dmzn@163.com 2012-03-26
  描述: 车辆调度
*******************************************************************************}
unit UFrameTruckDiapatch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  IniFiles, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxContainer, Menus, dxLayoutControl, cxMaskEdit, cxButtonEdit,
  cxTextEdit, ADODB, cxLabel, UBitmapPanel, cxSplitter, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin;

type
  TfFrameTruckDispatch = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N6: TMenuItem;
    N3: TMenuItem;
    N7: TMenuItem;
    N5: TMenuItem;
    N4: TMenuItem;
    cxLevel2: TcxGridLevel;
    cxView2: TcxGridTableView;
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure OnLoadPopedom; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
    procedure SetTruckQueue(const nFirst: Boolean);
    //车辆插队
  public
    { Public declarations }
    procedure OnLoadGridConfig(const nIni: TIniFile); override;
    procedure OnSaveGridConfig(const nIni: TIniFile); override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormInputbox, USysPopedom, USysConst,
  USysDB, USysGrid, USysBusiness, USysDataDict;

var
  gTruckData: TTruckDataSource = nil;
  //全局使用

class function TfFrameTruckDispatch.FrameID: integer;
begin
  Result := cFI_FrameTruckDispatch;
end;

procedure TfFrameTruckDispatch.OnLoadPopedom;
begin
  inherited;
  N1.Enabled := BtnAdd.Enabled;
  N2.Enabled := BtnAdd.Enabled;

  N3.Enabled := BtnEdit.Enabled;
  N4.Enabled := BtnEdit.Enabled;
  N5.Enabled := BtnEdit.Enabled;
end;

procedure TfFrameTruckDispatch.OnLoadGridConfig(const nIni: TIniFile);
begin
  inherited;
  cxGrid1.ActiveLevel := cxLevel1;
  gSysEntityManager.BuildViewColumn(cxView2, 'MAIN_B02');
  InitTableView(Name, cxView2, nIni);

  if not Assigned(gTruckData) then
    gTruckData := TTruckDataSource.Create;
  cxView2.DataController.CustomDataSource := gTruckData;
end;

procedure TfFrameTruckDispatch.OnSaveGridConfig(const nIni: TIniFile);
begin
  inherited;
  cxView2.DataController.CustomDataSource := nil;
  FreeAndNil(gTruckData);
  SaveUserDefineTableView(Name, cxView2, nIni);
end;

//------------------------------------------------------------------------------
function TfFrameTruckDispatch.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From $ZC zc ';
  //xxxxx

  if nWhere <> '' then
    Result := Result + ' Where (' + nWhere + ')';
  //xxxx

  Result := MacroValue(Result, [MI('$ZC', sTable_ZCTrucks)]);
  //xxxxx

  gTruckData.LoadTrucks(gSysParam.FURL_MIT);
  //truck queue
end;

//Desc: 执行查询
procedure TfFrameTruckDispatch.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := Format('T_Truck like ''%%%s%%''', [EditTruck.Text]);
    InitFormData(FWhere);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2012-4-26
//Parm: 是否队首
//Desc: 车辆插队
procedure TfFrameTruckDispatch.SetTruckQueue(const nFirst: Boolean);
var nDate: TDateTime;
    nStr,nTruck: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    if nFirst then
    begin
      nStr := '确定要将车辆[ %s ]插入队首吗?' + #13#10 +
              '该车将优先装车.';
    end else
    begin
      nStr := '确定要将车辆[ %s ]插入队尾吗?' + #13#10 +
              '该车按照最后进站车辆排队.';
    end;

    nTruck := SQLQuery.FieldByName('T_Truck').AsString;
    nStr := Format(nStr, [nTruck]);
    if not QueryDlg(nStr, sAsk) then Exit;

    if nFirst then
    begin
      nStr := 'Select Min(T_InTime),%s As T_Now From %s Where T_Truck=''%s''';
    end else
    begin
      nStr := 'Select Max(T_InTime),%s As T_Now From %s Where T_Truck=''%s''';
    end;

    nStr := Format(nStr, [sField_SQLServer_Now, sTable_ZCTrucks, nTruck]);
    //sql

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      nDate := Fields[0].AsDateTime;
      if nFirst then
           nDate := nDate - StrToTime('00:00:02')
      else nDate := nDate + StrToTime('00:00:02');
    end else
    begin
      nDate := Fields[0].AsDateTime;
    end;

    nStr := 'Update %s Set T_InTime=''%s'',T_Valid=''%s'',T_Line='''' ' +
            'Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_ZCTrucks, DateTime2Str(nDate), sFlag_Yes,
            nTruck]);
    //xxxxx

    FDM.ExecuteSQL(nStr);
    if nFirst then
      FDM.WriteSysLog(sFlag_LGTruckQueue, nTruck, '车辆插入队首.');
    //xxxxx

    InitFormData(FWhere);
    ShowMsg('插队完毕', sHint);
  end;
end;

//Desc: 插队首
procedure TfFrameTruckDispatch.N1Click(Sender: TObject);
begin
  SetTruckQueue(True);
end;

//Desc: 插队尾
procedure TfFrameTruckDispatch.N2Click(Sender: TObject);
begin
  SetTruckQueue(False);
end;

//Desc: 定道装车
procedure TfFrameTruckDispatch.N3Click(Sender: TObject);
var nStr,nLine,nSQL: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nLine := SQLQuery.FieldByName('T_Line').AsString;
    nStr := nLine;
    if not ShowInputBox('请输入新的装车通道号:', sHint, nLine, 15) then Exit;

    nLine := Trim(nLine);
    if nLine <> '' then
    begin
      nSQL := 'Select Z_ID From %s Where Z_ID=''%s''';
      nSQL := Format(nSQL, [sTable_ZCLines, nLine]);

      with FDM.QueryTemp(nSQL) do
      if RecordCount < 1 then
      begin
        ShowMsg('无效的通道编号', sHint);
        Exit;
      end;
    end;

    nSQL := 'Update %s Set T_Line=''%s'' Where R_ID=%s';
    nSQL := Format(nSQL, [sTable_ZCTrucks, nLine,
            SQLQuery.FieldByName('R_ID').AsString]);
    FDM.ExecuteSQL(nSQL);

    nSQL := '指定装车道[ %s ]->[ %s ]';
    if nStr = '' then nStr := '空';
    nSQL := Format(nSQL, [nStr, nLine]);

    nStr := SQLQuery.FieldByName('T_Truck').AsString;
    FDM.WriteSysLog(sFlag_LGTruckQueue, nStr, nSQL);
    InitFormData(FWhere);
  end;
end;

//Desc: 车辆出队入队
procedure TfFrameTruckDispatch.N4Click(Sender: TObject);
var nStr,nFlag,nEvent,nTruck: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    case TComponent(Sender).Tag of
     10:
      begin
        nFlag := sFlag_Yes;
        nEvent := '车辆[ %s ]入队操作.';
      end;
     20:
      begin
        nFlag := sFlag_No;
        nEvent := '车辆[ %s ]移出队列.';
      end;
    end;

    nTruck := SQLQuery.FieldByName('T_Truck').AsString;
    nStr := 'Update %s Set T_Valid=''%s'' Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_ZCTrucks, nFlag, nTruck]);
    FDM.ExecuteSQL(nStr);
                                    
    nEvent := Format(nEvent, [nTruck]);
    FDM.WriteSysLog(sFlag_LGTruckQueue, nTruck, nEvent);
    InitFormData(FWhere);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameTruckDispatch, TfFrameTruckDispatch.FrameID);
end.
