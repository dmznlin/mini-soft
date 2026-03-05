// Package main
/******************************************************************************
  作者: dmzn@163.com 2026-02-27 14:30:26
  描述:
******************************************************************************/
package main

import (
	"crypto/md5"
	"crypto/tls"
	"crypto/x509"
	"encoding/json"
	"fmt"
	"os"

	"github.com/dmznlin/znlib-go/znlib"
	mt "github.com/eclipse/paho.mqtt.golang"
)

type mqttUtils struct {
	client    mt.Client
	Options   *mt.ClientOptions
	subTopics map[string]MqttQos
	pubTopics map[string]MqttQos
}

// MqttUtils mqtt tunnel
var MqttUtils = &mqttUtils{
	Options:   mt.NewClientOptions(),
	subTopics: make(map[string]MqttQos),
	pubTopics: make(map[string]MqttQos),
}

const (
	CmdConnHost   = iota + 5 //客户端: 向服务器发起连接请求
	CmdConnRep               //服务器: 连接结果反馈
	CmdBeginTrans            //客户端: 通知服务端开始传输
)

type (
	MqttCmd struct {
		Cmd     byte   `json:"c"`          //命令字
		Sender  string `json:"s"`          //发送方
		SrvName string `json:"n"`          //服务器
		Topic   string `json:"t,omitzero"` //主题
		Data    string `json:"d,omitzero"` //数据
		Verify  string `json:"v,omitzero"` //验证
	}
)

// GetVerify 2024-01-14 15:48:28
/*
 描述: 计算验证信息
*/
func (mc *MqttCmd) GetVerify() (string, error) {
	mc.Verify = Tunnel.Broker.EncryptKey
	data, err := json.Marshal(mc)

	if err != nil {
		return "", err
	}

	mc.Verify = fmt.Sprintf("%x", md5.Sum(data))
	return mc.Verify, nil
}

func (mc *MqttCmd) Marshal() ([]byte, error) {
	if Tunnel.Broker.EncryptKey != "" { //验证命令有效性
		_, err := mc.GetVerify()
		if err != nil {
			return nil, err
		}
	}

	return json.Marshal(mc)
}

func (mc *MqttCmd) Unmarshal(data []byte) error {
	err := json.Unmarshal(data, mc)
	if err != nil {
		return err
	}

	if Tunnel.Broker.EncryptKey != "" { //验证命令有效性
		ver := mc.Verify
		v, err := mc.GetVerify()
		if err != nil {
			return err
		}

		if ver != v {
			return fmt.Errorf("verify mismatch")
		}
	}

	return nil
}

// CmdConnHost 2026-03-01 10:36:53
/*
 参数: host,主机名
 描述: 客户端发起连接请求
*/
func (mc *MqttCmd) CmdConnHost(host string) ([]byte, error) {
	mc.Cmd = CmdConnHost
	mc.Sender = Tunnel.Broker.ClientID
	mc.SrvName = Tunnel.srvName
	mc.Data = ""

	for _, h := range Tunnel.Client.Hosts {
		if h.Name == host {
			mc.Data = h.Host
			break
		}
	}

	if mc.Data == "" {
		return nil, fmt.Errorf("host [%s] not found", host)
	}

	return mc.Marshal()
}

// CmdConnResponse 2026-03-04 11:50:43
/*
 描述: 服务器反馈连接结果
*/
func (mc *MqttCmd) CmdConnResponse() ([]byte, error) {
	mc.Cmd = CmdConnRep
	mc.Sender = Tunnel.Broker.ClientID
	mc.SrvName = Tunnel.Server.Name
	mc.Topic = Tunnel.Broker.TopicData.Topic

	//mc.Data = ""
	//若连接异常,由外部填写内容
	return mc.Marshal()
}

// CmdBeginTrans 2026-03-04 16:14:50
/*
 描述: 客户端发起传输请求
*/
func (mc *MqttCmd) CmdBeginTrans() ([]byte, error) {
	mc.Cmd = CmdBeginTrans
	mc.Sender = Tunnel.Broker.ClientID
	mc.SrvName = Tunnel.srvName

	return mc.Marshal()
}

// ------------------------------------------------------------------------------

// ApplyOptions 2026-02-27 20:06:36
/*
 描述: 使用配置信息
*/
func (mc *mqttUtils) ApplyOptions() error {
	if Tunnel.Broker.Tls.Used {
		rootCA, err := os.ReadFile(Tunnel.Broker.Tls.CA)
		if err != nil {
			return fmt.Errorf("broker.Tls.ca 配置错误: %w", err)
		}

		cp := x509.NewCertPool()
		if !cp.AppendCertsFromPEM(rootCA) {
			return fmt.Errorf("broker.Tls.ca 配置错误: 无法加载")
		}

		cert, err := tls.LoadX509KeyPair(Tunnel.Broker.Tls.Cert, Tunnel.Broker.Tls.Key)
		if err != nil {
			return fmt.Errorf("broker.Tls.ca 配置错误: %w", err)
		}

		mc.Options.SetTLSConfig(&tls.Config{
			RootCAs:            cp,
			ClientAuth:         tls.NoClientCert,
			ClientCAs:          nil,
			InsecureSkipVerify: true,
			Certificates:       []tls.Certificate{cert},
		})
	}

	mc.Options.SetClientID(Tunnel.Broker.ClientID)
	//更新 client id

	if Tunnel.Broker.User != "" {
		mc.Options.SetUsername(Tunnel.Broker.User)
		//user-name
	}

	if Tunnel.Broker.Password != "" {
		mc.Options.SetPassword(Tunnel.Broker.Password)
		//user-password
	}

	for _, v := range Tunnel.Broker.URL { //多服务器支持
		mc.Options.AddBroker(v)
	}

	mc.subTopics[Tunnel.Broker.TopicCmd.Topic] = Tunnel.Broker.TopicCmd.Qos
	//订阅命令通道
	if Tunnel.isSrv {
		mc.subTopics[Tunnel.Broker.TopicData.Topic+cTunnelUp] = Tunnel.Broker.TopicData.Qos
		//订阅数据通道
	}

	// ----------------------------------------------------------------------------
	mc.Options.SetOnConnectHandler(func(client mt.Client) {
		var host string
		for _, v := range mc.Options.Servers {
			if host == "" {
				host = v.String()
			} else {
				host = host + "," + v.String()
			}
		}

		znlib.Info("mqtt.connected: " + host)
		_ = mc.subscribeMultiple(client)
		//连接成功后,重新订阅主题
	})

	mc.Options.SetConnectionLostHandler(func(client mt.Client, err error) {
		znlib.ErrorCaller(err, "mqtt.lostconnect")
		//log
	})

	mc.Options.SetReconnectingHandler(func(client mt.Client, options *mt.ClientOptions) {
		znlib.Info("mqtt.reconnect_broker.")
		//log
	})

	mc.Options.SetDefaultPublishHandler(mc.OnMessage)
	//消息处理句柄
	return nil
}

// Start 2026-02-27 14:33:47
/*
 参数: msgHandler,
 对象: MqttUtils
 描述:
*/
func (mc *mqttUtils) Start() error {
	if mc.client != nil {
		return nil
	}

	mc.client = mt.NewClient(mc.Options)
	//创建链路
	token := mc.client.Connect()
	//连接 broker

	if token.Wait() && token.Error() != nil {
		znlib.ErrorCaller(token.Error(), "mqtt.connect_broker")
	}

	return token.Error()
}

// Stop 2024-01-14 15:23:20
/*
 描述: 停止mqtt服务
*/
func (mc *mqttUtils) Stop() {
	if mc.client == nil {
		return
	}

	mc.unsubscribe(mc.client)
	//退订主题
	mc.client.Disconnect(500)
	//断开链路
	mc.client = nil
}

// Publish 2026-02-27 14:43:07
/*
 参数: topic,主题
 参数: qos,送达级别
 参数: msg,消息
 描述: 向topic发布msg消息
*/
func (mc *mqttUtils) Publish(topic string, qos MqttQos, msg []byte) {
	pub := func() {
		token := mc.client.Publish(topic, qos, false, msg)
		if token.Wait() && token.Error() != nil {
			znlib.ErrorCaller(token.Error(), "mqtt.publish")
		}
	}

	if topic == "" { //
		var q MqttQos
		useCfg := qos == MqttQosNone
		//使用配置 qos

		for topic, q = range mc.pubTopics {
			if useCfg {
				qos = q
			}

			pub()
		}
	} else {
		if qos == MqttQosNone {
			q, ok := mc.pubTopics[topic]
			if ok {
				qos = q
			} else {
				qos = MqttQos0
			}
		}

		pub()
		//自定义主题
	}
}

// subscribeMultiple 2026-02-27 14:40:55
/*
 参数: client,链路
 描述: 订阅主题列表
*/
func (mc *mqttUtils) subscribeMultiple(client mt.Client) error {
	if len(mc.subTopics) < 1 {
		return nil
	}

	token := client.SubscribeMultiple(mc.subTopics, nil)
	if token.Wait() && token.Error() == nil {
		znlib.Info(fmt.Sprintf("mqtt.subscribe: %+v", mc.subTopics))
	} else {
		znlib.ErrorCaller(token.Error(), "mqtt.subscribe")
	}

	return token.Error()
}

// unsubscribe 2026-03-03 11:30:37
/*
 参数: client,链路
 描述: 退订所有主题
*/
func (mc *mqttUtils) unsubscribe(client mt.Client) error {
	idx := len(mc.subTopics)
	if idx > 0 && client.IsConnected() { //退订所有主题
		topics := make([]string, idx)
		idx = 0
		for k := range mc.subTopics {
			topics[idx] = k
			idx++
		}

		token := client.Unsubscribe(topics...)
		token.Wait()
		if token.Error() != nil {
			znlib.ErrorCaller(token.Error(), "mqtt.unsubscribe")
			return token.Error()
		}

		znlib.Info(fmt.Sprintf("mqtt.unsubscribe: %v", topics))
	}

	return nil
}

// OnMessage 2026-02-27 14:48:47
/*
 参数: cli,mqtt
 参数: msg,数据
 描述: 收到来自 cli 的消息
*/
func (mc *mqttUtils) OnMessage(cli mt.Client, msg mt.Message) {
	caller := "mqttutils.OnMessge"
	defer znlib.DeferHandle(false, caller)
	//捕捉异常

	if msg.Topic() == Tunnel.Broker.TopicCmd.Topic { //命令传输通道
		var cmd MqttCmd
		err := cmd.Unmarshal(msg.Payload())
		if err != nil {
			znlib.ErrorCaller(err, caller+".Unmarshal")
			return
		}

		if cmd.Sender == Tunnel.Broker.ClientID { //忽略自己发出的指令
			return
		}

		if Tunnel.isSrv { //服务器
			if cmd.SrvName != Tunnel.Server.Name { //接收方不是自己
				return
			}

			if cmd.Cmd == CmdConnHost { //连接指定主机
				Tunnel.srvHost = cmd.Data
				//待连接主机地址

				err = TcpUtils.start()
				if err == nil {
					cmd.Data = ""
				} else {
					cmd.Data = err.Error()
				}

				buf, err := cmd.CmdConnResponse()
				if err != nil {
					znlib.ErrorCaller(err, caller+".CmdConnResponse")
					return
				}

				mc.Publish(Tunnel.Broker.TopicCmd.Topic, Tunnel.Broker.TopicCmd.Qos, buf)
				//应答
			}

			if cmd.Cmd == CmdBeginTrans {
				TcpUtils.waiter.Wakeup(nil)
				//唤醒数据通道
			}
		} else {
			if cmd.Cmd == CmdConnRep {
				if cmd.SrvName != Tunnel.srvName { //与请求的服务器名称不匹配
					return
				}

				suc := cmd.Data == ""
				if !suc { //连接远程主机异常
					znlib.ErrorCaller(err, caller+".CmdConnRep")
					TcpUtils.waiter.Wakeup(&suc) //唤醒 tcp.srvConn 继续
					return
				}

				_, ok := mc.subTopics[cmd.Topic]
				if !ok {
					delete(mc.subTopics, Tunnel.Broker.TopicCmd.Topic)
					mc.unsubscribe(mc.client)
					//退订旧数据通道

					mc.subTopics = make(map[string]MqttQos)
					mc.subTopics[Tunnel.Broker.TopicCmd.Topic] = Tunnel.Broker.TopicCmd.Qos //命令通道
					mc.subTopics[cmd.Topic+cTunnelDown] = Tunnel.Broker.TopicData.Qos       //数据通道

					mc.subscribeMultiple(mc.client)
					Tunnel.Broker.TopicData.Topic = cmd.Topic
					//订阅数据通道

					cmd = MqttCmd{}
					buf, err := cmd.CmdBeginTrans() //开始传输
					if err != nil {
						znlib.ErrorCaller(err, caller+"OnMessage")
						return
					}

					mc.Publish(Tunnel.Broker.TopicCmd.Topic, Tunnel.Broker.TopicCmd.Qos, buf)
					//应答
					znlib.Info(fmt.Sprintf("connected server(%s) on tunnel(%s)", Tunnel.srvName, cmd.Sender))
				}
			}
		}
	} else {
		TcpUtils.writeData(msg.Payload())
		//数据传输通道
	}
}
