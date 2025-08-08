package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path"
	"regexp"
	"strings"

	"github.com/go-ini/ini"
	"github.com/joho/godotenv"
)

type QuadletContainer struct {
	Name  string
	Image string
}

type Response struct {
	Results []struct {
		Name string `json:"name"`
	} `json:"results"`
}

func quadletReadContainer(path string) (QuadletContainer, error) {
	data, err := ini.Load(path)
	if err != nil {
		return QuadletContainer{}, err
	}

	container := data.Section("Container")
	name := container.Key("ContainerName").String()
	image := container.Key("Image").String()

	return QuadletContainer{
		Name:  name,
		Image: image,
	}, nil
}

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal(err)
	}

	hi := os.Getenv("HI_TEST_ONE_THREE")
	log.Println(hi)
	//os.Exit(0)

	fmt.Println("wok")
	root := "C:\\Users\\Nathan\\Projects\\Server\\quadman\\samples"
	files, err := os.ReadDir(root)
	if err != nil {
		log.Fatal(err)
	}

	for _, file := range files {
		name := file.Name()
		if !strings.HasSuffix(name, ".container") {
			continue
		}

		path := path.Join(root, name)
		log.Println(path)

		quadletContainer, err := quadletReadContainer(path)
		if err != nil {
			log.Fatal(err)
		}

		//u, err := url.Parse("http://" + image)
		//if err != nil {
		//	log.Fatal(err)
		//}

		//log.Println(u.Path)
		//continue

		r, err := regexp.Compile("(^[^/]*)/([^:]*)")
		if err != nil {
			log.Fatal(err)
		}

		imageAct := r.FindStringSubmatch(quadletContainer.Image)
		imageHost := imageAct[1]
		image2 := imageAct[2]
		log.Printf("%q", imageHost)
		log.Printf("%q", image2)
		//log.Printf("%q", imageAct)

		resp, err := http.Get("https://hub.docker.com/v2/repositories/jetbrains/youtrack/tags")
		if err != nil {
			log.Fatal(err)
		}

		defer resp.Body.Close()
		body, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			log.Fatal(err)
		}

		var hubData Response
		err = json.Unmarshal(body, &hubData)
		if err != nil {
			log.Fatal(err)
		}

		log.Println(hubData)
		for _, tag := range hubData.Results {
			log.Println(tag.Name)
		}
	}
}
