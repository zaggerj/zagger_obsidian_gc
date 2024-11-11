---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
## 参考链接
1. [详解JS中for...of、in关键字_js of关键字_MonsterQy的博客-CSDN博客](https://blog.csdn.net/XIAO_A_fighting/article/details/116258308)
2. [for...of - JavaScript | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Statements/for...of)
3. https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Iteration_protocols
4. https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Symbol/iterator
#### 文章目录

- [前言](#_8)
- [一、in关键字](#in_27)
- - [1.数组中的in](#1in_29)
    - [2.对象中的in](#2in_50)
- [二、for...of](#forof_83)
- - [1.数组中的for...of](#1forof_84)
    - [2.对象中的for...of](#2forof_106)

---

## 前言

在总结到数组方法includes的时候突然产生了一个疑问，in是不是也可以用来判断数组中是否有某元素呢？于是尝试了一下

```javascript
var arr5=[1,2,3,4]
console.log(1 in arr5) //true
```

返回了 true ，正当我要记录下来它可以准确判断的时候，我决定还是慎重一点在试一次

```javascript
var arr5=[1,2,3,4]
console.log(4 in arr5) //false
```

顿时产生了疑惑，这是怎么回事呢？  
后来上网查了查资料才知道：  
对于数组来说 in 检查的是对应的索引是否存在，第一次尝试下标为‘1’的元素存在所以true；第二次下标为‘4’的元素不存在所以false。恍然大悟，索性总结记录一下有关of in 关键字的知识点，警示自己！！

## 一、in关键字

### 1.数组中的in

对于数组来说in关键字可以被这么使用：  
**1.判断对应索引是否存在：**

```javascript
var arr5=[1,2,3,4]
console.log(1 in arr5) //true
console.log(4 in arr5) //false
```

**2.遍历数组**

```javascript
var arr5=[1,2,3,4]
for(let i in arr5)
{
    console.log(i) //0,1,2,3
     console.log(arr5[i])//1,2,3,4
}
```

_**总结一下：对于数组来说in总是指的是索引**_

### 2.对象中的in

**1.判断对应属性（键）是否存在：**

```javascript
var obj={name:'小明',age:15,sex:'男'}
console.log('name' in obj) //true
console.log('小明' in obj) //false
```

**注意 要用字符串的形式去判断！**  
**2.遍历对象**

```javascript
for(let i in obj)
{
    console.log(i)//name age sex
    console.log(obj[i]) //'小明' 15 '男'
    console.log(obj.i)//undefined undefined undefined
}
```

这里扩展一下，为什么obj.i为undefined呢?原来我们的js引擎最早都是利用obj[‘xxx’]注意 xxx必须是字符串的形式去访问对应得属性值，后来引入了obj.xxx形式去访问，其实是在js引擎中完成了obj.xxx->obj[‘xxx’]的过程，所以此时直接访问的是obj[‘i’]，也就没有对应得属性值了。  
_**总结一下：对于对象来说in指键**_  
for in 这种方式会将对象的所有属性名/属性值都打印出来，但有时我们只想要它自己本身或构造函数所拥有的一些方法，并不想要原型上的方法这是我们就要这样做:

```javascript
for(let i in obj)
{
   if(obj.hasOwnProperty(i) )
   {
    console.log(obj[i]) 
   }
}
```

即利用hasOwnProperty筛选属性

## 二、for…of

### 1.数组中的for…of

遍历数组中的每一个值：

```javascript
var arr6=[1,2,3,4]
for(var i of arr6)
{
console.log(i)//1，2，3，4
}

```

若数组的每一项都是一个对象的话，也可以遍历出来

```javascript
var arr6=[{name:'小明'},{age:15},{sex:'男'}]
for(var i of arr6)
{
    console.log(i) //{name:'小明'},{age:15},{sex:'男'}
   
}
```

### 2.对象中的for…of

对象无法使用该语句！！！