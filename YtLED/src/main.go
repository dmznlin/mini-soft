package main

import (
	"context"
	"fmt"
	"github.com/dmznlin/znlib-go/znlib/modbus"
	"github.com/goburrow/serial"
	"sync"
	"time"
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
	//modbus client
	client.SetAutoReconnect(3)
	client.LogMode(false)

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

// ReadAndSend 2026-02-06 11:20:43
/*
 参数: cli,modbus通道
 描述: 读取温度数据并发送至LED屏幕
*/
func ReadAndSend(cli modbus.Client) {
	defer func() {
		if r := recover(); r != nil {
			err, ok := r.(error)
			if ok {
				log("ReadAndSend: " + err.Error())
			}
		}
	}()

	if cli.IsConnected() {
		cli.Close()
		//重新接入端口
	}

	err := cli.Connect()
	if err != nil {
		log("连接 %s 端口失败: %s", gConfig.Port, err.Error())
		return
	}
	defer cli.Close()

outloop:
	for {
		select {
		case <-gCtx.Done():
			log("ReadAndSend Exists.")
			break outloop
		default:
			time.Sleep(time.Second * 1)
		}

		buf := []byte{gConfig.Address, 0x03, 0x00, 0x00, 0x00, 0x02}
		crc := modbus.CRC16(buf[:len(buf)])
		buf = append(buf, byte(crc), byte(crc>>8)) //大端

		buf, err := cli.SendRawFrame(buf)
		if err != nil {
			log(err.Error())
			break
		}

		if len(buf) != 9 || buf[0] != gConfig.Address || buf[1] != 0x03 {
			log("ReadAndSend: 无效的数据长度.")
			continue
		}

		crc = modbus.CRC16(buf[:len(buf)-2]) //crc为大端,标准为小端
		if crc == byte2Val([]byte{buf[7], buf[8]}) {
			log("ReadAndSend: CRC校验错误.")
			break
		}

		tmp := byte2Val([]byte{buf[5], buf[6]})
		str := StrReplace(gConfig.Display, time.Now().Format("15:04:05"), "$T")
		str = StrReplace(str, fmt.Sprintf("%.1f", float32(tmp)/10), "$W")
		//构建显示内容

		disp, err := EncodeToGB2312TwoBytes(string([]byte{0x40, gConfig.Card}) + str + string([]byte{0x0D}))
		if err != nil {
			log(err.Error())
			continue
		}

		_, err = cli.SendRawFrame(disp, true)
		if err != nil {
			log(err.Error())
			continue
		}
	}
}
