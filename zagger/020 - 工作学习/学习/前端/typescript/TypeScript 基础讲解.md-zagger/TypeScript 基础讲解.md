---
created: 2023-11-03T22:29
updated: 2023-11-06T12:24
---
# TypeScript 基础讲解

![ts学习(1).png](image1-20230814113250-ow7u7wm.png)

**基础类型**

TypeScript 支持与 JavaScript 几乎相同的数据类型，此外还提供了实用的枚举类型方便我们使用。

**布尔值**

let isDone: boolean = false;

**数字**

let a1: number = 10

**字符串**

let name:string = 'tom'

**undefined 和 null**

let u: undefined = undefined

let n: null = null

**数组**

let list1: number\[\] = \[1, 2, 3\]

**元组 Tuple**

元组通俗理解及定义数组的时候，数据类型和个数在一开始的时候就已经定好了

let t1: \[string, number\]

t1 = \['hello', 10\] // OK

**枚举**

可以理解枚举就是一个字典

enum Status {

Success = 200,

NotFound = 404,

Error = 500

}

console.log(Status\["Success"\]); // 200

console.log(Status\[200\]); // 'Success'

// 使用字符串字面量

enum Message {

Error = "Sorry, error",

Success = "Hoho, success"

}

console.log(Message.Error); // 'Sorry, error'

**any**

any类型变量可以赋值成任何类型的值

let notSure: any = 4

notSure = 'maybe a string'

notSure = false

**void**

void用于函数，表示没有返回值

function fn(): void {

console.log('fn()')

}

**object**

object 表示对象类型：

function fn2(obj:object):object {

console.log('fn2()', obj)

return {}

}

**函数重载**

可以在同一个函数下定义多种类型值，最后汇总到一块

let obj: any = {};

function setInfo(val: string): void;

function setInfo(val: number): void;

function setInfo(val: boolean): void;

function setInfo(val: string \| number \| boolean): void {

if (typeof val === "string") {

obj.name = val;

} else {

obj.age = val;

}

}

setInfo("Domesy");

setInfo(7);

setInfo(true);

console.log(obj); // { name: 'Domesy', age: 7 }

**联合类型**

表示取值可以为多种类型中的一种

let a:string\|number\|boolean;

a = 's';

a = 1;

a= false;

**交叉类型**

表示类型同时为多个类型，等同于运算符 &&。

type A = {

name: string;

}

type B = {

age: number;

}

type C = {

sex: boolean;

}

type D = A & B & C

let people: D = {

name: '张三',

age: 13,

sex: true

}

**类型守卫**

类型推断的行为称作类型守卫

类型判断：typeof

实例判断：instanceof

属性判断：in

字面量相等判断：==, ===, !=, !==

function test(input: string \| number) {

if (typeof input == 'string') {

// 这里处理当input为string类型时的操作

} else {

// 这里处理当input为number类型时的操作

}

}

**类型断言**

个人理解：类型断言会告诉编译器，你不用给我进行检查，相信我，他就是这个类型，自己确定了具体类型

类型断言有两种形式。 其一是“尖括号”语法, 另一个为 as 语法

/\*

类型断言(Type Assertion): 可以用来手动指定一个值的类型

语法:

方式一: \<类型\>值

方式二: 值 as 类型 tsx中只能用这种方式

\*/

//尖括号

let num:any = '小杜杜'

let res1: number = (\<string\>num).length; // React中会 error

// as 语法

let str: any = 'Domesy';

let res: number = (str as string).length;

**类型推断**

类型推断: TS会在没有明确的指定类型的时候推测出一个类型

有下面2种情况: 1. 定义变量时赋值了, 推断为对应的类型. 2. 定义变量时没有赋值, 推断为any类型

/\* 定义变量时赋值了, 推断为对应的类型 \*/

let b9 = 123 // number

// b9 = 'abc' // error

/\* 定义变量时没有赋值, 推断为any类型 \*/

let b10 // any类型

b10 = 123

b10 = 'abc'

**泛型**

指在定义函数或类的时候，不预先指定具体的类型，而在使用的时候再指定具体类型。

**引入**

下面创建一个函数, 实现功能: 根据指定的数量 count 和数据 value , 创建一个包含 count 个 value 的数组 不用泛型的话，这个函数可能是下面这样：

function createArray(value: any, count: number): any\[\] {

const arr: any\[\] = \[\]

for (let index = 0; index \< count; index++) {

arr.push(value)

}

return arr

}

const arr1 = createArray(11, 3)

const arr2 = createArray('aa', 3)

console.log(arr1\[0\].toFixed(), arr2\[0\].split(''))

**使用函数泛型**

function createArray2 \<T\> (value: T, count: number) {

const arr: Array\<T\> = \[\]

for (let index = 0; index \< count; index++) {

arr.push(value)

}

return arr

}

const arr3 = createArray2\<number\>(11, 3)

console.log(arr3\[0\].toFixed())

// console.log(arr3\[0\].split('')) // error

const arr4 = createArray2\<string\>('aa', 3)

console.log(arr4\[0\].split(''))

// console.log(arr4\[0\].toFixed()) // error

**多个泛型参数的函数**

一个函数可以定义多个泛型参数

function swap \<K, V\> (a: K, b: V): \[K, V\] {

return \[a, b\]

}

const result = swap\<string, number\>('abc', 123)

console.log(result\[0\].length, result\[1\].toFixed())

**泛型约束**

如果我们直接对一个泛型参数取 length 属性, 会报错, 因为这个泛型根本就不知道它有这个属性

// 没有泛型约束

function fn \<T\>(x: T): void {

// console.log(x.length) // error

}

我们可以使用泛型约束来实现

interface Lengthwise {

length: number;

}

// 指定泛型约束

function fn2 \<T extends Lengthwise\>(x: T): void {

console.log(x.length)

}

我们需要传入符合约束类型的值，必须包含必须 length 属性：

fn2('abc')

// fn2(123) // error number没有length属性
