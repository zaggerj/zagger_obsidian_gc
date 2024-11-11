---
created: 2023-11-06T08:20
updated: 2023-11-06T08:20
---
## `<place>`参数详解

还记得之前课程说的吧，当为 git push 指定 place 参数为 `master` 时，我们同时指定了提交记录的来源和去向。

你可能想问 —— 如果来源和去向分支的名称不同呢？比如你想把本地的 `foo` 分支推送到远程仓库中的 `bar` 分支。

哎，很遗憾 Git 做不到…… 开个玩笑，别当真！当然是可以的啦 :) Git 拥有超强的灵活性（有点过于灵活了）

接下来咱们看看是怎么做的……

要同时为源和目的地指定 `<place>` 的话，只需要用冒号 `:` 将二者连起来就可以了：

`git push origin <source>:<destination>`

Source这个参数实际的值是个 refspec，“refspec” 是一个自造的词，意思是 Git 能识别的位置（比如分支 `foo` 或者 `HEAD~1`）

一旦你指定了独立的来源和目的地，就可以组织出言简意赅的远程操作命令了，让我们看看演示！


![[Pasted image 20231102164839.png]]

将 foo 上一个提交，push 到远程仓库的 master 分支了
这是个另人困惑的命令，但是它确实是可以运行的 —— Git 将 `foo^` 解析为一个位置，上传所有未被包含到远程仓库里 `master` 分支中的提交记录。

![[Pasted image 20231102164910.png]]


![[Pasted image 20231102165141.png]]

要推送的远程目的分支不存在，会自动创建远程仓库分支和本地远程分支 o/newBranch；并且看起来本地分支 master 跟踪了远程 o/newBranch 分支

![[Pasted image 20231102165224.png]]



起点：
![[Pasted image 20231102170615.png]]

目标：

![[Pasted image 20231102170556.png]]


```shell
git push origin master^:foo;
git push origin foo:master
```