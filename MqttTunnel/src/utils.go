package main

import (
	"fmt"
	"time"

	"github.com/dmznlin/znlib-go/znlib"
	"github.com/dmznlin/znlib-go/znlib/mqtt"
)

func DurationToTime(duration time.Duration) time.Time {
	epochTime := time.Date(1970, time.January, 1, 0, 0, 0, 0, time.UTC)
	// Unix 纪元基准时间（UTC 1970-01-01 00:00:00）
	return epochTime.Add(duration).Local()
}

func TimeToDuration(t1 time.Time) time.Duration {
	epochTime := time.Date(1970, time.January, 1, 0, 0, 0, 0, time.UTC)
	// Unix 纪元基准时间（UTC 1970-01-01 00:00:00）
	return t1.In(time.UTC).Sub(epochTime)
}

// TunnelModal 2026-02-11 16:24:26
/*
 描述: 通道配置示例
*/
func TunnelModal() {
	idAuto := znlib.SerialID.MakeID(7)
	//auto make id

	Tunnel = ConfigTunnel{
		Server: ConfigServer{
			Name: "srv-" + idAuto,
			Desc: "服务器示例",
		},
		Client: ConfigClient{
			Name: "cli-" + idAuto,
			Desc: "客户端示例",
			Port: 8022,
			Hosts: []ServerHost{
				{
					Name: "local",
					Host: "127.0.0.1:22",
				},
			},
		},
		Broker: ConfigBroker{
			EncryptKey: "",
			TopicCmd: znlib.MqttTopic{
				Qos:   0,
				Topic: "mqttunnel/cmd",
			},
			TopicData: znlib.MqttTopic{
				Qos:   0,
				Topic: "mqttunnel/$id",
			},
			Servers: []*BrokerItem{
				{
					Used:     true,
					Name:     "runsoft",
					URL:      []string{"mqtt://bbs.runsoft.online:43222"},
					ClientID: "mt-",
					IDAuto:   7,
					User:     "mqttunnel",
					Password: "tFtZ9fpBJhU+dBEaZ8D5Pw==",
					Tls:      znlib.MqttTLS{},
				},
				{
					Used:     true,
					Name:     "hivemq",
					URL:      []string{"tcp://broker.hivemq.com:1883"},
					ClientID: "mt-",
					IDAuto:   7,
					User:     "",
					Password: "",
					Tls: znlib.MqttTLS{
						Used: false,
						CA:   "$path/cert/ca.crt",
						Key:  "$path/cert/mqtt.key",
						Cert: "$path/cert/mqtt.crt",
					},
				},
			},
		},
	}
}

// verifyConfig 2026-03-29 11:52:29
/*
 描述: 验证配置信息的有效性
*/
func verifyConfig() error {
	if len(Tunnel.Client.Hosts) < 1 {
		return fmt.Errorf("client.hosts: 主机列表为空")
	}

	if len(Tunnel.Broker.Servers) < 1 {
		return fmt.Errorf("broker.servers: 服务器列表为空")
	}

	dk := func(tag, ek string) (string, error) {
		buf, err := znlib.NewEncrypter(znlib.EncryptDesEcb,
			[]byte(znlib.DefaultEncryptKey)).Decrypt([]byte(ek), true)
		if err != nil {
			return "", fmt.Errorf("%s: 加密无效", tag)
		}

		return string(buf), nil
	}

	if Tunnel.Broker.EncryptKey != "" { // 数据加密 key
		key, err := dk("broker.encrypt", Tunnel.Broker.EncryptKey)
		if err != nil {
			return err
		}

		Tunnel.Broker.EncryptKey = key
	}

	mqtt.Client.KeyEncrypted = false
	//使用明文

	for idx, srv := range Tunnel.Broker.Servers {
		if srv.Password != "" {
			key, err := dk(fmt.Sprintf("broker.servers[%s].pwd", srv.Name), srv.Password)
			if err != nil {
				return err
			}

			Tunnel.Broker.Servers[idx].Password = key
			//登录密码
		}
	}

	return nil
}
