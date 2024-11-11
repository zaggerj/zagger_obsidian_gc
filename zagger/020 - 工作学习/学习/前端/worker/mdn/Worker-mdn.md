---
alias:
tags: 长青笔记
cdate: 2023-12-27 15:05
uid: 20231227150505
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. Worker

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2023-12-27 星期三 15:05:02

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

# 2. Worker

Worker 接口是 [Web Workers API](https://developer.mozilla.org/zh-CN/docs/Web/API/Web_Workers_API) 的一部分，指的是一种可由脚本创建的后台任务，任务执行中可以向其创建者收发信息。要创建一个 Worker，只须调用 `Worker(URL)` 构造函数，函数参数 `URL` 为指定的脚本。

Worker 也可以创建新的 Worker，当然，所有 Worker 必须与其创建者[同源](https://developer.mozilla.org/zh-CN/docs/Web/Security/Same-origin_policy)（注意：[Blink](https://groups.google.com/a/chromium.org/forum/#!topic/blink-dev/5R3B4RN4GHU)暂时不支持嵌套 Worker）。

需要注意的是，不是所有函数和构造函数 (或者说…类) 都可以在 Worker 中使用。具体参考页面 [Worker 所支持的函数和类](https://developer.mozilla.org/zh-CN/docs/Web/API/Web_Workers_API/Functions_and_classes_available_to_workers)。Worker 可以使用 [`XMLHttpRequest`](https://developer.mozilla.org/zh-CN/docs/Web/API/XMLHttpRequest) 发送请求，但是请求的 `responseXML` 与 `channel` 两个属性值始终返回 `null` （`fetch` 仍可正常使用，没有类似的限制）。

**备注：** 如果你要在火狐浏览器的扩展使用 Worker 访问 [js-ctypes](https://developer.mozilla.org/zh-CN/docs/Mozilla/js-ctypes "This is a link to an unwritten page")，应使用 `ChromeWorker` 对象来替代。(译者注：这里没有看懂，希望有人能驳正，或添加说明)

## 2.1. [构造函数](https://developer.mozilla.org/zh-CN/docs/Web/API/Worker#%E6%9E%84%E9%80%A0%E5%87%BD%E6%95%B0)

[`Worker()`](https://developer.mozilla.org/zh-CN/docs/Web/API/Worker/Worker "Worker()")

创建一个专用 Web worker，它只执行 URL 指定的脚本。使用 [Blob URL](https://developer.mozilla.org/zh-CN/docs/Web/API/Blob) 作为参数亦可。

## 2.2. [属性](https://developer.mozilla.org/zh-CN/docs/Web/API/Worker#%E5%B1%9E%E6%80%A7)

_继承_父对象*[`EventTarget`](https://developer.mozilla.org/zh-CN/docs/Web/API/EventTarget) 的属性，以及实现对象 [`AbstractWorker` (en-US)](https://developer.mozilla.org/en-US/docs/Web/API/Worker "Currently only available in English (US)")的属性。*

### 2.2.1. [_事件句柄_](https://developer.mozilla.org/zh-CN/docs/Web/API/Worker#%E4%BA%8B%E4%BB%B6%E5%8F%A5%E6%9F%84)

[`AbstractWorker.onerror` (en-US)](https://developer.mozilla.org/en-US/docs/Web/API/Worker/error_event "Currently only available in English (US)")

当[`ErrorEvent`](https://developer.mozilla.org/zh-CN/docs/Web/API/ErrorEvent) 类型的事件冒泡到 worker 时，事件监听函数 [`EventListener`](https://developer.mozilla.org/zh-CN/docs/Web/API/EventTarget/addEventListener) 被调用。它继承于 [`AbstractWorker` (en-US)](https://developer.mozilla.org/en-US/docs/Web/API/Worker "Currently only available in English (US)").

[`Worker.onmessage`](https://developer.mozilla.org/zh-CN/docs/Web/API/Worker/message_event)

当[`MessageEvent`](https://developer.mozilla.org/zh-CN/docs/Web/API/MessageEvent)类型的事件冒泡到 worker 时，事件监听函数 [`EventListener`](https://developer.mozilla.org/zh-CN/docs/Web/API/EventTarget/addEventListener) 被调用。例如，一个消息通过 [`DedicatedWorkerGlobalScope.postMessage` (en-US)](https://developer.mozilla.org/en-US/docs/Web/API/DedicatedWorkerGlobalScope/postMessage "Currently only available in English (US)")，从执行者发送到父页面对象，消息保存在事件对象的 [`data` (en-US)](https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent/data "Currently only available in English (US)") 属性中。

[`Worker.onmessageerror`](https://developer.mozilla.org/zh-CN/docs/Web/API/Worker/messageerror_event)

当[`messageerror` (en-US)](https://developer.mozilla.org/en-US/docs/Web/API/DedicatedWorkerGlobalScope/messageerror_event "Currently only available in English (US)") 类型的事件发生时，对应的事件处理器代码被调用。

## 2.3. [方法](https://developer.mozilla.org/zh-CN/docs/Web/API/Worker#%E6%96%B9%E6%B3%95)

_继承_父对象*[`EventTarget`](https://developer.mozilla.org/zh-CN/docs/Web/API/EventTarget) 的方法，以及实现对象 [`AbstractWorker` (en-US)](https://developer.mozilla.org/en-US/docs/Web/API/Worker "Currently only available in English (US)")的方法。*

[`Worker.postMessage()`](https://developer.mozilla.org/zh-CN/docs/Web/API/Worker/postMessage)

发送一条消息到最近的外层对象，消息可由任何 JavaScript 对象组成。

[`Worker.terminate()`](https://developer.mozilla.org/zh-CN/docs/Web/API/Worker/terminate)

立即终止 worker。该方法不会给 worker 留下任何完成操作的机会；就是简单的立即停止。Service Woker 不支持这个方法。

## 2.4. [示例](https://developer.mozilla.org/zh-CN/docs/Web/API/Worker#%E7%A4%BA%E4%BE%8B)

下面的代码通过构造函数 [`Worker()`](https://developer.mozilla.org/zh-CN/docs/Web/API/Worker/Worker "Worker()") 创建了一个 [`Worker`](https://developer.mozilla.org/zh-CN/docs/Web/API/Worker) 对象。

JSCopy to Clipboard

```
var myWorker = new Worker("worker.js");
var first = document.querySelector("#number1");
var second = document.querySelector("#number2");

first.onchange = function () {
  myWorker.postMessage([first.value, second.value]);
  console.log("Message posted to worker");
};
```

完整的示例，请查阅 [Basic dedicated worker example](https://github.com/mdn/simple-web-worker) ([run dedicated worker](https://mdn.github.io/simple-web-worker/)).

## 2.5. [规范](https://developer.mozilla.org/zh-CN/docs/Web/API/Worker#%E8%A7%84%E8%8C%83)

|Specification|
|---|
|[HTML Standard  <br># dedicated-workers-and-the-worker-interface](https://html.spec.whatwg.org/multipage/workers.html#dedicated-workers-and-the-worker-interface)|
# 3. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
