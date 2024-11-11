---
created: 2023-11-03T22:29
updated: 2023-11-06T12:24
---
## 0.1. 参考链接
1. [linux之find -regex 使用正则表达式_find 正则_慕城南风的博客-CSDN博客](https://blog.csdn.net/lovedingd/article/details/107896981)
2. [Linux系统find命令详解 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/556919811?utm_id=0)

-regex
```bash
find . -regex ".*fullsc.*"
```
![[Pasted image 20230922172928.png]]
-regex同样属于测试项。使用-regex时有一点要注意：-regex不是匹配文件名，而是匹配完整的文件名（包括路径）。例如，当前目录下有一个文件"abar9"，如果你用"ab.*9"来匹配，将查找不到任何结果，正确的方法是使用".*ab.*9"或者".*/ab.*9"来匹配。  
针对上面的那个查找c代码的问题，可以这么写：
```bash
$ find . -regex ".*/[0-9]*/.c" -print  
./2234.c

# 基于正则表达式匹配文件路径
find . -regex ".*\(\.txt\|\.pdf\)$"
#### 否定参数

找出/home下不是以.txt结尾的文件

```shell
find /home ! -name "*.txt"
```

```
## 一、`find`命令

`find`命令是一种通过条件匹配在指定目录下查找对应文件或者目录的工具。匹配的条件可以是文件名称、类型、大小、权限属性、[时间戳](https://link.zhihu.com/?target=https%3A//so.csdn.net/so/search%3Fq%3D%25E6%2597%25B6%25E9%2597%25B4%25E6%2588%25B3%26spm%3D1001.2101.3001.7020)等。`find`命令还可以配合相关命令对匹配到的文件作出后续处理。

## 二、工作原理及特点

`find`在工作时会遍历指定的目录，通过匹配指定的条件搜寻我们需要的文件或者目录。因此，`find`命令具有以下特点：

- 查找速度略慢
- 精确查找
- 实时查找
- 可能只搜索用户具备读取和执行权限的目录（这点同locate）

## 三、命令用法

`find`命令语法格式为:`find [path...] [expression]`

`[path...]`为需要查找文件所指定的路径。如果不指定，则默认为当前目录及其子目录。

`[expression]`为匹配条件/表达式。如果未设置匹配条件，则默认查找指定目录及子目录下所有文件

## 四、匹配条件

### 4.1 指定搜索目录层级/深度

指定搜索目录的层级需要用到选项-maxdepth和-mindepth，分别指定搜索目录的最大深度和最小深度。两个选项可以配合使用，指定搜索目录的深度范围。如果-maxdepth/-mindepth二者的参数相同，则`find`命令会搜索某个特定深度的文件。

```text
-maxdepth level 指定最大搜索目录深度level,指定的目录为第1级
-mindepth level 指定最小搜索目录深度level。配合-maxdepth可搜索指定深度的文件。
```

示例1：**find / -maxdepth 2 -name "*.conf" ,** 该命令中”/”为第一级目录,查找文件的最大目录深度为2。

```text
[root@nat1 ~]# find / -maxdepth 2 -name "*.conf"
/etc/resolv.conf
/etc/asound.conf
/etc/logrotate.conf
/etc/dracut.conf
/etc/host.conf
/etc/ld.so.conf
/etc/nsswitch.conf
/etc/sestatus.conf
/etc/sysctl.conf
/etc/libuser.conf
/etc/libaudit.conf
/etc/krb5.conf
/etc/yum.conf
/etc/kdump.conf
/etc/chrony.conf
/etc/rsyslog.conf
/etc/man_db.conf
/etc/sudo-ldap.conf
/etc/sudo.conf
/etc/e2fsck.conf
/etc/mke2fs.conf
/etc/vconsole.conf
/etc/locale.conf
[root@nat1 ~]# 
```

### 0.1.1. 根据文件名和inode查找

在下面的例子中，我们使用了-name选项查找f开头的文件，现在我们开始讲解如何根据文件名查找指定文件。另外，由于每个文件都有一个inode编号与其对应，除了硬链接文件外，同一分区下，每个文件的inode编号都是唯一的，也因此我么可以利用inode编号及文件的链接数来查找符合条件的文件。相关选项用法如下：

```text
-name "FILE_NAME"   文件名查找，支持使用glob：*、？、[]、[^]
-iname "FILE_NAME"  文件名查找，不区分大小写
-inum n             按inode号查找
-samefile name      查找与指定文件有相同inode号的文件，一般用于查找硬连接文件
-links n            查找连接数为N的文件
-regex "PATTERN"    以PATTERN匹配整个文件路径字符串，而不仅仅是文件名称
```

示例：_#find ./ -name "f*" # 查找指定目录下所有文件名以f开头的文件 #_

```text
[root@nat1 ~]# find . -name "f*" 
./file.txt
```

### 0.1.2. 根据属主/属组查找

根据文件的属主以及属组信息，我们可以查找符合指定属主、属组的文件。相关选项用法如下：

```text
-user username      查找属主为指定用户(UID)的文件
-group groupname    查找属组为指定组(GID)的文件
-uid UseerID        查找属主为指定的UID号的文件
-gid GroupID        查找属组为指定的GID号的文件
-nouser             查找没有属主的文件
-nogroup            查找没有属组的文件
————————————————
```

示例：

```text
root@Centos7T test1]#ll
total 0
-rw-r--r--. 1 root     root     0 Aug  6 13:45 f1
-rw-r--r--. 1 geoffrey root     0 Aug  6 13:45 f2
-rw-r--r--. 1 root     geoffrey 0 Aug  6 15:04 f3
-rw-r--r--. 1 geoffrey geoffrey 0 Aug  6 15:04 f4
[root@Centos7T test1]#find ./ -user geoffrey
./f2
./f4
[root@Centos7T test1]#find ./ -group geoffrey
./f3
./f4
[root@Centos7T test1]#find ./ -gid 0
./
./f1
./f2
————————————————
```

### 0.1.3. 根据文件类型查找

linux系统中的文件大致分为以下种：普通文件、目录文件、二进制程序文件、符号链接文件、套接字文件、块设备文件、字符设备文件。我们可以指定搜索文件的文件类型以达到查找文件的目的。命令用法为find [path] -type TYPE。所搜文件的具体类型有TYPE的值确定。TYPE的值及具体含义如下

```text
f  普通文件
d  目录文件
l  符号链接文件
s  套接字文件
b  块设备文件
c  字符设备文件
p  管道文件
```

示例：

```text
[root@Centos7T ~]#find /dev -type b
/dev/sda5
/dev/sda4
/dev/sda3
······
root@Centos7T ~]#find / -maxdepth 1 -type d
/
/app
/boot
/dev
······
[root@Centos7T ~]#find /etc -maxdepth 1 -type l
/etc/favicon.png
/etc/redhat-release
/etc/system-release
/etc/mtab
······
```

### 0.1.4. 根据文件大小查找

命令用法为`find [path] -size [+|-]N`

其中N为文件大小，单位为c/k/M/G.

[+|-]N的具体含义如下：

```text
50k:   搜索49k~50k大小的文件   N-1~N
+50k:  搜索大于50k的文件       N~······
-50k:  搜索小于49k的文件       0~N-1
```

示例：

```text
[root@Centos7T ~]#find /app -size 2M
/app/man_pages_zh-CN_v1.6.2.1.tar.gz
[root@Centos7T ~]#find /app -size +10k
/app/man_pages_zh-CN_v1.6.2.1.tar.gz
/app/source/httpd-2.2.34.tar.gz
/app/source/httpd-2.4.27.tar.bz2
/app/source/nginx-1.12.1.tar.gz
/app/source/linux-4.12.4.tar.xz
[root@Centos7T ~]#find /app -size -1k
/app/wang/1024
/app/wang/18_f2
/app/wang/2048
/app/wang/4096
/app/wang/9172
/app/wang/f1
/app/wang/test110
/app/wang/test
```

这个命令对用户找大文件非常重要。

### 0.1.5. 根据时间戳查找

文件的时间戳分为访问时间(access time)/修改时间(modify time)/创建时间(create time)，分别简写为atime/mtime/ctime。我们可以根据这三个时间戳查找对应文件。命令用法如下：

```text
 根据时间戳查找：
       以天为单位(time)：访问时间
           -atime [+|-]#
               +: 表示（#+1）天之外被访问过；
               -: 表示#天之内被访问过；
               无符号：表示短于（#+1）> x >=#天的时间段被访问过；    
           -mtime:修改时间
           -ctime:创建时间

       以分钟为单位(min)：
           -amin [+|-]#:访问时间
           -mmin:修改时间
           -cmin:创建时间
```

示例：

```text
[root@Centos7T app]#find /app -atime +1
/app/wang/1024
/app/wang/18_f2
/app/wang/2048
/app/wang/4096
/app/wang/9172
/app/wang/f1
[root@Centos7T app]#find /app -atime -1
/app/test1
/app/test1/f1
/app/test1/f2
/app/test1/f3
/app/test1/f4
[root@Centos7T app]#find /app -atime 1
/app/systeminfo.sh
/app/arg.sh
/app/wang/08-scp.sh
/app/wang/1024.sh
/app/wang/11backup.sh
/app/wang/11scp.sh
/app/wang/15scp.sh
/app/wang/17scp.sh
```

示例： 查找五分钟以内创建的目录：

find . -cmin 3 -type d

### 0.1.6. 根据权限查找

我们可以根据文件三类访问对象的三种三种权限查找对应文件，命令用法如下：

```text
-perm [/|-] MODE
   MODE：精确匹配三类对象(u,g,o)的权限
  /MODE：三类对象只要有一类对象中的三个权限位匹配一位即可，或关系(/444,三个只要有一 个“有”读权限(注意不是“是”读权限,))
  -MODE：三类对象分别有对应权限，是否还有其他权限不在意，与关系(-444,三个都要“有”读权限，可以匹配到4,6,7；是否还有写或者执行权限不关心)
  Notes：/或者-后面需要匹配的权限出现0(例如404)，,则表明不关心该对象权限(例如440,所属组有无权限都不关心)。如果单独的权限表示精确匹配，则表明该对象无任何权限
```

示例：

```text
[root@Centos7T test1]#ll
total 0
--wx--x--x. 1 root root 0 Aug  6 13:45 f1
-rw-r--r-x. 1 root root 0 Aug  6 13:45 f2
-r-xr--r--. 1 root root 0 Aug  6 15:04 f3
--w--wx-w-. 1 root root 0 Aug  6 15:04 f4
[root@Centos7T test1]#find ./ -name "f*" -perm 311
./f1
[root@Centos7T test1]#find ./ -name "f*" -perm -644
./f2
```

### 0.1.7. 多条件查询

find命令常用的多条件组合查询方式：

```text
and    -a   与   #并且，也可以忽略
or     -o   或   #
not    !    非   #相反的条件
```

多条件查询示例：

```text
1.查找普通文件和符号链接文件
[root@ky35z 51mn]# find ./ -type f -o -type l

2.在当前目录查找gz包和zip包
[root@ky35z 51mn]# find ./ -name "*.gz" -o -name "*.zip"

3.查找名为info的符号链接文件
[root@ky35z 51mn]# find ./ -name "*info" -a -type l

4.查找log以外的文件
[root@ky35z 51mn]# find ./ ! -name "*.log"

5.查找30分钟以内生成并且名字有1101_的.jpg图片文件
[root@ky35z 51mn]#find . -amin -30 -a -name "1101_*.jpg"
```

## 0.2. 五、处理动作

有时候我们查找文件可能还会对这些文件进行后续的操作，例如删除，修改权限等。可以使用以下命令：

```text
-print:默认的处理动作，显示至屏幕
-ls   :类似于对查找到的文件执行“ls -l”命令
-delete:删除查找到的文件 *慎用！*
-fls file :查找到的所有文件的长格式信息保存至指定文件中，也可用重定向的方式
-ok COMMAND {} \; :对查找到的每个文件执行由COMMAND指定的命令，对于每个文件执行命令之前，都会交互式要求用户确认
-exec COMMAND {} \; :对查找到的每个文件执行由COMMAND指定的命令,没有-ok中的交互式确认。
    其中{}用于引用查找到的文件名称自身，\;是配合-ok和-exec选项的
```

示例：

```text
[root@Centos7T app]#find ./test1/ -type f -perm -001
./test1/f1
./test1/f2
[root@Centos7T app]#find ./test1/ -type f -perm -001 -exec chmod o-x {} \;
[root@Centos7T app]#ll ./test1/*
--wx--x---. 1 root root 0 Aug  6 13:45 ./test1/f1
-rw-r--r--. 1 root root 0 Aug  6 13:45 ./test1/f2
-r-xr--r--. 1 root root 0 Aug  6 15:04 ./test1/f3
--w--wx-w-. 1 root root 0 Aug  6 15:04 ./test1/f4
```

当然find 和xargs是绝配， 后续我们将另起一个文章重点写写！

## 0.3. **六、**获取某个时间段内的文件

如章节：4.6， 可以从天数atime,ctime,mtime [+|-] N天， 也可以amin,cmin,mmin [+|-]分钟可以找到相应的文件。

也可以通过：newer参数来搜索。

例如：

```text
root@nat1 ~]# find . -type f -newermt '2022-08-17 00:00:00'  #找到比2022-08-17 0时0分0秒修改的文件
./.bash_history
./debug.sh
./test.txt
[root@nat1 ~]# ls -lrt test.txt
-rw-r--r--. 1 root root 52 Aug 21 00:24 test.txt
```

其实find -newermt的真正形式是find -newer**XY** {variable}，旨在找到一些X属性比variable的Y属性更早的文件。其中

**X**指代find的目标文件属性；X可选a,c,m;Y可选a,c,m,t。acm意义分别为atime（访问时间），ctime(改变时间），mtime（修改时间）。

**Y**代表参照属性。t代表客观绝对时间，只作为参照属性存在，格式为yyyy-MM-dd hh:mm:ss。

由于我想要找到除了今天修改的文件之外的文件，只需要

1. 筛出mtime为今天的文件：find {path} -newermt `date +%F` -type f

```text
[root@nat1 ~]# touch aa                            #创建一个文件
[root@nat1 ~]# date        
Thu Aug 25 06:07:47 EDT 2022
[root@nat1 ~]# ls -l aa
-rw-r--r--. 1 root root 0 Aug 25 06:07 aa
[root@nat1 ~]# find . -newermt `date +%F` -type f  #检索今天创建的文件
./aa
[root@nat1 ~]# find . -newermt `date +%F` -type f | xargs ls -l 
-rw-r--r--. 1 root root 0 Aug 25 06:07 ./aa
```

2. 进行反选，在find中加入 !

```text
root@nat1 ~]# find . ! -newermt `date +%F` -type f  ####检查一下并没有aa文件
./.bash_logout
./.bash_profile
./.bashrc
./.cshrc
./anaconda-ks.cfg
./ssh_cmd_test.sh
./test.sh
./loop.sh

./test.txt
```

所以得到的最终命令为

``find {path} ! -newermt \`date +%F\` -exec {order} {} \;``

最后一组{}表示exec之前筛到的文件。