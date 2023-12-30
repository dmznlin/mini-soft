//go:generate goversioninfo -o main.syso ../res/ver.json
package main

import (
	"context"
	"flag"
	"fmt"
	"github.com/dmznlin/znlib-go/znlib"
	"github.com/go-ini/ini"
	"net"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"syscall"
	"time"
)

// 初始化基础库
var _ = znlib.InitLib(nil, nil)

var cfg = struct {
	bindIP    string //服务地址
	bindPort  int    //服务端口
	erpVerify string //ERP Key
}{
	"",
	80,
	"erp_cli",
}

// 载入系统配置
func loadcfg() {
	f, err := ini.Load(znlib.Application.ConfigFile)
	if err != nil {
		znlib.Error("无法载入配置文件：" + err.Error())
		return
	}

	sec := f.Section("config")
	cfg.bindIP = sec.Key("host").MustString(cfg.bindIP)
	cfg.bindPort = sec.Key("port").MustInt(cfg.bindPort)
	cfg.erpVerify = sec.Key("verify").MustString(cfg.erpVerify)

	wechat.host = sec.Key("wcfHost").MustString(wechat.host)
	wechat.port = sec.Key("wcfPort").MustInt(wechat.port)

	if znlib.StrPos(wechat.host, "//") < 1 {
		wechat.host = "tcp://" + wechat.host
		//add protocol
	}
}

func main() {
	loadcfg()
	//load config first

	var list bool
	flag.BoolVar(&list, "list", false, "打印微信联系人 或 群成员列表")
	flag.Parse()

	if list {
		wechat.listContact()
		return
	}

	//  ---------------------------------------------------------------------------
	mx := http.NewServeMux()
	mx.HandleFunc("/cli", hand_FromERP)

	srv := http.Server{
		Addr:    net.JoinHostPort(cfg.bindIP, strconv.Itoa(cfg.bindPort)),
		Handler: mx,
	}

	go func() {
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			panic(err)
		}
	}()

	znlib.Info("服务已启动,主配置：" + fmt.Sprintf("%v", cfg))
	signalCh := make(chan os.Signal, 1)
	signal.Notify(signalCh, syscall.SIGINT, syscall.SIGTERM)
	sig := <-signalCh

	znlib.Info(fmt.Sprintf("Received signal: %v\n", sig))
	ctxTimeout, cancelTimeout := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancelTimeout()

	if err := srv.Shutdown(ctxTimeout); err != nil {
		select {
		case <-ctxTimeout.Done():
			// 由于达到超时时间服务器关闭，未完成优雅关闭
			znlib.Warn("timeout of 5 seconds.")
		default:
			// 其他原因导致的服务关闭异常，未完成优雅关闭
			znlib.Warn(fmt.Sprintf("Server shutdown failed: %v\n", err))
		}
		return
	}

	// 正确执行优雅关闭服务器
	znlib.Info("Server shutdown gracefully")
}
