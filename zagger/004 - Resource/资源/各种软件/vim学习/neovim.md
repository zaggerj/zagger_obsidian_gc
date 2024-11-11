---
tags: 资源/软件安装
created: 2023-11-03T22:29
updated: 2023-11-17 22:30:31
---
# 1. neovim

# 2. 安装neovim (推荐)

```js
apt remove neovim 
cd ~
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz
rm -rf nvim-linux64.tar.gz
cd /usr/bin
ln -s  ~/nvim-linux64/bin/nvim ./nvim
```

# 3. neovim安装（ubuntu 22.04） 最终安装是 7版本，不够用 （废弃）

　　https://github.com/neovim/neovim/wiki/Installing-Neovim#[ubuntu](https://so.csdn.net/so/search?q=ubuntu&spm=1001.2101.3001.7020)

　　稳定版本

```
sudo add-apt-repository ppa:neovim-ppa/stable
```

　　更新源并安装

```
sudo apt-get update
sudo apt-get install neovim
```

　　查看版本  
​![在这里插入图片描述](https://img-blog.csdnimg.cn/8c3e6bfc7003459aba8fe98cf272c235.png)​

　　‍
