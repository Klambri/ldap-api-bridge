package routes

import (
	"github.com/gin-gonic/gin"
	"github.com/klambri/ldap-api-bridge/api/handlers"
)

func addUserRoutes(rg *gin.RouterGroup) {
	users := rg.Group("/users")
	{
		users.GET("/", handlers.GetUsers)
		users.POST("/", handlers.CreateUser)
		users.PUT("/", handlers.UpdateUser)
		users.DELETE("/", handlers.DeleteUser)
	}
}
