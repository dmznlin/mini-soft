/*
Package main
*******************************************************************************
作者: dmzn@163.com 2023-12-29 10:29:37
描述: http handle,处理 http 业务
*******************************************************************************
*/
package main

import (
	"fmt"
	"github.com/bytedance/sonic"
	"github.com/bytedance/sonic/ast"
	"github.com/dmznlin/znlib-go/znlib"
	"io"
	"net/http"
)

/*
hand_FromERP 2023-12-29 10:31:44
参数: w,
参数: r,
描述: 接收草料 ERP post的数据

数据格式：verify=aabb&id=1122
*.verify: 验证码，用于确认身份
*.id: 身份代码，用于确认数据属于哪个单位
*/
func hand_FromERP(res http.ResponseWriter, req *http.Request) {
	res.WriteHeader(http.StatusOK)
	//200

	params := req.URL.Query()
	//url params

	id := znlib.StrTrim(params.Get("id"))
	if params.Get("verify") != cfg.erpVerify || id == "" {
		znlib.Error(fmt.Sprintf("来自ERP: %s 的请求无法验证.", req.Host))
		res.Write([]byte("cann't verify erp host."))
		return
	} //verify

	body, err := io.ReadAll(req.Body)
	if err != nil {
		znlib.Error(err)
		return
	}

	var str string
	var root ast.Node
	//var node *ast.Node

	znlib.TryFinal{
		Try: func() (err error) {
			root, err = sonic.GetFromString(string(body))
			str, _ = root.Raw()
			znlib.Info(str)

			return nil
		},
		Finally: nil,
		Except: func(err error) {
			znlib.Error(err)
		},
	}.Run()
}
