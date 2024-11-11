---
alias:
tags: 长青笔记
cdate: 2024-08-19 10:21
uid: 20240819102105
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. linux安装最新neovim

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2024-08-19 Monday 10:21:04

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

```bash
sudo apt remove neovim
wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz
rm -rf nvim-linux64.tar.gz
cd /usr/bin
ln -s ~/nvim-linux64/bin/nvim nvim


```

Failed to run `config` for telescope-fzf-native.nvim

...m/lazy/telescope.nvim/lua/telescope/_extensions/init.lua:10: 'fzf' extension doesn't exist or isn't installed: ...hare/nvim/lazy/telescope-fzf-native.nvim/lua/fzf_l
ib.lua:11: /root/.local/share/nvim/lazy/telescope-fzf-native.nvim/lua/../build/libfzf.so: 无法打开共享目标文件: 没有那个文件或目录

# 2. stacktrace:
  - /telescope.nvim/lua/telescope/_extensions/init.lua:10 _in_ **load_extension**
  - /telescope.nvim/lua/telescope/_extensions/init.lua:62 _in_ **load_extension**
  - .config/nvim/lua/plugins.lua:217 _in_ **config**


# 3. 报错
`rest.nvim lua version 5.1 needed but found Lua 5.4.7`

```bash
sudo apt-get install lua5.1
```
```bash
Error detected while processing /root/.config/nvim/init.vim:
line   26:
E5108: Error executing lua /root/.config/nvim/lua/plugins.lua:7: module 'lazy' not found:
        no field package.preload['lazy']
        no file './lazy.lua'
        no file '/home/runner/work/neovim/neovim/.deps/usr/share/luajit-2.1/lazy.lua'
        no file '/usr/local/share/lua/5.1/lazy.lua'
        no file '/usr/local/share/lua/5.1/lazy/init.lua'
        no file '/home/runner/work/neovim/neovim/.deps/usr/share/lua/5.1/lazy.lua'
        no file '/home/runner/work/neovim/neovim/.deps/usr/share/lua/5.1/lazy/init.lua'
        no file './lazy.so'
        no file '/usr/local/lib/lua/5.1/lazy.so'
        no file '/home/runner/work/neovim/neovim/.deps/usr/lib/lua/5.1/lazy.so'
        no file '/usr/local/lib/lua/5.1/loadall.so'
stack traceback:
        [C]: in function 'require'
        /root/.config/nvim/lua/plugins.lua:7: in main chunk
        [C]: in function 'require'
        [string ":lua"]:14: in main chunk
Error detected while processing /root/.config/nvim/init.vim[41]../root/.config/nvim/mysettings/ngconsole.vim[13]..function TrySwitchTheme:
line    7:
E185: Cannot find color scheme 'catppuccin-latte'
```
重启nvim 解决

有时候如果依赖很多没有安装 ，需要删除安装数据，重新安装即可。
# 4. checkheath
## 4.1. luarocks
```bash
#https://github.com/luarocks/luarocks/wiki/Installation-instructions-for-Unix
# First, ensure that you have development tools installed on your system, otherwise run the command below to install them.
sudo apt install build-essential libreadline-dev unzip
# https://www.lua.org/ftp/
curl -R -O https://www.lua.org/ftp/lua-5.4.7.tar.gz
tar -zxf lua-5.4.7.tar.gz
cd lua-5.4.7
make linux test
sudo make install

wget https://luarocks.github.io/luarocks/releases/luarocks-3.11.1.tar.gz
tar -zxvf luarocks-3.11.1.tar.gz
cd luarocks-3.11.1/
./configure --with-lua-include=/usr/local/include
make
make install
```

## 4.2. rg ripgrep

```bash
# https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation
sudo apt-get install ripgrep
```
## 4.3. fd

```bash
# https://github.com/sharkdp/fd?tab=readme-ov-file#installation
apt install fd-find
```

## 4.4. ubuntu 清空安装插件数据  重新安装
```bash
rm -rf ~/.config/nvim 
rm -rf ~/.local/share/nvim
```

## 4.5. nvim 库
[LinHQ1999/nvim-config (github.com)](https://github.com/LinHQ1999/nvim-config)
# 5. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
