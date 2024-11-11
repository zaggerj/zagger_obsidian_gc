---
alias:
tags: 长青笔记
cdate: 2023-12-27 11:23
uid: 20231227112448
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. chrome扩展开发相关

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2023-12-27 星期三 11:23:32

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

1. 问题：【插件】跟【客户端flash服务】如何交互？
```
第一步：插件  <----终端ip---      guesttool
第二部：终端  <---http://ip:9999/*--->   插件
插件拿到终端IP后，就直接和终端对接了
```
2. 问：有没有可能用其他chrome内核的浏览器 替换nw？答：重定向环境要的是 webview，不是附加了其它界面元素的浏览器
3. 问：我这边应该是不依赖nw的，如果要替换也是他们终端服务这边要修改东西的？答：是

[[Service Worker API]]


## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

### 1.4.1. 使用到的API简述
1. Manifest：[清单文件格式  |  Manifest  |  Chrome for Developers](https://developer.chrome.com/docs/extensions/reference/manifest?hl=zh-cn#keys)
	1. `"options_page"`：指定 options.html 文件的路径，以将扩展程序用作选项页面。如需了解详情，请参阅[为用户提供选项](https://developer.chrome.com/docs/extensions/develop/ui/options-page?hl=zh-cn)。
	2. 为用户提供选项：[为用户提供选项  |  Extensions  |  Chrome for Developers](https://developer.chrome.com/docs/extensions/develop/ui/options-page?hl=zh-cn)
2. 内容脚本：[内容脚本  |  Extensions  |  Chrome for Developers](https://developer.chrome.com/docs/extensions/develop/concepts/content-scripts?hl=zh-cn)
	1. chrome.runtime，使用 `chrome.runtime` API 可检索 Service Worker，返回有关清单的详情，并监听和响应应用或扩展程序生命周期中的事件。您还可以使用此 API 将网址的相对路径转换为完全限定网址。Runtime API 提供了为扩展程序可以使用的功能的多个领域提供支持的方法： [chrome.runtime  |  API  |  Chrome for Developers](https://developer.chrome.com/docs/extensions/reference/api/runtime?hl=zh-cn#method-connect)
		1. onMessage事件，在扩展程序进程（通过 [`runtime.sendMessage`](https://developer.chrome.com/docs/extensions/reference/api/runtime?hl=zh-cn#method-sendMessage)）或内容脚本（通过 [`tabs.sendMessage`](https://developer.chrome.com/docs/extensions/reference/tabs/?hl=zh-cn#method-sendMessage)）发送消息时触发。：[chrome.runtime  |  API  |  Chrome for Developers](https://developer.chrome.com/docs/extensions/reference/api/runtime?hl=zh-cn#event-onMessage)
	2. chrome.tabs，使用 `chrome.tabs` API 与浏览器的标签页系统进行交互。您可以使用此 API 在浏览器中创建、修改和重新排列标签页。Tabs API 不仅提供操控和管理标签页的功能，还能检测标签页的[语言](https://developer.chrome.com/docs/extensions/reference/api/tabs?hl=zh-cn#method-detectLanguage)、截取[屏幕截图](https://developer.chrome.com/docs/extensions/reference/api/tabs?hl=zh-cn#method-captureVisibleTab)，以及与标签页的内容脚本[通信](https://developer.chrome.com/docs/extensions/reference/api/tabs?hl=zh-cn#method-sendMessage)。
		1. 事件：[chrome.tabs  |  API  |  Chrome for Developers](https://developer.chrome.com/docs/extensions/reference/api/tabs?hl=zh-cn#event)
			1. onActivated：在窗口中的活动标签页发生变化时触发。请注意，在触发此事件时可能未设置标签页的网址，但您可以监听 onUpdated 事件，以便在设置网址时收到通知。
			2. onUpdated：在标签页更新时触发。
			3. onRemoved：在标签页关闭时触发。
		2. executeScript：将 JavaScript 代码注入网页中。如需了解详情，请参阅内容脚本文档的[程序化注入](https://developer.chrome.com/docs/extensions/content_scripts?hl=zh-cn#pi)[chrome.tabs  |  API  |  Chrome for Developers](https://developer.chrome.com/docs/extensions/reference/api/tabs?hl=zh-cn#method-executeScript)
		3. 标签页上的属性和方法：[chrome.tabs  |  API  |  Chrome for Developers](https://developer.chrome.com/docs/extensions/reference/api/tabs?hl=zh-cn#type-Tab)
		4. window上的属性和方法： [chrome.windows  |  API  |  Chrome for Developers](https://developer.chrome.com/docs/extensions/reference/api/windows?hl=zh-cn#type-Window)
	3. webRequest：使用 `chrome.webRequest` API 可以观察和分析流量，以及拦截、屏蔽或修改传输中的请求。
		1. onBeforeSendHeaders：在请求标头可用时，在发送 HTTP 请求之前触发。这可能会发生在 TCP 连接到服务器之后、发送任何 HTTP 数据之前。[chrome.webRequest  |  API  |  Chrome for Developers](https://developer.chrome.com/docs/extensions/reference/api/webRequest?hl=zh-cn#event-onBeforeSendHeaders)

### 1.4.2. 代码逻辑简述

#### 1.4.2.1. 背景页面

背景页面的概念参考[百度文档 (opens new window)](https://chajian.baidu.com/developer/extensions/overview.html#arch)。

背景页面是常驻内存的，它需要为白名单网址提供重定向并保存当前重定向信息。

所有的重定向逻辑都在 `src/js/core.js` 里面，它做了这样几件事：

- 监听来自页面的 `viewport-change` 事件，并发送给客户端 flash 服务
- 阻止白名单网站的 .swf 文件请求，这样是为了禁用 flash 播放器
- 监听浏览器激活 tab 页变化事件
- 监听浏览器 tab 页更新事件
- 监听浏览器 tab 页关闭事件

重定向的核心逻辑就在 tab 页的 3 个事件里面，总的来说就这么几条：

1. 打开的时候开始播放
2. 关闭的时候停止播放
3. 切换 tab 页的时候，前一个 tab 页临时停止播放，当前 tab 页开始播放

当一个 tab 页在白名单里面时，就会开始播放，播放时插件会将 `src/js/cs.js` 注入到当前 tab 页，注入的目的是为了捕获浏览器窗口移动或者缩放。


#### 1.4.2.2. 前景页面

此页面即 `src/js/cs.js`。

当它出于活动状态时，它做了这么几件事情：

- 每隔 1 秒监听一次浏览器窗口位置是否发生了变化，如果变化则发送给背景页面
- 监听浏览器窗口缩放事件，缩放时发送消息给背景页面
- 监听浏览器页面可见性事件，变化时发送消息给背景页面，临时停止此 tab 页的播放



#### 1.4.2.3. flash 重定向

flash 重定向是为了降低虚拟机内播放视频对VDI服务器产生的CPU压力。

##### 1.4.2.3.1. [#](http://192.168.0.161/fedoc/flashredirect/#%E8%83%8C%E6%99%AF%E5%8E%9F%E7%90%86)背景原理

VDI客户端使用 spice 协议连接管理台里面的教学场景时，实际上相当于连接了一个由VDI服务器创建出来的虚拟机（类似远程桌面连接），此时VDI客户端上面有如下窗口界面：

- 客户端操作系统界面
- spice 远程连接界面，界面里面就是虚拟机内的操作系统界面（一般是全屏，可能未置顶）

对用户来说，此时主要的交互界面就是 spice 远程连接界面，也就是虚拟机操作系统界面。用户在虚拟机里面使用 Chrome 打开优酷网时，优酷可以播放视频，但由于视频涉及数据加载、解码、播放等，虚拟机内的CPU压力较高，当有很多个虚拟机同时播放视频时，反应在VDI服务器上就是系统负载过高。

为了降低VDI服务器的系统负载，flash 重定向技术应运而生，这项技术的核心原理是转移虚拟机内的CPU压力到客户端，即：每当虚拟机里面要播放视频的时候，将播放重定向到客户端，此时虚拟机就不用播放视频了，进而有效降低虚拟机内的CPU压力。

使用了 flash 重定向后，当VDI客户端连接虚拟机时，VDI客户端上面有如下窗口界面：

- 客户端操作系统界面
- spice 远程连接界面，界面里面就是虚拟机内的操作系统界面（一般是全屏，可能未置顶）
- flash 视频播放界面（此界面与虚拟机内的播放界面**无缝重合**）

此时，对于用户来说，交互过程如同以前一样，他并不知道视频播放已经转移到了客户端。

##### 1.4.2.3.2. [#](http://192.168.0.161/fedoc/flashredirect/#%E9%87%8D%E5%AE%9A%E5%90%91%E7%B1%BB%E5%9E%8B)重定向类型

重定向有两种：

- 第一种是使用诸如暴风影音播放虚拟机内的视频时，客户端启动了另一个播放程序同步播放虚拟机内的视频
- 第二种是访问浏览器内的视频页面的时候，客户端需要另一个浏览器同步浏览虚拟机内的浏览器页面

目前公司相关产品的设计里，仅仅第二种与前端有关。

疑问：为什么在客户端里面打开浏览器来实现 flash 重定向？没有其它更好的解决方案了吗？

的确有其它更好的解决办法，但是先贤们已经倒在了以前的更好的方案里面，**重定向需要获取到目标视频的有效地址，对于多数视频网站来说，加密、认证、视频分段都是常规手段，它们为优雅的解决重定向技术树立了相当大的障碍**

##### 1.4.2.3.3. [#](http://192.168.0.161/fedoc/flashredirect/#flash-%E9%87%8D%E5%AE%9A%E5%90%91%E5%AE%9E%E7%8E%B0%E8%BF%87%E7%A8%8B)flash 重定向实现过程

- 虚拟机内的 Chrome 安装 flash 重定向插件(下面称插件）
- 虚拟机内的 Chrome 打开优酷网页面
    - 插件发送开始播放请求到客户端 flash 重定向服务（下称服务）
    - 服务启动 nw
    - nw 打开优酷网，并完整覆盖虚拟机浏览器视口区域
    - 用户观看 nw 播放的视频
    - 用户在 nw 播放的页面点击另一个视频
    - 另一个视频继续在 nw 里面播放
    - 用户关闭掉优酷网 tab 页
    - 插件发送停止播放请求到服务

##### 1.4.2.3.4. [#](http://192.168.0.161/fedoc/flashredirect/#%E4%B8%BA%E4%BB%80%E4%B9%88%E5%8F%AB%E5%81%9A-flash-%E9%87%8D%E5%AE%9A%E5%90%91)为什么叫做 flash 重定向？

该项目早期阶段，flash 还大行其道，当时解决问题的首要问题就是处理 flash 视频，因此命名为 flash 重定向，现在可以称之为 web 重定向。
#### 1.4.2.4. # 插件说明

插件仓库：[地址(opens new window)](http://172.16.203.254/zhangyao/newflashrediredt)

技术栈：gulp, commonjs, javascript, chrome.* API

该项目是一个标准的 Chrome 浏览器插件，Chrome 插件开发的官方文档在[这里](http://192.168.0.161/fedoc/flashredirect/plugin.html)，百度提供了一个[汉化的文档 (opens new window)](https://chajian.baidu.com/developer/extensions/getstarted.html)，不过这个文档不是最新的，并且有部分API仅仅在百度浏览器上可以使用。

##### 1.4.2.4.1. [#](http://192.168.0.161/fedoc/flashredirect/plugin.html#%E7%9B%AE%E5%BD%95%E7%BB%93%E6%9E%84)目录结构

```
src
├── css                        # 选项页样式
│   └── options.css
├── images                     # logo
│   ├── icon128.png
│   ├── icon16.png
│   ├── icon48.png
│   └── icon64.png
├── js
│   ├── ajax.js
│   ├── background.js          # 背景脚本主程序
│   ├── core.js                # 核心的业务逻辑实现
│   ├── cs.js                  # 前台脚本，由背景脚本手动注入到视频播放页面
│   ├── env
│   │   ├── development.js
│   │   └── production.js
│   ├── livereload.js          # 自动重载插件的开发工具
│   ├── old                    # 忽略掉
│   │   ├── README.md
│   │   ├── background.js
│   │   └── content_script.js
│   ├── options.js             # 选项页的 js，一般不需要修改
│   ├── service                # 将单一的功能代码封装为一个可执行的服务
│   │   ├── changebase.js      # 修改重定向服务地址的服务
│   │   ├── device.js          # 获取客户端设备信息的服务
│   │   ├── heartbeat.js       # 心跳服务
│   │   └── playstatus.js      # 轮训当前播放状态的服务
│   ├── util.js
│   ├── variables.js
│   └── whitelist.js           # 默认的白名单列表，用户增删了白名单后，引入此模块后就是修改后的白名单
├── manifest.json              # 插件元数据
└── options.html               # 选项页，里面可以设置白名单
dist.pem                       # 插件的秘钥，不可以修改
```

##### 1.4.2.4.2. [#](http://192.168.0.161/fedoc/flashredirect/plugin.html#%E5%8F%AF%E7%94%A8%E7%9A%84%E5%91%BD%E4%BB%A4)可用的命令

##### 1.4.2.4.3. [#](http://192.168.0.161/fedoc/flashredirect/plugin.html#gulp-%E6%88%96%E8%80%85-gulp-watch)`gulp` 或者 `gulp watch`

运行一次 build 任务，并监听源码变更，每当发生变更时，重新执行 build 任务

##### 1.4.2.4.4. [#](http://192.168.0.161/fedoc/flashredirect/plugin.html#gulp-build)`gulp build`

生成代码到 dist 目录，同时生成 sourcemap 到 maps 目录。生成之后，需要使用 Chrome 浏览器的插件管理页面手动打包本扩展，如图： ![chrome build crx](http://192.168.0.161/fedoc/assets/img/build-crx.80bbadde.png) 打包后会在项目根目录生成 `dist.crx`，此时运行：

```
bash deploy.sh
```

上面的命令会将 `dist.crx` 移动到 zips 目录并加上日期和 build 号信息。

**注意：提交的时候，zips, maps 目录都需要提交**

##### 1.4.2.4.5. [#](http://192.168.0.161/fedoc/flashredirect/plugin.html#%E5%89%8D%E5%B0%98%E5%BE%80%E4%BA%8B)前尘往事

##### 1.4.2.4.6. [#](http://192.168.0.161/fedoc/flashredirect/plugin.html#deploy-sh-%E8%84%9A%E6%9C%AC%E9%87%8C%E9%9D%A2%E6%9C%89%E5%87%A0%E8%A1%8C%E4%BB%A3%E7%A0%81%E8%A2%AB%E6%B3%A8%E9%87%8A%E6%8E%89%E4%BA%86-%E4%B8%BA%E4%BB%80%E4%B9%88)deploy.sh 脚本里面有几行代码被注释掉了，为什么？

这几行代码如下：

> 下面这种自动检查插件 ID 的方法在 chrome 65 失效了
> 
> echo "check extension id ..."
> 
> node -p "require('crx-parser')(fs.readFileSync('./dist.crx'), function(err, data){ console.log(err || (require('chrome-extension-id')(data.header.publicKey) === 'nallafmcbjlffmfjnndbjmfpnicjfbnp' ? 'match' : 'not match')); })"

打包扩展的时候，需要使用秘钥文件，为了方便验证打包后的 ID 是否一致，添加了上述代码校验当前打包的扩展是否是默认的 ID。不幸的是，Chrome 65 之后，这种校验方法失效了，使用的依赖库 [chrome-extension-id (opens new window)](https://npm.taobao.org/package/chrome-extension-id)也没有继续更新，所以注释掉了这里的代码，如果以后发现这个依赖包更新了，可以放开这些注释。

##### 1.4.2.4.7. [#](http://192.168.0.161/fedoc/flashredirect/plugin.html#dist-pem-%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E8%83%BD%E4%BF%AE%E6%94%B9)dist.pem 为什么不能修改？

dist.pem 保证了每次打包的扩展ID不变。

正常来说，由于插件并没有上传到 Chrome 插件商城，直接安装是无法成功的，但虚拟机内的 guesttool 修改了相关注册表，使得可以安装指定的插件。这个指定的意思就是指定一系列允许的插件 ID，在这个列表里面的 ID 就可以直接安装。
# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
1. Manifest V3：
[chrome.tabs  |  API  |  Chrome for Developers](https://developer.chrome.com/docs/extensions/reference/api/tabs?hl=zh-cn#method-executeScript)
[扩展程序 / 使用入门  |  Get started  |  Chrome for Developers](https://developer.chrome.com/docs/extensions/get-started?hl=zh-cn)
[Hello World 扩展程序  |  Extensions  |  Chrome for Developers](https://developer.chrome.com/docs/extensions/get-started/tutorial/hello-world?hl=zh-cn)
[扩展程序 Service Worker 简介  |  Extensions  |  Chrome for Developers](https://developer.chrome.com/docs/extensions/develop/concepts/service-workers?hl=zh-cn)



2. Manifest V2：
[extensions/mv2/reference?hl=zh-cn](https://developer.chrome.com/docs/extensions/mv2/reference?hl=zh-cn)

3. [插件说明 | OS-Easy 前端文档](http://192.168.0.161/fedoc/flashredirect/plugin.html)
[ServiceWorkerGlobalScope - Web API 接口参考 | MDN](https://developer.mozilla.org/zh-CN/docs/Web/API/ServiceWorkerGlobalScope#events)