{*******************************************************************************
  作者: dmzn@163.com 2009-6-25
  描述: 单元模块

  备注: 由于模块有自注册能力,只要Uses一下即可.
*******************************************************************************}
unit USysModule;

{$I Link.Inc}

interface

uses
  {$IFDEF MultiJS}
  UFormZTParam_M, UFormJS_M,
  {$ELSE}
  UFormZTParam, UFormJS,
  {$ENDIF}
  UFrameLog, UFrameSysLog, UFormIncInfo, UFormPassword,
  UFrameStockType, UFormStockType, UFrameTruckInfo, UFormTruckInfo,
  UFrameJSLog, UFrameCustomer, UFormCustomer, UFormBackupAccess,
  UFormRestoreAccess, UFrameJSItem, UFormJSItem;

implementation

end.
