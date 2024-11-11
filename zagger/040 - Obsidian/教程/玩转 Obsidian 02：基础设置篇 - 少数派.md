---
searchType: obsidian
created: 2023-11-08T10:39
updated: 2023-11-10T15:21
---
[Obsidian](https://sspai.com/link?target=https%3A%2F%2Fobsidian.md%2F) 是一款非常优秀的「现代化」笔记管理工具，因其快速的功能迭代和优秀社区活跃度，成为了近期较为热门的笔记软件之一。个人经过一段时间的使用和体验，认为 Obsidian 已经具备了成为「主力笔记管理软件」的能力，并陆续将自己的笔记迁移到 Obsidian 上进行管理。

Obsidian 和其他常见的「笔记软件」有什么不同，它具备哪些优势，以及想要用好 Obsidian 有哪些「方法论」，我在上一篇文章《[玩转 Obsidian | 打造知识循环利器](https://sspai.com/post/62414)》中有过详细的阐述，感兴趣的同学可以先翻过去了解一下。

由于后续我打算持续更新「玩转 Obsidian」系列文章，所以迫切需要一篇「关于基础设置和使用介绍」的入门级介绍文章，于是有了本篇。

碍于篇幅，我不可能将所有的功能都罗列出来，本篇「**只适用于快速上手体验**」，文中介绍的是个人认为比较重要的设定和使用方法。如果想了解 Obsidian 的所有功能特点，Obsidian 官方非常贴心的提供了帮助文档《[Obsidian Help](https://sspai.com/link?target=https%3A%2F%2Fpublish.obsidian.md%2Fhelp%2FIndex)》，同时为了方便大家进行「交互式」体验其功能，Obsidian 还内置了「Obsidian Help」仓库，并且以上两个文档都会得到官方的持续更新，大家可以选择任意方式进行阅读。

PS：本篇文章基于 Obsidian `v0.9.10` 版本。

## Obsidian 的基本使用

大家可以去 [Obsidian 官网](https://sspai.com/link?target=https%3A%2F%2Fobsidian.md%2F)下载对应的客户端，由于使用了跨平台的「前端技术」，Obsidian 同时支持多个「桌面平台」的使用，当你安装好 Obsidian 后，我们就可以简单的设置并使用它写笔记。

### 新建仓库

Obsidian 支持「仓库」概念，我们可以将自己的「个人笔记」和「工作笔记」创建不同的仓库，这样他们之间的内容互不影响，当然一切都是自由的，你可以任意创建属于自己的「仓库」。

![新建仓库](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513203.png?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

新建仓库

PS：如果我们设置仓库的存储目录为「云盘」的时候，Obsidian 就具备了「云同步」的能力。

![云端管理](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513220.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

云端管理

### Obsidian 的基本布局

Obsidian 的布局比较直观，如下图一些基本的操作和入口我已经标注出来，这里大家只需要做下了解：  
 

![基本布局](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513232.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

基本布局

### 新建笔记

Obsidian 支持多种创建笔记方式，最简单的就是使用快捷键「CMD + N」，也可以在「资源管理面板」中点击「新建笔记」按钮。

![新建笔记](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513244.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

新建笔记

## 通用设置

以下将介绍 Obsidian 的通用设置，包括主题设置、标签管理、编辑模式 VS 预览模式、命令模式、工作区管理等。

### 主题设置

由于 Obsidian 使用了前端技术，理论上通过 CSS 技术可以实现各种样式和布局，在 Obsidian 中设置「样式」也非常简单。

第一步，开启「自定义主题」插件：

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513256.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

第二步，选择符合自己的主题： 

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513269.jpg?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

PS：作者使用的主题是「[Pisum](https://sspai.com/link?target=https%3A%2F%2Fgithub.com%2FGuangluWu%2Fobsidian-pisum)」，如果打不开「主题样式」列表，可能遇到了不可翻越的墙，可以去 Github 搜索「Obsidian」关键字查找。

### 附件存储设置

Obsidian 支持在笔记中插入图片和音频等「附件」，为了方便管理我们的仓库，可以单独设置「附件」的存储目录，这样就不会和文件都散落在仓库中。

![附件存储](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513281.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

附件存储

### 标签管理

Obsidian 支持标签管理，如果需要使用首先要开启「标签面板」。 

![标签管理](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513295.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

标签管理

当我们在文章任意地方通过 `#标签名称` 插入标签后，就可以在「标签面板」中看到所有仓库中的标签。

![标签使用](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513307.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

标签使用

### 编辑模式 VS 预览模式

编辑模式，指的是在 Obsidian 中新建或打开笔记时，笔记处于「编辑」状态，此时我们可以直接输入 Markdown 语法进行编辑。

由于 Obsidian 不支持「所见即所得」的编辑模式，所以我们需要进入「预览模式」才可以看到我们笔记真实的样式，下图中可以看到他们的对比：

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513320.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

进入「预览模式」的方式常见的几种如下：

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513331.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

通过快捷键切换 CMD + E

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513342.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

菜单栏按钮切换

PS： 点击上图按钮时如果同时按下 CMD 键，会在右边打开新的笔记面板展示「预览模式」。

### 命令模式

Obsidian 也向大多数智能笔记工具一样具备「命令模式」，同样使用「CMD + P」打开命令面板，从中可以选择各种命令，如果想要查看各种命令的中文名称，可以去「仓库管理面板」切换到「中文」查看：

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513353.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

## 工作区管理

工作区指的是，Obsidian 会把当前打开的多个「笔记页」、「右侧扩展区域」和「Backlinks For XXX」等全部面板的「加载打开」状态等当做一个「工作区」。我们可以任意保存和加载工作区。

工作区带来的好处，当我们同时处理各种笔记的时候，具备了「一键还原现场」的能力，方便我们快速进入「心流状态」，避免我们被各种事情所打扰，迟迟不能进入状态。

使用工作区的话，首先开启「Workspaces」插件，就可以看到「工作区」操作入口了，如图： 

![工作区管理](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513364.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

工作区管理

**保存「工作区」：**我们可以在 Obsidian 的任意界面，点击上图中「工作区操作入口」的按钮，打开「工作区管理面板」进行保存：

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513374.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

**加载「工作区」：**我们可以在 Obsidian 的任意界面点击上图中「工作区操作入口」的按钮，打开「工作区管理面板」进行加载操作：

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513385.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

## 模板输入

在使用笔记的过程中经常会遇到需要重复输入的内容，比如会议纪要的模板，此时我们可以使用 Obsidian 的「模板输入」功能，创建好「模板」后，就可以是实现「快速输入模板」的能力，具体操作如下：

1. 开启模板插件：

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513396.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

2. 设置模板目录和格式：

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513406.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

3. 创建模板文件：

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513418.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

4. 使用模板：

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513430.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513441.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

## 超链接使用

Obsidian 支持多种「超链接语法」，这些功能也是「现代笔记管理」的必备技能。几种常见的语法如下：

- 双向链接：`[[Note Name]]`
- 话题引用：`[[Note Name #header]]`
- 别名引用：`[[Note Name |Alias]]`
- 嵌入引用：`！[[Note Name]]`
- 块引用：`[[Note Name ^]]`

### 超链接语法 - 双向链接

「双向链接」的语法为`[[Note Name]]`，在前文中已经简单介绍过它的使用，下边是关于「双向链接」的详细介绍。

「双向链接」指的是在笔记 A 中通过输入 `[[笔记 B]]` 后，使得笔记 A 和笔记 B 建立了链接关系，如下：

在笔记A 中可以看到它和 `[[笔记 B]]` 有关系，同时在笔记 A的「预览模式」下，鼠标经过`[[笔记 B]]` 时，可以弹出笔记 B 的「缩略视图」，同时点击 `[[笔记 B]]` 后也可以打开笔记 B的编辑页面。

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513451.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

PS：想要看到笔记 B 的「缩略视图」需要开启「Page Preview」插件。

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513461.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

在笔记 B 中可以通过「Backlinks For 笔记B」看到都有哪些笔记和自己建立过「双向链接」。

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513472.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

PS：「Backlinks For 笔记B」的打开方式常用的方法有两种，通过快捷键或者菜单按钮。

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513485.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513496.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

### 超链接语法 - 话题引用

在 Obsidian 中，由于 Obsidian 支持 Markdown 标记，我把用 `#` 标记的内容称为「话题」，如下图，「### English」和「### Chinese」就是两个「话题」： 

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513507.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

话题引用的语法是`[[Note Name #header]]`，即在使用「双向链接」的时候，我们可以在输入的「笔记名称」后边输入笔记中的「话题」，这种「双向链接」的添加方式称为「话题引用」如图：

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513518.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

「话题引用」带来的好处是，当我们在「预览模式」下，鼠标经过「双向链接」时，弹出的「缩略视图」中只展示 `#话题` 所包含的内容（最新版本不再展示全文），并且点击「双向链接」也会直接跳转到对应的话题所在行。

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513529.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

### 超链接语法 - 别名引用

别名引用的语法是`[[Note Name | Alias]]`，即在使用「双向链接」的时候，我们可以在输入的「笔记名称」后边输入一个「别名」，这种「双向链接」的添加方式称为「别名引用」。 

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513540.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

别名引用带来的好处是，可以更准确的「表述」我们在原笔记中输入「双向链接」时想表达的意思。

### 超链接语法 - 嵌入引用

嵌入引用的语法`![[Note Name]]`，即在使用「双向链接」的时候，我们可以在「双向链接」前边输入一个`!`（叹号），这种「双向链接」的添加方式称为「嵌入引用」。

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513552.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

嵌入引用带来的好处是，我们无需跳转，直接在原笔记中查看到被引入的「新笔记」。

### 超链接语法 - 块引用

块引用的语法 `[[Note Name ^]]` ，既在使用「双向链接」的时候，我们可以在「双向链接」的后边输入 `^` ，此时我们可以将被链接的笔记中的某一行（包括它的从属段落）引入到当前笔记中。这种方式成为「块引用」。

块引用带来的好处是，我们可以将一篇笔记中的「某个段落」引入到当前笔记中，结合「别名引用」更容易帮我们表达它的意思，如图：

![](https://cdn.sspai.com/editor/u_5b3wva6y/16046439513563.png?imageView2/2/w/1120/q/40/interlace/1/ignore-error/1)

## 总结

本篇作为「玩转 Obsidian」的基础入门介绍，希望能够让更多的人认识并使用它，也是得力于开发者持续不断的迭代更新，我个人非常喜欢 Obsidian ，并打算长期使用并体验，后续会我也会持续更新「玩转 Obsidian」系列文章，也欢迎大家持续关注。

---

「玩转 Obsidian」系列会持续更新「如何使用 Obsidian 进行知识管理」，对此系列感兴趣可以在以下渠道找到相关文章：

- [少数派专栏 - 知识管理之术](https://sspai.com/my/column/263/post)
- [闲者时间博客](https://sspai.com/link?target=https%3A%2F%2Fxzsj.vip%2F)
- [闲者时间 Medium](https://sspai.com/link?target=https%3A%2F%2Fxzsj.icu%2F)

玩转 Obsidian 系列目前包括文章：

- 《[玩转 Obsidian 01：用 Obsidian 打造「知识循环」利器](https://sspai.com/post/62414)》
- 《[玩转 Obsidian 02：基础设置篇](https://sspai.com/post/63481)》

可以在 [Twitter](https://sspai.com/link?target=https%3A%2F%2Ftwitter.com%2Fxianzheshijian)、[Telegram](https://sspai.com/link?target=https%3A%2F%2Ft.me%2Fxztime) 、[instagram](https://sspai.com/link?target=https%3A%2F%2Finstagram.com%2Fshopkeeper.wang) 等渠道关注我，获取更多有意思的讯息。

> 下载少数派 [客户端](https://sspai.com/page/client)、关注 [少数派公众号](https://sspai.com/s/J71e)，让智能设备为你所用 💪

> 特惠、好用的硬件产品，尽在 [少数派 sspai 官方店铺](https://shop549593764.taobao.com/?spm=a230r.7195193.1997079397.2.2ddc7e0bPqKQHc) 🛒
