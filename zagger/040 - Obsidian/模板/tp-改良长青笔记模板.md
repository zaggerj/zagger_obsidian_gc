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

alias:
tags: 长青笔记
cdate: <% tp.file.creation_date() %>
uid: <% tp.date.now("YYYYMMDDHHmmss") %>
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. <% tp.file.title %>

## 1.1. Metadata

Status:: <% status %>
Source Type:: <% sourceType %>
Note Type:: <% noteType %>
Topic:: [[<% topic %>]]
Author:: <% author %>
Source URL::
Modify:: <% modifyTime %>

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
