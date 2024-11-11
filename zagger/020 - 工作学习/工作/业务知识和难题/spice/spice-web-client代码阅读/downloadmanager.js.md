---
tags:
  - 工作/spice/源码学习
created: 2023-11-03T22:29
updated: 2023-11-13T16:51
---
# 1. downloadmanager.js

　　// 添加这些局部变量便于代码压缩

　　const SPICE_CHANNEL_MAIN = 1

　　const SPICE_MSGC_MAIN_AGENT_DATA = 107

　　const VD_AGENT_FILE_RECEIVE_START = 16

　　const VD_AGENT_FILE_RECEIVE_STATUS = 17

　　const VD_AGENT_FILE_RECEIVE_DATA = 18

　　const VD_AGENT_FILE_RECEIVE_FILE_LIST = 19

　　const VD_AGENT_FILE_XFER_STATUS_CAN_SEND_DATA = 0

　　const VD_AGENT_FILE_XFER_STATUS_CANCELLED = 1

　　const VD_AGENT_FILE_XFER_STATUS_SUCCESS = 3

　　/\*\*

　　\* 从虚拟机下载文件的任务

　　\* 使用自定义证书时，需要为浏览器添加下面的启动参数

　　\*  --ignore-certificate-errors --unsafely-treat-insecure-origin-as-secure=https://172.16.103.192:3590

　　\*/

　　wdi.DownloadManager = \$.spcExtend(wdi.EventObject.prototype, {

　　agent: null,

　　tasks: {},

　　// 初始化方法

　　init: function (agent) {

　　  this.superInit()

　　// 代理

　　  this.agent = agent

　　  this.tasks = {}

　　  this.\_todoFiles = null

　　},

　　// 设置长度？

　　setLength: function (n) {

　　  this.\_len = n

　　},

　　// 开始

　　onStart: function (files) {

　　  this.\_doReceive(files)

　　},

　　//

　　sendAgentPacket: function (type, data) {

　　  const packet = new wdi.SpiceMessage({

　　    messageType: SPICE_MSGC_MAIN_AGENT_DATA,

　　    channel: SPICE_CHANNEL_MAIN,

　　    args: new wdi.VDAgentMessage({

　　      protocol: 1, // agent protocol version, should be unhardcoded

　　      type: type,

　　      opaque: 0,

　　      data: data

　　    })

　　  })

　　  this.agent.sendAgentPacket(packet)

　　},

　　onData: function (data) {

　　  const task = this.tasks\[data.id\]

　　  if (!task) { return }

　　  task.bytesRead += data.data.length

　　  if (!task.downloading) {

　　    this.download(task)

　　    task.downloading = true

　　    task.startTime = Date.now()

　　  }

　　  task.onData(data.data)

　　  if (task.bytesRead \>= task.size) {

　　    wdi.Debug.log('download:', task.id, task.name, 'successfully!\nspeed:', task.size / 1024 / ((Date.now() - task.startTime) / 1000), 'KB/s')

　　    task.onEnd()

　　  } else {

　　    this.sendAgentPacket(VD_AGENT_FILE_RECEIVE_STATUS, new wdi.VDAgentFileXferStatus({

　　      id: task.id,

　　      status: VD_AGENT_FILE_XFER_STATUS_CAN_SEND_DATA

　　    }))

　　  }

　　},

　　sendStart: function () {

　　  this.sendAgentPacket(VD_AGENT_FILE_RECEIVE_START, wdi.VDAgentEmptyData)

　　},

　　\_doReceive: function (files) {

　　  for (let i = 0, len = files.length; i \< len; i++) {

　　    files\[i\].bytesRead = 0

　　    files\[i\].buffer = \[\]

　　    this.tasks\[files\[i\].id\] = files\[i\]

　　    wdi.Debug.log('download:', files\[i\].id, files\[i\].name, 'start')

　　    const data = new wdi.VDAgentFileXferStatus({

　　      id: files\[i\].id,

　　      status: VD_AGENT_FILE_XFER_STATUS_CAN_SEND_DATA

　　    })

　　    if (files\[i\].size \> 0) {

　　      this.sendAgentPacket(VD_AGENT_FILE_RECEIVE_STATUS, data)

　　    } else {

　　      wdi.Debug.log('download:', 'size is 0, start immediately')

　　      this.download0(files\[i\])

　　    }

　　  }

　　},

　　onFinish: function (task, status = VD_AGENT_FILE_XFER_STATUS_SUCCESS) {

　　  wdi.Debug.log(\`download task \${task.id} finish: \${status}\`)

　　  this.sendAgentPacket(VD_AGENT_FILE_RECEIVE_STATUS, new wdi.VDAgentFileXferStatus({

　　    id: task.id,

　　    status

　　  }))

　　  Object.keys(this.tasks).length === 1 && this.agent.notifyDownload(25 /\* VD_AGENT_DOWNLOAD_OFF \*/)

　　},

　　download0: function (task) {

　　  require('downloadjs')(new Blob(\[\]), task.name)

　　  this.onFinish(task)

　　  delete this.tasks\[task.id\]

　　},

　　download: function (task) {

　　  const self = this

　　  const streamSaver = require('streamsaver')

　　  // streamSaver.mitm = "/lib/mitm.html";

　　  streamSaver.mitm = 'https://mystorp.gitee.io/static'

　　  const writer = streamSaver.createWriteStream(task.name, {

　　    size: task.size, // (optional) Will show progress

　　    writableStrategy: undefined, // (optional)

　　    readableStrategy: undefined // (optional)

　　  }).getWriter()

　　  let databuffer = \[\]; let bufsize = 0; let pending = true

　　  const flush = function (isEnd = false) {

　　    writer.ready.then(function () {

　　      const onebuf = new Uint8Array(bufsize)

　　      let offset = 0

　　      for (let i = 0, len = databuffer.length; i \< len; i++) {

　　        onebuf.set(databuffer\[i\], offset)

　　        offset += databuffer\[i\].length

　　      }

　　      databuffer = \[\]

　　      bufsize = 0

　　      writer.write(onebuf).finally(()=\>{

　　        isEnd && writer.close()

　　      })

　　    }, function () {

　　      if (writer.desiredSize === null \|\| writer.desiredSize === 0) {

　　        task.onEnd('abort')

　　      }

　　    })

　　  }

　　  const beforeunload = function () {

　　    if (pending) {

　　      writer.abort()

　　    }

　　  }

　　  task.onData = function (chunk) {

　　    if (!pending) { return }

　　    bufsize += chunk.length

　　    databuffer.push(chunk)

　　    if (bufsize \>= 1024 \* 1024) {

　　      flush()

　　    }

　　  }

　　  task.onEnd = function (reason) {

　　    pending = false

　　    window.removeEventListener('beforeunload', beforeunload)

　　    if (reason) {

　　      wdi.Debug.error('task ended:', reason)

　　      writer.abort()

　　      self.onFinish(task, VD_AGENT_FILE_XFER_STATUS_CANCELLED)

　　    } else {

　　      flush(true)

　　      self.onFinish(task)

　　    }

　　    delete self.tasks\[task.id\]

　　  }

　　  window.addEventListener('beforeunload', beforeunload)

　　},

　　cancel: function () {

　　  this.\_todoFiles = null

　　}

　　})
