---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
# tar命令
## 参考文档
1. [Linux笔记06-压缩解压命令_tar -zcf_浮尘笔记的博客-CSDN博客](https://blog.csdn.net/rxbook/article/details/106059408)
2. [Linux中tar归档命令、zip压缩、gzip压缩、bzip2压缩_linux tar-CSDN博客](https://blog.csdn.net/m0_52165864/article/details/123998531)
## **目录**

[.gz压缩文件：gzip](#t0)

[解压缩.gz的压缩文件：gunzip](#t1)

[打包（压缩）目录：tar](#t2)

 [.zip 压缩文件或目录：zip](#t3)

[解压zip压缩文件命令：unzip](#t4)

[.bz2 压缩命令：bzip2](#t5)

[解压.bz2文件命令：bunzip2](#t6)

---

## .gz压缩文件：gzip

> 命令名称：gzip
> 
> 命令英文原义：[GNU](https://so.csdn.net/so/search?q=GNU&spm=1001.2101.3001.7020) zip
> 
> 命令所在路径：/bin/gzip
> 
> 执行权限：所有用户
> 
> 语法：gzip [文件]
> 
> 功能描述：压缩文件
> 
> 压缩后文件格式：.gz

![](https://img-blog.csdnimg.cn/963b8ea914e14f0baedc2c2bd564fb7a.png)

## 解压缩.gz的压缩文件：gunzip

> 命令名称：gunzip
> 
> 命令英文原意：GNU unzip
> 
> 命令所在路径：/bin/gunzip
> 
> 执行权限：所有用户
> 
> 语法：gunzip [压缩文件].gz
> 
> 功能描述：解压缩.gz的压缩文件

![](https://img-blog.csdnimg.cn/94b8d48d6c544ab580a57c702e8c0553.png)

> 备注说明 ①：使用 gzip -d 也可以解压缩 .gz 压缩文件，与gunzip 相同，案例略。
> 
> 备注说明 ②：使用gzip 只能压缩文件，不能对目录进行压缩：
> 
> 备注说明 ③：使用gzip 压缩文件后，不保留原文件。
> 
> 要压缩目录，就用到了下面的[tar命令](https://so.csdn.net/so/search?q=tar%E5%91%BD%E4%BB%A4&spm=1001.2101.3001.7020)：

## 打包（压缩）目录：tar

> 命令名称：tar
> 
> 命令所在路径：/bin/tar
> 
> 执行权限：所有用户
> 
> 语法：tar 选项[-zcf] [压缩后文件名] [目录]
> 
> -c 打包 [create]
> 
> -v 显示详细信息
> 
> -f 指定文件名
> 
> -z 打包同时压缩
> 
> 功能描述：打包目录
> 
> 压缩后文件格式：.tar.gz

范例：使用 tar -cvf abcd.tar abcd 将目录abcd打包并压缩为.tar文件

![](https://img-blog.csdnimg.cn/358e829405284bd4b3c52c4db5ad8a33.png)

因为使用了 -v ，所以会显示详情。

然后呢，可以在使用 gzip abcd.tar 进行压缩，得到一个 .tar.gz 的压缩文件，这就是大多数网上下载到的最常见的源代码的安装包。

![](https://img-blog.csdnimg.cn/b20c758e9a3e4a35982129144c8421f5.png)

 上面演示的是先打包（将目录打包为 .tar 文件）,然后对这个文件进行压缩。接下来直接进行打包并且压缩（先将刚才生成的压缩文件删除）：

![](https://img-blog.csdnimg.cn/6ba04beed8fa441f85e4ffa550861ded.png)

 这个就表示把目录abcd 打包并压缩为 abcd.tar.gz

**使用tar解压命令：tar**

> tar命令解压缩语法：
> 
> -x 解包
> 
> -v 显示详细信息
> 
> -f 指定解压文件
> 
> -z 解压缩

范例：$ tar -zxvf abcd.tar.gz

简单地说，压缩就是 tar -zcf，解压就是 tar -zxf，需要显示详情就加上 -v。

![](https://img-blog.csdnimg.cn/01563e2b64a2477ca8c1b6301d3f336d.png)

##  .zip 压缩文件或目录：zip

> 命令名称：zip
> 
> 命令所在路径：/usr/bin/zip
> 
> 执行权限：所有用户
> 
> 语法：zip 选项[-r] [压缩后文件名] [文件或目录]
> 
> -r 压缩目录
> 
> 功能描述：压缩文件或目录
> 
> 压缩后文件格式：.zip

案例1：$ zip test.zip test.txt 压缩文件

案例2：$ zip -r abcd.zip abcd 压缩目录

![](https://img-blog.csdnimg.cn/aeeb5e004f8f45ea906863b66275025a.png)

> 说明①：zip压缩目录必须加上 zip -r
> 
> 说明②：使用zip压缩会保留原文件或者原目录

## 解压zip压缩文件命令：unzip

> 命令名称：unzip
> 
> 命令所在路径：/usr/bin/unzip
> 
> 执行权限：所有用户
> 
> 语法：unzip [压缩文件].zip
> 
> 功能描述：解压.zip的压缩文件

范例：$ unzip abcd.zip

## .bz2 压缩命令：bzip2

> 命令名称：bzip2
> 
> 命令所在路径：/usr/bin/bzip2
> 
> 执行权限：所有用户
> 
> 语法： bzip2 选项 [-k] [文件]
> 
> -k 产生压缩文件后保留原文件
> 
> 功能描述：压缩文件
> 
> 压缩后文件格式：.bz2

范例：$ bzip2 -k test.txt

扩展：类似之前的 tar -zcf abcd.tar.gz 压缩目录，这里可以使用 tar -cjf abcd.tar.bz2 abcd 生成一个.tar.bz2压缩文件，注意将 -zcf 改成 -cjf

说明：比较常用的Linux的压缩包举例:.tar.gz 和 .tar.bz2

## 解压.bz2文件命令：bunzip2

> 命令名称：bunzip2
> 
> 命令所在路径：/usr/bin/bunzip2
> 
> 执行权限：所有用户
> 
> 语法： bunzip2 选项 [-k] [压缩文件]
> 
> -k 解压缩后保留原文件
> 
> 功能描述：解压缩

范例：$ bunzip2 -k test.bz2

同样的，解压 .tar.bz2，类似之前的.tar.gz，将上面之前的 -zxf 改成 -xjf ，即可。即：tar -xjf abcd.tar.bz2