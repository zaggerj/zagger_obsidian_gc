---
tags: 工作/业务问题
created: 2023-11-03T22:29
updated: 2023-11-13T20:35
---
## OEIDP 库结构

  

打包后的 oeidp 是一个库，它的内容如下：

  

```

oeidp/

├── oeidp.js                    # ES6 版的 OEIDP

├── oeidp.umd.cjs               # 兼容 amd, commonjs 的 OEIDP

├── zstd.js                     # zstd 解码库，支持 AJE 编码

├── 81b3dc321/                  # 流式下载额外库，目前无用，仅做备份

|   ├── sw.js

|   ├── mitm.html

├── oeidp.d.ts                  # 库类型文件

```

  

## 在项目中集成 OEIDP

  

集成 oeidp 到自己的项目里是简单的，推荐直接导入：

  

```js

import OEIDP from './oeidp/oeidp'

  

const oeidp = new OEIDP(options)

```

  

## 功能选项

  

**worker** `Boolean` 默认 false, 是否启用worker, AJE 编码会用到此选项, 为 true 时会加载 zstd.js

  

**mx** `Object` 钩子对象，允许仅指定部分参数

  

* **onFps1Change** `Function` 客户端渲染帧率，接受实时帧率参数

* **onFps2Change** `Function` 服务器发送帧率，需要手动计算

* **onDelayChange** `Function` 网络延迟毫秒值，连接成功后每秒触发 1 次

* **onWriteChange** `Function` 接受 2 个参数 `bytes`, `channel`, `bytes` 表示当前发送的字节数，`channel` 表示通道名称

* **onReadChange** `Function` 接受 2 个参数 `bytes`, `channel`, `bytes` 表示当前发送的字节数，`channel` 表示通道名称

* **onUploadChange** `Function` 接受 2 个参数 `type`, `task`, `type` 表示当前上传的阶段：`start` 开始，`progress` 上传中，`end` 上传结束，`task` 表示当前上传信息，可获取上传文件名，进度等，上传按 1MB 切片上传

* **onDownloadChange** `Function`  接受 2 个参数 `type`, `task`, `type` 表示当前下载的阶段：`start` 开始，`progress` 下载中，`end` 上传结束，`task` 表示当前上传信息，可获取上传文件名，进度等，下载按 1MB 切片下载

  

**el** `HTMLCanvasElement` oeidp 画布对象

  

**url** `string` 通道 websocket 地址

  

**debug** `string` 逗号分隔的通道字符串，如：`image,control`, `*` 表示全部通道

  

**imageOptions** `Object` 图形选项

  

* **type** `string` 传 `h264` 即可

* **quality** `string | Object` 图形质量参数

  

**transferOptions** `Object` 文件传输选项

  

* **enableUpload** `Boolean` 是否启用上传功能，为 false 时禁用拖拽，调用 `uploadFile()` 无效

* **enableDownload** `Boolean` 是否启用下载功能，为 false 时调用 `downloadFile()` 无效

* **onError** `Function` 接受一个 code 参数，表示文件传输过程中发生错误原因

* **onUploadRepeat** `Function` 接受一个 path 参数，表示文件传输过程中 path 对应的文件已经存在，询问是否要覆盖，返回 `Boolean` 或 `Promise<Boolean>`

* **defaultUploadDir** string 默认上传目录，推荐使用 `uploadFile(dir, files)` 为每次上传指定目录

  

**clipboardOptions** `Object` 剪切板选项

  

* **guestToBrowser** `Boolean` 允许传输虚拟机剪切板到浏览器

* **browserToGuest** `Boolean` 允许浏览器传输剪切板到虚拟机

  

## 常见问题

  

1. 如何判断已经连接上了？

2. 设置分辨率不成功？

3. 为什么拖拽了文件，但没有开始上传？

4. 如何跟踪上传/下载进度？

5. 为什么桌面内播放视频没有声音？

6. 为什么剪切板无法读取？

7. 连接为什么断开了？

8. 如何实现重连？

9. 磁盘类型问题，隐藏文件夹问题

10. 如何排查异常问题？

  

### 1. 如何判断已经连接上了？

  

* 看画面

* 看日志

* 看网络

  

```js

const totalChannelCount = 7

let connectedCount = 0

let readyCount = 0

  

oeidp.on('connected', function (channel) {

  connectedCount++

  if (connectedCount === totalChannelCount) {

    // 连接上了，7个通道全部 open

  }

})

  

// 发送 RESPONSE_ID 后 ready

//  client   <------->   server

//               <<1<<     ID

// RESPONSE_ID   >>2>>    

//   *ready*       3

oeidp.on('ready', function (channel) {

  readyCount++

  if (readyCount === totalChannelCount) {

    // 7个通道全部 ready

  }

})

```

  

### 2. 设置分辨率不成功？

  

* 确定服务端是否支持

* 设置的时机，首次不设置

* 最佳策略

  

### 3. 为什么拖拽了文件，但没有开始上传？

  

* 是否处理了 `file-drop` 回调

* 是否允许上传多个文件？重复上传同一个路径、名称，忽略还是上传？

* 是否拖拽了禁止读取的文件？

  

### 4. 如何跟踪上传/下载进度？

  

* 上传时，绑定钩子 `onUploadChange`

  

```js

import prettyBytes from 'pretty-bytes'

  

var startTime = 0

  

function onUploadChange (type, task) {

  if (type === 'start') {

    startTime = Date.now()

  } else if (type === 'progress') {

    var speed = prettyBytes(task.bytes * 1000 / (Date.now() - startTime)) + '/s'

    var progress = `${task.bytes / task.file.size * 100}%`

    var filename = task.fullPath // file.name  a.txt

                                 // a/b/c.txt

    // other code

  } else {

    var progress = '100%'

    // other code

  }

}

```

  

* 下载时，绑定钩子 `onDownloadChange`

  

```js

import prettyBytes from 'pretty-bytes'

  

var startTime = 0

  

function onDownloadChange (type, task) {

  if (type === 'start') {

    startTime = Date.now()

  } else if (type === 'progress') {

    var speed = prettyBytes(task.bytes * 1000 / (Date.now() - startTime)) + '/s'

    var progress = `${task.bytes / task.totalBytes * 100}%`

    // other code

  }} else {

    var progress = '100%'

    // other code

  }

}

```

  

### 5. 为什么桌面内播放视频没有声音？

  

* 桌面内声音设备不是虚拟声卡？OEVAUDIO

* 页面未进行任何操作？

* 查看日志：audio ready!

  

### 6. 为什么剪切板无法读取？

  

* 没有赋予权限

* Chrome 支持读写文本，支持写 png 图像

* Safari 不支持读写文本、图像

* Firefox 支持读文本，不支持写文本

  

### 7. 连接为什么断开了？

  

* 网络

* 桌面异常关闭

* 服务程序异常终止

* 心跳超时

* 日志

  

### 8. 如何实现重连？

  

```js

const totalChannelCount = 7

let destroyCount = 0

  

oeidp.on('destroy', function (channel) {

  destroyCount++

  if (destroyCount === totalChannelCount) {

    if (oeidp.canReconnect()) {

      // oeidp.destroy()

      // new OEIDP()

    } else {

      // 不能重连！不能重连！不能重连！

    }

  }

})

```

  

### 9. 磁盘类型问题，隐藏文件夹问题

  

获取磁盘类型，仅驱动器对象包含此属性

  

```js

oeidp.listCatalog(function (items) {

  var myDesktop = items[0]

  myDesktop.driveType // undefined

  var C = items[2]

  C.driveType // 3 本地磁盘

  var samba = items[3]

  samba.driveType // 4 网络磁盘

  var cdrom = items[4]

  cdrom.driveType // 5 CD 驱动器

})

```

  

### 10. 如何排查异常问题？

  

* 查看当前 build 时间戳

* 查看 websocket 连接状态

* 查看异常日志

* 导出日志

  

新的问题：

  

* 列出目录时由服务器排序？

* 不显示隐藏文件

* 暂停、取消上传