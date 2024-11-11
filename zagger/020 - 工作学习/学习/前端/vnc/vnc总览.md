---
alias:
tags: 长青笔记
cdate: 2023-12-16 23:12
uid: 20231216231247
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. vnc总览

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2023-12-16 星期六 23:12:19

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

1. vnc中 vdi的桌面名和voi不一样。
vdi的桌面：
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231218100237.png)
voi的桌面：
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231218100404.png)

看代码好像是后台返回的，所以暂时不做处理。

2. vdi vnc 可以统一个id，不同token连接这个桌面。
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231218092706.png)
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231218092714.png)

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

1. 问题：vdi的vnc由于需要url中携带`token`，在开发环境中，`webpack5`，`webpack-dev-server`由于缓存设置的问题，导致会缓存`/api/instances/fcf4eaf3-6750-43ff-a3ec-994b8be7fd9d/token`接口的返回，导致vnc连接有个connection接口报错，找不到对象。

![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231218091847.png)

![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231218092509.png)

解决办法：禁用浏览器缓存。![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231218092555.png)

# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
[Issues · novnc/noVNC · GitHub](https://github.com/novnc/noVNC/issues)