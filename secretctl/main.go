package main

import (
	"fmt"
	"log"
	"os"

	"github.com/BurntSushi/toml"
)

const title = `
                        _       _   _
 ___  ___  ___ _ __ ___| |_ ___| |_| |
/ __|/ _ \/ __| '__/ _ \ __/ __| __| |
\__ \  __/ (__| | |  __/ || (__| |_| |
|___/\___|\___|_|  \___|\__\___|\__|_|
`

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
	fmt.Println(title)
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
		fmt.Printf("%s:\n", secret.Key)
		fmt.Printf("  Driver: %s\n", secret.Driver)
		fmt.Printf("  User: %s\n", secret.User)
		fmt.Printf("  Value: %s\n", secret.Value)
		err = validate(secret)
		if err != nil {
			log.Fatal("SECRET err")
		}
	}
}
