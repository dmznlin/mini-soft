/*
Package main
*******************************************************************************
作者: dmzn@163.com 2023-12-30 21:48:10
描述: 扫描erp数据库，依照模板发送微信消息
*******************************************************************************
*/
package main

import (
	"bytes"
	"context"
	"errors"
	"fmt"
	. "github.com/dmznlin/znlib-go/znlib"
	_ "github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
	"html/template"
	"io"
	"os"
	"reflect"
	"strings"
	"time"
)

// 数据变更记录
type erpEvent struct {
	Rid    int64  `db:"r_id"`
	Table  string `db:"e_table"`
	Record string `db:"e_record"`
	WxID   string `db:"e_wxid"`
	At     string `db:"e_at"`
	Temp   string `db:"e_template"`
	Fields string `db:"e_fields"`
}

var (
	// 变更数据
	dataEvent erpEvent

	// 表名称
	tableEvent = "erp_event"

	// 查询变动数据
	sqlEvent = fmt.Sprintf("select %s from %s where e_valid=true "+
		"order by e_record asc", SQLFields(dataEvent), tableEvent)

	// 微信消息模板
	wxTemplate = make(map[string]string)

	// 扫描终止信号
	scanStop = make(chan struct{})
)

/*
ScanDataToWechat 2023-12-30 21:50:37
描述: 扫描数据库并发送微信
*/
func ScanDataToWechat() {
	timer := time.Now().Add(time.Duration(cfg.scanInterval) * time.Second)
	//计时器

loop:
	for true {
		select {
		case <-scanStop: //停止信号
			break loop
		default: //休眠1个单位
			time.Sleep(100 * time.Millisecond)
			if timer.After(time.Now()) { //未到时间
				continue
			}
		}

		timer = time.Now().Add(time.Duration(cfg.scanInterval) * time.Second)
		//重置计时器
		doScan()
	}

	Info("停止扫描数据库.")
	scanStop <- struct{}{}
	//set has stop flag
}

/*
stopScanData 2023-12-30 21:58:55
参数: ctx,
描述: 停止扫描
*/
func stopScanData(ctx context.Context) {
	scanStop <- struct{}{}
	//set stop flag

	<-scanStop
	//wait for stop
}

/*
doScan 2023-12-30 22:45:18
描述: 执行扫描
*/
func doScan() {
	defer DeferHandle(false, "ScanDataToWechat.doScan")
	//捕捉异常

	db, err := DBManager.GetDB(DBManager.DefaultName)
	if err != nil {
		panic(err)
	}

	rows, err := db.Queryx(sqlEvent)
	if err != nil {
		panic(err)
	}

	defer rows.Close()
	//若异常则手动关闭

	var status = struct {
		maxID      int64  //最大id号
		lastRecord string //最后记录的ID
	}{
		0,
		"",
	}

	for rows.Next() {
		err := rows.StructScan(&dataEvent)
		if err != nil {
			panic(err)
		}

		if dataEvent.Record == status.lastRecord {
			continue
		} //重复记录不予处理

		status.lastRecord = dataEvent.Record
		if doSendWechat(db) {
			str := fmt.Sprintf("update %s set e_valid=false where r_id=%d", tableEvent, dataEvent.Rid)
			db.MustExec(str)
		}
	}
}

/*
doSendWechat 2023-12-31 22:43:38
描述: 将 dataEvent 描述的数据发送至微信
*/
func doSendWechat(db *sqlx.DB) (isok bool) {
	isok = false
	defer func() {
		err := recover()
		if err != nil {
			isok = false
			Error(err, LogFields{"caller": "ScanDataToWechat.doSendWechat"})
		}
	}() //捕获异常

	var wxData = struct {
		query string   //查询
		temp  string   //模板
		at    []string //@列表
	}{
		"",
		"",
		make([]string, 0),
	}

	//  ---------------------------------------------------------------------------
	wxData.temp = wxTemplate[dataEvent.Temp]
	if wxData.temp == "" { //读取并缓存模板
		wxData.temp = StrReplace(dataEvent.Temp, AppPath, "$path/")
		if !FileExists(wxData.temp, false) {
			panic(errors.New(fmt.Sprintf("模板 %s 不存在", wxData.temp)))
		}

		file, err := os.Open(wxData.temp)
		if err != nil {
			panic(err)
		}

		defer file.Close()
		bytes, err := io.ReadAll(file)
		if err != nil {
			panic(err)
		}

		wxData.temp = string(bytes)
		wxTemplate[dataEvent.Temp] = wxData.temp
	}

	//  ---------------------------------------------------------------------------
	wxData.query = fmt.Sprintf("select %s from %s where record_id=%s",
		dataEvent.Fields, dataEvent.Table, dataEvent.Record)
	//xxxxx

	rows, err := db.Queryx(wxData.query)
	if err != nil {
		panic(err)
	}

	defer rows.Close()
	for rows.Next() {
		cur := make(map[string]interface{})
		err := rows.MapScan(cur)
		if err != nil {
			panic(err)
		}

		for k, v := range cur { //将value转为字符串
			t := reflect.TypeOf(v)
			if t != nil {
				switch t.Kind() {
				case reflect.Slice:
					cur[k] = fmt.Sprintf("%s", v)

				default:
					// do nothing
				}
			}
		}

		//  ---------------------------------------------------------------------------
		list := strings.Split(dataEvent.At, ",")
		// 需@ID列表,字段 或 $wxid,逗号分割

		for _, v := range list {
			if StrPos(v, "$") == 0 { //微信ID
				wxData.at = append(wxData.at, StrDel(v, 0, 0))
				continue
			}

			val := cur[v]
			if val != nil {
				id := val.(string)
				if id != "" { //无对应字段
					wxData.at = append(wxData.at, id)
				}
			}
		}

		//  ---------------------------------------------------------------------------
		tmp, err := template.New("wx").Parse(wxData.temp)
		if err != nil {
			panic(err)
		}

		buf := new(bytes.Buffer)
		err = tmp.Execute(buf, cur)
		if err != nil {
			panic(err)
		}

		if !wechat.init() { //需保证微信在线
			return false
		}

		at_str := ""
		for _, v := range wxData.at {
			alias := wechat.cli.CmdClient.GetAliasInChatRoom(v, dataEvent.WxID)
			if alias == "" {
				alias = v
			}
			at_str = at_str + fmt.Sprintf("@%s ", alias)
		}

		if at_str != "" {
			at_str = "\n\n" + at_str
		}
		wechat.cli.CmdClient.SendTxt(buf.String()+at_str, dataEvent.WxID, strings.Join(wxData.at, ","))
		//发送微信消息，并 @ 主要人员
		Info(fmt.Sprintf("SendMessage: %s.%s -> %s", dataEvent.Table, dataEvent.Record, dataEvent.WxID))
	}

	return true
}
