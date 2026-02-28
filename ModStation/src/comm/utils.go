// Package comm
/******************************************************************************
  作者: dmzn@163.com 2026-02-27 18:51:20
  描述: 模块公用函数
******************************************************************************/
package comm

import (
	"bytes"
	"encoding/binary"
	"fmt"

	binpacker "github.com/dmznlin/znlib-go/znlib/bin/packer"
)

// Bytes2Uint 2026-02-27 17:18:17
/*
 参数: data,数据
 参数: bigEndian,大小端
 描述: 将 data 转为 uint16 数组
*/
func Bytes2Uint(data []byte, bigEndian bool) (res []uint16, err error) {
	dl := len(data)
	if dl < 1 || dl%2 != 0 {
		return nil, fmt.Errorf("Bytes2Uint: 数据长度(%d)异常", dl)
	}

	buf := bytes.NewBuffer(data)
	var unpacker *binpacker.Unpacker
	if bigEndian {
		unpacker = binpacker.NewUnpacker(binary.BigEndian, buf)
	} else {
		unpacker = binpacker.NewUnpacker(binary.LittleEndian, buf)
	}

	idx := 0
	res = make([]uint16, dl/2)
	for i := 0; i < dl; i += 2 {
		val, err := unpacker.ShiftUint16()
		if err != nil {
			return nil, err
		}

		res[idx] = val
		idx++
	}

	return res, err
}

// Uint2Bytes 2026-02-27 17:20:12
/*
 参数: data,数据
 参数: bigEndian,大小端
 描述: 将 data 转为 byte 数组
*/
func Uint2Bytes(data []uint16, bigEndian bool) []byte {
	var packer *binpacker.Packer
	buf := new(bytes.Buffer)

	if bigEndian {
		packer = binpacker.NewPacker(binary.BigEndian, buf)
	} else {
		packer = binpacker.NewPacker(binary.LittleEndian, buf)
	}

	for _, dt := range data {
		packer.PushUint16(dt)
	}

	return buf.Bytes()
}

// Bytes2Bool 2026-02-28 11:04:53
/*
 参数: data,数据
 描述: 将 data 转为 bool 数组
*/
func Bytes2Bool(data []byte) (res []bool) {
	res = make([]bool, len(data))
	for i, d := range data {
		res[i] = d != 0
	}

	return res
}

// Bool2Bytes 2026-02-28 11:09:02
/*
 参数: data,数据
 描述: 将 data 转为 byte 数组
*/
func Bool2Bytes(data []bool) (res []byte) {
	res = make([]byte, len(data))
	for i, d := range data {
		if d {
			res[i] = 1
		} else {
			res[i] = 0
		}
	}

	return res
}
