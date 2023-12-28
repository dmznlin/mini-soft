//go:generate goversioninfo -o main.syso ../res/ver.json
package main

import "github.com/dmznlin/znlib-go/znlib"

var _ = znlib.InitLib(nil, nil)

func main() {
	znlib.Info("Hello,word")
}
