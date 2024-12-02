package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func GetUsers(c *gin.Context) {
	c.JSON(http.StatusOK, "get_users")
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
