{*******************************************************************************
  ����: dmzn 2008-8-29
  ����: �Զ������ݼ�
*******************************************************************************}
unit USysDataSet;

interface

uses
  Classes, Controls, DB, SysUtils, cxCustomData, UMgrDataDict, USysDict,
  USysFun, TypInfo;

type
  TCustomerDataSource = class(TcxCustomDataSource)
  private
    FAlign: TStrings;
    FFieldType: TStrings;
    FFmtStyle: TStrings;
    FFooterKind: TStrings;
    FFooterPosition: TStrings;
    {*��������*}
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle;
      AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create;
    destructor Destroy; override;
    function AlignToText(const nAlign: TAlignment): string;
    function FieldTypeToStr(const nType: TFieldType): string;
    function FmtStyleToStr(const nStyle: TDictFormatStyle): string;
    function FooterKindToStr(const nKind: TDictFooterKind): string;
    function FooterPositionToStr(const nPositon: TDictFooterPosition): string;
  end;

var
  gSysDataSet: TCustomerDataSource = nil;
  //���ݼ�

implementation

constructor TCustomerDataSource.Create;
begin
  inherited;
  FAlign := TStringList.Create;
  FFieldType := TStringList.Create;
  FFmtStyle := TStringList.Create;
  FFooterKind := TStringList.Create;
  FFooterPosition := TStringList.Create;

  GetOrdTypeInfo(TypeInfo(TAlignment), FAlign);
  GetOrdTypeInfo(TypeInfo(TFieldType), FFieldType);
  GetOrdTypeInfo(TypeInfo(TDictFormatStyle), FFmtStyle);
  GetOrdTypeInfo(TypeInfo(TDictFooterKind), FFooterKind);
  GetOrdTypeInfo(TypeInfo(TDictFooterPosition), FFooterPosition);
end;

destructor TCustomerDataSource.Destroy;
begin
  FAlign.Free;
  FFieldType.Free;
  FFmtStyle.Free;
  FFooterKind.Free;
  FFooterPosition.Free;
  inherited;
end;

function TCustomerDataSource.AlignToText(const nAlign: TAlignment): string;
begin
  Result := FAlign[Ord(nAlign)];
  System.Delete(Result, 1, Pos('=', Result));
end;

function TCustomerDataSource.FieldTypeToStr(const nType: TFieldType): string;
begin
  Result := FFieldType[Ord(nType)];
  System.Delete(Result, 1, Pos('=', Result));
end;

function TCustomerDataSource.FmtStyleToStr(const nStyle: TDictFormatStyle): string;
begin
  Result := FFmtStyle[Ord(nStyle)];
  System.Delete(Result, 1, Pos('=', Result));
end;

function TCustomerDataSource.FooterKindToStr(const nKind: TDictFooterKind): string;
begin
  Result := FFooterKind[Ord(nKind)];
  System.Delete(Result, 1, Pos('=', Result));
end;

function TCustomerDataSource.FooterPositionToStr(const nPositon: TDictFooterPosition): string;
begin
  Result := FFooterPosition[Ord(nPositon)];
  System.Delete(Result, 1, Pos('=', Result));
end;

function TCustomerDataSource.GetRecordCount: Integer;
begin
  if Assigned(gSysEntityManager.ActiveEntity) and
     Assigned(gSysEntityManager.ActiveEntity.FDictItem) then
       Result := gSysEntityManager.ActiveEntity.FDictItem.Count
  else Result := 0;
end;

function TCustomerDataSource.GetValue(ARecordHandle: TcxDataRecordHandle;
  AItemHandle: TcxDataItemHandle): Variant;
var nRow: integer;
    nColumn: Integer;
    nItem: PDictItemData;
begin
  nColumn := GetDefaultItemID(Integer(AItemHandle));
  nRow := Integer(ARecordHandle);
  nItem := gSysEntityManager.ActiveEntity.FDictItem[nRow];

  case nColumn of
    0: Result := nItem.FItemID;
    1: Result := nItem.FTitle;
    2: Result := AlignToText(nItem.FAlign);
    3: Result := nItem.FWidth;
    4: Result := nItem.FIndex;
    5: Result := nItem.FVisible;
    6: Result := nItem.FLangID;
    7: Result := nItem.FDBItem.FTable;
    8: Result := nItem.FDBItem.FField;
    9: Result := nItem.FDBItem.FIsKey;
    10: Result := FieldTypeToStr(nItem.FDBItem.FType);
    11: Result := nItem.FDBItem.FWidth;
    12: Result := nItem.FDBItem.FDecimal;
    13: Result := FmtStyleToStr(nItem.FFormat.FStyle);
    14: Result := nItem.FFormat.FData;
    15: Result := nItem.FFormat.FFormat;
    16: Result := nItem.FFormat.FExtMemo;
    17: Result := nItem.FFooter.FDisplay;
    18: Result := nItem.FFooter.FFormat;
    19: Result := FooterKindToStr(nItem.FFooter.FKind);
    20: Result := FooterPositionToStr(nItem.FFooter.FPosition);
  end;
end;

initialization
  gSysDataSet := TCustomerDataSource.Create;
finalization
  FreeAndNil(gSysDataSet);
end.
