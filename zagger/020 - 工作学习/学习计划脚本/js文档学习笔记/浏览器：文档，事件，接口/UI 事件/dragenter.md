---
alias:
tags: 长青笔记
cdate: 2023-12-21 11:07
uid: 20231221110739
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. dragenter

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2023-12-21 星期四 11:07:37

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231221112501.png)

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

### 1.4.1. HTMLElement：dragenter 事件

`dragenter` 事件在可拖动的元素或者被选择的文本进入一个有效的放置目标时触发。

目标对象是_用户直接选择的范围_（由用户直接指示作为放置目标的元素），或者 [`<body>`](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/body) 元素。

#### 1.4.1.1. [语法](https://developer.mozilla.org/zh-CN/docs/Web/API/HTMLElement/dragenter_event#%E8%AF%AD%E6%B3%95)

在 [`addEventListener()`](https://developer.mozilla.org/zh-CN/docs/Web/API/EventTarget/addEventListener "addEventListener()") 等方法中使用事件名称，或者设置事件处理器属性。

JSCopy to Clipboard

```
addEventListener("dragenter", (event) => {});

ondragenter = (event) => {};
```

#### 1.4.1.2. [事件类型](https://developer.mozilla.org/zh-CN/docs/Web/API/HTMLElement/dragenter_event#%E4%BA%8B%E4%BB%B6%E7%B1%BB%E5%9E%8B)

继承自MouseEvent

一个 [`DragEvent`](https://developer.mozilla.org/zh-CN/docs/Web/API/DragEvent)。继承自 [`Event`](https://developer.mozilla.org/zh-CN/docs/Web/API/Event)。

![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231221110935.png)


#### 1.4.1.3. [事件属性](https://developer.mozilla.org/zh-CN/docs/Web/API/HTMLElement/dragenter_event#%E4%BA%8B%E4%BB%B6%E5%B1%9E%E6%80%A7)

_除了以下的属性，来自父接口 [`Event`](https://developer.mozilla.org/zh-CN/docs/Web/API/Event) 的属性也是可用的。_

[`DragEvent.dataTransfer`](https://developer.mozilla.org/zh-CN/docs/Web/API/DragEvent/dataTransfer) 只读

在拖放交互期间转移的数据。

#### 1.4.1.4. [示例](https://developer.mozilla.org/zh-CN/docs/Web/API/HTMLElement/dragenter_event#%E7%A4%BA%E4%BE%8B)

##### 1.4.1.4.1. [dragenter 事件触发时放置区域的样式](https://developer.mozilla.org/zh-CN/docs/Web/API/HTMLElement/dragenter_event#dragenter_%E4%BA%8B%E4%BB%B6%E8%A7%A6%E5%8F%91%E6%97%B6%E6%94%BE%E7%BD%AE%E5%8C%BA%E5%9F%9F%E7%9A%84%E6%A0%B7%E5%BC%8F)

在该示例中，我们在容器中有一个可拖动的元素。尝试抓住元素，拖动它进入另一个容器，然后释放它。

当拖动的元素在另一个容器上时，我们监听的 `dragenter` 事件将给它一个紫色的背景，以表明可拖动的元素可以放置到该容器中。

注意，在这个部分示例中，我们还没有实现放置：关于拖放的完整示例，请参见 [`drag`](https://developer.mozilla.org/zh-CN/docs/Web/API/HTMLElement/drag_event) 事件这页。

#### 1.4.1.5. HTML

HTMLPlayCopy to Clipboard

```
<div class="dropzone">
  <div id="draggable" draggable="true">This div is draggable</div>
</div>
<div class="dropzone" id="droptarget"></div>
```

#### 1.4.1.6. CSS

CSSPlayCopy to Clipboard

```
body {
  /* Prevent the user selecting text in the example */
  user-select: none;
}

#draggable {
  text-align: center;
  background: white;
}

.dropzone {
  width: 200px;
  height: 20px;
  background: blueviolet;
  margin: 10px;
  padding: 10px;
}

.dropzone.dragover {
  background-color: purple;
}
```

#### 1.4.1.7. JavaScript

JSPlayCopy to Clipboard

```
const target = document.getElementById("droptarget");
target.addEventListener("dragenter", (event) => {
  // highlight potential drop target when the draggable element enters it
  if (event.target.classList.contains("dropzone")) {
    event.target.classList.add("dragover");
  }
});

target.addEventListener("dragleave", (event) => {
  // reset background of potential drop target when the draggable element leaves it
  if (event.target.classList.contains("dropzone")) {
    event.target.classList.remove("dragover");
  }
});
```

#### 1.4.1.8. 结果

![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231221110906.png)

# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
[HTMLElement：dragenter 事件 - Web API 接口参考 | MDN](https://developer.mozilla.org/zh-CN/docs/Web/API/HTMLElement/dragenter_event)