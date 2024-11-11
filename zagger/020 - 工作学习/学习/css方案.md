---
alias: 
tags: 长青笔记
cdate: 2023-11-14 14:31
uid: 20231114143120
searchterm: "#长青笔记"
banner: 040 - Obsidian/附件/banners/book-banner.gif
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
created: 2023-11-14 14:31:10
updated: 2023-11-17 14:51:44
---

# 1. css方案

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[css]] [[2023年11月14日]]
Author:: {原资讯的作者或者对话的人或者引起某种想法的原因}
Source URL::
Modify:: `=dateformat(this.file.mtime, "yyyy-MM-dd HH:MM:ss")`

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::windicss已经落寞，探索其他方案。

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_
windicss官方已经明确表示自己的衰落和维护力度，并推荐新项目考虑unocss或者taiwindcss。
## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_
### 1.4.1. Windi CSS is Sunsetting[#](https://windicss.org/posts/sunsetting.html#windi-css-is-sunsetting)

Initiated by [@voorjaar](https://github.com/voorjaar) in December 2020, Windi CSS was created to explore the possibilities of solving [Tailwind's performance issues](https://v1.tailwindcss.com/docs/controlling-file-size). Our efficient and powerful [on-demand approach](https://windicss.org/guide/#why-windi-css) later inspired Tailwind to implement [their "JIT" engine](https://v2.tailwindcss.com/docs/just-in-time-mode), the same methodology of Windi CSS. Along the way, we delved into various possibilities for enhancing developer experience, introducing features such as [Variant Group](https://windicss.org/features/variant-groups), [Shortcuts](https://windicss.org/features/shortcuts), [Attributify Mode](https://windicss.org/features/attributify), [Visual Analyzer](https://windicss.org/features/analyzer). These innovations influenced [UnoCSS](https://unocss.dev/) and significantly improved the developer experience across other atomic CSS frameworks.
<mark style="background: #FF5582A6;">For new projects, we recommend considering alternatives like</mark> [UnoCSS](https://unocss.dev/) or [Tailwind CSS](https://tailwindcss.com/).

### 1.4.2. <mark style="background: #FF5582A6;">探索UnoCSS</mark>
看文档先看why xxx？了解方案优劣。

angularjs项目配置步骤：
1. package.json 
```js
	pnpm add -D @unocss/webpack
	pnpm add -D unocss
	{
   unocss": "^0.57.3",
   "@unocss/webpack": "^0.57.3",
   }
```
2. 新增uno.config.js
```js
import { defineConfig, presetAttributify, presetUno, presetIcons } from 'unocss'

export default defineConfig({
  presets: [presetUno(), presetAttributify(), presetIcons({ scale: 1.2, warn: true })],
  shortcuts: [
    ['wh-full', 'w-full h-full'],
    ['f-c-c', 'flex justify-center items-center'],
    ['flex-col', 'flex flex-col'],
    ['text-ellipsis', 'truncate'],
    [
      'icon-btn',
      'text-16 inline-block cursor-pointer select-none opacity-75 transition duration-200 ease-in-out hover:opacity-100 hover:text-primary !outline-none'
    ]
  ],
  rules: [
    [/^bc-(.+)$/, ([, color]) => ({ 'border-color': `#${color}` })],
    ['card-shadow', { 'box-shadow': '0 1px 2px -2px #00000029, 0 3px 6px #0000001f, 0 5px 12px 4px #00000017' }]
  ],
  theme: {
    colors: {
      primary: 'var(--primary-color)',
      dark_bg: 'var(--dark-bg)'
    }
  }
})
```
3. webpack5配置新增：
```js
   // 引入
   const UnoCSS = require('@unocss/webpack').default
  // 增加UnoCSS插件调用
  plugins.unshift(UnoCSS())
  // optimization增加这个属性
  realContentHash: true
```

4. main.js中新增css文件引入
```js
import 'uno.css'
``` 
5. <mark style="background: #FF5582A6;">倒在了html文件没有经过webpack打包中</mark>
6. #TODO 需要研究angularjs模板打包，才能引入unocss库，帮助前端写css
7. #TODO 研究webpack5打包机制 [配置 | webpack 中文文档](https://webpack.docschina.org/configuration/#use-different-configuration-file)
## 1.5. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
[Getting Started | Windi CSS](https://windicss.org/guide/)
[UnoCSS: The instant on-demand Atomic CSS engine](https://unocss.dev/)
[Tailwind CSS - Rapidly build modern websites without ever leaving your HTML.](https://tailwindcss.com/)
