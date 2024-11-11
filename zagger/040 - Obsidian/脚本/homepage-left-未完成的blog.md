---
UID: 20231107184258
aliases: 
tags: 
source: 
cssclass: 
created: 2023-11-07
updated: 2023-11-08T08:21
---

## ✍内容


```dataviewjs
let pages = dv.pages("#Blog and -#Blog/Done");
dv.table(
	["Name","genre" ],
	// sort(compareFn, descStr)
	pages.sort(b => b.file.mtime, "desc")
		.map(b => [b.file.link, b.genre])
)
```