---
alias:
tags: 长青笔记
cdate: 2024-07-17 11:35
uid: 20240717113517
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. windows操作系统重装教程

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2024-07-17 星期三 11:35:16

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

### 1.4.1. 安装7zip
[Download (7-zip.org)](https://www.7-zip.org/download.html)
### 1.4.2. 安装scoop

1. 先升级powershell到最新：[在 Windows 上安装 PowerShell](https://learn.microsoft.com/zh-cn/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.4#msi)
2. 安装scoop：
```bash
# 1. 安装scoop：
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# 2. 配置目录：

.\install.ps1 -ScoopDir 'D:\install\Scoop' -ScoopGlobalDir 'D:\install\GlobalScoopApps'
irm scoop.201704.xyz -outfile 'install.ps1

[Environment]::SetEnvironmentVariable('SCOOP', 'D:\install\Scoop', 'User')
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', 'D:\install\GlobalScoopApps', 'Machine')

# 3. 配置scoop
netsh winhttp set proxy "127.0.0.1:7890"

$ENV:ALL_PROXY ='http://127.0.0.1:7890'

$proxy='http://127.0.0.1:7890'

$ENV:HTTP_PROXY=$proxy

$ENV:HTTPS_PROXY=$proxy

# 4. 清空代理
$env:all_proxy=""

$ENV:HTTP_PROXY=""

$ENV:HTTPS_PROXY=""

$env:all_proxy=""

# 5. 测试
curl google.com

# 6. 配置scoop 代理
scoop config proxy 127.0.0.1:7890

# 7. scoop添加安装库
scoop bucket add extras
scoop bucket add Java
scoop bucket add dorado https://github.com/chawyehsu/dorado
scoop bucket add nerd-fonts
scoop bucket add versions

# 8. 安装aria2 配置aria2
# scoop install aria2 -g
scoop config aria2-enabled true
scoop config aria2-warning-enabled false

# 安装软件
scoop install git flameshot fnm vscode windows-terminal aria2 picgo PowerToys -g


# 新建账号 加到sudo组
sudo adduser newuser # 创建新用户newuser

sudo usermod -aG sudo newuser # 将newuser添加到sudo组

```

### 1.4.3. winget
1. 先配置好powershell代理之后，完美下载！（失效）

`Invoke-Expression (Invoke-WebRequest -Uri 'https://aka.ms/getwinget')`

但是会卡住

2. 采用：[Releases · microsoft/winget-cli (github.com)](https://github.com/microsoft/winget-cli/releases?spm=5176.28103460.0.0.53ed572ca9sm0u)也卡住（失效）
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240813094217.png)
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240813095449.png)

3. 设置好系统代理，然后更新系统更新，然后打开store，可以打开了，然后更新所有包即可。 （成功）![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240813113403.png)
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240813113957.png)
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240813114016.png)
终于安装成功了。
#### 1.4.3.1. 获取 WinGet

首先确认系统是否满足需求：WinGet 只可以运行在 Windows10 高于 1709 (Build 16299) 的版本和 Windows11 上。
在安装 WinGet 之前，建议使用微软新推出的终端模拟器 Windows Terminal 代替传统的conhost.exe。

#### 1.4.3.2. 配置winget
##### 1.4.3.2.1. 常用命令：替换源
```powershell
winget source remove winget
winget source add winget https://mirrors.ustc.edu.cn/winget-source

# 搜索软件包
winget search 7zip

# 常用命令：查看软件包
winget show --id 7zip.7zip

# 常用命令：安装软件包
winget install --id 7zip.7zip --rainbow

# 常用命令：更新软件包
winget upgrade --id 7zip.7zip --rainbow

# 常用命令：卸载软件包
winget uninstall --id 7zip.7zip

# 获取和使用 WingetUI
# 既然有了 WinGet ，就可以直接从 WinGet 安装 WingetUI：
winget install --id SomePythonThings.WingetUIStore --rainbow
```

[【干货】Windows软件包管理器（WinGet）最实用教程 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/659515299)
### 1.4.4. windows terminal
Windows Terminal 和 WinGet 都可以通过系统预装的 Microsoft Store 商店搜索安装，也可以转到下面的网页调用 Microsoft Store 安装，也可以去微软托管在 GitHub 的发布页下载安装包到本地安装（较新版本的 Windows11 已经预装，如已预装请略过此章节）。
### 1.4.5. Windows10/11 LTS 版本，长期服务频道（企业版 LTSC，IoT 企业版 LTSC）

如果使用了 Windows LTSC 版本的系统，需要先安装一个 Microsoft Store 的环境才能安装 Windows Terminal 和 WinGet。

CTRL+SHIFT+ESC 呼出任务管理器，打开详细信息界面：

```powershell
wsreset.exe -i
```

等待运行完成，待到窗口重新出现命令提示符以后，开始菜单出现了 Microsoft Store 的图标，就可以参考 Windows10/11 非 LTS 版本的安装方法安装 Windows Terminal 和 WinGet 。
### 1.4.6. Chocolatey

`Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`
### 1.4.7. resilio sync
[Download Sync (resilio.com)](https://www.resilio.com/sync/download/)
![[Resilio Sync.btskey]]
### 1.4.8. clash

订阅链接：`https://sub1.smallstrawberry.com/api/v1/client/subscribe?token=7f06f7e65d0c2d8b0f7ef161c4ecb6b3`

### 1.4.9. windows升级

clash 全局  系统代理

升级 才可以跑起来

### 1.4.10. windows terminal
需要升级好windows系统之后才可以安装`Microsoft.WindowsTerminalPreview_1.21.1772.0_8wekyb3d8bbwe.msixbundle` 文件

配置文件路径
`C:\Users\zagger\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`
```json
{
    "$help": "https://aka.ms/terminal-documentation",
    "$schema": "https://aka.ms/terminal-profiles-schema",
    "actions": 
    [
        {
            "command": 
            {
                "action": "copy",
                "singleLine": false
            },
            "keys": "ctrl+c"
        },
        {
            "command": "paste",
            "keys": "ctrl+v"
        },
        {
            "command": 
            {
                "action": "splitPane",
                "split": "auto",
                "splitMode": "duplicate"
            },
            "keys": "alt+shift+d"
        },
        {
            "command": "find",
            "keys": "ctrl+shift+f"
        }
    ],
    "copyFormatting": "none",
    "copyOnSelect": false,
    "defaultProfile": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
    "newTabMenu": 
    [
        {
            "type": "remainingProfiles"
        }
    ],
    "profiles": 
    {
        "defaults": {},
        "list": 
        [
            {
                "commandline": "%SystemRoot%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
                "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
                "hidden": false,
                "name": "Windows PowerShell"
            },
            {
                "commandline": "\"D:\\install\\GlobalScoopApps\\apps\\git\\current\\bin\\bash.exe\" --login -i",
                "elevate": false,
                "guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
                "hidden": false,
                "icon": "D:\\install\\GlobalScoopApps\\apps\\git\\current\\usr\\share\\git\\git.ico",
                "name": "GitBash",
                "startingDirectory": "D:\\code"
            },
            {
                "guid": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
                "hidden": false,
                "name": "PowerShell",
                "source": "Windows.Terminal.PowershellCore"
            },
            {
                "guid": "{b453ae62-4e3d-5e58-b989-0a998ec441b8}",
                "hidden": false,
                "name": "Azure Cloud Shell",
                "source": "Windows.Terminal.Azure"
            },
            {
                "guid": "{ad2e605a-62be-5571-ae83-1c0ef203f6df}",
                "hidden": false,
                "name": "Developer Command Prompt for VS 2022",
                "source": "Windows.Terminal.VisualStudio"
            },
            {
                "guid": "{a0469ae8-4734-5b0e-b13f-31bec4b2db57}",
                "hidden": false,
                "name": "Developer PowerShell for VS 2022",
                "source": "Windows.Terminal.VisualStudio"
            }
        ]
    },
    "schemes": 
    [
        {
            "background": "#0C0C0C",
            "black": "#0C0C0C",
            "blue": "#0037DA",
            "brightBlack": "#767676",
            "brightBlue": "#3B78FF",
            "brightCyan": "#61D6D6",
            "brightGreen": "#16C60C",
            "brightPurple": "#B4009E",
            "brightRed": "#E74856",
            "brightWhite": "#F2F2F2",
            "brightYellow": "#F9F1A5",
            "cursorColor": "#FFFFFF",
            "cyan": "#3A96DD",
            "foreground": "#CCCCCC",
            "green": "#13A10E",
            "name": "Campbell",
            "purple": "#881798",
            "red": "#C50F1F",
            "selectionBackground": "#FFFFFF",
            "white": "#CCCCCC",
            "yellow": "#C19C00"
        },
        {
            "background": "#012456",
            "black": "#0C0C0C",
            "blue": "#0037DA",
            "brightBlack": "#767676",
            "brightBlue": "#3B78FF",
            "brightCyan": "#61D6D6",
            "brightGreen": "#16C60C",
            "brightPurple": "#B4009E",
            "brightRed": "#E74856",
            "brightWhite": "#F2F2F2",
            "brightYellow": "#F9F1A5",
            "cursorColor": "#FFFFFF",
            "cyan": "#3A96DD",
            "foreground": "#CCCCCC",
            "green": "#13A10E",
            "name": "Campbell Powershell",
            "purple": "#881798",
            "red": "#C50F1F",
            "selectionBackground": "#FFFFFF",
            "white": "#CCCCCC",
            "yellow": "#C19C00"
        },
        {
            "background": "#282C34",
            "black": "#282C34",
            "blue": "#61AFEF",
            "brightBlack": "#5A6374",
            "brightBlue": "#61AFEF",
            "brightCyan": "#56B6C2",
            "brightGreen": "#98C379",
            "brightPurple": "#C678DD",
            "brightRed": "#E06C75",
            "brightWhite": "#DCDFE4",
            "brightYellow": "#E5C07B",
            "cursorColor": "#FFFFFF",
            "cyan": "#56B6C2",
            "foreground": "#DCDFE4",
            "green": "#98C379",
            "name": "One Half Dark",
            "purple": "#C678DD",
            "red": "#E06C75",
            "selectionBackground": "#FFFFFF",
            "white": "#DCDFE4",
            "yellow": "#E5C07B"
        },
        {
            "background": "#FAFAFA",
            "black": "#383A42",
            "blue": "#0184BC",
            "brightBlack": "#4F525D",
            "brightBlue": "#61AFEF",
            "brightCyan": "#56B5C1",
            "brightGreen": "#98C379",
            "brightPurple": "#C577DD",
            "brightRed": "#DF6C75",
            "brightWhite": "#FFFFFF",
            "brightYellow": "#E4C07A",
            "cursorColor": "#4F525D",
            "cyan": "#0997B3",
            "foreground": "#383A42",
            "green": "#50A14F",
            "name": "One Half Light",
            "purple": "#A626A4",
            "red": "#E45649",
            "selectionBackground": "#4F525D",
            "white": "#FAFAFA",
            "yellow": "#C18301"
        },
        {
            "background": "#002B36",
            "black": "#002B36",
            "blue": "#268BD2",
            "brightBlack": "#073642",
            "brightBlue": "#839496",
            "brightCyan": "#93A1A1",
            "brightGreen": "#586E75",
            "brightPurple": "#6C71C4",
            "brightRed": "#CB4B16",
            "brightWhite": "#FDF6E3",
            "brightYellow": "#657B83",
            "cursorColor": "#FFFFFF",
            "cyan": "#2AA198",
            "foreground": "#839496",
            "green": "#859900",
            "name": "Solarized Dark",
            "purple": "#D33682",
            "red": "#DC322F",
            "selectionBackground": "#FFFFFF",
            "white": "#EEE8D5",
            "yellow": "#B58900"
        },
        {
            "background": "#FDF6E3",
            "black": "#002B36",
            "blue": "#268BD2",
            "brightBlack": "#073642",
            "brightBlue": "#839496",
            "brightCyan": "#93A1A1",
            "brightGreen": "#586E75",
            "brightPurple": "#6C71C4",
            "brightRed": "#CB4B16",
            "brightWhite": "#FDF6E3",
            "brightYellow": "#657B83",
            "cursorColor": "#002B36",
            "cyan": "#2AA198",
            "foreground": "#657B83",
            "green": "#859900",
            "name": "Solarized Light",
            "purple": "#D33682",
            "red": "#DC322F",
            "selectionBackground": "#073642",
            "white": "#EEE8D5",
            "yellow": "#B58900"
        },
        {
            "background": "#000000",
            "black": "#000000",
            "blue": "#3465A4",
            "brightBlack": "#555753",
            "brightBlue": "#729FCF",
            "brightCyan": "#34E2E2",
            "brightGreen": "#8AE234",
            "brightPurple": "#AD7FA8",
            "brightRed": "#EF2929",
            "brightWhite": "#EEEEEC",
            "brightYellow": "#FCE94F",
            "cursorColor": "#FFFFFF",
            "cyan": "#06989A",
            "foreground": "#D3D7CF",
            "green": "#4E9A06",
            "name": "Tango Dark",
            "purple": "#75507B",
            "red": "#CC0000",
            "selectionBackground": "#FFFFFF",
            "white": "#D3D7CF",
            "yellow": "#C4A000"
        },
        {
            "background": "#FFFFFF",
            "black": "#000000",
            "blue": "#3465A4",
            "brightBlack": "#555753",
            "brightBlue": "#729FCF",
            "brightCyan": "#34E2E2",
            "brightGreen": "#8AE234",
            "brightPurple": "#AD7FA8",
            "brightRed": "#EF2929",
            "brightWhite": "#EEEEEC",
            "brightYellow": "#FCE94F",
            "cursorColor": "#000000",
            "cyan": "#06989A",
            "foreground": "#555753",
            "green": "#4E9A06",
            "name": "Tango Light",
            "purple": "#75507B",
            "red": "#CC0000",
            "selectionBackground": "#555753",
            "white": "#D3D7CF",
            "yellow": "#C4A000"
        },
        {
            "background": "#000000",
            "black": "#000000",
            "blue": "#000080",
            "brightBlack": "#808080",
            "brightBlue": "#0000FF",
            "brightCyan": "#00FFFF",
            "brightGreen": "#00FF00",
            "brightPurple": "#FF00FF",
            "brightRed": "#FF0000",
            "brightWhite": "#FFFFFF",
            "brightYellow": "#FFFF00",
            "cursorColor": "#FFFFFF",
            "cyan": "#008080",
            "foreground": "#C0C0C0",
            "green": "#008000",
            "name": "Vintage",
            "purple": "#800080",
            "red": "#800000",
            "selectionBackground": "#FFFFFF",
            "white": "#C0C0C0",
            "yellow": "#808000"
        }
    ],
    "themes": []
}
```

![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240816152716.png)

### 1.4.11. vscode
1. 没有使用scoop安装
2. 全局搜索 ctrl+shift+f 被搜狗输入法 占用了，直接取消。
3. ctrl+shift+P 跟picgo 冲突了 直接取消
4. i18n ally插件无法识别的问题
5. `"terminal.integrated.env.windows": {"NODE_PATH": "C:\\Users\\zagger\\AppData\\Roaming\\fnm\\node-versions\\v18.20.4\\installation"},`
	
	查看vscode 某个插件的日志，发现有报错:vscode i18n ally 插件报错 node is not recognized as an internal or external command。改完之后没有原来的报错了。![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240812144307.png)
6. nodejs添加环境变量  ![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240812151514.png)


### 1.4.12. flameshot

windows无法设置快捷键

### 1.4.13. picgo
scoop 安装
token 保存在手机
配置好picgo，图片才会展示
有ctrl+shift+P 快捷键 跟vscode 冲突
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240807164950.png)

![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240807164925.png)

### 1.4.14. PowerToys
scoop安装
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240808154005.png)


### 1.4.15. everything
[voidtools](https://www.voidtools.com/zh-cn/)

### 1.4.16. git 配置
```
git config --global user.name "zagger"
git config --global user.email "huangzijie@os-easy.com"
git config --global credential.helper store

# 移除 Git 跟踪状态
git rm --cached file
git rm --cached -r fold/
git add .gitignore
git commit -m "Add to .gitignore and remove tracked files"
```

[[git 保存密码]]

### 1.4.17. fnm
```bash
# .bash_profile
eval "$(fnm env --use-on-cd)"
fnm install v16
fnm use v16

fnm install v18
fnm use v18

# v16和v18 都装一下
# https://npmmirror.com/
# npm install -g cnpm --registry=https://registry.npmmirror.com
npm install -g yarn --registry=https://registry.npmmirror.com
npm install -g pnpm --registry=https://registry.npmmirror.com
# 安装特定版本的pnpm
npm install -g pnpm@8.14.0 --registry=https://registry.npmmirror.com

# pnpm install 一直开在 Lockfile is up to date, resolution step is skipped

# rm -rf node_modules权限不足导致的
# pnpm cache clean

```

### 1.4.18. virtualbox
[Oracle VM VirtualBox](https://www.virtualbox.org/)

1. 选择桥接网络![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240808185527.png)

2. 选择启用uefi![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240808185437.png)
3. 设置启动顺序 ![企业微信截图_17231656809918.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_17231656809918.png)
4. 开机前：要设置u-disk启动，每次关闭电源之后，都需要重新设置u-disk。![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240809133058.png)

5. 开机后：要移除u-disk启动，这样就可以进选单界面。![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240809121406.png)


### 1.4.19. ftp工具
[MobaXterm (lanzoub.com)](https://gndown.lanzoub.com/b048r8poh)

### 1.4.20. Dism++
[Release Dism++ 10.1.1002.2 · Chuyu-Team/Dism-Multi-language (github.com)](https://github.com/Chuyu-Team/Dism-Multi-language/releases/tag/v10.1.1002.2)

### 1.4.21. electron安装失败
```bash

# .npmrc

# npm 包注册源地址（包括末尾斜杠）
registry = https://registry.npmmirror.com/
npmmirror = https://npmmirror.com/mirrors/

ELECTRON_MIRROR=https://npmmirror.com/mirrors/electron/
electron_mirror=https://npmmirror.com/mirrors/electron/
electron-builder-binaries_mirror=https://npmmirror.com/mirrors/electron-builder-binaries/

shamefully-hoist=true

```
### 1.4.22. git bash 脚本
[[windows git bash 配置文件]]
# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
