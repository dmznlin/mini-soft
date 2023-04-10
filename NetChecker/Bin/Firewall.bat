rem 批处理防火墙规则
@echo off

netsh advfirewall firewall show rule name=%1 >nul
if not ERRORLEVEL 1 (
    echo 对不起，规则已经存在
) else (
    netsh advfirewall firewall add rule name=%1 protocol=TCP dir=out action=allow description=%2 program=%3
    echo 规则创建成功
)