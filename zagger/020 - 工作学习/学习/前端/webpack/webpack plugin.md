---
alias:
tags: 长青笔记
cdate: 2023-12-14 16:59
uid: 20231214165957
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. webpack compiler

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2023-12-14 星期四 16:59:33

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

### 1.4.1. 跟着源码了解Webpack编译流程
### 1.4.2. Plugins

即插件，它是可插拔的模块，可以完成更多[编译过程](https://so.csdn.net/so/search?q=%E7%BC%96%E8%AF%91%E8%BF%87%E7%A8%8B&spm=1001.2101.3001.7020)中 loader 不能完成的功能。这里我们要先介绍一下Plugin依赖的另外一个库——Tapable[2]，它简单来说就是一个发布-订阅模式的实现。它提供了很多类型的钩子类（如同步、异步、并行、熔断等），他们可以tap（订阅）若干个回调函数，在call（发布）的时候，将订阅的回调函数以对应的方式执行。举个例子🌰：

```js
const tapable = require("tapable"); 
 
const { SyncHook } = tapable; 
 
const hook = new SyncHook(); 
 
hook.tap("MyHook", () => { console.log("enter MyHook") }); 
hook.tap("MyHook2", () => { console.log("enter MyHook2") }); 
 
hook.call(); // enter MyHook   enter MyHook2
```

webpack的Plugin是与上述的Tapable强耦合的，我们可以参照下面一个plugin的简单实现来了解一下：

```js
class MyPlugin { 
  apply(compiler) { 
    compiler.hooks.make.tap("MyPlugin", (compilation) => { 
      // ... 
      compilation.hooks.optimizeChunkAssets.tap("MyPlugin", (chunks) => { 
        // ... 
      } 
    } 
  } 
}
```

结合上述代码我们可以注意到：

- plugin必须在原型上定义一个apply方法，并接受了一个compiler实例作为参数。
    
- apply方法会在初始化插件时被调用，此时我们可以对compiler、compilation上的hooks做订阅，等编译流程执行到了我们监听的时机，就会调用订阅的回调函数，来对编译的过程做一些对应操作。
    

Webpack 会在特定的时间点（编译周期钩子）发布特定的事件，插件在监听到对应事件后会执行特定的逻辑，并且插件可以调用 Webpack 提供的 API 改变 Webpack 的运行结果


# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
[跟着源码了解Webpack编译流程-CSDN博客](https://blog.csdn.net/frontend_frank/article/details/131098725)
[如何编写一个WebPack的插件原理及实践 - 龙恩0707 - 博客园](https://www.cnblogs.com/tugenhua0707/p/11332463.html)
[Webpack插件核心原理\_webpack\_Geek\_02d948\_InfoQ写作社区](https://xie.infoq.cn/article/e61d3035bd82680f71d6b9936)
[Webpack5，了解从0到1搭建一个项目的细节 - 掘金](https://juejin.cn/post/7031813766098452493)
[面试官：你写过webpack插件吗？ - 掘金](https://juejin.cn/post/7034442352001286152)
[webpack source code](https://github.com/webpack/webpack/blob/main/lib/APIPlugin.js)
[filemanager-webpack-plugin](https://github.com/gregnb/filemanager-webpack-plugin/tree/master)
[自定义插件 | webpack 中文文档](https://webpack.docschina.org/contribute/writing-a-plugin/#tapasync)
[TerserWebpackPlugin | webpack 中文文档](https://webpack.docschina.org/plugins/terser-webpack-plugin/#getting-started)
[compiler 钩子 | webpack 中文文档](https://webpack.docschina.org/api/compiler-hooks/)
[自定义插件 | webpack 中文文档](https://webpack.docschina.org/contribute/writing-a-plugin/#creating-a-plugin)
[Webpack 自定义插件学习笔记\_前端知识库](https://frontend.devrank.cn/traffic-information/7297189240902617126)
[【webpack系列】从基础配置到掌握进阶用法 - 知乎](https://zhuanlan.zhihu.com/p/644734290)
[webpack Compiler-CSDN博客](https://blog.csdn.net/qq_40409143/article/details/123663207)
[Webpack打包，compile实际处理的是webpack的参数moudle的健值(chank) - 知乎](https://zhuanlan.zhihu.com/p/554365882?utm_id=0)
[前端开发环境mock+持久化方案 - 简书](https://www.jianshu.com/p/f834e31e4959)
[webpack 源码分析（四）——complier模块 - 简书](https://www.jianshu.com/p/9e75b27ef7b8)