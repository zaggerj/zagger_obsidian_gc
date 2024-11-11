---
created: 2023-11-06T08:20
updated: 2023-11-06T08:20
---
# Vite4 + Vue3 + vue-router4 动态路由

分类专栏： [Vue3全家桶](https://blog.csdn.net/qq_19991931/category_12265210.html) 文章标签： [javascript](https://so.csdn.net/so/search/s.do?q=javascript&t=all&o=vip&s=&l=&f=&viparticle=) [前端](https://so.csdn.net/so/search/s.do?q=%E5%89%8D%E7%AB%AF&t=all&o=vip&s=&l=&f=&viparticle=) [vue.js](https://so.csdn.net/so/search/s.do?q=vue.js&t=all&o=vip&s=&l=&f=&viparticle=) [开发语言](https://so.csdn.net/so/search/s.do?q=%E5%BC%80%E5%8F%91%E8%AF%AD%E8%A8%80&t=all&o=vip&s=&l=&f=&viparticle=) [typescript](https://so.csdn.net/so/search/s.do?q=typescript&t=all&o=vip&s=&l=&f=&viparticle=)

于 2023-03-12 12:47:29 首次发布

本文链接：[https://blog.csdn.net/qq_19991931/article/details/129300550](https://blog.csdn.net/qq_19991931/article/details/129300550)
Vue3全家桶 专栏收录该内容](https://blog.csdn.net/qq_19991931/category_12265210.html "Vue3全家桶")



[动态路由](https://so.csdn.net/so/search?q=%E5%8A%A8%E6%80%81%E8%B7%AF%E7%94%B1&spm=1001.2101.3001.7020)，基本上每一个项目都能接触到这个东西，通俗一点就是我们的菜单是根据后端接口返回的数据进行动态生成的。表面上是对菜单的一个展现处理，其实内部就是对router的一个数据处理。当然你只对菜单做处理也是可以的，但是没有任何意义，熟悉router的小伙伴都知道，如果你的一个路由存在，即使没有这个菜单，我只要改变浏览器的地址一样能访问到。所以你还是省不了修改router的步骤。通过接口获取数据的话就可以根据角色权限或者一些业务上的需求，根据不同属性实现路由的划分。达到不同的页面渲染效果。

本文只是讲解菜单的[权限控制](https://so.csdn.net/so/search?q=%E6%9D%83%E9%99%90%E6%8E%A7%E5%88%B6&spm=1001.2101.3001.7020)，不到按钮级别。其实按钮也是差不多的。可以设置一个属性表示菜单，一个属性表示按钮，每一个菜单的叶子节点上都包含根据权限返回的按钮数组。接着可以通过组件的形式去输出相应的按钮就可以。

## 一、搭建项目 😛😛😛

这里我已经提前搭建好了 [Vite4+Pinia2+vue-router4+ElmentPlus搭建Vue3项目(组件、图标等按需引入)](https://blog.csdn.net/qq_19991931/article/details/128658576?spm=1001.2014.3001.5502 "Vite4+Pinia2+vue-router4+ElmentPlus搭建Vue3项目(组件、图标等按需引入)")

## 二、根据上面链接搭建好项目，修改src/router/index.ts 😁 😉

asyncRoutes里面可以存放默认的一些路由，比如登录、404、403这些。由于我只是演示，所以就啥都不放了。清晰明朗一点。
```js

import { createRouter, createWebHashHistory, RouteRecordRaw } from 'vue-router'
export const asyncRoutes: RouteRecordRaw[] = []
const router = createRouter({
	history: createWebHashHistory(),
	routes: asyncRoutes,
	scrollBehavior: () => ({ left: 0, top: 0 })
})
export default router

```
## 三、创建 'src/layout/index.vue' 文件 😁 😉

这个文件就是整个项目的布局，一般我们常见的项目都分为上下结构，就如下图。导航和菜单部分基本上是用户登录以后就已经确定好了，点击菜单的时候去切换路由。我这里由于这部分不是重点，所以我就很潦草的画了一个很简单的页面。

![](https://img-blog.csdnimg.cn/d8f0b6fbd72f423985990df26a1a59b5.png)

```vue
<template>
	<div style="padding: 100px;">
		<div>
		<div v-for="(item, index) in menus[0].children" :key="index" style="margin-bottom: 20px;">
		<router-link :to="item.path">{{item.title}}</router-link>
		</div>
		</div>
		<div>
		<router-view #default="{route, Component}">
		<transition leave-from-class="ts-web-fade--leave-to" enter-active-class="animate__animated animate__bounceInRight">
		<component :is="Component"></component>
		</transition>
		</router-view>
		</div>
	</div>
</template>
<script lang="ts">
import appStore from '@/pinia';
export default defineComponent({
setup() {
const { menus } = appStore.permissionModule
console.log(menus, 'menus')
return {
menus,
}
}
})
</script>

```
## 四、创建 'src/pinia/modules/permission.ts' 文件 😁 😉

由于我这里是一个demo，没有真正的去接入后端。所以我暂时放入的静态数据。自己替换成接口返回就好。