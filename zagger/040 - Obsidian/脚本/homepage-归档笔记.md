---
UID: 20231107204308
aliases: 
tags: 
source: 
cssclass: 
created: 2023-11-07
updated: 2023-11-08T08:21
---

## ✍内容


```dataviewjs
dv.table(
	["Name", "Modified Date"],
	dv.pages("#Done")
	.sort(b => b.file.mtime, "desc")
	.map(b => [b.file.link, b.file.mtime])
	.limit(10)
)
```