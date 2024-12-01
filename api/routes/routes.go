package routes

import "github.com/gin-gonic/gin"

func Run() {
	r := gin.Default()

	setupRoutes(r)

	r.Run(":8080")
}

func setupRoutes(r *gin.Engine) {
	v1 := r.Group("/v1")
	addUserRoutes(v1)
}
