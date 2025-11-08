// This is free and unencumbered software released into the public domain.

package main

import (
	"bytes"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"syscall"
	"text/template"
)

// Copies the ownership and permissions to/from the given files.
func copyPermissions(source string, target string) {
	info, err := os.Stat(source)
	if err != nil {
		panic(err)
	}

	err = os.Chmod(target, info.Mode())
	if err != nil {
		panic(err)
	}

	stat, ok := info.Sys().(*syscall.Stat_t)
	if !ok {
		panic("Unable to stat source file")
	}

	err = os.Chown(target, int(stat.Uid), int(stat.Gid))
	if err != nil {
		panic(err)
	}
}

// Executes the given template and returns the result.
func format(text string) string {
	functions := template.FuncMap{"read": read}
	tmpl := template.Must(template.New("").Funcs(functions).Parse(text))

	var res bytes.Buffer
	err := tmpl.Execute(&res, os.Args)
	if err != nil {
		panic(err)
	}

	return res.String()
}

// Reads the file at the given path and returns its contents as a string.
func read(path string) string {
	if !filepath.IsAbs(path) {
		dir := filepath.Dir(os.Args[1])
		if !filepath.IsAbs(dir) {
			abs, err := filepath.Abs(dir)
			if err == nil {
				dir = abs
			}
		}
		path = filepath.Join(dir, path)
	}

	buffer, err := os.ReadFile(path)
	if err != nil {
		panic(err)
	}

	return strings.TrimSpace(string(buffer))
}

// Processes the template at 'args[1]' and writes it to 'args[2]'.
func main() {
	// Assert the correct usage.
	if len(os.Args) != 3 {
		fmt.Println("Usage: telae <source> <target>")
		os.Exit(1)
	}

	// Read and process the template file.
	source := os.Args[1]
	template, err := os.ReadFile(source)
	if err != nil {
		panic(err)
	}
	result := format(string(template))

	// Write the processed template.
	target := os.Args[2]
	os.WriteFile(target, []byte(result), 0600)
	copyPermissions(source, target)
}
