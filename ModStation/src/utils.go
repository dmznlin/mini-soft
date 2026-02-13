package main

import (
	"crypto/tls"
	"encoding/json"
	"fmt"
	"os"
	"strings"
	"time"

	"github.com/dmznlin/znlib-go/znlib"
	"github.com/dmznlin/znlib-go/znlib/modbus"
)

//-------------------------------------------------------------------------------

// LoadSlavers 2026-01-26 17:49:30
/*
 参数: cfg, 配置文件
 描述: 载入从站配置信息
*/
func LoadSlavers(cfg string) error {
	df, err := os.ReadFile(cfg)
	if err != nil {
		return fmt.Errorf("读取配置失败: %w", err)
	}

	if err = json.Unmarshal(df, &Devices); err != nil {
		return fmt.Errorf("解析配置失败: %w", err)
	}

	var lt LinkType
	for _, link := range Devices.Links {
		if link.Type == TcpTls {
			if !znlib.FileExists(link.TLSClientCert, false) {
				return fmt.Errorf("通道 %s.certfile 配置错误: 文件丢失", link.Name)
			}

			if !znlib.FileExists(link.TLSClientKey, false) {
				return fmt.Errorf("通道 %s.keyfile 配置错误: 文件丢失", link.Name)
			}

			if !znlib.FileExists(link.TLSRootCA, false) {
				return fmt.Errorf("通道 %s.cafile 配置错误: 文件丢失", link.Name)
			}
		}

		link.Url = strings.ToLower(link.Url)
		// 通讯协议为小写

		lt, err = Str2LinkType(link.Url)
		if err != nil {
			return fmt.Errorf("通道 %s.url 配置错误: %s", link.Name, err.Error())
		}

		link.Type = lt
	}

	for _, slaver := range Devices.Slavers {
		for idx, link := range Devices.Links {
			if strings.EqualFold(link.Name, slaver.LinkName) {
				slaver.Link = Devices.Links[idx]
				break
			}
		}

		if slaver.Link == nil {
			return fmt.Errorf("从站 %s.link 未找到(%s)通道.", slaver.Name, slaver.LinkName)
		}

		var dt DataType
		var dts []DataType = []DataType{}
		//从站支持的数据类型

		for idx, addr := range slaver.Addrs {
			dt, err = Str2DataType(addr.DataComm)
			if err != nil {
				return fmt.Errorf("从站 %s.%d.type 配置错误: %s", slaver.Name, addr.Addr, err.Error())
			}

			slaver.Addrs[idx].DataType = dt
			//更新数据类型
			dts = append(dts, dt)
		}

		if slaver.Link.Type == UserMem { //内存数据,验证同类型数据边界重叠
			for _, dt = range dts {
				for i, a := range slaver.Addrs {
					if a.DataType != dt {
						continue
					}

					al := len(slaver.Addrs)
					for j := i + 1; j < al; j++ {
						if slaver.Addrs[j].DataType != dt {
							continue
						}

						if ((a.Addr >= slaver.Addrs[j].Addr) &&
							(a.Addr < slaver.Addrs[j].Addr+slaver.Addrs[j].Quantity)) || //a的起始地址,落在j区间内
							((a.Addr+a.Quantity-1 >= slaver.Addrs[j].Addr) &&
								(a.Addr+a.Quantity-1 < slaver.Addrs[j].Addr+slaver.Addrs[j].Quantity)) { //a的结束地址,落在j区间内
							return fmt.Errorf("从站 %s.addrs(%d-%d) 配置错误: 数据边界重叠", slaver.Name, a.Addr, slaver.Addrs[j].Addr)
						}
					}

					if dt == Bools { //申请空间
						slaver.Addrs[i].Coils = make([]bool, a.Quantity)
					} else {
						slaver.Addrs[i].HoldingReg = make([]uint16, a.Quantity)
					}
				}
			}
		}
	}

	return nil
}

// SaveSlavers 2026-01-26 17:49:53
/*
 参数: cfg, 配置文件
 描述: 保存token信息到cfg中
*/
func SaveSlavers(cfg string) error {
	dt, err := json.MarshalIndent(&Devices, "", "  ")
	if err != nil {
		return fmt.Errorf("打包JSON失败: %w", err)
	}

	if err := os.WriteFile(cfg, dt, 0644); err != nil {
		return fmt.Errorf("保存配置失败: %w", err)
	}

	return nil
}

// SlaverModal 2026-02-11 16:24:26
/*
 描述: 从站示例
*/
func SlaverModal() {
	slaver := Slaver{
		Name:      "示例",
		UnitID:    1,
		LinkName:  "link-com1",
		Link:      nil,
		Endianess: modbus.BIG_ENDIAN,
		WordOrder: modbus.HIGH_WORD_FIRST,

		Addrs: []SlaveAddr{{
			Addr:     0,
			DataComm: "uint16",
			Quantity: 10,
		}, {
			Addr:     10,
			DataComm: "bool",
			Quantity: 10,
		}},
	}

	Devices.Slavers = append(Devices.Slavers, &slaver)
	//从站模板

	link := LinkConfig{
		Name:          "link-com1",
		Url:           "rtu:///dev/ttyUSB0",
		Type:          RTU,
		BaudRate:      9600,
		DataBits:      8,
		Parity:        modbus.PARITY_NONE,
		StopBits:      1,
		TLSClientCert: "",
		TLSClientKey:  "",
		TLSRootCA:     "",
		Timeout:       300,
	}

	Devices.Links = append(Devices.Links, &link)
}

//-------------------------------------------------------------------------------

// LinkType2Str 2026-02-12 10:14:56
/*
 参数: lt,链路类型
 描述: 返回 lt 的描述
*/
func LinkType2Str(lt LinkType) (string, error) {
	for _, link := range LinkComment {
		if link.link == lt {
			return link.url, nil
		}
	}

	return "", fmt.Errorf("未知的连接类型(%d)", lt)
}

// Str2LinkType 2026-02-12 10:21:15
/*
 参数: lt,连接类型描述
 描述: 返回 lt 对应的连接类型
*/
func Str2LinkType(lt string) (LinkType, error) {
	for _, link := range LinkComment {
		if strings.HasPrefix(lt, link.url) {
			return link.link, nil
		}
	}

	return 0, fmt.Errorf("未知的连接类型(%s)", lt)
}

// DataType2Str 2026-02-11 16:55:49
/*
 参数: dt,数据类型
 描述: 返回 dt 的描述
*/
func DataType2Str(dt DataType) (string, error) {
	for _, comm := range DataComment {
		if comm.data == dt {
			return comm.comm, nil
		}
	}

	return "", fmt.Errorf("未知的数据类型(%d)", dt)
}

// Str2DataType 2026-02-11 16:57:49
/*
 参数: dt,数据类型描述
 描述: 返回 dt 对应的数据类型
*/
func Str2DataType(dt string) (DataType, error) {
	for _, comm := range DataComment {
		if strings.EqualFold(dt, comm.comm) {
			return comm.data, nil
		}
	}

	return 0, fmt.Errorf("未知的数据类型(%s)", dt)
}

// GetSlaver 2026-02-12 10:41:53
/*
 参数: id,从站编号
 参数：adr,数据地址
 描述: 获取编号为 id 的从站
*/
func GetSlaver(id uint8) *Slaver {
	for _, slaver := range Devices.Slavers {
		if slaver.UnitID == id {
			return slaver
		}
	}
	return nil
}

// GetSlaverAddr 2026-02-12 19:28:25
/*
 参数: slaver, 从站
 参数: dt,数据类型
 参数: addr, 地址
 参数: quantity, 数据长度
 描述: 获取 slaver 可以满足读取 addr.quantity 的地址
*/
func GetSlaverAddr(slaver *Slaver, dt DataType, addr uint16, quantity uint16) (address int, err error) {
	if slaver.Link.Type != UserMem {
		return -1, fmt.Errorf("slaver %s not user-mem", slaver.Name)
	}

	for idx, ad := range slaver.Addrs {
		if ad.DataType != dt {
			continue
		}

		if addr >= ad.Addr && addr < ad.Addr+ad.Quantity { //基地址匹配
			if addr+quantity > ad.Addr+ad.Quantity {
				return -1, fmt.Errorf("slaver %s.addr(%d) no enough data", slaver.Name, ad.Addr)
			}

			return idx, err
		}
	}

	tp, err := DataType2Str(dt)
	if err != nil {
		return -1, err
	}
	return -1, fmt.Errorf("slaver %s(%s.%d.%d) no match data", slaver.Name, tp, addr, quantity)
}

// PrepareLink 2026-02-12 11:02:51
/*
 参数: slaver,从站
 描述: 准备 slaver 连接通道
*/
func PrepareLink(slaver *Slaver) (err error) {
	if slaver.Link.Type <= UDP { //标准modbus
		if slaver.Link.Client == nil {
			var cfg *modbus.ClientConfiguration
			if slaver.Link.Type == RTU {
				cfg = &modbus.ClientConfiguration{
					URL:      slaver.Link.Url,
					Speed:    slaver.Link.BaudRate,
					DataBits: slaver.Link.DataBits,
					StopBits: slaver.Link.StopBits,
					Parity:   slaver.Link.Parity,
					Timeout:  slaver.Link.Timeout * time.Millisecond,
				}
			} else {
				cfg = &modbus.ClientConfiguration{
					URL:     slaver.Link.Url,
					Timeout: slaver.Link.Timeout * time.Millisecond,
				}

				if slaver.Link.Type == TcpTls {
					clientKeyPair, err := tls.LoadX509KeyPair(slaver.Link.TLSClientCert, slaver.Link.TLSClientKey)
					if err != nil {
						return fmt.Errorf("failed to load client tls key pair: %v\n", err)
					}
					cfg.TLSClientCert = &clientKeyPair

					cfg.TLSRootCAs, err = modbus.LoadCertPool(slaver.Link.TLSRootCA)
					if err != nil {
						return fmt.Errorf("failed to load client tls key pair: %v\n", err)
					}
				}
			}

			slaver.Link.Client, err = modbus.NewClient(cfg)
			if err != nil {
				return fmt.Errorf("failed to create client: %v\n", err)
			}
		}

		err = slaver.Link.Client.SetEncoding(slaver.Endianess, slaver.WordOrder)
		if err != nil {
			return fmt.Errorf("failed to set encoding: %v\n", err)
		}

		slaver.Link.Client.SetUnitId(slaver.UnitID)

		// connect to the remote host/open the serial port
		err = slaver.Link.Client.Open()
		if err != nil {
			return fmt.Errorf("failed to open client: %v\n", err)
		}
	}

	return nil
}
