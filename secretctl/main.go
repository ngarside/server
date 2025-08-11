package main

import (
	"encoding/json"
	"fmt"
	"log"
	"os"

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

func validate(secret Secret) error {
	if secret.Driver == "" {
		return fmt.Errorf("driver is required")
	}

	if secret.Key == "" {
		return fmt.Errorf("key is required")
	}

	if secret.User == "" {
		return fmt.Errorf("user is required")
	}

	if secret.Value == "" {
		return fmt.Errorf("value is required")
	}

	return nil
}

func main() {
	// Return early unless the program is run with a single "cat" command
	if len(os.Args) != 2 || os.Args[1] != "cat" {
		return
	}

	// cat the file to check that it is parsed properly (cat command)
	var file SecretFile
	_, err := toml.DecodeFile("example.toml", &file)
	if err != nil {
		log.Fatal(err)
	}

	for _, secret := range file.Secrets {
		log.Println(secret.User)
		err = validate(secret)
		if err != nil {
			log.Fatal("SECRET err")
		}
	}

	jsonData, err := json.MarshalIndent(file.Secrets, "", "  ")
	if err != nil {
		log.Fatal(err)
	}

	log.Println(string(jsonData))
}
