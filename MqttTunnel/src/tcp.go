// Package main
/******************************************************************************
  作者: dmzn@163.com 2026-03-04 11:40:36
  描述: 服务器连接远程主机,客户端提供TCP服务
******************************************************************************/
package main

import (
	"errors"
	"fmt"
	"io"
	"net"
	"sync"
	"syscall"
	"time"

	"github.com/dmznlin/znlib-go/znlib"
)

type tcpUtils struct {
	srv    net.Listener
	srvOK  bool
	conn   net.Conn
	connOK bool

	wg     sync.WaitGroup
	waiter *znlib.Waiter[bool]
}

var TcpUtils = tcpUtils{
	srvOK:  false,
	connOK: false,
	wg:     sync.WaitGroup{},
	waiter: znlib.NewWaiter[bool](nil),
}

// start 2026-03-02 18:29:24
/*
 描述: 启动服务
*/
func (tu *tcpUtils) start() (err error) {
	if Tunnel.isSrv { //服务器
		if len(Tunnel.srvHost) < 1 {
			return nil
		}

		if tu.connOK {
			tu.connOK = false
			tu.conn.Close()

			tu.wg.Wait()
			//等待上一个连接结束
		}

		tu.conn, err = net.Dial("tcp", Tunnel.srvHost)
		if err != nil {
			return err
		}

		tu.connOK = true
		go tu.cliConn()
	} else {
		if tu.srvOK { ////客户端监听服务已存在
			return nil
		}

		tu.srv, err = net.Listen("tcp", fmt.Sprintf(":%d", Tunnel.Client.Port))
		if err != nil {
			return err
		}

		tu.srvOK = true
		go tu.srvConn()
	}

	return nil
}

// Stop 2026-03-02 18:28:35
/*
 描述: 停止服务
*/
func (tu *tcpUtils) Stop() (err error) {
	val := false
	tu.waiter.Wakeup(&val)
	//唤醒等待

	if tu.connOK {
		tu.connOK = false
		tu.conn.Close()
	}

	if tu.srvOK {
		tu.srvOK = false
		tu.srv.Close()
	}

	tu.wg.Wait()
	return nil
}

// closeConn 2026-03-05 15:28:01
/*
 描述: 关闭数据链路
*/
func (tu *tcpUtils) closeConn() {
	if tu.connOK {
		tu.connOK = false
		tu.conn.Close()
	}
}

// srvConn 2026-03-02 18:28:53
/*
 描述: 客户端提供接入服务
*/
func (tu *tcpUtils) srvConn() {
	caller := "tcpUtils.srvConn"
	defer znlib.DeferHandle(false, caller)

	znlib.Info(fmt.Sprintf("client tcp service on: 127.0.0.1:%d", Tunnel.Client.Port))
	//show status

	defer func() {
		if tu.connOK {
			tu.connOK = false
			tu.conn.Close()
		}

		if tu.srvOK {
			tu.srvOK = false
			tu.srv.Close()
		}

		tu.wg.Done()
	}()

	tu.wg.Add(1)
	for {
		select {
		case <-znlib.Application.Ctx.Done():
			{
				znlib.Info("client tcp tunnel closed")
				return
			}
		default:
			//do nothing
		}

		if tu.connOK {
			tu.connOK = false
			tu.conn.Close()
		}

		var err error
		tu.conn, err = tu.srv.Accept()
		if err != nil {
			continue
		}

		tu.connOK = true
		//set flag to close

		var cmd MqttCmd
		buf, err := cmd.CmdConnHost(Tunnel.srvHost)
		if err != nil {
			znlib.ErrorCaller(err, "tcpUtils.srvConn")
			continue
		}

		mu.Publish(Tunnel.Broker.TopicCmd.Topic, Tunnel.Broker.TopicCmd.Qos, buf)
		//发起连接请求

		tu.waiter.Reset()
		val, ok := tu.waiter.WaitFor(5 * time.Second)
		if !ok || !*val { //超时或连接异常
			znlib.Warn("tcpUtils.srvConn: wait CmdConnResponse timeout")
			continue
		}

		fmt.Println("tcp new connection: ", tu.conn.RemoteAddr())
		tu.doConn()
		//处理数据
	}
}

// cliConn 2026-03-02 17:57:27
/*
 描述: 服务器连接主机
*/
func (tu *tcpUtils) cliConn() {
	defer znlib.DeferHandle(false, "tcpUtils.cliConn")
	znlib.Info(fmt.Sprintf("server connected host: %s", Tunnel.srvHost))
	//show status

	tu.waiter.Reset()
	val, ok := tu.waiter.WaitFor(10 * time.Second)
	//等待客户端订阅数据通道

	if !ok || !*val { //超时或连接异常
		if tu.connOK {
			tu.connOK = false
			tu.conn.Close()
		}

		znlib.Warn("tcpUtils.cliConn: wait CmdBeginTrans timeout")
		return
	}

	defer tu.wg.Done()
	tu.wg.Add(1)
	tu.doConn()
}

// doConn 2026-03-02 17:52:15
/*
 描述: 读取链路数据
*/
func (tu *tcpUtils) doConn() {
	defer func() {
		if tu.connOK {
			tu.connOK = false
			tu.conn.Close()

			var cmd MqttCmd
			buf, err := cmd.CmdConnBreak()
			if err != nil {
				znlib.ErrorCaller(err, "tcpUtils.doConn")
			}

			mu.Publish(Tunnel.Broker.TopicCmd.Topic, Tunnel.Broker.TopicCmd.Qos, buf)
			//发起连接请求
		}
	}()

	buf := make([]byte, 4096)
	var err error
	var n int
outLoop:
	for {
		n, err = tu.conn.Read(buf)
		//read data

		select {
		case <-znlib.Application.Ctx.Done():
			break outLoop
		default:
			//do nothing
		}

		if n > 0 { //发送数据
			if !Tunnel.isSrv && buf[0] == cTagUpdateHost[0] && n > cTagLen { //客户端动态设置服务器和主机参数
				if string(buf[:cTagLen]) == cTagUpdateHost && buf[n-1] == cTagEnd { //前、后缀匹配
					Tunnel.srvHost = string(buf[cTagLen : n-1])
					znlib.Info(fmt.Sprintf("tcpUtils.doConn: new host(%s)", Tunnel.srvHost))
					continue
				}
			}

			mu.Publish(Tunnel.topicSnd, Tunnel.Broker.TopicData.Qos, buf[:n])
			//send data
		}

		if err != nil && ConnInvalid(err) {
			znlib.Warn(fmt.Sprintf("host disconnect: %s", tu.conn.RemoteAddr()))
			break outLoop
		}
	}
}

// ConnInvalid 2026-03-04 17:25:41
/*
 参数: err,异常
 描述: 依据 err 判定连接是否可用
*/
func ConnInvalid(err error) bool {
	// 1. 最常见的 EOF（对方关闭连接）
	if err == io.EOF {
		return true
	}

	// 2. 连接被本地关闭
	if errors.Is(err, net.ErrClosed) {
		return true
	}

	// 3. 系统级致命错误（连接重置/管道破裂等）
	var sysErr syscall.Errno
	if errors.As(err, &sysErr) {
		switch {
		case errors.Is(sysErr, syscall.ECONNRESET),
			errors.Is(sysErr, syscall.EPIPE),
			errors.Is(sysErr, syscall.ECONNABORTED),
			errors.Is(sysErr, syscall.ENOTCONN):
			return true
		}
	}

	// 4. 网络错误中，永久性错误（非临时错误）代表连接不可用
	var netErr net.Error
	if errors.As(err, &netErr) {
		// Temporary() 返回 false 表示是永久性错误，连接无法恢复
		return !netErr.Temporary()
	}

	return false
}

// writeData 2026-03-02 18:27:38
/*
 参数: dt,数据
 描述: 向链路写入数据
*/
func (tu *tcpUtils) writeData(dt []byte) {
	defer znlib.DeferHandle(false, "tcpUtils.writeData")
	//handle exception

	if tu.connOK {
		_, err := tu.conn.Write(dt)
		if err != nil {
			znlib.ErrorCaller(err, "tcpUtils.writeData")
		}
	}
}
