---
alias:
tags: 长青笔记
cdate: 2024-08-27 17:13
uid: 20240827171349
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. windows git bash 配置文件

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2024-08-27 星期二 17:13:49

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

```js
const cp = require("child_process");
const isWin = require("os").platform() === "win32";

if(require.main === module) {
    buildWeb();
    buildExe();
}

function buildWeb(){
    cp.execSync( isWin? 'npm.cmd run build' : 'npm run build', {
        stdio: "inherit"
    });
}

function buildExe() {
  let gitVersion = cp.execSync('git describe --tags', { encoding: 'utf-8' }).trim();
  let command = isWin? 'npm.cmd run dist' : 'npm run dist';
  let envVars = Object.assign({}, process.env, {
      GV: gitVersion,
      ELECTRON_MIRROR: 'https://npmmirror.com/mirrors/electron/',
      ELECTRON_BUILDER_BINARIES_MIRROR: 'https://npmmirror.com/mirrors/electron-builder-binaries/',
      ELECTRON_CUSTOM_DIR: 'v9.4.4'
  });
  let envOptions = { env: envVars, stdio: "inherit" };
  cp.execSync(command, envOptions);
}

```
# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
