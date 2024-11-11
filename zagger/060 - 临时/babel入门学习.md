---
alias:
tags: 长青笔记
cdate: 2024-01-11 14:56
uid: 20240111145621
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. babel入门学习

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2024-01-11 星期四 14:56:20

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

### 1.4.1. 前言

从我开始接触前端工程化到现在工作一年多，`babel`这个词就时不时出现在各种代码里，但是见到了并不意味着就知道了，尤其是各种`babel`的包结合起来配置，头都晕了，所以这次写个文章加深下自己的印象。

### 1.4.2. 官方文档

[Babel · The compiler for next generation JavaScript​babeljs.io/![](https://pic1.zhimg.com/v2-f2814440b9cc3721601ebe80a4776a18_ipico.jpg)](https://babeljs.io/)

### 1.4.3. 简介

![](https://pic2.zhimg.com/80/v2-33a1f57c97c3fea8420a797728bb25e1_720w.webp)

babel

开头直接简洁明了，就是一个`javascript`的解析器。主要就是将不兼容的`ES6`以上的`api`、语法等转换为大部分浏览器都兼容的`es5`。

主要能用于一下地方

1. 语法转换，就是上面说的
2. 帮你兼容一些低版本没有的`api`
3. 源码转换，比如你用的`jsx`，帮你转换为`js`
4. 其它。。。。

### 1.4.4. 配置

说的再多也不如直接实战

我们先创建一个文件夹和一个`index.js`文件，然后初始下环境

```bash
mkdir babel-study
cd babel-study
echo > indexjs
npm init --yes
```

然后在我们的`index.js`文件中随便写点`es6`的东西，比如箭头函数或者`Array.reduce`之类的`api`。

```js
const res = [[0, 1, 2].reduce((prev, current) => prev + current, 0)];
console.log(...res);
```

然后在终端安装`babel`的核心包`@babel/core、@babel/preset-env`以及能让这两个包跑起来的命令工具`@babel/cli`

```bash
npm install @babel/core @babel/cil @babel/preset-env -D
```

安装完包之后直接执行运行命令

```bash
./node_modules/.bin/babel index.js --out-dir lib
```

然而你发现`lib`目录下生成的`index.js`里的代码依旧没改变，还是`es6`的东西，为什么没有转换呢？因为我们并没有做配置，命令读不到配置自然就按原来的输出了。

在介绍通过配置文件配置之前，我们先来看下通过参数传入，我们先安装`@babel/plugin-transform-arrow-functions` ,这个包一看就知道是用来转换箭头函数的。

```bash
npm install @babel/plugin-transform-arrow-functions -D
```

那么我们要怎么用这个`plugin`呢？`@babel/cli`中提供了`--plugins`的`option`

```bash
 ./node_modules/.bin/babel index.js --out-dir lib --plugins=@babel/plugin-transform-arrow-functions
```

![](https://pic2.zhimg.com/80/v2-cb40df8d37bb8ca524424a1c473cb749_720w.webp)

plugin-transform-arrow-functions

这里就转换完成了。但每次这样传参就麻烦，所以官方又提供了一种方式，通过配置文件。

让我们来创建一个`babel.config.js`的配置文件，当然建议用`.json`(>=7.8.0)的，`js`是旧版中的。

```js
module.exports = {
  plugins: ['@babel/plugin-transform-arrow-functions']
}
```

![](https://pic4.zhimg.com/80/v2-d616cb316dd28b2b932125aad55d22cf_720w.webp)

箭头函数正常转换了。但你应该注意到了`reduce`方法和`...`解构都没有转换为`es5`。

让我们改下配置

```js
module.exports = {
  presets: [
    [ "@babel/preset-env" ],
  ],
};
```

我们再重新跑一下指令。

```bash
 ./node_modules/.bin/babel index.js --out-dir lib  
```

![](https://pic1.zhimg.com/80/v2-a89eaeb667410b4fe7a182f3a17f00d0_720w.webp)

build-result

箭头函数是转换了，`...`结构也通过`apply`的方式转换了，但是这个`reduce`并没有变。

在低版本是可以引入`@babel/polyfill`处理的，但是在`7.4.0`之后就废弃迁移到`core-js`[[1]](#ref_1)包中了。

另外为什么没有自动转换呢？因为现在默认是不需要的，需要我们做其他配置。

首先，我们先安装下`core-js`，这个包中的代码都是参与打包的，所以不能放`dev`中。

```bash
npm install core-js --save
```

然后我们改下`babel.config.js`文件中的配置

```js
 module.exports = {
  presets: [
    [
      "@babel/preset-env",
      {
      useBuiltIns: "usage",
      corejs: "3.25.5",
      },
    ],
  ],
};
```

- `useBuiltIns`[[2]](#ref_2): 默认是`false`，不使用任何的`polyfill`。不为`false`的时候会直接从`core-js`中引入`polyfill`,其他无相关的将不会被引入。 其中`usage` 会分析每一个`module`中需要引入的`polyfill`然后自动引入，是按需加载，同时代码是放在`module`内部的，不会污染全局，但当所有的`module`合并后自然会出现很多重复的导入（指编译后的代码，不影响实际效果，因为同一个`polyfill`只会被导入一次）。而`entry`需要开发者自己去全局入口引入`core-js`，这样全局就只有一份`polyfill`，但这份`polyfill`是全量的，会污染全局，不过你会有重复的导入问题。怎么用还是得看具体的场景，并不是说`usage`就会比较好。
- `corejs`: 你安装的`core-js`包版本,其中有`2`和`3`的版本，其中`2`的版本比`3`少了一些实例自身的属性。

另外，我们并不需要补充`regenarator-runtime`这个包，因为这个包如果没有配置会自动给我们加上。

让我们重新跑下指令

![](https://pic1.zhimg.com/80/v2-ca32b5374c250e542cb49f0dbd689794_720w.webp)

result

这下就正常转换了。并且只引入了我们需要的。

我们来看下`useBuiltIns`的`usage`和`entry`的不同。

**`usage`**

首先新建`src`文件夹，然后新增`a.js、b.js、c.js`以及`index.js`四个文件，其中`abc`三个文件导出方法除了名字其它都相同，`index.js`导入这三个文件导出的方法。

`a\b\c.js`

```js
function a () {
    const res = [1, 2, 3].reduce((prev, current) => (prev + current), 0);
    console.log(res)
}

module.exports = {
    a
} 
```

`index.js`

```js
const { a } = require('./a.js')
const { b } = require('./b.js')
const { c } = require('./c.js')

a();
b();
c(); 
```

然后改下我们`package.json`中`build`的指令

```js
    "build": "babel src --out-file build.js" 
```

然后终端直接执行`npm run build`

```js
"use strict";

require("core-js/modules/es.array.reduce.js");
require("core-js/modules/es.object.to-string.js");
function a() {
  var res = [1, 2, 3].reduce(function (prev, current) {
    return prev + current;
  }, 0);
  console.log(res);
}
module.exports = {
  a: a
};
"use strict";

require("core-js/modules/es.array.reduce.js");
require("core-js/modules/es.object.to-string.js");
function b() {
  var res = [1, 2, 3].reduce(function (prev, current) {
    return prev + current;
  }, 0);
  console.log(res);
}
module.exports = {
  b: b
};
"use strict";

require("core-js/modules/es.array.reduce.js");
require("core-js/modules/es.object.to-string.js");
function c() {
  var res = [1, 2, 3].reduce(function (prev, current) {
    return prev + current;
  }, 0);
  console.log(res);
}
module.exports = {
  c: c
};
"use strict";

var _require = require('./a.js'),
  a = _require.a;
var _require2 = require('./b.js'),
  b = _require2.b;
var _require3 = require('./c.js'),
  c = _require3.c;
a();
b();
c(); 
```

可以看到编译后的文件中两个`polyfill`被重复引用。

**`entry`**

首先将`babel.config.js`中的`useBuildIns`改为`entry`,然后在我们的`index.js`中将`core-js`包导入，然后重新执行我们的`npm run build`指令。

![](https://pic4.zhimg.com/80/v2-f63d2a685e0f45598c7b1c7af3fea7f3_720w.webp)

entry-result

可以看到所有的`polyfill`都被引入了。

这里越过了`@babel/polyfill`这个包的使用，因为目前已经是不推荐了，但如果你接手了一个老项目，那还是得看一下的，这里放下官网链接

[https://babeljs.io/docs/en/usage#polyfill​babeljs.io/docs/en/usage#polyfill](https://babeljs.io/docs/en/usage#polyfill)

---

### 1.4.5. 关于配置文件

配置文件支持多种

1. `babel.onfig.js/json`这两种都是一样的，推荐`json`格式，上边已经介绍过了这种方式，就不多说了。作用范围是整个项目。
2. `.babelrc.json` ，作用范围局部，当前文件夹下，执行转换时会先往上找最近的一个`.babelrc.json`文件直到根目录，然后将这个`.babelrc.json`和全局的合并之后再获取配置信息。用法如下：

```json
{
  "presets": [...],
  "plugins": [...]
} 
```

3. 嫌麻烦，可以直接将配置信息写到`package.json`文件中。

```json
{
  "name": "my-package",
  "version": "1.0.0",
  "babel": {
    "presets": [ ... ],
    "plugins": [ ... ],
  }
}
```

---

### 1.4.6. 一些常用的配置

已经被内置了的就不说了。

1. `@babel/preset-react`[[3]](#ref_3),看名字就知道是用于`react`的配置,我们先安装

```bash
npm install @babel/preset-react -D 
```

然后将这个配置加到`babel.config.js`文件中

```js
module.exports = {
  presets: [
    [
      "@babel/preset-env",
      {
      useBuiltIns: "entry",
      corejs: "3.25.5",
      },
    ],
    ["@babel/preset-react"]
  ],
};
```

接着创建`react`的文件夹，新建`index.jsx`,随便写点`react`的代码

```js
import { ReactDOM } from 'React'

function test () {
    const className = 'test'
    const text = '666'
    return (
        <div className={className}>{ text }</div>
    )
}

ReactDOM.render(test(), document.body) 
```

然后`package.json`中新增`script`

```text
    "build-react": "babel react --out-dir lib" 
```

然后直接执行指令`npm run build-react`

![](https://pic1.zhimg.com/80/v2-4cedfeefce19900cb7fe2e3fa8570428_720w.webp)

preset-react-result

2. `@babel/preset-typescript`[[4]](#ref_4),看名字也知道这是个用来识别转换`typescript`的配置

```text
npm install @babel/preset-typescript -D
```

然后新增一个`ts`的文件夹，创建一个`index.ts`，随便搞点东西

```js
 interface Test {
    (name: string | undefined): string | undefined
}

const test: Test = (name) => name;
```

接着在`package.json`中新增指令，需要注意`ts`文件需要提供`extensions`的`option`

```text
    "build-ts": "babel ts --out-dir typescript --extensions .ts" 
```

最后在`babel.config.js`中新增一个预设

```js
    [
      "@babel/preset-typescript",
    ]
```

然后运行指令`npm run build-ts`

![](https://pic2.zhimg.com/80/v2-e55e8de12c8f33a0aba30b7d8ec72cdd_720w.webp)

preset-typescript result

---

### 1.4.7. 实现一个babel插件

如果大家用过`webpack`的插件，应该能发现都有同一个格式，需要定义`class.apply`才能被调用。

而`babel`也有自己的格式。

我们先创建一个`plugins`文件夹,新建`log.js`文件

```js
module.exports = function() {
  return {
    visitor: {
      Identifier(path) {
        const name = path.node.name;
        if (name === 'res') {
          console.log(path.node)
        }
      },
    },
  };
}
```

当找到`name`是`res`的变量时，打印这个节点。

然后我们将它引入到`babel.config.js`中。

```js
module.exports = {
  presets: [
    [
      "@babel/preset-env",
      {
        useBuiltIns: 'usage',
        corejs: '3.25.5'
      }
    ],
    [
      "@babel/preset-typescript",
      {
        allExtensions: true
      }
    ]
  ],
  plugins: [require('./plugins/log')]
}
 
```

然后我们执行`npm run build`，目标既是我们的`index.js`文件

![](https://pic4.zhimg.com/80/v2-6f7b3636e1a4c62a409eb2d05ad4a24f_720w.webp)

log-res

这里面标记了行列的位置，注释，起始结束位置等。

![](https://pic3.zhimg.com/80/v2-edd2741b3c1bbc99aba91be205d363c6_720w.webp)

res

正好就是第一行第六列到第九列。

通过这个例子可以看出这个格式

```js
module.exports = function() {
  return {
    visitor: {
      // 监听对象，不一定是`identifier`
      Identifier(args) {
         //...
      },
    },
  };
}
```

这里就只展示这一个小`demo`，实际上一个`plugin`能做的事情很多，可以监听的东西也很多。因为传入`visitor`中的是被`core`编译转换后的`ast`(抽象语法树)

---

### 1.4.8. @babel/cli

你是否觉得这个指令的执行者`./node_modules/.bin/babel`很奇怪？实际上`node_modules/.bin`中存放的是所有第三方包里的命令执行文件入口，如果这个包配合`commander`和全局安装，就能做到类似`npm`这样的全局命令执行工具。可以看下我之前的文章。

[坏蛋Dan：基于Commander实现自定义的命令行指令0 赞同 · 0 评论文章![](https://pic3.zhimg.com/v2-b4121e06bdd80c3e2eca2c73f1fa4456_ipico.jpg)](https://zhuanlan.zhihu.com/p/569233377)

而这个`.bin`中的命令来源是包自身带有的`bin`文件夹中的，比如这个`@babel/cli`中的`bin`文件夹。

![](https://pic4.zhimg.com/80/v2-2918224eb4220cf669d70204fcd86d9b_720w.webp)

bin

要怎么分辨呢？直接去看`package.json`中如何配置的即可。

![](https://pic1.zhimg.com/80/v2-9f981fa05b8e32a4ad3a3005f75f0210_720w.webp)

package.json

如果你嫌弃`./node_modules...`这种执行太冗长，你可以在`package.json`中新增一个`script`

```text
     "build": "babel index.js --out-dir lib"
```

为什么这样会生效呢？因为`@bael/cli`这个包配置了这个`npm`指令即上面提到的`package.json`文件中的`bin.babel`。

我们跟着进入`babel.js`中，发现是导入`cli/lib/babel`这个包，入口自然是`index.js`文件

```js
 #!/usr/bin/env node
"use strict";

var _options = require("./options");
var _dir = require("./dir");
var _file = require("./file");
const opts = (0, _options.default)(process.argv);
if (opts) {
  const fn = opts.cliOptions.outDir ? _dir.default : _file.default;
  fn(opts).catch(err => {
    console.error(err);
    process.exitCode = 1;
  });
} else {
  process.exitCode = 2;
}
```

这段代码很简单，就是将命令行带上的参数传入`options.js`中，转换后判断是否有配置`--out-dir`，如果有则按照传入的来，否则使用默认输出路径。

简单的说下`options.js`中做了什么。 就不看代码了，毕竟这不是源码分析。。。

其实这里面也用了`commander`，装载了一堆的`option`，唯独没有配置指令的名字。。。

抛去`commander`的配置，还剩`200`多行代码。

主要做了以下几件事。

1. 获取命令行中传入的参数
2. 判断参数是否符合要求，不符合报错`return`
3. 以对象的格式返回转换后的参数

然后参数传入`dir.js`中。

这个文件中代码写的很绕，一个套一个的，最终找到的`compile`方法居然在`utils`里。。。。

这里面主要做了以下的俩件事

1. 读文件，没有读怎么写呢，是吧？doge
2. 遍历读到的符合要求的文件（比如非`ignore`的文件），调用`compile`方法，引入`core`包，将这些文件里的源码转换成我们想要的兼容低版本的代码。

---

### 1.4.9. @babel/preset-env

这个包相信大家也差不多猜到了，在学的过程中需要通过它来做兼容判断。

先来看下官方对它的描述[[5]](#ref_5)

![](https://pic1.zhimg.com/80/v2-f4dcb0200b31ba4c7033372620ab3a08_720w.webp)

preset-env introduce

简单的说就是可以帮你自动去做兼容等，不需要你去做额外的处理比如引入插件等。当然，有些东西需要额外配置才能生效，比如`polyfill`，需要配置`useBuiltIns`以及`corejs`。

同样不分析源码，简单的说先是判断当前环境，比如`node`，然后通过`options`判断加载不同`plugin`。

来看下常用的`option`

- `targets`: [[6]](#ref_6) 你希望支持的哪些浏览器的哪些版本，会根据你的配置，往你的`bundle`中加点兼容性东西，让你的代码可以正常运行在你想要的浏览器中。 当然，如果你配置了`browserlist`,也会根据`browserlist`的来做判断。默认不配置，会根据默认情况执行，尽量帮你兼容所有浏览器的低版本。
- `include`:[[7]](#ref_7) 和下面的`exclude`同类型的作用，用于让某些`plugin`一定会被调用。
- `exclude`:[[8]](#ref_8) 让某些`plugin`一定不会被调用。
- `useBuiltIns`:[[9]](#ref_9) 用来处理`polyfill`的，默认`false`不加载`polyfill`。其它不多说了，`配置` 这一块里有对`usage`和`entry`的分析。
- `corejs`:[[10]](#ref_10) 只有配置了`useBuiltIns: usage/entry`这个字段才会生效。默认是版本`2`，`2`不可以传入具体的版本 ，`3`则可以。用于加载`core-js`的包，而`core-js`需要自行安装并确保包版本和你这配置里的是一致的（指的是`core-js2`只能配置`2`，不能配置`3`，`core-js3`同样道理）。
- `browserlistEnv`:[[11]](#ref_11) 基于`browserlist`的配置。

---

### 1.4.10. @babel/core[12]

看名字就知道这个包的重要性，是用来处理源码转换代码的核心包。

我们直接来实战

我们先创建一个`transform`的文件夹，新建`index.js`文件。

```bash
mkdir transform
cd transform
echo > index.js 
```

然后我们在`index.js`中将`@babel/core`包中的`transform`方法导入。

```js
const { transform } = require('@babel/core');

const test = `
  const a = name => name;
`

transform(test, {}, (...args) => {
  console.log(args)
}) 
```

我们执行下这个文件`node transform/index.js`

![](https://pic2.zhimg.com/80/v2-cd12d3c5b86db8cabe0265a206b79fcd_720w.webp)

transform-result

可以看到我们的箭头函数确实被转换成`function`的形式了。

这里依旧不会去分析源码，只需要知道这里面有一个解析器`@babel/parser`[[13]](#ref_13)，将代码转换成`object`，经过`@babel/traverse`加工处理后，再调用`@babel/generator`[[14]](#ref_14)从`object`转换为最终的代码。

---

### 1.4.11. @babel/parser[15]

上面说到了，将你的代码"字符串·"转换成抽象语法树（`AST`）,至于怎么转的，这里就不说了，因为这块逻辑是很复杂的，简单的说就是将你的`code`进行遍历，将每个字符都过一遍，当然这不是简单的遍历。它里面内置了几十个`javscript`特殊字段（比如`const、let、var`这些，尤其是空格），根据这些字段，将“不稳定”的状态 转变为稳定状态（比如你定义一个变量，最开始是不确定你这个是不是变量的，但是遍历过前后之后再配上这些特殊字段判断就能确定了）,最终将你的`code string`变成一颗”树“`object`。`AST`的应用是非常非常常见的，比如你的`vue`的虚拟`dom`就是一种`AST`,还有你现在正在用的`IDE`,都是基于`AST`的。

我们来调用下这个包

```js
const parser = require('@babel/parser')


const test = `
  const a = name => name;
`
const parseResult = parser.parse(test);

console.log(parseResult)
```

![](https://pic2.zhimg.com/80/v2-cd97647a14b2f93ecbf105a0f16c6f71_720w.webp)

parse-result

又或者你可以将上面`@babel/core`中的`transform`传入的参数第二个插入一个`options`,里面传入`ast: true`，也是一样的。

```js
const { transform } = require('@babel/core');

const test = `
  const a = name => name;
`

transform(test, {
  ast: true
}, (...args) => {
  console.log(args)
})
 
```

![](https://pic1.zhimg.com/80/v2-89310eae118321e4788e09f6522c9d50_720w.webp)

transform-options-ast-true

---

### 1.4.12. @babel/generator[16]

这个`core`包中也提到了，主要是将你的`ast`转换为`string`。当然，这里拿到的`ast`不是原版从`parser`中拿到的`ast`，是经过`@babel/traverse`执行各种`plugin`加工过后的。

我们直接来调用下这个包

```js
const { transform } = require('@babel/core');

const parser = require('@babel/parser')

const generator = require('@babel/generator')

const test = `
  const a = name => name;
`

transform(test, {
  ast: true
}, (...args) => {
  // console.log(args)
})

const parseResult = parser.parse(test);

// console.log(parseResult)

const generateResult = generator.default(parseResult)
console.log(generateResult)
```

![](https://pic3.zhimg.com/80/v2-3fd26458a494447e32d098c54ed43c42_720w.webp)

generate-result-without-options

这里的`code`里的箭头函数居然没有转换成`function`的形式，这是为什么呢？因为我们没有配置。。。。。之前`@babel/core`能正常转换是因为里面做了读取配置的处理，而`generate/parser`都是功能单一的包，不可能会做读取的处理。 这也符合官方的描述 --“默认不处理代码，处理都交由插件“。那么要怎么变成我们想要的呢？

你应该注意到了`generator`处理的是`ast`，所以如果我们改动`ast`的话到时它输出也就是我们改动了的，官方包里也是这么做的。

而改动我们需要用到另一个包`@babel/traverse`来帮助我们将箭头函数变为`function`的形式。

---

### 1.4.13. @babel/traverse[17]

这个包是用来更新`ast`的。

接着我们上面的代码

```js
const { transform } = require('@babel/core');

const parser = require('@babel/parser')

const generator = require('@babel/generator')

const traverse = require('@babel/traverse')

const test = `
  const a = name => name;
`

transform(test, {
  ast: true
}, (...args) => {
  // console.log(args[1].ast)
})

const parseResult = parser.parse(test);

traverse.default(parseResult, {
  ArrowFunctionExpression (path) {
    path.arrowFunctionToExpression({
      allowInsertArrow: false,
      noNewArrows: true,
      specCompliant: false
    });
  }
})


const generateResult = generator.default(parseResult, {
  jsescOption: {
    es6: false
  }
})
console.log(generateResult)
```

然后终端执行下`node transform/index.js`

![](https://pic3.zhimg.com/80/v2-2934b403c0d7a500b49bf50197e00ff2_720w.webp)

arrow-to-function

转换成功！

---

### 1.4.14. @babel/types[18]

提供了`babel`内置的类型，比如上面提到过的`Identifier`和`ArrowFunctionExpression`。

这里就不多说了，感兴趣的大佬可自行点下【18】去官网看下。

---

### 1.4.15. @babel/template

看名字就知道是和模板有关的。

我们简单的搞下即可，因为重要的包前面几个已经讲完。

官方提供了两种替换变量的方式

1. `%%xxx%%` 的方式
2. `XXX`的方式

```js
const template = require('@babel/template');
const getTemplate = template.default(`console.log(TEST)`)


const ast = getTemplate({
  TEST: '666'
})

console.log(ast)
```

![](https://pic2.zhimg.com/80/v2-0057481e1f539b85d222bda71df6013d_720w.webp)

template-result

`template`方法会返回一个`function`

---

### 1.4.16. @babel/runtime

还记得上面提到过的`polyfill`和配置不？是通过注入代码参与打包来实现转换的，而这些一般叫做`runtime`。

`babel`也是需要注入一些`runtime`来帮助代码进行兼容的。

我们先在`transform`文件夹中创建一个文件`test-runtime.js`

```js
async function test () {
  await console.log(123);
  return 666
}
```

然后`package.json`新增`script`

```js
    "build-runtime": "babel transform/test-runtime.js --out-file transform/buildRuntime.js" 
```

接着`npm run build-runtime`

输出的`buildRuntime.js`中多了一堆意义不明的玩意儿。

![](https://pic1.zhimg.com/80/v2-b38721b2ff0fbed479982ab9f37cc404_720w.webp)

build-runtime

而这些东西就是`async await`的辅助函数。

让我们在创建一个`test-runtime2.js`，然后让这个文件也参与编译

![](https://pic1.zhimg.com/80/v2-752473a9cf43f8502deec957468a9500_720w.webp)

build-runtime-2

发现这些辅助函数每次都会被引入，这也就意味着存在大量的重复代码。

为了处理这个问题，官方就将这些个`runtime`都抽出来放到了这个`@babel/runtime`包中。

那么要这么做才能处理掉这些重复代码呢？

我们直接在入口引入对应的包即可。

```js
var _asyncToGenerator = require('@babel/runtime/helpers/asyncToGenerator')
var _regeneratorRuntime = require('@babel/runtime/helpers/regeneratorRuntime')
// ...
```

但这样每次都得手动去引入，很麻烦。有没有办法能做到和`core-js`一样自动引入？

有的，官方又提供了一个包`@babel/plugin-transform-runtime`，这个包能自动引入。

[https://babeljs.io/docs/en/v7-migration#babelruntime-babelplugin-transform-runtime​babeljs.io/docs/en/v7-migration#babelruntime-babelplugin-transform-runtime![](https://pic1.zhimg.com/v2-f2814440b9cc3721601ebe80a4776a18_ipico.jpg)](https://babeljs.io/docs/en/v7-migration#babelruntime-babelplugin-transform-runtime)

我们先安装

```js
npm install @babel/plugin-transform-runtime -D
```

然后在我们的`babel.config.js`中配置下

```js
 module.exports = {
  presets: [
    [
      "@babel/preset-env",
      {
        useBuiltIns: 'usage',
        corejs: '3.25.5'
      }
    ],
    [
      "@babel/preset-typescript",
      {
        allExtensions: true
      }
    ]
  ],
  plugins: [require('./plugins/log'), "@babel/plugin-transform-runtime"]
}
```

![](https://pic1.zhimg.com/80/v2-8e3b0743bcd45c573fddd7f58381e63c_720w.webp)

build-runtime3

这回就自动引入啦

---

### 1.4.17. @babel/code-frame[19]

这个包提供了自定义行列位置的`log`,就不多说了，感兴趣的大佬可以点击【19】看下。

随便搞下。

```js
const { codeFrameColumns } = require('@babel/code-frame')

const rawLines = `class Foo {
  constructor() {
    console.log("hello");
  }
}`;
const location = { start: { line: 2, column: 16 } };

const result = codeFrameColumns(rawLines, location, {
  /* options */
});

console.log(result);
```

![](https://pic2.zhimg.com/80/v2-7ae9ac9cdacb9a9d155d0468fe299199_720w.webp)

code-frame

---

那么`babel`的基础就学完了，如果觉得对你有用麻烦点个赞~谢谢！

## 1.5. 参考

1. [^](#ref_1_0)core-js [https://www.npmjs.com/package/core-js](https://www.npmjs.com/package/core-js)
2. [^](#ref_2_0)useBuiltIns [https://babeljs.io/docs/en/babel-preset-env#usebuiltins](https://babeljs.io/docs/en/babel-preset-env#usebuiltins)
3. [^](#ref_3_0)@babel/preset-react [https://babeljs.io/docs/en/babel-preset-react](https://babeljs.io/docs/en/babel-preset-react)
4. [^](#ref_4_0)@babel/preset-typescript [https://babeljs.io/docs/en/babel-preset-typescript](https://babeljs.io/docs/en/babel-preset-typescript)
5. [^](#ref_5_0)preset-env [https://babeljs.io/docs/en/babel-preset-env](https://babeljs.io/docs/en/babel-preset-env)
6. [^](#ref_6_0)@babel/preset-env_targets [https://babeljs.io/docs/en/babel-preset-env#targets](https://babeljs.io/docs/en/babel-preset-env#targets)
7. [^](#ref_7_0)@babel/preset-env_include [https://babeljs.io/docs/en/babel-preset-env#include](https://babeljs.io/docs/en/babel-preset-env#include)
8. [^](#ref_8_0)@babel/preset-env_exclude [https://babeljs.io/docs/en/babel-preset-env#exclude](https://babeljs.io/docs/en/babel-preset-env#exclude)
9. [^](#ref_9_0)useBuiltIns [https://babeljs.io/docs/en/babel-preset-env#usebuiltins](https://babeljs.io/docs/en/babel-preset-env#usebuiltins)
10. [^](#ref_10_0)@babel/preset-env_corejs [https://babeljs.io/docs/en/babel-preset-env#corejs](https://babeljs.io/docs/en/babel-preset-env#corejs)
11. [^](#ref_11_0)browserlistEnv [https://babeljs.io/docs/en/babel-preset-env#browserslistenv](https://babeljs.io/docs/en/babel-preset-env#browserslistenv)
12. [^](#ref_12_0)@babel/core [https://babeljs.io/docs/en/babel-core](https://babeljs.io/docs/en/babel-core)
13. [^](#ref_13_0)@babel/parser [https://babeljs.io/docs/en/babel-parser](https://babeljs.io/docs/en/babel-parser)
14. [^](#ref_14_0)@babel/generator [https://babeljs.io/docs/en/babel-generator](https://babeljs.io/docs/en/babel-generator)
15. [^](#ref_15_0)@babel/parser [https://babeljs.io/docs/en/babel-parser](https://babeljs.io/docs/en/babel-parser)
16. [^](#ref_16_0)@babel/generator [https://babeljs.io/docs/en/babel-generator](https://babeljs.io/docs/en/babel-generator)
17. [^](#ref_17_0)@babel/traverse [https://babeljs.io/docs/en/babel-traverse](https://babeljs.io/docs/en/babel-traverse)
18. [^](#ref_18_0)@babel/types [https://babeljs.io/docs/en/babel-types](https://babeljs.io/docs/en/babel-types)
19. [^](#ref_19_0)@babel/code-frame [https://babeljs.io/docs/en/babel-code-frame](https://babeljs.io/docs/en/babel-code-frame)
# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
