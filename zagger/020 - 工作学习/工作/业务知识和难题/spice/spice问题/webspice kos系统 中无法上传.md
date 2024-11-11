---
UID: 20231105215716
aliases: 
tags:
  - 远程桌面/spice
  - 排查问题/spice
  - 工作/spice/spice问题
source: 
cssclasses: 
created: 2023-11-06
searchterm: 排查问题
updated: 2023-11-13T19:40
---
# 1. webspice kos系统 中无法上传
## 1.1. ✍内容

#记录 排查经过

解决问题 :: `=this.file.name`
编写时间:: `=this.file.mtime`
## 1.2. 排查过程

### 1.2.1. 首先分析前端代码

#### 1.2.1.1. 前端响应事件
```js
// clientgui.js
document.addEventListener('drop', ondrop, false)

// ... 回调中调用了这个

self.fire('fileUpload', [files, dirs])

```

* ![[Pasted image 20231106181122.png]]
#### 1.2.1.2. application中给clientgui监听fileUpload事件
* ![[Pasted image 20231106181347.png]]

#### 1.2.1.3. 调用的onFileUpload方法 最终调用是agent的sendFile方法
* ![[Pasted image 20231106181416.png]]

#### 1.2.1.4. agent.js中的sendFile方法最终调用的handleUpload
* ![[Pasted image 20231106181609.png]]


#### 1.2.1.5. handleUpload方法
* 上传数据(`this.uploadQueue`)的队首部设为item，判断是字符串，给agent发送`VD_AGENT_MAKEDIR`消息,并设置好`_lastDir`，创建好FileXferTask的实例为上传任务， 最终给每一个上传任务监听了start、transfer、cancel、finished事件，然后开始上传任务
* 上传数据(`this.uploadQueue`)的队首部设为item，判断数字，给agent发送`VD_AGENT_FILE_RECEIVE_SIZE`
* `this.sendMessage(VD_AGENT_FILE_RECEIVE_SIZE, size64)`
* ![[Pasted image 20231106181717.png]]
* ![[Pasted image 20231106182618.png]]

#### 1.2.1.6. 'transfer'事件谁在调用
* ![[Pasted image 20231106182838.png]]
* transferTask方法调用的`self.fire('transfer'`
* tranfer方法调用的transferTask方法![[Pasted image 20231106182936.png]]
* 猜测谁调用的`task.transfer()`

#### 1.2.1.7. agent.js中的onAgentData 在解析agent消息，表示收到了agent的`VD_AGENT_FILE_XFER_STATUS`消息之后调用`task.transfer()`
* ![[Pasted image 20231106183127.png]]
* main process中收到主进程的agent消息`SPICE_MSG_MAIN_AGENT_DATA`之后，会调用`onAgentData`来解析agent消息
* ![[Pasted image 20231106183323.png]]

#TODO 这里需要梳理一个流程图，说明清楚上传的消息传递路线！

### 1.2.2. 沟通guesttool 李文龙

* 问题：怎么判断kos 装好了guesttool？
 答： `/usr/local/VDI/agent`
![[IE@{C]Q[UAWJH)ARMJKU5@U.png]]


### 1.2.3. 沟通刘伟帅
* 问：如何判断kos系统是否装好了guesttool？
* 答：/usr/local/VDI/agent这个进程跑没跑就行
* 问：VD_AGENT_FILE_XFER_STATUS和VD_AGENT_FILE_RECEIVE_FILE_LIST消息为啥没有发？
* 答：这个是和spice-vdagent通信，看一下这个进程在不
![[64S)X1M@DEI)E2NWVXYF2R9.png]]
* 继续看：/var/log/syslog日志看看有没有打印
![[[~K(71OO1}}VQG9IP3{7UDA.png]]
### 1.2.4. 沟通阮志鹏

* 问：kos无法上传，为啥收不到收不到VD_AGENT_FILE_XFER_STATUS  VD_AGENT_FILE_RECEIVE_FILE_LIST 消息？
* 答：`VD_AGENT_FILE_FREESPACE_STATUS`消息
* 问：web这边没有这个消息，值是多少？代表啥意思？应该处理啥逻辑？
* 问：张之前联调吗？
* 附上证据：![[}[YAY}4`V3EH[RB]0}29_00.png]]
* 问：用windows端可以使用，需要对下协议？`VD_AGENT_FILE_FREESPACE_STATUS`这个消息你那是没有是吧？这个消息只是判断属于空间的，剩余空间
* 自答：那就不应该发VD_AGENT_FILE_RECEIVE_SIZE这个消息，21年9月改的  到现在没改过这个流程了，需要找环境看下；
* 问：是这个消息吧?`VD_AGENT_FILE_RECEIVE_FILE_LIST`
* 问：我给你加一个，前端先不改
* 问：为啥总是web不行 客户端可以啊？
* 答：我想起来了  当时改这个文件传输的时候 避免web的改动，原本应该返回VD_AGENT_FILE_FREESPACE_STATUS消息的地方加了一个适配web端的返回VD_AGENT_FILE_RECEIVE_FILE_LIST，国产化桌面当时没提上日程 就没改
* 终于破案了



### 1.2.5. 发现是agent 这边 没有适配web端

