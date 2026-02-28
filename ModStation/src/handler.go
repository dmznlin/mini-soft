// Package main
/******************************************************************************
  作者: dmzn@163.com 2026-02-11 22:33:19
  描述: modbus数据处理器
******************************************************************************/
package main

import (
	"fmt"
	"io"
	"modstation/comm"
	"net"
	"net/url"
	"sync"
	"time"

	"github.com/dmznlin/znlib-go/znlib"
	"github.com/dmznlin/znlib-go/znlib/modbus"
)

// DealErrorLink 2026-02-12 16:53:11
/*
 参数: slaver,从站
 参数: err,错误
 描述: 处理 slaver 发生异常
*/
func DealErrorLink(slaver *Slaver, err error) {
	DealErrorLog(slaver.Link, err)
	// print log first

	if slaver.Link.Type != RTU { //网络异常
		_, ok := err.(*net.OpError)
		if ok { //网络错误
			slaver.Link.Client.Close()
		}
	} else { //串口异常

	}
}

// DealErrorLog 2026-02-12 17:11:59
/*
 参数: link,链路
 参数: err,错误
 描述: 处理 link 的异常日志,合并相同日志
*/
func DealErrorLog(link *LinkConfig, err error) {
	if err.Error() != link.LastErr {
		link.LastErr = err.Error()
		link.LastLog = time.Now()
		znlib.Error(link.LastErr)
	}
}

//-------------------------------------------------------------------------------

// stationHandler 处理器
type stationHandler struct {
	lock sync.RWMutex //同步锁定
}

func NewHandler() *stationHandler {
	return &stationHandler{
		lock: sync.RWMutex{},
	}
}

func (s stationHandler) HandleCoils(req *modbus.CoilsRequest) (res []bool, err error) {
	defer znlib.DeferHandle(false, "HandleCoils")
	//default panic handle

	slaver := GetSlaver(req.UnitId)
	if slaver == nil {
		err = fmt.Errorf("no slaver with unit(%d).addr(%d)", req.UnitId, req.Addr)
		znlib.Error(err)
		return nil, err
	}

	s.lock.Lock()
	defer s.lock.Unlock()

	if slaver.Link.Type == UserMem { //内存数据
		addr, err := GetSlaverAddr(slaver, Bools, req.Addr, req.Quantity)
		if err != nil {
			DealErrorLog(slaver.Link, err)
			return nil, err
		}

		base := int(req.Addr - slaver.Addrs[addr].Addr)
		if req.IsWrite {
			for i, dt := range req.Args {
				slaver.Addrs[addr].Coils[base+i] = dt
			}
		}

		return slaver.Addrs[addr].Coils[base : base+int(req.Quantity)], nil
	}

	err = PrepareLink(slaver)
	if err != nil {
		DealErrorLog(slaver.Link, err)
		return nil, err
	}

	// ----------------------------------------------------------------------------
	if slaver.Link.Type == UserHttp || slaver.Link.Type == UserHttps { //读写 http
		if req.IsWrite { //写入数据
			buf := comm.Bool2Bytes(req.Args)
			dt, err := znlib.NewEncrypter(znlib.EncryptBase64_STD, nil).EncodeBase64(buf)
			if err != nil {
				DealErrorLog(slaver.Link, err)
				return nil, err
			}

			url := fmt.Sprintf("%s?act=2&id=%d&type=1&addr=%d&len=%d&end=%d&data=%s", slaver.Link.Url,
				req.UnitId, req.Addr, req.Quantity, slaver.Endianess, url.QueryEscape(string(dt)))
			resp, err := slaver.Link.HttpClient.Get(url)

			if err != nil {
				DealErrorLog(slaver.Link, err)
				return nil, err
			}

			defer resp.Body.Close()
			bd, err := io.ReadAll(resp.Body)
			if err != nil {
				DealErrorLog(slaver.Link, err)
				return nil, err
			}

			if resp.StatusCode != 200 {
				err = fmt.Errorf("HandleCoils.Http.Write: %s", string(bd))
				DealErrorLog(slaver.Link, err)
				return nil, err
			}

			return nil, nil
		} else { // 读取数据
			url := fmt.Sprintf("%s?act=1&id=%d&type=1&addr=%d&len=%d&end=%d", slaver.Link.Url,
				req.UnitId, req.Addr, req.Quantity, slaver.Endianess)
			resp, err := slaver.Link.HttpClient.Get(url)

			if err != nil {
				DealErrorLog(slaver.Link, err)
				return nil, err
			}

			defer resp.Body.Close()
			bd, err := io.ReadAll(resp.Body)
			if err != nil {
				DealErrorLog(slaver.Link, err)
				return nil, err
			}

			if resp.StatusCode != 200 {
				err = fmt.Errorf("HandleCoils.Http.Read: %s", string(bd))
				DealErrorLog(slaver.Link, err)
				return nil, err
			}

			dt, err := znlib.NewEncrypter(znlib.EncryptBase64_STD, nil).DecodeBase64(bd)
			if err != nil {
				DealErrorLog(slaver.Link, err)
				return nil, err
			}

			res = comm.Bytes2Bool(dt)
			return res, nil
		}
	}

	// ----------------------------------------------------------------------------
	if req.IsWrite { //写入数据
		res = nil
		err = slaver.Link.Client.WriteCoils(req.Addr, req.Args)
	} else { //读取数据
		res, err = slaver.Link.Client.ReadCoils(req.Addr, req.Quantity)
	}

	if err != nil {
		DealErrorLink(slaver, err)
	}

	return res, err
}

func (s stationHandler) HandleDiscreteInputs(req *modbus.DiscreteInputsRequest) (res []bool, err error) {
	defer znlib.DeferHandle(false, "HandleDiscreteInputs")
	//default panic handle

	panic("implement me")
}

func (s stationHandler) HandleHoldingRegisters(req *modbus.HoldingRegistersRequest) (res []uint16, err error) {
	defer znlib.DeferHandle(false, "HandleHoldingRegisters")
	//default panic handle

	slaver := GetSlaver(req.UnitId)
	if slaver == nil {
		err = fmt.Errorf("no slaver with unit(%d).addr(%d)", req.UnitId, req.Addr)
		znlib.Error(err)
		return nil, err
	}

	s.lock.Lock()
	defer s.lock.Unlock()

	if slaver.Link.Type == UserMem { //内存数据
		addr, err := GetSlaverAddr(slaver, Uint16, req.Addr, req.Quantity)
		if err != nil {
			DealErrorLog(slaver.Link, err)
			return nil, err
		}

		base := int(req.Addr - slaver.Addrs[addr].Addr)
		if req.IsWrite {
			for i, dt := range req.Args {
				slaver.Addrs[addr].HoldingReg[base+i] = dt
			}
		}

		return slaver.Addrs[addr].HoldingReg[base : base+int(req.Quantity)], nil
	}

	err = PrepareLink(slaver)
	if err != nil {
		DealErrorLog(slaver.Link, err)
		return nil, err
	}

	// ----------------------------------------------------------------------------
	if slaver.Link.Type == UserHttp || slaver.Link.Type == UserHttps { //读写 http
		if req.IsWrite { //写入数据
			buf := comm.Uint2Bytes(req.Args, slaver.Endianess == modbus.BIG_ENDIAN)
			dt, err := znlib.NewEncrypter(znlib.EncryptBase64_STD, nil).EncodeBase64(buf)
			if err != nil {
				DealErrorLog(slaver.Link, err)
				return nil, err
			}

			url := fmt.Sprintf("%s?act=2&id=%d&type=2&addr=%d&len=%d&end=%d&data=%s", slaver.Link.Url,
				req.UnitId, req.Addr, req.Quantity, slaver.Endianess, url.QueryEscape(string(dt)))
			resp, err := slaver.Link.HttpClient.Get(url)

			if err != nil {
				DealErrorLog(slaver.Link, err)
				return nil, err
			}

			defer resp.Body.Close()
			bd, err := io.ReadAll(resp.Body)
			if err != nil {
				DealErrorLog(slaver.Link, err)
				return nil, err
			}

			if resp.StatusCode != 200 {
				err = fmt.Errorf("HandleHoldingRegisters.Http.Write: %s", string(bd))
				DealErrorLog(slaver.Link, err)
				return nil, err
			}

			return nil, nil
		} else { // 读取数据
			url := fmt.Sprintf("%s?act=1&id=%d&type=2&addr=%d&len=%d&end=%d", slaver.Link.Url,
				req.UnitId, req.Addr, req.Quantity, slaver.Endianess)
			resp, err := slaver.Link.HttpClient.Get(url)

			if err != nil {
				DealErrorLog(slaver.Link, err)
				return nil, err
			}

			defer resp.Body.Close()
			bd, err := io.ReadAll(resp.Body)
			if err != nil {
				DealErrorLog(slaver.Link, err)
				return nil, err
			}

			if resp.StatusCode != 200 {
				err = fmt.Errorf("HandleHoldingRegisters.Http.Read: %s", string(bd))
				DealErrorLog(slaver.Link, err)
				return nil, err
			}

			dt, err := znlib.NewEncrypter(znlib.EncryptBase64_STD, nil).DecodeBase64(bd)
			if err != nil {
				DealErrorLog(slaver.Link, err)
				return nil, err
			}

			res, err = comm.Bytes2Uint(dt, slaver.Endianess == modbus.BIG_ENDIAN)
			if err != nil {
				DealErrorLog(slaver.Link, err)
				return nil, err
			}
		}

		return res, nil
	}

	// ----------------------------------------------------------------------------
	if req.IsWrite { //写入数据
		res = nil
		err = slaver.Link.Client.WriteRegisters(req.Addr, req.Args)
	} else { //读取数据
		res, err = slaver.Link.Client.ReadRegisters(req.Addr, req.Quantity, modbus.HOLDING_REGISTER)
	}

	if err != nil {
		DealErrorLink(slaver, err)
	}

	return res, err
}

func (s stationHandler) HandleInputRegisters(req *modbus.InputRegistersRequest) (res []uint16, err error) {
	defer znlib.DeferHandle(false, "HandleInputRegisters")
	//default panic handle

	panic("implement me")
}
