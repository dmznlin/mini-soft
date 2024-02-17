**AnySSH客户端**部署说明文档

*.名词约定:\
**被控端**: 一台启用了**ssh服务**的内网主机\
**客户端**: client.exe 所在目录中的所有文件.

部署前提:
>客户端和服务端连接到同一个**mqtt broker**.

部署方法: 修改 config.xml
> 1. des密码: 可以使用 `server.exe --pass` 获得
> 2. mqtt.clientID不能重复,如果使用公共broker,与其他用户的clientID重复会导致频繁断线.
> 3. mqtt.utils.encryptKey: 为保证安全,设定自己的加密密钥.同时设定verifyMsg=true
> 4. mqttSSH.enable=false,但需要与服务端的 mqttSSH.mqtt参数保持一致.

启动客户端后,自动打开浏览器,地址为: http://127.0.0.1:50266/?remote=anyssh_server_01 \
其中: 端口为自动选择,修改remote的值切换连接哪个服务端.