package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"runtime"
	"strconv"
	"strings"
	"time"

	"github.com/google/gops/agent"
)

// 1.624.000.000.000 ops/sec
// 1.6 P ops/sec
// (parallelism = 4, optimize factor = 29)

// HACK: we increment in factors of 29, this keeps things aligned
// var unit = uint64(1000000000)
var unit = uint64(5000000000 * 29)

var input = "939\n7,13,x,x,59,x,31,19"

func main() {
	if err := agent.Listen(agent.Options{}); err != nil {
		log.Fatal(err)
	}

	start := time.Now()

	r, err := os.Open("13.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer r.Close()

	b, err := ioutil.ReadAll(r)
	if err != nil {
		log.Fatal(err)
	}
	input = string(b)

	lines := strings.Split(input, "\n")
	buses := strings.Split(lines[1], ",")

	type pair struct {
		i   uint64
		val uint64
	}

	bus_pairs := []pair{}
	for i, val_str := range buses {
		if val_str == "x" {
			continue
		}
		if val_str == "29" {
			// HACK: we are multiplying by 29, so we can always skip it
			continue
		}
		val_uint, err := strconv.ParseUint(val_str, 10, 64)
		if err != nil {
			log.Fatal(err)
		}
		bus_pairs = append(bus_pairs, pair{val_uint, uint64(i)})
	}

	ch := make(chan uint64)
	done := make(chan interface{})

	go func() {
		// HACK: we know the solution is > 100 trillion
		// n := uint64(100000000000001 / unit)
		// we can update this based on already checked numbers
		n := uint64(108460000000000 / unit)
		for {
			ch <- n
			n++
		}
	}()

	for i := 0; i < runtime.NumCPU(); i++ {
		go func() {
			for {
				t_prev := uint64(0)
				t := <-ch * unit
				max := t + unit
				for t < max {
					found := true
					for _, p := range bus_pairs {
						if (t+p.i)%p.val != 0 {
							found = false
							break
						}
					}
					if found {
						done <- t
						break
					}
					t += 29 // HACK: buses[0] is 29, so we know we the result is a multiple of 29
				}
				fmt.Println(time.Now().Sub(start), t)
				if t_prev != 0 {
					throughput := float64(t-t_prev) / time.Now().Sub(start).Seconds()
					fmt.Println("throughput (ops/s)", throughput)
				}
				t_prev = t
			}
		}()
	}

	t := <-done
	fmt.Println(t)
}
