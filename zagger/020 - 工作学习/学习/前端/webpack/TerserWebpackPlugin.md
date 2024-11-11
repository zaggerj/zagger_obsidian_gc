---
alias:
tags: 长青笔记
cdate: 2023-12-14 14:20
uid: 20231214142059
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. TerserWebpackPlugin

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2023-12-14 星期四 14:20:36

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

terser-webpack-plugin 是一个 Webpack 插件，它可以将 JavaScript 代码进行压缩，从而减小文件的体积，提升加载速度。它使用 Terser 库来执行压缩，Terser 是一个用于压缩 JavaScript 代码的工具，可以对代码进行简单的混淆，以及删除未使用的代码和注释等优化。

使用 terser-webpack-plugin 的方式是在 Webpack 配置文件中引入该插件，并将其添加到 plugins 数组中。例如：

ini

复制代码

`const TerserPlugin = require('terser-webpack-plugin'); module.exports = {   // ...   optimization: {     minimizer: [new TerserPlugin()]   }   // ... };`

在这里，TerserPlugin 实例被添加到了 optimization.minimizer 数组中，表示它是一个 JavaScript 代码压缩器，在打包过程中会被使用。

需要注意的是，terser-webpack-plugin 默认会忽略 console.log 等调试语句，如果需要保留这些语句，可以在 TerserPlugin 的配置项中设置 compress.drop_console 为 false。
## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

# 2. terser-webpack-plugin

This plugin uses [terser](https://github.com/terser/terser) to minify/minimize your JavaScript.

## 2.1. [](https://github.com/webpack-contrib/terser-webpack-plugin#getting-started)Getting Started

Webpack v5 comes with the latest `terser-webpack-plugin` out of the box. If you are using Webpack v5 or above and wish to customize the options, you will still need to install `terser-webpack-plugin`. Using Webpack v4, you have to install `terser-webpack-plugin` v4.

To begin, you'll need to install `terser-webpack-plugin`:

```shell
npm install terser-webpack-plugin --save-dev
```

or

```shell
yarn add -D terser-webpack-plugin
```

or

```shell
pnpm add -D terser-webpack-plugin
```

Then add the plugin to your `webpack` config. For example:

**webpack.config.js**

```js
const TerserPlugin = require("terser-webpack-plugin");

module.exports = {
  optimization: {
    minimize: true,
    minimizer: [new TerserPlugin()],
  },
};
```

And run `webpack` via your preferred method.
# 3. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
[terser-webpack-plugin](https://github.com/webpack-contrib/terser-webpack-plugin)
[terser-webpack-plugin作用-掘金](https://juejin.cn/s/terser-webpack-plugin%E4%BD%9C%E7%94%A8)