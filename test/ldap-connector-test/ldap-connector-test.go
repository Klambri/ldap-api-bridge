package main

import (
	"fmt"
	"log"

	"github.com/go-ldap/ldap/v3"
	ldapconnector "github.com/klambri/ldap-api-bridge/internal/ldap-connector"
)

func main() {
	Test()
}

func Test() {

	l, err := ldapconnector.CreateConnector("ldaps://klambri.lan", "Administrator@klambri.lan", "P@ssw0rd")
	if err != nil {
		log.Fatal(err)
	}
	defer l.Close()

	searchRequest := ldap.NewSearchRequest(
		"cn=Users,dc=klambri,dc=lan", ldap.ScopeWholeSubtree, ldap.NeverDerefAliases, 0, 0, false, "(cn=Administrator)", []string{"cn", "dn"}, nil,
	)

	result, err := l.Search(searchRequest)
	if err != nil {
		log.Fatal(err)
	}

	for _, entry := range result.Entries {
		fmt.Println(entry.DN)
		// fmt.Printf("%s: %v\n", entry.DN, entry.GetAttributeValue("cn"))
	}
}