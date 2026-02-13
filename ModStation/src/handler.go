// Package main
/******************************************************************************
  作者: dmzn@163.com 2026-02-11 22:33:19
  描述: modbus数据处理器
******************************************************************************/
package main

import (
	"fmt"
	"net"
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
	//TODO implement me
	panic("implement me")
}

func (s stationHandler) HandleDiscreteInputs(req *modbus.DiscreteInputsRequest) (res []bool, err error) {
	//TODO implement me
	panic("implement me")
}

func (s stationHandler) HandleHoldingRegisters(req *modbus.HoldingRegistersRequest) (res []uint16, err error) {
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
	//TODO implement me
	panic("implement me")
}
