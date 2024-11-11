---
created: 2023-11-06T08:20
updated: 2023-11-06T08:20
---
### 古怪的 `<source>`

Git 有两种关于 `<source>` 的用法是比较诡异的，即你可以在 git push 或 git fetch 时不指定任何 `source`，方法就是仅保留冒号和 destination 部分，source 部分留空。

- `git push origin :side`
- `git fetch origin :bugFix`

我们分别来看一下这两条命令的作用……


![[Pasted image 20231102180557.png]]![[Pasted image 20231102180638.png]]![[Pasted image 20231102180651.png]]![[Pasted image 20231102180737.png]]