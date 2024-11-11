---
tags: 资源/环境配置
created: 2023-11-06T08:20
updated: 2023-11-14T09:22
---
# 1. wsl2 docker 环境部署

　　[返回](siyuan://blocks/20230704220020-mlenixa)

　　‍

# 2. 配置wsl2 ubuntu2204版本，默认使用root账号登录

```bash
~/AppData/Local/Microsoft/WindowsApps/ubuntu2204.exe config --default-user root
net stop lxssmanager
```

　　[WSL 修改默认登录用户为root - 爱码网 (likecs.com)](https://www.likecs.com/show-308427680.html)

　　[WSL2配置代理 - 哔哩哔哩 (bilibili.com)](https://www.bilibili.com/read/cv22203257/)

　　[WSL的备份和迁移 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/622706723)

　　[记录折腾WSL用于前端开发的过程 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/357041079)

　　[wsl2配置前端开发环境 - 掘金 (juejin.cn)](https://juejin.cn/post/7164656035217539102)

　　[2022 年 11 月，Windows 10 WSL 2 配置和踩坑记录【多图预警】 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/583002945?utm_id=0&wd=&eqid=dfda4f13000f82bb0000000364716425)

# 3. wsl2 配置代理

```bash
#!/bin/bash
host_ip=$(cat /etc/resolv.conf |grep "nameserver" |cut -f 2 -d " ")
export ALL_PROXY="http://$host_ip:7890"
一键配置脚本
将上面的过程写入一个 bash 脚本，可以轻松的实现一键配置代理：
#!/bin/bash
host_ip=$(cat /etc/resolv.conf |grep "nameserver" |cut -f 2 -d " ")
export ALL_PROXY="http://$host_ip:7890"
脚本通过 cat /etc/resolv.conf 来获取 DNS 服务器，也就是 Windows 的 IP，再将其中的 IP 部分截取出来，加上代理客户端的端口（我的是 7890，可以根据自己实际情况修改），使用 export 写入环境变量中。
脚本也可以从这里下载.proxyrc，使用时只需要 source .proxyrc 就可以生效。
```

　　[为 WSL2 一键设置代理 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/153124468)

　　[优雅简洁的zim美化你的zsh终端，媲美甚至超越 ohmyzsh - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/563433955)

　　[zimfw/zimfw: Zim: Modular, customizable, and blazing fast Zsh framework (github.com)](https://github.com/zimfw/zimfw#uninstalling)

　　[matyle/matyle.github.io: blog](https://github.com/matyle/matyle.github.io)

# 4. wsl --web-download

```bash
# wsl 安装wsl2
wsl --update --web-download
# WSL安装发行版
wsl --install -d Ubuntu-22.04 --web-download
```

# 5. 设置root账户密码

```bash
sudo passwd root
```

# 6. 配置用户sudo免密

```bash
# root账户下执行以下指令，替换leap为自己单独配置的用户名
sudo echo "leap ALL=(ALL:ALL) NOPASSWD: ALL" >>/etc/sudoers
```

## 6.1. 更换ubuntu的apt安装源

```bash
cp /etc/apt/sources.list /etc/apt/sources.list.bak
 
echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted \
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted \
deb http://mirrors.aliyun.com/ubuntu/ focal universe \
deb http://mirrors.aliyun.com/ubuntu/ focal-updates universe \
deb http://mirrors.aliyun.com/ubuntu/ focal multiverse \
deb http://mirrors.aliyun.com/ubuntu/ focal-updates multiverse \
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse \
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted \
deb http://mirrors.aliyun.com/ubuntu/ focal-security universe \
deb http://mirrors.aliyun.com/ubuntu/ focal-security multiverse">/etc/apt/sources.list
```

# 7. 使用root账户执行更新

```bash
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh
$ sudo service docker start
```

# 8. 原生linux安装docker方式

```bash
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh
$ sudo service docker start
```

# 9. 检查docker安装正常

```bash
# 检查dockerd进程启动
service docker status
ps aux|grep docker
# 检查拉取镜像等正常
docker pull busybox
docker images
```

# 10. Ubuntu系统 软件安装报错：Could not get lock /var/lib/dpkg/lock-frontend - open解决方法

```bash
ps aux|grep apt-get
sudo kill -9 进程号
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/lib/dpkg/lock
sudo apt-get update
# 再次运行apt-install即可安装成功
```

　　​![image](image-20230705092723-qsy38nn.png)​

　　​![image](image-20230705092729-nhwadz9.png)​

　　wsl --unregister Ubuntu-22.04

1. [(50条消息) win10开发环境搭建之wsl2(Ubuntu)+Terminal+docker_wsl2 docker login-CSDN博客](https://blog.csdn.net/mp9105/article/details/123436429)
2. [(50条消息) Ubuntu系统 软件安装报错：Could not get lock /var/lib/dpkg/lock-frontend - open解决方法_lansebingxuan的博客-CSDN博客](https://blog.csdn.net/lansebingxuan/article/details/127084441)
