/*
Package main
*******************************************************************************
作者: dmzn@163.com 2023-12-29 17:26:08
描述: 微信通讯代理
*******************************************************************************
*/
package main

import (
	"fmt"
	"github.com/danbai225/WeChatFerry-go/wcf"
	. "github.com/dmznlin/znlib-go/znlib"
	"strconv"
)

// wechat proxy: 微信代理
type wcProxy struct {
	cli  *wcf.Client //客户端对象
	host string      //wcf地址
	port int         //wcf端口
}

// 代理对象
var wechat = wcProxy{
	nil,
	"tcp://127.0.0.1",
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
		isok = wp.cli.IsLogin()
		if isok {
			return
		} //proxy ok

		cli := wp.cli
		wp.cli = nil
		//reset

		if err := cli.Close(); err != nil {
			Error("关闭微信代理失败：", LogFields{"wcf.Close": err})
			return
		}
	}

	var err error
	wp.cli, err = wcf.NewWCF(wp.host + ":" + strconv.Itoa(wp.port))
	if err != nil {
		Error("初始化微信代理失败：", LogFields{"wcf.NewWCF": err})
		return
	}

	isok = wp.cli.IsLogin()
	if isok {
		Info(fmt.Sprintf("用户 %s 已登录微信", wp.cli.GetSelfWXID()))
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
func (wp *wcProxy) listContact() {
	if !wp.init() {
		return
	}

	var name string
	cts := wp.cli.GetContacts()
	for i, v := range cts {
		if v.Remark == "" {
			name = v.Name
		} else {
			name = v.Remark
		}

		fmt.Println(fmt.Sprintf("%-3d.%25s - %s", i, v.Wxid, name))
	}
}
