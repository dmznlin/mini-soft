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
	"time"

	"github.com/dmznlin/znlib-go/znlib"
	"github.com/dmznlin/znlib-go/znlib/mqtt"
	mt "github.com/eclipse/paho.mqtt.golang"
)

const (
	CmdPing        = iota     //查找服务器
	CmdHintMessage            //双向:发送提示消息
	CmdConnHost    = iota + 5 //客户端: 向服务器发起连接请求
	CmdConnRep                //服务器: 连接结果反馈
	CmdConnBreak              //双向: tcp连接断开
	CmdBeginTrans             //客户端: 通知服务端开始传输
)

type (
	MqttCmd struct {
		Cmd      byte   `json:"c"` //命令字
		Stamp    int64  `json:"p"` //流水号
		Sender   string `json:"s"` //发送方
		Receiver string `json:"r"` //接收方

		Param  string `json:"m,omitzero"` //参数
		Data   string `json:"d,omitzero"` //数据
		Verify string `json:"v,omitzero"` //验证
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

// CmdInit 2026-03-20 19:45:33
/*
 描述: 填充基础信息
*/
func (mc *MqttCmd) CmdInit(cmd byte) {
	mc.Cmd = cmd
	mc.Stamp = time.Now().Unix()
	mc.Sender = Tunnel.Broker.clientID

	if cmd == CmdConnHost { //不知道对方标识前填写名称
		mc.Receiver = Tunnel.srvName
	} else {
		mc.Receiver = Tunnel.receiver
	}
}

// CmdConnHost 2026-03-01 10:36:53
/*
 参数: host,主机名
 描述: 客户端发起连接请求
*/
func (mc *MqttCmd) CmdConnHost(host, caller string) error {
	mc.CmdInit(CmdConnHost)
	mc.Data = ""

	for _, h := range Tunnel.Client.Hosts {
		if h.Name == host {
			mc.Data = h.Host
			break
		}
	}

	if mc.Data == "" {
		err := fmt.Errorf("host [%s] not found", host)
		znlib.ErrorCaller(err, caller+".CmdConnHost")
		return err
	}

	buf, err := mc.Marshal()
	if err != nil {
		znlib.ErrorCaller(err, caller+".CmdConnHost")
		return err
	}

	return mqtt.Client.Publish(Tunnel.Broker.TopicCmd.Topic, Tunnel.Broker.TopicCmd.Qos, buf)
}

// CmdConnResponse 2026-03-04 11:50:43
/*
 描述: 服务器反馈连接结果
*/
func (mc *MqttCmd) CmdConnResponse(caller string) error {
	mc.CmdInit(CmdConnRep)
	mc.Param = Tunnel.Broker.topicValid
	//mc.Data = ""
	//若连接异常,由外部填写内容

	buf, err := mc.Marshal()
	if err != nil {
		znlib.ErrorCaller(err, caller+".CmdConnResponse")
		return err
	}

	return mqtt.Client.Publish(Tunnel.Broker.TopicCmd.Topic, Tunnel.Broker.TopicCmd.Qos, buf)
}

// CmdBeginTrans 2026-03-04 16:14:50
/*
 描述: 客户端发起传输请求
*/
func (mc *MqttCmd) CmdBeginTrans(caller string) error {
	mc.CmdInit(CmdBeginTrans)
	buf, err := mc.Marshal()

	if err != nil {
		znlib.ErrorCaller(err, caller+".CmdBeginTrans")
		return err
	}

	return mqtt.Client.Publish(Tunnel.Broker.TopicCmd.Topic, Tunnel.Broker.TopicCmd.Qos, buf)
}

// CmdConnBreak 2026-03-05 15:04:46
/*
 描述: tcp.conn 断开时,通知对方断开服务
*/
func (mc *MqttCmd) CmdConnBreak(caller string) error {
	mc.CmdInit(CmdConnBreak)
	buf, err := mc.Marshal()
	if err != nil {
		znlib.ErrorCaller(err, caller+".CmdConnBreak")
		return err
	}

	return mqtt.Client.Publish(Tunnel.Broker.TopicCmd.Topic, Tunnel.Broker.TopicCmd.Qos, buf)
}

// CmdHintMsg 2026-03-05 15:04:46
/*
 描述: 向对方发送提示消息
*/
func (mc *MqttCmd) CmdHintMsg(receiver, msg, caller string) error {
	mc.CmdInit(CmdHintMessage)
	mc.Receiver = receiver
	mc.Data = msg

	buf, err := mc.Marshal()
	if err != nil {
		znlib.ErrorCaller(err, caller+".CmdHintMsg")
		return err
	}

	return mqtt.Client.Publish(Tunnel.Broker.TopicCmd.Topic, Tunnel.Broker.TopicCmd.Qos, buf)
}

// CmdPingResponse 2026-03-30 10:34:36
/*
 描述: 服务器应答ping
*/
func (mc *MqttCmd) CmdPingResponse(receiver, broker, caller string) error {
	mc.CmdInit(CmdPing)
	mc.Receiver = receiver
	mc.Data = broker

	buf, err := mc.Marshal()
	if err != nil {
		znlib.ErrorCaller(err, caller+".CmdPingResponse")
		return err
	}

	return mqtt.Client.Publish(Tunnel.Broker.TopicCmd.Topic, Tunnel.Broker.TopicCmd.Qos, buf)
}

// ------------------------------------------------------------------------------

// ApplyOptions 2026-02-27 20:06:36
/*
 参数: cli,mqtt client
 参数: broker,配置项
 描述: 使用params配置mt通道,返回有效clientID
*/
func ApplyOptions(cli *mqtt.Utils, config *BrokerItem) (string, error) {
	if len(config.URL) < 1 {
		return "", fmt.Errorf("config.server[%s].url: 服务地址为空", config.Name)
	}

	cfg := znlib.MqttConfig{
		Enable:   true,
		Broker:   config.URL,
		ClientID: config.ClientID,
		IDAuto:   config.IDAuto,
		User:     config.User,
		Password: config.Password,
		Tls:      config.Tls,
		TopicSub: nil,
		TopicPub: nil,
	}

	err := cli.ApplyConfig(&cfg)
	if err != nil {
		return "", err
	}

	cli.SubTopics = make(map[string]mqtt.Qos)
	cli.SubTopics[Tunnel.Broker.TopicCmd.Topic] = Tunnel.Broker.TopicCmd.Qos
	//订阅命令通道

	if cli == mqtt.Client { //配置主通道
		Tunnel.Broker.clientID = cfg.ClientID
		//同步客户端标识

		Tunnel.Broker.topicValid = znlib.StrReplace(Tunnel.Broker.TopicData.Topic,
			Tunnel.Broker.clientID, "$id")
		//更新数据通道标识

		if Tunnel.isSrv {
			Tunnel.Broker.topicSnd = Tunnel.Broker.topicValid + cTunnelDown
			Tunnel.Broker.topicRcv = Tunnel.Broker.topicValid + cTunnelUp
			//向客户端发送数据通道

			cli.SubTopics[Tunnel.Broker.topicRcv] = Tunnel.Broker.TopicData.Qos
			//订阅数据通道
		}

		cli.Options.SetDefaultPublishHandler(OnMessage)
		//消息处理句柄
		cli.RegisterEventHandler(brokerEvent)
		//断线自动选择新服务器
	}

	return cfg.ClientID, nil
}

// brokerEvent 2026-03-31 10:30:01
/*
 描述: 服务器自动选择新通道
*/
func brokerEvent(_ *mqtt.Utils, event mqtt.Event) {
	switch event {
	case mqtt.EventConnected:
		Tunnel.Broker.reConn = 0
		//重置计数
	case mqtt.EventReConnect:
		Tunnel.Broker.reConn = Tunnel.Broker.reConn + 1
		//累计计数

		if Tunnel.Broker.reConn >= 3 {
			mqtt.Client.Stop()
			//停用当前通道
			switchBroker(false)
		}
	default:
		//do nothing
	}
}

// switchBroker 2026-03-31 16:56:28
/*
 描述: 切换至最快服务器
*/
func switchBroker(init bool) {
	if Tunnel.Broker.reSwitch {
		return
	}

	Tunnel.Broker.reSwitch = true
	//set switch tag

	go func() {
		var param []string
		if init && !Tunnel.isSrv {
			param = append(param, cTagUpdateHost)
			//客户端启动时,通知服务端更新通道
		}

		incTime := 1
		waiter := znlib.NewWaiter[bool](nil)
		for {
			if err := startTunnel(Tunnel.srvName, Tunnel.isSrv, param...); err == nil {
				Tunnel.Broker.reSwitch = false
				return
			}

			res, _ := waiter.WaitFor(time.Duration(incTime*5) * time.Second)
			//逐渐延长探测时间
			if res != nil { //系统退出
				return
			}

			if incTime < 12 && Tunnel.isSrv { //最大延迟1分钟
				incTime++
			}
		}
	}()
}

// startTunnel 2026-03-30 08:50:37
/*
 参数: srvName,待连接的服务器名称
 参数: conn,是否立即连接
 参数: param,ping参数
 描述: 启动通道服务
*/
func startTunnel(srvName string, conn bool, param ...string) (res error) {
	defer znlib.DeferHandle(false, "mqtt.startTunnel", func(err error) {
		if err != nil {
			res = err
		}
	}) //捕获异常

	timeout := 10 * time.Second //ping 等待超时
	waiteResult := znlib.NewWaiter[string](nil)

	for _, srv := range Tunnel.Broker.Servers {
		if !srv.Used {
			continue
		}

		go func(cfg *BrokerItem) { //连接或检测
			cli := &mqtt.Utils{
				Client:   nil,
				Options:  mt.NewClientOptions(),
				HintInfo: false, //减少打印
			}
			defer cli.Stop()

			var cID string
			var err error
			if cID, err = ApplyOptions(cli, cfg); err != nil {
				znlib.ErrorCaller(err, "startTunnel.ApplyOptions")
				return
			}

			waiter := znlib.NewWaiter[bool](nil)
			//等待超时
			err = cli.Start(func(client mt.Client, msg mt.Message) {
				var cmd MqttCmd
				err = cmd.Unmarshal(msg.Payload())
				if err != nil || cmd.Cmd != CmdPing { //只处理 ping
					return
				}

				if (cmd.Receiver == "" && cmd.Sender == cID) || //ping 自己
					cmd.Receiver == cID { //ping 服务器
					bn := cmd.Data //broker name
					waiteResult.Wakeup(&bn, true)
					waiter.Wakeup(nil)
				}
			}, timeout)

			if err != nil {
				znlib.Warn(err)
				return
			}

			cmd := MqttCmd{
				Cmd:      CmdPing,
				Stamp:    time.Now().Unix(),
				Sender:   cID,
				Receiver: srvName,
				Data:     cfg.Name,
			}

			if len(param) > 0 {
				cmd.Param = param[0]
				//ping 参数
			}

			buf, err := cmd.Marshal()
			if err != nil {
				return
			}

			_ = cli.Publish(Tunnel.Broker.TopicCmd.Topic, Tunnel.Broker.TopicCmd.Qos, buf)
			//send ping
			waiter.WaitFor(timeout)
		}(srv)
	}

	bn, ok := waiteResult.WaitFor(timeout)
	if !ok {
		var hint string
		if srvName == "" {
			hint = "服务器全部不可用"
		} else {
			hint = fmt.Sprintf("服务器[ %s ]不在线", srvName)
		}

		znlib.Warn(hint)
		return fmt.Errorf(hint)
	}

	znlib.Info(fmt.Sprintf("使用[ %s ]作为传输通道", *bn))
	//show status

	if conn && Tunnel.Broker.activeSrv != *bn { //执行连接
		for _, srv := range Tunnel.Broker.Servers {
			if srv.Name == *bn { //broker name
				mqtt.Client.Stop()
				//stop first
				if _, err := ApplyOptions(mqtt.Client, srv); err != nil {
					return err
				}

				err := mqtt.Client.Start(nil, timeout)
				if err == nil {
					Tunnel.Broker.activeSrv = *bn
				}
				return err
			}
		}
	}

	return nil
}

// OnMessage 2026-02-27 14:48:47
/*
 参数: cli,mqtt
 参数: msg,数据
 描述: 收到来自 cli 的消息
*/
func OnMessage(_ mt.Client, msg mt.Message) {
	caller := "mqtt.OnMessge"
	defer znlib.DeferHandle(false, caller)
	//捕捉异常

	tp := msg.Topic()
	if tp == Tunnel.Broker.topicRcv { //数据传输通道
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

	// -----------------------------------------------------------------------------
	if cmd.Sender == Tunnel.Broker.clientID { //忽略自己发出的指令
		return
	}

	if (cmd.Receiver != Tunnel.Broker.clientID) && //接收方不是自己
		!(Tunnel.isSrv && cmd.Receiver == Tunnel.Server.Name && //连接时的服务器名称
			(cmd.Cmd == CmdConnHost || cmd.Cmd == CmdPing)) { //连接指令 or ping 指令
		return
	}

	stamp, ok := Tunnel.lastStamp[cmd.Cmd]
	if ok && stamp == cmd.Stamp { //反DDOS: 该时间戳已处理
		return
	}

	Tunnel.lastStamp[cmd.Cmd] = cmd.Stamp
	//记录时间戳

	bt := time.Duration(time.Now().Unix() - cmd.Stamp)
	//计算时间差
	if bt < 0 {
		bt = -bt
	}

	if bt > 5 { //时间戳5秒内失效
		var hintMsg string
		if Tunnel.isSrv {
			hintMsg = "time isn't sync: server(%s) client(%s)"
		} else {
			hintMsg = "time isn't sync: client(%s) server(%s)"
		}

		hintMsg = fmt.Sprintf(hintMsg,
			time.Now().Format(znlib.LayoutTime), znlib.DateTime2Str(DurationToTime(
				time.Duration(cmd.Stamp)*time.Second), znlib.LayoutTime))
		//format message

		if Tunnel.isSrv {
			_ = cmd.CmdHintMsg(cmd.Sender, hintMsg, caller)
		}

		znlib.Warn(hintMsg)
		return
	}

	if cmd.Cmd == CmdHintMessage { //双向提示信息
		znlib.Warn(cmd.Data)
		return
	}

	// ----------------------------------------------------------------------------
	if Tunnel.isSrv { //服务器
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
			Tunnel.receiver = cmd.Sender
			//更新接收方
			Tunnel.srvHost = cmd.Data
			//待连接主机地址

			err = TcpUtils.start()
			if err == nil {
				cmd.Data = ""
			} else {
				cmd.Data = err.Error()
			}

			_ = cmd.CmdConnResponse(caller)
			//回复客户端连接结果
		case CmdPing:
			_ = cmd.CmdPingResponse(cmd.Sender, cmd.Data, caller)
			//应答ping,告诉客户端在此服务器上

			if cmd.Param == cTagUpdateHost { //切换服务器
				switchBroker(false)
			}
		default:
			//do nothing
		}

		return
	}

	// ----------------------------------------------------------------------------
	switch cmd.Cmd {
	case CmdConnBreak:
		TcpUtils.closeConn()
		//关闭 tpc.conn 数据链路
		znlib.Warn("server disconnected tcp tunnel")
	case CmdConnRep:
		Tunnel.receiver = cmd.Sender
		//更新接收方
		suc := cmd.Data == ""

		if !suc { //连接远程主机异常
			znlib.ErrorCaller(cmd.Data, caller+".CmdConnRep")
			TcpUtils.waiter.Wakeup(&suc) //唤醒 tcp.srvConn 继续
			return
		}

		_, ok := mqtt.Client.SubTopics[cmd.Param+cTunnelDown]
		if !ok {
			delete(mqtt.Client.SubTopics, Tunnel.Broker.TopicCmd.Topic)
			//删除命令通道,余下旧的数据通道
			_ = mqtt.Client.Unsubscribe()
			//退订旧数据通道

			Tunnel.Broker.topicSnd = cmd.Param + cTunnelUp
			Tunnel.Broker.topicRcv = cmd.Param + cTunnelDown
			//同步服务器数据通道

			mqtt.Client.SubTopics = make(map[string]mqtt.Qos)
			mqtt.Client.SubTopics[Tunnel.Broker.TopicCmd.Topic] = Tunnel.Broker.TopicCmd.Qos //命令通道
			mqtt.Client.SubTopics[Tunnel.Broker.topicRcv] = Tunnel.Broker.TopicData.Qos      //数据通道

			_ = mqtt.Client.SubscribeMultiple()
			//订阅数据通道
			znlib.Info(fmt.Sprintf("connected server(%s) on tunnel(%s)", Tunnel.srvName, cmd.Sender))
		}

		cmd = MqttCmd{}
		err = cmd.CmdBeginTrans(caller) //通知服务器开始传输
		if err != nil {
			return
		}

		TcpUtils.waiter.Wakeup(&suc)
		//唤醒 tcp.srvConn 开始传输
	default:
		//do nothing
	}
}
