# glacierBlog
基于md文档的blog,采用了gitblog的风格
## 使用方法
进入项目目录
```
go bulid
```
1. 编译出程序文件后将`static`,`views`文件夹与程序文件拷贝到任意目录运行即可
2. 将md文档放入`static\blog`文件夹下,md文档需要在开头添加如下标识信息
```
<!--
author: 火柴同学
date: 2016-11-30
title: PHP实现二分搜索树
category:算法
summary: PHP实现二分搜索树
-->
```
PS:blog文件夹下有示例
3. 修改`controllers\public.go`的常量可以自定义网站标题分页数量等