package main

import (
	"context"
	"fmt"
	"sync"
	"time"

	"github.com/dmznlin/znlib-go/znlib/modbus"
)

var (
	// 全局上下文
	gCtx, gCancel = context.WithCancel(context.Background())
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

	var client *modbus.ModbusClient
	client, err = modbus.NewClient(&modbus.ClientConfiguration{
		URL:      "rtu://" + gConfig.Port,
		Speed:    gConfig.Baud,
		DataBits: gConfig.DataBits,
		Parity:   configParity(),
		StopBits: gConfig.StopBits,
		Timeout:  300 * time.Millisecond,
	})

	wg := sync.WaitGroup{}
	wg.Add(1)
	//执行线程业务

	go func() {
	outloop:
		for {
			select {
			case <-gCtx.Done():
				log("Call ReadAndSend Break.")
				break outloop
			default:
				//do nothing
			}

			ReadAndSend(client)
			//处理业务
			time.Sleep(5 * time.Second)
		}

		wg.Done()
		//业务退出
	}()

	WaitSystemExit()
	gCancel() //通知业务退出
	wg.Wait()
}

// configParity 2026-02-09 18:56:05
/*
 描述: 获取配置 校验方式
*/
func configParity() uint {
	switch gConfig.Parity {
	case "none":
		return modbus.PARITY_NONE
	case "odd":
		return modbus.PARITY_ODD
	case "even":
		return modbus.PARITY_EVEN
	default:
		return modbus.PARITY_NONE
	}
}

// ReadAndSend 2026-02-06 11:20:43
/*
 参数: cli,modbus通道
 描述: 读取温度数据并发送至LED屏幕
*/
func ReadAndSend(cli *modbus.ModbusClient) {
	defer func() {
		if r := recover(); r != nil {
			err, ok := r.(error)
			if ok {
				log("ReadAndSend: " + err.Error())
			}
		}
	}()

	err := cli.Close()
	if err != nil {
		log("关闭 %s 端口失败: %s", gConfig.Port, err.Error())
		return
	}

	err = cli.Open()
	if err != nil {
		log("连接 %s 端口失败: %s", gConfig.Port, err.Error())
		return
	}

	defer cli.Close()
	var tmp uint16
	//温度值

outloop:
	for {
		select {
		case <-gCtx.Done():
			log("ReadAndSend Exists.")
			break outloop
		default:
			time.Sleep(time.Duration(gConfig.Refresh) * time.Second)
		}

		tmp, err = cli.ReadRegister(gConfig.Address, modbus.HOLDING_REGISTER)
		if err != nil {
			log("ReadRegister Error: %s", err.Error())
			break
		}

		str := StrReplace(gConfig.Display, time.Now().Format("15:04:05"), "$T")
		str = StrReplace(str, fmt.Sprintf("%.1f", float32(tmp)/10), "$W")
		//构建显示内容

		disp, err := EncodeToGB2312TwoBytes(string([]byte{0x40, gConfig.Card}) + str + string([]byte{0x0D}))
		if err != nil {
			log(err.Error())
			continue
		}

		err = cli.WriteRawData(disp)
		if err != nil {
			log(err.Error())
			continue
		}
	}
}
