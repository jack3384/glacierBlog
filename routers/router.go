package routers

import (
	"blog/controllers"
	"github.com/astaxie/beego"
)

func init() {
    beego.Router("/", &controllers.MainController{})//index路由
    beego.Router("/page/:pageNum", &controllers.MainController{})//index路由
    beego.Router("/blog/:article", &controllers.BlogController{})//blog详情路由
    beego.Router("/category/:category", &controllers.MainController{})//blog分类路由
}
