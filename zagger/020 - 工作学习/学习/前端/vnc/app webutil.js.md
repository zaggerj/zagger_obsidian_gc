---
alias:
tags: 长青笔记
cdate: 2023-12-13 11:25
uid: 20231213112617
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. app webutil.js

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2023-12-13 星期三 11:25:43

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

该代码是一个包含多个功能的模块，主要用于处理浏览器中的日志记录、Cookie操作和设置管理。

代码中的主要函数和功能如下：

1. `initLogging(level)`: 用于初始化日志记录级别。它会读取浏览器URL中的`logging`参数，并将其传递给日志记录模块进行初始化。
    
2. `getQueryVar(name, defVal)`: 用于从查询字符串中获取指定名称的变量值。它会解析当前浏览器URL中的查询字符串，并返回指定参数名的值。
    
3. `getHashVar(name, defVal)`: 用于从哈希片段中获取指定名称的变量值。它会解析当前浏览器URL中的哈希片段，并返回指定参数名的值。
    
4. `getConfigVar(name, defVal)`: 从查询字符串或哈希片段中获取指定名称的变量值。如果哈希片段中存在指定参数名的值，则优先返回哈希片段中的值；否则，返回查询字符串中的值。
    
5. `createCookie(name, value, days)`: 用于创建一个Cookie。它接受名称、值和可选的过期天数作为参数，并在浏览器中创建相应的Cookie。
    
6. `readCookie(name, defaultValue)`: 用于读取指定名称的Cookie的值。它会解析浏览器中的所有Cookie，并返回与指定名称匹配的Cookie的值。
    
7. `eraseCookie(name)`: 用于删除指定名称的Cookie。
    
8. `initSettings()`: 初始化设置。该函数会检查浏览器是否支持Chrome存储API，并尝试从存储中读取设置值。
    
9. `setSetting(name, value)`: 更新设置的缓存值，但不写入永久存储。它接受设置名称和值作为参数，并更新设置的缓存值。
    
10. `writeSetting(name, value)`: 将设置值写入永久存储。它接受设置名称和值作为参数，并将设置值写入Chrome存储或本地存储。
    
11. `readSetting(name, defaultValue)`: 读取指定名称的设置值。它会首先检查设置的缓存值，如果缓存中不存在，则尝试从Chrome存储或本地存储中读取。
    
12. `eraseSetting(name)`: 删除指定名称的设置值。
    
13. `logOnce(msg, level)`: 用于记录日志消息，但只记录一次。它接受消息内容和日志级别作为参数，并将消息记录到日志中。
    
14. `localStorageGet(name)`: 从本地存储中获取指定名称的值。它会尝试读取本地存储中指定名称的值，并返回结果。
    
15. `localStorageSet(name, value)`: 将指定名称和值存储到本地存储中。它会尝试将指定的名称和值写入本地存储。
    
16. `localStorageRemove(name)`: 从本地存储中删除指定名称的值。它会尝试删除本地存储中指定名称的值。
    

这些函数可以帮助你处理日志记录、Cookie操作和设置管理的相关任务。
# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
