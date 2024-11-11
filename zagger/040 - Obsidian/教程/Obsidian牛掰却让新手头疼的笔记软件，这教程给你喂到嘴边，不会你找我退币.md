---
searchType: obsidian
tags:
  - 教程/obsidian/blog
  - obsidian
  - 教程
created: 2023-11-06T08:24
updated: 2023-11-10T15:21
---

#obsidian #教程 #菜有隐 #插件

# obsidian 内容点集锦

- [3] 外观主题：卡片界面，配色，彩虹文件样式，文件图标，泡泡条，工具栏，callout 样式，程序块高亮样式，文字色块，ckecklist 样式

- [0] 功能：一键记灵感/日记，自定义文件夹/文件排序，日历，简易 todo list，自定义按钮，悬浮窗，标签管理，最近使用文件，链接预览

> [!download] 需要插件
> Admonition，Calendar，Checklist，Commander，Customer File Explore sorting，Dataview，Easy Typing，Editing Toolbar，File Tree Alternative Plugin，Highlightr，Hover Editor，Iconize，Minimal Theme Settings，obsidian markmind，Paste URL into selection，QuickAdd，Recent Files，Style Settings，TagFolder，Templater，Convert url to preview (iframe), Tag Wrangler, Editor Syntax Highlight

## 该教程所需知道的常用操作
插件和主题下载需要梯子，没有梯子在我的视频的简介下自取
插件下载后需要激活
安装的插件在左下角的设置界面可以管理，大多数插件可以在这里设置
> [!tip]
> 
> 另外，插件命令可以 Ctrl+P 呼出命令面板，输入插件名，会出现该插件相应的命令
> 例如 Checklist 插件，激活插件后没有显示，可以用这个方式
>![[Pasted image 20231020094836.png]]


## 下载 AnuPpuccin 主题

> [!info] 说明
> 
> 该主题是后续很多外观样式的前置条件，需要下载激活后，后续的例如泡泡条，checklist 样式，卡片界面等才可以设置

> [!download] 新主题下载激活
> 如果有梯子的，自己下载，没有梯子打不开 obsidian 主题商店的，看下面的说明下载
> ![[Pasted image 20231020093152.png]]
> 没有梯子的，在我的视频简介下载的文件里，把“主题”文件夹下的，AnuPpuccin 文件夹放入 obsidian 的主题文件夹（找到该文件夹的方式见下图）
>![[Pasted image 20231020093516.png]]
> ![[Pasted image 20231020093558.png]]
## 安装插件

查看视频

## 案例：悬浮窗
### 一键呼出 <样式设置悬浮面板>
> [!download] 需要插件
> 
Hover Editor，Commander

![[Pasted image 20231020095345.png]]
![[Pasted image 20231016232410.png]]
![[Pasted image 20231016232506.png]]
![[Pasted image 20231020095424.png]]
## 代码块示例

> [!download] 需要插件
> 
> Editor Syntax Highlight

```python
import pandas as pd

videoProduceSpeed = 1.0 //初始视频生产速度

def thumbUp(👍,🌟):
	if IsThumbUp or IsFavorite: 
		videoProduceSpeed *= 10
```

```C#
using System；

public float videoProduceSpeed = 1.0； //初始视频生产速度

public void touBi(   ){

	if (touBi){

		videoProduceSpeed *= 20;

	}

}
```

## CheckBox 示例样式

> [!download] 需要插件
> 
> Style Settings

> [!download] 需要下载主题
> 
> AnuPpuccin

> [!info] 需要设置
> 
> 打开插件 Style Settings 中的开关
> ![[Pasted image 20231020092017.png]]

- [p] 点赞
- [*] 收藏
:coin_bcoin:   投币
- [ ] Unchecked
- [x] Checked
- [>] Rescheduled
- [<] Scheduled
- [!] Important
- [-] Cancelled
- [/] In Progress
- [ ] Question
- [n] Note
- [l] Location
- [i] Information
- [I] Idea
- [S] Amount
- [c] Con
- [b] Bookmark
- ["] Quote

## 泡泡条示例样式

> [!info] PS
> 
> 与 CheckBox 设置相同
> ![[Pasted image 20231020092501.png]]

- [0] 泡泡条示例样式 0 泡泡条示例样式 0 泡泡条示例样式 0 泡泡条示例样式 0
- [1] 泡泡条示例样式 1 泡泡条示例样式 1 泡泡条示例样式 1
- [2] 泡泡条示例样式 2 泡泡条示例样式 2 
- [3] 泡泡条示例样式 3
- [4] 示例样式 4
- [5] 样式 5
- [6] 泡泡条示例样式 6
- [7] 泡泡条示例样式 7 泡泡条示例样式 7
- [8] 泡泡条示例样式 8 泡泡条示例样式 8 泡泡条示例样式 8
- [9] 泡泡条示例样式 9 泡泡条示例样式 9 泡泡条示例样式 9 泡泡条示例样式 9 
## 案例：一键记灵感/日记

> [!download] 需要插件
> 安装核心插件 <mark style="background: #FF5582A6;">日记</mark>，第三方插件 <mark style="background: #FF5582A6;">QuickAdd</mark>，<mark style="background: #FF5582A6;">Calendar</mark>

### 一键写灵感，一个灵感一篇笔记
#### 1.  新建文件夹，用来存放 灵感/日记
> [!info] 文件创建
> ![[Pasted image 20231016215206.png]]
设置完之后写的笔记会放在灵感 memo 文件夹下，如灵感 20231016. md 文件，该路径为 `灵感/灵感memo` ，路径第 4 步会用到

#### 2. 设置笔记模板文件

> [!example] 流程
> 新建笔记 :luc_arrow_big_right:  放到指示文件位置  :luc_arrow_big_right: 开头输入 `---` 会出现文档属性 :luc_arrow_big_right: `created` 先用文本的格式，等输入 `{{date}}` 后再改成日期格式 :luc_arrow_big_right: 之后按示例完成设置，

> [!info] 文件位置
> ![[Pasted image 20231016223148.png]] 
文件存放路径为 `obsidian使用相关/templater/灵感模板.md` ，路径第 4 步会用到

> [!info] 模板设置最终示例
> ![[Pasted image 20231016215726.png]]


#### 3.  打开 QuickAdd 插件设置界面（设置界面，第三方插件下面找到对应插件）
   ![[Pasted image 20231016222051.png]]
#### 4. 设置 QuickAdd-创建自定义动作
 ![[Pasted image 20231016213959.png]]
> [!important] 重要
> 记得点亮动作的黄色闪电


#### 5. 设置创建的动作，点击动作后面的齿轮，进入设置界面 
![[Pasted image 20231016214457.png]]
```js

let text = ""
text = await this.quickAddApi.inputPrompt("Inspire","输入灵感",text);
text = text.replace("\n","<br>");
text = "\n"+  "> [! tip] ins" + "\n"  +">" + text + "\n" + "#灵感"
return text

// 这是说明不用复制， 将这段代码复制到截图所示输入框中，并补全首尾缺失部分。
// 另外在该代码的段落上下各留1行空行，重要!!！
```
   
#### 6. 使用方式

> [!赞] 使用方式1：使用命令行
> 按快捷键 Ctrl + P 呼出命令行，搜索之前设置的动作名称 `inspire` 或者插件名 `quickadd`,之后弹出第一个名为 `灵感标题` 窗口，该窗口输入笔记标题。按下确定后，弹出第二个窗口，这里输出的是笔记内容。

> [!收藏] 使用方式2：设置快捷键
> 设置 - 快捷键 - 搜索 `inspire` - 设置快捷键

### 一键写灵感，所有灵感都记在一篇笔记

#### 1. 新建笔记，用来记录所有灵感
> [!info] 文件创建
> ![[Pasted image 20231016221746.png]]
设置完之后写的笔记会添加到 `灵感` 文件夹下的 `灵感散记.md` 文件中，该路径为 ` 灵感/灵感 散记.md ` ，路径第 4 步会用到

#### 2 . 打开 QuickAdd 插件设置界面【同上】
#### 3 . 设置 QuickAdd-创建自定义动作，【同上】，修改下动作名 `2inspire`
#### 4 . 设置创建的动作，点击动作后面的齿轮，进入设置界面
 ![[Pasted image 20231016222451.png]]
 ```js
//这留1个空行
//```js quickadd
let text = ""
text = await this.quickAddApi.inputPrompt("Inspire","输入灵感",text);
text = text.replace("\n","<br>");
text = "\n"+  "> [! tip] ins" + "\n"  +">" + text + "\n" + "#灵感 " 
let nowDate = new Date()
text += nowDate.toLocaleDateString()
return text
//```
//这留1个空行

// 这是说明不用复制， 将这段代码复制到截图所示输入框中，并补全首尾缺失部分。
// 另外在该代码的段落上下各留1行空行，重要!!！
```
5. 

#### 5. 使用方式【同上】
### 将日记内容添加到当天的日记文件中，我主要快速写待办用

#### 1. 创建文件夹，用来存放日记，命名“日记”
> [!info] 创建文件夹
> ![[Pasted image 20231016230640.png]]
文件夹路径 `日记` ，路径第 3 步会用到

#### 2. 设置笔记模板文件

> [!example] 流程
> 新建笔记 :luc_arrow_big_right:  放到指示文件位置  :luc_arrow_big_right: 开头输入 `---` 会出现文档属性 :luc_arrow_big_right: `created` 先用文本的格式，等输入 `{{date}}` 后再改成日期格式 :luc_arrow_big_right: 之后按示例完成设置，

> [!info] 文件位置
> ![[Pasted image 20231016225818.png]]
文件存放路径为 `obsidian使用相关/templater/日记模板.md` ，路径第 3 步会用到

> [!info] 模板设置最终示例
> ![[Pasted image 20231016225928.png]]

#### 3. 设置日记插件
![[Pasted image 20231016230500.png]]
#### 4. 设置 QuickAdd-创建自定义动作，【同上】，修改下动作名 `todo`
#### 5 . 设置创建的动作，点击动作后面的齿轮，进入设置界面
 ![[obsidian使用相关1/Attachment/Pasted image 20231016230100.png]]
 ```js
//```js quickadd
let text = ""
text = await this.quickAddApi.inputPrompt("todo","输入todo",text);
text = text.replace("\n","<br>");
text =  "- [ ] " + text
return text
//```

// 这是说明不用复制， 将这段代码复制到截图所示输入框中，并补全首尾缺失部分。
// 这次不用留空行
```
#### 6. 使用方式

> [!important] 每天点击日历上当天日期，创建当天日记，然后使用方式【同上】
> 


## 案例：自定义文件排序

> [!download] 需要插件
> 
> Customer File Explore sorting

> [!tip]
> 
>Shift  + enter 可以在属性编辑输入多行

> [!warning] 设置
> 
> 这一案例的设置请查看视频
## 自定义按钮

> [!download] 需要插件
> 
> Commander

![[Pasted image 20231016232810.png]]
## 标签管理

> [!download] 需要插件
> Tag Wrangler, TagFolder

![[Pasted image 20231016233527.png]] ![[Pasted image 20231016233648.png]]
## 最近使用文件

> [!download] 需要插件
> Recent Files

Ctrl + P 呼出命令面板，搜索 `recent files：open`，最近使用文件的按钮就会出现了

![[Pasted image 20231016233949.png]]
## 链接预览
> [!download] 需要插件
> Convert url to preview (iframe)

将链接粘贴到 obsidian
https://space.bilibili.com/2080168582
选择链接 Ctrl + P 呼出命令面板，搜索 `convert`
点击 `Convert url to preview(iframe):URL to Preview/Iframe`
![[Pasted image 20231016235420.png]]
![[Pasted image 20231016235149.png]]
## 自定义 callout 样式

> [!good] 点赞
> 
> 自定义 callout

![[Pasted image 20231017000212.png]]
![[Pasted image 20231017000704.png]]
![[Pasted image 20231017001238.png]]
![[Pasted image 20231017001305.png]]

> [!download] 创建自定义 callout 设置示例
> ![[Pasted image 20231017000733.png]]

> [!download] 使用示例说明
>Ctrl + P ，搜索 `callout`，选择 `Admonition:Insert Callout`
> ![[Pasted image 20231017000822.png]]




## 卡片界面

> [!download] 需要插件
> 
> Style Settings

> [!download] 需要下载主题
> 
> AnuPpuccin

> [!info] 设置
> 
> ![[Pasted image 20231020092751.png]]
![[Pasted image 20231020092829.png]]

## 彩虹文件管理
> [!download] 需要插件
> 
> Style Settings

> [!download] 需要下载主题
> 
> AnuPpuccin

> [!info] 设置
> ![[Pasted image 20231020093008.png]]
> ![[Pasted image 20231017003124.png]]



## 案例：文件/文件夹的 ICON 设置

> [!download] 需要插件
> 
>Iconize

> [!download] 安装 Icon 包
>有梯子的自己下载
> ![[Pasted image 20231017004628.png]]
>没有梯子的，icon 包我放视频简介了，下面是安装方法
>
>![[Pasted image 20231017005111.png]]

> [!info] 使用方法1
> 
> 右键文件/文件夹
>![[Pasted image 20231017004204.png]]

> [!info] 使用方法2：规则
> 
>![[Pasted image 20231017004306.png]]
>
## 显示 todo 任务汇总侧边栏

> [!download] 需要插件
> 
>Checklist

![[Pasted image 20231017002813.png]]
## 文字色块
你们的<mark style="background: #FFB86CA6;">一键三连</mark>，是我创作的动力~
![[Pasted image 20231016235836.png]]
你们的<mark style="background: #FFB8EBA6;">一键三连</mark>，是我创作的动力！

## 工具栏

<u>下划线</u>

> [!download] 需要插件
> 
>Editing Toolbar

> [!info] 显示工具栏
>Ctrl+ P，搜索
> ![[Pasted image 20231017002302.png]]
## 设置搜索框

> [!download] 需要插件
> 
> Settings search

当安装了很多插件后，有时候不知道某些设置在哪个插件，或者哪里设置，有了这个就会方便很多

比如： 显示行号
## 多级标题自定义颜色

![[Pasted image 20231020202324.png]]
