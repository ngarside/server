// This is free and unencumbered software released into the public domain.

package main

import (
	"io/ioutil"
	"log"
	"os"
	"strings"
	"text/template"
)

func format(template2 string) {
	functions := template.FuncMap{"read": read}

	path := os.Args[0]
	path = "/home/nathan/Projects/Server/telae/sample.txt"
	t, err := template.New("sample.txt").Funcs(functions).ParseFiles(path)
	if err != nil {
		log.Print(err)
		return
	}

	err = t.Execute(os.Stdout, os.Args)
	if err != nil {
		log.Print(err)
		return
	}
}

func read(path string) string {
	bytes, err := ioutil.ReadFile(path)
	if err != nil {
		panic(err)
	}

	trimmed := strings.TrimSpace(string(bytes))
	return trimmed
}

func main() {
	path := os.Args[0]
	path = "/home/nathan/Projects/Server/telae/sample.txt"
	format(path)
}
