// Package main
/******************************************************************************
  作者: dmzn@163.com 2026-02-27 14:30:26
  描述: 使用 mqtt 通道,传输命令和数据

数据流向:
1.客户端c: XShell -> tcp-server -> mqtt-client
2.服务器s: mqtt-client -> tcp-client -> host/service

客户端发起连接主机: CmdConnHost
1.c -> s: 服务器名, 主机/服务地址(如: 127.0.0.1:80)
2.s -> c: 返回连接结果,正常 或 异常描述
******************************************************************************/
package main

import (
	"crypto/md5"
	"encoding/json"
	"fmt"

	"github.com/dmznlin/znlib-go/znlib"
	"github.com/dmznlin/znlib-go/znlib/mqtt"
	mt "github.com/eclipse/paho.mqtt.golang"
)

// mu mqtt utils
var mu = &mqtt.Utils{
	Client:    nil,
	Options:   mt.NewClientOptions(),
	SubTopics: make(map[string]mqtt.Qos),
	PubTopics: make(map[string]mqtt.Qos),
}

const (
	CmdConnHost   = iota + 5 //客户端: 向服务器发起连接请求
	CmdConnRep               //服务器: 连接结果反馈
	CmdConnBreak             //双向: tcp连接断开
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

// CmdConnBreak 2026-03-05 15:04:46
/*
 描述: tcp.conn断开时,通知对方断开服务
*/
func (mc *MqttCmd) CmdConnBreak() ([]byte, error) {
	mc.Cmd = CmdConnBreak
	mc.Sender = Tunnel.Broker.ClientID

	if Tunnel.isSrv {
		mc.SrvName = Tunnel.Server.Name
	} else {
		mc.SrvName = Tunnel.srvName
	}

	return mc.Marshal()
}

// ------------------------------------------------------------------------------

// ApplyOptions 2026-02-27 20:06:36
/*
 描述: 使用配置信息
*/
func ApplyOptions() error {
	if len(Tunnel.Client.Hosts) < 1 {
		return fmt.Errorf("client.hosts 配置错误: 服务为空")
	}

	if Tunnel.Broker.EncryptKey != "" { // 数据加密 key
		buf, err := znlib.NewEncrypter(znlib.EncryptDesEcb,
			[]byte(znlib.DefaultEncryptKey)).Decrypt([]byte(Tunnel.Broker.EncryptKey), true)
		if err != nil {
			return fmt.Errorf("broker.encrypt 配置错误: 加密无效")
		}
		Tunnel.Broker.EncryptKey = string(buf)
	}

	cfg := znlib.MqttConfig{
		Enable:   true,
		Broker:   Tunnel.Broker.URL,
		ClientID: Tunnel.Broker.ClientID,
		IDAuto:   Tunnel.Broker.IDAuto,
		User:     Tunnel.Broker.User,
		Password: Tunnel.Broker.Password,
		Tls:      Tunnel.Broker.Tls,
		TopicSub: nil,
		TopicPub: nil,
	}

	err := mu.ApplyConfig(&cfg)
	if err != nil {
		return err
	}

	Tunnel.Broker.ClientID = cfg.ClientID
	//同步客户端标识

	Tunnel.Broker.TopicData.Topic = znlib.StrReplace(Tunnel.Broker.TopicData.Topic,
		Tunnel.Broker.ClientID, "$id")
	//更新数据通道标识

	mu.SubTopics[Tunnel.Broker.TopicCmd.Topic] = Tunnel.Broker.TopicCmd.Qos
	//订阅命令通道
	if Tunnel.isSrv {
		Tunnel.topicSnd = Tunnel.Broker.TopicData.Topic + cTunnelDown
		Tunnel.topicRcv = Tunnel.Broker.TopicData.Topic + cTunnelUp
		//向客户端发送数据通道

		mu.SubTopics[Tunnel.topicRcv] = Tunnel.Broker.TopicData.Qos
		//订阅数据通道
	}

	mu.Options.SetDefaultPublishHandler(OnMessage)
	//消息处理句柄
	return nil
}

// OnMessage 2026-02-27 14:48:47
/*
 参数: cli,mqtt
 参数: msg,数据
 描述: 收到来自 cli 的消息
*/
func OnMessage(cli mt.Client, msg mt.Message) {
	caller := "mqttutils.OnMessge"
	defer znlib.DeferHandle(false, caller)
	//捕捉异常

	tp := msg.Topic()
	if tp == Tunnel.topicRcv { //数据传输通道
		TcpUtils.writeData(msg.Payload()) //mqtt to tcp
		return
	}

	if tp != Tunnel.Broker.TopicCmd.Topic { //命令传输通道
		return
	}

	var cmd MqttCmd
	err := cmd.Unmarshal(msg.Payload())
	if err != nil {
		znlib.ErrorCaller(err, caller+".Unmarshal")
		return
	}

	if cmd.Sender == Tunnel.Broker.ClientID { //忽略自己发出的指令
		return
	}

	// ----------------------------------------------------------------------------
	if Tunnel.isSrv { //服务器
		if cmd.SrvName != Tunnel.Server.Name { //接收方不是自己
			return
		}

		switch cmd.Cmd {
		case CmdBeginTrans:
			val := true
			TcpUtils.waiter.Wakeup(&val)
			//唤醒 tcp.cliConn 开始传输数据
		case CmdConnBreak:
			TcpUtils.closeConn()
			//关闭 tpc.conn 数据链路
			znlib.Warn("client disconnected tcp tunnel")
		case CmdConnHost: //连接指定主机
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

			mu.Publish(Tunnel.Broker.TopicCmd.Topic, Tunnel.Broker.TopicCmd.Qos, buf)
			//应答连接结果
		default:
			//do nothing
		}

		return
	}

	// ----------------------------------------------------------------------------
	if cmd.SrvName != Tunnel.srvName { //与请求的服务器名称不匹配
		return
	}

	switch cmd.Cmd {
	case CmdConnBreak:
		TcpUtils.closeConn()
		//关闭 tpc.conn 数据链路
		znlib.Warn("server disconnected tcp tunnel")
	case CmdConnRep:
		suc := cmd.Data == ""
		if !suc { //连接远程主机异常
			znlib.ErrorCaller(cmd.Data, caller+".CmdConnRep")
			TcpUtils.waiter.Wakeup(&suc) //唤醒 tcp.srvConn 继续
			return
		}

		_, ok := mu.SubTopics[cmd.Topic+cTunnelDown]
		if !ok {
			delete(mu.SubTopics, Tunnel.Broker.TopicCmd.Topic)
			//删除命令通道,余下旧的数据通道
			_ = mu.Unsubscribe(mu.Client)
			//退订旧数据通道

			Tunnel.topicSnd = cmd.Topic + cTunnelUp
			Tunnel.topicRcv = cmd.Topic + cTunnelDown
			//同步服务器数据通道

			mu.SubTopics = make(map[string]mqtt.Qos)
			mu.SubTopics[Tunnel.Broker.TopicCmd.Topic] = Tunnel.Broker.TopicCmd.Qos //命令通道
			mu.SubTopics[Tunnel.topicRcv] = Tunnel.Broker.TopicData.Qos             //数据通道

			_ = mu.SubscribeMultiple(mu.Client)
			//订阅数据通道
			znlib.Info(fmt.Sprintf("connected server(%s) on tunnel(%s)", Tunnel.srvName, cmd.Sender))
		}

		cmd = MqttCmd{}
		buf, err := cmd.CmdBeginTrans() //开始传输
		if err != nil {
			znlib.ErrorCaller(err, caller+"OnMessage")
			return
		}

		mu.Publish(Tunnel.Broker.TopicCmd.Topic, Tunnel.Broker.TopicCmd.Qos, buf)
		//通知服务器开始传输

		TcpUtils.waiter.Wakeup(&suc)
		//唤醒 tcp.srvConn 开始传输
	default:
		//do nothing
	}
}
