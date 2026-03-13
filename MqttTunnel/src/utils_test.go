package main

import (
	"fmt"
	"testing"
	"time"

	"github.com/dmznlin/znlib-go/znlib"
)

func TestMqttCmd(t *testing.T) {
	cmd := &MqttCmd{
		Cmd:    5,
		Sender: "srv",
		Data:   "srv",
		Verify: "",
	}

	dt, err := cmd.Marshal()
	if err != nil {
		t.Fatal(err)
	}
	fmt.Println(string(dt))

	buf, err := cmd.GetVerify()
	if err != nil {
		t.Fatal(err)
	}

	fmt.Println(buf)
	if buf != "2b1684cb988c3288a33c8015b4e8956b" {
		t.Fatal()
	}
}

func TestDurationTime(t *testing.T) {
	now := time.Now()
	t.Log(znlib.DateTime2Str(now, znlib.LayoutDateTimeMilli))

	if now.UnixNano() != int64(TimeToDuration(now)) {
		t.Fatal()
	}

	ch := DurationToTime(time.Duration(now.UnixNano()))
	t.Log(znlib.DateTime2Str(ch, znlib.LayoutDateTimeMilli))
	if ch.Sub(now) != 0 {
		t.Fatal()
	}
}
