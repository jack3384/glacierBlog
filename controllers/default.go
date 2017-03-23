package controllers

import (
	"github.com/astaxie/beego"
	"os"
	"strings"
	"sort"
	"strconv"
	"math"
)

const  (
	blogPath="./static/blog"
)

type MainController struct {
	beego.Controller
}

type Category map[string][]string

func checkErr(err error){
	if(err!=nil){
		panic(err)
	}
}

func (c *MainController) Get() {
	dir,err:=os.Open(blogPath)
	checkErr(err)
	files,err:=dir.Readdir(0)
	checkErr(err)
	var mdFiles []MdInfo
	cateMap:=Category{} //储存category
	cateString:= c.Ctx.Input.Param(":category")
	cateString= strings.TrimSpace(cateString)
	for _,file:=range files{
		fileName:=file.Name()
		if strings.HasSuffix(fileName,".md"){
			flag:=0 //标识是否通过了category筛选
			mdPath:=blogPath+"/"+fileName
			mdInformation:=ReadMdInfo(mdPath)
			mdInformation["fileName"]=fileName
			//储存category分类
			categories:=strings.Split(mdInformation["category"],",")
			for _,v:=range categories{
				v=strings.TrimSpace(v)
				cateMap[v]=append(cateMap[v],fileName)
				if cateString==v||cateString==""{
					flag=1
				}
			}
			if flag==1{
				mdFiles=append(mdFiles,mdInformation)
			}

		}
	}
	//slice按日期排序
	sort.Slice(mdFiles, func(i, j int) bool {
		return mdFiles[i]["date"]>mdFiles[j]["date"]
	})
	//分页
	pageString:= c.Ctx.Input.Param(":pageNum")
	if pageString==""{
		pageString="1"
	}
	page,err:=strconv.Atoi(pageString)
	checkErr(err)
	totalNum:=len(mdFiles)
	offset:=(page-1)*PAGESIZE
	end:=offset+PAGESIZE
	if end>totalNum{
		end=totalNum
	}
	partMdFiles:=mdFiles[offset:end]
	//填充页面数据
	c.Data["mdFiles"]=partMdFiles
	c.Data["siteInfo"]=getSiteInfo()
	c.Data["category"]=cateMap
	//分页处理
	totalPage:=int(math.Ceil(float64(totalNum)/float64(PAGESIZE)))
	c.Data["pageNow"]=page
	pageInfo:=[]int{}
	for i:=1;i<=totalPage;i++{
		pageInfo=append(pageInfo,i)
	}
	c.Data["pageInfo"]=pageInfo
	c.TplName="index.tpl"
}
