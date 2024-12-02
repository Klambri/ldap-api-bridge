package ldapconnector

import (
	"log"

	"github.com/go-ldap/ldap/v3"
)

var connector *ldap.Conn

func NewInstance(url string, username string, password string) error {
	l, err := ldap.DialURL(url)

	if err != nil {
		log.Fatal(err)
	}

	err = l.Bind(username, password)

	if err != nil {
		log.Fatal(err)
	}

	connector = l
	return err
}

func GetInstance() *ldap.Conn {
	return connector
}
