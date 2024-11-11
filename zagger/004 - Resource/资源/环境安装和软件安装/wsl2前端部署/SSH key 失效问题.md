---
tags: 资源/环境配置
created: 2023-11-06T08:20
updated: 2023-11-14T09:22
---
# SSH key 失效问题

　　Git配置SSH Key

　　1.检查本机是否有ssh key设置,切换到.ssh目录  
　　$ cd ~/.ssh 或cd .ssh

　　2.配置git用户名和邮箱，配置多个用户时添加 --add 参数  
　　$ git config --global --add user.name "username"  
　　$ git config --global --add user.email "email"

　　　　$ git config --global --unset user.name "username"　　　　　　　　　　　　#移除用户  
　　$ git config --global --unset user.email "email"　　　　　　　　　　　　　　 #移除邮箱

　　3.查看用户名和邮箱  
　　$ git config --list

　　(如果没有安装TortoiseGit则跳过)因为TortoiseGit和Git的冲突需要把TortoiseGit设置改正如下：  
　　1.在右键选择 TortoiseGit  ->  Settings  ->  Network<br />　　2.将SSH client指向  ~Git\usr\bin\ssh.exe  (Git安装路径下的\usr\bin\ssh.exe)

　　4.生成成对的私钥公钥  
　　$ ssh-keygen -t rsa -C "test@qq.com"  
　　注：生成id_rsa私钥公钥时需要命不同文件名，密码可设可不设。

　　5.添加ssh key到对应的GitHub或GitLab上面  
　　登录GitHub系统；点击右上角账号头像的“▼”→Settings→SSH kyes→Add SSH key。  
　　复制id_rsa.pub的公钥内容到Key填写框内。

　　6.测试公钥配置是否成功  
　　$ssh -T git@github.com　　

　　　　FQA  
1.Git克隆代码需要输入密码？Git提交代码需要输入账号、密码的。  
　　tips: 　　 　　1.Access denied.  
　　　　　　　　  2.Authentication failed.  
　　　　　　　　  3.Permission denied (publickey).  
　　说明：

　　	解决方案：[gitlab 页面添加 sshkey后，git clone git@xxx.com:xx.git 任然提示需要输入密码的问题解决。解决debug1: send_pubkey_test: no mutual signature algorithm - 北风之神0509 - 博客园 (cnblogs.com)](https://www.cnblogs.com/ydf0509/p/15718955.html)

　　==	修改~/.ssh/config文件，没有的话新建，xxx.com是==​[==gitlab==](https://so.csdn.net/so/search?q=gitlab&spm=1001.2101.3001.7020)​==的地址==

```bash
Host xxx.com
PubkeyAcceptedKeyTypes=+ssh-rsa
```

　　2.Git采用 http 方式(而不是ssh)clone/pull/push代码时，需要输入用户名密码,解决每次输入账号密码

　　　　解决：执行存储密码命令  
　　　　$git config --global credential.helper store  
　　命令会在项目本地生成一个文本，记录账号和密码。使用上述的命令配置好之后，再操作一次git pull，然后它会提示输入账号和密码，这一次之后就不需要再次输入账号和密码了。

　　常用命令  
$git clone url 　　　　　　　　　　　　　　    　　#克隆远程仓库  
$git --version 　　　　　　　　　　　　　　   　　#查看git的版本信息  
$git branch 　　　　　　　　　　　　　　　   　　#查看本地所有分支  
$git branch -a 　　　　　　　　　　　　　　  　　#查看所有的分支  
$git branch -r 　　　　　　　　　　　　　　   　　#查看远程所有分支  
$git branch dev 　　　　　　　　　　　　　　　　#创建分支  
$git branch -D master develop 　　　　　　　　　 #删除本地库develop

　　$git checkout dev 　　　　　　　　　　　　　　    #切换到本地dev分支  
$git checkout -b dev 　　　　　　　　　　　　　　#创建分支并切换分支  
$git checkout --track origin/dev 　　　　　　　　　 #切换到远程dev分支

　　$git commit 　　　　　　　　　　　　　　　　　　#提交  
$git commit -am "test" 　　　　　　　　　　　　　  #提交并且加注释  
$git commit -m [message] 　　　　　　　　　　　   #提交暂存区到仓库区  
$git commit -v 　　　　　　　　　　　　　　　　    #提交时显示所有diff信息

　　$git status 　　　　　　　　　　　　　　　　　　   #查看当前状态  
$git remote show 　　　　　　　　　　　　　　　　#查看远程库  
$git remote add origin url 　　　　　　　　　　　　 #添加远程库  
$git remote show origin 　　　　　　　　　　　　    #显示远程库origin里的资源

　　$git pull 　　　　　　　　　　　　　　　　　　　　#本地与服务器端同步  
$git push origin master 　　　　　　　　　　　　　 #将文件给推到服务器上  
$git push origin master:develop 　　　　　　　　　  #将本地库develop与服务器上的库进行关联  
$git push origin master:my-dev 　　　　　　　　　   #将本地库与服务器上的库进行关联

　　$git merge origin/dev 　　　　　　　　　　　　　　#将分支dev与当前分支进行合并  
$git add read.txt 　　　　　　　　　　　　　　　　 #将文件加入git  
$git rm read.txt 　　　　　　　　　　　　　　　　  #从git中删除指定文件

　　更多命令参考：[https://www.cnblogs.com/zengming/p/7733099.html](https://www.cnblogs.com/zengming/p/7733099.html "https://www.cnblogs.com/zengming/p/7733099.html")
