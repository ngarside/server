// This is free and unencumbered software released into the public domain.

package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"os"
	"strings"
	"text/template"
)

func format(template2 string) string {
	functions := template.FuncMap{"read": read}

	t, err := template.New("").Funcs(functions).Parse(template2)
	if err != nil {
		panic(err)
	}

	var res bytes.Buffer
	err = t.Execute(&res, os.Args)
	if err != nil {
		panic(err)
	}

	return res.String()
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
	path = "/home/nathan/Projects/Server/telae/sample.tmpl"
	template2 := read(path)
	out := format(template2)
	fmt.Println(out)
}
