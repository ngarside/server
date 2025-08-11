package main

import (
	"encoding/json"
	"log"

	"github.com/BurntSushi/toml"
)

type SecretFile struct {
	Secrets []Secret
}

type Secret struct {
	Driver string
	Key    string
	User   string
	Value  string
}

func main() {
	var file SecretFile
	_, err := toml.DecodeFile("example.toml", &file)
	if err != nil {
		log.Fatal(err)
	}

	jsonData, err := json.MarshalIndent(file.Secrets, "", "  ")
	if err != nil {
		log.Fatal(err)
	}

	log.Println(string(jsonData))

}
