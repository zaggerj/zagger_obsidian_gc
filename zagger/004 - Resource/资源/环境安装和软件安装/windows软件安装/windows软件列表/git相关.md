---
tags: 资源/环境配置
created: 2023-11-06T08:20
updated: 2023-11-14T09:22
---
# git相关

　　ssh-keygen -t rsa

　　表示我们指定 RSA 算法生成密钥，然后敲三次回车键，期间不需要输入密码，之后就就会生成两个文件，分别为id_rsa和id_rsa.pub，即密钥id_rsa和公钥id_rsa.pub. 对于这两个文件，其都为隐藏文件，

　　默认生成在以下目录：

　　Linux 系统：~/.ssh

　　Mac 系统：~/.ssh

　　Windows 系统：C:\Documents and Settings\username\\.ssh

　　Windows 10 ThinkPad：C:\Users\think\\ssh

　　密钥和公钥生成之后，我们要做的事情就是把公钥id_rsa.pub的内容添加到 GitHub，这样我们本地的密钥id_rsa和 GitHub 上的公钥id_rsa.pub才可以进行匹配，授权成功后，就可以向 GitHub 提交代码啦！

　　**验证绑定是否成功**

　　ssh -T [*git@github.com*](http://git@github.com)

　　参考文档：[还不会使用 GitHub ？ GitHub 教程来了！万字图文详解 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/369486197)

　　http方式，用于保存密码

　　git config --global credential.helper store

　　ssh -Tv [*git@172.16.203.254*](http://git@172.16.203.254)

　　你会看到这条信息 debug1: send_pubkey_test: no mutual signature algorithm

　　这两行写在config文件中

　　Host [172.16.203.254](http://172.16.203.254/)

　　PubkeyAcceptedKeyTypes=+ssh-rsa

　　例如我的电脑.s[sh文件](https://so.csdn.net/so/search?q=sh%E6%96%87%E4%BB%B6&spm=1001.2101.3001.7020)夹截图，C:\Users\ydf19\\ssh文件夹中自己新建config文件，写上上面内容就可以啦

　　例如我的电脑.ssh文件夹截图，C:\Users\ydf19\\ssh文件夹中自己新建config文件，写上上面内容就可以啦

　　取消git配置

　　git config --**global** --**unset** http.postBuffer

　　git大文件上传：

　　git lfs install

　　git lfs migrate import --include="\*"

　　参考链接：

　　[(29条消息) gitlab 页面添加不带密码的sshkey后，git clone git@xxx.com:xx.git 仍提示需要输入密码的问题解决_罗汉翔的博客-CSDN博客](https://blog.csdn.net/qq_44885775/article/details/127427068)

　　[(29条消息) git传输时使用的两种协议ssh和http的区别_吨吨不打野的博客-CSDN博客_git http](https://blog.csdn.net/Castlehe/article/details/119530573)

　　[git 本地协议、http、ssh、git协议优缺点总结对比 - 2BiTT - 博客园 (cnblogs.com)](https://www.cnblogs.com/qwj-sysu/p/14763751.html)

　　[重置 git 配置 ](https://qa.1r1g.com/sf/ask/3537140841/)​[ (1r1g.com)](https://qa.1r1g.com/sf/ask/3537140841/)
