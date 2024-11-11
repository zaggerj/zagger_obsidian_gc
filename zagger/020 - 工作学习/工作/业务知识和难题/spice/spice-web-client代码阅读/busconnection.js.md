---
tags:
  - 工作/spice/源码学习
created: 2023-11-03T22:29
updated: 2023-11-13T16:50
---
# 1. busconnection.js

　　init: 接收ws,接收了集群节点选择？，是否是二进制？

　　connect：

　　判断是否用了bus

　　是否用了旧的bus

　　判断是否是支持Modernizr\['websocketsbinary'\]的浏览器

　　接收了busUser、busPass、protocol、host、port、busFIleServerBaseUrl、busSubscritions

　　调用了_connectToNextHost连接下一个host

　　\_connectToNextHost

　　this.clusterNodeChooser.getAnother()获取下一个

　　wdi.Utils.generateWebSocketUrl返回url

　　连接ws

　　setListeners设置监听器

　　disconnect

　　关闭ws

　　setListeners

　　ws.onOpen

　　ws.onMessage

　　ws.onClose

　　ws.onError
