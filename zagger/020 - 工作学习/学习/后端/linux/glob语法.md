---
created: 2023-11-03T22:29
updated: 2023-11-16 14:31:20
---
# 1. glob

## 1.1. 参考文档
1. [node：glob语法以及常用的文件查找库glob、fast-glob、globby_Lvan的前端笔记的博客-CSDN博客](https://blog.csdn.net/weixin_43972437/article/details/132926908)
2. [通配符（？，*）与正则表达式_正则? *-CSDN博客](https://blog.csdn.net/yh13572438258/article/details/121545229)
## 1.2. glob语法
1. 基本语法
```shell
*	匹配任意长度任意字符
**	代表0或多个层级的目录
?	匹配任意单个字符
[list]	匹配指定范围内（list）任意单个字符，也可以是单个字符组成的集合
[^list]	匹配指定范围外的任意单个字符或字符集合
[!list]	同[^list]
{str1,str2,...}	匹配 srt1 或者 srt2 或者更多字符串，也可以是集合
() 小括号必须跟在 ?、*、+、@、! 后面使用，且小括号里面的内容是一组以 | 分隔符的模式集合，例如：abc|a?c|ac*。
```
2. 专用字符集
```shell
[:alnum:] 任意数字或者字母
[:alpha:] 任意字母
[:space:] 空格
[:lower:] 小写字母
[:digit:] 任意数字
[:upper:] 任意大写字母
[:cntrl:] 控制符
[:graph:] 图形
[:print:] 可打印字符
[:punct:] 标点符号
[:xdigit:] 十六进制数
[:blank:] 空白字符（未验证）
```
3. 举例
- `src/*.js` 表示 src 目录下所有以 js 结尾的文件，但是不能匹配 src 子目录中的文件，例如 src/login/login.js
- `test/?at.js` 匹配形如 test/cat.js、test/bat.js 等所有3个字符且后两位是 at 的 js 文件，但是不能匹配 test/flat.js
- `test/[bc]at.js` 只能匹配test/bat.js 和 test/cat.js
- `test/[c-f]at.js` 能匹配 test/cat.js、test/dat.js、test/eat.js 和test/fat.js
- `test/[!bc]at.js`不能匹配 test/bat.js 和 test/cat.js，但是可以匹配 test/fat.js
- `!test/tmp/**` 排除 test/tmp 目录下的所有目录和文件
- `/var/log/**` 匹配 /var/log 目录下所有文件和文件夹，以及文件夹里面所有子文件和子文件夹
- `/var/log/**/*.log` 匹配 /var/log 及其子目录下的所有以 .log 结尾的文件
- `a.{png,jp{,e}g}` 匹配 a.png、a.jpg、a.jpeg
- `{a…c}{1…2}` 匹配 a1 a2 b1 b2 c1 c2
- `?(pattern|pattern|pattern)`：匹配0次或1次给定的模式

node中解析glob语法
1、node-glob
```shell
// 1、安装方式：
yarn add glob -D

// 2、使用方式：
var glob = require("glob")
glob("**/*.js", function (er, files) {
  // files 就是它模糊查找到的文件
})
const jsfiles = await glob('**/*.js', { ignore: 'node_modules/**' })
const images = await glob(['css/*.{png,jpeg}', 'public/*.{png,jpeg}'])
```
2、fast-glob

这是一款比 node-glob 速度更快的 glob 工具库，一些大家所熟知的比如 eslint、vite 等工具都是用了 fast-glob 作为依赖
```shell
// 1、安装：
yarn add fast-glob -D

// 2、使用：
const fg = require('fast-glob');
const entries = await fg(['.editorconfig', '**/index.js'], { dot: true });
```

```shell
fg(patterns, [options])
fg.async(patterns, [options])
fg.glob(patterns, [options])
```
dot 选项：例如，`src/.*` 会匹配文件 src/.ignore 文件，而 `src/*` 则不会匹配该文件，因为 * 不会匹配以 . 字符开头的文件。

可通过在 options 设置 dot: true，让 glob 将 . 视为普通字符。

3、globby

Based on fast-glob but adds a bunch of useful features.

```shell
// 1、安装：
yarn add globby -D

// 2、使用：
import {globby} from 'globby';

const paths = await globby(['*', '!cake']);

console.log(paths);
//=> ['unicorn', 'rainbow']
```

https://github.com/sindresorhus/globby

