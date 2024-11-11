---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
> _WASM支持将C/C++/Go/Rust等语言实现的代码编译为浏览器可执行的机器码，从而支持浏览器以接近原生应用的性能运行相关应用。在边缘计算领域，WASM也在尝试建立自己的用例，为边缘应用提供统一的运行环境。原文：Introduction to WebAssembly (WASM)[1]_

WebAssembly于2015年首次发布，第一次演示是在Firefox、Chrome和Edge上执行Unity的Angry Bots游戏。但仅仅过了4年，它就成为了官方标准，是继HTML、CSS和JavaScript之后的第四种Web语言。到目前为止，94%的浏览器已经支持了WebAssembly。它能够在浏览器中实现接近本机的执行速度，使得我们有可能将桌面应用(如AutoCAD)甚至电子游戏(如《Doom 3》)移植到Web。

如今几乎每个人都在谈论WebAssembly。这篇文章将带你了解什么是WebAssembly以及它是如何工作的。

> _JavaScript有什么问题？_  
> _什么是WebAssembly？_  
> _这是一种类似于C/C++那样的新的编程语言吗？_  
> _WebAssembly是如何工作的？_  
> _WASM是Web应用的未来吗？_

我们将回答所有这些问题，并鼓励你开始使用Web汇编（web assembly），它有可能极大的改变我们今天所知道的网站！

所以，做好准备，让我们开始吧！⚡

# JavaScript有什么问题？

Javascript不是为高性能而开发的

JavaScript是由Brenden Eich在1995年为Netscape浏览器设计的，在那个年代，它可以为静态网页实现一些交互。

JavaScript是解释型语言，也是动态类型语言。如果变量类型是在运行时决定的，那么就是动态类型语言。那么动态类型语言的问题是什么呢？

相对于动态类型语言，还有静态类型语言，C++就是一种静态类型语言，其变量类型是在定义的时候就决定了的。

```cpp
int x = 5 ;
```

通过一条指令，编译器就能知道变量x的类型和内存位置。但是对于JavaScript中相同的操作，每次执行程序时，引擎都必须检查它是整数还是浮点数，或者任何其他有效的数据类型。所以JavaScript中的每条指令都要经过几次类型检查和转换，这会影响到它的执行速度。

下面是JavaScript在运行代码时花费的时间🤓。

Javascript

下面是WebAssembly花费的时间。

WebAssembly

与JavaScript相比，WebAssembly简化了整个编译过程。

> **JavaScript不是为CPU密集型和高性能应用程序开发的。**

---

# 什么是WebAssembly？

浏览器只能运行JavaScript，但如果我们有一个虚拟微处理器，它可以将任何高级语言转换成可以在所有主流浏览器上运行的机器码，那会怎么样呢？这正是Web汇编（web assembly）所做的事情。

下面是一个用C++编写并被转为WASM的加法函数的例子。

> _VirtualProcessor原理图，它将C++代码转换为浏览器可理解的二进制代码。_

---

# 这是一种类似于C/C++那样的新的编程语言吗？

确切地说，WASM不是一种编程语言

WASM不是一种编程语言🙂。简而言之，它是一种将用一种编程语言编写的代码转换为浏览器可理解的机器代码的技术。

> **WASM (WebAssembly的缩写)被设计为其他语言的编译目标，允许服务器端代码(如C或C++代码)被编译成WASM并在浏览器中执行。**

---

# WebAssembly是如何工作的？

要了解Web汇编（web assembly），我们首先需要了解什么是通用汇编（general assembly）。

什么是汇编语言和汇编程序？

- 每个处理器都有一个类似x86或ARM的架构。此外，处理器只能理解机器码。
- 编写机器码是件乏味的事情，所以我们用汇编语言来编写。
- 汇编程序将汇编语言中的指令转换为处理器能理解的机器码。

以下表示了用C语言编写的应用程序是如何在你的电脑上运行的。

> _类似于通用汇编，在WebAssembly中，用高级语言(如C++)编写的代码被转换为浏览器可理解的机器码。_

---

# WebAssembly入门

WebAssembly是一个具有WASM扩展名的文件，可以把它看作一个可以导入JavaScript程序的模块。

#### 项目目录中的交互文件 —

> _记住，WASM不能直接与DOM交互，因此我们需要同时使用JavaScript和WASM。_

从上面的讨论中，我们了解到，我们可以在浏览器中运行C、C++等语言实现的应用程序，其性能接近原生应用。为了实现这一目标，我们需要采取以下步骤。🖖

##### 1. 用你喜欢的语言编写应用程序。

我们编写一个小型C++函数，用来查找Fibonacci数列的第n个元素。

```cpp
// Following is a function that finds nth fibonacci written in C++
int fib(int n)
{
   if (n <= 1)
      return n;
   return fib(n-1) + fib(n-2);
}
```

##### 2. 创建WASM模块。

现在，我们需要将C++文件转换为浏览器能够理解的预编译WASM模块。

> _有多种方法可以将高级语言代码转换为WASM。但在本教程中，我们将使用Web Assembly Explorer[2]。_

**步骤1：**复制粘贴C++代码，然后点击编译（compile）。  
**步骤2：**点击汇编（assemble）。  
**步骤3：**下载wasm文件。

编译和汇编之后(步骤1，步骤2)

_将下载的文件复制粘贴到项目目录，命名为“math.wasm”。_

##### 3. 分发模块——通常可以使用CDN实现低延迟分发，但在这个演示中，我们只在本地运行WASM文件。

创建`script.js`，暂时存为空文件。

你的项目目录应该如下所示。

项目目录视图

##### 4. 加载WASM模块

我们将创建`loadWebAssembly()`函数将给定文件转换为数组缓冲区。然后，该二进制数组缓冲区可以被转换为WebAssembly模块。创建数组缓冲区的需求与Web汇编内存[3]有关。浏览器可以读取该模块实例。

你的`script.js`看起来差不多像这样。

```jsx
let math;
// Let's create a function called loadWebAssembly that converts given file into binary array buffer.
function loadWebAssembly(fileName) {
  return fetch(fileName)
    .then(response => response.arrayBuffer())
    .then(buffer => WebAssembly.compile(buffer)) // Buffer converted to Web Assembly 
    .then(module => {return new WebAssembly.Instance(module) }); // Instance of Web assmebly module is returened 
};   

//We call the function for math.wasm for the given Instance. 
loadWebAssembly('math.wasm')
  .then(instance => {
   
  }); 
```

##### 5. 创建模块实例。

下面是最棘手的部分，我们需要在JS文件中引用C++创建的函数。我们不能直接引用这些函数，而是需要使用在WASM文件中生成的名字，这些名字定义在Web Assembly Explorer的WAT列中。

使用下图中带下划线的函数名。

要引用的变量加了下划线

_在你的WAT文件中，名字可能不一样。_

> _在`script.js`中，第1部分是关于加载WASM文件。_
> 
> _第2部分提供了一些简单的javascript函数，用于比较javascript和WebAssembly的性能。🤓_

```jsx
//---------------------------PART 1--------------------------------------------------------
// Let's create a function called loadWebAssembly that converts given file into binary array buffer.
function loadWebAssembly(fileName) {
  return fetch(fileName)
    .then(response => response.arrayBuffer())
    .then(buffer => WebAssembly.compile(buffer))
    .then(module => {return new WebAssembly.Instance(module) });
};   

//We call the function for math.wasm
loadWebAssembly('math.wasm')
  .then(instance => {
  fibc = instance.exports._Z3fibi;

    console.log('Call your functions !');
  });

//---------------------------PART 2 -----------------------------------------------
// Function written in Javascript for nth fibonacci 
  function fibj(n)
{
   if (n <= 1)
      return n;
   return fibj(n-1) + fibj(n-2);
}
  
//This function gives the time required for C++ function
function perfoc(n){
var startTime = performance.now()

var c=fibc(n)
    
var endTime = performance.now()

console.log(`Calculating nth Fibonacci with WASM took ${endTime - startTime} milliseconds,nth fibonacci is ${c}`)

}

// This function gives the time required for Javascript function
function perfoj(n){
  var startTime = performance.now()
  
  var j=fibj(n)
      
  var endTime = performance.now()
  
  console.log(`Calculating nth Fibonacci with JS took ${endTime - startTime} milliseconds, nth fibonacci is ${j}`)
  
  }
```

##### 6. 调用实例函数。

现在可以在本地主机上加载网站并完成演示！

> 注意：不能直接运行index.html，因为这样就不会加载WASM模块，可以用Visual Studio Code的Live Server扩展[4]或者Xampp拉起本地主机上的项目目录。

转到控制台，我们可以调用以下两个函数。

1. `fibj()`→这是用简单的Javascript编写的。
2. `fibc()`→这是用C++编写的，然后转换为WebAssembly。

两个函数，fibj()和fibc()

下面是纯JavaScript编写的函数(`fibj()`)和从WebAssembly导入的函数(`fibc()`)之间的比较。

![](//upload-images.jianshu.io/upload_images/15825758-81a04289ecf4b36e.gif?imageMogr2/auto-orient/strip|imageView2/2/w/600/format/webp)

![](//upload-images.jianshu.io/upload_images/15825758-992ac99dbf2ebfe5.gif?imageMogr2/auto-orient/strip|imageView2/2/w/600/format/webp)

WebAssembly快得多

`fibj()`和`fibc()`的执行时间是通过以下函数度量的：

1. `perfoj()`→告诉我们`fibj()`所消耗的时间
2. `perfoc()`→告诉我们`fibc()`所消耗的时间

正如我们在上面的GIF中所看到的，`fibj()`(用JavaScript编写)所花费的时间比`fibc()`(用WebAssembly编写)要高。

---

# WebAssembly是Web应用的未来吗？

通过web汇编，我们可以开发接近原生性能的高性能web应用程序，可以执行视频处理、3D渲染、多媒体游戏、加密计算和AR/VR实时应用程序等任务。

因此，基本上，任何需要大量编码和性能优化的应用程序都是WebAssembly的完美用例。

你可以自己尝试任何可能性！🧑🔧

本文所有代码在这里：[https://github.com/Chandrashekhar-D/Introduction-to-WASM/](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2FChandrashekhar-D%2FIntroduction-to-WASM%2F)

---

参考内容：  
[1]：官方网站。什么是WebAssembly？[https://webassembly.org/](https://links.jianshu.com/go?to=https%3A%2F%2Fwebassembly.org%2F)  
[2]：Mozilla。加载和运行WebAssembly。[https://developer.mozilla.org/en-US/docs/WebAssembly/Loading_and_running](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fen-US%2Fdocs%2FWebAssembly%2FLoading_and_running)  
[3]：Lin Clark: 用动画介绍WebAssembly。[https://youtu.be/HktWin_LPf4](https://links.jianshu.com/go?to=https%3A%2F%2Fyoutu.be%2FHktWin_LPf4)  
[4]：Guy Royse: WebAssembly简介 [https://youtu.be/3sU557ZKjUs](https://links.jianshu.com/go?to=https%3A%2F%2Fyoutu.be%2F3sU557ZKjUs)  
[5]：Priyesh Patel: JavaScript到底是如何工作的？[https://blog.bitsrc.io/how-does-javascript-really-work-part-1-7681dd54a36d](https://links.jianshu.com/go?to=https%3A%2F%2Fblog.bitsrc.io%2Fhow-does-javascript-really-work-part-1-7681dd54a36d)

> **References:**  
> [1] [https://medium.com/dscvitpune/introduction-to-webassembly-wasm-54d505d6d569](https://links.jianshu.com/go?to=https%3A%2F%2Fmedium.com%2Fdscvitpune%2Fintroduction-to-webassembly-wasm-54d505d6d569)  
> [2] [https://mbebenita.github.io/WasmExplorer/](https://links.jianshu.com/go?to=https%3A%2F%2Fmbebenita.github.io%2FWasmExplorer%2F)  
> [3] [https://www.oreilly.com/library/view/webassembly-the-definitive/9781492089834/ch04.html](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.oreilly.com%2Flibrary%2Fview%2Fwebassembly-the-definitive%2F9781492089834%2Fch04.html)  
> [4] [https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer](https://links.jianshu.com/go?to=https%3A%2F%2Fmarketplace.visualstudio.com%2Fitems%3FitemName%3Dritwickdey.LiveServer)

> 你好，我是俞凡，在Motorola做过研发，现在在Mavenir做技术工作，对通信、网络、后端架构、云原生、DevOps、CICD、区块链、AI等技术始终保持着浓厚的兴趣，平时喜欢阅读、思考，相信持续学习、终身成长，欢迎一起交流学习。  
> 微信公众号：DeepNoMind