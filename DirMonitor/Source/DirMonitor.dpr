program DirMonitor;

uses
  FastMM4,
  Windows,
  Vcl.Forms,
  UFormMain in 'UFormMain.pas' {fFormMain},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

var
  gMutexHwnd: Hwnd;
  //互斥句柄

begin
  gMutexHwnd := CreateMutex(nil, True, 'RunSoft_FeiheDirMonitor');
  //创建互斥量
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ReleaseMutex(gMutexHwnd);
    CloseHandle(gMutexHwnd); Exit;
  end; //已有一个实例

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Iceberg Classico');
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.
