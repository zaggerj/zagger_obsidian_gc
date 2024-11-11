---
tags: 资源/环境配置
created: 2023-11-06T08:20
updated: 2023-11-14T09:22
---
# 1. 安装powershell

```bash
#powershell配置代理
netsh winhttp set proxy "127.0.0.1:7890"

$ENV:ALL_PROXY ='http://127.0.0.1:7890'

$proxy='http://127.0.0.1:7890'

#powershell删除代理
netsh winhttp reset proxy

$ENV:HTTP_PROXY=$proxy

$ENV:HTTPS_PROXY=$proxy

$env:all_proxy=""

$ENV:HTTP_PROXY=""

$ENV:HTTPS_PROXY=""

$env:all_proxy=""

curl cip.cc

ls env:*


irm scoop.201704.xyz -outfile 'install.ps1'
.\install.ps1 -ScoopDir 'D:\install\Scoop' -ScoopGlobalDir 'D:\install\GlobalScoopApps'
```

　　![截图.png](image1-20230708221750-mtteqnb.png)

```bash
winget install --id Microsoft.Powershell --source winget

[(29条消息) Windows Terminal美化：oh-my-posh配置记录_Miska_Muska的博客-CSDN博客_oh-my-posh](https://blog.csdn.net/qq_45755158/article/details/124677516?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-124677516-blog-127909293.pc_relevant_landingrelevant&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-124677516-blog-127909293.pc_relevant_landingrelevant&utm_relevant_index=1)

winget install scoop

不可行
```

　　‍
