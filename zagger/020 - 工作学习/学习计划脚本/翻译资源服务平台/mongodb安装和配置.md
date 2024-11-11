---
alias: 
tags: 长青笔记
cdate: 2023-11-21 08:41
uid: 20231121084208
searchterm: "#长青笔记"
banner: 040 - Obsidian/附件/banners/book-banner.gif
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
created: 2023-11-21 08:41:40
updated: 2023-11-30 10:03:50
---

# 1. mongodb安装和配置

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2023-11-21 星期二 08:41:40

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_


1. windows本地安装mongo服务，`scoop install -g mongodb@4.4.26`
2. 创建data目录，用来跑服务
3. 切换到mongodb目录：`cd /d/GlobalScoopApps/apps/mongodb/current/bin`
4. 跑起来mongod服务：`./mongod --dbpath D:\\GlobalScoopApps\\apps\\mongodb\\current\\data --auth`，并可以在命令行查看日志 
5. `./mongo`跑起来客户端
6. `use admin`进入admin数据库
7. 创建admin账号
   
   ```js
db.createUser( {
	 user: "admin",
	 pwd: "admin",
	 roles: [ { role: "root", db: "admin" } ]
 })
db.createUser( {
	 user: "webres",
	 pwd: "123456",
	 roles: [ { role: "root", db: "admin" } ]
 })
```
7. 启用身份验证 ,重启服务
```js
security:
  authorization: enabled
```
8. `./mongo -u admin -p admin --authenticationDatabase admin` 使用管理员用户连接到 MongoDB 服务器
9. ![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231121110312.png)
10. ![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231121110338.png)

11. 遇到一个坑：一直报这个错。
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231121110359.png)

# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::

[MongoDB 数据类型|极客教程](https://geek-docs.com/mongodb/mongodb-top-articles/1009100_mongodb_datatype.html)
[What is MongoDB? — MongoDB Manual](https://www.mongodb.com/docs/manual/)
[Node.js对MongoDB进行增删改查操作 - 知乎](https://zhuanlan.zhihu.com/p/62758583)
