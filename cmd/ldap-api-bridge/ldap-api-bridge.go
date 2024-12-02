package main

import (
	"log"

	"github.com/klambri/ldap-api-bridge/api/routes"
	ldapconnector "github.com/klambri/ldap-api-bridge/internal/ldap-connector"
)

func main() {
	err := ldapconnector.NewInstance("ldaps://klambri.lan", "Administrator@klambri.lan", "P@ssw0rd")

	if err != nil {
		log.Fatal(err)
	}

	routes.Run()
}
