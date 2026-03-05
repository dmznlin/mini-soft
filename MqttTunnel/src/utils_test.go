package main

import (
	"fmt"
	"testing"
)

func TestMqttCmd(t *testing.T) {
	cmd := &MqttCmd{
		Cmd:    5,
		Sender: "srv",
		Param:  "cli",
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

func TestMqttCmd_CmdServerInfo(t *testing.T) {
	var cmd = &MqttCmd{}
	buf, err := cmd.CmdFindServer("srv")
	if err != nil {
		t.Fatal(err)
	}
	fmt.Println(string(buf))

	buf, err = cmd.CmdServerInfo()
	if err != nil {
		t.Fatal(err)
	}
	fmt.Println(string(buf))

	buf, err = cmd.CmdConnHost("local")
	if err != nil {
		t.Fatal(err)
	}
	fmt.Println(string(buf))
}
