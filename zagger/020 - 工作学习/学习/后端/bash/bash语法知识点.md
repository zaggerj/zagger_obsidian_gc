---
created: 2023-11-03T22:29
updated: 2023-11-06T12:24
---
# bash用法
 ```bash
 # 1. 表达式
`ls /etc`
$(ls /etc)

# 2. 使用变量
your_name='qinjx'
echo $your_name
echo ${your_name}
# 变量名外面的花括号是可选的，加不加都行，加花括号是为了帮助解释器识别变量的边界
# 推荐给所有变量加上花括号，这是个好的编程习惯。

# 3. 只读变量
myUrl="https://www.google.com"  
readonly myUrl

# 4. 删除变量
unset variable_name

# 5. Shell 字符串
# 字符串是shell编程中最常用最有用的数据类型（除了数字和字符串，也没啥其它类型好用了），字符串可以用单引号，也可以用双引号，也可以不用引号。

# 单引号
str='this is a string'
# 单引号字符串的限制：
# 单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的；
# 单引号字串中不能出现单独一个的单引号（对单引号使用转义符后也不行），但可成对出现，作为字符串拼接使用。
# 双引号的优点：

# 双引号里可以有变量
# 双引号里可以出现转义字符
your_name="runoob"  
str="Hello, I know you are \"$your_name\"! \n"  
echo -e $str

# 拼接字符串
your_name="runoob"
# 使用双引号拼接
greeting="hello, "$your_name" !"
greeting_1="hello, ${your_name} !"
echo $greeting  $greeting_1

# 使用单引号拼接
greeting_2='hello, '$your_name' !'
greeting_3='hello, ${your_name} !'
echo $greeting_2  $greeting_3

# 获取字符串长度
string="abcd"
echo ${#string}   # 输出 4
# 变量为字符串时，${#string} 等价于 ${#string[0]}:
string="abcd"
echo ${#string[0]}   # 输出 4
# 提取子字符串
string="runoob is a great site"
echo ${string:1:4} # 输出 unoo

# 查找子字符串
string="runoob is a great site"
echo `expr index "$string" io`  # 输出 4

# 6. Shell 数组
# bash支持一维数组（不支持多维数组），并且没有限定数组的大小。
# 类似于 C 语言，数组元素的下标由 0 开始编号。获取数组中的元素要利用下标，下标可以是整数或算术表达式，其值应大于或等于 0。
# 定义数组

# 在 Shell 中，用括号来表示数组，数组元素用"空格"符号分割开。定义数组的一般形式为：

# 数组名=(值1 值2 ... 值n)
array_name=(value0 value1 value2 value3)
# 或者
array_name=(
value0
value1
value2
value3
)
# 还可以单独定义数组的各个分量：
array_name[0]=value0
array_name[1]=value1
array_name[n]=valuen
# 可以不使用连续的下标，而且下标的范围没有限制。

# 读取数组
# 读取数组元素值的一般格式是：
${数组名[下标]}
valuen=${array_name[n]}

# 使用 @ 符号可以获取数组中的所有元素，例如：
echo ${array_name[@]}

# 获取数组的长度
# 获取数组长度的方法与获取字符串长度的方法相同，例如：
# 实例
# 取得数组元素的个数  
length=${#array_name[@]}  
# 或者  
length=${#array_name[*]}  
# 取得数组单个元素的长度  
length=${#array_name[n]}

# 7. Shell 注释

# 以 # 开头的行就是注释，会被解释器忽略。

# 多行注释

# 多行注释还可以使用以下格式：

:<<EOF  
注释内容...  
注释内容...  
注释内容...  
EOF

# EOF 也可以使用其他符号:

## 实例

:<<'  
注释内容...  
注释内容...  
注释内容...  
'  
  
:<<!  
注释内容...  
注释内容...  
注释内容...  
!


# 8. Shell 传递参数

# 我们可以在执行 Shell 脚本时，向脚本传递参数，脚本内获取参数的格式为：$n。n 代表一个数字，1 为执行脚本的第一个参数，2 为执行脚本的第二个参数，以此类推…
以下实例我们向脚本传递三个参数，并分别输出，其中 **$0** 为执行的文件名（包含文件路径）：

## 实例

#!/bin/bash  
# author:菜鸟教程  
# url:www.runoob.com  
  
echo "Shell 传递参数实例！";  
echo "执行的文件名：$0";  
echo "第一个参数为：$1";  
echo "第二个参数为：$2";  
echo "第三个参数为：$3";  

为脚本设置可执行权限，并执行脚本，输出结果如下所示：

$ chmod +x test.sh 
$ ./test.sh 1 2 3
Shell 传递参数实例！
执行的文件名：./test.sh
第一个参数为：1
第二个参数为：2
第三个参数为：3
另外，还有几个特殊字符用来处理参数：

$* 与 $@ 区别：

- 相同点：都是引用所有参数。
- 不同点：只有在双引号中体现出来。假设在脚本运行时写了三个参数 1、2、3，则 " * " 等价于 "1 2 3"（传递了一个参数），而 "@" 等价于 "1" "2" "3"（传递了三个参数）。

```
![[Pasted image 20230817084900.png]]