---
created: 2023-11-06T08:20
updated: 2023-11-06T08:20
---
## Git Push 的参数

很好! 既然你知道了远程跟踪分支，我们可以开始揭开 git push、fetch 和 pull 的神秘面纱了。我们会逐个介绍这几个命令，它们在理念上是非常相似的。

首先来看 `git push`。在远程跟踪课程中，你已经学到了 Git 是通过当前检出分支的属性来确定远程仓库以及要 push 的目的地的。这是未指定参数时的行为，我们可以为 push 指定参数，语法是：

`git push <remote> <place>`

`<place>` 参数是什么意思呢？我们稍后会深入其中的细节, 先看看例子, 这个命令是:

`git push origin master`

把这个命令翻译过来就是：

_切到本地仓库中的“master”分支，获取所有的提交，再到远程仓库“origin”中找到“master”分支，将远程仓库中没有的提交记录都添加上去，搞定之后告诉我。_

我们通过“place”参数来告诉 Git 提交记录来自于 master, 要推送到远程仓库中的 master。它实际就是要同步的两个仓库的位置。

需要注意的是，因为我们通过指定参数告诉了 Git 所有它需要的信息, 所以它就忽略了我们所检出的分支的属性！
![[Pasted image 20231102163955.png]]

![[Pasted image 20231102164013.png]]

![[Pasted image 20231102164114.png]]

如果不给参数，默认是从当前分支推送，
游离 HEAD 没有跟踪任何分支；

![[Pasted image 20231102164131.png]]


![[Pasted image 20231102164354.png]]


```shell
git push origin master
git push origin foo
```

![[Pasted image 20231102164347.png]]

