package ldapconnector

import (
	"log"

	"github.com/go-ldap/ldap/v3"
)

func CreateConnector(url string, username string, password string) (connector *ldap.Conn, err error) {
	l, err := ldap.DialURL(url)

	if err != nil {
		log.Fatal(err)
	}

	err = l.Bind(username, password)

	if err != nil {
		log.Fatal(err)
	}

	return l, err
}
