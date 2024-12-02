package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/go-ldap/ldap/v3"
	ldapconnector "github.com/klambri/ldap-api-bridge/internal/ldap-connector"
)

func GetUsers(c *gin.Context) {
	// todo: Need refactoring
	connector, err := ldapconnector.CreateConnector("ldaps://klambri.lan", "Administrator@klambri.lan", "P@ssw0rd")
	if err != nil {
		c.JSON(http.StatusServiceUnavailable, "error")
	}
	defer connector.Close()

	searchRequest := ldap.NewSearchRequest(
		"cn=Users,dc=klambri,dc=lan", ldap.ScopeWholeSubtree, ldap.NeverDerefAliases, 0, 0, false, "(|(objectClass=person)(objectClass=user))", []string{"cn", "dn"}, nil,
	)

	result, err := connector.Search(searchRequest)
	if err != nil {
		c.JSON(http.StatusNotFound, "Not Found")
	}

	resp := []string{}
	for _, entry := range result.Entries {
		resp = append(resp, entry.DN)
	}

	c.JSON(http.StatusOK, gin.H{
		"users": resp,
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
