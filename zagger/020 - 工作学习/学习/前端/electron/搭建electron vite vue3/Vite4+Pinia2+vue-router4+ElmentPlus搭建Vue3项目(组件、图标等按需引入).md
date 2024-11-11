---
created: 2023-11-06T08:20
updated: 2023-11-06T08:20
---
本文为快速搭建 vite4项目，一些插件的详情就不做过多的解释，都放有官网链接，需要深入了解的小伙伴可自行查看。至于为什么选择使用[vite]( https://vitejs.cn/ "vite")，因为它具备着快速启动、按需编译、模块[热更新](https://so.csdn.net/so/search?q=%E7%83%AD%E6%9B%B4%E6%96%B0&spm=1001.2101.3001.7020)的亮点。归根结底最大的特点就是**快**。vue 的创始人是[尤雨溪](https://so.csdn.net/so/search?q=%E5%B0%A4%E9%9B%A8%E6%BA%AA&spm=1001.2101.3001.7020)大佬，vite 也是他。所以放心大胆的用吧。

## 壹、初始化项目 😆😆😆😆

#### 1️⃣ 通过yarn初始化项目

![](https://img-blog.csdnimg.cn/912453fd3da44d86bc0c96a4ecbe70ad.png)

`yarn create vite 你的项目名称 --template vue-ts`

注：如果没有yarn的可通过npm执行命令**npm install -g yarn**进行安装

#### 2️⃣ 如下图，到这里我们的vite项目就初始化好了，跟着提示，进入ts-super-web(自己的项目名)根目录下执行yarn，下载完依赖后执行yarn dev就可以启动项目。

![](https://img-blog.csdnimg.cn/cc53bdf954f341518ec3486f1f91fae7.png)

![](https://img-blog.csdnimg.cn/2c6d0faae57b4f39844d446d2674afd6.png)

![](https://img-blog.csdnimg.cn/00df347d3dde49a59bdaaf24e90c5abc.png)

3️⃣ **启动成功以后浏览器访问[http://127.0.0.1:5173/](http://127.0.0.1:5173/ "http://127.0.0.1:5173/")** 👇👇👇👇

![](https://img-blog.csdnimg.cn/eaff9b1b618043d58339c22435bfdfe6.png)

## 贰、安装相关依赖 😜😜😜😜

#### 1️⃣ element-plus为UI框架。pinia和vuex一样为状态管理。vue-router路由。nprogress顶部进度条。animate.css一个跨浏览器的动画库。

`yarn add element-plus pinia vue-router nprogress animate.css`

#### 2️⃣ 安装图标库

`yarn add @iconify-json/carbon @iconify-json/ep @iconify-json/noto -D`

#### 3️⃣ 按需引入涉及到的依赖安装

`yarn add unplugin-vue-components unplugin-auto-import unplugin-icons -D`

#### 4️⃣ 其他依赖安装，支持sass，jsx等等

`yarn add sass sass-loader @types/node @vitejs/plugin-vue-jsx -D`

#### 5️⃣ 项目根目录下修改tsconfig.json

```json
{
  "compilerOptions": {
    "target": "esnext", // 目标语言的版本
    "useDefineForClassFields": true,
    "module": "esnext", // 生成代码的模板标准
    "moduleResolution": "node", // 模块解析策略，ts默认用node的解析策略，即相对的方式导入
    "strict": true, // 开启所有严格的类型检查
    "jsx": "preserve", // 指定将 JSX 编译成什么形式
    "jsxFactory": "h", // 当使用经典的JSX运行时编译JSX元素时，更改.js文件中调用的函数，默认：React.createElement 。
    "jsxFragmentFactory": "Fragment",
    "sourceMap": true, // 生成目标文件的sourceMap文件
    "resolveJsonModule": true, // 指定 JSX 片段工厂函数在指定了 jsxFactory 编译器选项的情况下针对 react JSX 发出时使用。
    "esModuleInterop": true, // 允许export=导出，由import from 导入
    // TS需要引用的库，即声明文件，es5 默认引用dom、es5、scripthost,如需要使用es的高级版本特性，通常都需要配置，如es8的数组新特性需要引入"ES2019.Array"
    "lib": [
      "esnext",
      "dom"
    ],
    "types": [
      "vite/client",
      "element-plus/global",
      "unplugin-icons/types/vue"
    ], // 加载的声明文件包
    "baseUrl": ".", // 解析非相对模块的基地址，默认是当前目录
    "skipLibCheck": true, // 忽略所有的声明文件（ *.d.ts）的类型检查。
    "paths": { // 路径映射，相对于baseUrl
      "@/*": [
        "src/*"
      ]
    }
  },
  // 指定一个匹配列表（属于自动指定该路径下的所有ts相关文件）
  "include": [
    "src/**/*.ts",
    "**/*.d.ts",
    "src/**/*.tsx",
    "src/**/*.vue",
    "src/autoImport/*.d.ts"
  ],
  "exclude": [
    "node_modules"
  ]
}
```

## 叁、配置ElementPlus、图标库，vueAPI等按需引入，支持jsx、tsx等 😉😉😉😉

为什么做按需引入，相对于全局引入来说很大程度上的减少了代码体积。

#### 1️⃣ 在项目根目录下修改vite.config.ts

**注：**按需引入这里需要在src文件夹下新建一个autoImport的文件夹存在按需引入生成的文件。这样做的目的是，后期如果传git，可以屏蔽这个文件夹。

```js
import { defineConfig } from 'vite'
import path from 'path'
import vue from '@vitejs/plugin-vue'
import Icons from 'unplugin-icons/vite'
import IconsResolver from 'unplugin-icons/resolver'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'
import vueJsx from '@vitejs/plugin-vue-jsx'
const pathSrc = path.resolve(__dirname, 'src')
export default defineConfig({
  resolve: {
    alias: {
      '@': pathSrc // 文件系统路径别名
    }
  },
  plugins: [
    vue(),
    vueJsx(), // 支持jsx、tsx的写法
    AutoImport({
      imports: ['vue'],
      resolvers: [
        ElementPlusResolver(),
        IconsResolver({
          prefix: 'Icon'
        })
      ],
      dts: path.resolve(pathSrc + '/autoImport', 'auto-imports.d.ts')
    }),
    Components({
      resolvers: [
        ElementPlusResolver(),
        IconsResolver({
          enabledCollections: ['ep', 'carbon', 'noto']
        })
      ],
      dts: path.resolve(pathSrc + '/autoImport', 'components.d.ts')
    }),
    Icons({
      autoInstall: true,
      compiler: 'vue3'
    })
  ],
  server: {
    host: '0.0.0.0', // 指定服务器应该监听哪个 IP 地址
    port: 9527, // 指定开发服务器端口
    strictPort: true, // 若端口已被占用则会直接退出
    https: false, // 启用 TLS + HTTP/2
    open: false // 启动时自动在浏览器中打开应用程序
  }
})
```

#### 2️⃣ 测试ElementPlus、图标以及vue3API等按需引入情况。修改App.vue文件。

```vue
<template>
<el-row :gutter="20">
<el-col :span="6">
<el-button type="primary">Primary</el-button>
</el-col>
<el-col :span="6">
<el-button type="success">Success</el-button>
</el-col>
<el-col :span="6">
<el-button type="info">Info</el-button>
</el-col>
<el-col :span="6">
<el-button type="warning"><i-ep-delete />Warning</el-button>
</el-col>
</el-row>
<br/>
<br/>
<br/>
<el-button type="primary" @click="changeCount">++++</el-button>
<br/>
<br/>
<br/>
<span style="color: red;font-size: 22px;">{{ count }}</span>
</template>
<script lang="ts">
export default defineComponent({
setup() {
let data = reactive({
count: 1,
})
const changeCount = () => {
data.count++
}
return {
changeCount,
...toRefs(data)
}
}
})
</script>

```

#### 3️⃣ 成功运行至下列效果表示按需引入没有任何问题 👇👇👇👇

![](https://img-blog.csdnimg.cn/505f8aac217f441ebb033d4e3c6d7ffb.png)

## 肆、vue-router路由以及路由拦截器配置 😋😋😋😋

至于[vue-router](https://router.vuejs.org/zh/ "vue-router")的话，在vue2大家应该已经很熟悉了，vue全家桶必备知识。

#### 1️⃣ src文件夹下新建router文件夹。接着新建index.ts和permission.ts两个文件。前者是路由，后面是路由拦截器，我喜欢放在一块。你可以根据自己的情况放到其他位置也行。

#### 2️⃣ index.ts 路由配置

```typescript
import { createRouter, createWebHashHistory, RouteRecordRaw } from 'vue-router'
export const asyncRoutes: RouteRecordRaw[] = [
{
path: '/',
name: 'home',
meta: {
title: 'home'
},
component: () => import('@/views/home.vue')
},
{
path: '/home1',
name: 'home1',
meta: {
title: 'home1'
},
component: () => import('@/views/home1.vue')
}
]
const router = createRouter({
history: createWebHashHistory(),
routes: asyncRoutes,
scrollBehavior: () => ({ left: 0, top: 0 })
})
export default router

```

#### 3️⃣ permission.ts路由拦截器,这里面使用到了nprogress顶部加载效果

```typescript
import router from '@/router'
// @ts-ignore
import NProgress from 'nprogress'
import 'nprogress/nprogress.css'
NProgress.configure({
easing: 'ease', // 动画方式
showSpinner: true, // 是否显示加载ico
trickleSpeed: 200, // 自动递增间隔
minimum: 0.4, // 更改启动时使用的最小百分比
})
const whiteList = ['/login', '/redirect']
router.beforeEach((to, form, next) => {
// 这里处理自己的逻辑,比如需要登录以后才能访问其他页面等等
NProgress.start()
next()
NProgress.done()
})

```

#### 4️⃣ src下main.ts 文件修改

```ts
import { createApp } from 'vue'
import App from './App.vue'
import 'animate.css'
import router from '@/router';
import '@/router/permission'
import 'element-plus/theme-chalk/dark/css-vars.css'
const app = createApp(App);
app.use(router)
app.mount('#app')

```

#### 5️⃣ src下新建views文件夹,文件夹下新建home.vue和home1.vue两个文件

**home.vue**

```vue
<template>
<div style="background: rgb(217, 217, 217);height: 100vh;width: 100%;display: flex;align-items: center;justify-content: center;">
<el-button type="primary" @click="goHome">去home</el-button>
<el-button type="primary" @click="changeCount">++++</el-button>
<div style="color: red;font-size: 22px;">{{ count }}</div>
</div>
</template>
<script lang="ts">
import {useRouter} from "vue-router";
export default defineComponent({
setup() {
const router = useRouter();
let data = reactive({
count: 1,
})
const changeCount = () => {
data.count++
}
const goHome = () => {
router.push({
path: '/home1'
})
}
return {
changeCount,
goHome,
...toRefs(data)
}
}
})
</script>

```

**hom1.vue**

```vue
<template>
<div style="background: #ffffff;height: 100vh;width: 100%;display: flex;align-items: center;justify-content: center;">
<el-button type="primary" @click="goHome1">回home</el-button>
<el-button type="primary" @click="changeCount">++++</el-button>
<div style="color: red;font-size: 22px;">{{ count }}</div>
</div>
</template>
<script lang="ts">
import {useRouter} from "vue-router";
export default defineComponent({
setup() {
const router = useRouter();
let data = reactive({
count: 1,
})
const changeCount = () => {
data.count++
}
const goHome1 = () => {
router.push({
path: '/'
})
}
return {
changeCount,
goHome1,
...toRefs(data)
}
}
})
</script>

```

#### 6️⃣ App.vue修改,这里就使用到了animate.css,给切换路由增加一些动画

```vue
<template>
<router-view #default="{route, Component}">
<transition leave-from-class="ts-web-fade--leave-to" enter-active-class="animate__animated animate__bounceInRight">
<component :is="Component"></component>
</transition>
</router-view>
</template>

```

#### 7️⃣ 项目目录

![](https://img-blog.csdnimg.cn/780b5bec6fb044f2b984d17a958f2418.png)

#### 8️⃣ 最终的效果，可以看到切换路由的时候右上角有个圈圈在转动，因为截屏的原因，看不到顶部的加载条。还可以看到切换路由时的动画。

![](https://img-blog.csdnimg.cn/10b6876bd9a14b0ab7f0b0c0cce36fdd.gif)

 注：这里只是一个简单的搭建demo，所以拦截器没有做过多的扩展。我的另一篇文章有详细讲解动态路由的实现，但是建议先把本篇文章走完以后再去看。[Vite4 + Vue3 + vue-router4 动态路由](https://blog.csdn.net/qq_19991931/article/details/129300550 "Vite4 + Vue3 + vue-router4 动态路由")如果有问题的话可以联系我👉👉SH--TS。

## 伍、pinia状态管理 😱😱😱😱

为啥没有使用vuex而选择[pinia](https://pinia.web3doc.top/ "pinia")来实现状态管理。相对于vuex来说，它更好的支持TypeScript、非常轻巧(体积约 1KB)等等优势。而且尤雨溪大佬也推荐使用。至于它俩如何做选择。可以根据自己的项目情况，如果是中小型项目的话推荐pinia。如果大规模、高复杂度的话就选vuex。

#### 1️⃣ src文件夹下新建pinia，以及文件夹下新建index.ts等等。如下图

![](https://img-blog.csdnimg.cn/cff7301899ae4cedbdacd10ae25bff42.png)

#### 2️⃣ /pinia/modules/views.ts

```ts
import { defineStore } from 'pinia'
export interface IViewsState {
count?: number
title?: string
}
// 创建一个pinia, defineStore接受两个参数，第一个是id(唯一的)。参数二是配置项
export const viewsModule = defineStore('VIEWS',{
state(): IViewsState {
return {
count: 1,
title: 'Etc.End'
}
},
//可以操作异步 和 同步提交state
actions:{
// 这里因为我的count定义的类型不是必有参数,所有它会存在空的情况.
// 后面只需要加个!让编译器知道它不会未定义或不会为null
// 也可以把上面的count?: number更改为count: number,下面就不用加!了
incremental() {
this.count!++
},
getCount() {
return this.count
}
},
// 类似于computed 可以帮我们去修饰我们的值
getters:{
newCount ():number | string {
return this.count = 0
},
newTitle ():string {
return `$-${this.title}`
}
},
})

```

#### 3️⃣ /pinia/index.ts

```ts
import { viewsModule } from './modules/views';
export interface IAppStore {
viewsModule: ReturnType<typeof viewsModule>;
}
const appStore: IAppStore = {} as IAppStore;
export const registerStore = () => {
appStore.viewsModule = viewsModule();
};
export default appStore;

```

#### 4️⃣ main.ts

```ts
import { createApp } from 'vue'
import App from './App.vue'
import 'animate.css'
import { createPinia } from 'pinia';
import { registerStore } from '@/pinia';
import router from '@/router';
import '@/router/permission'
import 'element-plus/theme-chalk/dark/css-vars.css'
const app = createApp(App);
app.use(router)
app.use(createPinia())
// 这里是进行一个注册，不然的话页面上是拿不到值的
registerStore()
app.mount('#app')

```

#### 5️⃣ 修改之前的home.vue页面

```vue
<template>
<div style="background: rgb(217, 217, 217);height: 100vh;width: 100%;padding-top: 100px;">
<div style="text-align: center;margin-top: 50px;">
<el-button type="primary" @click="goHome">去home1</el-button>
</div>
<div style="text-align: center;margin-top: 50px;">
<el-button type="primary" @click="directChange">直接修改count的值</el-button>
<el-button type="primary" @click="batchChange">批量修改pinia的值</el-button>
<el-button type="primary" @click="callAction">actions修改pinia的值</el-button>
</div>
<div style="text-align: center;margin-top: 50px;color: red;font-size: 22px;">
<div>{{ count }}</div>
<div>{{ title }}</div>
</div>
</div>
</template>
<script lang="ts">
import {useRouter} from "vue-router";
import { storeToRefs } from 'pinia';
import appStore from '@/pinia';
export default defineComponent({
setup() {
const router = useRouter();
// 这里是个小知识点,因为pinia不允许直接解构,比如下面
// const { count, title } = appStore.viewsModule
// 这样写的话会失去响应式,所以得使用storeToRefs
const { count, title } = storeToRefs(appStore.viewsModule)
// 直接修改views里面的count值
const directChange = () => {
appStore.viewsModule.count!++
}
// 批量修改views的值
const batchChange = () => {
appStore.viewsModule.$patch({
count: 100,
title: 'Etc-End'
})
// 还可以这样写,和上面一样的效果
// appStore.viewsModule.$state = {
// count: 100,
// title: 'Etc-End'
// }
}
const callAction = () => {
appStore.viewsModule.incremental()
}
const goHome = () => {
router.push({
path: '/home1'
})
}
return {
directChange,
batchChange,
callAction,
goHome,
count,
title
}
}
})
</script>

```

#### 6️⃣ 修改之前的home1.vue页面

```vue
<template>
<div style="background: rgb(217, 217, 217);height: 100vh;width: 100%;padding-top: 100px;">
<div style="text-align: center;margin-top: 50px;">
<el-button type="primary" @click="goHome">回home</el-button>
</div>
<div style="text-align: center;margin-top: 50px;">
<el-button type="primary" @click="directChange">直接修改count的值</el-button>
<el-button type="primary" @click="batchChange">批量修改pinia的值</el-button>
<el-button type="primary" @click="callAction">actions修改pinia的值</el-button>
</div>
<div style="text-align: center;margin-top: 50px;color: red;font-size: 22px;">
<div>{{ count }}</div>
<div>{{ title }}</div>
</div>
</div>
</template>
<script lang="ts">
import {useRouter} from "vue-router";
import { storeToRefs } from 'pinia';
import appStore from '@/pinia';
export default defineComponent({
setup() {
const router = useRouter();
// 这里是个小知识点,因为pinia不允许直接解构,比如下面
// const { count, title } = appStore.viewsModule
// 这样写的话会失去响应式,所以得使用storeToRefs
const { count, title } = storeToRefs(appStore.viewsModule)
// 直接修改views里面的count值
const directChange = () => {
appStore.viewsModule.count!++
}
// 批量修改views的值
const batchChange = () => {
appStore.viewsModule.$patch({
count: 100,
title: 'Etc-End'
})
// 还可以这样写,和上面一样的效果
// appStore.viewsModule.$state = {
// count: 100,
// title: 'Etc-End'
// }
}
const callAction = () => {
appStore.viewsModule.incremental()
}
const goHome = () => {
router.push({
path: '/'
})
}
return {
directChange,
batchChange,
callAction,
goHome,
count,
title
}
}
})
</script>

```

#### 7️⃣ 最终效果，下图中可以看到，状态管理已经到达效果。切换路由后，拿到的count和title值都是更改后的。

![](https://img-blog.csdnimg.cn/61523e5c0b904f01bb8c9f088fa10555.gif)

 注：切换路由是没有问题，但页面刷新状态就会丢失。解决这个问题的话也很简单，搭配localStorage写一个插件就可以达到持久化。这里就不做演示了，自行研究一下。

## 陆、国际化

[Vite4 + Vue3 + ElementPlus 实现国际化包括表单校验(超详细)](https://blog.csdn.net/qq_19991931/article/details/129517219?spm=1001.2014.3001.5502 "Vite4 + Vue3 + ElementPlus 实现国际化包括表单校验(超详细)")

**我是Etc.End。如果文章对你有所帮助，能否帮我点个免费的赞和收藏😍。**

![](https://img-blog.csdnimg.cn/22c8b504f38f4dca92e4933f041cbd23.jpeg)

👇 👇 👇 👇 👇 👇 👇 👇 👇 👇 👇 👇