// Package main
/******************************************************************************
  作者: dmzn@163.com 2026-02-27 10:42:17
  描述: 常量定义
******************************************************************************/
package main

import "github.com/dmznlin/znlib-go/znlib"

const (
	cTagUpdateHost = "%#$+123abc=>"      //更新主机配置数据标识
	cTagLen        = len(cTagUpdateHost) //标识长度
	cTagEnd        = '#'                 //更新主机配置结束符

	cTunnelUp   = "/up" //客户端上行数据通道
	cTunnelDown = "/dn" //服务器下行数据通道
)

type (
	BrokerItem struct {
		Used     bool          `json:"used"`   //是否启用
		Name     string        `json:"name"`   //服务器名称
		URL      []string      `json:"url"`    //服务器(集群),多地址逗号分割
		ClientID string        `json:"client"` //客户端标识
		IDAuto   int           `json:"auto"`   //以ClientID为前缀,自动增加n位随机id
		User     string        `json:"user"`   //用户名
		Password string        `json:"pwd"`    //登录密码(des)
		Tls      znlib.MqttTLS `json:"tls"`    //接入认证
	}

	ConfigBroker struct {
		clientID   string //生效的客户端标识
		topicValid string //生效的数据通道
		topicSnd   string //发送数据通道
		topicRcv   string //接收数据通道

		reConn    int    //重新连接计数
		reSwitch  bool   //切换服务器标识
		activeSrv string //当前服务器名称

		EncryptKey string          `json:"encrypt"` //命令加密密钥(des)
		TopicCmd   znlib.MqttTopic `json:"tpCmd"`   //命令传输通道
		TopicData  znlib.MqttTopic `json:"tpData"`  //数据传输通道
		Servers    []*BrokerItem   `json:"servers"` //服务器列表
	}

	// ServerHost 服务器可以连接的主机
	ServerHost = struct {
		Name string `json:"name"` //主机或服务名
		Host string `json:"host"` //IP+Port
	}

	ConfigServer struct {
		Name string `json:"name"` //服务器名称
		Desc string `json:"desc"` //服务器描述信息
	}

	ConfigClient struct {
		Name  string       `json:"name"`  //客户端名称
		Desc  string       `json:"desc"`  //客户端描述信息
		Port  int          `json:"port"`  //服务监听端口
		Hosts []ServerHost `json:"hosts"` //可用主机列表
	}

	ConfigTunnel struct {
		isSrv    bool   //是否服务器
		receiver string //接收方标识
		srvName  string //服务名称
		srvHost  string //主机名称

		lastStamp map[byte]int64
		//反DDOS机制:指令的最后时间戳

		Server ConfigServer `json:"server"` //server
		Client ConfigClient `json:"client"` //client
		Broker ConfigBroker `json:"broker"` //broker
	}
)

// Tunnel 通道配置
var Tunnel ConfigTunnel
