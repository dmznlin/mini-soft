rem ���������ǽ����
@echo off

netsh advfirewall firewall show rule name=%1 >nul
if not ERRORLEVEL 1 (
    echo �Բ��𣬹����Ѿ�����
) else (
    netsh advfirewall firewall add rule name=%1 protocol=TCP dir=out action=allow description=%2 program=%3
    echo ���򴴽��ɹ�
)