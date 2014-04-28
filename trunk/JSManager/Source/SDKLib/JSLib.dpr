{*******************************************************************************
  作者: dmzn@163.com 2014-04-27
  描述: 网络版多道计数器接口
*******************************************************************************}
library JSLib;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  FastMM4,
  Windows,
  SysUtils,
  Classes,
  UNetCounter in 'UNetCounter.pas';

{$R *.res}

exports
  JSStatus, JSStop, JSStart, JSServiceStop, JSServiceStart, JSLoadConfig;

begin
  DLLProc := @LibraryEntity;
  LibraryEntity(DLL_PROCESS_ATTACH);
end.
