---
alias:
tags: 长青笔记
cdate: 2024-05-13 11:42
uid: 20240513114210
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. 渲染进程和渲染进程通讯：使用 MessagePort例子

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2024-05-13 星期一 11:42:09

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_
```js
import { BrowserWindow, app, MessageChannelMain } from 'electron'
app.whenReady().then(async () => {
  // 创建窗口
  const mainWindow = new BrowserWindow({
    show: false,
    webPreferences: { contextIsolation: false, preload: 'preloadMain.js' }
  })
  const secondaryWindow = new BrowserWindow({
    show: false,
    webPreferences: { contextIsolation: false, preload: 'preloadSecondary.js' }
  })
  // 建立通道
  const { port1, port2 } = new MessageChannelMain()
  // webContents准备就绪后，使用postMessage向每个webContents发送一个端口。
  mainWindow.once('ready-to-show', () => {
    mainWindow.webContents.postMessage('port', null, [port1])
  })
  secondaryWindow.once('ready-to-show', () => {
    secondaryWindow.webContents.postMessage('port', null, [port2])
  })
})

//
// mainWindow
port1.onmessage = (event) => {
  console.log('received result:', event.data)
}
port1.postMessage('我是渲染进程一发送的消息')
// secondaryWindow
port2.onmessage = (event) => {
  console.log('received result:', event.data)
}
port2.postMessage('我是渲染进程二发送的消息')

// preloadMain.js
// preloadSecondary.js
const { ipcRenderer } = require('electron')
ipcRenderer.on('port', (e) => {
  // 接收到端口，使其全局可用。
  window.electronMessagePort = e.ports[0]
  window.electronMessagePort.onmessage = (messageEvent) => {
    // 处理消息
  }
})

// mainWindow renderer.js
// 在 renderer 的任何地方都可以调用 postMessage 向另一个进程发送消息 w
window.electronMessagePort.postMessage('ping')

```
# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
