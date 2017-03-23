package controllers

import (
	"os"
	"bufio"
	"strings"
)

const  (
	URL            = "/"
	TITLE          = "网站标题"
	CACHE          = false
	DUOSHUO        = "51glacier"
	BAIDUTONGJI = ""
	KEYWORDS       = "关键词逗号隔开"
	DESCRIPTION    = "网站描述"
	PAGESIZE       = 5
)


type MdInfo map[string]string
type SiteInfo map[string]string

func ReadMdInfo(fileName string) MdInfo {
	//打开blog文件夹
	file, err := os.Open(fileName)
	if err != nil {
		panic("blog文件夹打开出错")
	}
	reader := bufio.NewReader(file)
	//读取首行
	first, _, _ := reader.ReadLine()
	mdBaseInfo := make(MdInfo)
	if strings.Contains(string(first), "<!--") {
		for {
			bytes, _, err := reader.ReadLine()
			if err != nil {
				panic(err)
			}
			info := string(bytes)
			if strings.Contains(info, "-->") {
				break;
			} else {
				information := strings.Split(info, ":")
				mdBaseInfo[strings.TrimSpace(information[0])] = strings.TrimSpace(information[1])
			}
		}

	} else {
		panic("md文件缺失头信息" + fileName)
	}

	return mdBaseInfo
}

func getSiteInfo() map[string]string {
	siteInfo:=make(SiteInfo)
	siteInfo["url"]=URL
	siteInfo["title"]=TITLE
	siteInfo["description"]=DESCRIPTION
	siteInfo["keywords"]=KEYWORDS
	siteInfo["duoshuo"]=DUOSHUO
	siteInfo["baidutongji"]=BAIDUTONGJI
	return siteInfo
}
