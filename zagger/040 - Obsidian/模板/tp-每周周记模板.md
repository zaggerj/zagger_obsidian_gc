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

creation date: <% tp.file.creation_date() %>
tags: 周记
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

记录日期：{{monday:YYYY年MM月DD日}} ~ {{friday:YYYY年MM月DD日}}

## 1.1. Metadata

_添加一些元数据，方便后续搜索查看等等_

Status:: <% status %>
Source Type:: <% sourceType %>
Note Type:: <% noteType %>
Topic:: [[<% topic %>]]
Author:: <% author %>
Source URL::
Modify:: <% modifyTime %>

## 1.2. 周待办

_周计划，每周计划完成的事情_

- [ ] 待办示例1
- [ ] 待办示例2
![[{{monday:YYYY年MM月DD日}}#^todo]] 
![[{{tuesday:YYYY年MM月DD日}}#^todo]] 
![[{{wednesday:YYYY年MM月DD日}}#^todo]] 
![[{{thursday:YYYY年MM月DD日}}#^todo]] 
![[{{friday:YYYY年MM月DD日}}#^todo]] 
![[{{saturday:YYYY年MM月DD日}}#^todo]] 
![[{{sunday:YYYY年MM月DD日}}#^todo]] 

# 2. 记录

_集中记录_

## 2.1. {{DATE: gggg年ww周记录}}
![[{{monday:YYYY年MM月DD日}}#^event]] 
![[{{monday:YYYY年MM月DD日}}#^time]] 
![[{{monday:YYYY年MM月DD日}}#^url]] 

---

![[{{tuesday:YYYY年MM月DD日}}#^event]] 
![[{{tuesday:YYYY年MM月DD日}}#^time]] 
![[{{tuesday:YYYY年MM月DD日}}#^url]] 

---

![[{{wednesday:YYYY年MM月DD日}}#^event]] 
![[{{wednesday:YYYY年MM月DD日}}#^time]] 
![[{{wednesday:YYYY年MM月DD日}}#^url]] 

---

![[{{thursday:YYYY年MM月DD日}}#^event]] 
![[{{thursday:YYYY年MM月DD日}}#^time]] 
![[{{thursday:YYYY年MM月DD日}}#^url]] 

---

![[{{friday:YYYY年MM月DD日}}#^event]] 
![[{{friday:YYYY年MM月DD日}}#^time]] 
![[{{friday:YYYY年MM月DD日}}#^url]] 

---

![[{{saturday:YYYY年MM月DD日}}#^event]] 
![[{{saturday:YYYY年MM月DD日}}#^time]] 
![[{{saturday:YYYY年MM月DD日}}#^url]] 

---

![[{{sunday:YYYY年MM月DD日}}#^event]] 
![[{{sunday:YYYY年MM月DD日}}#^time]] 
![[{{sunday:YYYY年MM月DD日}}#^url]] 

