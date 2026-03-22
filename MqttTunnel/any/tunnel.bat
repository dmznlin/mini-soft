
cd %~dp0..\src
go build -ldflags="-s -w" -o ..\bin\tunnel.exe .