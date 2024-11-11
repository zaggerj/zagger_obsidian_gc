---
searchType: wsl
created: 2023-11-08T14:23
updated: 2023-11-17 22:30:31
tags:
  - wsl
---

## 0.1. Metadata
Status::    #笔记状态/🌱发芽
Source Type::  #📥/💭想法 
Note Type::  #笔记
Topic:: [[wsl2]]
Author:: {原资讯的作者或者对话的人或者引起某种想法的原因}
Source URL:: 
Modify:: `=dateformat(this.file.mtime, "yyyy-MM-dd HH:MM:ss")`
## 0.2. 长青笔记
*一句话概括这篇笔记的内容*
Summary::  迁移成功，这样就可以安装好，各种软件之后，在u盘中迁移了

## 0.3. 自我重述
*用自己的话去重述提取的重点内容*
Ubuntu-22.04 =》 ubuntu2204

## 0.4. 重点摘抄
*摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。*

### 0.4.1. 迁移wsl步骤
1. ` wsl -l -v`
2. ` wsl --export Ubuntu-22.04 D:\\Ubuntu-22.04.tar`
3. `wsl --unregister Ubuntu-22.04`
4. `wsl -l -v`
5. `wsl --import Ubuntu-22.04 D:\\wsl D:\\Ubuntu-22.04.tar --version 2`
6. `ubuntu2204 config --default-user root`



## 0.5. 相关文章
*摘抄来源，引用出处，参考链接，文档查询*
Page Link::  https://blog.csdn.net/m0_37605642/article/details/127812965
[超详细的wsl2下配置Ubuntu教程 - 知乎](https://zhuanlan.zhihu.com/p/600519231)
[win10 wsl /ubuntu发行版,docker desktop 等从c盘导出迁移到非系统盘 ，释放c盘空间 -配置啦-研发运维人员必备网站](http://config.net.cn/server/microservice/b5c41c02-1f9c-4167-a846-402d9441b787-p1.html)