package main

import (
	"bytes"
	"encoding/binary"
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
	"github.com/go-restruct/restruct"
	"golang.org/x/text/encoding/simplifiedchinese"
	"golang.org/x/text/transform"
)

const (
	LayoutDateTime = "2006-01-02 15:04:05" //日期 + 时间

)

type (
	Config struct {
		Port     string `json:"port"`     //通讯端口
		Baud     int    `json:"baud"`     //波特率
		DataBits int    `json:"databits"` //数据位
		StopBits int    `json:"stopbits"` //停止位
		Parity   string `json:"parity"`   //校验位
		Card     byte   `json:"card"`     //屏卡地址
		Display  string `json:"display"`  //屏显格式

		SlaveID  byte   `json:"slaveid"`  //从站ID
		Address  byte   `json:"address"`  //数据地址
		Quantity uint16 `json:"quantity"` //
	}

	CardData struct {
		Prefix [10]byte //10个数据头
		Start  byte     //帧起始
		Ver    byte     //版本
		Addr   int16    //控制卡地址
		Cmd    byte     //命令字
		Ident  uint32   //识别标识
		Frame  uint32   //帧计数
		Len    int16    //数据长度
		Data   []byte   `struct:"sizefrom=Len"` //数据
		CRC    uint16   //校验
		End    byte     //结束帧
	}

	TextData struct {
		Area    int16  //显示分区ID
		Code    byte   //编码方式:0=unicode;1=gb2312
		Display byte   //显示方式:0=保存数据;2=立即显示
		Idx     byte   //字符串索引
		Color   byte   //1 = 红色;2 = 绿色;3 = 黄色;4 = 蓝色;5 = 紫色;6 = 青色;7 = 白色
		Len     int16  //数据长度
		Text    []byte `struct:"sizefrom=Len"` //数据
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
		Parity:   "N",
		SlaveID:  1,
		Address:  1,
		Quantity: 10,
		Card:     1,
		Display:  "时间$T温度 $W℃",
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

// EncodeToTwoBytes 2026-02-04 22:13:27
/*
 参数: s,中英混合的原始字符串
 描述: 按规则将中英混合字符串编码为[]byte，每个字符占2字节
*/
func EncodeToTwoBytes(s string) []byte {
	var result []byte
	// 遍历字符串的每个Unicode码点（rune），兼容中英字符
	for _, r := range s {
		// 按Unicode码点判断：ASCII字符（≤127）/非ASCII字符（汉字等）
		if r <= 127 {
			// 英文：高位填0x00，低位为字符本身的字节值
			result = append(result, 0x00, byte(r))
		} else {
			// 汉字：取Unicode码点的低两个字节（大端序，符合常规编码习惯）
			result = append(result, byte(r>>8), byte(r&0xFF))
		}
	}
	return result
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

// GetCRC 2026-02-04 23:43:32
/*
 参数: data,数据
 参数: len,有效长度
 描述: int16类型的CRC16校验结果（多项式0xA001，初始值0xFFFF）
*/
func GetCRC(data []byte, len uint16) uint16 {
	CRCFull := uint16(0xFFFF) // 初始值，直接用uint16（原C用uint32仅存低16位，此处更贴合实际）
	var CRCLSB uint8          // 存储CRC当前最低位

	// 外层循环：遍历指定长度的每个字节，与原C循环逻辑完全一致
	for i := uint16(0); i < len; i++ {
		// 与当前字节异或，类型强转对齐C的无符号运算
		CRCFull ^= uint16(data[i])
		// 内层循环：每个字节处理8位，逐位计算CRC
		for j := 0; j < 8; j++ {
			CRCLSB = uint8(CRCFull & 0x0001)  // 获取最低位
			CRCFull = (CRCFull >> 1) & 0x7FFF // 右移1位，保留15位有效位（最高位补0）
			if CRCLSB == 1 {
				CRCFull ^= 0xA001 // 最低位为1时，与多项式0xA001异或
			}
		}
	}

	return CRCFull // 直接返回uint16，无需类型转换
}

// BuildCardData 2026-02-04 23:18:53
/*
 参数: text,字符串
 描述: 使用gb2312编码,讲text打包 中航单双色屏卡 数据
*/
func BuildCardData(text string) ([]byte, error) {
	var err error
	var txt TextData
	txt.Text, err = EncodeToGB2312TwoBytes(text)
	if err != nil {
		return nil, err
	}

	txt.Code = 1
	txt.Display = 2
	txt.Idx = 0
	txt.Color = 1
	txt.Len = int16(len(txt.Text))

	var data CardData
	data.Data, err = restruct.Pack(binary.LittleEndian, &txt)
	if err != nil {
		return nil, err
	}

	buf, ok := StrHex2Bin([]byte("FF FF FF FF FF FF 00 00 00 00"), true)
	if !ok {
		return nil, err
	}

	for idx, b := range buf {
		data.Prefix[idx] = b
	}

	data.Start = 0x78
	data.Ver = 0x34
	data.Cmd = 0x29 //字符串更新
	data.Ident = binary.LittleEndian.Uint32([]byte{0xBC, 0xFD, 0x00, 0x00})
	data.Len = int16(len(data.Data))
	data.End = 0xA5

	buf, err = restruct.Pack(binary.LittleEndian, &data)
	if err != nil {
		return nil, err
	}

	data.CRC = GetCRC(buf[10:], uint16(len(buf)-13)) //前10个网络标记 + 末尾 3 个字节
	return restruct.Pack(binary.LittleEndian, &data)
}

// byte2Val 2026-02-06 17:13:40
/*
 参数: b,字节组
 描述: 双字节构建 温度/湿度 值
*/
func byte2Val(b []byte) uint16 {
	var num uint16
	buf := bytes.NewBuffer(b)
	err := binary.Read(buf, binary.BigEndian, &num)
	if err != nil {
		log("byte2Val: %s", err.Error())
		return 0
	}

	return num
}
