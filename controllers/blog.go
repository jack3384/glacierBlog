package controllers

import (
	"github.com/astaxie/beego"
	"github.com/shurcooL/github_flavored_markdown"
	"io/ioutil"
	"html/template"
	"net/http"
)

const(
)

type BlogController struct {
	beego.Controller
}

func (c *BlogController) Get() {
	//获得blog名字
	article := c.Ctx.Input.Param(":article")
	//获得md文件绝对路径
	filePath:="./static/blog/"+article
	md,err:=ioutil.ReadFile(filePath)
	if err!=nil{
		http.Error(c.Ctx.ResponseWriter, "文档不存在", 404)
		return
	}
	output := github_flavored_markdown.Markdown(md)
	c.Data["output"]=template.HTML(string(output))
	fileInfo:=ReadMdInfo(filePath)
	fileInfo["fileName"]=article
	c.Data["fileInfo"]=fileInfo
	c.Data["siteInfo"]=getSiteInfo()
	c.TplName="blog.tpl"
}
