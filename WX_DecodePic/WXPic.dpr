program WXPic;

uses
  Winapi.Windows,
  Vcl.Forms,
  UFormMain in 'UFormMain.pas' {fFormMain},
  UWXFun in 'UWXFun.pas';

{$R *.res}

var
  gMutexHwnd: Hwnd;
  //互斥句柄

begin
  gMutexHwnd := CreateMutex(nil, True, 'RunSoft_QL_SpeedMon');
  //创建互斥量
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ReleaseMutex(gMutexHwnd);
    CloseHandle(gMutexHwnd); Exit;
  end; //已有一个实例

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '微信图片解码';
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;

  ReleaseMutex(gMutexHwnd);
  CloseHandle(gMutexHwnd);
end.
