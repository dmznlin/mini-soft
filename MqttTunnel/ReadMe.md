**MqttTunnel**<br>
MqttTunnel：基于mqtt协议的内网穿透服务。通过公网免费的 mqtt broker，如：[mqtt](http://mqtt-dashboard.com) 或 [emqx](http://emqx.com/zh/mqtt/public-mqtt5-broker)，实现从内网管理远程内网主机的目的。

特性如下：<br>
1、支持 TCP、TcpTls、WebSocket、WSS 多种接入协议。<br>
2、支持单个 broker 或 broker 集群。<br>
3、支持单个 tunnel-client 连接 tunnel-server 所在内网的所有主机。<br>
4、支持传输过程中数据的压缩和加密。<br>
5、支持 x86-64/arm 直接部署，或 docker/集群 部署。<br>

**一、原理**<br>
以 XShell 连接内网主机`host-a`为例:<br>
**内网**: xshell &ensp;→&ensp; tunnel-client(端口: 22)<br>
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;↓<br>
**公网**:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; mqtt broker<br>
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;↓<br>
**内网**: host-a(端口: 22) &ensp;←&ensp; tunnel-server

**二、参数**<br>
服务器: `tunnel.exe -role srv` <br>
客户端: `tunnel.exe -role cli -srv 服务名 -host 主机名` **简化**: `tunnel.exe -role cli`<br>
加&emsp;密: `tunnel.exe -pass 明文` <br>
帮&emsp;助: `tunnel.exe -help`

**三、部署**<br>
1、运行 `tunnel.exe`， 生成默认的配置文件。<br>
2、按需要修改配置参数。<br>
3、启动服务器和客户端，xshell正常连接 客户端。

**三、安全**<br>
1、使用 `tunnel.exe -pass` 生成秘钥，填写在 `broker.encrypt` 处。客户端、服务器秘钥相同才能通讯。<br>
2、修改 `broker.tpCmd.topic` 命令通道名称，避免与其它使用默认配置的用户共用。<br>
3、修改 `server.name` 为特殊内容，客户端需要准确的服务器名称才能连接。<br>