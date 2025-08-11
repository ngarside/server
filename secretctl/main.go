package main

import (
	"encoding/json"
	"log"

	"github.com/BurntSushi/toml"
)

type SecretFile struct {
	Secrets []Secret
}

type DriverType string

const (
	PodmanDriver DriverType = "Podman"
)

type Secret struct {
	Driver DriverType
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
