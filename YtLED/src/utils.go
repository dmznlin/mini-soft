package main

import (
	"bytes"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"os/signal"
	"path/filepath"
	"syscall"
	"time"
	"unicode"
)

import (
	"golang.org/x/text/encoding/simplifiedchinese"
	"golang.org/x/text/transform"
)

const (
	LayoutDateTime = "2006-01-02 15:04:05" //日期 + 时间
)

type (
	Config struct {
		Port     string `json:"port"`     //通讯端口
		Baud     uint   `json:"baud"`     //波特率
		DataBits uint   `json:"databits"` //数据位
		StopBits uint   `json:"stopbits"` //停止位
		Parity   string `json:"parity"`   //校验位
		Card     byte   `json:"card"`     //屏卡地址
		Display  string `json:"display"`  //屏显格式
		Refresh  byte   `json:"refresh"`  //刷新频率,单位秒

		SlaveID  byte   `json:"slaveid"`  //从站ID
		Address  uint16 `json:"address"`  //数据地址
		Quantity uint16 `json:"quantity"` //
	}
)

var (
	gPath = filepath.Dir(os.Args[0])
	//运行目录
	gConfigFile = gPath + "/cfg/config.json"
	//配置文件
	gConfig = Config{
		Port:     "/dev/ttyUSB0",
		Baud:     4800,
		DataBits: 8,
		StopBits: 1,
		Parity:   "none",
		SlaveID:  1,
		Address:  1,
		Quantity: 10,
		Card:     1,
		Display:  "时间$T温度 $W℃",
		Refresh:  1,
	}
)

//-------------------------------------------------------------------------------

// log 2026-02-04 18:24:03
/*
 参数: event,待显示内容
 描述: 打印日志
*/
func log(event string, ext ...any) {
	fmt.Printf(time.Now().Format(LayoutDateTime)+"\t"+event+"\r\n", ext[0:]...)
}

// LoadConfig 2026-01-26 17:49:30
/*
 参数: cfg, 配置文件
 描述: 载入token配置信息
*/
func LoadConfig(cfg string) error {
	dt, err := os.ReadFile(cfg)
	if err != nil {
		return fmt.Errorf("读取配置失败: %w", err)
	}

	fmt.Println("配置信息: \r\n", string(dt))
	//打印配置

	if err := json.Unmarshal(dt, &gConfig); err != nil {
		return fmt.Errorf("解析JSON失败: %w", err)
	}

	return nil
}

// SaveConfig 2026-01-26 17:49:53
/*
 参数: cfg, 配置文件
 描述: 保存token信息到cfg中
*/
func SaveConfig(cfg string) error {
	dt, err := json.MarshalIndent(gConfig, "", "  ")
	if err != nil {
		return fmt.Errorf("打包JSON失败: %w", err)
	}

	if err := os.WriteFile(cfg, dt, 0644); err != nil {
		return fmt.Errorf("保存配置失败: %w", err)
	}

	return nil
}

// FileExists 2022-05-30 13:24:34
/*
 参数: file,路径
 参数: isDir,是否文件夹
 描述: 判断file是否能存在
*/
func FileExists(file string, isDir bool) bool {
	info, err := os.Stat(file)
	switch {
	case err == nil:
		if isDir {
			return info.IsDir()
		}
		return true
	case os.IsNotExist(err):
		return false
	default:
		return false
	}
}

// WaitSystemExit 2022-06-08 15:24:34
/*
 描述: 捕捉操作系统关闭信号,执行清理后退出
*/
func WaitSystemExit() {
	// 程序无法捕获信号 SIGKILL 和 SIGSTOP （终止和暂停进程），因此 os/signal 包对这两个信号无效。
	signals := []os.Signal{syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT}
	ch := make(chan os.Signal, 1)
	signal.Notify(ch, signals...)

	s := <-ch //阻塞
	close(ch)
	log("信号:" + s.String() + ",系统退出.")
}

// StrBin2Hex 2024-04-17 20:49:46
/*
 参数: bin,字节数组
 参数: blank,是否添加空格
 描述: 将bin数组格式化为16进制字符串
*/
func StrBin2Hex(bin []byte, blank bool) (dst []byte, ok bool) {
	idx := hex.EncodedLen(len(bin))
	if idx < 1 {
		return nil, false
	}

	blank = blank && idx >= 4
	//每两个字节补一个空格
	if blank {
		idx = idx + idx/2 - 1
	}

	dst = make([]byte, idx)
	cur := hex.Encode(dst, bin)
	//编码

	if blank {
		idx = idx - 1
		cur = cur - 1
		//末尾索引

		for cur > 1 {
			dst[idx] = dst[cur]
			dst[idx-1] = dst[cur-1]
			dst[idx-2] = byte(32) //空格

			cur = cur - 2
			idx = idx - 3
			//前移索引指针
		}
	}

	return dst, true
}

// StrHexFilter 2024-04-25 22:04:51
/*
 参数: sHex,16进制字符串
 描述: 过滤sHex中的无效字符
*/
func StrHexFilter(sHex []byte) (dst []byte, ok bool) {
	sLen := len(sHex)
	if sLen < 2 { //空字符串
		return nil, false
	}

	validator := func(val byte) bool {
		return (val >= '0' && val <= '9') || (val >= 'a' && val <= 'f') || (val >= 'A' && val <= 'F')
		//有效字符: 0-9,a-f,A-F
	}

	var valid int = 0
	for _, v := range sHex {
		if validator(v) {
			valid++
		}
	}

	if valid == sLen {
		return sHex, true
		//全部是有效字符
	}

	if valid < 1 {
		return nil, false
		//全部是无效字符
	}

	dst = make([]byte, valid)
	cur := 0 //当前索引
	for _, v := range sHex {
		if validator(v) { //有效字符
			dst[cur] = v
			cur++ //next
		}
	}

	return dst, true
}

// StrHex2Bin 2024-04-17 20:32:59
/*
 参数: sHex,16进制字符串
 参数: filter,过滤无效字符
 描述: 将16进制编码为2进制数据
*/
func StrHex2Bin(sHex []byte, filter bool) (bin []byte, ok bool) {
	if filter {
		sHex, ok = StrHexFilter(sHex) //无效字符处理
		if !ok {
			return nil, false
		}
	}

	var err error
	bin, err = hex.DecodeString(string(sHex))
	if err != nil {
		log("znlib.strings.StrHex2Bin: %s", err.Error())
		return nil, false
	}

	return bin, true
}

// StrPosFrom 2022-05-30 13:44:04
/*
 参数: str,字符串
 参数: sub,子字符串
 参数: from,开始索引
 描述: 检索sub在str中的位置,不区分大小写
*/
func StrPosFrom(str, sub []rune, from int) int {
	lstr := len(str)
	lsub := len(sub)
	if lstr < 1 || lsub < 1 {
		return -1
	}

	compare := func(a, b rune) bool {
		return a == b || (unicode.IsLower(a) && unicode.ToUpper(a) == b) || (unicode.IsUpper(a) && unicode.ToLower(a) == b)
		//忽略大小写
	}

	var match bool
	for idx := from; idx < lstr; idx++ {
		if !compare(str[idx], sub[0]) {
			continue
			//匹配首字母
		}

		match = true
		for i := 1; i < lsub; i++ {
			if idx+i >= lstr {
				match = false
				break
				//已超出字符串长度
			}

			if !compare(str[idx+i], sub[i]) {
				match = false
				break
				//子字符串未匹配
			}
		}

		if match {
			return idx
		}
	}

	return -1
}

// StrReplace 2022-05-30 13:43:26
/*
 参数: str,字符串
 参数: new,新字符串
 参数: old,现有字符串
 描述: 使用new替换str中的old字符串,不区分大小写
*/
func StrReplace(str string, new string, old ...string) string {
	if old == nil || len(str) < 1 {
		return str
	}

	var idx, pos, sublen int
	var update = true //需更新strBuf
	var strBuf = make([]rune, 0, 20)
	var subBuf = make([]rune, 0, 10)

	for _, tmp := range old {
		subBuf = append(subBuf[0:0], []rune(tmp)...)
		sublen = len(subBuf)
		if sublen < 1 { //旧字符串为空
			continue
		}

		if update {
			update = false
			strBuf = append(strBuf[0:0], []rune(str)...)
		}

		idx = 0
		pos = StrPosFrom(strBuf, subBuf, idx)
		for pos >= 0 {
			update = true
			if idx == 0 {
				str = ""
				//重新配置字符串
			}

			str = str + string(strBuf[idx:pos]) + new
			idx = pos + sublen
			pos = StrPosFrom(strBuf, subBuf, idx)
		}

		if update {
			if idx < len(strBuf) {
				str = str + string(strBuf[idx:])
			}

		}
	}

	return str
}

// EncodeToGB2312TwoBytes 2026-02-04 22:42:37
/*
 参数: s,中英混合原始字符串（Go默认UTF-8编码）
 描述: GB2312编码后的2字节定长切片，错误信息（非GB2312字符会触发错误）
*/
func EncodeToGB2312TwoBytes(s string) ([]byte, error) {
	// 空输入校验
	if len(s) == 0 {
		return nil, errors.New("输入字符串不能为空")
	}

	var result []byte
	// 初始化GB2312编码器（官方库，原生支持UTF-8→GB2312）
	encoder := simplifiedchinese.GBK.NewEncoder()

	// 遍历每个Unicode码点（rune），单字符处理避免字节拆分
	for _, r := range s {
		charStr := string(r) // 单个字符转为字符串，保证编码完整性
		// 新建字节缓冲区，用于接收编码后的字节
		var buf bytes.Buffer
		// 执行编码：UTF-8 → GB2312，将结果写入buf
		_, err := transform.NewWriter(&buf, encoder).Write([]byte(charStr))
		if err != nil {
			return nil, fmt.Errorf("字符 %q 非GB2312可编码字符，转换失败：%w", charStr, err)
		}

		gbBytes := buf.Bytes() // 获取单个字符的GB2312编码字节
		// 按GB2312特性处理：ASCII(1字节)补高位0x00，汉字(2字节)直接拼接
		switch len(gbBytes) {
		case 1:
			// ASCII字符：高位0x00 + 原始ASCII字节，保证2字节
			result = append(result, gbBytes[0])
		case 2:
			// GB2312汉字：直接使用原生2字节编码，无需额外处理
			result = append(result, gbBytes...)
		default:
			// 理论上不会触发，GB2312仅支持1/2字节编码
			return nil, fmt.Errorf("字符 %q 转换后字节数异常：%d字节", charStr, len(gbBytes))
		}
	}

	return result, nil
}
