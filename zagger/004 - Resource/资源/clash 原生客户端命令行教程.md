---
alias:
tags: 长青笔记
cdate: 2024-08-19 10:21
uid: 20240819102105
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. clash 原生客户端命令行教程

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2024-08-19 Monday 10:21:04

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

# 2. clash 原生客户端命令行教程（推荐）

## 2.1. 安装

由于 Clash 作者删除了项目，所以还请使用 [https://pub-eac3eb5670f44f09984dee5c57939316.r2.dev/clash-linux-amd64-v1.18.0.gz](https://pub-eac3eb5670f44f09984dee5c57939316.r2.dev/clash-linux-amd64-v1.18.0.gz) 这个下载链接进行下载。解压后执行以下步骤以确保 clash 能够正常启动。

复制

```
chmod +x clash-darwin-amd64-v1.18.0 # 赋与可执行权限
cp clash-darwin-amd64-v1.18.0 /usr/local/bin/clash # 添加到用户可执行文件目录
```

注意，在 macOS 下，首次运行 clash 会被系统安全策略阻止，用户需要手动在「系统偏好设置」-「安全与隐私」中允许 clash 运行。
## 2.2. 配置下载

打开浏览器登陆 AgentNEO，点击套餐进入套餐详情。

![](https://www.neodocs.co/~gitbook/image?url=https%3A%2F%2F2299570314-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-legacy-files%2Fo%2Fassets%252F-MWDNz4ahdkTrt8AMi8V%252F-MWgVJGvg6OxyikKXEWO%252F-MWgXD6yei2xIB3oMbss%252Fclashx-1.jpg%3Falt%3Dmedia%26token%3D5ea0a1b7-b063-4f6a-bc91-86096acd2bdf&width=768&dpr=4&quality=100&sign=2e4fbc7c&sv=1)

点击右侧「**配置链接**」。

![](https://www.neodocs.co/~gitbook/image?url=https%3A%2F%2F2299570314-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-legacy-files%2Fo%2Fassets%252F-MWDNz4ahdkTrt8AMi8V%252F-MWgVJGvg6OxyikKXEWO%252F-MWgZ--Mh1uEBfqNRTaX%252Fclashx-2.jpg%3Falt%3Dmedia%26token%3Dccac3657-09d7-464a-af3a-5480cf1ea6cd&width=768&dpr=4&quality=100&sign=d9bf0ce5&sv=1)

下滑到「**Clash 配置链接**」处，点击「**复制地址**」，

![](https://www.neodocs.co/~gitbook/image?url=https%3A%2F%2F2299570314-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-legacy-files%2Fo%2Fassets%252F-MWDNz4ahdkTrt8AMi8V%252F-MWgc9UG36hTl7EBuHQa%252F-MWgcEItJHF8fyaqDKle%252Fclashx-3.jpg%3Falt%3Dmedia%26token%3Dde6477e3-bbdb-4951-860f-c0a94967e1b9&width=768&dpr=4&quality=100&sign=3fb06779&sv=1)

而后在 shell 中执行以下步骤以下载 clash 配置（其中 `https://example.com/files/clash.yml`为用户复制的链接，需要自行替换）。

复制

```
mkdir /usr/local/etc/clash # 创建配置文件夹
wget -P /usr/local/etc/clash https://example.com/files/clash.yml # 下载订阅文件到本地
mv /usr/local/etc/clash/clash.yml /usr/local/etc/clash/config.yaml
```
## 2.3. 
执行 `clash -d /usr/local/etc/clash` 即可运行 clash 并打印暴露在本地的代理服务端口，默认为 `127.0.0.1:7890`。

更多 clash 运行时控制可参见[官方文档](https://github.com/Dreamacro/clash/wiki/external-controller-API-reference)。
测试代理

### 2.3.1. ubuntu安装步骤
```bash
wget https://pub-eac3eb5670f44f09984dee5c57939316.r2.dev/clash-linux-amd64-v1.18.0.gz
chmod +x clash-linux-amd64-v1.18.0.gz
gzip -d clash-linux-amd64-v1.18.0.gz
chmod +x clash-linux-amd64-v1.18.0
cp clash-linux-amd64-v1.18.0 /usr/local/bin/clash
mkdir /usr/local/etc/clash

# 主机中 D:\install\clash\data\profiles 目录中运行 http-server
wget -P /usr/local/etc/clash http://172.21.15.105:8083/1722943497792.yml
 mv /usr/local/etc/clash/1722943497792.yml /usr/local/etc/clash/config.yaml
 # 偶尔会失败 多执行几次
 ./clash/clash -d /usr/local/etc/clash/
 INFO[0000] Can't find MMDB, start download
 INFO[0001] Start initial compatible provider 自动选择
 INFO[0001] Start initial compatible provider 一元机场
 INFO[0001] Start initial compatible provider 故障转移
 INFO[0001] RESTful API listening at: 127.0.0.1:9090
 INFO[0001] inbound mixed://:7890 created successfully
 ./clash/clash -d /usr/local/etc/clash/
 INFO[0000] Start initial compatible provider 故障转移
 INFO[0000] Start initial compatible provider 自动选择
 INFO[0000] Start initial compatible provider 一元机场
 INFO[0000] inbound mixed://:7890 created successfully
 INFO[0000] RESTful API listening at: 127.0.0.1:9090

# proxy
# default socks5
alias setproxy="export ALL_PROXY=socks5://127.0.0.1:7890;export http_proxy=http://127.0.0.1:7890;export https_proxy=http://127.0.0.1:7890"
# company socks5 ssh tunnel
alias setproxy1="export ALL_PROXY=socks5://59.175.233.194:8181"
# reset proxy
alias unsetproxy="unset ALL_PROXY;unset http_proxy;unset https_proxy;"
 
```
# 3. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
