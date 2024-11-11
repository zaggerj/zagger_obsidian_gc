---
alias:
tags: 长青笔记
cdate: 2024-01-16 11:09
uid: 20240116110949
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. cut命令

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2024-01-16 星期二 11:09:47

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

# 2. Linux cut命令详解

**cut** 命令在Linux和Unix中的作用是从文件中的每一行中截取出一些部分，并输出到标准输出中。我们可以使用 **cut** 命令从一行字符串中于以字节，字符，字段（分隔符）等单位截取一部分内容出来。

在本文中，我们通过一些例子来了解 **cut** 命令的使用，这些使用方法在我们的日常工作中也是非常常用的。

## 2.1. [#](https://www.lxlinux.net/e/linux/linux-cut.html#cut%E5%91%BD%E4%BB%A4%E5%92%8C%E8%AF%AD%E6%B3%95)Cut命令和语法

**cut** 命令的基本语法如下：

```
$ cut OPTION... [FILE]...
```

我们先来了解一下 **cut** 的一些选项，**cut** 命令必须要指定选项才能执行。

`-f` : 提取指定的字段，**cut** 命令使用 **Tab** 作为默认的分隔符。

`-d` : **Tab** 是默认的分隔符，使用这一选项可以指定自己的分隔符。

`-b` : 提取指定的字节，也可以指定一个范围。

`-c` : 提取指定的字符，可以是以逗号分隔的数字的列表，也可以是以连字符分隔的数字的范围。

`–complement` : 补充选中的部分，即反选。

`–output-delimiter` : 修改输出时使用的分隔符。

`--only-delimited` : 不输出不包含分隔符的列。

我们以如下的名为 `context.txt` 的文本文件和 `/etc/passwd` 文件来为例来进行说明。

```
$ cat content.txt 
Ubuntu Linux
Microsoft Windows
OsX El Capitan
Unix
FreeBSD
```

## 2.2. [#](https://www.lxlinux.net/e/linux/linux-cut.html#%E5%A6%82%E4%BD%95%E6%8C%87%E5%AE%9A%E5%88%86%E9%9A%94%E7%AC%A6)如何指定分隔符

最常用的选项是 `-d` 和 `-f` 的组合，这会根据 `-d` 指定的分隔符和 `-f` 列出的字段来提取内容。

例如在这个例子中只打印出 /etc/passwd 文件每一行的第一个字段，用的分隔符是 `:`

```
$ cut -d':' -f1 /etc/passwd
root
bin
daemon
adm
lp
sync
shutdown
halt
mail
operator
games
alvin
liangxu
...
```

在下面这个例子中我们用空格作为分隔符打印 content.txt 文件的第一个字段

```
$ cut -d " " -f 1 content.txt 
Ubuntu
Microsoft
OsX
Unix
FreeBSD
```

在下面这个例子中我们提取了多个字段。这里，我们使用冒号（:）分隔符从文件 /etc/passwd 中包含字符串 /bin/bash 的行提取第一和第六个字段。

```
$ grep "/bin/bash" /etc/passwd | cut -d':' -f1,6
root:/root
alvin:/home/alvin
```

要显示字段的某个范围，可以指定开始和结束的字段，中间用连字符（-）连接，如下所示：

```
$ grep "/bin/bash" /etc/passwd | cut -d':' -f1-4,6,7
root:x:0:0:/root:/bin/bash
alvin:x:1000:1000:/home/alvin:/bin/bash
```

## 2.3. [#](https://www.lxlinux.net/e/linux/linux-cut.html#%E5%A6%82%E4%BD%95%E8%A1%A5%E5%85%A8%E9%80%89%E6%8B%A9%E7%9A%84%E8%BE%93%E5%87%BA)如何补全选择的输出

要补全选择输出的字段（即反选），使用 `--complement` 选项。这一选项输出所有的字段，除了指定的字段。

在下面这个例子中输出 /etc/passwd 文件中包含 /bin/bash 的行中除了第二个字段以外的所有字段：

```
$ grep "/bin/bash" /etc/passwd | cut -d':' --complement -f2
root:0:0:root:/root:/bin/bash
```

## 2.4. [#](https://www.lxlinux.net/e/linux/linux-cut.html#%E5%A6%82%E4%BD%95%E6%8C%87%E5%AE%9A%E8%BE%93%E5%87%BA%E7%9A%84%E5%88%86%E9%9A%94%E7%AC%A6)如何指定输出的分隔符

使用 `--output-delimiter` 可以指定输出的分隔符。输入的分隔符由 `-d` 来指定，而输出分隔符和输入分隔符默认是一样的。

我们先以下面的例子来测试不指定输出分隔符时的输出；

```
$  cut -d: -f1,7  /etc/passwd |  sort |  uniq -u
_apt:/usr/sbin/nologin
backup:/usr/sbin/nologin
bin:/usr/sbin/nologin
daemon:/usr/sbin/nologin
dnsmasq:/usr/sbin/nologin
games:/usr/sbin/nologin
gnats:/usr/sbin/nologin
irc:/usr/sbin/nologin
landscape:/usr/sbin/nologin
list:/usr/sbin/nologin
lp:/usr/sbin/nologin
lxd:/bin/false
```

现在我们加上`--output-delimiter`选项，将输出分隔符指定为空格：

```
$  cut -d: -f1,7 --output-delimiter ' ' /etc/passwd |  sort |  uniq -u
_apt /usr/sbin/nologin
backup /usr/sbin/nologin
bin /usr/sbin/nologin
daemon /usr/sbin/nologin
dnsmasq /usr/sbin/nologin
games /usr/sbin/nologin
gnats /usr/sbin/nologin
irc /usr/sbin/nologin
landscape /usr/sbin/nologin
list /usr/sbin/nologin
lp /usr/sbin/nologin
lxd /bin/false
```

我们再测试一个例子，用分隔符让每一行打印一个字段。

我们将 `--output-delimiter` 指定为 `$'\n'` 表换行。

输出结果为：

```
$ grep root /etc/passwd | cut -d':' -f1,6,7 --output-delimiter=$'\n'
root
/root
/bin/bash
operator
/root
/sbin/nologin
```

## 2.5. [#](https://www.lxlinux.net/e/linux/linux-cut.html#%E5%A6%82%E4%BD%95%E4%BB%A5%E5%AD%97%E7%AC%A6%E7%9A%84%E6%96%B9%E5%BC%8F%E6%8F%90%E5%8F%96%E5%86%85%E5%AE%B9)如何以字符的方式提取内容

`-c`选项可以用来根据字符位置进行提取，注意空格和`Tab`也以字符来处理。

打印 context.txt 文件每一行的第一个字符，如下：

```
$ cut -c 1 content.txt
U
M
O
U
F
```

下面显示了 context.txt 文件每一行的第一至七个字符；

```
$ cut -c 1-7 content.txt
Ubuntu
Microso
OsX El
Unix
FreeBSD
```

我们再测试一下只指定开始或结束的位置。

下面提取第二个到最后一个字符：

```
$ cut -c2- content.txt
buntu Linux
icrosoft Windows
sX El Capitan
nix
reeBSD
```

提取第一到第四个字符：

```
cut -c-4 content.txt
Ubun
Micr
OsX
Unix
Free
```

## 2.6. [#](https://www.lxlinux.net/e/linux/linux-cut.html#%E5%A6%82%E4%BD%95%E6%A0%B9%E6%8D%AE%E5%AD%97%E8%8A%82%E6%8F%90%E5%8F%96)如何根据字节提取

使用`-b`选项通过指定字节的位置来选择一行的某一部分，使用逗号分隔每个指定位置，或用连字符 `-` 指定一个范围。

下面这个例子提取 content.txt 文件每一行的第一，二，三个字节：

```
$ cut -b 1,2,3 content.txt 
Ubu
Mic
OsX
Uni
Fre
```

我们也可以用如下命令列出一个范围；

```
$ cut -b 1-3,5-7 content.txt 
Ubutu 
Micoso
OsXEl 
Uni
FreBSD
```

## 2.7. [#](https://www.lxlinux.net/e/linux/linux-cut.html#%E4%B8%80%E4%BA%9B%E5%AE%9E%E7%94%A8%E7%9A%84%E4%BE%8B%E5%AD%90)一些实用的例子

**cut** 是一个实用的命令，常常和其他Linux或Unix命令结合使用 。

例如如果你想提取 ps 命令中的 USER，PID和COMMAND：

```
ps -L u n | tr -s " " | cut -d " " -f 2,3,14-
USER PID COMMAND
0 676 /sbin/agetty -o -p -- \u --keep-baud 115200,38400,9600 ttyS0 vt220
0 681 /sbin/agetty -o -p -- \u --noclear tty1 linux
0 23174 -bash
0 26737 ps -L u n
0 26738 tr -s
0 26739 cut -d -f 2,3,14-
```

再测试一个例子，提取内存的 total，used和free值，并保存到一个文件中。

```
$ free -m | tr -s ' ' | sed '/^Mem/!d' | cut -d" " -f2-4 >> memory.txt
$ cat memory.txt
985 86 234
```

## 2.8. [#](https://www.lxlinux.net/e/linux/linux-cut.html#%E6%80%BB%E7%BB%93)总结

**cut** 命令可以和很多其他Linux或Unix命令通过管道连接。可以通过管道传递一个或多个过滤器进行额外的文本处理。

**cut** 命令的局限性之一是它不支持指定多个字符作为分隔符。多个空格会被计算为多个字段分隔符，因此必须在 **cut** 命令前使用 **tr** 命令才能获得需要的输出。
# 3. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
[Linux cut命令详解 | 良许嵌入式](https://www.lxlinux.net/e/linux/linux-cut.html#%E5%A6%82%E4%BD%95%E4%BB%A5%E5%AD%97%E7%AC%A6%E7%9A%84%E6%96%B9%E5%BC%8F%E6%8F%90%E5%8F%96%E5%86%85%E5%AE%B9)
