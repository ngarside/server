// This is free and unencumbered software released into the public domain.

package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	fmt.Println("Sending healthcheck request...")

	res, err := http.Head("http://0.0.0.0:80/reverse_proxy/upstreams")
	if err != nil {
		log.Fatalf("Request errored - %s", err)
	}

	if res.StatusCode >= 300 {
		log.Fatalf("Request returned unsuccessful status - %s", res.Status)
	}

	fmt.Printf("Request passed - %s", res.Status)
}
