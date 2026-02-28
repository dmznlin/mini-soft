**一、支持协议**

| 协议         | 格式                       | 描述             |
|------------|--------------------------|----------------|
| RTU        | rtu://com1               | 232/485传输rtu协议 |
| RTUOverTCP | rtuovertcp://localhost   | tcp传输rtu协议     |
| RTUOverUDP | rtuoverudp://localhost   | udp传输rtu协议     |
| TCP        | tcp://localhost          | tcp远程从站        |
| TcpTls     | tcp+tls://localhost      | tcp双向认证的远程从站   |
| UDP        | udp://localhost          | udp协议从站        |
| UserMem    | mem://localhost          | 内存虚拟从站         |
| UserHttp   | http://localhost/getmod  | http远程从站       |
| UserHttps  | https://localhost/setmod | http双向认证的远程从粘  |

**二、配置信息**

配置文件为 `slavers.json`

| 参数                | 示例                 | 描述                                        |
|-------------------|--------------------|-------------------------------------------|
| local.server      | tcp://:5502        | 5502端口提供服务                                |
| local.timeout     | 30                 | 连接空闲30秒后断开                                |
| local.maxconn     | 5                  | 同时可连接5个主站                                 |
| local.maxquantity | 255                | 内存虚拟站数据上限                                 |
| links.url         | rtu:///dev/ttyUSB0 | 使用usb转232设备                               |
| links.baudRate    | 9600               | 波特率                                       |
| links.dataBits    | 8                  | 数据位                                       |
| links.parity      | 0                  | 校验位:NONE 0,EVEN 1,ODD 2                   |
| links.stopBits    | 1                  | 停止位                                       |
| links.certFile    | ""                 | 客户端公钥                                     |
| links.keyFile     | ""                 | 客户端私钥                                     |
| links.caFile      | ""                 | CA公钥                                      |
| links.serverDNS   | ""                 | https验证服务器域名                              |
| links.timeout     | 300                | 数据读写超时，单位毫秒                               |
| slavers.unit      | 1                  | 从站unit-id,不能重复                            |
| slavers.link      | link-com           | 从站通道名称,可共享通道(如485)                        |
| slavers.endianess | 1                  | word大小端: BIG_ENDIAN 1,LITTLE_ENDIAN 2     |
| slavers.wordOrder | 1                  | int高低位:HIGH_WORD_FIRST 1,LOW_WORD_FIRST 2 |
| slavers.addrs     | []                 | 内存虚拟站地址位                                  |

**三、开发说明**

`UserHttp/UserHttps`可以与远程 web 服务器通讯，细节如下：

| 名称      | 类型          | 描述         |
|---------|-------------|------------|
| HTTP.请求 | get         | 仅支持 get 方式 |
| 参数.操作   | act,uint8   | 读取 1,写入 2  |
| 参数.从站ID | id,uint8    | 从站编号       |
| 参数.数据类型 | type,uint8  | 线圈 1,存储器 2 |
| 参数.数据地址 | addr,uint16 |            |
| 参数.数据长度 | len,uint8   |            |
| 参数.大小端  | end,uint8   | 大端 1,小端 2  |
| 参数.数据   | data,text   | base编码     |

**发起**：读取(act=1)从站1(id=1)的存储器(type=2)数据,从地址2(addr=2)读取5(len=5)个寄存器:<br>
http://127.0.0.1/modbus?act=1&id=1&type=2&addr=2&len=5&end=1 <br>
**返回**：5个word值的base64编码