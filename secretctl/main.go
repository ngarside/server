package main

import (
	"fmt"
	"log"
	"os"
	"strings"

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
	PodmanDriver DriverType = "podman"
)

type Secret struct {
	Driver DriverType
	Key    string
	User   string
	Value  string
}

func validate(secret Secret) error {
	if secret.Driver != "podman" {
		return fmt.Errorf("driver is required")
	}

	if strings.TrimSpace(secret.Key) == "" {
		return fmt.Errorf("key is required")
	}

	if secret.User != "" && strings.TrimSpace(secret.User) == "" {
		return fmt.Errorf("user is required")
	}

	if strings.TrimSpace(secret.Value) == "" {
		return fmt.Errorf("value is required")
	}

	return nil
}

func main() {
	fmt.Print(title)
	// Return early unless the program is run with a single "cat" command
	if len(os.Args) != 3 || os.Args[1] != "cat" {
		return
	}

	// cat the file to check that it is parsed properly (cat command)
	fmt.Printf("Reading file - %s\n", os.Args[2])
	var file SecretFile
	_, err := toml.DecodeFile(os.Args[2], &file)
	if err != nil {
		log.Fatal(err)
	}

	map2 := map[string]int{}
	secrets := []Secret{}
	for _, secret := range file.Secrets {
		key := secret.Key + secret.User + string(secret.Driver)
		if existingIndex, exists := map2[key]; exists {
			// Remove the existing secret from the slice
			secrets = append(secrets[:existingIndex], secrets[existingIndex+1:]...)
		}
		map2[key] = len(secrets)
		secrets = append(secrets, secret)
	}

	for _, secret := range secrets {
		fmt.Println()
		fmt.Printf("[%s]\n", secret.Key)
		fmt.Printf("Driver: %s\n", secret.Driver)
		fmt.Printf("User: %s\n", secret.User)
		fmt.Print("Value: ")
		for range secret.Value {
			fmt.Print("*")
		}
		fmt.Println()
		err = validate(secret)
		if err != nil {
			log.Print(err)
			log.Fatal("SECRET err")
		}
	}
}
