package ldapconnector

import (
	"log"
	"strings"

	"github.com/go-ldap/ldap/v3"
)

type LdapConfig struct {
	Connector struct {
		Realm    string `yaml:"realm"`
		User     string `yaml:"user"`
		Password string `yaml:"password"`
		Secure   bool   `yaml:"secure"`
	} `yaml:"connector"`
}

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

func NewInstanceFromConfig(config *LdapConfig) error {
	var urlSb strings.Builder

	if config.Connector.Secure {
		urlSb.WriteString("ldaps://")
	} else {
		urlSb.WriteString("ldap://")
	}

	urlSb.WriteString(config.Connector.Realm)

	url := urlSb.String()

	l, err := ldap.DialURL(url)

	if err != nil {
		return err
	}

	// todo: Need refactoring
	var userSb strings.Builder
	userSb.WriteString(config.Connector.User)
	userSb.WriteString("@")
	userSb.WriteString(config.Connector.Realm)

	if err = l.Bind(userSb.String(), config.Connector.Password); err != nil {
		return err
	}

	connector = l
	return nil
}

func GetInstance() *ldap.Conn {
	return connector
}
