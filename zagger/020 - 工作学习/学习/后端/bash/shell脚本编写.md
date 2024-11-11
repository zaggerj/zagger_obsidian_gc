---
aliases: 
tags:
  - 长青笔记
cdate: 2024-01-03 16:44
uid: 20240103164437
searchterm: "#长青笔记"
banner: 040 - Obsidian/附件/banners/book-banner.gif
cssclasses:
  - noyaml
banner_icon: 💌
banner_x: -1
banner_y: 0.38
---

# 1. shell脚本编写

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2024-01-03 星期三 16:44:35

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_


> 作者：胡海
>
> 日期：2024 年 1 月 3 日


# 2. 分享 - shell脚本编写

/

## 2.1. 操作 

### 2.1.1. :-


`${var:-default}` 如果变量 var 未定义或为空，则使用默认值 default。


```bash
echo "a: ${a:-v}"   # 输出：a: v
a=""
echo "a: ${a:-v}"   # 输出：a: v
echo "a: ${a}"    # 输出：a:


```


### 2.1.2. -


`${var-default}` 如果变量 var 未定义，则使用默认值 default。


```bash
echo "a: ${a-v}"    # 输出：a: v
a=""
echo "a: ${a-v}"    # 输出：a:
echo "a: ${a}"    # 输出：a:
```


### 2.1.3. :=


`${var:=default}` 如果变量 var 未定义或为空，则设置为默认值 default。


```bash
echo "a: ${a:=v}"   # 输出：a: v
echo "a: ${a}"    # 输出：a: v
a=""
echo "a: ${a:=v}"   # 输出：a: v
echo "a: ${a}"    # 输出：a: v


```


> 注意这里会改变变量的值，同 `:-` 进行区分


### 2.1.4. :+


`${var:+value}` 如果变量 var 已定义且非空，则使用值 value。


```bash
echo "a:+v: ${a:+v}"  # 输出：a+v:
a="1"
echo "a:+v: ${a:+v}"  # 输出：a+v: v
a=""
echo "a:+v: ${a:+v}"  # 输出：a+v:
```


### 2.1.5. +


`${var+value}` 如果变量 var 已定义，则使用值 value。


```bash
echo "a+v: ${a+v}"  # 输出：a+v:
a="1"
echo "a+v: ${a+v}"  # 输出：a+v: v
a=""
echo "a+v: ${a+v}"  # 输出：a+v: v


```


### 2.1.6. :?


`${var:?message}` 如果变量 var 未定义或为空，则输出错误信息 message 并终止脚本。


```bash
echo "a:+v: ${a:?message}"  # 输出：bash: a: message
a=""
echo "a:+v: ${a:?message}"
a="1"
echo "a:+v: ${a:?message}"
```


> 这里脚本未按照预期输出，是因为变量 a 未定义或为空，输出错误信息 message 并终止脚本


我们对脚本进行修改，使用括号将脚本括起来，这样脚本会在子进程中执行，并不会影响父进程的执行。


```bash
( echo "a:?msg: ${a:?message}" )  # 输出：bash: a: message
a=""
( echo "a:?msg: ${a:?message}" )  # 输出：bash: a: message
a="1"
echo "a:?msg: ${a:?message}"      # 输出：a:?msg: message
```


### 2.1.7. ?


`${var?message}` 如果变量 var 未定义，则输出错误信息 message 并终止脚本。


```bash
( echo "a?msg: ${a?message}" )  # 输出：bash: a: message
a=""
( echo "a?msg: ${a?message}" )  # 输出：bash: a: message
a="1"
echo "a?msg: ${a?message}"  # 输出：a:+v: 1
```


总结


![](http://192.168.0.161:4999/server/index.php?s=/api/attachment/visitFile&sign=f3af0c5ecd8778813fd695c33d1261a0)


## 2.2. 变量


### 2.2.1. 定义


在 Shell 脚本中，变量用于存储数据，并通过变量名进行访问。变量的定义不需要指定数据类型，可以直接赋值。


直接赋值


```bash
variable_name=value
```


使用 read 命令从用户输入获取值


```bash
read -p "Enter your name: " name<<<"aaa"
echo $name  # 输出: aaa
```


> read -p "Enter your name: " name 会等待用户输入，并将输入的值赋给变量 name。而 <<< "aaa" 将字符串 "aaa" 传递给 read 命令，充当用户的输入


命令输出赋值


```bash
result=$(command)


```


通过命令行参数传递


```bash
# 在脚本中使用 $1, $2, ... 获取传递的参数
variable=$1
```


环境变量赋值


```bash
export MY_VARIABLE="Hello World"


```


数组赋值


```bash
# 数组的定义与赋值
my_array=(value1 value2 value3)
```


### 2.2.2. 特殊变量


$0: 当前脚本的文件名。
$1, $2, ...: 脚本或函数的参数。
$#: 参数的数量。
$@: 所有参数的列表。
$?: 上一个命令的退出状态。
$$: 当前脚本的进程 ID。


```bash
function foo() {


    echo "\$0: $0"
    echo "\$1: $1"
    echo "\$#: $#"
    echo "\$*: $*"
    echo "\$@: $@"
    echo "\$?: $?"
    echo "\$$: $$"
    printf "%s\n" "$@" | awk '{print NR,$0}'


}
foo 1 2 3 "4 5"


```


### 变量的修改


通过重新赋值可以修改变量的值。


### 删除变量


使用 unset 命令可以删除变量。


```bash
a=1
echo "a:${a?}"
unset a
echo "a:${a?a is not defined}"
```


## 作用域


变量的作用域指的是变量在程序中可见和可访问的范围。在 Shell 脚本中，主要有两种变量作用域：全局作用域和局部作用域。


### 全局变量


全局作用域的变量在整个脚本中都是可见和可访问的，包括脚本的所有函数。全局变量通常在脚本的最外层定义，并可以被脚本中的任何地方引用。


```bash
# 全局变量
global_variable="I am global"


function my_function {
  echo "Inside function: $global_variable"
}


# 在函数外访问全局变量
echo "Outside function: $global_variable"


# 调用函数
my_function
```


在上述例子中， `global_variable` 是一个全局变量，可以在函数内外被引用。


### 局部变量


局部作用域的变量仅在其被定义的块（通常是函数）中可见。一旦离开这个块，变量就超出了作用域，无法再被引用。


```bash
function my_function {
  # 局部变量
  local local_variable="I am local"
  echo "Inside function: $local_variable"
}


# 在函数外尝试访问局部变量（会报错）
echo "Outside function: $local_variable"


# 调用函数
my_function
```


在上述例子中， `local_variable` 是一个局部变量，只能在 `my_function` 函数内部被引用。在函数外部访问它会导致错误。


### 环境变量


环境变量具有全局作用域，可以在整个 Shell 会话中访问。在一个 Shell 脚本中设置的环境变量在脚本执行结束后仍然保持有效，因为它们存在于 Shell 的环境中。


```bash
# 设置环境变量
export MY_VARIABLE="I am an environment variable"
# 在脚本中访问环境变量
echo "Inside script: $MY_VARIABLE"


# 执行另一个脚本
./another_script.sh
```


在上述例子中， `MY_VARIABLE` 是一个环境变量，可以在脚本中和其他通过该脚本启动的脚本中访问。


总体而言，了解变量的作用域有助于编写更清晰、可维护的代码。*全局变量*适用于需要在整个脚本中共享的数据，而*局部变量*适用于只在某个函数或代码块内部使用的数据，可以有效地控制变量的可见性和生命周期。


## 字符串


### 定义


 `S="abcdeabcde"`


### 长度



![](http://192.168.0.161:4999/server/index.php?s=/api/attachment/visitFile&sign=44df70772c75b730560baa50e7394bd9)


```bash
S="abcdeabcde"
echo "len: ${#S}"
```


### 切片


在 Shell 脚本中，字符串切片是一种从字符串中提取子字符串的操作。可以使用以下语法进行字符串切片：


 `${string:offset:length}`


* `string` 是要进行切片的字符串。
* `offset` 是从哪个位置开始切片，索引从 0 开始。
* `length` 是要切片的字符数。



![](http://192.168.0.161:4999/server/index.php?s=/api/attachment/visitFile&sign=1b81ea79463b79c939dc75e34fc72e7d)


> 在 Shell 中，负数索引是从字符串的末尾向前数的。负数索引从 `-1` 开始 ( `-0` 并不表示从字符串末尾向前数的第 0 个字符，而是从字符串开头的第 0 个字符，因为在数学上 `-0` 与 `0` 是相同的），表示字符串的最后一个字符， `-2` 表示倒数第二个字符，以此类推。正数索引从 `0` 开始，表示字符串的第一个字符。


```bash
S="abcdeABCDE"


echo "\${S:5}:     ${S:5}"
echo "\${S:5:4}:   ${S:5:4}"
echo "\${S:0-5}:   ${S:0-5}"
echo "\${S:0-5:4}: ${S:0-5:4}"
```


> 这里需要注意如果从字符串尾部开始切片，索引需要表示为0-x而不是-x


```bash
S="abcdeABCDE"


echo "\${S:-5}:    ${S:-5}"
echo "\${S:-5:4}:  ${S:-5:4}"
```


### 截取



![](http://192.168.0.161:4999/server/index.php?s=/api/attachment/visitFile&sign=fb2356885e30f4e9f572c2a6711f6f88)


```bash
S="abcdeabcde"


echo "\${S#abc}:     ${S#abc}"
echo "\${S#*bc}:     ${S#*bc}"
cho "\${S##*bc}:    ${S##*bc}" # 贪婪匹配
```



![](http://192.168.0.161:4999/server/index.php?s=/api/attachment/visitFile&sign=3d351bbddddb84b038d2668c4cdce18f)


```bash
S="abcdeabcde"


echo "\${S%cde}:     ${S%cde}"
echo "\${S%cd*}:     ${S%cd*}"
echo "\${S%%cd*}:    ${S%%cd*}" # 贪婪匹配
```


### 替换


![](http://192.168.0.161:4999/server/index.php?s=/api/attachment/visitFile&sign=166a0b6d0e0016c974e3fb85aae9e64d)

```bash
S="abcdeabcde"


echo "\${S/abc/ABC}:   ${S/abc/ABC}"
echo "\${S//abc/ABC}:  ${S//abc/ABC}"
echo "\${S/#abc/ABC}:  ${S/#abc/ABC}"  # 前缀匹配
echo "\${S/%cde/CDE}:  ${S/%cde/CDE}"  # 后缀匹配
echo "\${S/*bc/BC}:    ${S/*bc/BC}"
echo "\${S/bc*/BC}:    ${S/bc*/BC}"
```


### 转换大小写


```bash
S="abcdeABCDE"


echo "\${S,,}:  ${S,,}"
echo "\${S^^}:  ${S^^}"
```


## 列表（数组）


列表通常被称为数组。数组是一种数据结构，可以存储多个值，并使用索引或键（关联数组）进行访问。


### 定义


```bash


# 使用空格分隔的值定义数组


my_array=("value1" "value2" "value3")


# 或者逐个赋值


my_array[0]="value1"
my_array[1]="value2"
my_array[2]="value3"
```


### 访问


使用索引访问数组元素


```bash
echo ${my_array[0]}  # 输出：value1
echo ${my_array[1]}  # 输出：value2
echo ${my_array[2]}  # 输出：value3
```


### 长度


使用 # 可以获取数组的长度


```bash
length=${#my_array[@]}
echo $length  # 输出：3
```


### 遍历


```bash
# 遍历数组中的所有元素
for item in "${my_array[@]}"; do
  echo $item
done
```


## 字典（关联数组）


关联数组使用字符串键而不是数字索引。关联数组在 Bash 版本 4 及以上可用。


在 Shell 编程中，没有直接称之为 “字典” 的数据结构。Shell 中通常使用关联数组来实现类似字典的功能。关联数组允许使用字符串作为键，并与每个键相关联一个值。


### 定义


```bash
# 使用 -A 选项定义关联数组


declare -A dict=([key1]="value1" [key2]="value2" [key3]="value3")
```


### 访问


```bash
declare -A dict=([key1]="value1" [key2]="value2" [key3]="value3")


# 使用键访问关联数组元素
echo ${dict["key1"]}  # 输出：value1
echo ${dict["key2"]}  # 输出：value2
echo ${dict["key3"]}  # 输出：value3
```


### 遍历


```bash
declare -A dict=([key1]="value1" [key2]="value2" [key3]="value3")


# 遍历关联数组中的所有键值对


for key in "${!dict[@]}"; do
  echo "Key: $key, Value: ${dict[$key]}"
done
```


### 获取所有数组元素


```bash
declare -A dict=([key1]="value1" [key2]="value2" [key3]="value3")


# 使用 @ 或 * 获取所有数组元素
all_elements="${dict[@]}"
echo $all_elements  # 输出：value1 value2 value3
```


### 获取所有关联数组的键


```bash
declare -A dict=([key1]="value1" [key2]="value2" [key3]="value3")


# 使用 ! 获取所有关联数组的键


all_keys="${!dict[@]}"
echo $all_keys  # 输出：key1 key2 key3
```


## 流程控制


### 条件语句


`if` 语句用于根据条件执行不同的代码块。


`


```bash
if [ condition ]; then
  # 代码块1
elif [ another_condition ]; then
  # 代码块2
else
  # 代码块3
fi
````


### 循环语句


#### for循环


`for` 循环用于按顺序迭代一组值。


`


```bash
for variable in value1 value2 value3; do
  # 循环体
done
````


示例：


`


```bash
# 遍历列表
fruits=("apple" "orange" "banana")
for fruit in "${fruits[@]}"; do
  echo "I like $fruit"
done


# 遍历数字范围
for number in {1..5}; do
  echo "Number: $number"
done


# 使用 seq 命令遍历数字范围（seq 命令用于生成数字序列）
for number in $(seq 1 2 10); do
  echo "Number: $number"
done


# 嵌套循环
for (( i = 1; i <= 3; i++ )); do
  echo "Outer loop: $i"
  for (( j = 1; j <= 4; j+=2 )); do
    echo "  Inner loop: $j"
  done
done
````


#### while 循环


`while` 循环用于在条件为真时重复执行代码块。


`


```bash
while [ condition ]; do
  # 循环体
done
````


#### 跳出循环


##### break


`break` 语句用于立即跳出循环。


```
while [ condition ]; do
  # 循环体
  if [ another_condition ]; then
    break
  fi
done
```


##### continue


`continue` 语句用于结束当前循环迭代，立即进入下一次迭代。


```
while [ condition ]; do
  # 循环体
  if [ another_condition ]; then
    continue
  fi
  # 以下代码在 another_condition 不满足时执行
done
```


### 选择语句


#### case 语句


`case` 语句用于根据不同的模式（patterns）匹配执行不同的代码块。在这个结构中， `$variable` 的值将被逐个与每个模式进行匹配，如果匹配成功，对应的代码块将被执行。


```bash
case $variable in
  pattern1)
    # 代码块1
    ;;
  pattern2)
    # 代码块2
    ;;
  *)
    # 默认代码块
    ;;
esac
```


以下是关于 `case` 语句中模式


#### 基本模式


在 `case` 语句中，模式可以是简单的字符串，如：


`


```bash
case $fruit in
  "apple")
    echo "It's an apple."
    ;;
  "orange")
    echo "It's an orange."
    ;;
  *)
    echo "It's something else."
    ;;
esac


````


#### 通配符模式


`case` 语句支持通配符模式，使用 `*` 表示匹配任意字符， `?` 表示匹配单个字符：


`


```bash
case $file in
  *.txt)
    echo "Text file."
    ;;
  image?.png)
    echo "Image file with a single-character identifier."
    ;;
  *)
    echo "Other type of file."
    ;;
esac
````


#### 正则表达式模式


在 `case` 语句中，也可以使用 `~` 运算符进行正则表达式匹配：


`


```bash
case $input in
  [0-9])
    echo "Single digit."
    ;;
  [a-z])
    echo "Lowercase letter."
    ;;
  [A-Z])
    echo "Uppercase letter."
    ;;
  *)
    echo "Other input."
    ;;
esac
````


#### 多个模式共享代码块


如果多个模式需要执行相同的代码块，可以在一起列出它们：


`


```bash
case $day in
  "Monday" | "Wednesday" | "Friday")
    echo "It's a work day."
    ;;
  "Saturday" | "Sunday")
    echo "It's a weekend."
    ;;
  *)
    echo "It's some other day."
    ;;
esac
````


`case` 语句中的模式提供了一种灵活的方式来匹配和处理不同的情况，可以根据需要选择不同的匹配方式。在实际编程中，根据具体的需求选择最适合的模式是很重要的。


## 函数


函数是一组命令的有序集合，用于完成特定的任务。函数提高了代码的可维护性和可重用性。


### 定义


在 Shell 中，函数可以使用 `function` 关键字，也可以省略。函数的定义通常位于脚本的顶部或任何需要调用函数的位置。


```bash


# 使用 function 关键字


function my_function {
  # 函数体
  echo "Hello World!"
}


# 或者省略 function 关键字


another_function() {
  # 函数体
  echo "Hello another world!"
}


```


### 调用


调用函数时，只需使用函数名即可：


```bash
my_function       # 调用第一个函数
another_function    # 调用第二个函数
```


### 参数


函数可以接受参数。在函数内部，使用 `$1` , `$2` , ... 来引用传递给函数的参数。例如：


```bash
function hello {
  echo "Hello, $1!"
}
hello "World"


```


### 返回值


函数可以通过 `return` 语句返回一个值。返回值可以通过 `$?` 来获取。


```bash
function add {
  local result=$(( $1 + $2 ))
  return $result
}


add 3 4
echo "Sum: $?"
```


> 函数的返回值是一个 8 位的整数（0-255），因此函数的返回值范围受到限制。通常，返回值用于表示命令的执行状态，0 表示成功，非零表示失败。可以在函数中显式的使用 `return` 语句返回自定义的整数值，但需要注意限制。


函数的返回值通常是整数，不直接支持返回字符串。如果需要传递字符串，可以使用变量或输出到标准输出，然后在调用函数的地方捕获输出。


```bash
function concatenate_strings {
  local result="$1$2"
  echo "$result"
}


ret=$(concatenate_strings "Hello, " "World!")
echo $ret  # 输出：Hello, World!


```


在这个例子中， `concatenate_strings` 函数使用 `echo` 将连接后的字符串输出到标准输出，然后在调用函数的地方捕获输出。


### 局部变量


在函数内部声明的变量默认是局部变量，不会影响到函数外部的同名变量。（细节部分参考作用域相关说明）


```bash
function local_var_example {
  local my_var="Local variable"
  echo "Inside function: $my_var"
}


my_var="Global variable"
local_var_example
echo "Outside function: $my_var"
```


### 返回值


函数的返回值可以作为命令的退出状态，用 `$?` 获取。


```bash
function is_even {
  if (( $1 % 2 == 0 )); then


    return 0  # 0 表示真（偶数）


  else


    return 1  # 1 表示假（奇数）


  fi
}


is_even 4
if [ $? -eq 0 ]; then
  echo "It's even."
else
  echo "It's odd."
fi


```


### 嵌套调用


函数可以嵌套调用其他函数。


```bash
function outer_function {
  echo "This is outer function."
  inner_function
}


function inner_function {
  echo "This is inner function."
}


outer_function
```



# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
