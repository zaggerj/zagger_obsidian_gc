---
mindmap-plugin: basic
created: 2023-11-03T22:29
updated: 2023-11-10T15:21
---

# spice websocket 消息的处理流程

## websocket 功能
- wdi.SocketQueue
    - 位于 socketqueue.js
        - wdi.SocketQueue 是一个带有数据缓冲功能的 wdi.Socket 的封装
        - 什么是数据缓冲功能？在一般的消息处理流程里面，每一次的 message 事件即代表了一个完整的消息，它包含一个业务完整的数据包，而对 wdi.SocketQueue 来说，每次收发的数据包可能不是完整的，因此在实际发送之前，需要确保数据包是完整的，而在数据完整之前，不完整的数据是应当被缓冲的。
- wdi.Socket
    - 位于 socket.js
        - wdi.Socket 是对浏览器原生 WebSocket 对象的封装

## websocket 消息解析
- wdi.PacketController
    - 位于 packetcontroller.js
        - 3. wdi.PacketController 利用 wdi.SizeDefiner 识别这些单元
- wdi.PacketExtractor
    - 位于 packetextractor.js
        - 2. wdi.PacketExtractor 将每一个数据包分解为很小的 spice 协议数据单元
- wdi.PacketReassembler
    - 位于 packetreassembler.js
        -
            - 1. wdi.PacketReassembler 利用 wdi.PacketController 将缓冲的消息转换为完整的消息
        -
            - 4. 到了 wdi.PacketReassembler 又把这些单元合并为一个完整的消息。
- wdi.SizeDefiner
    - 位于 sizedefiner.js
        - this.status
            - STATUS_READY: 0,
                 STATUS_REPLY: 1,
                 STATUS_REPLY_BODY: 2,
                 STATUS_ERROR_CODE: 3,
                 STATUS_MESSAGE: 4,
                 STATUS_HEADER: 5,
                 STATUS_BODY: 6,
        - init: function(c) {
                  this.status = this.STATUS_READY;
             },
        - getSize
        - getReplyBodySize
            - wdi.GlobalPool
                - pools
                    - 全局缓存对象
                - retained
                    - 全局缓存image对象和canvas对象
                - init
                - createCanvas
                - create
                - discard
                    - 判断是否为自动释放
                -

## cleanPool
- wdi.GenericObjectPool
    - discard丢弃
        参数为poolIndex
        - 释放某个index
            并维护好this.freeElems
- getBodySizeFromArrayHeader
    - wdi.SpiceDataHeader
        - marshall集结待发
            demarshall散装
            - 将元素数据尾部拼接好16进制的this.type和32进制的this.size
                将封装好的数据，散装，取出size和type
        - 调用demarshall方法
            - 拿到header数据中的size
- getStatus
    - 根据是否为header消息，返回正确的消息状态

## websocket 消息派发
- wdi.SpiceChannel
    - 位于 spicechannel.js
        - 5. 消息派发对象 wdi.SpiceChannel，一个 spice websocket 消息已经开始按照 spice 协议工作了
    - 整个 network 目录来看，wdi.SpiceChannel 是对外暴露的主要接口
    - 但从消息派发流程来看，wdi.SpiceChannel 仅仅是开始
    - 因为接下来的消息还需要格式化，从二进制数据变成可以直接在 js 里面使用的对象，然后再次派发给不同的通道消息处理函数
    - ![[Paste image 1691548964921image.png]]
    - spicechannel
       this.fire('channelConnected')
        - spiceconnnection
           为每个channel监听‘channelConnected’事件，事件传递到了spiceconnection的‘channelConnected’，看一下谁监听了spiceconnection的‘channelConnected’事件
           this.channels[channel].addListener('channelConnected', function () {
           
                 this.fire('channelConnected', channel)
               }, this)
            - onChannelConnected: function (params) {
                   this.executeExternalCallback('channelConnected', params)
                 },
               这样oevdi中的执行callback的方法中就知道了channel的参数params
            - application.js
               为spiceConnection监听了‘channleConnected’事件
               this.spiceConnection.addListener('channelConnected', this.onChannelConnected, this)