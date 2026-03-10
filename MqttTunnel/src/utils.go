package main

import (
	"github.com/dmznlin/znlib-go/znlib"
)

// TunnelModal 2026-02-11 16:24:26
/*
 描述: 通道配置示例
*/
func TunnelModal() {
	idAuto := znlib.SerialID.MakeID(7)
	//auto make id

	Tunnel = ConfigTunnel{
		Broker: ConfigBroker{
			URL:        []string{"tcp://broker.hivemq.com:1883"},
			ClientID:   "mt-",
			IDAuto:     7,
			User:       "",
			Password:   "",
			EncryptKey: "",
			Tls: znlib.MqttTLS{
				Used: false,
				CA:   "$path/cert/ca.crt",
				Key:  "$path/cert/mqtt.key",
				Cert: "$path/cert/mqtt.crt",
			},
			TopicCmd: znlib.MqttTopic{
				Qos:   0,
				Topic: "mqttunnel/cmd",
			},
			TopicData: znlib.MqttTopic{
				Qos:   0,
				Topic: "mqttunnel/$id",
			},
		},
		Client: ConfigClient{
			Name: "cli-" + idAuto,
			Desc: "客户端示例",
			Port: 22,
			Hosts: []ServerHost{
				{
					Name: "local",
					Host: "127.0.0.1:22",
				},
			},
		},
		Server: ConfigServer{
			Name: "srv-" + idAuto,
			Desc: "服务器示例",
		},
	}
}
