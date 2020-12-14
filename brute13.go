package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"runtime"
	"strconv"
	"strings"
	"time"
)

// 81200000000 ops/min
// 4.872.000.000.000 ops/sec
// 4.872 G ops/sec
// 4.8   T ops/sec
// (parallelism = 4, optimize factor = 29)

// HACK: we increment in factors of 29, this keeps things aligned
// var unit = uint64(1000000000)
var unit = uint64(1000000000 * 29)

var input = "939\n7,13,x,x,59,x,31,19"

func main() {
	start := time.Now()

	r, err := os.Open("13.txt")
	if err != nil {
		panic(err)
	}
	defer r.Close()

	b, err := ioutil.ReadAll(r)
	if err != nil {
		panic(err)
	}
	input = string(b)

	lines := strings.Split(input, "\n")
	buses := strings.Split(lines[1], ",")

	bus_pairs := make(map[uint64]uint64)
	for i, val_str := range buses {
		if val_str == "x" {
			continue
		}
		val_uint, err := strconv.ParseUint(val_str, 10, 64)
		if err != nil {
			panic(err)
		}
		bus_pairs[val_uint] = uint64(i)
	}

	ch := make(chan uint64)
	done := make(chan interface{})

	go func() {
		// HACK: we know the solution is > 100 trillion
		n := uint64(100000000000001 / unit)
		for {
			ch <- n
			n++
		}
	}()

	for i := 0; i < runtime.NumCPU(); i++ {
		go func() {
			for {
				t := <-ch * unit
				max := t + unit
				for t < max {
					found := true
					for val, i := range bus_pairs {
						if (t+i)%val != 0 {
							found = false
							break
						}
					}
					if found {
						done <- t
						break
					}
					t += 29 // HACK: we need to be a multiple of 29
				}
				fmt.Println(time.Now().Sub(start), t)
			}
		}()
	}

	t := <-done
	fmt.Println(t)
}
