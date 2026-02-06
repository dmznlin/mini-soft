package main

import (
	"fmt"
	"github.com/goburrow/serial"
	modbus "github.com/thinkgos/gomodbus/v2"
	"time"
)

func main() {
	var err error
	if FileExists(gConfigFile, false) {
		err = LoadConfig(gConfigFile) //加载配置
	} else {
		err = SaveConfig(gConfigFile) //生成配置
	}

	if err != nil {
		log(err.Error())
		return
	}

	pv := modbus.NewRTUClientProvider(modbus.WithEnableLogger(),
		modbus.WithSerialConfig(serial.Config{
			Address:  gConfig.Port,
			BaudRate: gConfig.Baud,
			DataBits: gConfig.DataBits,
			StopBits: gConfig.StopBits,
			Parity:   gConfig.Parity,
			Timeout:  modbus.SerialDefaultTimeout,
		}))

	client := modbus.NewClient(pv)
	err = client.Connect()
	if err != nil {
		log("连接 %s 端口失败: %s", gConfig.Port, err.Error())
		return
	}
	defer client.Close()

	for {
		results, err := client.ReadCoils(gConfig.SlaveID, gConfig.Address, gConfig.Quantity)
		if err != nil {
			fmt.Println(err.Error())
		} else {
			fmt.Printf("ReadDiscreteInputs %#v\r\n", results)
		}
		time.Sleep(time.Second * 5)
	}

	WaitSystemExit()
}
