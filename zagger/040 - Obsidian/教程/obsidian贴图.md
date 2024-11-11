---
searchType: obsidian
aliases: 
tags:
  - 教程/obsidian/图片
  - obsidian
cdate: 2023-11-09 14:01
uid: 20231109140120
update: 
cssclasses: 
cover: 
created: 2023-11-09T14:01
updated: 2023-11-14 11:53:03
---
# 1. obsidian贴图

## 1.1. Metadata
Status::    #笔记状态/🌱发芽
Source Type::  #📥/📰️文章
Note Type::  #笔记
Topic:: [[obsidian贴图]]
Author:: {原资讯的作者或者对话的人或者引起某种想法的原因}
Source URL:: 
Modify:: `=dateformat(this.file.mtime, "yyyy-MM-dd HH:MM:ss")`

## 1.2. 长青笔记
*一句话概括这篇笔记的内容*
Summary:: 准备使用长青笔记继续下去了！

## 1.3. 自我重述
*用自己的话去重述提取的重点内容*
obsidian有点折腾了，插件也过于重了。

## 1.4. 重点摘抄
*摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。*

- Chrome插件：Roam-highlighter、tabCopy
- picgo软件配置、image自动上传配置，github图床，==注意personal token使用未过期的==
- 利用vscode使用正则替换链接地址，批量添加列表项目元数据，企图进行归类和视图展示。

### 1.4.1. ==Roam-highlighter==

><mark style="background: #FFF3A3A6;">DEMO: youtube.com/watch?v=UzseaoxaSEM</mark>
	Roam-highlighter Shortcut Keys (v2.1.1)
	[ALT + X] - Activate Extension and Show/Hide Side Window
>
> [Ctrl + X] (WIN) or [CMD + X] (MAC) - Highlights selected text - To remove part of a highlight, select text and press [Ctrl + X]
>
> [Alt + Click] - Removes an entire highlight
>
> [ALT + Q] - Remove all highlights on the page
>
> [ALT + A] - Makes selected highlighted a "header"; highlights following will nest until another highlight is selected as a "header"
>
> [Double-Click] a Single Word (has to be highlighted already) - Adds [[Double Brackets]] for Roam "Page Linking"
>
> [ALT + Z] (must already be highlighted) - Adds [[Double Brackets]] around selection for Roam "Page Linking"


> 
> - 工具推荐：Roam-highlighter
> - Roam-highlighter 如何使用
>   - `Alt + X` ，显示和隐藏窗体
>   - `Ctrl + X or CMD + X` ，对选中的文字进行高亮或取消高亮
>   - `Alt + Click` ，移除鼠标点击所在的高亮内容。
>   - `Alt + Q` ，移除所有已经高亮内容。

### 1.4.2. ==picgo==
> 1. install the [picgo](https://github.com/Molunerfinn/PicGo) and config it
> 2. open the tool and open the setting "设置 server"
> 3. install the plugin in obsidian
> 4. open the plugin setting, and set the "picGo server" `http://127.0.0.1:{{port in picgo}}/upload`（example：`http://127.0.0.1:36677/upload`）
> 5. try paste image

* 一个机器需要一个personal key [[personal token | token]]
* 还有个要记得点下协议同意，不然也会失败。
* 上传就成功了
* ![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian20231109213618.png)
### 1.4.3. 模板


* ![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/pic20231108132000.png)
### 1.4.4. 图片上传工具配置 
  * 
  * ![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/pic20231108112226.png)



### 1.4.5. ==正则==
* 选中链接
	* `([^!]\[.*(\(.*\))?\]\(.*\))\n\n`
	* `$1 \n`![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian20231109114412.png)

* 选中链接的url部分进行格式修改
	* `(\[(http(s)?\S*)\])`
	* `$1[url::$2]`
	* ![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/pic20231108191707.png)
*  找出元数据type
	* `\((type::\S*)\)`
	* `\n[$1]`
	* ![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/pic20231108183631.png)
### 1.4.6. 调出来console
windows：`ctrl+shift+i`
macos：`cmd+opt+i`
使用[快捷键](https://www.zhihu.com/search?q=%E5%BF%AB%E6%8D%B7%E9%94%AE&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A3097956845%7D)ctrl+shift+i**查看错误信息。

### 1.4.7. 文件夹目录
![image.png](https:cdn.jsdelivr.net/gh/zaggerj/obsidian_picgo/obsidian/20231110144326.png)
### 1.4.8. dataviewjs 检索内容

![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian20231112125644.png)
### 1.4.9. recent file 插件 [[2023年11月14日#1.4.1. 事件|recent files]]
* obsidian recent file 插件 使用<mark style="background: #FF5582A6;">ctrl+click</mark>可以在新标签页打开最近打开的文件
* 好像obsidian都是使用<mark style="background: #FF5582A6;">ctrl+click</mark>可以在新标签页打开文件

## 1.5. 相关文章
Page Link::  [玩转 Obsidian 01：打造知识循环利器 - 少数派](https://sspai.com/post/62414) [[Obsidian-Highlights]]
[[obsidian清单]]
[Obsidian插件: Recent Files追踪最近打开过的文件 - 知乎](https://zhuanlan.zhihu.com/p/660527886)

