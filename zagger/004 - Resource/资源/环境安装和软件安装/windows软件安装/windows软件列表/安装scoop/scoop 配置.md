---
tags: 资源/环境配置
created: 2023-11-06T08:20
updated: 2023-11-14T09:22
---
# 1. scoop

```bash
#scoop配置代理
scoop config proxy 127.0.0.1:7890

#scoop删除代理
scoop config rm proxy

#添加库

scoop bucket add extras

scoop bucket add Java

scoop bucket add dorado https://github.com/chawyehsu/dorado

scoop bucket add versions

scoop bucket add Ash258 https://github.com/Ash258/Scoop-Ash258.git

scoop bucket add iszy https://github.com/ZvonimirSun/scoop-iszy

scoop bucket add dodorz https://github.com/dodorz/scoop

scoop bucket add rasa https://github.com/rasa/scoops

scoop bucket add scoopet https://github.com/integzz/scoopet

scoop bucket add raresoft https://github.com/L-Trump/scoop-raresoft

scoop bucket add nerd-fonts

scoop bucket add everyx https://github.com/everyx/scoop-bucket

scoop install anki dismplusplus electerm ffmpeg geekuninstaller go obs-studio sudo telegram typora vscode wechat winfetch youtube-dl windows-terminal Youdaodict neovim WOX clash-for-windows nvm-windows grep less everything snipaste curl wpsoffice-cn scoopet/baidunetdisk sumatrapdf 7zip idm

scoop install python27 python

python --version # -> Python 3.6.2

# switch to python 2.7.x

scoop reset python27

python --version # -> Python 2.7.13

# switch back (to 3.x)

scoop reset python

python --version # -> Python 3.6.2

7zip Aida64 AoMeiPartition aria2 baidunetdisk cacert CCleanerPro cmder cpu-z crystaldiskinfo crystaldiskmark curl dark dingtalk DiskGenius dismplusplus ditto everything geekuninstaller git googlechrome gpu-z gradle grep IDM innounp less lessmsi lxrunoffline maven motrix nodejs notepadplusplus openssl oraclejdk8 pandoc postman privoxy process-explorer python QQLive QQMusic redis-desktop-manager screentogif shadowsocksr-csharp snipaste SpaceSniffer switchhosts teamviewer touch typora utools vim vscode-portable wechat wget windows-terminal wireshark wox Youdaodict zookeeper
```

　　‍
`TASKKILL /F /PID 8856` powershell
`tasklist | grep 'Code'` windows git bash 
`scoop config aria2 --aria2-opts=--http-proxy=http://127.0.0.1:7890` 配置好aria2代理 ：[代理网络下的aria2工具如何设置进config · Issue #409 · iambus/xunlei-lixian (github.com)](https://github.com/iambus/xunlei-lixian/issues/409)
　　‍
[[a powershell]]

取消aria2下载
`scoop config aria2-enabled false`
# 2. 参考链接

1. [(53条消息) 包管理工具scoop_scoop包管理器_大大大古月的博客-CSDN博客](https://blog.csdn.net/m0_49945160/article/details/127023180)
