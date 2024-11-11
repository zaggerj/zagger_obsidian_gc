---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
# vscode的格式化工具：eslint 、 prettier、editorconfig 和 vetur

### 文章目录

* [eslint——代码检查工具](#eslint\_5)
*  

  * [eslint的作用](#eslint\_6)
  * [eslint的配置](#eslint\_8)
  *  

    * [第一步配置IDE的eslint环境](#IDEeslint\_9)
    * [第二步：配置项目中的eslint](#eslint\_171)
    *  

      * [下载对应的包](#\_172)
      * [Eslint配置文件的形式](#Eslint\_191)
      * [.eslintignore](#eslintignore\_375)
      * [vite集成eslint](#viteeslint\_378)
    * [项目中的.eslintrc和IDE中的settings.json会走哪一个呢](#eslintrcIDEsettingsjson\_398)
    *  

      * [&quot;eslint.enable&quot;: true](#eslintenable\_true\_405)
* [prettier ——统一代码风格](#prettier\_\_423)
*  

  * [prettier 的作用](#prettier\_\_424)
  * [prettier 的使用](#prettier\_\_427)
  *  

    * [Ide配置prettier](#Ideprettier\_428)
    * [git整合prettier](#gitprettier\_440)
* [eslint 和 prettier](#eslint\_\_prettier\_468)
*  

  * [eslint和prettier的区别](#eslintprettier\_469)
  * [eslint和prettier的配置](#eslintprettier\_481)
* [editorconfig——统一代码编辑器编码风格](#editorconfig\_506)
* [Vetur](#Vetur\_547)
* [VScode的prettier配置 和 项目中的eslint的配置出现冲突](#VScodeprettier\_\_eslint\_570)

　　原文链接：<br />[https://zhuanlan.zhihu.com/p/548306020?utm\_id=0](https://zhuanlan.zhihu.com/p/548306020?utm\_id\=0)<br />[https://www.cnblogs.com/jiaoshou/p/12218642.html](https://www.cnblogs.com/jiaoshou/p/12218642.html)<br />[https://zhuanlan.zhihu.com/p/81764012](https://zhuanlan.zhihu.com/p/81764012)

# [eslint](https://so.csdn.net/so/search?q\=eslint&spm\=1001.2101.3001.7020)——代码检查工具

## eslint的作用

　　​`ESLint`​ **主要解决了两类问题，一个是代码质量问题，另一个是代码风格问题。**

## eslint的配置

### 第一步配置IDE的eslint环境

　　ide**进行**eslint**的配置之后才能根据项目中的**eslint**的配置文件（如**​`.eslint.js`​**）进行相应的格式化。**

* ​`插件下载`​<br />![在这里插入图片描述](https://img-blog.csdnimg.cn/7e79fb4878a0435fbafbfbae0fab939a.png) -   编辑器配置eslint

　　配置位置：`settings.json`​

　　​`c 1.eslint.enable：启用/禁用ESLint。默认情况下启用。  2.eslint.debug：启用ESLint的调试模式（与--debug命令行选项相同）。请参阅ESLint输出通道以获取调试输出。此选项对于跟踪ESLint的配置和安装问题非常有用，因为它提供了有关ESLint如何验证文件的详细信息。  3.eslint.lintTask.enable：扩展是否为整个工作区文件夹提供lint任务。  4.eslint.lintTask.options：运行任务时应用的命令行选项，用于对整个工作区执行linting操作（ https://eslint.org/docs/user-guide/command-line-interface ）。指向定制.eslintrc.json文件和定制的示例.eslintignore是：  {   "eslint.lintTask.options": "-c C:/mydirectory/.eslintrc.json --ignore-path C:/mydirectory/.eslintignore ." } 5.eslint.packageManager：控制用于解析ESLint库的包管理器。这只有在全局解析ESLint库时才有影响。有效值为"npm"or "yarn"或"pnpm"。  6.eslint.options：用于配置如何使用ESLint CLI引擎API启动ESLint的选项。默认为空选项包。指向自定义.eslintrc.json文件的示例如下：  {   "eslint.options": { "configFile": "C:/mydirectory/.eslintrc.json" } } 7.eslint.run: 运行linter 的时间，onSave(保存后)或onType(输入时)，默认为onType。  8.eslint.quiet: 忽略警告。  9.eslint.runtime: 使用此设置设置要在其下运行ESLint的节点运行时的路径。  10.eslint.nodePath: 如果无法检测到已安装的ESLint包，请使用此设置，例如 /myGlobalNodePackages/node_modules  11.eslint.probe:应激活ESLint扩展名并尝试验证文件的语言标识符数组。如果对探测语言的验证失败，扩展将显示silent。默认为["javascript", "javascriptreact", "typescript", "typescriptreact", "html", "vue"]  12.eslint.validate: 指定要强制验证的文件的语言标识符数组。这是一个旧的遗留设置，在正常情况下应该不再需要。默认为["javascript", "javascriptreact"]  13.eslint.format.enable: 启用ESLint作为已验证文件的格式化程序。尽管您也可以使用设置editor.formatOnSave在保存时使用格式化程序，但建议使用editor.codeActionsOnSave功能，因为它允许更好的可配置性。  14.eslint.workingDirectories: 指定如何计算ESLint使用的工作目录。ESLint解析相对于工作目录的配置文件（例如eslintrc、.eslintignore），因此正确配置该文件非常重要。如果在终端中执行ESLint需要将终端中的工作目录更改为子文件夹，则通常需要调整此设置。（另请参见CLIEngine options#cwd）。还请记住，.eslintrc*文件是在考虑父目录的情况下解析的，而.eslintignore文件只在当前工作目录中使用。可以使用以下值：  <span data-type="a" data-href="@since 2.0.0">{ &quot;mode&quot;: &quot;location&quot; }</span>: 指示ESLint使用工作区文件夹位置或文件位置（如果没有打开工作区文件夹）作为工作目录。这是默认策略，与ESLint扩展的旧版本（1.9.x版本）中使用的策略相同。 *[{ "mode": "auto" }] (@since 2.0.0): 指示ESLint根据package.json、.eslintignore和.eslintrc*文件的位置推断工作目录。这可能在很多情况下有效，但也可能导致意想不到的结果。 string[] : 要使用的工作目录数组。请考虑以下目录布局： root/ client/   .eslintrc.json   client.js server/   .eslintignore   .eslintrc.json   server.js 然后使用设置：    "eslint.workingDirectories": [ "./client", "./server" ] 将使用服务器目录作为当前eslint工作目录来验证服务器目录中的文件。客户端目录中的文件也是如此。ESLint扩展还会将进程的工作目录更改为提供的目录。如果这不是要一个文字与！可以使用!cwd属性（例如{ "directory: "./client", "!cwd": true }））。这将使用客户端目录作为ESLint工作目录，但不会更改进程的工作目录。  { "pattern": glob pattern }(@since 2.0.0):允许指定检测工作目录的模式。这基本上是列出每个目录的捷径。如果您有一个Mono存储库，并且所有项目都位于packages文件夹下，那么可以使用{ "pattern": "./packages/*/" }使所有这些文件夹都在目录下工作。 15.eslint.codeAction.disableRuleComment: 具有属性的对象：  enable : 在快速修复菜单中显示禁用lint规则。默认情况下为true。 location : 选择在separateLine 或 sameLine上添加eslint disable注释。默认为separateLine。例子： { "enable": true, "location": "sameLine" } 16.eslint.codeAction.showDocumentation: 具有属性的对象：  enable : 在“快速修复”菜单中显示“打开lint规则文档”网页。默认情况下为true。 17.eslint.codeActionsOnSave.mode (@since 2.0.12): 控制在保存时运行代码操作时修复哪些问题  all : 通过重新验证文件内容修复所有可能的问题。这将执行与在终端中使用--fix选项运行eslint相同的代码路径，因此可能需要一些时间。这是默认值。 problems : 仅修复当前已知的可修复问题，只要它们的文本编辑不重叠即可。此模式要快得多，但很可能只能解决部分问题。 18.eslint.format.enable（@since 2.0.0起）:使用ESlint作为由ESlint验证的文件的格式化程序。如果启用，请确保禁用其他格式化程序（如果要将其设为默认值）。一个好的方法是为javascript添加以下设置"[javascript]": { "editor.defaultFormatter": "dbaeumer.vscode-eslint" }。对于TypeScript，您需要添加"[typescript]": { "editor.defaultFormatter": "dbaeumer.vscode-eslint" }。  19.eslint.onIgnoredFiles（@since 2.0.10）:用于控制在尝试清除被忽略的文件时是否应生成警告。默认值为off。可以设置为warn。  20.editor.codeActionsOnSave（@since 2.0.0起）：此设置现在支持条目source.fixAll.eslint。如果设置为true，则来自所有插件的所有可自动修复的ESLint错误都将在保存时修复。您还可以使用VS Code的语言范围设置来有选择地启用和禁用特定语言。要禁用codeActionsOnSaveHTML文件，请使用以下设置：  "[html]": {     "editor.codeActionsOnSave": {       "source.fixAll.eslint": false     }   } 旧eslint.autoFixOnSave设置现已弃用，可以安全地删除。另请注意，如果将ESLint用作默认格式化程序，则应在打开editor.formatOnSave时将其关闭editor.codeActionsOnSave。否则，您的文件将被修复两次，这是不必要的。 123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475 ​`​

* **我的**settings.json

　　​`c {   // 编辑器设置   -----settings begin-----   // 编辑器字体大小   "editor.fontSize": 18,   // 每次保存的时候自动格式化  "editor.formatOnSave": true,  "editor.codeActionsOnSave": {     // 每次保存时将代码按eslint的格式进行保存    "source.fixAll.eslint": true  },   // 编辑器设置    -----settings end-----     // eslint   -----settings begin-----   // 配置如何使用ESLint CLI引擎API启动ESLint的选项  "eslint.options": {    //指定vscode的eslint所处理的文件的后缀    "extensions": [".js", ".vue", ".ts", ".tsx"]  },   //  启用ESLint作为已验证文件的格式化程序   "eslint.format.enable": true,   // 扩展是否为整个工作区文件夹提供lint任务。   "eslint.lintTask.enable": true,   // eslint   -----settings end-----     // 各个文件的配置  -----settings begin-----   "[json]": {     // json文件按prettier格式进行保存     "editor.defaultFormatter": "esbenp.prettier-vscode"   },   "[html]": {     // html文件按prettier格式进行保存     "editor.defaultFormatter": "esbenp.prettier-vscode"   },   "[vue]": {     // vue文件按eslint格式进行保存     "editor.defaultFormatter": "dbaeumer.vscode-eslint"   },   "[typescriptreact]": {     // ts文件按typescript-language-features保存     "editor.defaultFormatter": "vscode.typescript-language-features"   },    // 各个文件的配置  -----settings end-----    // git配置   -----settings begin-----   // git开启智能提交   "git.enableSmartCommit": true,   // git关闭确认同步   "git.confirmSync": false,   // git配置   -----settings end-----    //  vetur   -----settings begin-----   // 使用插件格式化 html   "vetur.format.defaultFormatter.html": "js-beautify-html",   //  vetur   -----settings end-----     "explorer.confirmDragAndDrop": false,   // 空格   "diffEditor.ignoreTrimWhitespace": false,   // 菜单栏的显示方式   "window.menuBarVisibility": "compact",   // 编辑器失去焦点的时候文件保存   "files.autoSave": "onFocusChange", }  12345678910111213141516171819202122232425262728293031323334353637383940414243444546474849505152535455565758596061626364656667 ​`​

* eslint**插件为**vscode**添加的终端命令：**<br />`Create '.eslintrc.json' file`​：创建一个新.eslintrc.json文件。       `Fix all auto-fixable problems`​：将ESLint自动修复解决方案应用于所有可修复的问题。       `Disable ESLint for this Workspace`​：禁用此工作空间的ESLint扩展。       `Enable ESLint for this Workspace`​：为此工作空间启用ESLint扩展。

### 第二步：配置项目中的eslint

#### 下载对应的包

* **安装**eslint

　　​`c npm install eslint --save-dev 1 ​`​

* **初始化配置，**eslint**同时可作为命令行工具使用**

　　​`c ./node_modules/.bin/eslint --init 1 ​`​

* window**如果无法运行上述命令，可尝试**

　　​`c "node_modules/.bin/eslint" --init  1 ​`​

#### Eslint配置文件的形式

* ​`JavaScript`​ - **使用** .eslintrc.js **然后输出一个配置对象。**
* ​`YAML`​ - **使用** .eslintrc.yaml **或** .eslintrc.yml **去定义配置的结构。**
* ​`JSON`​ - **使用** .eslintrc.json **去定义配置的结构，**ESLint **的** JSON **文件允许** JavaScript **风格的注释。**
* ​`package.json`​ - **在** package.json **里创建一个** eslintConfig**属性，在那里定义你的配置。**

　　如果 .eslintrc**和**package.json**同时存在时，** .eslintrc **优先级高会被使用，**package.json **文件将不会被使用。**<br />ESLint **还支持层叠配置，即一个项目中可以有多个**​`.eslintrc.js`​ **的配置文件。层叠配置使用离要检测的文件最近的** .eslintrc**文件作为最高优先级，然后才是父目录里的配置文件。**

1. **行内配置**<br />`/*eslint-disable*/ 和 /*eslint-enable*/`​，禁用启用规则       `/*global*/`​，定义全局变量       `/*eslint*/`​，配置规则       `/*eslint-env*/`​，指定当前运行环境 2.  配置项

* root**：指定是否停止在父级目录寻找配置文件** **。**
* env**：**env**用于启用特定环境的全局变量**

　　​`c /** 启用特定环境的全局变量 */ env: {   es6: true /** 启用除了modules以外的所有 EC6 特性,开启后会自动设置ecmaVersion为6 */,       node: true /** Node.js 全局变量和 Node.js 作用域 */,       browser: true /** 浏览器全局变量 */,       commonjs: true /**  CommonJS 全局变量和 CommonJS 作用域 (用于 Browserify/WebPack 打包的只在浏览器中运行的代码) */,       jest: false /** Jest 全局变量 */,       jquery: false /** jQuery 全局变量 */,       'shared-node-browser': false /** Node.js 和 Browser 通用全局变量 */,       worker: false /** Web Workers 全局变量 */,       amd: false /** 将 require() 和 define() 定义为像 amd 一样的全局变量 */,       mocha: false /** 添加所有的 Mocha 测试全局变量 */,       jasmine: false /** 添加所有的 Jasmine 版本 1.3 和 2.0 的测试全局变量。 */,       phantomjs: false /** phantomjs 全局变量 */,       protractor: false /** protractor 全局变量 */,       qunit: false /** QUnit 全局变量 */,       prototypejs: false /** Prototype.js 全局变量 */,       shelljs: false /** ShellJS 全局变量 */,       meteor: false /** Meteor 全局变量 */,       mongo: false /** MongoDB 全局变量 */,       applescript: false /** AppleScript 全局变量 */,       nashorn: false /** Java 8 Nashorn 全局变量 */,       serviceworker: false /** Service Worker 全局变量 */,       atomtest: false /** Atom 测试全局变量 */,       embertest: false /** Ember 测试全局变量 */,       webextensions: false /** WebExtensions 全局变量 */,       greasemonkey: false /** GreaseMonkey 全局变量 */, } 12345678910111213141516171819202122232425262728 ​`​

* parserOptions<br />用于设置解析器相关配置。       `ecmaVersion`​ - 默认设置为 3，5（默认)       `sourceType`​ - 设置为 “script” (默认) 或 “module”（如果你的代码是 ECMAScript 模块)。       `ecmaFeatures`​ - 这是个对象，表示你想使用的额外的语言特性:       `globalReturn`​ - 允许在全局作用域下使用 return 语句       `impliedStrict`​ - 启用全局 strict mode (如果 ecmaVersion 是 5 或更高)       `jsx`​ - 启用 JSX（支持 JSX 语法并不等同于支持 React。React 对 ESLint 无法识别的JSX语法应用特定的语义。如果你正在使用 React 并且想要 React 语义支持，需使用 eslint-plugin-react。）

　　​`c {     "parserOptions": {         "ecmaVersion": 6,         "sourceType": "module",         "ecmaFeatures": {             "jsx": true         }     }, } 123456789 ​`​

* parser<br />parser用于设置接解析器，ESLint 默认使用Espree作为其解析器。 -   processor       processor用于指定处理器，插件可以提供处理器。处理器可以从另一种文件中提取 JavaScript 代码，然后让 ESLint 检测 JavaScript 代码。或者处理器可以在预处理中转换 JavaScript 代码。使用时键值由插件名和处理器名组成的串接字符串加上斜杠组成

　　​`c {     "plugins": ["a-plugin"],     "processor": "a-plugin/a-processor" } 1234 ​`​

* overrides **：** **指定特定文件的检查规则**

　　eg**：** **为特定类型的文件指定处理器，可使用** overrides **键和** processor **的组合。**

　　​`c {     "plugins": ["a-plugin"],     "overrides": [         {             "files": ["*.md"],             "processor": "a-plugin/markdown"         }     ] } 123456789 ​`​

* globals<br />当访问当前文件内未定义的变量时，no-undef 规则将发出警告。如果想在一个源文件里使用全局变量，可以 ESLint 中定义这些全局变量。

　　​`c {     "globals": {         "var1": "writable",         "var2": "readonly"     } } 123456 ​`​

　　对应的值设置为 **“**writable**”** **以允许重写变量，或** **“**readonly**”** **不允许重写变量。**

* plugins<br />plugins 关用来引入指定的插件。插件名称可以省略 eslint-plugin- 前缀 。 -   rules       rules用于配置规则，ESLint 附带有大量的规则。你可以使用注释或配置文件修改你项目中要使用的规则。要改变一个规则设置，你必须将规则 ID 设置为下列值之一：       `"off"或 0`​ - 关闭规则       `"warn" 或 1`​ - 开启规则，使用警告级别的错误：warn (不会导致程序退出)       `"error"或 2`​ - 开启规则，使用错误级别的错误：error (当被触发的时候，程序会退出)

　　​`c {     "rules": {         "eqeqeq": "off",         "curly": "error",         "quotes": ["error", "double"]     } } 1234567 ​`​

　　配置定义在插件中的一个规则的时候，必须使用 **插件名**/**规则**ID **的形式：**

　　​`c {     "plugins": [         "plugin1"     ],     "rules": {         "eqeqeq": "off",         "curly": "error",         "quotes": ["error", "double"],         "plugin1/rule1": "error"     } } 1234567891011 ​`​

　　为一组文件定义规则，可以使用overrides**和** rules**：**

　　​`c {   "rules": {...},   "overrides": [     {       "files": ["*-test.js","*.spec.js"],       "rules": {         "no-unused-expressions": "off"       }     }   ] } 1234567891011 ​`​

* settings<br />ESLint 支持在配置文件添加共享设置。可以添加 settings 对象到配置文件，它将提供给每一个将被执行的规则。如果你想添加的自定义规则而且使它们可以访问到相同的信息，这将会很有用，并且很容易配置。

　　​`c {     "settings": {         "sharedData": "Hello"     } } 12345 ​`​

* extends<br />可共享的配置：https://cn.eslint.org/docs/developer-guide/shareable-configs       extends用于继承共享的配置规则，可共享的配置 是一个 npm 包，它输出一个配置对象。要确保这个包安装在 ESLint 能请求到的目录下（extends 属性值可以省略包名的前缀 eslint-config-)       extends 属性值可以由组成：plugin:包名 (可以是省略了前缀的插件名字也可以是完整包名，比如，react)/配置名称 (比如 recommended) ，也可以是一个省略 eslint-config-的共享配置。

　　​`c extends: [     // Airbnb JavaScript Style Guide https://github.com/airbnb/javascript     'airbnb-base',     'plugin:@typescript-eslint/recommended',     'plugin:import/recommended',     'plugin:import/typescript',     'plugin:vue/vue3-recommended',     'plugin:prettier/recommended', ], 123456789 ​`​

　　在配置文件中，使用 **“**extends**”**: **“**eslint:recommended**”** **来启用推荐的规则。**

#### .eslintignore

　　可以通过在项目根目录创建一个 .eslintignore **文件告诉** ESLint **去忽略特定的文件和目录。**.eslintignore **文件是一个纯文本文件，其中的每一行都是一个** [glob](https://so.csdn.net/so/search?q\=glob&spm\=1001.2101.3001.7020) **模式表明哪些路径应该忽略检测。**

#### [vite](https://so.csdn.net/so/search?q\=vite&spm\=1001.2101.3001.7020)集成eslint

　　安装插件vite-plugin-eslint**（**https://www.npmjs.com/package/vite-plugin-eslint**），配置如下：**

　　​`c import { defineConfig } from 'vite' import eslint from 'vite-plugin-eslint'  export default defineConfig({   plugins: [      eslint({           include: ['src/**/*.ts', 'src/**/*.tsx', 'src/**/*.vue'],           exclude: ['node_modules'],           cache:false        })     ] }) 123456789101112 ​`​

　　使用vite**集成的**​`vite-plugin-eslint`​**插件，直接在插件里面配置即可，但是也可以使用**eslint**的配置文件配置了（如**​`.eslintrc.js`​ **）**<br />vite**配置**eslint**：**​[https://blog.csdn.net/qq\_36305530/article/details/128342186](https://blog.csdn.net/qq\_36305530/article/details/128342186)

### 项目中的.eslintrc和IDE中的settings.json会走哪一个呢

　　对于 ESLint **来说，**.eslintrc **文件是主配置文件，如果配置文件中有指定使用的规则、插件和解析器等选项，则** IDE **的设置文件将被忽略。**<br />在大多数情况下，IDE **的设置文件只应用于该** IDE **环境中的代码检查，而无法覆盖在代码库中的项目范围内指定的规则和配置。**<br />如果您想在 IDE **中使用与项目相同的** ESLint **配置，请确保您的** IDE **的** ESLint **插件已正确安装，并且在** IDE **设置中已激活** Use ESLint **选项。**<br />在 Visual Studio Code **中，如果您的** .eslintrc **文件中指定了规则和配置，那么您需要添加** **“**eslint.enable**”**: true **配置才能启用** ESLint **检查。**<br />总之，`.eslintrc 文件最终会覆盖 IDE 中的任何设置文件`​**。**

#### “eslint.enable”: true

　　在 Visual Studio Code **中，如果您的项目中使用** ESLint **进行代码检查，在打开项目时默认情况下** `ESLint 插件处于禁用状态`​**，因此需要启用** eslint.enable **配置才能启用代码检查。**<br />可以通过以下方式在 Visual Studio Code **中启用** ESLint **检查：**

1. **在** VS Code **左侧菜单中选择“文件** > **首选项** > **设置”。**
2. **在打开的设置页中，在搜索栏中输入** **“**eslint**”。**
3. **点击** **“**Edit in settings.json**”** **按钮，打开** **“**settings.json**”** **文件。**
4. **在** **“**eslint.enable**”** **中添加** **“**true**”。**<br />例如：

　　​`typescript {     "eslint.enable": true } 123 ​`​

　　完成以上配置后，VS Code **将启用在项目中安装的** ESLint **插件，并使用您在项目中配置的** .eslintrc **文件中的选项和规则。为了让** VS Code **正常工作，建议安装和激活** ESLint **插件和** Prettier **插件，这样您就可以将代码格式和风格设置为一致的规范。**

# prettier ——统一代码风格

## prettier 的作用

　　​`prettier`​ **的作用就是统一代码风格。**<br />Prettier **的原理非常简单：不管你写的代码是个什么鬼样子，**Prettier **会去掉你代码里的所有样式风格，然后用统一固定的格式重新输出。**

## prettier 的使用

### Ide配置prettier

　　**下载插件：**<br />![在这里插入图片描述](https://img-blog.csdnimg.cn/506377f7fd8f460e8924ef60ca330b1c.png)<br />**格式化文档:**<br />右键编辑器页面，选择`以...格式化文档`​**，** **就会有如下选项**

　　​![在这里插入图片描述](https://img-blog.csdnimg.cn/531cba1206164ab5828faa3b3e7d05c1.png)<br />选择prettier**即可。**

　　**保存文件按时自动格式化文档：**<br />在设置中进行设置即可：<br />![在这里插入图片描述](https://img-blog.csdnimg.cn/e84d6ac8c29f4a9bab0da463bd19db73.png)​

### git整合prettier

　　git**整合**prettier**后再提价代码提交之前会自动帮我们格式化。**<br />**整合方法：** **使用**lint-staged

　　​`html // 这一行就可以安装husky和lint-stage，并且配置好husky。 npx mrm lint-staged 12 ​`​

　　husky **在这里的作用就是咬住** Git **的**hooks**不放。我们这里只关心** pre-commit **这一个** hook**。**<br />mrm **之后，** package.json **多了这些内容：**

　　​`js "devDependencies": {     "husky": "^3.0.5",     "lint-staged": "^9.2.5"   },   "husky": {     "hooks": {       "pre-commit": "lint-staged"     }   },   "lint-staged": {     "*.{js,css,json,md}": [       "prettier --write",       "git add"     ]   } 123456789101112131415 ​`​

# eslint 和 prettier

## eslint和prettier的区别

　　**提示错误的区别：**

* **当** ESLint **遇到上面的** incorrect code **的时候，会提示你违反规则，**​`让你修改代码`​**以符合规则。**
* **而** Prettier **则根本不管你之前符不符合什么规则，都先把你的代码解析成** `AST`​**，然后按照它自己的风格给你重新输出代码。**

　　**所解决的问题的区别：**

* ​`ESLint`​ **主要解决了两类问题，一个是代码质量问题，另一个是代码风格问题，但是主要解决的是代码质量问题，对于代码风格没有很重视。**
* ​`prettier`​ **就是解决代码风格问题的。**

　　所以我们通常将eslint**和**prettier`结合起来使用`​**，以达到解决两个问题的目的。**

## eslint和prettier的配置

　　由于prettier **和** eslint **都对代码做了格式化，所以一起使用的时候可能会有冲突。**<br />**解决方案：**​`eslint-config-prettier + eslint-plugin-prettier`​<br />`eslint-config-prettier`​**：关闭**eslint**中与**prettier**相互冲突的规则。**<br />`eslint-plugin-prettier`​**：赋予**eslint**用**prettier**格式化代码的能力，这样**prettier**检测出来的格式问题会报**eslint**的错误。**<br />**第一步：安装两个包**

　　​`c npm i eslint-config-prettier npm i eslint-plugin-prettier 12 ​`​

　　**第二步：修改.eslintrc文件**<br />添加如下内容：

　　​`c {     "extends": [         "plugin:prettier/recommended"     ], } 12345 ​`​

# editorconfig——统一代码编辑器编码风格

　　在多人开发的项目中，不能保证团队成员都使用相同的编辑器，那么不同的编辑器之间的格式设置各不相同，无法保证项目代码格式的统一，往往会出现意想不到的问题。editorconfig**就是解决这个问题的。**

　　**editorconfig是什么**<br />EditorConfig **有助于为跨各种编辑器和** IDE **处理同一项目的多个开发人员维护一致的编码风格。**EditorConfig **项目由用于定义编码样式的文件格式和一组文本编辑器插件组成，这些插件使编辑器能够读取文件格式并遵循定义的样式。**

　　**editorconfig插件**<br />EditorConfig **插件并不是所有的编辑器都默认支持的，需要使用请自行安装。**

　　**.editorconfig 配置文件**<br />.editorconfig **自定义文件是用来定义编辑器的编码格式规范，编辑器的行为会与** .editorconfig **文件中定义的一致，并且其优先级比编辑器自身的设置要高。**<br />editorconfig**只有**8**个配置项：**

　　​`c # 表示是最顶层的配置文件，发现值为true时，才会停止查找.editorconfig文件 root   # 设置使用那种缩进风格(tab是制表符，space是空格) indent_style   # 定义用于每个缩进级别的空格数 indent_size   # 用一个整数来设置tab缩进的列数。 tab_width   # 设置换行符，值为lf、cr和crlf end_of_line   # 设置编码格式，值为latin1、utf-8、utf-8-bom、utf-16be和utf-16le charset   # 设置为true则删除换行符之前的任何空白字符 # 设置为true会删除每一行后的任何空格  *** trim_trailing_whitespace   # 设置为true以确保文件在保存时以换行符结尾 # 如果设置为true，则文件最后一行也会确保以换行符结尾，会强制换行到下一行  *** insert_final_newline 12345678910111213141516171819202122232425 ​`​

# Vetur

　　**vetur 的特性**: **使**.vue**文件有语法高亮**, **质量提示** & **错误、格式化** / **风格、智能提示等。**​`但是vetur 的代码提示不支持任何配置`​**，需要配合**eslint**使用。**Vetur**默认使用** eslint-plugin-vue@beta **来检测。**

　　Vetur **内嵌了如下格式化工具**, **如果本地安装了相应版本**, **则会使用本地安装的版本**, **默认配置如下：**

* ​`prettier`​: For css/scss/less/js/ts.
* ​`prettier-eslint`​: For js. Run prettier and eslint --fix.
* ​`prettyhtml`​: For html.
* ​`stylus-supremacy`​: For stylus.
* ​`vscode-typescript`​: For js/ts. The same js/ts formatter for VS Code.
* ​`sass-formatter`​: For the .sass section of the files.

　　Vscode**中安装激活** vetur **插件**, **可以使**vue**代码就有高亮显示。**<br />安装完vetur**插件之后，可以在**vscode**的**setting.json**中进行**vetur**的相关配置：**<br />eg**：**

　　​`c //配置html文件  "vetur.format.defaultFormatter.html": "js-beautify-html", //配置css  "vetur.format.defaultFormatter.css": "prettier", 1234 ​`​

# VScode的prettier配置 和 项目中的eslint的配置出现冲突

　　在编写代码的时候出现如下问题：<br />当保存项目代码时，vscode**会优先根据**​`setting.json`​**中的配置按照**​`prettier的配置`​**进行代码格式化；但是项目中使用**eslint**来约束代码风格，并且**eslint**约束的风格和**​`prettier配置`​**的风格不一样，这就导致只要文件一保存运行代码就会报格式错误不能正常编译运行。**

　　**解决：**<br />一般情况下我们已项目中代码的格式化为先，所以可以暂时更改`setting.json`​**中的配置，暂时取消**​`prettier的配置`​**约束，使用项目中**eslint**来约束代码风格，这样保存的时候就会按照代码中**eslint**风格进行保存了。**

　　取消vscode**的**setting.json**的**​`prettier的配置`​**约束两种方法：**<br />1.**设置**​`"editor.formatOnSave": false`​**：即保存的时候不按照**vscode**的**setting.json**的配置进行代码格式化**<br />2.**取消对应的约束代码**

　　**保存的时候进行代码格式化**<br />并不是设置了代码的eslint**或**prettier**风格，保存后就会按照设置的风格格式化，是需要进行配置的。**

* **保存时，按照**vscode**的**setting.json**中配置的风格格式化：需要在**setting.json**中配置**​`"editor.formatOnSave": true`​
* **保存时，按照项目中的**eslint**配置的风格格式化：需要在项目中**eslint**风格的配置文件中设置**​`"extends"`​**，**eg**：**

　　​`js //extends用于继承共享的配置规则 "extends": [       "@vue/standard",       "@vue/typescript/recommended"     ], 12345 ​`​

　　同时我们根据上面的效果可以得知，先按照vscode**的**setting.json**配置的风格尽心格式化，如果没有设置再按照项目中的配置的代码风格进行格式化**
