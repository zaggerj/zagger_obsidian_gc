---
<%-*
var cleanTitle = tp.user.getTitleSnippet(tp.file.title)
var title = `${cleanTitle}`;
await tp.file.rename(`${title}`);
let filetype = await tp.system.suggester(["学习", "工作", "非开发","资源","代码库", "obsidian 教程" ,"临时路径"], ["学习","工作", "非开发","资源","代码库", "obsidian 教程","临时"], false, "路径放到哪里？") 
if (filetype === "学习") { 
myFilePath = "/020 - 工作学习/学习/" +  `${title}`;
await tp.file.move(`${myFilePath}`);
} else if (filetype === "工作") { 
myFilePath = "/020 - 工作学习/工作/" +  `${title}`;
await tp.file.move(`${myFilePath}`);
} else if (filetype === "非开发") { 
myFilePath = "/020 - 工作学习/非开发/" +  `${title}`;
await tp.file.move(`${myFilePath}`);
} else if (filetype === "代码库") { 
myFilePath = "/020 - 工作学习/代码库/" +  `${title}`;
await tp.file.move(`${myFilePath}`);
} else if (filetype === "obsidian 教程") { 
myFilePath = "/040 - Obsidian/教程/" +  `${title}`;
await tp.file.move(`${myFilePath}`);
} else if (filetype === "资源") { 
myFilePath = "/004 - Resource/资源/" +  `${title}`;
await tp.file.move(`${myFilePath}`);
}else if (filetype === "临时") { 
myFilePath = "/60 - 临时/" +  `${title}`;
await tp.file.move(`${myFilePath}`);
} else { 
tp.file.cursor(1);
}

-%>

alias:
tags: 长青笔记
cdate: <% tp.file.creation_date() %>
uid: <% tp.date.now("YYYYMMDDHHmmss") %>
update: <%+ tp.file.last_modified_date("YYYY-MM-DD dddd HH:mm:ss") %>
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. <% tp.file.title %>

## 1.1. Metadata

Status:: <% tp.system.suggester(["🌱 发芽状态", "🪴 培育状态", "🌲 长青状态"], ["#笔记状态/🌱 发芽", "#笔记状态/🪴 培育","#笔记状态/🌲 长青"]) %>
Source Type:: <% tp.system.suggester(["💭 想法", "📚 书籍", "📰️ 文章", "🗣️ 聊天", "💻 教学", "▶️ 视频", "🎧️ 播客"], ["#📥/💭 想法 ", "#📥/📚 书籍 ", "#📥/📰️ 文章", "#📥/🗣️ 聊天 ", " #📥/💻 教学", "#📥/▶️ 视频", "#📥/🎧️ 播客"]) %>
Note Type:: <% tp.system.suggester(["笔记", "MOC"], ["#笔记", "#笔记/MOC"]) %>
Topic:: [[<% tp.system.prompt("这个笔记对应的主题MOC ", "DailyNote") %>]]
Author:: {原资讯的作者或者对话的人或者引起某种想法的原因}
Source URL::
Modify:: `=dateformat(this.file.mtime, "yyyy-MM-dd HH:MM:ss")`

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
