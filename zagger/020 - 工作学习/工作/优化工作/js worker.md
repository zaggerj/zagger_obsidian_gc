---
created: 2023-11-06T08:20
updated: 2023-11-06T08:20
---
# js worker

　　js worker

　　Web Worker是一种在后台运行的脚本，可以在不影响Web页面性能的情况下执行一些耗时的操作，例如计算密集型任务、文件读取和网络请求等。Web Worker运行在单独的线程中，可以与主线程进行通信，但不会阻塞主线程的运行。

　　以下是一个简单的Web Worker示例，用于计算斐波那契数列：

　　javascriptCopy code// 创建Web Worker对象

　　var worker = new Worker('fibonacci.js');

　　// 监听Web Worker的消息事件

　　worker.onmessage = function(event) {

　　console.log('Result:', event.data);

　　};

　　// 向Web Worker发送消息

　　worker.postMessage(10);

　　在该示例中，通过new Worker()方法创建了一个名为fibonacci.js的Web Worker对象。然后，使用onmessage事件监听器来接收Web Worker返回的消息，并使用postMessage()方法向Web Worker发送一个参数10。Web Worker会接收这个参数并计算出对应的斐波那契数列，并将结果发送回主线程。

　　在fibonacci.js文件中，实现了如下代码：

　　javascriptCopy code// 监听Web Worker的消息事件

　　self.onmessage = function(event) {

　　var n = event.data;

　　var result = fibonacci(n);

　　// 向主线程发送消息

　　self.postMessage(result);

　　};

　　// 计算斐波那契数列

　　function fibonacci(n) {

　　if (n \<= 1) {

　　return n;

　　}

　　return fibonacci(n - 1) + fibonacci(n - 2);

　　}

　　在该代码中，使用self.onmessage事件监听器来接收主线程发送的消息，并计算出对应的斐波那契数列。然后，使用postMessage()方法将结果发送回主线程。

　　需要注意的是，Web Worker中无法直接访问DOM和其他浏览器API，只能通过消息传递的方式与主线程进行通信。同时，由于Web Worker运行在单独的线程中，无法访问主线程的变量和函数，因此需要将所有需要的数据和函数通过消息传递的方式传递给Web Worker。

　　js service worker shared worker

　　Service Worker和Shared Worker都是Web Worker的一种，都可以在后台运行脚本，而不会阻塞主线程的运行。

　　Service Worker是一种专门用于处理网络请求和缓存的Web Worker，它运行在一个独立的上下文中，可以拦截并处理Web应用程序的网络请求，从而实现离线缓存、消息推送、拦截广告和网络优化等功能。

　　Shared Worker是一种可被多个窗口（包括跨域窗口）共享的Web Worker，可以在多个浏览器窗口之间共享数据和通信。与普通的Web Worker不同，Shared Worker不是在一个特定的页面中创建的，而是在多个页面之间共享。Shared Worker可以通过new SharedWorker()方法创建，然后可以在多个浏览器页面中共享。

　　以下是Service Worker和Shared Worker的创建示例：

　　Service Worker：

　　javascriptCopy code// 注册Service Worker

　　if ('serviceWorker' in navigator) {

　　navigator.serviceWorker.register('sw.js');

　　}

　　// 在sw.js文件中实现Service Worker代码

　　self.addEventListener('fetch', function(event) {

　　console.log('Fetch event:', event.request.url);

　　// 处理网络请求

　　});

　　在该示例中，使用navigator.serviceWorker.register()方法注册Service Worker，并在sw.js文件中实现Service Worker代码，使用self.addEventListener()方法监听fetch事件，用于处理网络请求。

　　Shared Worker：

　　javascriptCopy code// 创建Shared Worker

　　var worker = new SharedWorker('worker.js');

　　// 向Shared Worker发送消息

　　worker.port.postMessage('Hello World!');

　　// 监听Shared Worker的消息事件

　　worker.port.onmessage = function(event) {

　　console.log('Received message:', event.data);

　　};

　　// 在worker.js文件中实现Shared Worker代码

　　self.onconnect = function(event) {

　　var port = event.ports\[0\];

　　// 监听消息事件

　　port.onmessage = function(event) {

　　console.log('Received message:', event.data);

　　// 向页面发送消息

　　port.postMessage('Hello back!');

　　};

　　};

　　在该示例中，使用new SharedWorker()方法创建一个名为worker.js的Shared Worker对象，并使用worker.port.postMessage()方法向Shared Worker发送一个消息。使用worker.port.onmessage方法监听Shared Worker返回的消息，并使用self.onconnect方法在worker.js文件中实现Shared Worker代码。在onconnect事件处理程序中，使用event.ports\[0\]获取到连接的端口，然后使用port.onmessage方法监听端口返回的消息，并使用port.postMessage()方法向页面发送一个消息。

　　需要注意的是，Service Worker和Shared Worker虽然都是Web Worker的一种，但它们的用途和实现方式是不同的。Service Worker主要用于网络请求和缓存，Shared Worker主要用于多窗口之间的共享数据和通信。同时，它们也有一些不同的API和事件处理程序。
