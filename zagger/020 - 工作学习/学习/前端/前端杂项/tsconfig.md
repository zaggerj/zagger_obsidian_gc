---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
文章首发公众号→[程序员王天](https://link.juejin.cn?target=https%3A%2F%2Flink.zhihu.com%2F%3Ftarget%3Dhttps%253A%2F%2Fimg-cdn.dslcv.com%2Fwt_gzh.png "https://link.zhihu.com/?target=https%3A//img-cdn.dslcv.com/wt_gzh.png")←欢迎关注

# tsconfig.json

`tsconfig.json` 是ts项目中配置文件。在项目根目录，如果项目中有 `tsconfig.json`, `TypeScript`  则认为这是项目的根目录。

如果项目源码是 `JavaScript`，但是相用 `typescript` 处理，那配置文件的名字是`jsconfig.json` ,和 `tsconfig` 的写法一样。

## 指定 tsconfig.json 目录

命令行参数--project或-p可以指定tsconfig.json的位置（目录或文件皆可）。

如果不指定 `tsconfig.json`, `tsc` 会在当前目录搜索 `tsconfig.json` 文件，如果不存在，就到上一级目录搜索，直到找到为止。

`tsconfig.json` 文件格式，是一个 JSON 对象，简单到只可以放一个空对象 `{}`, 示例如下：

`` json  复制代码  `{     "compilerOptions":{         "outDir":"./built",         "allowJs":true,         "target":"es5"     },     "include":["./src/**/*"] }` ``

`tsconfig.json` 文件中有很多属性，这样简单说下上面四个属性的含义

- `outDir` 指定编译文件存放的目录
- `allowJs` 指定源目录的 `JavaScript` 文件是否原样拷贝到编译后的目录
- `target` 指定编译产物的js版本
- `include` 指定那些文件需要编译

`tsconfig.json` 文件可以不必手写，使用 tsc 命令的 `--init` 参数自动生成

`` csharp  复制代码  `tsc --init` ``

# tsconfig 一级属性

tsconfig.json的一级属性并不多，只有很少几个，但是compilerOptions属性有很多二级属性。

先介绍下一级属性

## 1、include

`include` 属性指定所要编译的文件列表，既支持逐一列出文件，也支持通配符。文件位置相对于当前配置文件而定。

`` json  复制代码  `{   "include": ["src/**/*", "tests/**/*"] }` ``

include属性支持三种通配符。

- ?：指代单个字符
- *：指代任意字符，不含路径分隔符
- **：指定任意目录层级。

如果不指定文件后缀名，默认包括.ts、.tsx和.d.ts文件。如果打开了allowJs，那么还包括.js和.jsx。

## 2、exclude

`exclude` 属性是一个数组，必须与 `include` 属性一起使用，用来从编译列表中去除指定的文件，同样支持和 `include` 属性相同的通配符。

`` json  复制代码  `{     "include":["**/*"], // 指定那些文件需要编译     "exclude":["**/*.spec.ts"] // 从编译列表中去除指定文件 }` ``

## 3、extends

如果一个项目有多个配置文件，可以将共同的配置写在 `tsconfig.base.json` `tsconfig.json` 可以继承另一个 `tsconfig.json` 文件的配置,这样方便维护。

`` json  复制代码  `{     "extends":"../tsconfig.base.json" }` ``

如果 `extends` 属性指定的路径如不是以`./` 或者 `../`开头，那么编译器将在`node_modules` 目录下查找指定的配置文件。

`extends` 属性也可也继承已发布的npm模块里面的tsconfig文件

`` perl  复制代码  `{     "extends":"@tsconfig/node12/tsconfig.json" }` ``

`extends` 指定的 `tsconfig.json` 会先加载，然后加载当前的 `tsconfig.json` 。如果两者有重名的属性，后者会覆盖前者。

## 4、files

`files` 属性指定编译的文件列表，如果其中一个文件不存在，就会报错。 它是一个数组，排在前面的文件先编译。

`` json  复制代码  `{     "files":["a.ts","b.ts"] }` ``

该属性必须逐一列出文件，不支持文件匹配，如果文件比较多建议使用 `include` 和 `exclude` 属性。

## 5、references

`references` 属性是一个数组，数组成员为对象，适合一个大项目由多个小项目构成的情况，用来设置需要引用的底层项目。

`` json  复制代码      `{         "references":[             {"path":"../pkg1"},             {"path":"../pkg2/tsconfig.json"}         ]     }` ``