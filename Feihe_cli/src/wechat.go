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
	"github.com/dmznlin/znlib-go/znlib/pinyin"
	"strings"
	"time"
)

// 微信联系人卡片
type wxContact struct {
	wxID     string //微信号
	nickName string //微信昵称
	pinyin   string //昵称拼音
	room     string //群id号
}

// 联系人有效时间，超过需要再次更新
const (
	sRoomTag                = "@chatroom"
	cLenRoomTag             = len(sRoomTag)
	cUpdateContactsInterval = 1 * time.Hour
)

var (
	wcContacts                   = make([]wxContact, 0, 100)                //联系人缓存
	lastUpdateContacts time.Time = time.Now().Add(-cUpdateContactsInterval) //下次更新时间
)

// wechat proxy: 微信代理
type wxProxy struct {
	cli  *wcferry.Client //客户端对象
	host string          //wcf地址
	port int             //wcf端口
}

// 代理对象
var wechat = wxProxy{
	nil,
	"127.0.0.1",
	10086,
}

/*
init 2023-12-29 18:43:32
对象: wp
描述: 初始化微信代理对象
*/
func (wp *wxProxy) init() (isok bool) {
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
func (wp *wxProxy) listContact(room string) {
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
		if room != "" { //群昵称
			name = wp.cli.CmdClient.GetAliasInChatRoom(v.Wxid, room)
		} else {
			name = ""
		}

		if name == "" {
			if v.Remark == "" {
				name = v.Name
			} else {
				name = v.Remark
			}
		}

		fmt.Println(fmt.Sprintf("%-3d.%25s - %s", i, v.Wxid, name))
	}

}

// matchContact 2024-01-03 10:26:24
/*
 参数: name,人名
 描述: 模糊匹配，找到name对应的微信联系人
*/
func (wp *wxProxy) matchContact(name string) (res []wxContact, ok bool) {
	res = nil
	ok = false
	//default

	dict := pinyin.NewDict()
	name = StrTrim(name)
	namepy := dict.Convert(name, " ").None()
	//Ex: 丰巢 - feng chao

	if namepy == "" { //无效名称
		return
	}

	//  ---------------------------------------------------------------------------
	if time.Now().After(lastUpdateContacts) { //缓存超时
		wcContacts = wcContacts[0:0]
		//clear first
		rooms := make([]string, 0, 100)
		//群列表

		getcts := func(room string) {
			var name string
			var cts []*wcferry.RpcContact
			if room == "" {
				cts = wp.cli.CmdClient.GetContacts()
			} else {
				cts = wp.cli.CmdClient.GetChatRoomMembers(room)
			}

			for _, v := range cts {
				if StrCopyRight(v.Wxid, cLenRoomTag) == sRoomTag { //群
					rooms = append(rooms, v.Wxid)
				} else {
					if StrPos(v.Wxid, "@openim") > 0 { //公众号
						continue
					}

					if room != "" { //群昵称
						name = wp.cli.CmdClient.GetAliasInChatRoom(v.Wxid, room)
					} else {
						name = ""
					}

					if name == "" {
						if v.Remark == "" {
							name = v.Name
						} else {
							name = v.Remark
						}
					}

					wcContacts = append(wcContacts, wxContact{
						wxID:     v.Wxid,
						nickName: StrTrim(name),
						pinyin:   dict.Convert(name, " ").None(),
						room:     room,
					})
				}
			}
		}

		getcts("")
		// 联系人列表
		for _, v := range rooms {
			getcts(v)
			//群成员
		}

		lastUpdateContacts = time.Now().Add(cUpdateContactsInterval)
		//标记时间
	}

	//  ---------------------------------------------------------------------------
	res = make([]wxContact, 0, 1)
	//init first

	for _, v := range wcContacts {
		if strings.EqualFold(v.nickName, name) || v.pinyin == namepy { //完全匹配或错别字匹配
			res = append(res, v)
		}
	}

	if len(res) < 1 {
		for _, v := range wcContacts {
			if StrPos(v.pinyin, namepy) > 0 { //错误字模糊匹配: 人名匹配群昵称,Ex: 张三 -> 技术部张三
				res = append(res, v)
			}
		}
	}

	if len(res) < 1 {
		for _, v := range wcContacts {
			if StrPos(namepy, v.pinyin) > 0 { //错误字模糊匹配: 群昵称匹配人名
				res = append(res, v)
			}
		}
	}

	return res, len(res) > 0
}
