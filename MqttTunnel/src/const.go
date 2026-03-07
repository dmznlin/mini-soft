// Package main
/******************************************************************************
  作者: dmzn@163.com 2026-02-27 10:42:17
  描述: 常量定义
******************************************************************************/
package main

const (
	cTagUpdateHost = "^+%-123454321=>"   //更新主机配置数据标识
	cTagLen        = len(cTagUpdateHost) //标识长度

	cTunnelUp   = "/up" //客户端上行数据通道
	cTunnelDown = "/dn" //服务器下行数据通道
)

type (
	// MqttQos qos定义
	MqttQos = byte
)

const (
	/*
		QoS 0：低延迟、高吞吐，适合丢包可容忍的实时数据流。
		QoS 1：平衡可靠性与性能，需业务层去重。
		QoS 2：最高可靠性，适合不可重复执行的关键指令
	*/

	MqttQos0    MqttQos = 0  //最多交付一次
	MqttQos1    MqttQos = 1  //至少交付一次
	MqttQos2    MqttQos = 2  //只交付一次
	MqttQosNone MqttQos = 27 //使用配置文件中的 qos
)

type (
	MqttTopic = struct {
		ID    uint16  `json:"id"`    //编号
		Qos   MqttQos `json:"qos"`   //控制
		Topic string  `json:"topic"` //主题
	}

	MqttTLS = struct {
		Used bool   `json:"use"`  //启用 tls
		CA   string `json:"ca"`   //ca 证书
		Key  string `json:"key"`  //客户端秘钥
		Cert string `json:"cert"` //客户端证书
	}

	ConfigBroker struct {
		URL        []string  `json:"URL"`     //服务器(集群),多地址逗号分割
		ClientID   string    `json:"client"`  //客户端标识
		IDAuto     int       `json:"auto"`    //以ClientID为前缀,自动增加n位随机id
		User       string    `json:"user"`    //用户名
		Password   string    `json:"pwd"`     //登录密码(des)
		Tls        MqttTLS   `json:"tls"`     //接入认证
		EncryptKey string    `json:"encrypt"` //命令加密密钥(des)
		TopicCmd   MqttTopic `json:"tpCmd"`   //命令传输通道
		TopicData  MqttTopic `json:"tpData"`  //数据传输通道
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
		srvName  string //服务名称
		srvHost  string //主机名称
		topicSnd string //发送数据通道
		topicRcv string //接收数据通道

		Server ConfigServer `json:"server"` //server
		Client ConfigClient `json:"client"` //client
		Broker ConfigBroker `json:"broker"` //broker
	}
)

// Tunnel 通道配置
var Tunnel ConfigTunnel
