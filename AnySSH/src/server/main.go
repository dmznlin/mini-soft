// Package main
/******************************************************************************
  作者: dmzn@163.com 2024-02-17 11:12:59
  描述: anyssh主服务端

备注:
  *.被控端:一台启用了ssh服务的内网主机
  *.server端与被控端在同一网络,或者可以访问到被控端主机.
******************************************************************************/
package main

import (
	"flag"
	"fmt"
	. "github.com/dmznlin/znlib-go/znlib"
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
	Mqtt.StartWithUtils(nil)
	//启动mqtt服务

	WaitSystemExit(func() error {
		Mqtt.Stop()
		return nil
	})
}
