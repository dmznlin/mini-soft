package main

import (
	"encoding/json"
	"fmt"
	"os"

	"github.com/dmznlin/znlib-go/znlib"
)

//-------------------------------------------------------------------------------

// makeID 2026-03-01 11:50:39
/*
 参数: idLen,标识长度
 描述: 生成长度为 idLen 的标识
*/
func makeID(idLen int) string {
	suffix := znlib.SerialID.TimeID(true) //后缀
	idx := len(suffix)
	if idx > idLen {
		idx = idx - idLen
		idLen = idx + idLen
	} else {
		idLen = idx
		idx = 0
	}

	return suffix[idx:idLen]
}

// LoadTunnel 2026-01-26 17:49:30
/*
 参数: cfg, 配置文件
 描述: 载入通道配置信息
*/
func LoadTunnel(cfg string) error {
	df, err := os.ReadFile(cfg)
	if err != nil {
		return fmt.Errorf("读取配置失败: %w", err)
	}

	if err = json.Unmarshal(df, &Tunnel); err != nil {
		return fmt.Errorf("解析配置失败: %w", err)
	}

	if len(Tunnel.Client.Hosts) < 1 {
		return fmt.Errorf("client.hosts 配置错误: 服务为空")
	}

	if Tunnel.Broker.Tls.Used {
		Tunnel.Broker.Tls.CA = znlib.FixPathVar(Tunnel.Broker.Tls.CA)
		if !znlib.FileExists(Tunnel.Broker.Tls.CA, false) {
			return fmt.Errorf("broker.Tls.ca 配置错误: 文件丢失")
		}

		Tunnel.Broker.Tls.Key = znlib.FixPathVar(Tunnel.Broker.Tls.Key)
		if !znlib.FileExists(Tunnel.Broker.Tls.Key, false) {
			return fmt.Errorf("broker.Tls.key 配置错误: 文件丢失")
		}

		Tunnel.Broker.Tls.Cert = znlib.FixPathVar(Tunnel.Broker.Tls.Cert)
		if !znlib.FileExists(Tunnel.Broker.Tls.Cert, false) {
			return fmt.Errorf("broker.Tls.cert 配置错误: 文件丢失")
		}
	}

	if Tunnel.Broker.Password != "" { // broker 密码
		buf, err := znlib.NewEncrypter(znlib.EncryptDES_ECB,
			[]byte(znlib.DefaultEncryptKey)).Decrypt([]byte(Tunnel.Broker.Password), true)
		if err != nil {
			return fmt.Errorf("broker.pwd 配置错误: 加密无效")
		}
		Tunnel.Broker.Password = string(buf)
	}

	if Tunnel.Broker.EncryptKey != "" { // 数据加密 key
		buf, err := znlib.NewEncrypter(znlib.EncryptDES_ECB,
			[]byte(znlib.DefaultEncryptKey)).Decrypt([]byte(Tunnel.Broker.EncryptKey), true)
		if err != nil {
			return fmt.Errorf("broker.encrypt 配置错误: 加密无效")
		}
		Tunnel.Broker.EncryptKey = string(buf)
	}

	if Tunnel.Broker.IDAuto > 0 { //自动生成 client-id
		idLen := 23 - len(Tunnel.Broker.ClientID) //mqtt id长度限制
		if Tunnel.Broker.IDAuto > idLen {         //取最大可用长度
			Tunnel.Broker.IDAuto = idLen
		}

		//new id
		Tunnel.Broker.ClientID = Tunnel.Broker.ClientID + makeID(Tunnel.Broker.IDAuto)
	}

	Tunnel.Broker.TopicData.Topic = znlib.StrReplace(Tunnel.Broker.TopicData.Topic,
		Tunnel.Broker.ClientID, "$id")
	//更新数据通道标识

	return nil
}

// SaveTunnel 2026-01-26 17:49:53
/*
 参数: cfg, 配置文件
 描述: 保存通道信息到cfg中
*/
func SaveTunnel(cfg string) error {
	dt, err := json.MarshalIndent(&Tunnel, "", "  ")
	if err != nil {
		return fmt.Errorf("打包JSON失败: %w", err)
	}

	if err := os.WriteFile(cfg, dt, 0644); err != nil {
		return fmt.Errorf("保存配置失败: %w", err)
	}

	return nil
}

// TunnelModal 2026-02-11 16:24:26
/*
 描述: 通道配置示例
*/
func TunnelModal() {
	idAuto := makeID(7)

	Tunnel = ConfigTunnel{
		Broker: ConfigBroker{
			URL:        []string{"tcp://broker.hivemq.com:1883"},
			ClientID:   "mt-",
			IDAuto:     7,
			User:       "",
			Password:   "",
			EncryptKey: "",
			Tls: MqttTLS{
				Used: false,
				CA:   "$path/cert/ca.crt",
				Key:  "$path/cert/mqtt.key",
				Cert: "$path/cert/mqtt.crt",
			},
			TopicCmd: MqttTopic{
				ID:    0,
				Qos:   0,
				Topic: "mqttunnel/cmd",
			},
			TopicData: MqttTopic{
				ID:    0,
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
