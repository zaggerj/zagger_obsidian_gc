---
alias:
tags: 长青笔记
cdate: 2023-12-27 18:27
uid: 20231227182714
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. flash重定向

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2023-12-27 星期三 18:27:11

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::前端相关的有两个

[[终端上flash脚本]]
## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

1. flash项目：一个nwjs项目，用来响应来自插件相关的接口通讯
2. newflashredirect项目：插件接受来自chrome的api事件以及拦截请求，通过guesttool开始给的终端ip地址，直接请求到ip+9999服务，falsh服务转发请求到nwjs的项目中
     多方角色：
	1. guesttool
	2. flash服务
	3. nwjs项目
	4. 插件
# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
前端相关有两个项目:
1. [flash · GitLab](http://172.16.203.254/huangzijie/flash)
2. [newflashrediredt · GitLab](http://172.16.203.254/zhangyao/newflashrediredt)