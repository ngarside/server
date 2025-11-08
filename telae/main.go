// This is free and unencumbered software released into the public domain.

package main

import (
	"bytes"
	"os"
	"syscall"
	"text/template"
)

const help = `
	This program formats a go-style template file and outputs the result.
`

// Executes the given template and returns the result.
func format(template2 string) string {
	functions := template.FuncMap{"read": read}

	t := template.Must(template.New("").Funcs(functions).Parse(template2))

	var res bytes.Buffer
	err := t.Execute(&res, os.Args)
	if err != nil {
		panic(err)
	}

	return res.String()
}

// Reads the file at the given path as a string.
func read(path string) string {
	buffer, err := os.ReadFile(path)
	if err != nil {
		panic(err)
	}

	return string(buffer)
}

func main() {
	source := os.Args[1]
	target := os.Args[2]

	info, err := os.Stat(source)
	if err != nil {
		panic(err)
	}

	stat, ok := info.Sys().(*syscall.Stat_t)
	if !ok {
		panic("Unable to stat source file")
	}

	template := read(source)
	result := format(template)
	os.WriteFile(target, []byte(result), info.Mode())

	err = os.Chown(target, int(stat.Uid), int(stat.Gid))
	if err != nil {
		panic(err)
	}
}
