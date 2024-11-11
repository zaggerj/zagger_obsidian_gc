---
UID: 20231107203759
aliases: 
tags: 
source: 
cssclass: 
created: 2023-11-07
updated: 2023-11-08T08:21
---

## ✍内容


```dataviewjs
// 调用table函数，第一个参数表格的字段名称
dv.table(
	["Name", "author", "publisher", "Create Time"],
	// 第二个参数，在所有标签为"waiting"的笔记中查找
	dv.pages("#waiting")
	// 调用查询函数 具体查询条件
	.where(b => b.type == "Extracts")
	// 调用排序函数 具体的排序字段和规则
	.sort(b => b.file.mtime, "desc")
	// 调用map函数 指定需要的字段
	.map(b => [b.file.link, b.author, b.publisher, b.file.ctime])
)
```