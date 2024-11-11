---
created: 2023-11-06T08:20
updated: 2023-11-20 17:12:50
---
# 1. 搭建Vite+Vue3+TypeScript项目
## 1.1. 一、Vite 官网
1. [Home | Vite中文网 (vitejs.cn)](https://vitejs.cn/)
2. [Vite | 下一代的前端工具链 (vitejs.dev)](https://cn.vitejs.dev/)
3. ![[Pasted image 20231103092804.png]]
4. `pnpm create vite`
5. 依次填写项目名称、选择 vue，选择 typescript
6. ![[Pasted image 20231103093229.png]]
7. ![[Pasted image 20231103093246.png]]
8. ![[Pasted image 20231103093256.png]]
9. 然后进入目录，安装依赖，尝试启动服务
   ```js
   cd my_desk_app
  pnpm install
  pnpm run dev
```
## 安装 Electron 相关依赖
如果你自己安装过 Electron 的相关依赖，想必你一定经历过失败、失败、失败。

这里需要借助一个[网站检测服务器响应速度](https://ping.chinaz.com/ "网站检测服务器响应速度")，然后拿到最快响应的ip进行本地配置加快我们的域名解析。

通过该工具可以多个地点Ping服务器以检测服务器响应速度。检查github.com。我都选择国内的，看自己想法选择啊。选择之前自己在本地**ping**一下，通了的话就能使用。

![](https://img-blog.csdnimg.cn/9ed9132c4faf47438a7183e4ce389b92.png)

![](https://img-blog.csdnimg.cn/1626f5c9cac440cbaa23ad322de8c75f.png)

修改 C:\Windows\System32\drivers\etc\hosts

![](https://img-blog.csdnimg.cn/1c0cbdf0d02b4e5eadc943c74c189936.png)

```bash
20.27.177.113 github.com
```
如果设置执行 yarn 出现 RequestError: connect ETIMEDOUT ***.***.***.***:443就更改一下 electron 安装源

```bash
yarn config set electron_mirror https://npmmirror.com/mirrors/electron/
```

安装electron依赖 👇 👇 👇 👇

```bash
yarn add -D electron electron-builder
```

根据官网提供的文档,需要创建一个BrowserWindow装载vite项目,你也可以写一个html页面。 这里我们启动vite项目以后就会产生一个连接，正好把它装载到 BrowserWindow中。

![](https://img-blog.csdnimg.cn/c2be86c0125a42b6b4515d6a348b201c.png)

![](https://img-blog.csdnimg.cn/f760efb4daf944b7a10020c17b701ed0.png)

因为src下面存放的是我们的vite项目，所以在根目录下创建一个electron文件夹，避免后续文件多了以后混淆起来，现在创建这个main.ts就是我们electron的入口文件。名字随便起，知道是干啥的就行。

项目根目录下 electron 文件夹下创建 main.ts 文件

```TypeScript
const { app, BrowserWindow } = require('electron')
let win
/**
* @Description: electron程序入口
* @Author: Etc.End
* @Copyright: TigerSong
* @CreationDate 2023-05-20 14:39:26
*/
const createWindow = () => {
	win = new BrowserWindow({
		width: 1200,
		height: 800,
		minWidth: 1200,
		minHeight: 800,
		center: true,
		skipTaskbar: false,
		transparent: false,
		webPreferences: {
		contextIsolation: false,
		webSecurity: false,
	}
	})
	win.loadURL(
	'http://localhost:5173/'
	)
	win.webContents.openDevTools()
}
app.whenReady().then(() => {
	createWindow()
})
/**
* @Description: 限制只能打开一个页面
* @CreationDate 2023-05-20 14:35:52
*/
const gotTheLock = app.requestSingleInstanceLock()
if (!gotTheLock) {
	app.quit()
} else {
	app.on('second-instance', (event, commandLine, workingDirectory) => {
		if (win) {
			if (win.isMinimized()) win.restore()
			win.focus()
		}
	})
}
app.on('window-all-closed', function () {
	if(process.platform !== 'darwin') app.quit()
})

```

接着修改 package.json 文件
![[Pasted image 20231103093813.png]]
配置完成以后分别启动 yarn dev 和 yarn start，出现以下窗口表示搭建成功了。

![](https://img-blog.csdnimg.cn/20d6ecf828aa4e07b20edf1c268e96f8.jpeg)

## 1.2. 四、优化 😆 😁 😉

因为现在需要启动两个服务，比较麻烦，可以借助concurrently插件整合。一个命令完成多个应用的启动。同时安装cross-env插件设置我们的环境变量。wait-on进行一个端口启动监听。

```bash
yarn add concurrently wait-on cross-env -D
```

![](https://img-blog.csdnimg.cn/03c7dfdcd8a34e238a13155a2987ac76.png)

安装完成以后修改启动和打包命令 

```TypeScript
"scripts": {
	"dev": "concurrently -k \"vite\" \"yarn dev:electron\"",
	"dev:electron": "wait-on tcp:5173 && cross-env NODE_ENV=development electron .",
	"build": "vite build && electron-builder --win --config",
	"build:mac": "vite build && electron-builder --mac --config",
	"build:linux": "vite build && electron-builder --linux --config"
},

```
![](https://img-blog.csdnimg.cn/d7b3f358eb00438f9695c08ecfaf5637.png)

```json
{
"name": "demo",
"private": true,
"version": "0.0.0",
"type": "module",
"main": "electron/main.ts",
"scripts": {
"dev": "concurrently -k \"vite\" \"yarn dev:electron\"",
"dev:electron": "wait-on tcp:5173 && cross-env NODE_ENV=development electron .",
"build": "vite build && electron-builder --win --config",
"build:mac": "vite build && electron-builder --mac --config",
"build:linux": "vite build && electron-builder --linux --config"
},
"build": {
"productName": "TigerSong", // 生成的exe文件名
"copyright": "Copyright @ 2023 TigerSong", //版权
"directories": { // 输出文件夹
"output": "dist"
},
"files": [
"dist/**/*",
"electron/**/*"
],
"nsis": {
"oneClick": false, // 是否一键安装
"allowElevation": true, // 允许请求提升
"allowToChangeInstallationDirectory": true, // 安装时可以修改安装目录
"createDesktopShortcut": false, // 创建桌面图标
"createStartMenuShortcut": false // 创建开始菜单图标
}
},
"dependencies": {
"vue": "^3.2.47"
},
"devDependencies": {
"@vitejs/plugin-vue": "^4.1.0",
"concurrently": "^8.0.1",
"cross-env": "^7.0.3",
"electron": "^24.3.1",
"electron-builder": "^23.6.0",
"typescript": "^5.0.2",
"vite": "^4.3.2",
"vue-tsc": "^1.4.2",
"wait-on": "^7.0.1"
}
}

```

接着修改我们的 electron 文件夹下的 main.ts 文件。

```js
const { app, BrowserWindow } = require('electron')
const path = require('path')
const NODE_ENV = process.env.NODE_ENV
let win
/**
* @Description: electron程序入口
* @Author: Etc.End
* @Copyright: TigerSong
* @CreationDate 2023-05-20 14:39:26
*/
const createWindow = () => {
win = new BrowserWindow({
width: 1200,
height: 800,
minWidth: 1200,
minHeight: 800,
center: true,
skipTaskbar: false,
transparent: false,
webPreferences: {
contextIsolation: false,
webSecurity: false,
}
})
win.loadURL(
NODE_ENV === 'development' ? 'http://localhost:5173/' : `file://${path.join(__dirname, '../dist/index.html')}`
)
if (NODE_ENV === 'development') {
win.webContents.openDevTools()
}
}
app.whenReady().then(() => {
createWindow()
})
/**
* @Description: 限制只能打开一个页面
* @CreationDate 2023-05-20 14:35:52
*/
const gotTheLock = app.requestSingleInstanceLock()
if (!gotTheLock) {
app.quit()
} else {
app.on('second-instance', (event, commandLine, workingDirectory) => {
if (win) {
if (win.isMinimized()) win.restore()
win.focus()
}
})
}
app.on('window-all-closed', function () {
if(process.platform !== 'darwin') app.quit()
})

```

执行 yarn dev 进行检测，出现下面的内容表示配置成功，基础脚手架就已经搭建完成了。

![](https://img-blog.csdnimg.cn/7cb4754b873d474c8fd083a91dc3796c.png)

接着测试我们的打包是否正常。

修改 vite.config.ts

```js
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
export default defineConfig({
base: './',
plugins: [vue()],
})

```

执行 yarn build，这个第一次可能优点慢，看自己的网速如何了。也可能会出现连接失败，下载失败的情况，多尝试几次。

> 问题一
> `pnpm build` 出现过一次失败，github 被墙了，命令行设置有 setproxy 之后，安装成功了。
![[Pasted image 20231103100720.png]]

> 问题二
> Prettier 格式化 ts 文件时报错了
> 原来是 `package.json` 文件中带有注释，导致报错了，干掉注释，解决问题

![](https://img-blog.csdnimg.cn/432a32ee57684d58ba4ea27f2cd7bb0f.png)

像上面一样就说明我们已经打包成功了。打开程序

![](https://img-blog.csdnimg.cn/844c97511b0b48f5871f8cc17c154fe2.jpeg)

运行起来后出现下图表示我们的打包已没有任何问题了。

![](https://img-blog.csdnimg.cn/eeec50e329fc40c99d577b876648c86f.png)

dist目录下还有生成的安装程序，可以拷贝至其他目录进行自定义安装。到此我们的程序已经搭建结束了，接着下一篇开始讲解如何使用electron进行爬虫实现自己音乐播放器。感兴趣的小伙伴可以关注我的[Electron](https://blog.csdn.net/qq_19991931/category_12304922.html?spm=1001.2014.3001.5482 "Electron")专栏，在不断更新中。

![](https://img-blog.csdnimg.cn/9e55a71e147b419b9c05d32588929054.png)