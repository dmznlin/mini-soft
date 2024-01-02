/*
Package main
*******************************************************************************
作者: dmzn@163.com 2023-12-29 17:26:08
描述: 微信通讯代理
*******************************************************************************
*/
package main

import (
	"Feihe_cli/src/wcferry"
	"fmt"
	. "github.com/dmznlin/znlib-go/znlib"
)

// wechat proxy: 微信代理
type wcProxy struct {
	cli  *wcferry.Client //客户端对象
	host string          //wcf地址
	port int             //wcf端口
}

// 代理对象
var wechat = wcProxy{
	nil,
	"127.0.0.1",
	10086,
}

/*
init 2023-12-29 18:43:32
对象: wp
描述: 初始化微信代理对象
*/
func (wp *wcProxy) init() (isok bool) {
	isok = false
	//default

	if wp.cli != nil {
		isok = wp.cli.CmdClient.IsLogin()
		if !isok {
			Error("微信代理已离线.")
		}
		return isok
	}

	wp.cli = &wcferry.Client{
		ListenAddr: wechat.host,
		ListenPort: wechat.port,
		SdkLibrary: "",
		WeChatAuto: false,
	}

	if err := wp.cli.Connect(); err != nil {
		Error("初始化微信代理失败：", LogFields{"wcf.Connect: ": err})
		return
	}

	wp.cli.EnrollReceiver(true, wcferry.MsgPrinter)
	isok = wp.cli.CmdClient.IsLogin()
	if isok {
		Info(fmt.Sprintf("用户 %s 已登录微信", wp.cli.CmdClient.GetSelfWxid()))
	} else {
		Error("未检测到 已登录 的微信")
	}
	return isok
}

/*
listContact 2023-12-30 10:13:30
对象: wp
描述: 打印群联系人列表
*/
func (wp *wcProxy) listContact(room string) {
	if !wp.init() {
		return
	}

	var name string
	var cts []*wcferry.RpcContact
	if room == "" {
		cts = wp.cli.CmdClient.GetContacts()
	} else {
		cts = wp.cli.CmdClient.GetChatRoomMembers(room)
	}

	for i, v := range cts {
		if v.Remark == "" {
			name = v.Name
		} else {
			name = v.Remark
		}

		name = wp.cli.CmdClient.GetAliasInChatRoom(v.Wxid, room)
		fmt.Println(fmt.Sprintf("%-3d.%25s - %s", i, v.Wxid, name))
	}
}
