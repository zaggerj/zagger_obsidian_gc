---
alias:
tags: 长青笔记
cdate: 2024-08-19 10:36
uid: 20240819103659
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. linux安装fnm

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2024-08-19 Monday 10:36:58

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

1. curl -fsSL https://fnm.vercel.app/install | bash

2. cargo安装
配置后代理之后

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
vim ~/.bashrc
export PATH="$HOME/.cargo/bin:$PATH"
source ~/.bashrc

cargo install fnm

eval "$(fnm env --use-on-cd --shell bash)"

```

sudo cargo install fnm 输入密码 Updating crates.io index Downloaded fnm v1.37.1 Downloaded 1 crate (180.0 KB) in 1.27s Installing fnm v1.37.1 error: failed to compile `fnm v1.37.1`, intermediate artifacts can be found at `/tmp/cargo-installZnDzlL` Caused by: failed to select a version for the requirement `chrono = "^0.4.38"` candidate versions found which didn't match: 0.4.31, 0.4.30, 0.4.29, ... location searched: crates.io index required by package `fnm v1.37.1` cargo 安装 fnm 时 失败

cargo默认版本太低，需要升级
# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
1. [Schniz/fnm: 🚀 Fast and simple Node.js version manager, built in Rust (github.com)](https://github.com/Schniz/fnm)
