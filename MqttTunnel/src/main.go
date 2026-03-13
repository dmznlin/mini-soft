//go:generate goversioninfo -o main.syso ../res/ver.json
package main

import (
	"flag"
	"fmt"

	"github.com/dmznlin/znlib-go/znlib"
)

// 引入标准库
var _ = znlib.InitLib(func() {
	znlib.Application.ConfigFile = znlib.FixPathVar("$path/cfg/lib.json")
	znlib.GlobalConfig.Logger.FilePath = "$path/cfg/log/"
	znlib.GlobalConfig.Logger.Colorful = true
}, nil)

func main() {
	var (
		pass string
		srv  string
		host string
		role string
	)

	flag.StringVar(&role, "role", "srv", "cli,客户端;srv,服务端")
	flag.StringVar(&srv, "srv", "", "服务名称")
	flag.StringVar(&host, "host", "", "服务连接的主机名称")
	flag.StringVar(&pass, "pass", "", "生成 des 加密数据")
	flag.Parse()

	if pass != "" {
		buf, err := znlib.NewEncrypter(znlib.EncryptDesEcb,
			[]byte(znlib.DefaultEncryptKey)).Encrypt([]byte(pass), true)
		if err == nil {
			fmt.Println(string(buf))
		} else {
			znlib.Error(err)
		}

		return
	}

	//  ---------------------------------------------------------------------------
	var err error
	var cfg = znlib.FixPathVar("$path/cfg/tunnel.json")

	if znlib.FileExists(cfg, false) {
		err = znlib.LoadConfig(cfg, &Tunnel) //加载配置
	} else {
		TunnelModal()                        //添加模板数据
		err = znlib.SaveConfig(cfg, &Tunnel) //生成配置
	}

	if err != nil {
		znlib.Error(err.Error())
		return
	}

	Tunnel.lastStamp = make(map[byte]int64, 5)
	//指令最后的时间戳

	Tunnel.isSrv = role != "cli"
	if Tunnel.isSrv {
		Tunnel.sender = Tunnel.Server.Name
		// server 标识
	} else {
		if srv == "" { //默认服务端
			srv = Tunnel.Server.Name
		}

		if host == "" { //默认主机服务
			host = Tunnel.Client.Hosts[0].Name
		}

		Tunnel.srvName = srv
		Tunnel.srvHost = host
		Tunnel.sender = Tunnel.Client.Name
	}

	//应用设置
	err = ApplyOptions()
	if err != nil {
		znlib.Error(err.Error())
		return
	}

	//启动 mqtt
	err = mu.Start(nil)
	if err != nil {
		znlib.Error(err.Error())
		return
	}

	//客户端启动 tcp-server
	if !Tunnel.isSrv {
		err = TcpUtils.start()
		if err != nil {
			znlib.Error(err.Error())
			return
		}
	}

	if Tunnel.isSrv {
		znlib.Info("server on " + Tunnel.Server.Name)
	} else {
		znlib.Info("client on " + Tunnel.Client.Name)
	}

	znlib.WaitSystemExit(func() error {
		return TcpUtils.Stop()
	}, func() error {
		mu.Stop()
		return nil
	})
}
