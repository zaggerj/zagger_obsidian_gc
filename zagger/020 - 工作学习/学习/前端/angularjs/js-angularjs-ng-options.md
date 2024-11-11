---
aliases: 
tags:
  - 长青笔记
cdate: 2023-11-17 15:03
uid: 20231117150428
searchterm: "#长青笔记"
banner: 040 - Obsidian/附件/banners/book-banner.gif
cssclasses:
  - noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
created: 2023-11-17 15:03:35
updated: 2023-11-20 08:57:53
---

# 1. js-angularjs-ng-options

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2023-11-17 星期五 15:03:35

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::建议选择select as 使用，应为大部分时候，最好是选中的id，可以直接给后端，设置初始值，设置为item.id。刚好也是从后端来的。第二选择时track by方式

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_、

<mark style="background: #FF5582A6;">track by 和 select as 不要一起使用！</mark>

![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231117165235.png)

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_
### 1.4.1. ng-options用法详解
#### 1.4.1.1. 1、ng-options指令用途：

在表达式中使用数组或对象来自动生成一个select中的option列表。ng-options与ng-[repeat](https://so.csdn.net/so/search?q=repeat&spm=1001.2101.3001.7020)很相似，很多时候可以用ng-repeat来代替ng-options。但是ng-options提供了一些好处，例如减少内存提高速度，以及提供选择框的选项来让用户选择。当select中一个选项被选择，该选项将会使用ng-model自动绑定到对应数据上。如果你想设一个默认值，可以像这样：$scope.selected = $scope.collection[3]。

#### 1.4.1.2. track by的用途：

track by主要是防止值有重复，angularjs会报错。因为angularjs需要一个唯一值来与生成的dom绑定，以方便追踪数据。例如：items=[“a”,“a”,“b”],这样ng-repeat=“item in items”就会出错，而用ng-repeat=“(key,value) in items track by key”就不会出现错误了。

#### 1.4.1.3. ng-option使用注意

使用时候，必须加 ng-[model](https://so.csdn.net/so/search?q=model&spm=1001.2101.3001.7020) 指令，否则无法使用会报错
# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::https://blog.csdn.net/qq_43437571/article/details/108072708
[DevDocs](https://devdocs.io/angularjs~1.5/api/ng/directive/ngoptions)
[angularjs中ng-options的用法-CSDN博客](https://blog.csdn.net/menghuanzhiming/article/details/77149572)

