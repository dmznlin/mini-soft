package main

import (
	"modstation/comm"
	"net/http"

	"github.com/dmznlin/znlib-go/znlib"
	"github.com/gin-gonic/gin"
)

var (
	Bool = make([]bool, 255)
	Uint = make([]uint16, 255)
)

type modbusData struct {
	Action    uint8  `form:"act" json:"act" binding:"required"`   //读取 1,写入 2
	UnitId    uint8  `form:"id" json:"id"`                        //从站编号
	Type      uint8  `form:"type" json:"type" binding:"required"` //线圈 1,存储器 2
	Addr      uint16 `form:"addr" json:"addr" `                   //数据地址
	Len       uint8  `form:"len" json:"len" binding:"required"`   //数据长度
	Endianess uint8  `form:"end" json:"end" binding:"required"`   //大端 1,小端 2
	Data      string `form:"data" json:"data" `                   //数据
}

func main() {
	srv := gin.Default()
	srv.GET("/modbus", func(ctx *gin.Context) {
		var req modbusData
		if err := ctx.ShouldBind(&req); err != nil {
			ctx.String(http.StatusBadRequest, "invalid request parameters")
			return
		}

		if req.Action == 1 { //读数据
			if req.Type == 1 { //读取线圈
				dt := comm.Bool2Bytes(Bool[req.Addr : req.Addr+uint16(req.Len)])
				buf, err := znlib.NewEncrypter(znlib.EncryptBase64_STD, nil).EncodeBase64(dt)
				if err != nil {
					ctx.String(http.StatusBadRequest, "invalid modbus data")
					return
				}

				ctx.String(http.StatusOK, string(buf))
				return
			} else { //读取寄存器
				dt := comm.Uint2Bytes(Uint[req.Addr:req.Addr+uint16(req.Len)], req.Endianess == 1)
				buf, err := znlib.NewEncrypter(znlib.EncryptBase64_STD, nil).EncodeBase64(dt)
				if err != nil {
					ctx.String(http.StatusBadRequest, "invalid modbus data")
					return
				}

				ctx.String(http.StatusOK, string(buf))
				return
			}
		}

		// --------------------------------------------------------------------------
		if req.Action == 2 { //写数据
			if req.Data == "" {
				ctx.String(http.StatusBadRequest, "invalid request parameters")
				return
			}

			if req.Type == 1 { //写线圈
				buf, err := znlib.NewEncrypter(znlib.EncryptBase64_STD, nil).DecodeBase64([]byte(req.Data))
				if err != nil {
					ctx.String(http.StatusBadRequest, "invalid modbus data: "+err.Error())
					return
				}

				dt := comm.Bytes2Bool(buf)
				for idx, val := range dt {
					Bool[req.Addr+uint16(idx)] = val
				}
			} else { //写寄存器
				buf, err := znlib.NewEncrypter(znlib.EncryptBase64_STD, nil).DecodeBase64([]byte(req.Data))
				if err != nil {
					ctx.String(http.StatusBadRequest, "invalid modbus data: "+err.Error())
					return
				}

				dt, err := comm.Bytes2Uint(buf, req.Endianess == 1)
				if err != nil {
					ctx.String(http.StatusBadRequest, "invalid modbus data: "+err.Error())
				}

				for idx, val := range dt {
					Uint[req.Addr+uint16(idx)] = val
				}
			}
		}

		ctx.String(http.StatusOK, "ok")
	})

	srv.Run(":8080")
}
