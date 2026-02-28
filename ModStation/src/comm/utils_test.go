package comm

import (
	"fmt"
	"reflect"
	"testing"
)

func TestBytes2Uint(t *testing.T) {
	dt, err := Bytes2Uint([]byte("12345678"), true)
	if err != nil {
		t.Fatal(err)
	}

	for _, val := range dt {
		fmt.Printf("%d ", val) //12594 13108 13622 14136
	}

	fmt.Println("")
}

func TestUint2Bytes(t *testing.T) {
	dt := []uint16{12594, 13108, 13622, 14136}
	str := string(Uint2Bytes(dt, true))
	if str != "12345678" {
		t.Fatal(fmt.Errorf("Expected %s but got %s", "12345678", str))
	}
	fmt.Println(str)
}

func TestBytes2Bool(t *testing.T) {
	dt := []byte{0, 2, 0, 4, 0}
	val := Bytes2Bool(dt)
	if !reflect.DeepEqual(val, []bool{false, true, false, true, false}) {
		t.Fatal(fmt.Errorf("Expected %v but got %v", []bool{false, true, false, true, false}, dt))
	}
}

func TestBool2Bytes(t *testing.T) {
	dt := []bool{false, true, false, true, false}
	val := Bool2Bytes(dt)
	if !reflect.DeepEqual(val, []byte{0, 1, 0, 1, 0}) {
		t.Fatal(fmt.Errorf("Expected %v but got %v", []byte(""), dt))
	}
}
