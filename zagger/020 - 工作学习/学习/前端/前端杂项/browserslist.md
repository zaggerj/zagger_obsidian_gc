---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
## 前言

最近在看create-react-app，刚好把browserslist的资料整理下来。一方面督促自己多写博客，另一方面练习自己的英语水平（6级还没过的我(；´д｀)ゞ

## browserslist的作用

- [npm地址](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.npmjs.com%2Fpackage%2Fbrowserslist)
- [github](https://links.jianshu.com/go?to=%255Bhttps%3A%2F%2Fgithub.com%2Fbrowserslist%2Fbrowserslist%255D%28https%3A%2F%2Fgithub.com%2Fbrowserslist%2Fbrowserslist%29)

这个配置能够分享目标浏览器和nodejs版本在不同的前端工具。这些工具能根据目标浏览器自动来进行配置，

## 使用方法

(1) package.json （推荐

```json
{
  "browserslist": [
    "last 1 version",
    "> 1%",
    "maintained node versions",
    "not dead"
  ]
}
```

(2) .browserslistrc

```bash
# Browsers that we support 
 
last 1 version
> 1%
maintained node versions
not dead
```

Browserslist 的数据都是来自[Can I Use](https://links.jianshu.com/go?to=http%3A%2F%2Fcaniuse.com%2F)的。如果你想知道配置语句的查询结果可以使用[online demo] ([https://browserl.ist/](https://links.jianshu.com/go?to=https%3A%2F%2Fbrowserl.ist%2F))

![](//upload-images.jianshu.io/upload_images/3529442-08e5df3b7a9dedd6.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

查询 last 1 version

你就可以看到最新的各个浏览器版本

## 支持的插件

Browserslist这个东西单独是没用的，（补充: 在vue官方脚手架中，browserslist字段会被 [@babel/preset-env](https://links.jianshu.com/go?to=https%3A%2F%2Fnew.babeljs.io%2Fdocs%2Fen%2Fnext%2Fbabel-preset-env.html) 和 [Autoprefixer](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fpostcss%2Fautoprefixer) 用来确定需要转译的 JavaScript 特性和需要添加的 CSS 浏览器前缀。2019-7-22）下面的搭配的工具列表：

- [Autoprefixer](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fpostcss%2Fautoprefixer)
- [Babel](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fbabel%2Fbabel%2Ftree%2Fmaster%2Fpackages%2Fbabel-preset-env)
- [postcss-preset-env](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fjonathantneal%2Fpostcss-preset-env)
- [eslint-plugin-compat](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Familajack%2Feslint-plugin-compat)
- [stylelint-no-unsupported-browser-features](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fismay%2Fstylelint-no-unsupported-browser-features)
- [postcss-normalize](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fjonathantneal%2Fpostcss-normalize)

了解更多请看这个[list](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fbrowserslist%2Fbrowserslist-example)

或者`npx browserslist`

## 最终选择

Browserslist将使用以下来源之一的浏览器和Node.js版本查询：

- browserslist键入package.json当前或父目录中的文件。 我们推荐这种方式。

- 工具选项。例如browsersAutoprefixer中的选项。
- BROWSERSLIST 环境变量。
- browserslist 当前或父目录中的配置文件。
- .browserslistrc 当前或父目录中的配置文件。
- 如果上述方法没有产生有效结果，则Browserslist将使用默认值： > 0.5%, last 2 versions, Firefox ESR, not dead。

## 最佳实践

- `last 2 Chrome versions` 这种配置最好当你只想在对应的一个浏览器下开发webapp，生产情况下最好不要，毕竟其他浏览器也有市场份额
- 如果你想自己配置，我建议你结合 `last 1 version, not dead with > 0.2% (or > 1% in US, > 1% in my stats`. `last n version`会增加很过过时的浏览器并且没有增加流行的旧版本浏览器。`> 0.2%`看起来更加合适（根据份额来定）
- 不要仅因为您不了解浏览器而删除浏览器。Opera Mini在非洲拥有1亿用户，它在全球市场上比微软边缘更受欢迎。中文QQ浏览器的市场份额比Firefox和桌面Safari都要多。（第一次知道，qq还是强啊，但是360呢..）

## 一些语句的含义

- `dead`: browsers from last 2 version query, but with less than 0.5% in global usage statistics and without official support or updates for 24 months. Right now it is IE 10, IE_Mob 10, BlackBerry 10, BlackBerry 7, and OperaMobile 12.1.

## 例子

> 自己项目中使用的

```bash
"browserslist": [
    "> 1%",
    "last 2 versions",
    "not ie <= 8"
  ]
```

## 最后

毫无疑问这篇很粗浅，还是多看npm文档比较实际...~~再慢慢补充

参考链接
[browserslist详解 - 简书 (jianshu.com)](https://www.jianshu.com/p/d45a31c50711)