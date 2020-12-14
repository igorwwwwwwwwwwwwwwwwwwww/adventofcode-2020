package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"runtime"
	"strconv"
	"strings"
	"sync/atomic"
	"time"

	"github.com/google/gops/agent"
)

// 2.81358e+14 ops/sec
// (parallelism = 4, optimize factor = 29)

// HACK: we increment in factors of 29, this keeps things aligned
// var unit = uint64(1000000000)
var unit = uint64(10000000 * 29)

var input = "939\n7,13,x,x,59,x,31,19"

var ops uint64
var maxAttempted uint64

func main() {
	if err := agent.Listen(agent.Options{}); err != nil {
		log.Fatal(err)
	}

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
		bus_pairs = append(bus_pairs, pair{uint64(i), val_uint})
	}

	ch := make(chan uint64)
	done := make(chan interface{})

	go func() {
		// HACK: we know the solution is > 100 trillion
		// n := uint64(100000000000001 / unit)
		// we can update this based on already checked numbers
		n := uint64(119661540000000 / unit)
		for {
			ch <- n
			n++
		}
	}()

	for i := 0; i < runtime.NumCPU(); i++ {
		go func() {
			for {
				t := <-ch * unit
				t_prev := t
				max := t + unit
				for t < max {
					// found := true
					// for _, p := range bus_pairs {
					// 	if (t+p.i)%p.val != 0 {
					// 		found = false
					// 		break
					// 	}
					// }
					// if found {
					// 	done <- t
					// 	break
					// }

					// [{19 41} {29 521} {37 23} {42 13} {46 17} {60 601} {66 37} {79 19}]
					if (t+19)%41 == 0 && (t+29)%521 == 0 && (t+37)%23 == 0 && (t+42)%13 == 0 && (t+46)%17 == 0 && (t+60)%601 == 0 && (t+66)%37 == 0 && (t+79)%19 != 0 {
						done <- t
						break
					}
					t += 29 // HACK: buses[0] is 29, so we know we the result is a multiple of 29

					// unrolling the loop a couple times

					if (t+19)%41 == 0 && (t+29)%521 == 0 && (t+37)%23 == 0 && (t+42)%13 == 0 && (t+46)%17 == 0 && (t+60)%601 == 0 && (t+66)%37 == 0 && (t+79)%19 != 0 {
						done <- t
						break
					}
					t += 29

					if (t+19)%41 == 0 && (t+29)%521 == 0 && (t+37)%23 == 0 && (t+42)%13 == 0 && (t+46)%17 == 0 && (t+60)%601 == 0 && (t+66)%37 == 0 && (t+79)%19 != 0 {
						done <- t
						break
					}
					t += 29

					if (t+19)%41 == 0 && (t+29)%521 == 0 && (t+37)%23 == 0 && (t+42)%13 == 0 && (t+46)%17 == 0 && (t+60)%601 == 0 && (t+66)%37 == 0 && (t+79)%19 != 0 {
						done <- t
						break
					}
					t += 29

					if (t+19)%41 == 0 && (t+29)%521 == 0 && (t+37)%23 == 0 && (t+42)%13 == 0 && (t+46)%17 == 0 && (t+60)%601 == 0 && (t+66)%37 == 0 && (t+79)%19 != 0 {
						done <- t
						break
					}
					t += 29

					if (t+19)%41 == 0 && (t+29)%521 == 0 && (t+37)%23 == 0 && (t+42)%13 == 0 && (t+46)%17 == 0 && (t+60)%601 == 0 && (t+66)%37 == 0 && (t+79)%19 != 0 {
						done <- t
						break
					}
					t += 29

					if (t+19)%41 == 0 && (t+29)%521 == 0 && (t+37)%23 == 0 && (t+42)%13 == 0 && (t+46)%17 == 0 && (t+60)%601 == 0 && (t+66)%37 == 0 && (t+79)%19 != 0 {
						done <- t
						break
					}
					t += 29

					if (t+19)%41 == 0 && (t+29)%521 == 0 && (t+37)%23 == 0 && (t+42)%13 == 0 && (t+46)%17 == 0 && (t+60)%601 == 0 && (t+66)%37 == 0 && (t+79)%19 != 0 {
						done <- t
						break
					}
					t += 29
				}
				atomic.AddUint64(&ops, t-t_prev)
				m := atomic.LoadUint64(&maxAttempted)
				for t > m && !atomic.CompareAndSwapUint64(&maxAttempted, m, t) {
					m = atomic.LoadUint64(&maxAttempted)
				}
				t_prev = t
			}
		}()
	}

	go func() {
		interval := 60 * time.Second
		ticker := time.NewTicker(interval)
		t_prev := atomic.LoadUint64(&ops)
		for {
			<-ticker.C
			t := atomic.LoadUint64(&ops)
			m := atomic.LoadUint64(&maxAttempted)
			fmt.Println(m, float64(t-t_prev)*interval.Seconds(), "(ops/s)")
			t_prev = t
		}
	}()

	t := <-done
	fmt.Println(t)
}
