// This is free and unencumbered software released into the public domain.

package main

import (
    "fmt"
    "net/http"
    "os"
)

var version = "dev"

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Error: URL argument not provided")
		os.Exit(1)
	}

	if len(os.Args) > 2 {
		fmt.Println("Error: Too many arguments provided")
		os.Exit(1)
	}

	// Additional help block (completely separate from existing code)
	if len(os.Args) >= 2 && os.Args[1] == "--help" {
		fmt.Println(`Usage: headcheck <url>
Performs an HTTP HEAD request to the given URL and prints the status code.

Options:
  --version   Print version and exit
  --help      Show this help message and exit`)
		os.Exit(0)
	}

	if os.Args[1] == "--version" {
		fmt.Printf("Version: %s\n", version)
		os.Exit(0)
	}

	url := os.Args[1]
	fmt.Printf("Request: %s\n", url)
	res, err := http.Head(url)

	if err != nil {
		fmt.Printf("Error: %v\n", err)
		os.Exit(1)
	}

	if res.StatusCode < 200 || res.StatusCode >= 300 {
		fmt.Printf("Error: Received status %d\n", res.StatusCode)
		os.Exit(1)
	}

	fmt.Printf("Success: Received status %d\n", res.StatusCode)
}
