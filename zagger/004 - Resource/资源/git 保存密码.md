---
alias:
tags: 长青笔记
cdate: 2024-08-07 19:26
uid: 20240807192623
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. git 保存密码

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2024-08-07 Wednesday 19:26:23

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

Git 保存用户名和密码通常有两种方式：使用凭证存储器（credential helper）或者使用 SSH 密钥。

使用凭证存储器：

Git 提供了凭证存储功能，可以将用户名和密码保存在一个安全的地方。

git config --global credential.helper store

之后，当你下次访问远程仓库时，Git 会要求你输入用户名和密码，这些信息将会被存储在一个明文文件中（通常在用户主目录下的 .git-credentials 文件）。

使用 SSH 密钥：

另一种方法是使用 SSH 密钥来认证。你需要生成一个 SSH 密钥对，并将公钥添加到远程仓库服务器上。

生成 SSH 密钥对：

ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

之后，你需要将生成的公钥（默认是 ~/.ssh/id_rsa.pub）添加到远程仓库服务的 SSH 密钥中。

在 GitHub 上，你可以在你的个人设置中添加 SSH 密钥；在其他服务（如 GitLab 或 Bitbucket）上，过程类似。

配置 SSH 来连接远程仓库：

git remote set-url origin git@github.com:username/repository.git

这样，Git 就会使用 SSH 密钥进行认证，而不是用户名和密码。
# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
