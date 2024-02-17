:: 进入当前目录
cd %~dp0

:: 编译
go build -ldflags "-s -w" -o ./bin/server/server.exe ./src/server
go build -ldflags "-s -w" -o ./bin/client/client.exe ./src/client

:: 压缩
upx.exe ./bin/server/server.exe
upx.exe ./bin/client/client.exe