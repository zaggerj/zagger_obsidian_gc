---
tags:
  - 工作/spice/源码学习
created: 2023-11-03T22:29
updated: 2023-11-13T16:50
---
# 1. agent.js

　　onAgentData-VD_AGENT_FILE_RECEIVE_START事件触发，如果上一个文件下载的过程不被处理，下一个下载会一直等待上一次的过程，只到下载结束。

　　// 添加这些局部变量便于代码压缩

　　const SPICE_CHANNEL_MAIN = 1

　　const SPICE_MSGC_MAIN_AGENT_START = 106

　　const SPICE_MSGC_MAIN_AGENT_DATA = 107

　　const SPICE_MSGC_MAIN_AGENT_TOKEN = 108

　　// Agent capabilities

　　const VD_AGENT_CAP_MOUSE_STATE = 0

　　const VD_AGENT_CAP_MONITORS_CONFIG = 1

　　const VD_AGENT_CAP_REPLY = 2

　　const VD_AGENT_CAP_CLIPBOARD = 3

　　const VD_AGENT_CAP_DISPLAY_CONFIG = 4

　　const VD_AGENT_CAP_CLIPBOARD_BY_DEMAND = 5

　　const VD_AGENT_CAP_CLIPBOARD_SELECTION = 6

　　// agent messages

　　const VD_AGENT_MOUSE_STATE = 1

　　const VD_AGENT_MONITORS_CONFIG = 2

　　const VD_AGENT_REPLY = 3

　　const VD_AGENT_CLIPBOARD = 4

　　const VD_AGENT_DISPLAY_CONFIG = 5

　　const VD_AGENT_ANNOUNCE_CAPABILITIES = 6

　　const VD_AGENT_CLIPBOARD_GRAB = 7

　　const VD_AGENT_CLIPBOARD_REQUEST = 8

　　const VD_AGENT_CLIPBOARD_RELEASE = 9

　　const VD_AGENT_FILE_XFER_START = 10

　　const VD_AGENT_FILE_XFER_STATUS = 11

　　const VD_AGENT_FILE_XFER_DATA = 12

　　const VD_AGENT_CLIENT_DISCONNECTED = 13

　　const VD_AGENT_MAX_CLIPBOARD = 14

　　const VD_AGENT_AUDIO_VOLUME_SYNC = 15

　　const VD_AGENT_FILE_RECEIVE_START = 16

　　const VD_AGENT_FILE_RECEIVE_STATUS = 17

　　const VD_AGENT_FILE_RECEIVE_DATA = 18

　　const VD_AGENT_FILE_RECEIVE_FILE_LIST = 19

　　const VD_AGENT_WEB_VIDEO_REDIRECT = 20

　　const VD_AGENT_LOCLA_VIDEO_REDIRECT = 21

　　const VD_AGENT_FILE_RECEIVE_SIZE = 22

　　const VD_AGENT_NEOKYLIN_MONITOR_CONFIG = 23

　　const VD_AGENT_DOWNLOAD_ON = 24

　　const VD_AGENT_DOWNLOAD_OFF = 25

　　const VD_AGENT_VIDEO_REDIRECT_STATE = 26

　　const VD_AGENT_EXT_CLOUD_APP = 27

　　const VD_AGENT_END_MESSAGE = 28

　　const VD_AGENT_FILE_REQUEST = 29

　　const VD_AGENT_MAKEDIR = 30

　　const VD_AGENT_FILE_START_SEQ = 31

　　const VD_AGENT_FILE_STOP_SEQ = 32

　　// clipboard

　　const VD_AGENT_CLIPBOARD_NONE = 0

　　const VD_AGENT_CLIPBOARD_UTF8_TEXT = 1

　　const VD_AGENT_CLIPBOARD_IMAGE_PNG = 2 /\* All clients with image support should support this one \*/

　　const VD_AGENT_CLIPBOARD_IMAGE_BMP = 3 /\* optional \*/

　　const VD_AGENT_CLIPBOARD_IMAGE_TIFF = 4 /\* optional \*/

　　const VD_AGENT_CLIPBOARD_IMAGE_JPG = 5 /\* optional \*/

　　// filexfer status

　　const VD_AGENT_FILE_XFER_STATUS_CAN_SEND_DATA = 0

　　const VD_AGENT_FILE_XFER_STATUS_CANCELLED = 1

　　const VD_AGENT_FILE_XFER_STATUS_ERROR = 2

　　const VD_AGENT_FILE_XFER_STATUS_SUCCESS = 3

　　const VD_AGENT_FILE_XFER_STATUS_NOT_ENOUGH_SPACE = 4

　　const VD_AGENT_FILE_XFER_STATUS_SESSION_LOCKED = 5

　　const VD_AGENT_FILE_XFER_STATUS_VDAGENT_NOT_CONNECTED = 6

　　const VD_AGENT_FILE_XFER_STATUS_DISABLED = 7

　　const VD_AGENT_FILE_XFER_STATUS_CANCELLED_ALL = 8

　　const VD_AGENT_FILE_XFER_STATUS_FILE_NOTEXIST = 9

　　const VD_AGENT_FILE_XFER_STATUS_CONTINUE = 10

　　wdi.Agent = \$.spcExtend(wdi.EventObject.prototype, {

　　clientTokens: null,

　　serverTokens: 10,

　　app: null,

　　clipboardContent: null,

　　clipboardGrabbed: false,

　　clipboardRequestReceived: false,

　　clipboardPending: false, // to keep clipboard data until spice sends us its request (clipboardRequestReceived)

　　clipboardEnabled: true,

　　windows: null,

　　taskId: 1,

　　uploadingTask: null,

　　uploadQueue: \[\],

　　\_queue: null,

　　\_resolution: null,

　　init: function (c) {

　　  this.superInit()

　　  this.app = c.app

　　  this.downloadManager = new wdi.DownloadManager(this)

　　  this.\_queue = \[\]

　　},

　　sendInitMessage: function (tokens) {

　　  wdi.Debug.log('agent init:', tokens)

　　  if (tokens) {

　　    this.clientTokens = tokens

　　  }

　　  const conn = this.app.spiceConnection

　　  let packet = new wdi.SpiceMessage({

　　    messageType: SPICE_MSGC_MAIN_AGENT_START,

　　    channel: SPICE_CHANNEL_MAIN,

　　    args: new wdi.SpiceMsgMainAgentTokens({

　　      num_tokens: 10

　　    })

　　  })

　　  conn.send(packet)

　　  this.\_queue = \[\]

　　  let mycaps = (1 \<\< VD_AGENT_CAP_MONITORS_CONFIG)

　　  if (this.clipboardEnabled) {

　　    mycaps = mycaps \| (1 \<\< VD_AGENT_CAP_CLIPBOARD_BY_DEMAND)

　　  }

　　  packet = new wdi.SpiceMessage({

　　    messageType: SPICE_MSGC_MAIN_AGENT_DATA,

　　    channel: SPICE_CHANNEL_MAIN,

　　    args: new wdi.VDAgentMessage({

　　      protocol: 1, // agent protocol version, should be unhardcoded

　　      type: VD_AGENT_ANNOUNCE_CAPABILITIES,

　　      opaque: 0,

　　      data: new wdi.VDAgentAnnounceCapabilities({

　　        request: 0,

　　        caps: mycaps

　　      })

　　    })

　　  })

　　  this.sendAgentPacket(packet)

　　  const { width, height } = this.\_resolution \|\| {}

　　  if (width && height) {

　　    this.setResolution(width, height)

　　  }

　　  packet = new wdi.SpiceMessage({

　　    messageType: SPICE_MSGC_MAIN_AGENT_DATA,

　　    channel: SPICE_CHANNEL_MAIN,

　　    args: new wdi.VDAgentMessage({

　　      protocol: 1, // agent protocol version, should be unhardcoded

　　      type: VD_AGENT_VIDEO_REDIRECT_STATE,

　　      opaque: 0,

　　      data: new wdi.VDAgentRedirectStateMessage()

　　    })

　　  })

　　  this.sendAgentPacket(packet)

　　},

　　setResolution: function (width, height) {

　　  if (!this.app.spiceConnection.agentConnected) {

　　    return

　　  }

　　  wdi.Debug.log('set:', width, 'x', height)

　　  const packet = new wdi.SpiceMessage({

　　    messageType: SPICE_MSGC_MAIN_AGENT_DATA,

　　    channel: SPICE_CHANNEL_MAIN,

　　    args: new wdi.VDAgentMessage({

　　      protocol: 1, // agent protocol version, should be unhardcoded

　　      type: VD_AGENT_MONITORS_CONFIG,

　　      opaque: 0,

　　      data: new wdi.VDAgentMonitorsConfig({

　　        num_of_monitors: 1,

　　        flags: 0,

　　        data: new wdi.VDAgentMonConfig({

　　          width: width,

　　          height: height,

　　          depth: 32,

　　          x: 0,

　　          y: 0

　　        })

　　      })

　　    })

　　  })

　　  this.sendAgentPacket(packet)

　　  this.\_resolution = { width, height }

　　},

　　setClientTokens: function (tokens) {

　　  console.log('tokens:', tokens)

　　  this.clientTokens += tokens

　　  while (this.clientTokens \> 0 && this.\_queue.length \> 0) {

　　    this.app.spiceConnection.send(this.\_queue.shift())

　　    this.clientTokens--

　　  }

　　  const task = this.uploadingTask

　　  if (this.clientTokens \> 0 && task && task.continueUpload) {

　　    task.continueUpload()

　　  }

　　},

　　sendAgentPacket: function (packet) {

　　  if (!this.app.spiceConnection.agentConnected) {

　　    return

　　  }

　　  this.\_queue.push(packet)

　　  while (this.clientTokens \> 0 && this.\_queue.length \> 0) {

　　    this.app.spiceConnection.send(this.\_queue.shift())

　　    this.clientTokens--

　　  }

　　},

　　isConnected: function () {

　　  return this.app.spiceConnection.agentConnected

　　},

　　makeServerTokensEnough: function () {

　　  const packet = new wdi.SpiceMessage({

　　    messageType: SPICE_MSGC_MAIN_AGENT_TOKEN,

　　    channel: SPICE_CHANNEL_MAIN,

　　    args: new wdi.SpiceMsgMainAgentTokens({

　　      num_tokens: 10

　　    })

　　  })

　　  this.app.spiceConnection.send(packet)

　　  this.serverTokens = 10

　　},

　　onAgentData: function (packet) {

　　  this.serverTokens--

　　  if (this.serverTokens === 0) {

　　    this.makeServerTokensEnough()

　　  }

　　  if (packet.incomplete) { return }

　　  const { downloadManager } = this

　　  switch (packet.type) {

　　    case VD_AGENT_ANNOUNCE_CAPABILITIES:

　　      break

　　    case VD_AGENT_CLIPBOARD_GRAB:

　　      if (packet.clipboardType === VD_AGENT_CLIPBOARD_UTF8_TEXT) {

　　        packet = new wdi.SpiceMessage({

　　          messageType: SPICE_MSGC_MAIN_AGENT_DATA,

　　          channel: SPICE_CHANNEL_MAIN,

　　          args: new wdi.VDAgentMessage({

　　            protocol: 1, // agent protocol version, should be unhardcoded

　　            type: VD_AGENT_CLIPBOARD_REQUEST,

　　            opaque: 0,

　　            data: new wdi.VDAgentClipboardRequest({

　　              type: VD_AGENT_CLIPBOARD_UTF8_TEXT

　　            })

　　          })

　　        })

　　        this.sendAgentPacket(packet)

　　      }

　　      break

　　    case VD_AGENT_CLIPBOARD:

　　      this.fire('clipBoardData', packet.clipboardData)

　　      break

　　    case VD_AGENT_CLIPBOARD_REQUEST:

　　      this.clipboardRequestReceived = true

　　      if (this.clipboardPending) {

　　        this.clipboardPending = false

　　        this.sendPaste()

　　      }

　　      break

　　    case VD_AGENT_CLIPBOARD_RELEASE:

　　      // debugger;// we've never seen this packet... if we receive it sometime, please warn somebody!!

　　      this.clipboardGrabbed = false

　　      this.clipboardRequestReceived = false

　　      break

　　    case VD_AGENT_REPLY:

　　      break

　　    case VD_AGENT_FILE_XFER_STATUS:

　　      var taskId = packet.fileXferStatus.id

　　      var task = this.uploadingTask

　　      if (task && task.id === taskId) {

　　        switch (packet.fileXferStatus.status) {

　　          case VD_AGENT_FILE_XFER_STATUS_CAN_SEND_DATA:

　　            wdi.Debug.log('upload:', 'continue')

　　            task.transfer()

　　            return

　　          case VD_AGENT_FILE_XFER_STATUS_CANCELLED:

　　            wdi.Debug.warn('upload:', taskId, ' is cancelled by spice agent!')

　　            task.cancel()

　　            break

　　          case VD_AGENT_FILE_XFER_STATUS_ERROR:

　　            wdi.Debug.warn('upload:', 'Some errors occurred in the spice agent on task', taskId)

　　            task.cancel()

　　            break

　　          case VD_AGENT_FILE_XFER_STATUS_SUCCESS:

　　            wdi.Debug.log('upload:', taskId, ' successfully!')

　　            task.finish()

　　            break

　　          case VD_AGENT_FILE_XFER_STATUS_NOT_ENOUGH_SPACE:

　　          case VD_AGENT_FILE_XFER_STATUS_SESSION_LOCKED:

　　          case VD_AGENT_FILE_XFER_STATUS_VDAGENT_NOT_CONNECTED:

　　          case VD_AGENT_FILE_XFER_STATUS_DISABLED:

　　          case VD_AGENT_FILE_XFER_STATUS_CANCELLED_ALL:

　　          case VD_AGENT_FILE_XFER_STATUS_FILE_NOTEXIST:

　　            task.cancel()

　　            console.log('download error:', packet.fileXferStatus.status)

　　            this.fire('downloadError', packet.fileXferStatus.status)

　　            break

　　          default:

　　            wdi.Debug.warn('upload:', 'Unknown status on task', taskId, 'status', packet.fileXferStatus.status)

　　            task.cancel()

　　            break

　　        }

　　      }

　　      break

　　    case VD_AGENT_FILE_RECEIVE_START:

　　      wdi.Debug.log('download: selecte file,', JSON.stringify(packet.data))

　　      downloadManager.onStart(packet.data)

　　      break

　　    case VD_AGENT_FILE_RECEIVE_STATUS:

　　      wdi.Debug.log('download: \[status\],', packet)

　　      break

　　    case VD_AGENT_FILE_RECEIVE_DATA:

　　      wdi.Debug.log('download: \[data\],', packet)

　　      downloadManager.onData(packet.data)

　　      break

　　    case VD_AGENT_FILE_RECEIVE_FILE_LIST:

　　      // 空间不足

　　      if (packet.data.status === 0) {

　　        this.uploadQueue = \[\]

　　        wdi.Debug.log('upload: no more space!')

　　      } else {

　　        this.handleUpload(packet.data.dir.replace(/\\/g, '/'))

　　      }

　　      break

　　    case VD_AGENT_FILE_RECEIVE_SIZE:

　　      wdi.Debug.log('download: ', packet.data)

　　      downloadManager.sendStart()

　　      break

　　    case VD_AGENT_MAKEDIR:

　　      wdi.Debug.log('download: \[md\] =\> "' + packet.data + '"')

　　      break

　　    case VD_AGENT_FILE_START_SEQ:

　　      downloadManager.setLength(packet.data)

　　      break

　　    case VD_AGENT_FILE_STOP_SEQ:

　　      wdi.Debug.log('download: end!')

　　      break

　　    default:

　　      console.log('unsupported agent message:', packet.type)

　　  }

　　},

　　setClipboard: function (text) {

　　  if (text !== this.clipboardContent) {

　　    this.clipboardContent = text

　　    this.sendGrab()

　　    this.sendPaste()

　　  }

　　},

　　sendGrab: function () {

　　  if (!this.clipboardGrabbed) {

　　    const packet = new wdi.SpiceMessage({

　　      messageType: SPICE_MSGC_MAIN_AGENT_DATA,

　　      channel: SPICE_CHANNEL_MAIN,

　　      args: new wdi.VDAgentMessage({

　　        protocol: 1, // agent protocol version, should be unhardcoded

　　        type: VD_AGENT_CLIPBOARD_GRAB,

　　        opaque: 0,

　　        data: new wdi.VDAgentClipboardGrab({

　　          types: \[VD_AGENT_CLIPBOARD_UTF8_TEXT\]

　　        })

　　      })

　　    })

　　    this.sendAgentPacket(packet)

　　  }

　　},

　　/\*\*

　　   \* Sends the text received from browser to spice

　　   \*

　　   \* @param clipboardContent

　　   \*/

　　sendPaste: function () {

　　  if (this.clipboardRequestReceived) {

　　    const packet = new wdi.SpiceMessage({

　　      messageType: SPICE_MSGC_MAIN_AGENT_DATA,

　　      channel: SPICE_CHANNEL_MAIN,

　　      args: new wdi.VDAgentMessage({

　　        protocol: 1, // agent protocol version, should be unhardcoded

　　        type: VD_AGENT_CLIPBOARD,

　　        opaque: 0,

　　        data: new wdi.VDAgentClipboard({

　　          type: VD_AGENT_CLIPBOARD_UTF8_TEXT,

　　          data: this.clipboardContent

　　        })

　　      })

　　    })

　　    this.clipboardRequestReceived = false

　　    this.sendAgentPacket(packet)

　　  } else {

　　    // we still haven't received the request event from server, we keep the clipboard data until then

　　    this.clipboardPending = true

　　  }

　　},

　　disableClipboard: function () {

　　  this.clipboardEnabled = false

　　},

　　sendFile: function (files, dirs) {

　　  this.uploadQueue.push(files.reduce((n, f) =\> n + f.file.size, 0), ...dirs, ...files)

　　  this.handleUpload()

　　},

　　handleUpload: function (dir) {

　　  let item = null

　　  if (this.uploadQueue.length === 0) { return }

　　  while (typeof (item = this.uploadQueue.shift()) === 'string') {

　　    this.sendMessage(VD_AGENT_MAKEDIR, wdi.SpiceObject.stringToBytesWithConvert(item))

　　  }

　　  if (typeof item === 'number') {

　　    const size64 = wdi.SpiceObject.numberTo64(item)

　　    return this.sendMessage(VD_AGENT_FILE_RECEIVE_SIZE, size64)

　　  }

　　  if (dir) {

　　    this.\_lastDir = dir

　　  } else {

　　    dir = this.\_lastDir

　　  }

　　  const { file, fullPath } = item

　　  const taskId = this.taskId++

　　  const task = new wdi.FileXferTask({

　　    id: taskId,

　　    dir,

　　    file,

　　    fullPath,

　　    agent: this

　　  })

　　  // 暴露事件给外部接口

　　  task.addListener('start', this.onSendFileStart, this)

　　  task.addListener('transfer', this.onSendFileTransfer, this)

　　  task.addListener('cancel', this.onSendFileCanceled, this)

　　  task.addListener('finished', this.onSendFileFinished, this)

　　  this.uploadingTask = task

　　  task.start()

　　},

　　\_syncResolution: function (size) {

　　  if (!this.\_resolution) {

　　    this.\_resolution = {}

　　  }

　　  this.\_resolution.width = size\[0\]

　　  this.\_resolution.height = size\[1\]

　　},

　　/\*\*

　　 \* VD_AGENT_DOWNLOAD_ON = 24

　　 \* VD_AGENT_DOWNLOAD_OFF = 25

　　 \* VD_AGENT_FILE_XFER_STATUS_CANCELLED_ALL = 8

　　 \* VD_AGENT_FILE_XFER_STATUS_CONTINUE = 10

　　 \* @param {24\|25\|8\|10} type

　　 \*/

　　notifyDownload: function (type = VD_AGENT_DOWNLOAD_ON) {

　　  let data

　　  let mtype

　　  if (type === 8 \|\| type === 10) {

　　    mtype = VD_AGENT_FILE_XFER_STATUS

　　    data = wdi.VDAgentFileXferStatus({ id: this.uploadingTask.id, status: type })

　　  } else if (type === 24 \|\| type === 25) {

　　    mtype = type

　　    data = \[\]

　　  } else {

　　    return console.error('unsupported download action:', type)

　　  }

　　  const packet = new wdi.SpiceMessage({

　　    messageType: SPICE_MSGC_MAIN_AGENT_DATA,

　　    channel: SPICE_CHANNEL_MAIN,

　　    args: new wdi.VDAgentMessage({

　　      protocol: 1, // agent protocol version, should be unhardcoded

　　      type: mtype,

　　      opaque: 0,

　　      data

　　    })

　　  })

　　  this.sendAgentPacket(packet)

　　},

　　startDownload: function () {

　　  this.downloadManager.sendStart()

　　},

　　downloadFile: function () {

　　  this.downloadManager.receive()

　　},

　　cancelDownload: function () {

　　  this.downloadManager.cancel()

　　},

　　onSendFileStart: function (params) {

　　  this.fire('sendFileAction', \['start', params\])

　　},

　　onSendFileCanceled: function (params) {

　　  this.destroyTask()

　　  this.handleUpload()

　　  this.fire('sendFileAction', \['canceled', params\])

　　},

　　onSendFileTransfer: function (params) {

　　  this.fire('sendFileAction', \['transfer', params\])

　　},

　　onSendFileFinished: function (params) {

　　  this.fire('sendFileAction', \['finished', params\])

　　  this.destroyTask()

　　  this.handleUpload()

　　},

　　destroyTask: function () {

　　  const task = this.uploadingTask

　　  if (!task) { return }

　　  task.removeListener('start', this.onSendFileStart)

　　  task.removeListener('transfer', this.onSendFileTransfer)

　　  task.removeListener('cancel', this.onSendFileCanceled)

　　  task.removeListener('finished', this.onSendFileFinished)

　　  this.uploadingTask = null

　　},

　　sendMessage: function (type, data) {

　　  const packet = new wdi.SpiceMessage({

　　    messageType: SPICE_MSGC_MAIN_AGENT_DATA,

　　    channel: SPICE_CHANNEL_MAIN,

　　    args: new wdi.VDAgentMessage({

　　      protocol: 1, // agent protocol version, should be unhardcoded

　　      type,

　　      opaque: 0,

　　      data

　　    })

　　  })

　　  this.sendAgentPacket(packet)

　　}

　　})
