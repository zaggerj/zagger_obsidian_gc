---
alias:
tags: 长青笔记
cdate: 2023-11-13 08:33
uid: 20231211084830
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
tags: 资源/软件安装
created: 2023-11-03T22:29
updated: 2023-11-14T09:21
---

# 1. vim 使用技巧

## 1.1. Metadata

Status:: #笔记状态/ 🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2023-12-11 星期一 08:48:25

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

### 1.4.1. 翻整页
```
Ctrl+f forward
Ctrl+b backward
```

### 1.4.2. 翻半页

```
Ctrl+d down
Ctrl+u up
```

### 1.4.3. 查看文档
`:h:%` 
%代表文件本身

### 1.4.4. find f
<mark style="background: #FF5582A6;">f 只能搜索同一行</mark>

### 1.4.5. zz 提升行
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231211093101.png)
zz 之后
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231211093112.png)

### 1.4.6. 寄存器|暂存器
#### 1.4.6.1. vim 寄存器

#### 1.4.6.2. 无名寄存器（”“）

Vim 的删除、复制与粘贴命令都会用到众多寄存器中的某一个。我们可以通过给命令加 “{register} 前缀的方式指定要用的寄存器。若不指明， Vim 将缺省使用**无名寄存器(“”)**  
倘若我们没有指定要使用的寄存器， Vim 将缺省使用无名寄存器，它可以用双引号表示为了显式地引用该寄存器，我们得使用两个双引号。例如， “”p，它完全等同于 p 命令。

#### 1.4.6.3. 复制专用寄存器（”0）

当我们使用 y{motion} 命令时，要复制的文本不仅会被拷贝到无名寄存器中，而且也被拷贝到了复制专用寄存器中，后者可用数字 0 加以引用。  
复制专用寄存器，顾名思义，仅当使用 y{motion} 命令时才会被赋值。换句话讲，使用 x、 s、c{motion} 以及 d{motion} 命令均不会覆盖该寄存器。如果我们复制了一些文本，可以确信该文本会一直保存于寄存器 0 中，直到我们复制其他文本时才会被覆盖。复制专用寄存器是稳定的，而无名寄存器是易变的。

#### 1.4.6.4. 有名寄存器（”a – “z）

Vim 提供了一组以 26 个英文字母命名的有名寄存器。这意  
味着我们可以剪切（”ad{motion}）、复制（”ay{motion}）或者粘贴（”ap）多达 26 段文本。

#### 1.4.6.5. 只读寄存器

```
"%  当前文件的名称（包含路径）
"#  Name of the alternate file（包含路径）
".  最后一次插入的文本
":  上次执行的 Ex 命令
"/  上次查找的模式
```
#### 1.4.6.6. 系统剪切板

之前我们在 vim 中复制粘贴的内容，只能在 vim 中使用。同样的系统中复制粘贴的内容只能在系统其它程序中使用，无法直接粘贴到 vim 中。我们可以在 vim 中使用系统剪切板。vim 可以使用 `+` 来访问系统剪切板。例如使用 `"+yy` 将内容复制到系统剪切板中，供其他程序使用。

但是在有好的 shell 工具的加持下，我更喜欢用 `<Ctrl+v>` 这样的方式直接粘贴一大段文字到 vim 中。或者配合 vim 的可视模式，直接使用 shell 中的快捷键从 vim 中粘贴选中的内容到系统剪切板
以下是一些常用的 Vim 暂存器及其用途：

1. `"a` 到 `"z`：这些是命名暂存器，用于存储文本。可以使用 `"ay` 将选中的文本复制到暂存器 `a` 中，然后使用 `"ap` 将暂存器 `a` 中的内容粘贴到光标位置。
    
2. `"0`：这是复制暂存器，用于存储最近复制的文本。当你使用 `y` 命令或者 `"ay` 将文本复制到暂存器时，它将存储在 `"0` 中。可以使用 `"0p` 将最近复制的文本粘贴到光标位置。
    
3. `"+`：这是系统剪贴板暂存器。可以使用 `"+y` 将选中的文本复制到系统剪贴板中，然后使用 `"+p` 将剪贴板中的内容粘贴到光标位置。
    
4. `"*`：这是与系统剪贴板关联的暂存器。在大多数情况下，它与 `"+` 暂存器相同。可以使用 `"*y` 将选中的文本复制到与系统剪贴板关联的暂存器中，然后使用 `"*p` 将其粘贴到光标位置。
    
5. `"_`：这是黑洞暂存器。当你不想保留复制的内容时，可以将其存储到黑洞暂存器中。例如，使用 `"_dd` 删除一行而不将其存储到任何暂存器中。
#### 1.4.6.7. gt 切换 tab
#### 1.4.6.8. 快速退出 vim
1. 按住 shift zz 保存退出， zq 不保存退出，q 表示放弃，之所以按住 shift，其实是切换大小写
2. 在命令编辑模式下：
	:q 不保存退出
	:q! 不保存强制退出
	:wq 保存退出，w 表示写入，不论是否修改，都会更改时间戳
	:x     保存退出，如果内容未改，不会更改时间戳
#### 1.4.6.9. tab window buffer 区别
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231211110733.png)

#### 1.4.6.10. tab 相关
tab 之于 window 如果 window 之于 buffer, tab 和 window 都只是布局而已,真正影响到文件保存的只有 buffer, 至少会有一个 window,但到 tab 可有可无
1. **跳转到指定的选项卡 tab**
- `tab1` 跳转到第 1 个 tab
- `tab2` 跳转到第 2 个 tab
- `tab3` 跳转到第 3 个 tab
- `tab5` 跳转到第 5 个 tab

2. **移动选项卡位置**
- `:-tabmove` 当前选项卡左移动
- `:+tabmove` 当前选项卡右移动
- `:0tabmove` 当前选项卡移动到最左边
- `:tabmove 0` 当前选项卡移动到最左边
- 这样的选项卡很方便打开一个帮助
    - `:tab help gt`

3. **按照选项卡打开文件**
- `vim -p file1.js file2.js file3.js`
- 对比原来按照 `window` 打开文件
    - `vim -o file1.js file2.js file3.js`
    - `vim -O file1.js file2.js file3.js`

![图片描述](https://www.learnfk.com/storage/vim/6490f5e11cdda4d30eb3f630155ff2d8.jpg)

- `:tabn` 和 `:tabp` 可以切换标签页
- 更快速的方法是 `gt`、`gT`、`1gt`

#### 1.4.6.11. 容器汇总

- vim 命令打开的参数对应一个列表 - `arguments` 参数列表
    - 列表 - `:args`
	    - 示例：
		- `:argsa file3.txt`：将 `file3.txt` 添加到当前文件列表的末尾。
	- 添加 - `:arga`  
		- 示例：
		- `:argsa file3.txt`：将 `file3.txt` 添加到当前文件列表的末尾。
    - 删除 - `:argd`
	    - 示例：
		- `:argsd file2.txt`：从当前文件列表中删除所有名为 `file2.txt` 的文件。
    - 执行命令 - `:argdo`
	    - 示例：
		- `:argdo %s/foo/bar/g | update`：在文件列表中的每个文件上执行替换命令，将每个文件中的所有 `foo` 替换为 `bar`，然后保存文件。
- 打开的文件缓存对应一个列表 - `buffers` 缓存列表
    - 列表 - `:ls`
    - 添加 - `:e .`
    - 切换 - `:b1`
    - 关闭 - `:bd`
    - 执行命令 - `:bufdo`
	    - 示例：
		- `:bufdo %s/foo/bar/g | update`：在所有打开的缓冲区中执行替换命令，将每个缓冲区中的所有 `foo` 替换为 `bar`，然后保存文件。
- tab 选项卡对应一个列表 - `tabs` 选项卡列表
    - 列表 - `:tabs`
    - 打开 - `:tabnew`
    - 切换 - gt、gT
    - 关闭 - `:tabc`
    - 执行命令 - `:tabdo`
- tab 选项卡中的窗口对应一个列表 - `windows` 窗口列表
    - 列表 - `:sp`、`:vsp`
    - 打开 - ctrl+w 后加 hjkl
    - 关闭 - `:q`
    - 执行命令 - `:windo`
```vim
:tabnew filename #打开一个tab  命令总是在一个新选项卡中打开文件
:tabedit #当前window 创建tab 简写:tabe 新建一个tab用来打开一个文件 :tabe 和 :tabedit 命令会根据情况在当前选项卡或新选项卡中打开文件。
:tabs用来查看tab列表
:gt 切换下一个tab
:gT切换上一个tab
:ngt切换到对应的tab，n是编号
```
#### 1.4.6.12. 使用全键盘方式跳入跳出超链接

- 是 ctrl+] 就可以**跳入链接**
- ctrl+o 可以**跳出链接**，回到原位置 `older position`
- `:h ctrl-c` 就是帮助我们查找一下 `ctrl-c` 快捷键究竟做些什么
- `:h ctrl-g`
#### 1.4.6.13. 命令模式 c+r+‘+‘引用系统剪切板
#### 1.4.6.14. vim 键盘图
![5a19c121fda7a831559898ae84a9f8e8.gif](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/5a19c121fda7a831559898ae84a9f8e8.gif)

#### 1.4.6.15. set noacd 取消设置当前目录自动跟随当前文件
#### 1.4.6.16. <C+w>, <S+t> 提升窗口到单独的 tab
#### 1.4.6.17. e # 快速用 buffer 打开上一个文件
#### 1.4.6.18. vs # 快速用分屏打开上一个文件
#### 1.4.6.19. buffer 使用:bd
#### 1.4.6.20. tab 使用:tabc
#### 1.4.6.21. window 使用:q
#### 1.4.6.22. 使用 marks 跳转
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240116153057.png)

```vim
" 简写为normal mode mQ
:mark Q
:mark W
:mark E
" 就相当于我们自己给这三个文件定义了相应的快捷跳转键啦
" normal mode `Q
`Q `W `E 
```

#### 1.4.6.23. tab 化和 window 化所有 buffer
```vim
:tab ba
:hori ba
:vert ba
"关闭当前tab的所有缓冲区
:windo bd 
```
#### 1.4.6.24. 查看文件历史版本
1. `Git log %`
2. 定位到对应的 commit，`yw` 复制对应的 hash
3. `Git show ` 加上 `C+u+"` 打开文件详细输出

#### 1.4.6.25. 先使用 grep 后使用 quickfix
`:grep queue .\view-front`
`copen`
#### 1.4.6.26. coc 不自动格式化
不能安装 coc-prettier
```json
{
"eslint.autoFixOnSave": true,
  "eslint.filetypes": ["javascript", "javascriptreact", "typescript", "typescriptreact"],
  "coc.preferences.formatOnSaveFiletypes": [
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact"
  ],
  "tsserver.formatOnType": true,
  "coc.preferences.formatOnType": true
}
```

#### 1.4.6.27. C+\ C+n term 切换成 normal 模式
#### 1.4.6.28. term 中 ctrl+e 把终端给关掉了
c+a/c+e 切换光标到行首和行位
c+u/c+k 
c+w

#### 1.4.6.29. 终端常见快捷键
终端中有许多常用的快捷键，下面列出一些常见的终端快捷键：

1. 光标移动：
    
    - `Ctrl+A`：将光标移动到行首
    - `Ctrl+E`：将光标移动到行尾
    - `Alt+B` 或 `Ctrl+左箭头`：将光标向左一个单词
    - `Alt+F` 或 `Ctrl+右箭头`：将光标向右一个单词
2. 删除文本：
    
    - `Ctrl+U`：删除光标位置之前的所有文本
    - `Ctrl+K`：删除光标位置之后的所有文本
    - `Ctrl+W`：删除光标位置之前的一个单词
    - `Ctrl+Y`：粘贴之前删除的文本
3. 历史命令：
    
    - `Ctrl+P` 或 `上箭头`：显示上一个命令
    - `Ctrl+N` 或 `下箭头`：显示下一个命令
    - `Ctrl+R`：搜索历史命令（按下后输入关键字，终端会显示最近的匹配命令）
    - `Ctrl+G` 或 `Ctrl+C`：退出历史命令搜索或终止当前命令
4. 窗口管理：
    
    - `Ctrl+L`：清屏（相当于执行 `clear` 命令）
    - `Ctrl+D`：退出当前终端会话
    - `Ctrl+S`：暂停终端屏幕输出
    - `Ctrl+Q`：恢复终端屏幕输出（当使用 `Ctrl+S` 暂停屏幕输出后）

#### 1.4.6.30. windows 安装最新版 neovim

1. ~~各种版本地址：[github-nvim](https://github.com/neovim/neovim/releases/)~~
2. 直接使用 `scoop install -g neovim`
3. 然后重新启动终端，`nvim -v` 即为最新的 neovim
4. 终端设置好代理
5. 拉取自己的 nvim 配置仓库：[GitHub - zaggerj/nvim\_config: pravite nvim config](https://github.com/zaggerj/nvim_config.git) `git clone https://github.com/zaggerj/nvim_config.git`
6. nvim 启动 nvim 安装各种插件
7. 其中包括安装 coc 插件
8. 配置 coc npm 包安装源地址：
```shell
# ~/.npmrc
registry= https://registry.npmmirror.com/
coc.nvim:registry= https://registry.npmmirror.com/
```
#### 1.4.6.31. nvim-tree.lua

[Archived · nvim-tree/nvim-tree.lua Wiki · GitHub](https://github.com/nvim-tree/nvim-tree.lua/wiki/Archived#alternative-default-mappings)
```
 vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
  vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
  vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
  vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
  vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
  vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
  vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
  vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
  vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
  vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
  vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
  vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
  vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
  vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
  vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
  vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
  vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
  vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
  vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
  vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
  vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
  vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
  vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
  vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
  vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
  vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
  vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
  vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
  vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
  vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
  vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
  vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
  vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
  vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
  vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
  vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
  vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
  vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
  vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
  vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
  vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
  vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
  vim.keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
  vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
  vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
  vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
  vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
  vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
  vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
  vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
  -- END_DEFAULT_ON_ATTACH


  -- Mappings removed via:
  --   remove_keymaps
  --   OR
  --   view.mappings.list..action = ""
  --
  -- The dummy set before del is done for safety, in case a default mapping does not exist.
  --
  -- You might tidy things by removing these along with their default mapping.
  vim.keymap.set('n', 'O', '', { buffer = bufnr })
  vim.keymap.del('n', 'O', { buffer = bufnr })
  vim.keymap.set('n', '<2-RightMouse>', '', { buffer = bufnr })
  vim.keymap.del('n', '<2-RightMouse>', { buffer = bufnr })
  vim.keymap.set('n', 'D', '', { buffer = bufnr })
  vim.keymap.del('n', 'D', { buffer = bufnr })
  vim.keymap.set('n', 'E', '', { buffer = bufnr })
  vim.keymap.del('n', 'E', { buffer = bufnr })


  -- Mappings migrated from view.mappings.list
  --
  -- You will need to insert "your code goes here" for any mappings with a custom action_cb
  vim.keymap.set('n', 'A', api.tree.expand_all, opts('Expand All'))
  vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
  vim.keymap.set('n', 'C', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', 'P', function()
    local node = api.tree.get_node_under_cursor()
    print(node.absolute_path)
  end, opts('Print Node Path'))

  vim.keymap.set('n', 'Z', api.node.run.system, opts('Run System'))

end
```
#### 1.4.6.32. lua 语言支持自动格式化如何配置 coc.nvim
[nvim lua版本配置](https://github.com/yaocccc/nvim)
[Using-coc-extensions](https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions)
[coc.nvim](https://github.com/neoclide/coc.nvim/wiki)
[Thoughts on coc.nvim - Meet @fannheyward](https://fann.im/blog/2021/08/01/thoughts-on-coc.nvim/)


#### 1.4.6.33. **保存文件前显示差异** `:w !diff % -`
我们将上述命令拆解来看：

- :w 用于保存/写入，在这个特定场景中，如果命令中没有指定文件名，则输出将写入 STDIN（标准输入）文件；
- :!<command> 是执行 shell 命令的语法，在这个例子中，我们在 shell 中运行 diff 命令；
- % 表示未修改的当前文件的名称；试试这个：:!echo %
- - 是 diff 命令的 STDIN 文件。

因此，该命令首先将所有[未保存]内容写入 STDIN 文件。然后 diff 命令读取当前文件（%）并将其与 STDIN（-）文件进行比较。

这个命令大致等同于这个 shell 命令：`diff <original-file> <Vim's STDOUT>`

#### 1.4.6.34. **以正确的缩进深度开始书写**

假设光标在第一行第一列，但是所要写的内容需要缩进，那在不按下制表符（tab）和空格键的情况下，应该怎样做呢？

答案是在正常模式下按下 S 键。

当光标位于行的第一列时，按 Esc 键进入正常模式。然后按 S（大写）键，这会将光标移动到适当的缩进深度，并自动进入“插入”模式，以便开始键入。


`i` 就是选择内部，`a` 就是连带结对符（此处先把单词两旁的空格也当成结对符吧）
```vim
gcc 快捷注释

gf #找到定义文件
g; #找到上次编辑的地方

`[ 上次粘贴的地方

leader fs 打开配置文件

# vim.sneak
' + 加上关键字两个往下调
backspace + 加上关键字两个往上

daf function coc
leader+gll [或]+m 切换下一个 diff
Git log --oneline
Git log -p % [[ ]] 跳转段落
# 最佳方式，但是会卡
Gclog 
```
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231221172513.png)
[GitHub - tpope/vim-fugitive: fugitive.vim: A Git wrapper so awesome, it should be illegal](https://github.com/tpope/vim-fugitive)
[GitHub - justinmk/vim-sneak: The missing motion for Vim :athletic\_shoe:](https://github.com/justinmk/vim-sneak)
[Archived · nvim-tree/nvim-tree.lua Wiki · GitHub](https://github.com/nvim-tree/nvim-tree.lua/wiki/Archived#example)
[12个 vim 编辑器的高级玩法 - 知乎](https://zhuanlan.zhihu.com/p/661568998)
[vim的高级用法\_vim高级用法-CSDN博客](https://blog.csdn.net/qq_49286390/article/details/107342848)
[vim教程之基本使用 - 知乎](https://zhuanlan.zhihu.com/p/601390879)
[GitHub - nvim-telescope/telescope.nvim: Find, Filter, Preview, Pick. All lua, all the time.](https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#usage)


#### 1.4.6.35. TSInstall html 没有安装导致配置# `nvim-ts-context-commentstring` 没有效果
[search](https://github.com/search?q=treesitter+comment&type=repositories)
[plugins.lua](https://github.com/siduck/dotfiles/blob/c03d41c29ce70211f523c92e7414fa27f6163f10/nvchad/custom/plugins.lua#L105)
[GitHub - JoosepAlviste/nvim-ts-context-commentstring: Neovim treesitter plugin for setting the commentstring based on the cursor location in a file.](https://github.com/JoosepAlviste/nvim-ts-context-commentstring?tab=readme-ov-file)
[Integrations · JoosepAlviste/nvim-ts-context-commentstring Wiki · GitHub](https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#commentnvim)

#### 1.4.6.36. TSInstall all 报错有四个一直安装不了
[[Bug]: nvim-treesitter[jsonc]: Error during tarball extraction · Issue #1578 · LunarVim/LunarVim · GitHub]( https://github.com/LunarVim/LunarVim/issues/1578 )

#### 1.4.6.37. daf dif 生效需要 treesittor 安装好

#### 1.4.6.38. 注释块 gcaf gcif
#### 1.4.6.39. 注释大块 gciB gcaB

#### 1.4.6.40. Comment.nvim 
[GitHub - numToStr/Comment.nvim: :brain: // Smart and powerful comment plugin for neovim. Supports treesitter, dot repeat, left-right/up-down motions, hooks, and more](https://github.com/numToStr/Comment.nvim)
 **✨ Features**

- Supports treesitter. [Read more](https://github.com/numToStr/Comment.nvim#treesitter)
- Supports `commentstring`. Read `:h comment.commentstring`
- Supports line (`//`) and block (`/* */`) comments
- Dot (`.`) repeat support for `gcc`, `gbc` and friends
- Count support for `[count]gcc` and `[count]gbc`
- Left-right (`gcw` `gc$`) and Up-Down (`gc 2 j` `gc 4 k`) motions
- Use with text-objects (`gci{` `gbat`)
- Supports pre and post hooks
- Ignore certain lines, powered by Lua regex

#### 1.4.6.41. :source % 重新应用 init.vim

#### 1.4.6.42. CocInstall coc-marketplace lua 选择 coc-sumneko-lua 就可以了

[上手Coc.nvim 完全指南-CSDN博客](https://blog.csdn.net/weixin_39130261/article/details/118490351)

#### 1.4.6.43. 折叠 zc zo 折叠当前块 nvim-ufo zM 折叠所有 zR 打开折叠

#### 1.4.6.44. gitsigns 插件配置
[GitHub - lewis6991/gitsigns.nvim: Git integration for buffers](https://github.com/lewis6991/gitsigns.nvim)

```vim
gcaf
注释掉了整个 on_attach 代码
```
#### 1.4.6.45. fugitive 插件工作流完美替换 lazygit 插件
```vim
" 进入 git status 查看状态
:G
a 切换 git add 状态
dd 查看 diff 文件差别
cc 提交 git commit 信息
:Git push 进行远程提交
```
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240119170958.png)
```
:git blame
O new tab
p previous
o h


```

#### 1.4.6.46. Server sh failed to start: Error: spawn UNKNOWN
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231225162132.png)
[[coc.nvim] Server sh failed to start: Error: spawn UNKNOWN · Issue #57 · josa42/coc-sh · GitHub]( https://github.com/josa42/coc-sh/issues/57 )

#### 1.4.6.47. conform.nvim
[GitHub - stevearc/conform.nvim: Lightweight yet powerful formatter plugin for Neovim](https://github.com/stevearc/conform.nvim)

### 1.4.7. ### git mergetool d 1 o d 3 o visual 模式下选中然后操作 

### 1.4.8. `:h swap-file`

```vim
:w !sudo tee % >/dev/null

```
`:h w!` 把当前的内容写到另外一个文件中
`:h expand`
`Ctrl+g`



# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
vim 基础：
1. [Vim查找与替换命令大全，功能完爆IDE！ - 良许Linux - 博客园](https://www.cnblogs.com/yychuyu/p/12671147.html)
1. vim 寄存器相关：
	1. [vim 从嫌弃到依赖(15)——寄存器 - 知乎](https://zhuanlan.zhihu.com/p/523486683)
	2. vim 寄存器：[vim寄存器](https://codeleading.com/article/89514035966/)
2. vim 快捷键：[vim退出快捷键「建议收藏」 - 全栈程序员必看](https://javaforall.cn/172543.html)
3. Command-line Mode [VIM学习笔记 命令行模式 (Command-line Mode) - 知乎](https://zhuanlan.zhihu.com/p/76531156)
4. vim buffer、tab、window
	1. [29.vim高效使用方法之buffer、window和tab\_vim buffer-CSDN博客](https://blog.csdn.net/a464057216/article/details/51523860)
	2. [vim之buffer/window/tab - 马肯尼煤牙巴骨 - 博客园](https://www.cnblogs.com/nocanstillbb/p/16375043.html)
	3. [[Vim] Tab，Window，Buffer 概念和操作-CSDN 博客]( https://blog.csdn.net/weixin_43162745/article/details/88732197 )
5. 命令集合：
	1. [vim命令大全，非常详细，强烈建议收藏！ - 知乎](https://zhuanlan.zhihu.com/p/628940845)
	2. [Vim 全局命令global详解 - 无涯教程网](https://www.learnfk.com/vim/vim-tutorial-global-command-global.html)
6. vim 杂项：
	1. [Vim 概述 - 知乎](https://zhuanlan.zhihu.com/p/648077001)
	2. [vim内置终端使用分享 - 知乎](https://zhuanlan.zhihu.com/p/596644062)
	3. [拥抱 Vim：这些快捷键让你爱上 Vim 编辑器](https://baijiahao.baidu.com/s?id=1760966208530497278&wfr=spider&for=pc)
	4. [vim操作教程，看这一篇绝对足够啦\~\_vim 显示标记-CSDN博客](https://blog.csdn.net/weixin_42639919/article/details/133626489)
	5. [精通 vim 你应该理解的几个名词 - 知乎](https://zhuanlan.zhihu.com/p/96801314/)
	6. [maps.vim](https://github.com/LinHQ1999/nvim-config/blob/office/mysettings/maps.vim)
	7. [Vim 使用帮助详解 - 无涯教程网](https://www.learnfk.com/vim/vim-tutorial-use-help.html)
	8. ![](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/5a19c121fda7a831559898ae84a9f8e8.gif)
	9. [Vim 标签页 tab详解 - 无涯教程网](https://www.learnfk.com/vim/vim-tutorial-tab-tab.html)
	10. [Vim实践与学习-08配置相关 - 知乎](https://zhuanlan.zhihu.com/p/103461924)
	11. [Vim 配置入门 - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2018/09/vimrc.html)
	12. [vim超实用指南，收藏这一篇就够了！ - 知乎](https://zhuanlan.zhihu.com/p/467661880)
	13. [vim的marks命令详解\_vim mark-CSDN博客](https://blog.csdn.net/alwaysbefine/article/details/122182127)
	14. [Linux文本编辑器—Vim【进阶操作】 - 知乎](https://zhuanlan.zhihu.com/p/652003809)
	15. [Linux系统操作命令汇总（含vim） - 知乎](https://zhuanlan.zhihu.com/p/617231934)
	16. [VIM 中文帮助: 使用多窗口多缓冲区的命令](https://vimcdoc.sourceforge.net/doc/windows.html#:buffers)
	17. [VIM 中文帮助: 总览最常用的命令](https://vimcdoc.sourceforge.net/doc/quickref.html)
	18. [vim-fugitive](https://github.com/tpope/vim-fugitive)
	19. [854.【git】git 查看 modified 状态文件与上个版本的改动 - 简书](https://www.jianshu.com/p/641321e139d0)
	20. [【neovim 技巧系列】quickfix 与文本处理-CSDN博客](https://blog.csdn.net/m0_37952030/article/details/127113848)
	21. [vi/vim使用进阶: 剑不离手 – quickfix - 摩斯电码 - 博客园](https://www.cnblogs.com/pengdonglin137/p/3552580.html)
	22. [像 VSCode 一样设置 Neovim\_vim\_开源小助理-开源](https://devpress.csdn.net/opensource/62f42b9d7e668234661882d7.html)
	23. [GitHub - preservim/nerdtree: A tree explorer plugin for vim.](https://github.com/preservim/nerdtree)
	24. [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#git-stage-unstage-files-and-directories-from-the-tree)
7. coc.nvim 和 nvim-lsp：
	1. [# Thoughts on coc.nvim](https://fann.im/blog/2021/08/01/thoughts-on-coc.nvim/)
	2. [nvim-lspconfig or coc.nvim : r/neovim](https://www.reddit.com/r/neovim/comments/p3ji6d/nvimlspconfig_or_cocnvim/?onetap_auto=true)
	3. [Why is nobody using CoC anymore? : r/neovim](https://www.reddit.com/r/neovim/comments/14pvyo4/why_is_nobody_using_coc_anymore/)
	4. [2023 年 vim 的 C/C++ 配置 | 工欲善其事,必先利其器](https://martins3.github.io/My-Linux-Config/docs/nvim.html#language-server-protocal)