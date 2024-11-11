---
tags: 资源/环境配置
created: 2023-11-06T08:20
updated: 2023-11-14T09:22
---
# 1. a powershell

　　iwr -useb https://gitee.com/glsnames/scoop-installer/raw/master/bin/install.ps1 \| iex

　　cmd

　　![截图.png](记事本/学习/学习目录/obsidian使用相关/Attachment/assets%201/image1-20230705215226-8cdtiqv.png)

　　设置**临时**代理（关闭cmd即设置的代理消失）

　　set all_proxy=socks5://127.0.0.1:10808 (**端口号为你代理软件socks5协议的端口**)

　　删除临时代理

　　set all_proxy=

　　\$env:SCOOP='D:\Applications\Scoop'

　　\[Environment\]::SetEnvironmentVariable('SCOOP', \$env:SCOOP, 'User')

　　☐ \$env:SCOOP_GLOBAL='D:\GlobalScoopApps'

　　\[Environment\]::SetEnvironmentVariable('SCOOP_GLOBAL', \$env:SCOOP_GLOBAL, 'Machine')

　　设置代理

　　netsh winhttp set proxy "127.0.0.1:7890"

　　取消代理

　　netsh winhttp reset proxy

　　安装程序

　　winget install --id Microsoft.Powershell --source winget

　　查看版本\$psversiontable 或 \$host 查看 PowerShell 的版本

　　code \$PROFILE

　　**oh-my-posh可以直接在windows商店中安装**

　　![截图.png](记事本/学习/学习目录/obsidian使用相关/Attachment/assets%201/image2-20230705215226-ujwrjwi.png)

　　安装scoop

　　Set-ExecutionPolicy RemoteSigned -scope CurrentUser

　　一直报错默认不能用admin运行

　　iex "& {\$(irm get.scoop.sh)} -RunAsAdmin"

　　iwr -useb get.scoop.sh \| iex

　　scoop install sudo

　　scoop config rm SCOOP_REPO

　　![截图.png](记事本/学习/学习目录/obsidian使用相关/Attachment/assets%201/image3-20230705215226-6wru1kl.png)

　　scoop config proxy 127.0.0.1:7890

　　![截图.png](记事本/学习/学习目录/obsidian使用相关/Attachment/assets%201/image4-20230705215226-gtwekt1.png)

　　code \$PROFILE

　　scoop安装软件

　　*​ 设置代理*

　　**scoop config proxy 127.0.0.1:7890**

　　Scoop install git

　　*​ 一些额外的软件，是官方维护的一些并不完全符合官方规范的应用，但是它们又非常常用*

　　scoop bucket **add** extras

　　*​ 一些字体*

　　scoop bucket **add** nerd-fonts

　　*​ 一些软件的更多版本*

　　scoop bucket **add** versions

　　*​ 有许多我们会用到的常用软件*

　　scoop bucket **add** dorado [https://github.com/chawyehsu/dorado](https://github.com/chawyehsu/dorado)

　　scoop install aria2

　　aria2相关配置

　　aria2-enabled (默认值: true)

　　aria2-retry-wait (默认值: 2)

　　aria2-split (默认值: 5)

　　aria2-max-connection-per-server (默认值: 5)

　　aria2-min-split-size (默认值: 5M)

　　scoop bucket add versions

　　scoop config SCOOP_REPO /squallliu/scoop

　　scoop update

　　sudo scoop install 7zip git openssh --global

　　scoop install aria2 curl grep sed less touch

　　scoop install python ruby go perl

　　\$ scoop bucket add versions \# add the 'versions' bucket if you haven't already

　　\$ scoop install python27 python

　　python --version \# -\> Python 3.6.2

　　\# switch to python 2.7.x

　　\$ scoop reset python27

　　python --version \# -\> Python 2.7.13

　　\# switch back (to 3.x)

　　\$ scoop reset python

　　python --version \# -\> Python 3.6.2

　　**添加库**

　　首先Scoop默认带的软件非常少，我们首先需要添加一些常用库：

　　      scoop bucket add extras

　　      scoop bucket add Java

　　      scoop bucket add dorado [https://github.com/chawyehsu/dorado](https://github.com/chawyehsu/dorado)

　　**梭哈安装软件**

　　以下是我个人安装的软件的梭哈安装命令：

　　scoop install anki dismplusplus electerm ffmpeg geekuninstaller go nodejs obs-studio sudo telegram typora vscode wechat winfetch youtube-dl windows-terminal

　　neovim WOX

　　**使用说明**

　　这里只介绍常用命令，具体还需要大家自己发掘。

　　      scoop install 软件名 \#安装软件

　　      scoop uninstall 软件名 \#卸载软件

　　      scoop search 软件名 \#搜索软件

　　      scoop hold 软件名 \#禁用指定软件更新

　　      scoop unhold 软件名 \#启用指定软件更新

　　      scoop update \* \#更新全部软件

　　      scoop reset 软件名 \#重置指定软件

　　另外，Scoop安装的软件大部分配置文件都存储在Scoop目录下的 persist文件夹内，如果换电脑可以事先备份此文件夹，在新电脑上软件都安装好，再复制进去。

　　安装chocolatey

　　Set-ExecutionPolicy Bypass -Scope Process -Force; \[System.Net.ServicePointManager\]::SecurityProtocol = \[System.Net.ServicePointManager\]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('[https://community.chocolatey.org/install.ps1](https://community.chocolatey.org/install.ps1)'))

　　**choco config set proxy 127.0.0.1:7890**

　　choco config unset proxy

　　choco install neovim -y

　　explicit

　　5、升级安装的某个软件或升级所有

　　choco upgrade name

　　choco upgrade all -y

　　1

　　2

　　6、搜索需要的包名

　　choco search name

　　1

　　7、安装对应的软件（指定版本）

　　choco install name

　　choco install name -version \*\*\*

　　1

　　2

　　8、卸载对应的包

　　choco uninstall name

　　1

　　9、软件列表备份

　　choco list -l \> d:\chocolatey.txt

　　choco list -li \> d:\chocolatey.txt

　　1

　　2

　　​有了导出的软件清单，可以在新机上或者是在重装电脑之后直接执行命令安装：

　　choco install -y namea nameb namec

　　1

　　​把软件一个个都装上了，好不方便！

　　10、显示包的详细信息

　　choco info name

　　————————————————

　　版权声明：本文为CSDN博主「xzsfg6825」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。

　　原文链接：[https://blog.csdn.net/xzsfg6825/article/details/118890694](https://blog.csdn.net/xzsfg6825/article/details/118890694)

　　设置-应用-可选应用-选择openSSh 服务器

　　ssh -V

　　sc config sshd start=auto

　　net start sshd

　　netsh advfirewall firewall add rule name="SSH PORT 22" dir=in action=allow protocol=TCP localport=22

　　7zip Aida64 AoMeiPartition aria2 baidunetdisk cacert CCleanerPro cmder cpu-z crystaldiskinfo crystaldiskmark curl dark dingtalk DiskGenius dismplusplus ditto everything geekuninstaller git googlechrome gpu-z gradle grep IDM innounp less lessmsi lxrunoffline maven motrix nodejs notepadplusplus openssl oraclejdk8 pandoc postman privoxy process-explorer python QQLive QQMusic redis-desktop-manager screentogif shadowsocksr-csharp snipaste SpaceSniffer switchhosts teamviewer touch typora utools vim vscode-portable wechat wget windows-terminal wireshark wox Youdaodict zookeeper

　　[Window包管理工具Scoop - hongdada - 博客园 (cnblogs.com)](https://www.cnblogs.com/hongdada/p/11844277.html)

　　[如何解决写脚手架过程中遇到请求github的项目接口中出现API rate limit exceeded for的问题。 - 未来-竭尽全力 - 博客园 (cnblogs.com)](https://www.cnblogs.com/hjdjs/p/11452387.html)
