---
UID: 20231107204922
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
	["Task", "Name"],
	dv.pages("#稍后读").file.tasks
		.where(t => (!t.completed && t.text.indexOf("#稍后读") > -1))
		.map(b => ["[ ] - " + b.text, b.link])
)
```
