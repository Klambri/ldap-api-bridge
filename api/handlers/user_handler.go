package handlers

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/go-ldap/ldap/v3"
	ldapconnector "github.com/klambri/ldap-api-bridge/internal/ldap-connector"
)

func GetUsers(c *gin.Context) {
	searchRequest := ldap.NewSearchRequest(
		"cn=Users,dc=klambri,dc=lan", ldap.ScopeWholeSubtree, ldap.NeverDerefAliases, 0, 0, false, "(|(objectClass=person)(objectClass=user))", []string{"cn", "dn"}, nil,
	)

	result, err := ldapconnector.GetInstance().Search(searchRequest)
	if err != nil {
		log.Fatal(err)
	}

	var response []string

	for _, item := range result.Entries {
		response = append(response, item.DN)
	}

	c.JSON(http.StatusOK, gin.H{
		"response": response,
	})
}

func CreateUser(c *gin.Context) {
	c.JSON(http.StatusCreated, "create_user")
}

func UpdateUser(c *gin.Context) {
	c.JSON(http.StatusOK, "update_user")
}

func DeleteUser(c *gin.Context) {
	c.JSON(http.StatusOK, "delete_user")
}
