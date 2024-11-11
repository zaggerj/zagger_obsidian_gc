---
created: 2023-11-03T22:29
updated: 2023-11-06T12:24
---
# wasm

‍

因为调用对应的`C/C++`​接口前，还需要先初始化，所以要在`Module.onRuntimeInitialized`​事件后，才能通过`JS`​调用`C/C++`​的内容

wasm异步加载慢于接口响应导致的

可以，要在worker那边加个缓存

​![31SSZ3RI3GA17ZMG_GWNH](31SSZ3RI3GA17ZMG_GWNH-20230725144946-r07ys03.png)​

​![@QYLOPRWNKM25C68BZO](@QYLOPRWNKM25C68BZO-20230725144955-m47gvpo.png)​

WebAssembly

说明 Javascript 引擎的执行过程。 Javascript 先编译为 AST， 然后到 Bytecode. AST 的抽象程度比 Bytecode 要高一级。

​![image](image-20230725145238-u5fsnpn.png)​

### Wasm的技术优势:

1. 性能高效：WASM采用二进制编码，在程序执行过程中的性能优越；
2. 存储成本低：相对于文本格式，二进制编码的文本占用的存储空间更小；
3. 多语言支持：用户可以使用 C/C++/RUST/Go等多种语言编写智能合约并编译成WASM格式的字节码； 如图：

​![image](image-20230725145324-cfc9p0n.png)​

### WebAssembly的虚拟机

WebAssembly(缩写 Wasm)是基于堆栈虚拟机的二进制指令格式。Wasm为了一个可移植的目标而设计的，可用于编译C/C+/RUST等高级语言，使客户端和服务器应用程序能够在Web上部署。WASM 有多种实现，包括浏览器和独立系统，它可以用于视频和音频编解码器、图形和 3D、多媒体和游戏、密码计算或便携式语言实现等应用。

​![image](image-20230725145509-wsznvm8.png)​

[Emscripten安装](https://cntofu.com/book/150/zh/ch1-quick-guide/ch1-01-install.md) Emscripten编译器，是WebAssembly开发的重要工具之一，主要是通过emcc（Emscripten Compiler Frontend）来工作的。这是个命令行工具。

### 参考资料

[wasm官网](https://www.wasm.com.cn/)

[将WebAssembly文本格式转换为wasm](https://developer.mozilla.org/zh-CN/docs/WebAssembly/Text_format_to_wasm)

[Emscripten快速入门](https://cntofu.com/book/150/zh/ch1-quick-guide/readme.md)

‍
