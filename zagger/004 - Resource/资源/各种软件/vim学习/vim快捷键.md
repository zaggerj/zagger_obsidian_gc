---
tags: 资源/软件安装
created: 2023-11-03T22:29
updated: 2023-11-14T09:21
---
# 1. vim快捷键

```js
// 从vim中复制到系统剪切板了
gg
shfit+v // 切换到visual模式
shift+g
"+y

// 复制到wsl2中ubuntu系统中
// insert
i  
// 复制
c+v 

c 删除至行尾并进入插入模式

c$ 删除光标到行尾字符，并进入插入模式
d$a

s 当前光标删除再进入插入
xi

= 对齐（=G）
=num回车 当前光标到下多少行对齐
^ 行首与0区别是忽略空格，0是到行首算空格，^是首字符

g_ 行首非空格 $,$算空格，
```

　　‍
