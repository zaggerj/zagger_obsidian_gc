---
aliases: 
tags:
  - 长青笔记
  - 工作/spice
cdate: 2023-11-13 15:58
uid: 20231113155847
searchterm: "#长青笔记"
banner: 040 - Obsidian/附件/banners/book-banner.gif
cssclasses:
  - noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
created: 2023-11-13T15:58
updated: 2023-11-13T16:53
---

# 1. spice被卡巴斯基拦截的过程

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[spice被卡巴斯基拦截的过程]]
Author:: {原资讯的作者或者对话的人或者引起某种想法的原因}
Source URL::
Modify:: `=dateformat(this.file.mtime, "yyyy-MM-dd HH:MM:ss")`

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary:: 卡巴斯基会拦截浏览器的https连接，猜测，拿取证书时，好像也经过了卡巴斯基，正常在443上拿取证书后，6082的webscoket是连接不上的。白名单一下  或者 关闭卡巴就行了

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_
- 我们的连接是自签名的  
- 并且 还连接websocket 跨了端口的
- 他认为不安全吧
- ![YQ0NY0E_G6KFKMH}6I6DSST.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/YQ0NY0E_G6KFKMH%7D6I6DSST.png)

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_
1. 命令：`tail -f /var/log/html5proxy/spice.log`
2. 卡巴斯基拦截时，开日志时，会发现没有后台日志，证明根本没有到后台，被客户端拦截了，倾向防火墙拦截了
3. 拦截时的日志截图：![](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231113160110.png)
4. 浏览器发现有这个卡巴的websocket连接：
5. ![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231113160818.png)

6. 关闭卡巴斯基，暂停卡巴没用，然后可以正常连接，看到后台日志
7. ![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231113155910.png)

## 1.5. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::


