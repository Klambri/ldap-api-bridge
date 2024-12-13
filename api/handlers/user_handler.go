package handlers

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/go-ldap/ldap/v3"
	ldapconnector "github.com/klambri/ldap-api-bridge/internal/ldap-connector"
	"github.com/klambri/ldap-api-bridge/internal/models"
)

func GetUsers(c *gin.Context) {
	searchRequest := ldap.NewSearchRequest(
		"dc=klambri,dc=lan", ldap.ScopeWholeSubtree, ldap.NeverDerefAliases, 0, 0, false, "(|(objectClass=person)(objectClass=user))", []string{"cn", "dn"}, nil,
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
	var user models.User

	if err := c.BindJSON(&user); err != nil {
		log.Fatal(err)
	}

	fmt.Println(user.Username)

	connector := ldapconnector.GetInstance()

	// todo: Password
	addReq := ldap.NewAddRequest(fmt.Sprintf("CN=%v,CN=Users,DC=klambri,DC=lan", user.Username), nil)
	addReq.Attribute("objectClass", []string{"top", "person", "organizationalPerson", "user"})

	if err := connector.Add(addReq); err != nil {
		log.Fatal(err)
	}

	c.JSON(http.StatusCreated, user)
}

func UpdateUser(c *gin.Context) {
	c.JSON(http.StatusOK, "update_user")
}

func DeleteUser(c *gin.Context) {
	var user models.User

	if err := c.BindJSON(&user); err != nil {
		log.Fatal(err)
	}

	fmt.Println(user.Username)

	connector := ldapconnector.GetInstance()

	delReq := ldap.NewDelRequest(fmt.Sprintf("CN=%v,CN=Users,DC=klambri,DC=lan", user.Username), nil)

	if err := connector.Del(delReq); err != nil {
		log.Fatal(err)
	}

	c.JSON(http.StatusCreated, user)
}
