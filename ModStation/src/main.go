package main

import (
	"fmt"
	"os"
	"time"

	"github.com/dmznlin/znlib-go/znlib"
	"github.com/dmznlin/znlib-go/znlib/modbus"
)

// 引入标准库
var _ = znlib.InitLib(nil, nil)

func main() {
	var err error
	var cfg = znlib.AppPath + "cfg" + znlib.PathSeparator + "slavers.json"

	if znlib.FileExists(cfg, false) {
		err = LoadSlavers(cfg) //加载配置
	} else {
		SlaverModal()          //添加模板数据
		err = SaveSlavers(cfg) //生成配置
	}

	if err != nil {
		znlib.Error(err.Error())
		return
	}

	//-----------------------------------------------------------------------------
	var server *modbus.ModbusServer
	server, err = modbus.NewServer(&modbus.ServerConfiguration{
		URL:        Devices.Local.Service,
		Timeout:    Devices.Local.Timeout * time.Second,
		MaxClients: Devices.Local.MaxClients,
	}, NewHandler())

	if err != nil {
		znlib.Error(fmt.Sprintf("modbus.NewServer: %s", err.Error()))
		os.Exit(1)
	}

	err = server.Start()
	if err != nil {
		znlib.Error(fmt.Sprintf("modbus.Start: %s", err.Error()))
		os.Exit(1)
	}

	znlib.Info("服务开启> " + Devices.Local.Service)
	znlib.WaitSystemExit(func() error {
		return server.Stop()
	})
}
