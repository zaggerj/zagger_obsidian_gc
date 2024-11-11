---
created: 2023-11-06T08:20
updated: 2023-11-06T08:20
---
## Git fetch 的参数

我们刚学习了 git push 的参数，很酷的 `<place>` 参数，还有用冒号分隔的 refspecs（`<source>:<destination>`）。 这些参数可以用于 `git fetch` 吗？

你猜中了！`git fetch` 的参数和 `git push` 极其相似。他们的概念是相同的，只是方向相反罢了（因为现在你是下载，而非上传）

让我们逐个讨论下这些概念……


### `<place>` 参数

如果你像如下命令这样为 `git fetch` 设置 `<place>` 的话：

`git fetch origin foo`

Git 会到远程仓库的 `foo` 分支上，然后获取所有本地不存在的提交，放到本地的 `o/foo` 上。

来看个例子（还是前面的例子，只是命令不同了）
![[Pasted image 20231102171956.png]]

我们只下载了远程仓库中 `foo` 分支中的最新提交记录，并更新了 `o/foo`

![[Pasted image 20231101182658.png]]

你可能会好奇 `——` 为何 Git 会将新提交放到 `o/foo` 而不是放到我本地的 foo 分支呢？之前不是说这样的 `<place>` 参数就是同时应用于本地和远程的位置吗？

好吧, 本例中 Git 做了一些特殊处理，因为你可能在 foo 分支上的工作还未完成，你也不想弄乱它。还记得在 `git fetch` 课程里我们讲到的吗 —— 它不会更新你的本地的非远程分支, 只是下载提交记录（这样, 你就可以对远程分支进行检查或者合并了）。


“如果我们指定 `<source>:<destination>` 会发生什么呢？”

如果你觉得直接更新本地分支很爽，那你就用冒号分隔的 refspec 吧。不过，你不能在当前检出的分支上干这个事，但是其它分支是可以的。

这里有一点是需要注意的 `——` `source` 现在指的是远程仓库中的位置，而 `<destination>` 才是要放置提交的本地仓库的位置。它与 git push 刚好相反，这是可以讲的通的，因为我们在往相反的方向传送数据。

理论上虽然行的通，但开发人员很少这么做。我在这里介绍它主要是为了从概念上说明 `fetch` 和 `push` 的相似性，只是方向相反罢了。

![[Pasted image 20231102172616.png]]

![[Pasted image 20231102172746.png]]


![[Pasted image 20231102172833.png]]


不存在会创建本地分支

![[Pasted image 20231102173033.png]]

没有参数
![[Pasted image 20231102173138.png]]

![[Pasted image 20231102173242.png]]



起点：
![[Pasted image 20231102175119.png]]


目标：
![[Pasted image 20231102175100.png]]


```shell
git fetch origin master^:foo
git fetch origin foo:master
git checkout foo
git merge master
```