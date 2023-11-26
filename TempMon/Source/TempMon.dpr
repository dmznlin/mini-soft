program TempMon;

uses
  FastMM4,
  Vcl.Forms,
  Winapi.Windows,
  UFormMain in 'UFormMain.pas' {fFormMain},
  UQingTian in 'UQingTian.pas',
  USysConst in 'USysConst.pas';

{$R *.res}

var
  gMutexHwnd: Hwnd;
  //互斥句柄

begin
  gMutexHwnd := CreateMutex(nil, True, 'RunSoft_XE_TempMon');
  //创建互斥量
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ReleaseMutex(gMutexHwnd);
    CloseHandle(gMutexHwnd); Exit;
  end; //已有一个实例

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.
