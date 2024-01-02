:: 进入当前目录
cd %~dp0

:: 编译
go build -ldflags "-s -w" -o ./bin/fh_cli.exe ./src

:: 压缩
upx.exe ./bin/fh_cli.exe