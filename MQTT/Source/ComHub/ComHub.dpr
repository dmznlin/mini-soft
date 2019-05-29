program ComHub;

uses
  Winapi.Windows,
  Vcl.Forms,
  UFormMain in 'UFormMain.pas' {fFormMain},
  Vcl.Themes,
  Vcl.Styles,
  USysConst in 'USysConst.pas';

{$R *.res}
var
  gMutexHwnd: Hwnd;
  //������

begin
  ReportMemoryLeaksOnShutdown := True;
  gMutexHwnd := CreateMutex(nil, True, 'RunSoft_ComHub');
  //����������
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ReleaseMutex(gMutexHwnd);
    CloseHandle(gMutexHwnd); Exit;
  end; //����һ��ʵ��

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;

  ReleaseMutex(gMutexHwnd);
  CloseHandle(gMutexHwnd);
end.
