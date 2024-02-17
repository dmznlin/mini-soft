**AnySSH服务端**部署说明文档

*.名词约定:\
**被控端**: 一台启用了**ssh服务**的内网主机\
**服务端**: server.exe 所在目录中的所有文件.

部署前提:
>服务端 和 被控端 在**同一系统**内,或**同一网络**,或可以访问到被控端的网络.

部署方法: 修改 config.xml
> 1. des密码: 可以使用 `server.exe --pass` 获得
> 2. mqtt.clientID不能重复,如果使用公共broker,与其他用户的clientID重复会导致频繁断线.
> 3. mqtt.utils.encryptKey: 为保证安全,设定自己的加密密钥.同时设定verifyMsg=true
> 4. mqttSSH.auth: 填写被控端的ssh参数.
> 5. mqttSSH.command: 如果使用公共broker,修改指定代码可避免一部分冲突,最大值255