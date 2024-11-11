---
created: 2023-11-06T08:20
updated: 2023-11-06T08:20
---
# vscode配置文件备份

　　{

　　// workbench

　　"workbench.settings.editor": "ui",

　　// editor

　　"editor.detectIndentation": false,

　　"editor.suggestSelection": "first",

　　"editor.renderControlCharacters": true,

　　"editor.multiCursorModifier": "ctrlCmd",

　　"editor.snippetSuggestions": "top",

　　"editor.fontSize": 14,

　　"editor.tabSize": 2,

　　"editor.fontWeight": "normal",

　　//启用字体渲染

　　"editor.fontLigatures": true,

　　// "window.zoomLevel": 1,

　　// "editor.fontFamily": "Hack Monaco Menlo Consolas, FiraCode Nerd Font Mono, DejaVu Sans Mono, DejaVuLGCSansCode, Droid Sans Mono, Source Code Pro, menlo, JetBrainsMono Nerd Font, menlo,Source Code Pro,JetBrains Mono,Droid Sans Mono",

　　"editor.fontFamily": "FiraCode Nerd Font Mono Retina, Source Code Pro,JetBrains Mono,Droid Sans Mono, Hack Monaco Menlo Consolas, FiraCode Nerd Font Mono, DejaVu Sans Mono, DejaVuLGCSansCode, Droid Sans Mono, Source Code Pro, menlo, JetBrainsMono Nerd Font, menlo",

　　// "editor.fontFamily: "JetBrainsMono",

　　"editor.accessibilitySupport": "off",

　　// 在按下 Tab 键时进行 Tab 补全，将插入最佳匹配建议。

　　"editor.tabCompletion": "on",

　　"editor.minimap.maxColumn": 20,

　　"editor.linkedEditing": true,

　　"editor.suggest.snippetsPreventQuickSuggestions": false,

　　"editor.wordWrap": "off",

　　"editor.guides.bracketPairs": false,

　　"editor.codeActionsOnSave": {

　　  "source.fixAll.eslint": true,

　　  "source.fixAll.stylelint": true

　　},

　　"editor.acceptSuggestionOnCommitCharacter": false,

　　"diffEditor.wordWrap": "off",

　　"diffEditor.ignoreTrimWhitespace": false,

　　// 文件资源管理

　　// 控制在资源管理器内拖放移动文件或文件夹时是否进行确认。

　　"explorer.confirmDragAndDrop": false,

　　// 控制资源管理器是否在把文件删除到废纸篓时进行确认。

　　"explorer.confirmDelete": false,

　　// 终端

　　"terminal.integrated.cursorBlinking": true,

　　"terminal.integrated.cursorStyle": "line",

　　"terminal.integrated.profiles.windows": {

　　  // 名称中不能有空格，否则无法识别

　　  // "Git_Bash": {

　　  //   // "path": "D:/install/Git/bin/bash.exe",

　　  //   // "icon": "circle-large-filled",

　　  //   "icon": "terminal-bash",

　　  //   "path": "C:\\Program Files\\Git\\bin\\bash.exe",

　　  //   // 配置git bash 参数的办法

　　  //   "args": \["--login", "-i"\]

　　  // },

　　  "Git-Bash": {

　　    // "path": "D:/install/Git/bin/bash.exe",

　　    // "icon": "circle-large-filled",

　　    "icon": "terminal-bash",

　　    "path": "D:\\GlobalScoopApps\\apps\\git\\2.39.2.windows.1\\bin\\bash.exe",

　　    // 配置git bash 参数的办法

　　    "args": \["--login", "-i"\]

　　  },

　　  // "GitBash": {

　　  //   "path": "C://msys64//msys2_shell.cmd",

　　  //   "args": \["-defterm", "-mingw64", "-no-start", "-here", "-lic", "cd \$PWD; exec zsh"\]

　　  // },

　　  "PowerShell_7": {

　　    // "source": "PowerShell",

　　    "path": "C:\\Program Files\\PowerShell\\7\\pwsh.exe",

　　    "color": "terminal.ansiBlue"

　　  }

　　},

　　// "git.path": "C:\\Program Files\\Git\\bin\\git.exe",

　　"git.path": "D:\\GlobalScoopApps\\apps\\git\\2.39.2.windows.1\\bin\\git.exe",

　　// "git.path": "C:\\msys64\\usr\\lib\\git-core\\git.exe",

　　// "git.path": "C:\\msys64\\git-wrap.bat",

　　"terminal.integrated.defaultProfile.windows": "Git-Bash",

　　// 启用后，保存文件时在文件末尾插入一个·最终新行。

　　"files.insertFinalNewline": true,

　　"files.eol": "\n",

　　"files.associations": {

　　  "\*.vue": "vue",

　　  "\*.wpy": "vue",

　　  "\*.wxml": "html",

　　  "\*.wxss": "css",

　　  "\*.cjson": "jsonc",

　　  "\*.json": "jsonc",

　　  "\*.wxs": "javascript",

　　  "\*.ejs": "html",

　　  "\*.html": "html"

　　},

　　//   文件焦点变化时自动保存

　　// "files.autoSave": "onWindowChange",

　　"files.autoSaveDelay": 500,

　　"files.defaultLanguage": "En",

　　// 这些文件将不会显示在工作空间中

　　"files.exclude": {

　　  "\*\*/.git": true,

　　  "\*\*/.svn": true,

　　  "\*\*/.hg": true,

　　  "\*\*/CVS": true,

　　  "\*\*/.DS_Store": true

　　  // "\*\*/\*.js": {

　　  //     "when": "\$(basename).ts" //ts编译后生成的js文件将不会显示在工作空中

　　  // }

　　  // "\*\*/node_modules": true

　　},

　　// 控制是否在搜索中跟踪符号链接。

　　"search.followSymlinks": false,

　　// 在使用搜索功能时，将这些文件夹/文件排除在外

　　"search.exclude": {

　　  "\*\*/node_modules": true,

　　  "\*\*/bower_components": true,

　　  "\*\*/target": true,

　　  "\*\*/logs": true,

　　  "\*\*/.data": true,

　　  "\*\*/.history": true,

　　  "\*\*/.vscode": true,

　　  "\*\*/.idea": true,

　　  "\*\*/built": true,

　　  "\*\*/bootstrap": true,

　　  "\*\*/libs": true,

　　  "\*\*/locale": true,

　　  "\*\*/plugin": true,

　　  "\*\*/dist": true

　　},

　　// "vetur.validation.template": false,

　　// 语言相关配置

　　// js

　　"javascript.referencesCodeLens.enabled": true,

　　"javascript.format.semicolons": "remove",

　　//  #让函数(名)和后面的括号之间加个空格

　　"javascript.format.insertSpaceBeforeFunctionParenthesis": true,

　　// ============= plugin config begin =============

　　// emmet

　　"emmet.includeLanguages": {

　　  "vue-html": "html",

　　  "wxml": "html",

　　  "vue": "html",

　　  "wpy": "html",

　　  "javascript": "javascriptreact"

　　},

　　"emmet.syntaxProfiles": {

　　  "vue-html": "html",

　　  "vue": "html"

　　},

　　"emmet.triggerExpansionOnTab": true,

　　"emmet.showAbbreviationSuggestions": true,

　　"emmet.showExpandedAbbreviation": "always",

　　// gitProjectManager

　　// windows 10 wsl GPM config start

　　/\* "gitProjectManager.baseProjectsFolders": \[

　　      // "D:/work/ngconsole",

　　      // "D:/codes/ngconsole",

　　      // "D:/work/ngconsole_resources",

　　      // "D:/codes/ngconsole_resources",

　　      // "D:/work/region-front",

　　      // "D:/work/edaas-front",

　　      // "D:/work/new-vdi-client",

　　      // "D:/codes/new-vdi-client",

　　      // "D:/work/oefe-docs",

　　      // "D:/work/idv-client",

　　      // "D:/work/oe-dms",

　　      // "D:/Github/face-api-demo",

　　      // "D:/Github/demo",

　　      // "D:/Github/sequelize-test/koa2-weibo-code",

　　      // "D:/Github/webbo_server",

　　      // "D:/Github/todolist-tool",

　　      // "D:/Github/sina",

　　      // "D:/my-dropbox/Dropbox",

　　      // "D:/work/pmv5-fe",

　　  \], \*/

　　//  macos

　　// "gitProjectManager.baseProjectsFolders": \[

　　// "/Users/zagger/code/ngconsole",

　　// "/Users/zagger/code/ngconsole_resources",

　　// "/Users/zagger/code/region-front",

　　// "/Users/zagger/code/edaas-front",

　　// "/Users/zagger/code/new-vdi-client",

　　// "/Users/zagger/code/oefe-docs",

　　// "/Users/zagger/code/idv-client",

　　// "/Users/zagger/code/oe-dms",

　　// "/Users/zagger/code/pmv5-fe",

　　// "/Users/zagger/code/web_resources_backend",

　　// "/Users/zagger/code/web_resources",

　　// "/Users/zagger/code/oe-control-user",

　　// "/Users/zagger/Dropbox",

　　// "/Users/zagger/Github/koa2-weibo-code",

　　// "/Users/zagger/Github/sequelize_test",

　　// "/Users/zagger/Github/precommit_test",

　　// "/Users/zagger/Github/jwt_test",

　　// "/Users/zagger/Github/mail_imap"

　　// /\* "/Users/zagger/Github/face-api-demo",

　　// "/Users/zagger/Github/demo",

　　// "/Users/zagger/Github/sequelize-test/koa2-weibo-code",

　　// "/Users/zagger/Github/webbo_server",

　　// "/Users/zagger/Github/todolist-tool",

　　// "/Users/zagger/Github/sina",

　　// "/Users/zagger/.config" \*/

　　// \],

　　"gitProjectManager.storeRepositoriesBetweenSessions": true,

　　"gitProjectManager.ignoredFolders": \["node_modules"\],

　　"gitProjectManager.maxDepthRecursion": 4,

　　"gitProjectManager.checkRemoteOrigin": false,

　　// spell userWords

　　"cSpell.userWords": \["Axios", "edaas", "juejin", "MVVM", "ngconsole", "tabset", "todolist", "tspace", "uihelper", "vdoi", "viewmodel", "zagger"\],

　　"security.workspace.trust.untrustedFiles": "open",

　　"minapp-vscode.disableAutoConfig": true,

　　// ============= plugin config end =============

　　// md format onsave

　　"markdownlint.run": "onSave",

　　"eslint.validate": \["typescript", "javascript", "javascriptreact", "typescriptreact"\],

　　// 对html的配置

　　"html.format.enable": true,

　　"html.format.wrapLineLength": 180,

　　"html.format.contentUnformatted": "pre,code,textarea",

　　"html.format.indentInnerHtml": true,

　　"html.validate.scripts": true,

　　"html.validate.styles": true,

　　"html.autoClosingTags": true,

　　"html.format.indentHandlebars": true,

　　"html.format.templating": true,

　　"html.trace.server": "messages",

　　// 对vue配置

　　// \#这个按用户自身习惯选择

　　// vetur 缩进是2

　　"vetur.format.enable": true,

　　"vetur.format.options.tabSize": 2,

　　"vetur.format.options.useTabs": false,

　　// 选择 vue 文件中 template 的格式化工具

　　// 仅仅格式化 html 部分，忽略 js, css

　　"vetur.format.defaultFormatter.js": "prettier-eslint",

　　"vetur.format.defaultFormatter.postcss": "prettier",

　　"vetur.format.defaultFormatter.scss": "prettier",

　　"vetur.format.defaultFormatter.less": "prettier",

　　"vetur.format.defaultFormatter.stylus": "stylus-supremacy",

　　"vetur.format.defaultFormatter.ts": "prettier",

　　// vetur 的自定义设置 \#vue组件中html代码格式化样式

　　"vetur.format.defaultFormatterOptions": {

　　  "js-beautify-html": {

　　    "eol": "\n",

　　    "indent_size": 2,

　　    "indent_char": " ",

　　    "indent_with_tabs": false,

　　    "templating": \["none"\],

　　    "unformatted": \["script", "pre", "style"\],

　　    "wrap_line_length": 120,

　　    "wrap_attributes": "auto",

　　    "end_with_newline": false

　　  },

　　  "prettier": {

　　    "prettier.printWidth": 120, // 超过最大值换行

　　    "semi": false, // 格式化不加分号

　　    "wrapAttributes": false

　　  }

　　},

　　//

　　"css.completion.completePropertyWithSemicolon": false,

　　"markdown-preview-enhanced.automaticallyShowPreviewOfMarkdownBeingEdited": true,

　　"todo-tree.general.tags": \["BUG", "HACK", "FIXME", "TODO", "XXX", "\[ \]", "\[x\]"\],

　　"todo-tree.regex.regex": "(//\|##\|\<!--\|;\|/\\\*\|^\|^\\s\*(-\|\\d+.))\\s\*(\$TAGS)",

　　"guides.enabled": false,

　　"\[html\]": {

　　  "editor.defaultFormatter": "vscode.html-language-features"

　　},

　　"\[javascript\]": {

　　  "editor.defaultFormatter": "vscode.typescript-language-features"

　　},

　　"\[vue\]": {

　　  "editor.defaultFormatter": "Vue.volar"

　　},

　　"\[svg\]": {

　　  "editor.defaultFormatter": "jock.svg"

　　},

　　"\[json\]": {

　　  "editor.defaultFormatter": "vscode.json-language-features"

　　},

　　"\[jsonc\]": {

　　  "editor.defaultFormatter": "esbenp.prettier-vscode"

　　},

　　"svg.preview.mode": "svg",

　　"git.confirmSync": false,

　　"local-history.path": "/Users/zagger/code/local_history",

　　"workbench.startupEditor": "none",

　　"vsicons.dontShowNewVersionMessage": true,

　　"settingsSync.ignoredSettings": \[\],

　　"projectManager.git.baseFolders": \["~~/code&quot;, &quot;~~/Github"\],

　　"Notes.notesLocation": "/Users/zagger/Desktop/zagger_files/notes",

　　"workbench.colorCustomizations": {

　　  "editor.lineHighlightBackground": "#1073cf2d",

　　  "editor.lineHighlightBorder": "#9fced11f"

　　},

　　"prettier.printWidth": 160,

　　"prettier.singleQuote": true,

　　"prettier.semi": false,

　　"git.enableSmartCommit": true,

　　"update.mode": "manual",

　　"interview.updateNotification": 1677734569020,

　　"interview.workspaceFolder": "e:\\frontend-docs",

　　"juejin.cookie": "passport_csrf_token=2c504e21f43196dd822fdfca010beadb; passport_csrf_token_default=2c504e21f43196dd822fdfca010beadb; csrf_session_id=7432cf6438f7aec9a1120b1971be073d; \_tea_utm_cache_2608={\\utm_source\\:\\gold_browser_extension\\}; \_\_tea_cookie_tokens_2608=%7B%22web_id%22%3A%227195374667530782219%22%2C%22user_unique_id%22%3A%227195374667530782219%22%2C%22timestamp%22%3A1675303728743%7D; n_mh=HfLXgDL8rksuzXUhP9IOwC4ewsDkoXROYkTGYlY7YNs; passport_auth_status=14b44b78092eea7c2802fbec9743fcf7,; passport_auth_status_ss=14b44b78092eea7c2802fbec9743fcf7,; sid_guard=c894125a2572701d842d68764e7c0924\|1675303758\|31536000\|Fri,+02-Feb-2024+02:09:18+GMT; uid_tt=d30aefacdc33eb1571ca8826f5d972ef; uid_tt_ss=d30aefacdc33eb1571ca8826f5d972ef; sid_tt=c894125a2572701d842d68764e7c0924; sessionid=c894125a2572701d842d68764e7c0924; sessionid_ss=c894125a2572701d842d68764e7c0924; sid_ucp_v1=1.0.0-KDAzOTYwODU2NjFkMTkyMmM5MWExZjY2NTg1YjUzMDY4MTFlMWQyZjMKFgitsKC\_\_fUNEM627J4GGLAUOAJA8QcaAmxmIiBjODk0MTI1YTI1NzI3MDFkODQyZDY4NzY0ZTdjMDkyNA; ssid_ucp_v1=1.0.0-KDAzOTYwODU2NjFkMTkyMmM5MWExZjY2NTg1YjUzMDY4MTFlMWQyZjMKFgitsKC\_\_fUNEM627J4GGLAUOAJA8QcaAmxmIiBjODk0MTI1YTI1NzI3MDFkODQyZDY4NzY0ZTdjMDkyNA; store-region=cn-hb; store-region-src=uid; msToken=8k3bJpfouj-13ptgqCJ3kkD4BrBM59rES9QV6h3FZV7RSppZfWA3Nnl-2ttwZQSBextaiXGRQdSU0TEx0Ixst8dTnu8T5LE4TEfLBBDZBtg=",

　　"juejin.pins.comment.background-color": "#1e80ff",

　　// 输入时格式化

　　"editor.formatOnType": true,

　　// 粘贴代码时格式化

　　"editor.formatOnPaste": true,

　　"terminal.external.windowsExec": "D:\\\\GlobalScoopApps\\\\apps\\\\git\\\\2.39.1.windows.1\\\\bin\\\\bash.exe",

　　"terminal.integrated.confirmOnKill": "never",

　　"editor.formatOnSave": true,

　　"eslint.format.enable": true,

　　"git.ignoreMissingGitWarning": true,

　　"vetur.format.styleInitialIndent": true,

　　"prettier.vueIndentScriptAndStyle": true

　　}
