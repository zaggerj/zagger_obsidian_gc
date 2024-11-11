---
<%-*
const status = ["#笔记状态/🌱 发芽", "#笔记状态/🪴 培育","#笔记状态/🌲 长青"][0]
const sourceType = ["#📥/💭 想法 ", "#📥/📚 书籍 ", "#📥/📰️ 文章", "#📥/🗣️ 聊天 ", " #📥/💻 教学", "#📥/▶️ 视频", "#📥/🎧️ 播客"][0]
const noteType = ["#笔记", "#笔记/MOC"][0]
const topic = "00.学习-前端"
const author = "zagger"
const modifyTime = tp.file.last_modified_date("YYYY-MM-DD dddd HH:mm:ss")
tp.file.cursor(1);
-%>

tags: DailyNote
searchterm: "#周记"
banner: "040 - Obsidian/附件/banners/daily-note-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
week: <% tp.date.now("YYYY-WW") %>
created: <% tp.date.now("YYYY-MM-DD HH:mm:ss") %>
updated: <% tp.date.now("YYYY-MM-DD HH:mm:ss") %>
---

# 1. <% tp.file.title %>

_本文件主旨，并链接到前一天和后一天文件_

<< [[<% tp.date.now("YYYY年MM月DD日", -1, tp.file.title, "YYYY-MM-DD") %>]] | [[<% tp.date.now("YYYY年MM月DD日", 1, tp.file.title, "YYYY-MM-DD") %>]]>>

## 1.1. Metadata

_添加一些元数据，方便后续搜索查看等等_

Status:: <% status %>
Source Type:: <% sourceType %>
Note Type:: <% noteType %>
Topic:: [[<% topic %>]]
Author:: <% author %>
Source URL::
Modify:: <% modifyTime %>

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_

- Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

- [ ] 待办示例 <% tp.file.title %>

^todo

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

### 1.4.1. 事件

_记录当天出现的事件_

**[[<% tp.date.now("YYYY年MM月DD日", 0, tp.file.title, "YYYY年MM月DD日") %>]]事件** 
#跟踪 #重要 #记录 #官方文档 #记录博客 #学习知识点 #计划任务 #远程协助 #会议 #管理任务

^event

#### 1.4.1.1. 每日工时

_记录禅道工时，最终摘抄到禅道_
**[[<% tp.date.now("YYYY年MM月DD日", 0, tp.file.title, "YYYY年MM月DD日") %>]]工时**
- [ ] 08:30 - 09:30 #工时  1h
- [ ] 09:30 - 10:30 #工时  1h
- [ ] 10:30 - 12:00 #工时  1.5h
- [ ] 14:00 - 15:30 #工时  1.5h
- [ ] 15:30 - 16:30 #工时  1h
- [ ] 16:30 - 17:30 #工时  1h

^time

本周记录：[[<%tp.date.now("YYYY年第WW周记录",0, tp.file.title, "YYYY年MM月DD日")%>]]

# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_

Page Link::

^url
