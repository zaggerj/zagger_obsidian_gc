---
<%-*
var cleanTitle = tp.user.getTitleSnippet(tp.file.title) 
var title = `${cleanTitle}`;
await tp.file.rename(`${title}`);
-%>

alias: 
tags: 
cdate: <% tp.file.creation_date() %>
uid: <% tp.date.now("YYYYMMDDHHmmss") %> 
Update: <% tp.file.last_modified_date("YYYY-MM-DD HH:mm:ss") %>
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. <% tp.file.title %>
## 1.1. Metadata

Status:: <% tp.system.suggester(["🌱 发芽状态", "🪴 培育状态", "🌲 长青状态"], ["#笔记状态/🌱 发芽", "#笔记状态/🪴 培育","#笔记状态/🌲 长青"],false, "笔记状态是？") %>
Source Type:: <% tp.system.suggester(["💭 想法", "📚 书籍", "📰️ 文章", "🗣️ 聊天", "💻 教学", "▶️ 视频", "🎧️ 播客"], ["#📥/💭 想法 ", "#📥/📚 书籍 ", "#📥/📰️ 文章", "#📥/🗣️ 聊天 ", " #📥/💻 教学", "#📥/▶️ 视频", "#📥/🎧️ 播客"],false, "笔记源自哪里？") %>
Note Type:: <% tp.system.suggester(["笔记", "MOC"], ["#笔记", "#MOC"],false, "笔记类型是？") %>
Topic:: [[<% tp.system.prompt("这个笔记对应的主题MOC ", "DailyNote") %>]]
Author:: {原资讯的作者或者对话的人或者引起某种想法的原因}
Modify:: `=dateformat(this.file.mtime, "yyyy-MM-dd HH:MM:ss")`

<%-\* let filetype = await tp.system.suggester(["放入日记", "放入工作", "放入学习", "放入资源","归入人脉", "放入临时"], ["日记","工作", "学习", "资源","人脉", "临时"], false, "Which template do you want to use?")
if (filetype === "工作") {
myFilePath = "/020 - 工作学习/工作/" + `${title}`;
await tp.file.move(`${myFilePath}`);
} else if (filetype === "学习") {
myFilePath = "/020 - 工作学习/学习/" + `${title}`;
await tp.file.move(`${myFilePath}`);
} else if (filetype === "人脉") {
myFilePath = "/010 - 人员管理/人脉/" + `${title}`;
await tp.file.move(`${myFilePath}`);
} else if (filetype === "日记") {
myFilePath = "/000 - 每日日记/DailyNote/" + `${title}`;
await tp.file.move(`${myFilePath}`);
} else if (filetype === "临时") {
myFilePath = "/060 - 临时/" + `${title}`;
await tp.file.move(`${myFilePath}`);
} else if (filetype === "资源") {
myFilePath = "/004 - Resource/资源/" + `${title}`;
await tp.file.move(`${myFilePath}`);
}else {
tp.file.cursor(1)
} -%>
