---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
## vnc业务学习分享

### 功能背景

在产品使用过程中，可能会出现用户的桌面发生故障，需要技术人员进行远程排查的情况，所以在控制台中提供了对VDI办公桌面(个人桌面)远程协助以及VOI、IDV办公桌面远程监看、远程监控的功能。这些功能正是使用vnc的技术来实现的。

### 技术框架

#### vnc

[vnc](https://baike.baidu.com/item/VNC/2906305)全称为虚拟网络控制台，是一种远程网络控制软件。

**优点**：

* **跨平台支持：**包括Windows、Linux，mac等
* **开源：**可以自由获取和修改源代码，满足特定需求
* **配置简单**

**缺点：**

* **功能简单：**不支持usb，视频播放GPU加速等功能
* **带宽占用高：** 由于vnc需要将远程计算机的屏幕图像传输到本地计算机，因此对网络带宽和延迟要求较高，在网络条件较差的情况下，vnc可能会导致图像延迟和卡顿。



##### vnc的组成部分

* vncserver

  该程序运行在被控制的计算机上，负责接收和处理来自vnc客户端的请求，连接成功后可以发送远程计算机的屏幕图像到客户端，实现远程的桌面投影

* vncviewer

  vnc的客户端程序，用于连接和访问远程计算机，vnc客户端负责向vnc服务器发送鼠标和键盘输入，接收和显示远程计算机的屏幕图像，并显示其环境。在连接的过程中需要进行身份验证

* vncpasswd

  vncserver的密码设置工具，用于增加vnc服务的安全性，确保只有知道密码的授权用户能够远程连接并控制你的计算机桌面。

  ![image-20230817110343189](https://s2.loli.net/2023/08/17/GQFjwCMypoqrU7R.png)

##### vnc的工作流程

![image-20230817110332360](https://s2.loli.net/2023/08/17/vzN7J5ORBosgDjw.png)

1. vncserver启动：

   用户在远程计算机上运行vncserver，在首次启动，需要使用vncpasswd来设置连接密码，用于身份验证，vncserver会监听一个指定的端口，等待vncviewer的连接请求。

2. vncviewer启动

   用户在本地计算机上运行vncviewer，用户端输入远程计算机的IP地址或主机名，以及vncserver的端口号，发起连接请求

3. 建立连接(rfb协议)

   vncviewer向vnc服务器发送连接请求，vncserver对请求进行验证和认证。如果连接请求合法，vncserver会建立与vncviewer的连接

4. 屏幕图像传输

   成功连接后，vncserver会将远程计算机的屏幕图像发送给vncviewer

5. 远程控制

   * vncviewer接收来着vncserver的桌面图像后，将这些图像显示在本地的计算机上，实现远程桌面显示
   * 用户在本地计算机上的鼠标和键盘的输入，都会将其转发给vncserver，并在远程计算上执行相应操作


#### noVnc

[noVnc](https://github.com/novnc/noVNC)是一个基于web技术的开源项目，给vnc的远程连接提供了应该web解决方案，它可以让用户直接在浏览器端访问和控制远程计算机桌面，从而替代原本的vncviewer客户端。

##### 优势

* **跨平台支持**。支持 Windows、Linux以及macOS，只要有一款支持 HTML5 的现代浏览器，您都可以使用 noVnc 来访问和控制远程计算机。
* **开源性质**。noVnc 是一个开源项目，这意味着任何人都可以访问并修改其源代码。



#### voi、idv的反向代理

#### 作用

* voi、idv的终端可能不在同一个网段，从而导致本地计算机和远程无法互通，反向代理监听特定端口，来进行转交数据
* 解决vnc的开启端口随机，无法再防火墙规则或安全问题预设端口，导致端口被屏蔽的问题

#### 主要逻辑

![image-20230905113803900](https://s2.loli.net/2023/09/05/SYImDUwsf1Zro6J.png)

* 控制台点击远程，请求接口获取token信息，此时会产生一个token文件在vnc目录下
* 在vnc页面打开会请求一个带token的wss连接，连接到vnc的代理服务
* vnc代理服务会根据wss中的token查找同名的token文件，获取文件中的信息并格式化为请求参数
* vnc代理服务向端发送请求api获取vnc的端口，并创建代理监听改端口，并通知端进行连接
* 连接完成后，端返回图像数据给代理服务器
* 代理服务器将数据转交给wss请求

### 相关代码

在使用的vnc的过程中

```js
// voi和idv
const params = {
	product_type: 'voi' | 'idv',
	view_only: isReadyOnly,
	token: resp.data.token,
	desktop_name: item.name
}

const url = '/voi_vnc/vnc.html?' +
	Object.keys(params).map(function (key) {
	return `${key}=${params[key]}`
}).join('&')
window.open(url)

// vdi
const rows = item ? [item] : $scope.rows.filter(function (row) { return row._selected })
window.open(`/vnc/index.html?id=${rows[0].id}&heartbeat=false`)
```

在我们的项目中都是通过`window.open`去加载vnc对应文件夹下的资源，vnc的文件夹相对于我们整个项目的代码来讲是完全独立的(优化点)

#### 代码结构

文件夹： 

vdi：`ngconsole\vnc`

idv + voi ：`ngconsole\voi_vnc`

> vdi的项目结构只是相当于对voi和idv的文件夹进行压缩后生成的

![image-20230902170340473](https://s2.loli.net/2023/09/02/OEtoSk6AT7y5MnB.png)

* `app`：包含用于构建页面的前端代码和资源文件
  * `images`：图片文件
  * `locale`：翻译json文案
  * `style`：样式文件
  * `ui.js`：处理用户界面相关的逻辑和功能的文件，适配vnc的自定义文件
  * `webutils.js`：辅助工具文件，用于处理web的相关功能逻辑
* `core`：novnc中的核心代码
  * `decoders`：包含解码方法的文件夹
  * `input`：包含定义用户输入(键盘和鼠标)的操作
  * `utils`：工具方法文件
  * `display.js`：包含了图像，分辨率，颜色功能
  * `rfb.js`：rfb协议的js实现
  * `websock.js`：包含了websocket的封装

#### 连接过程

##### vdi

`\app\ui.js`

* 开始

  ```js
  window.open(`/vnc/index.html?id=${rows[0].id}&heartbeat=false`)
  ```

  通过url设置想要连接的桌面id，页面跳转

* 准备工作
  * prime()函数，通过id获取连接的token和password
  * 讲token保存在UI对象中，以token为key将password保存在localStorage中
  * 初始化settings（置为空）
  * start()函数，初始化settings中保存的值
  * 开启心跳
  * 初始化状态栏，控制面板、用户键盘输入等
* 开始连接
  * 执行connect()函数
  * 获取settings中的值，以及localStorage中的密码
  * 设置连接的url
  * 创建RFB对象，RFB内部定义websocket对象
  * 通过url，建立websocket连接

##### voi + idv

`\app\ui.js`

* 开始

  ```javascript
  const params = {
  	product_type: 'voi' | 'idv',
  	view_only: isReadyOnly,
  	token: resp.data.token,
  	desktop_name: item.name
  }
  
  const url = '/voi_vnc/vnc.html?' +
  	Object.keys(params).map(function (key) {
  	return `${key}=${params[key]}`
  }).join('&')
  window.open(url)
  ```

  通过url设置想要连接的桌面token，页面跳转

* 准备工作

  * prime()函数，初始化settings（置为空）
  * start()函数，初始化settings中保存的值
  * 初始化状态栏，控制面板、用户键盘输入等

* 开始连接

  * 执行connect()函数
  * 设置连接的url
  * 创建RFB对象，RFB内部定义websocket对象
  * 通过url，建立websocket连接

#### 数据交互

* 数据接收

  ```
   this._sock.on('message', this._handleMessage.bind(this))
  ```

  * `_normalMsg()`通过获取数据的第一个字节来表示消息的类型
  * 当类型为0时：表示远程的桌面图像发生变化，执行`_framebufferUpdate()`方法
  * 会根据图像数据的编码类型，对接收的图像矩形数据进行处理

* 数据发送

  * 对发送的数据的处理存在`rfb.js`中的`RFB.messages` 对象里

    包含了用于构建和解析 RFB 协议消息的方法，用于在客户端和服务器之间传输输入事件消息

    * `keyEvent` ： 用于构建键盘事件消息
    * `pointerEvent`：用于构建鼠标指针事件消息

### 优化方案

#### 问题

* 控制台的vnc代码与主干功能无关
* 目前vdi和voi、idv使用了两个部分的vnc代码，引入了两遍noVnc的相关源码，导致代码大量重复，增加打包体积
* vnc的代码与源码的耦合程度很高，代码难以修改

#### 优化方案

* 新建[ngconsole-vnc]((http://172.16.203.254/YangZhanpeng/ngconsole-vnc))仓库，将原本的ngconsole中的vnc代码进行抽离，在新仓库中进行整合，优化开发过程

* 只引入一次novnc源码，将vdi、voi、idv的自定义代码进行抽离出单个文件

  一方面，减少相同的代码，减少打包体积，另一方面，将自定义的代码进行抽离，方便后期的库升级或者项目需求更改，利于阅读。

