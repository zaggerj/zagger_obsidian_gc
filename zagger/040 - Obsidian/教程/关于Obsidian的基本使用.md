---
searchType: obsidian
tags:
  - 教程/obsidian/blog
  - obsidian
  - blog
aliases:
  - Obsidian的基本使用
created: 2023-11-06T08:24
updated: 2023-11-10T15:21
---

## 关于Obsidian的基本使用，这一篇足矣。

> 写在开头的话：  
> 这篇教程大多是介绍obsidian原生功能的使用方法，如果你下好obsidian，面对obsidian的界面一头雾水，建议收藏，使用的时候按照目录参考一下。  
> 如果读完仍有疑问，欢迎评论，或者私信我加我微信都可以。  
> 我建了一个qq群，会同步与文章更新一些资源和模板，如果有什么问题也欢迎来到群里讨论呀：184533202

---

> 使用前的忠告： 
> - 不要刚下好obsidian就想着使用插件，大部分插件只是增强一些功能，建议先熟悉一下ob的基本使用功能。  
> - 个人认为外观设置没那么重要，如果以记录为主最好不要纠结CSS怎么写！再说一遍，不要纠结CSS怎么写！  
> - 刚开始用可以不用了解mermaid、dataview、yaml等语法，先掌握Markdown语法为重中之重。  
> - 注重笔记内容。

**如果你使用obsidian是为了搭建自己的知识管理系统，欢迎关注我最近正在更新的专题：**

[Obsidian拓展计划​www.zhihu.com/column/c_1559828696105644032![](https://pic2.zhimg.com/v2-52a669542a8699d42a3c5796c7e536e9_ipico.jpg)](https://www.zhihu.com/column/c_1559828696105644032)

### 一. 如何下载？

如果想了解ob是什么，有什么用，可以浏览我之前写过的一些文章：

[Wyatt：为什么选择·Obsidian？【玩转Obsidian的保姆级教程】237 赞同 · 23 评论文章![](https://pic2.zhimg.com/v2-d0cca5f1d098250f32c19e62d31377d1_180x120.jpg)](https://zhuanlan.zhihu.com/p/402994214)

[Wyatt：一个大学生与Obsidian。【玩转Obsidian的保姆级教程】460 赞同 · 68 评论文章![](https://pic1.zhimg.com/v2-f502d1cb1d059287b5798fad34efe16c_180x120.jpg)](https://zhuanlan.zhihu.com/p/409095645)

[Wyatt：obsidian学习成本高吗？【玩转obsidian的保姆级教程】89 赞同 · 24 评论文章](https://zhuanlan.zhihu.com/p/409545355)

或者浏览官网[Obsidian]([Obsidian: A knowledge base that works on local Markdown files.](https://obsidian.md/))

PS：如何到官网下载obsidian：

电脑端点击链接：[Obsidian]([Obsidian: A knowledge base that works on local Markdown files.](https://obsidian.md/))

进入后依照自己要下载的版本选择即可：

![](https://pic4.zhimg.com/80/v2-ed8eb586bbcbc325bfd1b2f8288ae34f_720w.webp)

  

### 二. 如何使用？

### 创建库文件夹：

下载好obsidian然后打开：

![](https://pic2.zhimg.com/80/v2-83abdcea58a2783c504539cc445988f1_720w.webp)

- **打开库文件夹**：打开之前已经建立过的文件夹——就像我这张演示图中，左侧是我之前建立过的文件夹，选择打开即可。
- **创建新库**：即新建一个库文件夹

点击“创建”，输入你想新建库的名字，选择库文件夹储存的位置，再次点击创建即可。

![](https://pic2.zhimg.com/80/v2-b1f4bd161981e695a1e1dbaa82d22601_720w.webp)

创建之后就会出现这个界面，我称之为obsidian的主界面，也就是我们主要记录笔记的地方：

![](https://pic3.zhimg.com/80/v2-f240ebfdc7a494c2471e919ba33167d2_720w.webp)

- **打开帮助**：即打开obsidian系统内置的操作指导obsidian help（在稍后的obsidian主界面内也可以打开obsidian help）

![](https://pic3.zhimg.com/80/v2-ff231e222952340fa390f9242a4b9e3e_720w.webp)

（obsidian help的界面）

### 建立一篇新笔记

在obsidian的主界面中：

![](https://pic4.zhimg.com/80/v2-02fb2cf5a88785521286d591a1f5d86b_720w.webp)

其实新建笔记主要依照上面两个图标

红色的是新建笔记，单击就会出现一篇为命名的笔记：

![](https://pic1.zhimg.com/80/v2-25dcfd0055e452689bb2b9ccbaa958e0_720w.webp)

绿色的是新建文件夹，单击就会出现一个未命名的文件夹：

![](https://pic2.zhimg.com/80/v2-93bf88ba5ad2c7893166185484337eb9_720w.webp)

我可以在主界面内，通过用鼠标拖拽的方式把笔记移动到文件夹中：

![](https://pic1.zhimg.com/80/v2-85df3b4662b9f33ccad1e44a26942df8_720w.webp)

当你文件夹很多的时候，可以右键文件夹，选择新建笔记，直接把新笔记建立在文件夹里：

![](https://pic1.zhimg.com/80/v2-64e098854347ede4e6a43c61743b0d18_720w.webp)

新建之后打开“未命名3”文件夹会发现里面多了一篇新建的笔记。

![](https://pic1.zhimg.com/80/v2-2b0d9200a8af0151631a7de7849ce634_720w.webp)

同理，你也可以在文件夹里新建一个文件夹。

这样的储存方式让你想到了什么？是不是和传统的Windows文件储存方式有点像？

![](https://pic4.zhimg.com/80/v2-1d3693bff9617d40bb7aa5cff4222927_720w.webp)

其实就是这样，当你打开你的库文件，你会发现刚刚你在obsidian里面的操作，都一一对应在Windows系统里的操作：

![](https://pic1.zhimg.com/80/v2-eac0f45edac2f8ec0e1c0e8247929bf0_720w.webp)

所以，用obsidian的目录管理文件，就和在Windows系统里面管理文件一样，只不过，你的笔记是以.md后缀的格式储存的。

那什么是.md呢？

这就要说到下一部分了：

### 如何书写一篇笔记

大家都用过word吧？obsidian其实和word差不多，就算你什么功能都不大熟悉，总可以在里面打字记录吧：

![](https://pic1.zhimg.com/80/v2-1e54f8017ee07388ef4b01448dc1e528_720w.webp)

在obsidian里面也一样，就是依靠打字记录你的内容，只不过，word是通过上面的图标进行排版，而在obsidian里面，简化了这一排版过程，使用的是**markdown语法**对你的笔记进行排版。

> 再次强调，markdown语法是用来排版的

### Markdown 排版

如何在ob里面使用markdown语法，在obsidian help里面就有详细的说明：

打开obsidian help——打开【格式化你的笔记】

![](https://pic1.zhimg.com/80/v2-9cd04fcccdb177490128b8cdce8cbc08_720w.webp)

然后就会看见详细的markdown语法了：

![](https://pic3.zhimg.com/80/v2-b113b5f86ffe91356194d64d86af16ea_720w.webp)

### 预览、编辑模式切换

刚刚也提到了，其实markdown是一种用来排版的文档，但是你在书写的过程中，其实，你的文档中会夹杂着markdown语言：

比如obsidian help中，就会发现一篇笔记其实有两种展示模式：

![](https://pic1.zhimg.com/80/v2-bab81068210aac42ed3c5a494a6bbd5c_720w.webp)

- 编辑模式

上图左侧比较乱（有一堆奇奇怪怪的字符）的是编辑模式，在编辑模式下，你可以对笔记进行编辑。

- 预览模式

上图右侧比较整洁，也看出有一定的排版的，是预览模式，在预览模式下，你不可以对笔记进行修改。

切换这两种模式也很简单——笔记上侧菜单栏中，有两个图标：

![](https://pic3.zhimg.com/80/v2-e845a697900d68410c44e5d35e97595a_720w.webp)

单击这两个图标就可以切换显示模式。

同一个笔记，在obsidian主界面中可以同时在多个窗口内显示，就像obsidian help中的笔记一样，右侧显示编辑模式，左侧实时显示预览模式。

在笔记最上面一栏单击“更多”，选择“左右拆分”（上下拆分也可以）

![](https://pic2.zhimg.com/80/v2-108ac9e33d82fae042205d258f0ec399_720w.webp)

![](https://pic3.zhimg.com/80/v2-73606683f4055dc9bca0a787b705b982_720w.webp)

如果你愿意，可以在obsidian主界面划分多个窗口分别显示不同的笔记，用来实现不同的记录需求（比如一边看文献一边记录）：

![](https://pic4.zhimg.com/80/v2-0c3d3ce53477a6ef2e7635a24244f9ff_720w.webp)

配合obsidian的核心插件【工作台】，你可以实现不同工作台的实现：

![](https://pic3.zhimg.com/80/v2-b74d256eededa58cc609c1016cabed82_720w.webp)

以前做过的一个工作台

具体的设置方法，可以参考我写过的一篇教程：

[Wyatt：打造自己的工作台【玩转Obsidian的保姆级教程】222 赞同 · 7 评论文章![](https://pic1.zhimg.com/v2-2323eabf712e3ebaae40c322ec18dde0_180x120.jpg)](https://zhuanlan.zhihu.com/p/409409946)

  

### 实时显示笔记大纲

在obsidian中记录，可以用核心插件查看自己的写作大纲，比如这样：

![](https://pic2.zhimg.com/80/v2-e62b762c28183b815dbf0f64d108d721_720w.webp)

如何打开ob里面的大纲功能？

obsidian设置——核心插件——大纲

![](https://pic2.zhimg.com/80/v2-0c2ab1f8ec5b6c98130e049c9aadff69_720w.webp)

![](https://pic1.zhimg.com/80/v2-c88704e9af9086d532dc63d69e54d754_720w.webp)

这一大纲是根据你的笔记内容变化的，具体怎么变化——其实就是通过Markdown语法实现的。

我在用“#”实现对标题分级的同时，也是在设立大纲：

![](https://pic2.zhimg.com/80/v2-2fd8237c0da8053934088a2ce04aca85_720w.webp)

### 三.插件是什么？

> 插件在obsidian中起到了增强obsidian使用功能的作用，对于提升使用舒适度，定制使用风格有着重要的意义。

obsidian中的插件分为两种：

- 核心插件

刚才我提到的笔记大纲、工作台，都是ob自带的核心插件的一种，是obsidian自带的为了增强功能的一种插件。需要自己通过设置启用。

- 第三方插件

这个不多探讨，如果想详细了解第三方插件，可以参考我写的一篇教程：

[Wyatt：如何安装插件？【玩转Obsidian的保姆级教程】270 赞同 · 63 评论文章![](https://pic2.zhimg.com/v2-51f1cdbc1b5891f62958cdb379dc5561_180x120.jpg)](https://zhuanlan.zhihu.com/p/403001135)

也可以访问我的知乎专栏，我在里面写了很多我常用插件的教程：

[玩转Obsidian的保姆级教程​www.zhihu.com/column/c_1413472005866266624![](https://pic2.zhimg.com/v2-52a669542a8699d42a3c5796c7e536e9_ipico.jpg)](https://www.zhihu.com/column/c_1413472005866266624)

如何使用核心插件？

打开obsidian设置：

![](https://pic2.zhimg.com/80/v2-0c2ab1f8ec5b6c98130e049c9aadff69_720w.webp)

点击核心插件选项，会发现有很多核心插件待启用：

![](https://pic4.zhimg.com/80/v2-9104faf388882b18d0865282153fa567_720w.webp)

这里我挑了几个主要的核心插件进行介绍：

- 模板：

[Wyatt：模板——践行模块化思维【玩转Obsidian的保姆级教程】110 赞同 · 16 评论文章![](https://pic2.zhimg.com/v2-42527f212c876f4f79ae0c1cb7d300f1_180x120.jpg)](https://zhuanlan.zhihu.com/p/411452840)

- 日记核心插件：

[Wyatt：日记——好用的核心插件【玩转Obsidian的保姆级教程】102 赞同 · 9 评论文章![](https://pic2.zhimg.com/v2-2ff12348f99fc98e8e0273a330af78b5_180x120.jpg)](https://zhuanlan.zhihu.com/p/403111731)

- 漫游笔记：

[Wyatt：漫游笔记——被严重低估的功能【玩转obsidian的保姆级教程】55 赞同 · 6 评论文章![](https://pic3.zhimg.com/v2-47eb2ff28856aade8235ead6d93b0802_180x120.jpg)](https://zhuanlan.zhihu.com/p/410053967)

- 笔记图谱：

[Wyatt：网状图？目录！28 赞同 · 24 评论文章![](https://pic2.zhimg.com/v2-8afac86a6824170bdd881a3aa203d7fd_180x120.jpg)](https://zhuanlan.zhihu.com/p/417101915)

- 幻灯片制作：（ob能制作简易的幻灯片！！）

[Wyatt：用obsidian做ppt【玩转Obsidian的保姆级教程】31 赞同 · 14 评论文章![](https://pic3.zhimg.com/v2-c165e4db3c93b4e564b9439040e9feee_180x120.jpg)](https://zhuanlan.zhihu.com/p/412523896)

- 录音机：  
    

![](https://pic4.zhimg.com/80/v2-5890f42834f834d3918afe9e33576b43_720w.webp)

![](https://pic1.zhimg.com/80/v2-cf971d32ff0c7b439f05c28f378cca24_720w.webp)

点击即可录音，再次点击就会结束录音，然后录音文件会保存在笔记中：

![](https://pic1.zhimg.com/80/v2-d65e429576a304869251ccc1fc440420_720w.webp)

其实这时候，你再次点开库文件，你会发现，在库文件中多了一个录音文件：

![](https://pic2.zhimg.com/80/v2-4b19bff7cb35aa44dd6076807fd94151_720w.webp)

### 四.什么是双向链接？

> 你可以理解为双向链接是一种更高级的引用

只不过，这里的引用是双向的

我可以在A文章中引用B，当你浏览B的时候，系统会显示B被A引用了。

具体的介绍，可以浏览我写的这篇文章，我在里面具体地阐述了双链连接的好处

[Wyatt：为什么选择·Obsidian？【玩转Obsidian的保姆级教程】237 赞同 · 23 评论文章![](https://pic2.zhimg.com/v2-d0cca5f1d098250f32c19e62d31377d1_180x120.jpg)](https://zhuanlan.zhihu.com/p/402994214)

使用的方式也很简单

可以直接把文件从左侧的目录栏里面拖拽到在编辑模式下的笔记中：

![](https://pic2.zhimg.com/80/v2-2b00e6bb950a55a88f22a30e7b169c0d_720w.webp)

然后调成预览模式，单击笔记中被引用的笔记名，会自动跳转到那篇笔记中：

![](https://pic3.zhimg.com/80/v2-e7794d986ba2e6ead87d990ae418c982_720w.webp)

在这篇被引用的笔记中，可以看到右侧显示这篇笔记被谁引用，被引用多少次。

并且此时，在关系图谱中，你也会看到这两篇笔记被联系起来了。

![](https://pic3.zhimg.com/80/v2-c702f52a14481b597193f2bfc40c592a_720w.webp)

同时，你也可以自己写引用，语法很简单，把输入法调整成英文输入法，然后输入两个中括号，再输入笔记名就实现了引用

![](https://pic3.zhimg.com/80/v2-1e704807e59ca9284e33826817e1465e_720w.webp)

并且，![[文件名]]表示在引用的同时被预览：

![](https://pic3.zhimg.com/80/v2-f895ec671ec6222c5fe321e123e42cb2_720w.webp)

还有一种引用方式是打标签，使用方法也很简单：用#加上你的内容即可（注意中间没有空格）：

![](https://pic3.zhimg.com/80/v2-7f27ddecbf5bf120e2541c896f2a7c5e_720w.webp)

比如这样，便与检索。

![](https://pic3.zhimg.com/80/v2-9c66f73d59f515584bdfbd873f9fad02_720w.webp)

同时也可以在关系图谱中显示：

![](https://pic1.zhimg.com/80/v2-c2e48aa3d8ff4c37397c5a8315715f3c_720w.webp)

---

  

以上就是一些基本的使用方法，如果还有什么疑问，欢迎留言。

建议自习阅读obsidian help中的【格式化你的笔记】，可以帮助你快速上手markdown语法

最后，祝你使用愉快。
