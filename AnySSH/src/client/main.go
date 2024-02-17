// Package main
/******************************************************************************
  作者: dmzn@163.com 2024-02-17 12:03:02
  描述: anyssh用户入口
******************************************************************************/
package main

import (
	"flag"
	"fmt"
	. "github.com/dmznlin/znlib-go/znlib"
	"github.com/olahol/melody"
	"net"
	"net/http"
	"os/exec"
	"strconv"
	"strings"
)

// 初始化znlib库
var _ = InitLib(nil, nil)

func main() {
	var pass string
	flag.StringVar(&pass, "pass", "", "生成DB、MQTT的DES密码")
	flag.Parse()

	if pass != "" {
		buf, err := NewEncrypter(EncryptDES_ECB,
			[]byte(DefaultEncryptKey)).Encrypt([]byte(pass), true)
		if err == nil {
			fmt.Println(string(buf))
		} else {
			Error(err)
		}

		return
	}

	//  ---------------------------------------------------------------------------
	caller := "anyssh.client.main"
	servicePort, err := randomPort()
	if err != nil {
		ErrorCaller(err, caller)
		return
	}

	ws := melody.New() //用于WebSocket
	msg := make(chan string, 10)

	Mqtt.StartWithUtils(func(cmd *MqttCommand) error { //启动mqtt服务
		msg <- cmd.Data
		return nil
	})

	go func() { // 处理来自虚拟终端的消息
		for {
			select {
			case <-Application.Ctx.Done():
				return
			case data := <-msg:
				ws.Broadcast([]byte(data)) // 将数据发送给网页
				//Info("remote:" + data)
			}
		}
	}()

	//  ---------------------------------------------------------------------------
	var remoteID string
	//远程节点
	remoteID = "anyssh_server_01"

	ws.HandleMessage(func(s *melody.Session, msg []byte) { // 处理来自WebSocket的消息
		nlen := len(msg)
		if nlen > 5 && string(msg[0:6]) == string([]byte{0, 1, 2, 3, 4, 5}) {
			switch {
			case nlen >= 10 && string(msg[6:10]) == "conn":
				MqttSSH.Connect(remoteID)
			case nlen >= 12 && string(msg[6:12]) == "resize":
				MqttSSH.SendData(remoteID, MqttSSHResize, msg[12:])
			default:
				//do nothing
			}

			return
		}

		MqttSSH.SendData(remoteID, MqttSSHCommon, msg)
	})

	http.HandleFunc("/terminal", func(w http.ResponseWriter, r *http.Request) {
		ws.HandleRequest(w, r) //转交给melody处理
	})

	termFS := FixPathVar("$path/dist/terminal/")
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		id := r.FormValue("remote")
		if id != "" {
			remoteID = id
			Info("当前服务端标识: " + remoteID)
		}

		http.StripPrefix("/", http.FileServer(http.Dir(termFS))).ServeHTTP(w, r)
		//静态文件处理
	})

	go http.ListenAndServe(fmt.Sprintf("0.0.0.0:%d", servicePort), nil)
	//启动服务
	serviceURL := fmt.Sprintf(`http://127.0.0.1:%d/?remote=%s`, servicePort, remoteID)
	exec.Command(`cmd`, `/c`, `start`, serviceURL).Start()
	//启动浏览器

	WaitSystemExit(func() error {
		Mqtt.Stop()
		return nil
	})
}

// RandomPort 2024-02-17 12:22:11
/*
 描述: 获取随机端口
*/
func randomPort() (port int, err error) {
	lis, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		return 0, err
	}

	defer lis.Close()
	addr := lis.Addr().String()
	idx := strings.LastIndex(addr, ":")

	if idx > 0 {
		port, _ = strconv.Atoi(addr[idx+1:])
	} else {
		err = ErrorMsg(nil, "RandomPort: invalid listener format.")
	}

	return port, err
}
