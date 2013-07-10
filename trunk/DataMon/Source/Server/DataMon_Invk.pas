unit DataMon_Invk;

{----------------------------------------------------------------------------}
{ This unit was automatically generated by the RemObjects SDK after reading  }
{ the RODL file associated with this project .                               }
{                                                                            }
{ Do not modify this unit manually, or your changes will be lost when this   }
{ unit is regenerated the next time you compile the project.                 }
{----------------------------------------------------------------------------}

{$I RemObjects.inc}

interface

uses
  {vcl:} Classes,
  {RemObjects:} uROXMLIntf, uROServer, uROServerIntf, uROTypes, uROClientIntf,
  {Generated:} DataMon_Intf;

type
  TDataService_Invoker = class(TROInvoker)
  private
  protected
  public
    constructor Create; override;
  published
    procedure Invoke_UpdateDataList(const __Instance:IInterface; const __Message:IROMessage; const __Transport:IROTransport; out __oResponseOptions:TROResponseOptions);
    procedure Invoke_UpdateDataStrs(const __Instance:IInterface; const __Message:IROMessage; const __Transport:IROTransport; out __oResponseOptions:TROResponseOptions);
  end;

implementation

uses
  {RemObjects:} uRORes, uROClient;

{ TDataService_Invoker }

constructor TDataService_Invoker.Create;
begin
  inherited Create;
  FAbstract := False;
end;

procedure TDataService_Invoker.Invoke_UpdateDataList(const __Instance:IInterface; const __Message:IROMessage; const __Transport:IROTransport; out __oResponseOptions:TROResponseOptions);
{ function UpdateDataList(const nDataList: DataList): Boolean; }
var
  nDataList: DataMon_Intf.DataList;
  lResult: Boolean;
  __lObjectDisposer: TROObjectDisposer;
begin
  nDataList := nil;
  try
    __Message.Read('nDataList', TypeInfo(DataMon_Intf.DataList), nDataList, []);

    lResult := (__Instance as IDataService).UpdateDataList(nDataList);

    __Message.InitializeResponseMessage(__Transport, 'DataMon', 'DataService', 'UpdateDataListResponse');
    __Message.Write('Result', TypeInfo(Boolean), lResult, []);
    __Message.Finalize;
    __Message.UnsetAttributes(__Transport);

  finally
    __lObjectDisposer := TROObjectDisposer.Create(__Instance);
    try
      __lObjectDisposer.Add(nDataList);
    finally
      __lObjectDisposer.Free();
    end;
  end;
end;

procedure TDataService_Invoker.Invoke_UpdateDataStrs(const __Instance:IInterface; const __Message:IROMessage; const __Transport:IROTransport; out __oResponseOptions:TROResponseOptions);
{ function UpdateDataStrs(const nStr: AnsiString): Boolean; }
var
  nStr: AnsiString;
  lResult: Boolean;
begin
  try
    __Message.Read('nStr', TypeInfo(AnsiString), nStr, []);

    lResult := (__Instance as IDataService).UpdateDataStrs(nStr);

    __Message.InitializeResponseMessage(__Transport, 'DataMon', 'DataService', 'UpdateDataStrsResponse');
    __Message.Write('Result', TypeInfo(Boolean), lResult, []);
    __Message.Finalize;
    __Message.UnsetAttributes(__Transport);

  finally
  end;
end;

initialization
end.