---
UID: 20231105215716
aliases:
  - 服务器命令
tags:
  - 远程桌面/idp
  - 排查问题/idp
  - 工作
  - 服务器
  - 命令
  - Linux
  - 工作/spice
  - 工作/spice/spice问题
source: 
cssclasses: 
created: 2023-11-06
updated: 2023-11-13T20:35
---


# 1. 基本信息

解决问题 :: `=this.file.name`
编写时间 :: 2022-02-01
部门名 :: 游戏部
审核人 :: [[小一]]
审核时间 :: 2022-05-18

项目名称 :: 打[[百里守约|守约]]银牌
版本号 :: 0.0.0

## 1.1. ✍内容

记录好如下的命令，下次排查问题好照旧！

![[M{994[AZF%U`8I2}DK([W4A.png]]

### 1.1.1. 查看weboeidp服务
`systemctl status weboeidpproxy.service`

![[Pasted image 20231106174827.png]]

### 1.1.2. 查看服务目录


![[Pasted image 20231106174947.png]]

### 1.1.3. 父级目录查看oeidp.json配置文件
`/usr/lib/python2.7/site-packages/tcloud/thor/weboeidp
`
![[Pasted image 20231106175041.png]]

### 1.1.4. 查看配置文件oeidp.json

![[Pasted image 20231106175220.png]]
### 1.1.5. 查看/opt/spicehtml5proxy/static/路径

跟spice代理（spicehtml5proxy）共用一套web页面

![[Pasted image 20231106175327.png]]


### 1.1.6. 查看日志文件

`/var/log/html5proxy/weboeidp.log`

![[Pasted image 20231106175526.png]]

#记录 问题服务器是从145上连上了155服务器的桌面。结果代理报token 失效