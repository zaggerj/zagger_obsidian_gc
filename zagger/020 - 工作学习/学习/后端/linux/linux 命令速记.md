---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
# linux 命令速记 [[汇总所有在线文档]]

　　‍

* [ ] 存在就覆盖：rm -rf v && mkdir v && \cp -rfv view-front/** ./v
* [ ] ftp 偶尔会出现 死都访问不了，提示没有权限，实际上不是权限问题，通过修改ip地址，可以解决登录不了的问题 ^5ed4f7
* [ ] vscode 解决冲突时，解决完冲突，最好不要点击继续，因为会冲突git pull 导致重新变基，会要求再解决一次冲突，体验极差，直接执行命令行git merge --continue ^967b6a
* [ ] history | grep pnpm
* [ ] grep -rl ''
* [ ] 86-5-7023
* [ ] cp 是 Linux 中用于复制文件和目录的命令，它的常用参数包括：

* -r：递归地复制目录及其所有子目录和文件。
* -i：交互式地复制文件，如果目标文件已经存在，则询问是否覆盖。
* -u：仅复制源文件中比目标文件新或者目标文件不存在的文件。
* -p：保留文件的属性，包括拥有者、组、权限、时间戳等。
* -v：详细输出复制的过程，包括每个文件的名称和大小。
* -a：以归档模式复制文件，等同于

　　-dpR，即递归地复制目录并保留文件属性和链接。

　　‍

```js
grep 是 Linux 中一个常用的文本搜索工具，它可以在文件中查找指定的文本模式，并将匹配的行输出到标准输出。grep 命令的基本语法如下：
Copy
grep [options] pattern [file ...]

其中，pattern 表示要查找的文本模式，可以是一个字符串、一个正则表达式或者一个文件，file 则表示要查找的文件名或目录名，可以是一个或多个文件。如果不指定文件名，则默认从标准输入读取数据。
以下是 grep 常用的选项：
-i：忽略大小写。
-v：反向匹配，即输出不包含模式的行。
-w：仅匹配整个单词，而不是单词的部分。
-c：仅输出匹配的行数。
-n：输出匹配的行号。
-r：递归地搜索指定目录及其子目录中的文件。
-l：仅输出包含匹配的文件名。
```

　　‍
# spice手动处理5.5.0开启拖拽上传 | [[汇总所有在线文档#^6ef750|汇总]]
```js
bindEvents:function(){let t=this;const e=function(e){t.clipboardEnabled&&t.fire("paste",e.clipboardData.getData("text/plain"))};document.addEventListener("paste",e);const i=function(){document.hasFocus()&&t.syncClientClipBoardToAgent()};window.addEventListener("focus",i);const n=function(){t._sendInput(["reset",null])};window.addEventListener("blur",n);const s=function(t){t.stopPropagation(),t.preventDefault(),t.dataTransfer.dropEffect="copy"};document.addEventListener("dragover",s,!1);let o=[],r=[],a=0;const c=function(){o.length>0&&t.fire("fileUpload",[o,r]),o=[],r=[],a=0};var h=function(t){t&&(a++,t.isFile?t.file((function(e){o.push({file:e,fullPath:t.fullPath}),a--,0===a&&c()})):t.isDirectory&&t.createReader().readEntries((function(e){e.forEach((function(t){h(t)})),r.push(t.fullPath),a--,0===a&&c()})))};const u=function(t){t.stopPropagation(),t.preventDefault();const e=t.dataTransfer;if(e.items)for(let t=0;t<e.items.length;t++){const i=e.items[t].webkitGetAsEntry();h(i)}};document.addEventListener("drop",u,!1);const l=function(e){122!==e.which&&(e.stopPropagation(),e.preventDefault()),t.handleKey(e)};document.addEventListener("keydown",l),document.addEventListener("keyup",l),t._disposeFns.push((function(){document.removeEventListener("paste",e),window.removeEventListener("focus",i),window.removeEventListener("blur",n),document.removeEventListener("dragover",s),document.removeEventListener("drop",u),document.removeEventListener("keydown",l),document.removeEventListener("keyup",l),t=null}))},setLayer
```
