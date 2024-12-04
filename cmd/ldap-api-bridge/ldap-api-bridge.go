package main

import (
	"fmt"
	"log"
	"os"

	"github.com/klambri/ldap-api-bridge/api/routes"
	ldapconnector "github.com/klambri/ldap-api-bridge/internal/ldap-connector"
	"gopkg.in/yaml.v3"
)

func readConfig() (*ldapconnector.LdapConfig, error) {
	buffer, err := os.ReadFile("configs/config.yaml")
	if err != nil {
		return nil, err
	}

	println(string(buffer[:]))

	config := &ldapconnector.LdapConfig{}

	if err := yaml.Unmarshal(buffer, config); err != nil {
		return nil, err
	}

	return config, nil
}

func main() {

	config, err := readConfig()
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(config)
	if err := ldapconnector.NewInstanceFromConfig(config); err != nil {
		log.Fatal(err)
	}

	fmt.Println("Ready..")
	routes.Run()
}
