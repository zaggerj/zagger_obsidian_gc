---
tags:
  - 工作/spice/源码学习
created: 2023-11-03T22:29
updated: 2023-11-13T16:51
---
# 1. spice代码文档

# 2. network

　　这个目录里面主要存放和网络数据相关的对象，下面简单描述一个 websocket **消息传输的过程，这个过程可以串联起很多对象，并且可以对** spice **网络层的运作有一个清晰的了解。**

## 2.1. websocket 一般的数据处理流程

　　在继续深入之前，先介绍下 websocket **一般如何处理数据，然后带着这样的理解再描述项目里面数据的处理流程。**

　　websocket **本身处理消息只有一个事件** `message`​**。**​`open`​, `close`​ **仅仅是对链接状态的事件化描述，它们没有收消息的能力。**​`message`​ **事件一般是这样处理的：**  
​`js const ws = new WebSocket("ws://localhost"); ws.addEventListener("message", (e) => {     // 拿到目标消息对象     const message = e.data; }); ​`​  
拿到消息对象后就可以解析消息，一般一个基于 websocket **的应用肯定不止一个消息，所以消息本身肯定会包含消息的类型，或者说消息编号，不同的场景收到的消息的类型、编号自然是不同的，因此收到** `message`​ **事件首要的工作就是分解消息，得到消息的类型，然后派发消息给对应的处理函数：**  
​`js const ws = new WebSocket("ws://localhost"); ws.addEventListener("message", (e) => {     // 拿到目标消息对象     const message = e.data;     const type = getMessageType(message);     dispatchMessage(type, message); }); ​`​  
消息派发完，一次消息的处理过程也就结束了。之后，就是不停的重复这一过程直到链接关闭。

## 2.2. spice websocket 消息的处理流程

　　在我们项目里面，websocket **的消息处理流程在套路上和上面一般的处理流程其实是相同的，但在流程内部，它又做了一些细化。**

　　首先先介绍用于消息处理主要的几个对象：

* ​`wdi.SpiceChannel`​, **位于** spicechannel.js
* ​`wdi.SocketQueue`​, **位于** socketqueue.js
* ​`wdi.Socket`​, **位于** socket.js
* ​`wdi.PacketReassembler`​ **位于** packetreassembler.js
* ​`wdi.PacketController`​, **位于** packetcontroller.js
* ​`wdi.PacketExtractor`​, **位于** packetextractor.js
* ​`wdi.SizeDefiner`​, **位于** sizedefiner.js

　　看起来是不是有点懵逼，就一个消息的解析、派发，怎么用到了这么多对象？对象多并不是说它很复杂，毕竟套路是确定，再怎么复杂化方向是很清晰的，因此对象的作用都是可预测的。上面的几个对象，按照一般 websocket **消息处理流程，我们可以将上面的消息这样分类：**

　　websocket **功能**: `wdi.SocketQueue`​, `wdi.Socket`​

　　websocket **消息解析：**​`wdi.PacketController`​, `wdi.PacketExtractor`​, `wdi.PacketReassembler`​, `wdi.SizeDefiner`​

　　websocket **消息派发：**​`wdi.SpiceChannel`​

　　我们先说 websocket **功能的两个对象。**​`wdi.Socket`​ **是对浏览器原生** WebSocket **对象的封装，而** `wdi.SocketQueue`​ **是一个带有数据缓冲功能的** `wdi.Socket`​ **的封装。什么是数据缓冲功能？在一般的消息处理流程里面，每一次的** `message`​ **事件即代表了一个完整的消息，它包含一个业务完整的数据包，而对** `wdi.SocketQueue`​ **来说，每次收发的数据包可能不是完整的，因此在实际发送之前，需要确保数据包是完整的，而在数据完整之前，不完整的数据是应当被缓冲的。**

　　消息处理的对象有点多，但如果你看了代码，其实每个对象的代码都不是很多。这些对象的是这样交互的： `wdi.PacketReassembler`​ **利用** `wdi.PacketController`​ **将缓冲的消息转换为完整的消息，**​`wdi.PacketExtractor`​ **将每一个数据包分解为很小的** spice **协议数据单元，**​`wdi.PacketController`​ **利用** `wdi.SizeDefiner`​ **识别这些单元，到了** `wdi.PacketReassembler`​ **又把这些单元合并为一个完整的消息。**

　　如果上面两部分的对象都是骚操作的话，那么消息派发对象 `wdi.SpiceChannel`​ **算是比较正经的了。因为从这里开始，一个** spice websocket **消息已经开始按照** spice **协议工作了。从整个** network **目录来看，**​`wdi.SpiceChannel`​ **是对外暴露的主要接口，但从消息派发流程来看，**​`wdi.SpiceChannel`​ **仅仅是开始，因为接下来的消息还需要格式化，从二进制数据变成可以直接在** js **里面使用的对象，然后再次派发给不同的通道消息处理函数，下图简要描述了这个过程：**

　　​`​              ┏━━━━━━━━━━━━━━━━━━┓               ┣ wdi.SpiceChannel ┫               ┗━━━━━━━━━━━━━━━━━━┛                        ↓                   首次派发消息                        ↓             ┏━━━━━━━━━━━━━━━━━━━━━┓             ┣ wdi.SpiceConnection ┫             ┗━━━━━━━━━━━━━━━━━━━━━┛                 ↓ ↓              ① 格式化 ② 再次派发消息                 ↓ ↓ ┏━━━━━━━━━━━━━━━━━━━┓ ┏━━━━━━━━━━━━━━━━━━━┓ ┣ wdi.PacketFactory ┫ ┣ wdi.PacketProcess ┫ ┗━━━━━━━━━━━━━━━━━━━┛ ┗━━━━━━━━━━━━━━━━━━━┛                                     ↓                               按通道类型派发                                     ↓                            ┏━━━━━━━━━━━━━━━━━━━━━┓                            ┣ process/*process.js ┫                            ┗━━━━━━━━━━━━━━━━━━━━━┛`​

　　上面就是一个消息从接收到最后被处理的过程，实际上还有一些其它处理过程，但已经属于细枝末叶上的逻辑了。在整个消息处理过程中，消息派发流程是完全按照 spice **协议来进行的，熟悉这个过程有助于加深对于** spice **协议的了解。**websocket **收、解析消息阶段实现的很啰嗦，也不够清晰，一般没问题不用特别关注。**
