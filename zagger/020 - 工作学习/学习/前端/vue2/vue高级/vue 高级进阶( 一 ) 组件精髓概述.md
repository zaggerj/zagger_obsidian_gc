---
created: 2023-11-06T08:20
updated: 2023-11-06T08:20
---
# vue 高级进阶( 一 ) 组件精髓概述

# 系列前言

> 这个系列可能会分为几部分：

1. 基础以及高级用法总结
2. 一些比较有代表性的实战
3. 源码解析（一定是用最粗俗，不对，是最通俗的语言讲解，这个我可以保证）

总之一定对得起高级进阶这几个字。。。

# 组件分类

vue组件主要包含：

1. 由vue-router产生的页面，可以称之为路由组件
2. 独立基础组件：例如Date和input这之类的可以全局复用的基础组件
3. 业务组件，除了以上两种就是业务组件

# 组件精髓

## props

- tppe 类型
- default 默认
    - 如果是对象，数组，必须要写成方法进行返回

```tsx
msg:{
    type: Array,
    default: ()=>([])
}
```

- Validator 校验，有一个参数 value
	- ![[Pasted image 20231103161643.png]]
- InheritAttrs 是否继承 html 特性
	- ![[Pasted image 20231103163005.png]]
- 子组件不能修改父组件传递过来的prop

## event

方法一

```css
<parent-com @on-click="handleClick"></parent-com>

子组件
<button>点击</button>
在子组件中触发
this.$emit('on-click', event)
```

方法二 
原生是按钮自己触发的

```css
加上.native就是原生方法
<parent-com @click.native="handleClick"></parent-com>

子组件
<button>点击</button>
```

## slot

子组件中使用： `<slot>` 节点就是指定的一个插槽的位置,
父组件中使用：v-slot:[name]可以指定插槽的位置，有了 name 就叫具名插槽

#### 具名slot

子组件中，`<slot>` 元素可以用一个特殊的属性 name 来配置如何分发内容。
多个 slot 可以有不同的名字。
具名 slot 将匹配内容片段中有对应 slot 特性的元素父组件

```xml
    <slotshow>
        <p>{{msg}}</p>
        <h6 slot="xxx">就是没有废话！</h6>

        vue2.6以上的版本是这样的
        <h6 v-slot:xxx>就是没有废话！</h6>
    </slotshow>
 
```

子组件

```jsx
    <div class="slotcontent">
        <slot></slot>
        <slot name="xxx"></slot>
    </div>
 
```

#### 作用域插槽

**从子组件的 `<slot>` 元素将变量传递给，父组件中的具有特殊属性 scope 的 `<template>` 元素**

作用域插槽是一种特殊类型的插槽，用作使用一个 (能够传递数据到) 可重用模板替换已渲染元素。 在子组件中，只需将数据传递到插槽，就像将 props 传递给组件一样，插槽的内容就可以使用这个传递过来的数据在父级中，具有特殊属性 scope 的 `<template>` 元素必须存在，表示它是作用域插槽的模板。scope 的值对应一个临时变量名，此变量接收从子组件中传递的 props 对象.

列表组件

```xml
var childNode = {
 template: `
     <ul>
     // 通过:text="item.text"进行传值
     <slot name="item" v-for="item in items" :text="item.text">默认值</slot>
     </ul>
 `,
 data(){
     return{
          items:[
              {id:1,text:'第1段'},
              {id:2,text:'第2段'},
              {id:3,text:'第3段'},
          ]
        }
    }
};

var parentNode = {
 template: `
 <div class="parent">
    <p>父组件</p>
     <child>
            // 通过props进行接收
          <template slot="item" scope="props">
          <li>{{ props.text }}</li>
          </template>
     </child>
 </div>
 `,
 components: {
    'child': childNode
 },
};
 
```

# 组件通信(第二篇会详细讲解8种用法)

1. `ref`：给元素或组件注册引用信息；
2. `$parent` / `$children`：访问父 / 子实例。
3. `props` 父向子传递
4. `$emit和$on`,子----->父
5. `vuex`

# 一些碎知识

1. 改变数组某一项的方法:
    
    1. 直接改变对象的引用
    2. 可以使用push,shift等方法
    3. 可以使用vue的变异方法
    
    ```cpp
    Vue.set(vm.userinfo,2,{a:1})  == vm.$set(vm.userinfo,2,{a:1})
     
    ```
    
2. is属性
    
    ```xml
    <table>
        <tr id="row"></tr>  注意is的使用 table中只能使用tr
    </table>
     
    ```
    
3. 在子组件中的data必须是一个function,来return 一个对象，这是为了保证`每一个实例的data属性都是独立的，不会相互影响`
    

第一节就是这些，不喜欢写废话

觉得对你有帮助，点个

# 赞

，后续持续输出这种简短有效的文章，帮助你用最短的时间内掌握最多的内容，毕竟谁不喜欢一劳永逸不是？ ❥(^_-) thank you ~

## 后续目录

[vue高级进阶( 一 ) 组件精髓概述](https://www.jianshu.com/p/e26939be5976)

[vue高级进阶( 二 ) 8种组件通信详解](https://www.jianshu.com/p/f6c73dc8945a)

[vue高级进阶( 三 ) 组件高级用法及最佳实践](https://www.jianshu.com/p/caad297881a0)