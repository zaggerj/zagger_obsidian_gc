---
created: 2023-11-08T08:31
updated: 2023-11-08T08:31
---
```dataviewjs
	dv.table(["Name","tags","genre"],dv.pages("#Blog")
		.sort(b => b.file.mtime,"desc")
		.map(b => [b.file.link,b.file.tags,b.genre])
	)
```