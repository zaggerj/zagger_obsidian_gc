---
tags: 资源/环境配置
created: 2023-11-06T08:20
updated: 2023-11-14T09:22
---
# git-ssh-key问题

　　ssh -Tv [*git@github.com*](mailto:git@github.com)

　　ping github.com

　　ssh-keygen -t rsa -C "zaggerzj@163.com"

　　1\. 引起的 github ping不通的问题

　　2\. remote: error: GH007: Your push would publish a private email address.

　　3\. 两个ssh-key账号的问题

　　1.在如下文件中添加：c:\Windows\System32\drivers\etc\hosts,

　　192.30.253.112 github.com

　　151.101.88.249 github.global.ssl.fastly.net

2. github网站上设置一下

　　使用命令：git push -u origin master   ,把本地库的内容推送到远程库的过程中,出现了问题 ——remote: error: GH007: Your push would publish a private email address.

　　解决方法——在GitHub的你账号网页上右上角，个人的登录退出的位置，找到setting：    setting-\>emails-\>Keep my email address private，把这一项去掉勾选即可。

　　3\. 新建config文件：

　　~\\ssh\config

　　\# gitlab配置

　　Host 172.16.203.254

　　HostName 172.16.203.254

　　IdentityFile ~\\ssh\id_rsa

　　PreferredAuthentications publickey

　　User huangzijie@os-easy.com

　　\# github配置

　　Host github.com

　　HostName github.com

　　IdentityFile ~\\ssh\id_rsa_github

　　PreferredAuthentications publickey

　　User zaggerzj@163.com
