// Package main
/******************************************************************************
  作者: dmzn@163.com 2026-02-11 14:59:34
  描述: 系统常量定义
******************************************************************************/
package main

import (
	"time"

	"github.com/dmznlin/znlib-go/znlib/modbus"
)

// LinkType 链路通讯类型
type LinkType byte

const (
	RTU LinkType = iota + 1
	RTUOverTCP
	RTUOverUDP
	TCP
	TcpTls
	UDP
	UserMem
	UserTcp
	UserHttp
)

// LinkComment 通讯类型描述
var LinkComment = []struct {
	link LinkType //通讯类型
	url  string   //地址格式
}{
	{RTU, "rtu://"},
	{RTUOverTCP, "rtuovertcp://"},
	{RTUOverUDP, "rtuoverudp://"},
	{TCP, "tcp://"},
	{TcpTls, "tcp+tls://"},
	{UDP, "udp://"},
	{UserMem, "mem://"},
	{UserTcp, "user+tcp://"},
	{UserHttp, "user+http://"},
}

// LinkConfig 连接参数
type LinkConfig struct {
	Name          string        `json:"name"`     //链路名称
	Url           string        `json:"url"`      //站点地址
	Type          LinkType      `json:"-"`        //连接类型
	BaudRate      uint          `json:"baudRate"` //波特率
	DataBits      uint          `json:"dataBits"` //数据位
	Parity        uint          `json:"parity"`   //校验位
	StopBits      uint          `json:"stopBits"` //启停为
	TLSClientCert string        `json:"certfile"`
	TLSClientKey  string        `json:"keyfile"` //客户端 X509KeyPair
	TLSRootCA     string        `json:"cafile"`  //根证书文件
	Timeout       time.Duration `json:"timeout"` //读超时

	LastErr string               `json:"-"` //最后异常
	LastLog time.Time            `json:"-"` //最后记录时间
	Client  *modbus.ModbusClient `json:"-"` //modbus客户端
}

// DataType 数据类型
type DataType byte

const (
	Bools DataType = iota + 1
	Uint16
	Int16
	Uint32
	Int32
	Float32
	Uint64
	Int64
	Float64
	Bytes
)

// DataComment 数据类型描述
var DataComment = []struct {
	data DataType
	comm string
}{
	{Bools, "bool"},
	{Uint16, "uint16"},
	{Int16, "int16"},
	{Uint32, "uint32"},
	{Int32, "int32"},
	{Float32, "float32"},
	{Uint64, "uint64"},
	{Int64, "int64"},
	{Float64, "float64"},
	{Bytes, "bytes"},
}

// SlaveAddr 从站数据地址
type SlaveAddr struct {
	Addr       uint16   `json:"addr"`     //数据地址
	DataType   DataType `json:"-"`        //数据类型
	DataComm   string   `json:"type"`     //类型描述
	Quantity   uint16   `json:"quantity"` //数据长度
	Coils      []bool   `json:"-"`        //线圈
	HoldingReg []uint16 `json:"-"`        //寄存器
}

// Slaver modbus从站
type Slaver struct {
	Name      string            `json:"name"`      //站点名称
	UnitID    uint8             `json:"unit"`      //站点编号
	LinkName  string            `json:"link"`      //通道名称
	Link      *LinkConfig       `json:"-"`         //连接通道
	Endianess modbus.Endianness `json:"endianess"` //16位大小端
	WordOrder modbus.WordOrder  `json:"wordOrder"` //32位双字节顺序
	Addrs     []SlaveAddr       `json:"addrs"`     //数据地址列表
}

type LocalConfig struct {
	Service     string        `json:"server"`      //本地服务地址
	Timeout     time.Duration `json:"timeout"`     //连接空闲断开,单位秒
	MaxClients  uint          `json:"maxconn"`     //最大连接数
	MaxQuantity uint16        `json:"maxquantity"` //最大自定义内存
}

// Devices 设备清单
var Devices = struct {
	Local   LocalConfig   `json:"local"`   //本地配置
	Links   []*LinkConfig `json:"links"`   //链路列表
	Slavers []*Slaver     `json:"slavers"` //从站列表
}{
	Local: LocalConfig{
		Service:     "tcp://:5502",
		Timeout:     30,
		MaxClients:  5,
		MaxQuantity: 255,
	},
	Slavers: []*Slaver{},
	Links:   []*LinkConfig{},
}
