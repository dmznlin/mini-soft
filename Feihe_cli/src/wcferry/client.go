package wcferry

import (
	"errors"
	"os/exec"
	"strings"
	"syscall"
	"time"

	"github.com/opentdp/go-helper/logman"
	"github.com/opentdp/go-helper/onquit"
)

type Client struct {
	ListenAddr string     // wcf 监听地址
	ListenPort int        // wcf 监听端口
	SdkLibrary string     // sdk.dll 路径
	WeChatAuto bool       // 微信自动启停
	CmdClient  *CmdClient // 命令客户端
	MsgClient  *MsgClient // 消息客户端
}

// 启动 wcf 服务
// return error 错误信息
func (c *Client) Connect() error {
	if c.ListenAddr == "" {
		c.ListenAddr = "127.0.0.1"
	}
	if c.ListenPort == 0 {
		c.ListenPort = 10080
	}
	// 注册 wcf 服务
	c.CmdClient = &CmdClient{
		pbSocket: newPbSocket(c.ListenAddr, c.ListenPort),
	}
	c.MsgClient = &MsgClient{
		pbSocket: newPbSocket(c.ListenAddr, c.ListenPort+1),
	}
	// 启动 wcf 服务
	if c.SdkLibrary != "" {
		if err := c.wxInitSDK(); err != nil {
			return err
		}
	}
	// 自动注销 wcf
	defer onquit.Register(func() {
		c.CmdClient.Destroy()
		c.MsgClient.Destroy(true)
		if c.SdkLibrary != "" {
			c.wxDestroySDK()
		}
	})
	// 返回连接结果
	return c.CmdClient.init(5)
}

// 启动消息接收器
// param pyq bool 是否接收朋友圈消息
// param fn ...MsgCallback 消息回调函数
// return error 错误信息
func (c *Client) EnrollReceiver(pyq bool, fn ...MsgCallback) error {
	if c.CmdClient.EnableMsgServer(true) != 0 {
		return errors.New("failed to enable msg server")
	}
	time.Sleep(1 * time.Second)
	c.MsgClient.Register(fn...)
	return nil
}

// 关闭消息接收器
// param force bool 是否强制关闭
// return error 错误信息
func (c *Client) DisableReceiver(force bool) error {
	if c.CmdClient.DisableMsgServer() != 0 {
		return errors.New("failed to disable msg server")
	}
	return c.MsgClient.Destroy(force)
}

// 调用 sdk.dll 中的函数
func (c *Client) sdkCall(fn string, a ...uintptr) error {
	// 加载 sdk.dll
	sdk, err := syscall.LoadDLL(c.SdkLibrary)
	if err != nil {
		logman.Info("failed to load sdk.dll", "error", err)
		return err
	}
	defer sdk.Release()
	// 查找 fn 函数
	proc, err := sdk.FindProc(fn)
	if err != nil {
		logman.Info("failed to call "+fn, "error", err)
		return err
	}
	// 执行 fn(a...)
	r1, r2, err := proc.Call(a...)
	logman.Warn("call dll:"+fn, "r1", r1, "r2", r2, "error", err)
	return err
}

// 启动 wcf 服务
// return error 错误信息
func (c *Client) wxInitSDK() error {
	if c.WeChatAuto {
		out, _ := exec.Command("tasklist").Output()
		if strings.Contains(string(out), "WeChat.exe") {
			return errors.New("please close wechat")
		}
	}
	c.sdkCall("WxInitSDK", uintptr(0), uintptr(c.ListenPort))
	time.Sleep(5 * time.Second)
	return nil
}

// 关闭 wcf 服务
// return error 错误信息
func (c *Client) wxDestroySDK() error {
	c.sdkCall("WxDestroySDK", uintptr(0))
	if c.WeChatAuto {
		logman.Info("killing wechat process")
		cmd := exec.Command("taskkill", "/IM", "WeChat.exe", "/F")
		if err := cmd.Run(); err != nil {
			logman.Warn("failed to kill wechat", "error", err)
			return err
		}
	}
	return nil
}
