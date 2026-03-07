package main

import (
	"flag"
	"fmt"

	"github.com/dmznlin/znlib-go/znlib"
)

// 引入标准库
var _ = znlib.InitLib(nil, nil)

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
		buf, err := znlib.NewEncrypter(znlib.EncryptDES_ECB,
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
	var cfg = znlib.AppPath + "cfg" + znlib.PathSeparator + "tunnel.json"

	if znlib.FileExists(cfg, false) {
		err = LoadTunnel(cfg) //加载配置
	} else {
		TunnelModal()         //添加模板数据
		err = SaveTunnel(cfg) //生成配置
	}

	if err != nil {
		znlib.Error(err.Error())
		return
	}

	Tunnel.isSrv = role != "cli"
	if !Tunnel.isSrv {
		if srv == "" { //默认服务端
			srv = Tunnel.Server.Name
		}

		if host == "" { //默认主机服务
			host = Tunnel.Client.Hosts[0].Name
		}

		Tunnel.srvName = srv
		Tunnel.srvHost = host
	}

	//应用设置
	err = MqttUtils.ApplyOptions()
	if err != nil {
		znlib.Error(err.Error())
		return
	}

	//启动 mqtt
	err = MqttUtils.Start()
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
		MqttUtils.Stop()
		return nil
	})
}
