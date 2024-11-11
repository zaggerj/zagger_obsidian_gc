---
created: 2023-11-03T22:29
updated: 2023-11-16 14:31:16
---

## 0.1. 参考链接
1. [linux三剑客之一（grep） - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/415394105)
2. [linux grep命令详解 - ggjucheng - 博客园 (cnblogs.com)](https://www.cnblogs.com/ggjucheng/archive/2013/01/13/2856896.html)
3. [搜索 命令，Linux 搜索 命令详解：最专业的Linux命令大全，命令搜索引擎，内容包含Linux命令手册、详解、学习，值得收藏的Linux命令速查手册。 - Linux 命令搜索引擎 (lutixia.cn)](http://bash.lutixia.cn/list.html#!kw=sed)
4. [linux 基础 - 知乎 (zhihu.com)](https://www.zhihu.com/column/c_1423265882214236160)
5. [linux三剑客(grep、sed、awk)基本使用 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/532822255)
6. [grep命令详解_运维朱工的博客-CSDN博客](https://blog.csdn.net/Lu_tixia/article/details/127183832)
## 0.2. 简介
**名称和翻译：** grep (global search regular expression(RE) and print out the line,全面搜索正则表达式并把行打印出来)

**定义：** 是一种强大的文本搜索工具，它能使用正则表达式搜索文本，并把匹配的行打印出来。
```shell
格式 ：grep [参数] [过滤的规则] [路径]
```

```bash
grep [option] pattern files
```

**1.1 格式 ：grep [参数] [过滤的规则] [路径]**

**标准输出 | grep [参数] [过滤规则]**

#### 0.2.1.1. grep递归搜索文件

在多级目录中对文本进行递归搜索：

```shell
grep "text" . -r -n
# .表示当前目录。
```
搜索多个文件并查找匹配文本在哪些文件中：

```shell
grep -l "text" file1 file2 file3...
```
统计文件或者文本中包含匹配字符串的行数 **-c** 选项：

```shell
grep -c "text" file_name
```
在grep搜索结果中包括或者排除指定文件：

```shell
# 只在目录中所有的.php和.html文件中递归搜索字符"main()"
grep "main()" . -r --include *.{php,html}
# 在搜索结果中排除所有README文件
grep "main()" . -r --exclude "README"

# 在搜索结果中排除filelist文件列表里的文件
grep "main()" . -r --exclude-from filelist
```
grep静默输出：

```shell
grep -q "test" filename
# 不会输出任何信息，如果命令运行成功返回0，失败则返回非0值。一般用于条件测试。
```



### 0.2.2. 1.option
**参数：**
**-n : 显示过滤出来的文本在文件内的行号**  
**-o : 只显示匹配到的内容**  
**-q : 静默输出**  
**-i : 忽略大小写**  
**-c : 显示匹配到的行数**  
**-v : 反向查找（重要）**  
**-w : 匹配某个词**  
**-E : 使用扩展正则**  
**-R : 递归查询（重要）**  
**-l : 只打印文件路径**

```bash
-a --text  # 不要忽略二进制数据。
-A <显示行数>   --after-context=<显示行数>   # 除了显示符合范本样式的那一行之外，并显示该行之后的内容。
-b --byte-offset                           # 在显示符合范本样式的那一行之外，并显示该行之前的内容。
-B<显示行数>   --before-context=<显示行数>   # 除了显示符合样式的那一行之外，并显示该行之前的内容。
-c --count    # 计算符合范本样式的列数。
-C<显示行数> --context=<显示行数>或-<显示行数> # 除了显示符合范本样式的那一列之外，并显示该列之前后的内容。
-d<进行动作> --directories=<动作>  # 当指定要查找的是目录而非文件时，必须使用这项参数，否则grep命令将回报信息并停止动作。
-e<范本样式> --regexp=<范本样式>   # 指定字符串作为查找文件内容的范本样式。
-E --extended-regexp             # 将范本样式为延伸的普通表示法来使用，意味着使用能使用扩展正则表达式。
-f<范本文件> --file=<规则文件>     # 指定范本文件，其内容有一个或多个范本样式，让grep查找符合范本条件的文件内容，格式为每一列的范本样式。
-F --fixed-regexp   # 将范本样式视为固定字符串的列表。
-G --basic-regexp   # 将范本样式视为普通的表示法来使用。
-h --no-filename    # 在显示符合范本样式的那一列之前，不标示该列所属的文件名称。
-H --with-filename  # 在显示符合范本样式的那一列之前，标示该列的文件名称。
-i --ignore-case    # 忽略字符大小写的差别。
-l --file-with-matches   # 列出文件内容符合指定的范本样式的文件名称。
-L --files-without-match # 列出文件内容不符合指定的范本样式的文件名称。
-n --line-number         # 在显示符合范本样式的那一列之前，标示出该列的编号。
-P --perl-regexp         # PATTERN 是一个 Perl 正则表达式
-q --quiet或--silent     # 不显示任何信息。
-R/-r  --recursive       # 此参数的效果和指定“-d recurse”参数相同。
-s --no-messages  # 不显示错误信息。
-v --revert-match # 反转查找。
-V --version      # 显示版本信息。   
-w --word-regexp  # 只显示全字符合的列。
-x --line-regexp  # 只显示全列符合的列。
-y # 此参数效果跟“-i”相同。
-o # 只输出文件中匹配到的部分。
-m <num> --max-count=<num> # 找到num行结果后停止查找，用来限制匹配行数

```


规则表达式
```bash
^    # 锚定行的开始 如：'^grep'匹配所有以grep开头的行。    
$    # 锚定行的结束 如：'grep$' 匹配所有以grep结尾的行。
.    # 匹配一个非换行符的字符 如：'gr.p'匹配gr后接一个任意字符，然后是p。    
*    # 匹配零个或多个先前字符 如：'*grep'匹配所有一个或多个空格后紧跟grep的行。    
.*   # 一起用代表任意字符。   
[]   # 匹配一个指定范围内的字符，如'[Gg]rep'匹配Grep和grep。    
[^]  # 匹配一个不在指定范围内的字符，如：'[^A-FH-Z]rep'匹配不包含A-R和T-Z的一个字母开头，紧跟rep的行。    
\(..\)  # 标记匹配字符，如'\(love\)'，love被标记为1。    
\<      # 锚定单词的开始，如:'\<grep'匹配包含以grep开头的单词的行。    
\>      # 锚定单词的结束，如'grep\>'匹配包含以grep结尾的单词的行。    
x\{m\}  # 重复字符x，m次，如：'0\{5\}'匹配包含5个o的行。    
x\{m,\}   # 重复字符x,至少m次，如：'o\{5,\}'匹配至少有5个o的行。    
x\{m,n\}  # 重复字符x，至少m次，不多于n次，如：'o\{5,10\}'匹配5--10个o的行。   
\w    # 匹配文字和数字字符，也就是[A-Za-z0-9]，如：'G\w*p'匹配以G后跟零个或多个文字或数字字符，然后是p。   
\W    # \w的反置形式，匹配一个或多个非单词字符，如点号句号等。   
\b    # 单词锁定符，如: '\bgrep\b'只匹配grep。  

```


**扩展参数：**

> **-A ：显示匹配到的数据的后n行**  
> **-B ：显示匹配到的数据的前n行**  
> **-C ：显示匹配到的数据的前后各n行**


**知识储备：**

> **$? : 代表上一条命令执行是否成功（0：成功，非0代表失败）**  
> **词 ： 一连串字母和数字组成的字符串**  
> **wc -l : 打印显示有多行**


**案例11：要求找出/etc目录下，那些文件中包含root**

```bash
grep -R "root" /etc/
或者
grep -Rl "root" /etc/

grep -Rl "root" /etc/ | wc -l

```