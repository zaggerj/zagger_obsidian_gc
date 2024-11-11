---
tags: 资源/环境配置
created: 2023-11-06T08:20
updated: 2023-11-14T09:22
---
# scoop 配置 全局安装目录和局部安装目录

```bash
# 将Scoop安装到自定义目录(命令行方式)
$env:SCOOP='D:\Applications\Scoop'
[Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')

$env:SCOOP='C:\Applications\Scoop'
[Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')


# 将Scoop配置为将全局程序安装到自定义目录 SCOOP_GLOBAL(命令行方式)
```

```bash
$env:SCOOP_GLOBAL='D:\GlobalScoopApps'
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL',$env:SCOOP_GLOBAL, 'Machine')


$env:SCOOP_GLOBAL='C:\GlobalScoopApps'
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL',$env:SCOOP_GLOBAL, 'Machine')

```

##### 安装aria2以加快scoop下载软件的速度

```bash
scoop install aria2
# aria2相关配置
aria2-enabled (默认值: true)
aria2-retry-wait (默认值: 2)
aria2-split (默认值: 5)
aria2-max-connection-per-server (默认值: 5)
aria2-min-split-size (默认值: 5M)

```

# 安装库

```bash
1、main - Default bucket for the most common (mostly CLI) apps
2、extras - Apps that don’t fit the main bucket’s criteria
3、games - Open source/freeware games and game-related tools
4、nerd-fonts - Nerd Fonts
5、nirsoft - A subset of the 250 Nirsoft apps
6、java - Installers for Oracle Java, OpenJDK, Zulu, ojdkbuild, AdoptOpenJDK, 7、Amazon Corretto, BellSoft Liberica & SapMachine
8、jetbrains - Installers for all JetBrains utilities and IDEs
9、nonportable - Non-portable apps (may require UAC)
10、php - Installers for most versions of PHP
11、versions - Alternative versions of apps found in other buckets

```

　　‍

　　‍

# 安装scoop

　　Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser  
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

# 设置环境变量

　　$env:SCOOP='D:\Applications\Scoop'  
[Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')  
$env:SCOOP_GLOBAL='F:\GlobalScoopApps'  
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $env:SCOOP_GLOBAL, 'Machine')

# 设置环境变量之后，建议将默认目录下的所有文件复制到新目录下

# 开始安装软件

　　scoop install aria2

# scoop install <软件名>

# global目录下安装：scoop install -g <软件名>

# 找不到软件？添加软件库

　　scoop bucket add <bucketname>

　　‍

　　‍

# 参考目录

1. [(53条消息) Windows下Scoop安装、配置与使用_luoyooi的博客-CSDN博客](https://blog.csdn.net/luoyooi/article/details/102990113/)
