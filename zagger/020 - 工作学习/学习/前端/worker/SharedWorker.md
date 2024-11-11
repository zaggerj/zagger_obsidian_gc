---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
​**`SharedWorker`**​ 接口代表一种特定类型的 worker，可以从几个浏览上下文中*访问*，例如几个窗口、iframe 或其他 worker。它们实现一个不同于普通 worker 的接口，具有不同的全局作用域，[`SharedWorkerGlobalScope`](https://developer.mozilla.org/en-US/docs/Web/API/SharedWorkerGlobalScope "Currently only available in English (US)")​[ (en-US)](https://developer.mozilla.org/en-US/docs/Web/API/SharedWorkerGlobalScope "Currently only available in English (US)") 。

　　**备注：** 如果要使 **SharedWorker** 连接到多个不同的页面，这些页面必须是同源的（相同的协议、host 以及端口）。

## [构造函数](https://developer.mozilla.org/zh-CN/docs/Web/API/SharedWorker#%E6%9E%84%E9%80%A0%E5%87%BD%E6%95%B0)

　　​[`SharedWorker()`](https://developer.mozilla.org/zh-CN/docs/Web/API/SharedWorker/SharedWorker "SharedWorker()")​创建一个执行指定 url 脚本的共享 web worker。

## [属性](https://developer.mozilla.org/zh-CN/docs/Web/API/SharedWorker#%E5%B1%9E%E6%80%A7)

　　*继承自其父类 ​*​*``*​*，并实现 ​*​*``*​**​*​ 中的属性。*

　　​[`AbstractWorker.onerror`](https://developer.mozilla.org/en-US/docs/Web/API/Worker/error_event "Currently only available in English (US)")​[ (en-US)](https://developer.mozilla.org/en-US/docs/Web/API/Worker/error_event "Currently only available in English (US)")一个 [`EventListener`](https://developer.mozilla.org/zh-CN/docs/Web/API/EventTarget/addEventListener)​，当 [`ErrorEvent`](https://developer.mozilla.org/zh-CN/docs/Web/API/ErrorEvent)​ 类型的 `error`​ 冒泡到 worker 时触发。

　　​[`SharedWorker.port`](https://developer.mozilla.org/en-US/docs/Web/API/SharedWorker/port "Currently only available in English (US)")​[ (en-US)](https://developer.mozilla.org/en-US/docs/Web/API/SharedWorker/port "Currently only available in English (US)") **只读**返回一个 [`MessagePort`](https://developer.mozilla.org/zh-CN/docs/Web/API/MessagePort)​ 对象，该对象可以用来进行通信和对共享 worker 进行控制。

## [方法](https://developer.mozilla.org/zh-CN/docs/Web/API/SharedWorker#%E6%96%B9%E6%B3%95)

　　继承自其*父类 ​*​*``*​*，并实现 ​*​*``*​**​*​ 中的方法。*

## [示例](https://developer.mozilla.org/zh-CN/docs/Web/API/SharedWorker#%E7%A4%BA%E4%BE%8B)

　　在这个[基本的共享型 worker 示例](https://github.com/mdn/dom-examples/tree/main/web-workers/simple-shared-worker) 中（[运行共享型 worker](https://mdn.github.io/dom-examples/web-workers/simple-shared-worker/)），我们有两个 HTML 页面，每个页面中使用一些 JavaScript 来执行简单的计算。这些脚本使用相同的 worker 文件来执行计算——每个脚本都可以访问这个 worker 文件，即使脚本所处的页面在不同的窗口下。

　　下面的代码展示了如何通过 [`SharedWorker()`](https://developer.mozilla.org/zh-CN/docs/Web/API/SharedWorker/SharedWorker "SharedWorker()")​ 方法来创建一个共享进程对象。

　　**JS**Copy to Clipboard

```
var myWorker = new SharedWorker("worker.js");
```

　　然后两个脚本都通过 [`MessagePort`](https://developer.mozilla.org/zh-CN/docs/Web/API/MessagePort)​ 对象来访问 worker，这个对象用[`SharedWorker.port`](https://developer.mozilla.org/en-US/docs/Web/API/SharedWorker/port "Currently only available in English (US)")​[ (en-US)](https://developer.mozilla.org/en-US/docs/Web/API/SharedWorker/port "Currently only available in English (US)") 属性获得。如果已经用 addEventListener 监听了 onmessage 事件，则可以使用 `start()`​ 方法手动启动端口：

　　**JS**Copy to Clipboard

```
myWorker.port.start();
```

　　当启动端口时，两个脚本都会向 worker 发送消息，然后使用 `port.postMessage()`​和 `port.onmessage`​ 处理从 worker 返回的消息：

　　**JS**Copy to Clipboard

```
first.onchange = function() {
    myWorker.port.postMessage([first.value,second.value]);
    console.log('Message posted to worker');
  }

  second.onchange = function() {
    myWorker.port.postMessage([first.value,second.value]);
    console.log('Message posted to worker');
  }

  myWorker.port.onmessage = function(e) {
    result1.textContent = e.data;
    console.log('Message received from worker');
  }
```

　　在 worker 中我们使用 [`SharedWorkerGlobalScope.onconnect`](https://developer.mozilla.org/en-US/docs/Web/API/SharedWorkerGlobalScope/connect_event "Currently only available in English (US)")​[ (en-US)](https://developer.mozilla.org/en-US/docs/Web/API/SharedWorkerGlobalScope/connect_event "Currently only available in English (US)") 处理程序连接到上面讨论的相同端口。可以在 [`connect`](https://developer.mozilla.org/en-US/docs/Web/API/SharedWorkerGlobalScope/connect_event "Currently only available in English (US)")​[ (en-US)](https://developer.mozilla.org/en-US/docs/Web/API/SharedWorkerGlobalScope/connect_event "Currently only available in English (US)") 事件的 `ports`​ 属性中获取到与该 worker 相关联的端口——然后我们使用 [`MessagePort`](https://developer.mozilla.org/zh-CN/docs/Web/API/MessagePort)​ `start()`​ 方法来启动端口，然后 `onmessage`​ 处理程序处理来自主线程的消息。

　　**JS**Copy to Clipboard

```
onconnect = function(e) {
    var port = e.ports[0];

    port.addEventListener('message', function(e) {
      var workerResult = 'Result: ' + (e.data[0] * e.data[1]);
      port.postMessage(workerResult);
    });

    port.start(); // Required when using addEventListener. Otherwise called implicitly by onmessage setter.
}
```

　　‍

　　‍

# 相关文件：

　　index.html

```bash
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width" />

    <title>Shared Workers basic example</title>

    <link rel="stylesheet" href="style.css" />
  </head>

  <body>
    <h1>Shared<br />Workers<br />basic<br />example</h1>

    <div class="controls" tabindex="0">
      <form>
        <div>
          <label for="number1">Multiply number 1: </label>
          <input type="text" id="number1" value="0" />
        </div>
        <div>
          <label for="number2">Multiply number 2: </label>
          <input type="text" id="number2" value="0" />
        </div>
      </form>

      <p class="result1">Result: 0</p>

      <p><a href="index2.html" target="_blank">Go to second worker page</a></p>
    </div>

    <script src="multiply.js"></script>
    <script src="nosubmit.js"></script>
  </body>
</html>

```

　　index2.html

```bash
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width" />

    <title>Shared Workers basic example</title>

    <link rel="stylesheet" href="style.css" />
  </head>

  <body>
    <h1>Shared<br />Workers<br />basic<br />example</h1>

    <div class="controls" tabindex="0">
      <form>
        <div>
          <label for="number3">Square number: </label>
          <input type="text" id="number3" value="0" />
        </div>
      </form>

      <p class="result2">Result: 0</p>
    </div>
    <script src="square.js"></script>
    <script src="nosubmit.js"></script>
  </body>
</html>

```

　　multiply.js

```bash
const first = document.querySelector("#number1");
const second = document.querySelector("#number2");

const result1 = document.querySelector(".result1");

if (!!window.SharedWorker) {
  const myWorker = new SharedWorker("worker.js");

  first.onchange = function () {
    myWorker.port.postMessage([first.value, second.value]);
    console.log("Message posted to worker");
  };

  second.onchange = function () {
    myWorker.port.postMessage([first.value, second.value]);
    console.log("Message posted to worker");
  };

  myWorker.port.onmessage = function (e) {
    result1.textContent = e.data;
    console.log("Message received from worker");
    console.log(e.lastEventId);
  };
}

```

　　nosubmit.js

```bash
const form = document.querySelector("form");

form.onsubmit = function (event) {
  event.preventDefault();
};

```

　　square.js

```bash
const squareNumber = document.querySelector("#number3");

const result2 = document.querySelector(".result2");

if (!!window.SharedWorker) {
  const myWorker = new SharedWorker("worker.js");

  squareNumber.onchange = function () {
    myWorker.port.postMessage([squareNumber.value, squareNumber.value]);
    console.log("Message posted to worker");
  };

  myWorker.port.onmessage = function (event) {
    result2.textContent = event.data;
    console.log("Message received from worker");
  };
}

```

　　style.css

```bash
html {
  background-color: #7d2663;
  font-family: sans-serif;
}

h1 {
  margin: 0;
  font-size: 15vw;
  letter-spacing: -0.2rem;
  position: absolute;
  top: 0;
  z-index: -1;
}

p {
  margin: 0 0 1rem 0;
}

.controls {
  padding: 4vw;
  width: 75%;
  margin: 3vw auto;
  background-color: rgba(255, 255, 255, 0.7);
  border: 5px solid black;
  opacity: 0.3;
  transition: 1s all;
}

.controls:hover,
.controls:focus {
  opacity: 1;
}

.controls label,
.controls p,
.controls input {
  font-size: 3vw;
}

.controls div {
  padding-bottom: 1rem;
}

```

　　work.js

```bash
onconnect = function (event) {
  const port = event.ports[0];

  port.onmessage = function (e) {
    const workerResult = `Result: ${e.data[0] * e.data[1]}`;
    port.postMessage(workerResult);
  };
};

```

# 参考文档

1. [SharedWorker - Web API 接口参考 | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Web/API/SharedWorker)

    ##
