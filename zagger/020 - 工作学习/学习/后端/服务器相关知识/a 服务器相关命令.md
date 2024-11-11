---
tags:
  - linux
  - 命令/linux/集合
  - 命令
aliases:
  - 服务器命令集合
created: 2023-11-03T22:29
updated: 2023-11-28 15:28:24
---
### 0.1.1. 服务状态
```bash
排查发现/8081/api/nodes/status接口一直没有响应返回

然后查看/var/log/vdi/compute.log日志发现日志最后时间一直停留在2024-10-18 10:35:25.364，然后重启了服务就好了
```
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20241029090827.png)

### 0.1.2. 服务器服务状态

```bash
less /etc/thor/log/thorconsole.log

systemctl status thor-websocketgo.service

// 可用内存不足 查看哪些服务被kill
dmesg -T | grep out 

systemctl status vdi-scheduler
```

### 0.1.3. 拿到数据库root密码

```bash
crudini --get /etc/auxo/server-config.conf db password
```

### 0.1.4. plink

```bash
plink -l "root" -pw "ServerR00t" -P "10240" "172.21.65.145" -batch
```

### 0.1.5. 多媒体 账号切换

```bash
sudo su 
sudo vi ~/.config/common-electron/logs/main.log

# MMC_SERVER_BIN 通常 是/opt/mmc-server/bin 加上服务器的两个json文件
MMC_SERVER_BIN/electron/common-electron --no-sandbox --disable-gpu
/opt/mmc-server/bin/electron/common-electron --no-sandbox --disable-gpu

```

### 0.1.6. sto  ssh linux bash

```bash
function sto() {
  ARGS=$(getopt -o u:p:xr -l user:,password:,uos,help -- "$@")
  # [[ $? -ne 0 ]] && usage
  eval set -- "$ARGS"
  local SSH_USERNAME
  local SSH_PASSWORD
  local ADDRESS
  while true; do
    case "$1" in
      -r)
        SSH_USERNAME="root"
      ;;
      -x)
        DEBUG=1
      ;;
      --uos)
        UOS=1
      ;;
      -u | --user)
        SSH_USERNAME="$2"
        shift
      ;;
      -p | --password)
        SSH_PASSWORD="$2"
        shift
      ;;
      -h | --help)
        usage
        exit 0
      ;;
      --)
        ip="$2"
        shift
        break
      ;;
    esac
    shift
  done
  if [[ ${DEBUG} -eq 1 ]]; then
    set -x
  fi
  if [[ ${UOS} -eq 1 ]]; then
    SSH_PASSWORD=${SSH_PASSWORD:-'Uos123$%^'}
  fi
  
  SSH_USERNAME=${SSH_USERNAME:-'Cloud_r00t'}
  if [[ "$SSH_USERNAME" == "root" ]]; then
    SSH_PASSWORD=${SSH_PASSWORD:-'serverroot'}
    elif [[ "$SSH_USERNAME" == "root" ]]; then
    SSH_PASSWORD=${SSH_PASSWORD:-'Vdi&Voi@r00t'}
  fi
  SSH_PASSWORD=${SSH_PASSWORD:-'Vdi&Voi@r00t'}
  
  ADDRESS=$(python3 -c "ip='$ip';print('.'.join(list(map(str,reversed([201,16,172][len(ip.split('.'))-1:])))+ip.split('.')))")
  # -n测试"$name"是否具有非零长度
  if [[ -n "${SSH_PASSWORD}" ]]; then
    sshpass -p "${SSH_PASSWORD}" ssh "${SSH_USERNAME}"@"${ADDRESS}" -o StrictHostKeyChecking=no
  else
    ssh "${SSH_USERNAME}"@"${ADDRESS}" -o StrictHostKeyChecking=no
  fi
  if [[ ${DEBUG} -eq 1 ]]; then
    set +x
  fi
}
alias sto='sto'
```

### 0.1.7. sto plink windows bash

```bash
function sto() {
  ARGS=$(getopt -o u:p:dxr -l user:,password:,docker,uos,help -- "$@")
  # [[ $? -ne 0 ]] && usage
  eval set -- "$ARGS"
  local SSH_USERNAME
  local SSH_PASSWORD
  local ADDRESS
  local PORT=22
  while true; do
    case "$1" in
      -d)
        PORT="10240"
      ;;
      -r)
        SSH_USERNAME="root"
      ;;
      -x)
        DEBUG=1
      ;;
      --uos)
        UOS=1
      ;;
      -u | --user)
        SSH_USERNAME="$2"
        shift
      ;;
      -p | --password)
        SSH_PASSWORD="$2"
        shift
      ;;
      -h | --help)
        usage
        exit 0
      ;;
      --)
        ip="$2"
        shift
        break
      ;;
    esac
    shift
  done
  if [[ ${DEBUG} -eq 1 ]]; then
    set -x
  fi
  if [[ ${UOS} -eq 1 ]]; then
    SSH_PASSWORD=${SSH_PASSWORD:-'Uos123$%^'}
  fi
  
  SSH_USERNAME=${SSH_USERNAME:-'Cloud_r00t'}
  if [[ "$SSH_USERNAME" == "root" ]]; then
    SSH_PASSWORD=${SSH_PASSWORD:-'ServerR00t'}
    elif [[ "$SSH_USERNAME" == "root" ]]; then
    SSH_PASSWORD=${SSH_PASSWORD:-'Vdi&Voi@r00t'}
  fi
  SSH_PASSWORD=${SSH_PASSWORD:-'Vdi&Voi@r00t'}
  # echo "ip:${ip}" 确保安装好 python3 scoop install python -g
  ADDRESS=$(python3 -c "ip='$ip';print('.'.join(list(map(str,reversed([65,21,172][len(ip.split('.'))-1:])))+ip.split('.')))")
  # -n测试"$name"是否具有非零长度
  if [[ -n "${SSH_PASSWORD}" ]]; then
    # sshpass -p "${SSH_PASSWORD}" ssh "${SSH_USERNAME}"@"${ADDRESS}" -o StrictHostKeyChecking=no
    # 假设使用 plink 代替 sshpass 和 ssh
    # echo "ADDRESS:${ADDRESS} SSH_USERNAME:${SSH_USERNAME} SSH_PASSWORD:${SSH_PASSWORD}"
    plink -l "${SSH_USERNAME}" -pw "${SSH_PASSWORD}" -P "${PORT}" "${ADDRESS}" -batch
  else
    ssh "${SSH_USERNAME}"@"${ADDRESS}" -o StrictHostKeyChecking=no
  fi
  if [[ ${DEBUG} -eq 1 ]]; then
    set +x
  fi
}
alias sto='sto'
sto -rd 145
```

### 0.1.8. 多媒体命令

```bash
sudo rm -rf app.asar /opt/mmc-server/bin/electron/resources/app.asar;wget http://172.21.15.105:8081/packages/common-electron/dist/linux-unpacked/resources/app.asar;sudo cp app.asar /opt/mmc-server/bin/electron/resources/


# 解决登录界面，无法进入主界面，从devtool中查看，接口 返回code:1 的问题
rm -f  /opt/mmc-server/bin/*.pid


```

### 0.1.9. 服务器10240

```bash
# docker run -it vpc bash 再次重新创建新容器 重新创建时，出现问题，找到了vpc的代码
docker ps -a 找不到 容器定端口
docker exec -it vpc bash # 进入容器 没问题
# 10240 进去的不在容器内

```

# 1. 共享目录

周政学 7-25 10:15:06  
用 oseasy/123456连 就是主目录  
  
周政学 7-25 10:15:07  
root进去 需要使用这个目录
`/usr/local/vsftpd-compose/vsftpd/data/oseasy`

# 2. ubuntu

```bash
# 配置root 密码 
sudo passwd root #切换root,同时设置root密码

# 172.21.15.106 网络认证 找明群力放开了限制，
# 配置 一键切换到清华大学镜像 ubuntu 22.04镜像
sudo bash -c "cat << EOF > /etc/apt/sources.list && apt update deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse EOF"

# 之后下载安装 都很顺利 网络认证搞定之后到 apt upgrade 安装完成 一共花了10分钟 
apt upgrade

# 开始搞定clash 未搞定

# 安装fnm https://github.com/Schniz/fnm
# 安装cargo
apt-get install cargo
# 安装 fnm 使用当前账号的 cargo 配置 如果加上sudo 就好像使用了 root用户的cargo配置了
cargo install fnm

1、进入 %USERPROFILE%\.cargo 目录
vim ~/.cargo/config

2、新建config文件，内容如下

[source.crates-io]
replace-with = 'tuna'

[source.tuna]
registry = "https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git"

# cargo添加到环境变量中
export PATH=$PATH:/root/.cargo/bin
fnm install 18
# 配置 fnm 所需的环境变量到 bash 或 zsh 配置文件中
fnm env --use-on-cd >> ~/.bashrc
source ~/.bashrc
# error: We can't find the necessary environment variables to replace the Node version.
You should setup your shell profile to evaluate `fnm env`, see https://github.com/Schniz/fnm#shell-setup on how to do this
Check out our documentation for more information: https://fnm.vercel.app
# 是因为没有fnm env --use-on-cd >> ~/.bashrc source ~/.bashrc

# 配置npm npm设置国内镜像
npm config set registry https://registry.npmmirror.com
npm i -g pnpm
# npm 安装 yarn
npm i -g yarn
npm i -g nrm
npm i -g yrm
nrm use taobao
yrm use taobao
git config --global user.email "huangzijie@os-easy.com"
git config --global user.name "pkg_manager"
# 仅使用pnpm 即可 查询当前使用的镜像源
pnpm get registry
# 设置为淘宝镜像源
pnpm config set registry https://registry.npmmirror.com/
# 还原为官方镜像源
pnpm config set registry https://registry.npmjs.org/

pnpm install --prefer-offline --frozen-lockfile --ignore-scripts

xrandr
Screen 0: minimum 0 x 0, current 1920 x 1080, maximum 32768 x 32768
default connected primary 1920x1080+0+0 507mm x 285mm
   1920x1080      0.00* 
xrandr --output HDMI-1 --mode 1920x1080
warning: output HDMI-1 not found; ignoring
# yarn 安装问题解决 
yarn
yarn install v1.22.22
[1/4] Resolving packages...
warning watchify > chokidar > fsevents@1.2.13: The v1 package contains DANGEROUS / INSECURE binaries. Upgrade to safe fsevents v2
[2/4] Fetching packages...
info There appears to be trouble with your network connection. Retrying...
error Error: certificate has expired
    at TLSSocket.onConnectSecure (node:_tls_wrap:1539:34)
    at TLSSocket.emit (node:events:513:28)
    at TLSSocket._finishInit (node:_tls_wrap:953:8)
    at TLSWrap.ssl.onhandshakedone (node:_tls_wrap:734:12)
info Visit https://yarnpkg.com/en/docs/cli/install for documentation about this command.

最终 删除yarn.lock文件解决此问题，只要有lock文件，就无法解决这个问题。nvim

# 创建用户
useradd zagger1
passwd zagger2

# 查看用户是否创建好了
cat /etc/passwd

# 使用账号zagger1同时登录系统
ssh zagger1@ip
# 输入密码
# 登录系统 在/home/zagger1 目录 
# 创建一个文件
touch 123.txt
mv 123.txt /tmp/
# 查看文件权限
ls -l 
# 当前用户可以读写 所在组可以读写 非当前用户所在组的其他用户只读

# 其他用户zagger2 登录系统
# 切换到 /tmp 目录
# zagger2可以 读123.txt 
cat 123.txt

# 切换到用户zagger1 
vi /tmp/123.txt 
# 添加一段话 xxxx
# zagger2 可以读到

# zagger1 中 使用 chmod change mode 修改文件属性
# ugo权限体系
# rw-  r--   r--
# user group other
# 去掉所有用户的 可取权限
chmod -r 123.txt
# 所属谁的文件 谁就可以 修改属性
# 只去掉 o 的 可读权限
chmod o-r

# 可执行权限：能执行的命令文件
# ls pwd 这些指令 都对应着命令文件
ls /bin
ls -l /
# /bin -> /usr/bin
cp /usr/bin/ls /tmp/xxxx
cd /tmp
xxx # 不能执行 去系统的/usr/bin/xxx 找不到
./xxx # 相对路径或者绝对路径 可以执行

# 同时取消g 和o 的可执行权限
chmod g-x,o-x

# nvim https://github.com/LinHQ1999/nvim-config/tree/office
# 需要安装最新的nvim

```

[Ubuntu开启root登录和SSH远程登录_ubuntu root ssh远程登录-CSDN博客](https://blog.csdn.net/chuanyu/article/details/139956839)
[ubuntu | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirror.tuna.tsinghua.edu.cn/help/ubuntu/)
[Beijing University of Posts and Telecommunications : Ubuntu (launchpad.net)](https://launchpad.net/ubuntu/+mirror/mirrors.bupt.edu.cn-release)

### 2.1.1. linux  配置代理

[clash 原生客户端命令行教程（推荐） | AgentNEO 配置说明文档 (neodocs.co)](https://www.neodocs.co/others/clash-yuan-sheng-ke-hu-duan-ming-ling-hang-jiao-cheng-tui-jian)

```bash
# proxy
# default socks5
alias setproxy="export ALL_PROXY=socks5://127.0.0.1:7890"
# company socks5 ssh tunnel
alias setproxy1="export ALL_PROXY=socks5://59.175.233.194:8181"
# reset proxy
alias unsetproxy="unset ALL_PROXY"



# proxy
# default socks5
alias setproxy="export ALL_PROXY=socks5://127.0.0.1:7890;export http_proxy=http://127.0.0.1:7890;export https_proxy=http://127.0.0.1:7890"
# company socks5 ssh tunnel
alias setproxy1="export ALL_PROXY=socks5://59.175.233.194:8181"
# reset proxy
alias unsetproxy="unset ALL_PROXY;unset http_proxy;unset https_proxy;"

```

[[clash 原生客户端命令行教程]]

### 2.1.2. linux 安装 fnm 失败

![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240819101928.png)

linux 配置好了代理 还是有问题
[[linux安装fnm]]

### 2.1.3. ubuntu安装最新neovim

```bash
apt install fzf
```

# 3. linux系统安装

[archlinux 硬盘to go-哔哩哔哩_bilibili](https://search.bilibili.com/all?vt=62127697&keyword=archlinux%20%E7%A1%AC%E7%9B%98to%20go&from_source=webtop_search&spm_id_from=&search_source=5)
[Arch + Gnome = 极致丝滑_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1dH4y1S7ob/?spm_id_from=333.788&vd_source=af94dc11f0a1751ebb3c2090844ad9f6)
[GRUB - Arch Linux 中文维基 (archlinuxcn.org)](https://wiki.archlinuxcn.org/wiki/GRUB)
[arch Linux 安装到移动硬盘_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1jW411E7At/?spm_id_from=..search-card.all.click&vd_source=af94dc11f0a1751ebb3c2090844ad9f6)
[买了个移动硬盘,装一个"Linux To Go",记录一下_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1xr421n7Xw/?spm_id_from=..search-card.all.click&vd_source=af94dc11f0a1751ebb3c2090844ad9f6)
[将ArchLinux装进U盘，口袋便携系统_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1i7411W7GP/?spm_id_from=..search-card.all.click&vd_source=af94dc11f0a1751ebb3c2090844ad9f6)
[【网络安全】拜托三连了！这绝对是全B站最用心（没有之一）的Linux学习教程！_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1P4421U7Ky/?spm_id_from=333.1007.tianma.6-2-20.click&vd_source=af94dc11f0a1751ebb3c2090844ad9f6)
[将ArchLinux装进U盘，口袋便携系统_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1i7411W7GP/?spm_id_from=..search-card.all.click&vd_source=af94dc11f0a1751ebb3c2090844ad9f6)
[arch-usb-installer/USB.sh at master · Gso650/arch-usb-installer (github.com)](https://github.com/Gso650/arch-usb-installer/blob/master/USB.sh)
[P4.为你的Linux加上一个桌面吧_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1RE411G796/?p=4&spm_id_from=pageDriver&vd_source=af94dc11f0a1751ebb3c2090844ad9f6)
[Arch Linux 详细安装教程，萌新再也不怕了！「2023.10」 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/596227524)
[Index of /archlinux/iso/latest/ | 北京外国语大学开源软件镜像站 | BFSU Open Source Mirror](https://mirrors.bfsu.edu.cn/archlinux/iso/latest/)
[详解在移动硬盘上安装 ArchLinux 教程_IT技术分享博客 (wordc.cn)](http://seo.wordc.cn/wap/contentlp.asp?id=1750)
[安装指南 - Arch Linux 中文维基 (archlinuxcn.org)](https://wiki.archlinuxcn.org/wiki/%E5%AE%89%E8%A3%85%E6%8C%87%E5%8D%97)
[ArchLinux环境 - Bannirui Blog](https://bannirui.github.io/2024/05/01/Linux/ArchLinux%E7%8E%AF%E5%A2%83/)
[【万字详细教程】Linux to go——装在移动硬盘里的Linux系统（Ubuntu22.04）制作流程；一口气解决系统安装/引导文件迁移/显卡驱动安装等问题-CSDN博客](https://blog.csdn.net/m0_64545111/article/details/136131918)
[全新移动硬盘装机全教程（硬盘安装便携linux系统）_移动硬盘安装linux-CSDN博客](https://blog.csdn.net/m0_67441224/article/details/132296069)
[Release Release v0.82.1 · microsoft/PowerToys (github.com)](https://github.com/microsoft/PowerToys/releases/tag/v0.82.1)

[【万字详细教程】Linux to go——装在移动硬盘里的Linux系统（Ubuntu22.04）制作流程；一口气解决系统安装/引导文件迁移/显卡驱动安装等问题-CSDN博客](https://blog.csdn.net/m0_64545111/article/details/136131918)
[linux操作系统引导过程_linux引导过程-CSDN博客](https://blog.csdn.net/m0_67497257/article/details/137748765)
[安装ArchLinux到U盘 - 专题 - 简书 (jianshu.com)](https://www.jianshu.com/c/e2f45b070551)
[[Linux]将ArchLinux安装到U盘 - 千松 - 博客园 (cnblogs.com)](https://www.cnblogs.com/ThousandPine/p/17219617.html)
[Archlinux个人安装流程_archlinux安装教程2023-CSDN博客](https://blog.csdn.net/xinxiaoyu_/article/details/129257241)

[arch Linux安装至U盘(兼容UEFI和BIOS启动)_archlinux安装到u盘-CSDN博客](https://blog.csdn.net/scarecrow_sun/article/details/125110808)
[flameshot-org/flameshot: Powerful yet simple to use screenshot software :camera_flash: (github.com)](https://github.com/flameshot-org/flameshot?tab=readme-ov-file#windows)
[Downloads – Oracle VM VirtualBox](https://www.virtualbox.org/wiki/Downloads)
[【网络安全】全方位讲解Linux操作系统，网络安全工程师一定要收藏！_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1Kf421q7S3/?spm_id_from=333.1007.tianma.4-1-11.click&vd_source=af94dc11f0a1751ebb3c2090844ad9f6)

# 4. 防火墙问题

```bash
cp /etc/auxo/public.xml /etc/firewalld/zones/public.xml
systemctl restart firewalld.service
```

# 5. electron 安装问题

 #electron安装 ELECTRON_MIRROR="<https://npmmirror.com/mirrors/electron/>" pnpm i --verbose  --unsafe-perm=true，解决问题，问题如下

# 6. git tag

修改 tag 为 带注释消息的 tag
`git tag -f -a v1.0 -m "updated version 1.0"`

# 7. idp下载问题（不支持没有外网的环境）

`sed -i -e 's#mystorp.gitee.io/static#新的地址#g' /var/www/html/js/libs/oeidp/oeidp.*`

`sed -i -e 's#mystorp.gitee.io/static#ecloud.os-easy.com.cn/static/#g' /var/www/html/js/libs/oeidp/oeidp.*`

`sed -i -e 's#mystorp.gitee.io/static#ecloud.os-easy.com.cn/static/#g' /var/www/html/js/libs/spice/oevdi.min.js`

`sed -i -e "s#mystorp.gitee.io\/static#ecloud.os-easy.com.cn\/static\/#g" "/var/www/html/js/libs/spice/oevdi.*"`

项目中替换文本
weboeidp
`sed -i -e "s#mystorp.gitee.io\/static#ecloud.os-easy.com.cn\/static\/#g" js/libs/oeidp/oeidp.*`
webspice
`sed -i -e "s#mystorp.gitee.io\/static#ecloud.os-easy.com.cn\/static\/#g" js/libs/spice/oevdi.*`

# 8. rustdesk `198793Peng` `284 037 269`

# 9. nova

```bash
nova get-vnc-console {uuid} novnc
```

# 10. patch windows上出错了 估计是换行符问题导致出错了 实测linux上创建文件，然后diff 之后patch是没有问题的

[（原）patching file 出现 Hunk #1 FAILED at xxx(different line endings). - lihaiping - 博客园](https://www.cnblogs.com/lihaiping/p/15895156.html)
windows上用`patch -l --binary tea.md tea.patch`，参考链接：[tag - 我如何在Windows上應用diff補丁?](https://code-examples.net/zh-TW/q/7e489)| [使用diff和patch命令协同开发 | 良许嵌入式](https://www.lxlinux.net/e/linux/linux-diff-patch.html#%E6%A0%B9%E6%8D%AE%E5%B7%AE%E5%BC%82%E5%88%9B%E5%BB%BApatch%E6%96%87%E4%BB%B6)
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240116140851.png)

# 11. `grep '需求\|bug' ./src/components/gateway/*.vue`

这里需要注意的是，始终要用单引号将正则表达式括起来，因为单引号内的内容原样输出，被单引号括起的内容不管是常量还是变量不会发生替换。

使用基本正则表达式时，元字符被解释为字面字符。要保留元字符的特殊含义，必须用反斜杠（ \ ）对它们进行转义。这就是为什么我们要转义 **OR** 运算符（**|**）。

![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240116110108.png)
[如何使用Grep命令查找多个字符串 | 良许嵌入式](https://www.lxlinux.net/e/linux/find-multiple-strings-using-grep-command.html)

# 12. 图标和字体存在iconfont

[iconfont-阿里巴巴矢量图标库](https://www.iconfont.cn/notifications?tab=official)

# 13. 修改`VDI`端版权信息

`VDI`端内容主要是通过下载服务器上的zip包资源来更新的，需要访问服务器中指定路径去更改zip包内容来修改文案。

步骤如下：
![cfbfd259d63724896d66e3dd55011dd7.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/cfbfd259d63724896d66e3dd55011dd7.png)

1. 访问服务器路径：`/opt/iso/iso/zip/`

   ```bash
   # 进入zip目录
   cd /opt/iso/iso/zip/
   # 查看文件列表
   ls
   
   # .
   # ├── e-vdi.zip  # VDI端资源包
   # └── md5.ini
   ```

2. 备份`e-vdi.zip`文件

   ```bash
   cp e-vdi.zip e-vdi-bak.zip
   ```

3. 解压`e-vdi.zip`

   ```bash
   unzip -o -q e-vdi.zip -d tempEVdi
   # 命令含义
   # unzip 解压命令
   # -o 覆盖
   # -q 不输出到屏幕
   # -d 输出到指定命名的目录 可自定义
   ```

4. 修改资源文件，找到`client.js`进入文件内，搜索噢易相关字样并进行替换

   ```bash
   # 进入目录
   cd tempEVd
   # 修改资源文件
   vi client.js
   # 按下/
   # 输入噢易 按下回车找到对应资源
   # 如果第一个不是，那么按下n跳转到下一个匹配项
   # 找到之后按i 进入编辑模式
   # 通过光标定位 修改噢易为烽火
   # 按下esc
   # 按下: 输入wq 保存并退出文件
   ```

   ![image-20230922180106746](http://cdn.chhhh.cn/image-20230922180106746.png)
[unix - zip压缩文件夹 - Zip命令不包括压缩目录本身](https://code-examples.net/zh-CN/q/376457)
5. 重新压缩文件，并生成对应`md5`值，填写到对应配置文件中保存即可完成`VDI`端文案修改。

   ```bash
   # 退出当前目录
   cd ..
   # 删除当前资源e-vdi.zip
   rm -rf e-vdi.zip
   # 压缩修改后的目录
   cd tempEVdi && zip -r ../e-vdi.zip *
   # zip -r e-vdi.zip tempEVdi 这个命令有坑
   # 获取压缩包md5值
   md5sum e-vdi.zip
   # ed0c6d3f3a823e1a0ea7da9302086911
   # 将出现的md5值 复制放到同级的md5.ini文件中
   
   # 修改md5.ini文件
   vi md5.ini
   
   e-vdi = ed0c6d3f3a823e1a0ea7da9302086911
   # 保存文件即可
   
   # 修改/etc/thor/version文本内的md5内容
   cd /etc/thor
   vi version
   # 找到最下方的[lang]中的e-vdi =xxxx
   # 修改 e-vdi = ed0c6d3f3a823e1a0ea7da9302086911
   # 保存文件即可
   ```

6. 重启`VDI`端即可查看更新后的内容

# 14. spice排查问题

1. 查找6082是否被代理了，`grep -rn '6082' /etc/nginx/**/*.conf`
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240103162220.png)
2. 排查防火墙端口是否放开了，`firewall-cmd --list-ports | grep -rn '6082'`
3. ip和浏览器ip是否一致，如果不一致，多半是网络原因需要后端排查网络，通过本地ping下spice连接的ip。

# 15. 远程

1. [隧道列表 - Cpolar](http://localhost:9200/#/tunnels/list)
2. [cpolar - secure introspectable tunnels to localhost](https://dashboard.cpolar.com/get-started)

# 16. 忽略lint-staged

`git commit --no-verify -m 'fix: 1. 退出登录报错问题 2. loadLanguageAsync在初始化vue实例之前调用 3.解决eslint报错`

# 17. 查看盘使用情况

![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231110153702.png)

# 18. 禁用canvas鼠标右键功能

```js
idpCanvas.oncontextmenu = (e) => {
      e.preventDefault()
      e.stopPropagation()
      return false
    }
```

# 19. windows git bash 中 查询端口占用 并干掉

`netstat -ano | grep 9527|awk '{print $5}' | xargs kill -9`
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian20231109165847.png)

```shell
ps -ef | grep mysql
netstat -tunlp | grep mysql
mysql -u oseasy
mysql -u oseasy -p cloudhan
mysql -u oseasy -pcloudhan
service firewalld restart
python /var/www/console/thor-console.pyc shell
service vdi-* restart
vdi-thor-gunicorn restart
python /var/www/console/thor-console.pyc shell
service vdi-thor-gunicorn restart
```

# 20. 快速清空工作区 #clean #empty

`git checkout -- .;git clean -fd;`

# 21. mac干掉不要的文件 #find #\.DS_Store

`find . -type f -name ".DS_Store" | xargs rm -rf`

# 22. 查看etc目录占用比较大的目录

```shell
du -h /etc | grep G
```

![[Pasted image 20231018111633.png]]

# 23. 跳过检查
> git commit --no-verify
# 24. 终端快捷键
ctrl+u
ctrl+k
ctrl+a
ctrl+e
![[Pasted image 20231017180331.png]]

复制spice-web-client代码到console仓库，cp -rv

```shell
# cwd code
cp -rv ./spice-web-client/dist/** ./ngconsole/js/libs/spice/ &&
 cp -rv ./spice-web-client/oeidp/** ./ngconsole/js/libs/oeidp/

# cwd spice-web-client
cp -rv ./dist/** ../ngconsole/js/libs/spice/ &&
 cp -rv ./oeidp/** ../ngconsole/js/libs/oeidp/

```

![[%_~DHG9[WVG9Y`D%~_HRHXO.png]]

xshell5登录[欧拉](https://so.csdn.net/so/search?q=%E6%AC%A7%E6%8B%89&spm=1001.2101.3001.7020)22.03时报错：找不到匹配的host key 算法
[Xshell5登录报“找不到匹配的host key 算法“的错误_mosaicwang的博客-CSDN博客](https://blog.csdn.net/mosaicwang/article/details/131693377?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-131693377-blog-129684562.235%5Ev38%5Epc_relevant_sort_base3&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-131693377-blog-129684562.235%5Ev38%5Epc_relevant_sort_base3&utm_relevant_index=1)

```bash
tar -zcvf "$output_zip_file" $files
tar -zxvf update_2023-09-21.tar.gz
tar -zxvf ./patch/update_2023-09-21.tar.gz -C update
```

[Linux中tar归档命令、zip压缩、gzip压缩、bzip2压缩_linux tar_欢喜躲在眉梢里的博客-CSDN博客](https://blog.csdn.net/m0_52165864/article/details/123998531)
[Linux笔记06-压缩解压命令_tar -zcf_浮尘笔记的博客-CSDN博客](https://blog.csdn.net/rxbook/article/details/106059408)

```bash
sudo lsof -i :端口号
```

# 25. 外网环境搭建

```bash
# 大家测试外网映射功能如果没有环境的话也可以通过ssh的方式实现  
ssh -L 0.0.0.0:1443:172.16.65.143:443 -NC root@172.16.65.143  
  
# 上面的的命令就是把本地的65.145上面的1443端口的流量转发到了143环境的443端口，模拟的就是在路由器上面设置了一个端口映射1443 到443

# 业务层接口连上
ssh -L 0.0.0.0:1443:172.16.65.143:443 -NC root@172.16.65.143
# webspice接口连上
ssh -L 0.0.0.0:6082:172.16.65.143:6082 -NC root@172.16.65.143

# 连上桌面后，断开一次业务层的通道
# 即可模拟业务层接口断开，但是spice连上在

```

![[Pasted image 20230901094555.png]]

# 26. 修改服务器时间

```bash
# 设置服务器时间
date -s "20220622 14:30:22"
# 同步服务器时间
yum install ntpdate
ntpdate -u cn.pool.ntp.org  
```

# 27. shutdown

```bash
shutdown -r -t 5
```

```

[[汇总所有在线文档#^548d59|spice build]]

```js
yarn build
cp dist/oevdi.min.js ../ngconsole/js/libs/spice/
```

^b70ed2

[authorized_key – Adds or removes an SSH authorized key — Ansible Documentation](https://docs.ansible.com/ansible/2.9/modules/authorized_key_module.html)

# 28. idp服务器配置文件

```bash
> http://172.16.65.147/
> oseasy@147
> /etc/thor/thor.conf
> oeidp.enable= false
```

# 29. wsl2

[WSL2 配置代理 - 哔哩哔哩 (bilibili.com)](https://www.bilibili.com/read/cv22203257/)

```bash
> wsl --web-download
> wsl 安装 wsl2 wsl --update --web-download # WSL 安装发行版 wsl --install -d Ubuntu-22.04 --web-download
```

　　‍

# 30. 终端业务

[终端连桌面业务详解--ShowDoc](http://192.168.0.161:4999/web/#/3/3848)

## 30.1. token 失效条件

​![image](40%20-%20Obsidian/附件/Attachment/assets%206-zagger/image-20230706085205-41m19po.png)​

## 30.2. 局域网追踪网络走向命令

　　​![image](40%20-%20Obsidian/附件/Attachment/assets%206-zagger/image-20230705084016-l62i7y8.png)​

　　局域网电脑中使用 58.48.71.131 连接，走到了局域网网关，然后直接 58.48.71.131 完成

```bash
tracert 58.48.71.131
```

# 31. 部署前端文档 #上传

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.0.161
scp -r dist/* root@192.168.0.161:/usr/share/nginx/html/fedoc
```

# 32. consoleui 打包 bash 命令 #上传

```bash
PV=$(node -p 'require("./package.json").version')
tar cf $PV.tar.gz consoleui/package.json consoleui/dist
scp -r 0.0.106.tar.gz root@192.168.0.161:/usr/local/vsftpd-compose/vsftpd/data/oseasy/trunk/console_ui
```

# 33. 服务器代码 #上传 | [[汇总所有在线文档#^ce3eb8|scp]]

```bash
scp -r js built resources views  css fonts includes view-front img init.html Cloud_r00t@172.16.201.47:/var/www/html                
scp -r js built resources views  css fonts includes view-front img init.html Cloud_r00t@172.16.65.151:/var/www/html
scp -r js built resources views  css fonts includes view-front img init.html root@172.16.65.143:/var/www/html
scp -r js built resources views  css fonts includes view-front img init.html tspace_path.json root@172.16.65.145:/var/www/html

# 5.6.1是docker版本：欧拉 系统 里面 docker版的 centos 系统 部署的服务器
#10240端口  
# root  
scp -P 10240 -r js built resources views  css fonts includes view-front img init.html tspace_path.json root@172.21.65.148:/var/www/html
ssh -p 10240 root@172.21.65.148
ssh root@172.21.65.148 oseasy@123早的 ServerR00t晚的
docker images
docker ps

ServerR00t
Vdi&Voi@r00t
```

^e6bdc2

# 34. ssh 服务器代码 #上传 windows

```bash
scp -r dist/* root@172.16.101.22:/var/www/edaas/
scp -r js built resources views  css fonts includes view-front img init.html root@172.16.201.120:/var/www/html
oseasy@141
```

# 35. 获取笔记本 WiFi 密码

```bash
netsh wlan show profiles name=HUAWEI-AF1UL2 key=clear 
netsh wlan show profiles name=zagger key=clear
```

# 36. 安装git报错

```bash
scoop install -g git@2.39.2.windows.1  
Could not install git@2.39.2.windows.1 
Select-CurrentVersion: D:\Applications\Scoop\apps\scoop\current\lib\core.ps1:239 
Line |  239 |      return $null -ne (Select-CurrentVersion -AppName $ app -Global:$gl …
```

　　‍

# 37. 启动weboeidpproxy服务

```bash
cd weboeidpproxy/ ./html5proxy --config=./spice.json --nova-config=/etc/nova/nova.conf
```

# 38. #修改分支名称

```bash
git branch -m oldBranchName newBranchName 
git push origin :oldBranchName 
git push --set-upstream origin newBranchName
```

# 39. #打tags

```bash
git tag -a 5.5.0-release -m '发布版本'
git push origin 5.5.0-release
git tag -l -n
# 表示自打tag以来有n次提交(commit)
git describe --tags 
# 删除远程tag
git push origin :refs/tags/v1.4-lw
git push origin --delete <tagname>

```

```bash
git describe --tags
git tag 5.3.2-vpc f6fe53e8a35c5c09a9eaab7113adc25de606ffd8 
git push --tags
```

参考链接：

1. [GIT 中如何打标签（git tag）_git打tag__Nino的博客-CSDN博客](https://blog.csdn.net/qq_21746331/article/details/120776710)
2. [git 生成版本号 git describe_我是榜样的博客-CSDN博客](https://blog.csdn.net/zhangpeng_linux/article/details/85858841)
3. [git tag 打标签（我看过最透彻的文章）_黒客与画家的博客-CSDN博客](https://blog.csdn.net/TIAN20121221/article/details/119737274)

# 40. 共享目录，voi 客户端包

```bash
ftp://172.16.227.19/CTSC%20files/%B2%FA%C6%B7%B0%E6%B1%BE/E-VOI/V5.5/VOI/5.5.0.6628/x86/
user
123456

ftp://172.16.227.19/CTSC%20files/%B2%FA%C6%B7%B0%E6%B1%BE/E-VOI/0_VOI%BD%CC%D3%FD%B0%E6/5.5.1/5.5.1-64/x86/
```

# 41. 融合客户端：设置密码

```bash
 osadmin
```

# 42. 融合端：切换命令行

```bash
C+ALT+f1-f7 切换命令行
C+ALT+f7 切回图形界面
命令行 root账号，密码3vclientroot

3v融合端 设置密码 默认为

端对端同传
网络要设置静态网络
要设置桥接模式
桌面不自动更新，不然会影响测试

虚拟机切换图形界面和命令行的快捷键
虚拟机centos：
ctrl+alt+f3：从图形界面进入命令行
ctrl+alt+f1：从命令行进入图形界面
虚拟机教育版融合终端：
ctrl+alt+f7：从命令行进入图形界面
ctrl+alt+f1：从图形界面进入命令行


虚拟机两种联网方式：
NAT+DHCP
桥接+静态地址

PING (Packet Internet Grope)，因特网包探索器
centos6.5设置桥接模式，虚拟机无法ping通宿主机，主机可以ping通虚拟机
需要解决！！！
(5条消息) 虚拟机ping不通的几种原因及解决办法_萌褚的博客-CSDN博客_虚拟机ping主机ping不通
```

# 43. weboeidp 172.19.20.119 hzj 账号

```bash
ssh Cloud_r00t@172.19.20.119
Vdi&Voi@r00t
cd weboeidpproxy
./html5proxy --config=./spice.json --nova-config=/etc/nova/nova.conf
```

# 44. weboeidp 172.16.201.136 getConnectInfo 补丁 nwy admin1

```bash
 var url = '/api/instances/connection'; var json = { instance_id: t.uuid }; s.a.post(url, json).then( function (resp) { t.instance = resp.data.instance; if (!t.instance) { return setTimeout(e, 500) } ;var data = t.instance.connect; data.port = 6082; var connectInfo = t.connectInfo; var status = connectInfo.status; if (status && status === 'ERROR') { self.onlyReset = true; return } ;t.instance = connectInfo.instance; console.log('newToken:', data.token) ;resolve(data) }, function () {} )
```

# 45. tspace 服务，服务器修改服务名称，避免其自动重启

```bash
ssh root@172.16.65.145
ServerR00t
 mv /usr/lib/venvs/vdi/bin/tspace-agent /usr/lib/venvs/vdi/bin/tspace-agent_bak
 systemctl stop tspace-agent
mv /usr/lib/venvs/vdi/bin/tspace-agent_bak /usr/lib/venvs/vdi/bin/tspace-agent
systemctl start tspace-agent
```

　　find [路径] [条件] 文件名原文链接：[https://www.linuxcool.com/find](https://www.linuxcool.com/find)

```bash
find / -name "*.mp4" -exec rm -rf {} \;
# 搜索整个路径
find . -iregex '.*client.*'
# 搜索文件名 -name 用于指定区分大小写的文件名；然后是搜索字符串。默认情况下，搜索字符串按字面意思处理：除非你使用正则表达式语法，否则 find 命令搜索的文件名正是你在引号之间输入的字符串。
find . -iname '*client*'
# 将模式使用“或”（-o）进行组合。括号需要转义，以便使 find 命令而不是 shell 程序尝试解释它们。
find . \( -iname 'jpeg' -o -iname '*png' -o -iname '*jpg' \) # 查找项目中所有图片
find . \( -iname '*jpeg' -o -iname '*jpg' \) -type f # 查看文件
find . \( -iname '*jpeg' -o -iname '*jpg' \) -type d # 查看图片
find . \( -iname '*jpeg' -o -iname '*jpg' \) -type f -mtime -7 # 一周内修改过的图片文件
# xargs 命令从标准输入流中获取参数，并基于它们执行命令。
# 假设你要将上周修改过的家目录中的所有 JPEG 文件复制到 U 盘，以便插到电子相册上。假设你已经将 U 盘挂载到 /media/photo_display
find ~ \( -iname '*jpeg' -o -iname '*jpg' \) -type f -mtime -7 -print0 | xargs -0 cp -t /media/photo_display
# 在当前目录中 root 用户拥有的文件，以及不被指定用户（在本例中为 shs）所拥有的文件。
find . -user root -ls
# 接下来的命令显示具有 777 权限的非符号链接文件：
sudo find /home -perm 777 ! -type l -ls
# 下面的命令将查找具有特定权限的文件
find . -perm 750 -ls
# 以下命令将查找大小超过千兆字节的文件
sudo find / -size +1G -ls
# find 命令是如何描述文件类型的，就可以通过文件类型来查找文件。
# b = 块设备文件
# c = 字符设备文件
# d = 目录
# p = 命名管道
# f = 常规文件
# l = 符号链接
# s = 套接字
# D = 门（仅限 Solaris）
# 我们要寻找符号链接和套接字：
find . -type l -ls
find . -type s -ls
#  inode 号来搜索文件
find . -inum 397132 -ls
# 另一种通过 inode 搜索文件的方法是使用 debugfs 命令。在大的文件系统上，这个命令可能比 find 快得多，您可能需要安装 icheck。
sudo debugfs -R 'ncheck 397132' /dev/sda1
# 我们从主目录（~）开始，限制搜索的深度（即我们将搜索子目录的层数），并只查看在最近一天内创建或修改的文件（mtime 设置）。
find ~ -maxdepth 2 -mtime -1 -ls
# 使用 -exec 选项，在您使用 find 命令找到文件后可以以某种方式更改文件。您只需参照 -exec 选项即可运行相应的命令。
find . -name runme -exec chmod 700 {} \;
find . -name runme -ls
# 在这条命令中，{} 代表文件名。此命令将更改当前目录和子目录中任何名为 runme 的文件的权限。
# 还可以通过其他条件进行搜索：文件的修改时间、所有者、权限等。
sudo find /home -user peanut # 根据用户查找文件
sudo find /home -perm 777 # 根据权限查找文件
sudo find /home -mtime +100 # 根据修改时间查找文件
sudo find /var/log -newer /var/log/syslog 通过比较修改时间查找文件
find / -type f ! -perm 777 # Find all the files without permission 777.
# Find all Read-Only files.
find / -perm /u=r
# Find all Executable files.
find / -perm /a=x
# Find all 777 permission files and use the chmod command to set permissions to 644
find / -type f -perm 0777 -print -exec chmod 644 {} \;
# 寻找重复的文件
#如果您正在清理磁盘空间，则可能需要删除较大的重复文件。确定文件是否真正重复的最好方法是使用 
# fdupes 命令。此命令使用 md5 校验和来确定文件是否具有相同的内容。使用 
# -r（递归）选项，
# fdupes 将在一个目录下并查找具有相同校验和而被确定为内容相同的文件。
# 如果以 root 身份运行这样的命令，您可能
```

# 46. 改變所屬群組, chgrp:change group

```bash
chgrp [-R] dirname/filename ...
選項與參數：
-R : 進行遞迴(recursive)的持續變更，亦即連同次目錄下的所有檔案、目錄
     都更新成為這個群組之意。常常用在變更某一目錄內所有的檔案之情況。
範例：
[root@study ~]# chgrp users initial-setup-ks.cfg
[root@study ~]# ls -l
-rw-r--r--. 1 root users 1864 May  4 18:01 initial-setup-ks.cfg
[root@study ~]# chgrp testing initial-setup-ks.cfg
chgrp: invalid group:  `testing' <== 發生錯誤訊息囉～找不到這個群組名～
```

# 47. 改變檔案擁有者, chown:change owner

```bash
chown [-R] 帳號名稱 檔案或目錄
[root@study ~]# chown [-R] 帳號名稱:群組名稱 檔案或目錄
選項與參數：
-R : 進行遞迴(recursive)的持續變更，亦即連同次目錄下的所有檔案都變更
範例：將 initial-setup-ks.cfg 的擁有者改為bin這個帳號：
[root@study ~]# chown bin initial-setup-ks.cfg
[root@study ~]# ls -l
-rw-r--r--. 1 bin  users 1864 May  4 18:01 initial-setup-ks.cfg

範例：將 initial-setup-ks.cfg 的擁有者與群組改回為root：
[root@study ~]# chown root:root initial-setup-ks.cfg
[root@study ~]# ls -l
-rw-r--r--. 1 root root 1864 May  4 18:01 initial-setup-ks.cfg
```

```bash
[root@study ~]# cp .bashrc .bashrc_test
[root@study ~]# ls -al .bashrc*
-rw-r--r--. 1 root root 176 Dec 29  2013 .bashrc
-rw-r--r--. 1 root root 176 Jun  3 00:04 .bashrc_test   <==新檔案的屬性沒變
```

　　‍

# 48. 改變權限, chmod

```bash
Linux檔案的基本權限就有九個，分別是owner/group/others三種身份各有自己的read/write/execute權限， 先複習一下剛剛上面提到的資料：檔案的權限字元為：『-rwxrwxrwx』， 這九個權限是三個三個一組的！其中，我們可以使用數字來代表各個權限，各權限的分數對照表如下：
r:4w:2x:1
每種身份(owner/group/others)各自的三個權限(r/w/x)分數是需要累加的，例如當權限為： [-rwxrwx---] 分數則是：
owner = rwx = 4+2+1 = 7group = rwx = 4+2+1 = 7others= --- = 0+0+0 = 0
[root@study ~]# chmod [-R] xyz 檔案或目錄
選項與參數：
xyz : 就是剛剛提到的數字類型的權限屬性，為 rwx 屬性數值的相加。
-R : 進行遞迴(recursive)的持續變更，亦即連同次目錄下的所有檔案都會變更
[root@study ~]# ls -al .bashrc
-rw-r--r--. 1 root root 176 Dec 29  2013 .bashrc
[root@study ~]# chmod 777 .bashrc
[root@study ~]# ls -al .bashrc
-rwxrwxrwx. 1 root root 176 Dec 29  2013 .bashrc
```

　　符號類型改變檔案權限還有一個改變權限的方法呦！從之前的介紹中我們可以發現，基本上就九個權限分別是(1)user (2)group (3)others 三種身份啦！那麼我們就可以藉由 u, g, o 來代表三種身份的權限！此外， a 則代表 all 亦即全部的身份！那麼讀寫的權限就可以寫成 r, w, x 囉！也就是可以使用底下的方式來看：

|chmod|ugoa|+(加入)-(除去)=(設定)|rwx|檔案或目錄|
| -----| ----| ---------------------| ---| ----------|

```bash
[root@study ~]# chmod  u=rwx,go=rx  .bashrc
# 注意喔！那個 u=rwx,go=rx 是連在一起的，中間並沒有任何空白字元！
[root@study ~]# ls -al .bashrc
-rwxr-xr-x. 1 root root 176 Dec 29  2013 .bashrc
[root@study ~]# ls -al .bashrc
-rwxr-xr-x. 1 root root 176 Dec 29  2013 .bashrc
[root@study ~]# chmod  a+w  .bashrc
[root@study ~]# ls -al .bashrc
-rwxrwxrwx. 1 root root 176 Dec 29  2013 .bashrc
[root@study ~]# chmod  a-x  .bashrc
[root@study ~]# ls -al .bashrc
-rw-rw-rw-. 1 root root 176 Dec 29  2013 .bashrc
[root@study ~]# chmod 644 .bashrc  # 測試完畢得要改回來喔！
```

```bash
linux权限0777代表的含义
0777前面的0是代表suid和guid的
suid意味着如果某个用户对属于自己的shell脚本设置了这种权限，那么其他用户在执行这一脚本时也会具有其属主的相应权限。
guid则表示执行相应脚本的用户将具有该文件所属用户组中用户的权限。
下面举个例子
-rwxr-xr-x 1 root root 12 09-02 15:21 my_test.sh
上面的mysql_test.sh文件权限是所属用户（root）是7
如果设置了suid，那么其他任何用户的权限都是7，
如果设置了guid，那么任何用户的权限都是5。
如何设置suid和guid：
设置suid就是把0变为4，设置guid就把0变为2，如果都设置那就是6了
```

　　‍

# 49. 定位文件和应用

```bash
which 命令只会在系统定义的搜索路径中，查找可执行的文件，通常用于识别命令。如果您对输入 
which 时会运行哪个命令感到好奇，您可以使用命令 
which which，它会指出对应的可执行文件。

locate 命令更大方一点，它可以查找任意数量的文件，但它也有一个限制：仅当文件名被包含在由 
updatedb 命令构建的数据库时才有效。该文件可能会存储在某个位置，如 
/var/lib/mlocate/mlocate.db，但不能用 
locate 以外的任何命令读取。这个文件的更新通常是通过每天通过 cron 运行的 
updatedb 进行的。
```

　　‍

# 50. grep使用方法

　　grep 使用格式： grep [OPTIONS] PATTERN [FILE...]

　　grep 查找文件包含某个字符串的文件名

```bash
find -type f -name '*.js' | xargs grep -rl "loss_spice_info_tips"

# grep查找 httpd服务器 并杀掉服务
ps -ef | grep httpd | grep -v 'grep' | awk '{print $2}' |xargs kill
# spicehtml5proxy代理可以让不同计算节点的桌面都在同一个ip上访问 用户网络策略设置错误导致的 其他计算节点的虚拟机无法访问的问题
systemctl status spicehtml5proxy.service
tail -f /var/log/html5proxy/spice.log
# 搜索
grep -rn 'bootstrap' ./ --exclude-dir={.git,node_modules,resources,built} --exclude={'*bundle*','*.min*',angular.js}
```

# 51. vdi 4.4版本 模板连接失败 实际上用的vnc 6080端口

```bash
systemctl list-units --type=service --state=running | grep vnc
systemctl status openstack-nova-novncproxy.service
systemctl restart  openstack-nova-novncproxy.service
```

![企业微信截图_17151596252422.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_17151596252422.png)

# 52. docker维护

# 53. 一、docker服务设置自动启动说明

# 54. 查看已启动的服务

systemctl list-units -type=service

# 55. 查看是否设置开机启动

systemctl list-unit-files | grep enable

# 56. 设置开机启动

systemctl enable docker.service

# 57. 关闭开机启动

systemctl disable docker.service

# 58. 二、docker容器设置自动启动

docker run -tid -name 容器id -p 端口号 -restart-always -v 挂载
# 59. Flag Description
# 60. no 不自动重启容器：(默认value)
# 61. on-failure 容器发生error而退出(容器退出状态不为0)重启容器
# 62. unless-stopped 在容器已经stop掉或Docker stoped/restarted的时候才重启容器
# 63. always 在容器已经stop掉或Docker stoped/restarted的时候才重启容器

# 64. 如果已经启动的项目.则使用update更新

docker update --restart=always 容器id

docker log -f showdoc

# 65. oeidp

sed -i -e 's#mystorp.gitee.io/static#ecloud.os-easy.com.cn/static/#g' /var/www/html/js/libs/oeidp/oeidp.*

```

没有证书的警告
[[a docker实战 - 禅道卫士维护 2023.0606]]
![[3%RR_1SP42(6{)_06%9QTC1.png]]

# 50. 查看 spice 的日志

```bash
 tail -f /var/log/html5proxy/spice.log
```

# 66. 正则表达式

```bash
(?<=<(\w+)>).*(?=<\/\1>)

报错：改为这个就不会报错了(?<=<(td)>).*(?=<\/\1>)
```

　　[regex - lookhehind assertion length error - Stack Overflow](https://stackoverflow.com/questions/48628410/lookhehind-assertion-length-error)

　　​![image](40%20-%20Obsidian/附件/Attachment/assets%206-zagger/image-20230705091201-pfofyc9.png)​

```js
var str= '1231345345356'

str.replace(/\B(?=(?:\d{3})+\b)/g, ',');
```

```js
<(\w+)\s*(\w+(=('|&quot;).*?\4)?\s*)*>.*?
```

　　    [举例 3：表达式 "((?!\bstop\b).)+" 在匹配 "fdjka ljfdl stop fjdsla fdj" 时](http://www.regexlab.com/zh/workshop.htm?pat=%28%28%3F%21%5Cbstop%5Cb%29%2E%29%2B&txt=fdjka+ljfdl+stop+fjdsla+fdj)

　　将从头一直匹配到 "stop" 之前的位置，如果字符串中没有 "stop"，则匹配整个字符串。

　　(?!\bstop\b) 匹配右侧不能是stop单词的缝隙，从左侧缝隙开始，一个个缝隙开始判断，在stop的s的左侧缝隙就不符合此缝隙约束的条件

　　‍

# 67. 远程服务器

```bash
ssh root@172.16.65.141
oseasy@141
cd /var/www/html
ssh Cloud_r00t@172.16.201.47
Vdi&Voi@r00t
Cloud_r00t
Vdi&Voi@r00t
su root
ServerR00t
vim /var/www/html/views/vdi/help/activeAuth.html
```

# 68. dms:开发服务器

```bash
http://172.16.162.200:7735  http://172.16.65.124:7735
```

# 69. 服务器查看日志

```bash
tail -f -n 10 /etc/thor/log/thorconsole.log
```

# 70. 重启 supervisor 服务

```bash
systemctl restart thor-supervisor
```

# 71. ssh-copy-id -i ~/.ssh/id_rsa.pub [zhangyao@172.16.103.196](mailto:zhangyao@172.16.103.196)

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub zhangyao@172.16.103.196
windows
cat ~/.ssh/id_rsa.pub | ssh Cloud_r00t@172.16.201.47 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
chmod 644 ~/.ssh/authorized_keys
```

# 72. console-vscode 插件

```bash
ctrl + alt + l 选中变量之后，使用这个快捷键生成 console.log
alt + shift + c 注释所有 console.log
alt + shift + u 启用所有 console.log
alt + shift + d 删除所有 console.log
```

# 73. mac 上传代码到服务器 docker 中指定端口

```bash
rsync -avz -e 'ssh -p 10240' js built resources views p css fonts includes img init.html root@172.16.201.9:/var/www/html/
直接进入服务器的10240端口，进入docker中。
```

# 74. ssh 动态

```bash
ssh Cloud_r00t@59.175.233.194 -p8181
我把ssh的口放开，你可以走remote_ssh的方式进行远程开发
这个对应的转发到了172.16.200.222环境
也可以通过ssh -D10101 Cloud_r00t@59.175.233.194 -p8181的方式启用本地socks5端口
```

# 75. 端口占用问题解决

```bash
netstat -aon|findstr 8088
```

```bash
#命令格式：lsof -i :端口
lsof -i:8080
```

# 76. 端口转发

```bash
待验证
先动态转发本地端口10101到59.175.233.194的8181端口上
ssh -D10101 Cloud_r00t@59.175.233.194 -p8181
```

### 76.1.1. Vdi&[Voi@r00t](http://Voi@r00t)

　　​![image](40%20-%20Obsidian/附件/Attachment/assets%206-zagger/image-20230705092131-dvexqxp.png)​

　　本地端口转发：是将本地的监听一个端口通过 ssh 转发到远端主机（服务器）的某个端口。（自己本地启端口给远端用）远程端口转发：是在远端主机上监听一个端口，所有的访问远程主机的这个端口的数据都会通过 ssh 转发到本地对应的端口（让远端自己启端口给自己用）

　　首先，SSH 端口转发自然需要 SSH 连接，而 SSH 连接是有方向的，从 SSH Client 到 SSH Server 。而我们的应用也是有方向的，比如需要连接 LDAP Server 时，LDAP Server 自然就是 Server 端，我们应用连接的方向也是从应用的 Client 端连接到应用的 Server 端。如果这两个连接的方向一致，那我们就说它是本地转发。而如果两个方向不一致，我们就说它是远程转发。

　　1、Bug 产生原因阐述：代码中两年前王川用的就是 terminalCount，现在魏洪说要用 client_count，向他确认过是否其他地方使用的 terminalCount 是否也需要同步更改，没有正面回答。大概率是后端因为什么原因，terminalCount 字段数量不对了，又无法解决就需要更换字段了。

　　​![image](40%20-%20Obsidian/附件/Attachment/assets%206-zagger/image-20230705092150-90qfurd.png)​

　　2、解决思路：3、影响范围：4、Bug 归属人修改原因：长度不得小于 20 个字符

　　[git reset 详解 |reset|commit (qq.com)](https://xw.qq.com/cmsid/20200224A09I2300)

　　​![image](40%20-%20Obsidian/附件/Attachment/assets%206-zagger/image-20230705092204-535rfto.png)​

```bash
ssh zagger@外网地址 -p 端口
scp -r js views built v img css includes fonts ssh_terminal vnc zips types Cloud_r00t@172.16.201.47:/var/www/html
Vdi&Voi@r00t
```

# 77. 清空 chatgpt 缓存

```bash
javascript:window.localStorage.removeItem(Object.keys(window.localStorage).find(i=>i.startsWith('@@auth0spajs')))
```

# 78. [环境配置相关](siyuan://blocks/20230705103954-dsr1hc8 "环境配置相关-不常用")

　　‍

上传服务器145脚本
