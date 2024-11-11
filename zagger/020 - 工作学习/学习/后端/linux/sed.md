---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
## 0.1. 参考链接
1. [Linux sed 命令 | 菜鸟教程 (runoob.com)](https://www.runoob.com/linux/linux-comm-sed.html)
2. [sed命令_Linux sed命令：替换、删除、更新文件中的内容 (biancheng.net)](http://c.biancheng.net/linux/sed.html)
3. [Linux之sed命令详解 | 《Linux就该这么学》 (linuxprobe.com)](https://www.linuxprobe.com/linux-sed-command.html)
4. [搜索 命令，Linux 搜索 命令详解：最专业的Linux命令大全，命令搜索引擎，内容包含Linux命令手册、详解、学习，值得收藏的Linux命令速查手册。 - Linux 命令搜索引擎 (lutixia.cn)](http://bash.lutixia.cn/list.html#!kw=sed)
5. [awk 命令，Linux awk 命令详解：文本和数据进行处理的编程语言 - Linux 命令搜索引擎 (lutixia.cn)](http://bash.lutixia.cn/c/awk.html#!kw=sed)

```bash
sed '/test/{ n; s/aa/bb/; }' test
```

```bash
 sed -e '/test/h' -e '$G' file 
```

在这个例子里，匹配test的行被找到后，将存入模式空间，h命令将其复制并存入一个称为保持缓存区的特殊缓冲区内。第二条语句的意思是，当到达最后一行后，G命令取出保持缓冲区的行，然后把它放回模式空间中，且追加到现在已经存在于模式空间中的行的末尾。在这个例子中就是追加到最后一行。简单来说，任何包含test的行都被复制并追加到该文件的末尾。

**保持和互换：h命令和x命令**

互换模式空间和保持缓冲区的内容。也就是把包含test与check的行互换：

 ```bash
 sed -e '/test/h' -e '/check/x' file
```


```bash
 sed -n 'p;n' test.txt  #奇数行 sed -n 'n;p' test.txt  #偶数行
```

```bash
 sed -n '1~2p' test.txt  #奇数行 sed -n '2~2p' test.txt  #**偶数行**
```
一、sed命令介绍
sed 是 stream editor 的缩写，中文称之为“流编辑器”。

sed 命令是一个面向行处理的工具，它以“行”为处理单位，针对每一行进行处理，处理后的结果会输出到标准输出（STDOUT）。你会发现 sed 命令是很懂礼貌的一个命令，它不会对读取的文件做任何贸然的修改(除非加上-i选项)，而是将内容都输出到标准输出中。

sed命令的语法：`sed command file`

command 部分：针对每行的内容所要进行的处理（这部分很重要很重要）。
file 部分：要处理的文件，如果忽略 file 参数，则 sed 会把标准输入作为处理对象。
sed命令的选项与参数：
```bash
-n : 使用静默模式，在一般的sed的用法中，所有来自stdin(标准输出)的数据一般都会被列出到屏幕上。
     但如果加上-n参数后，则只要经过sed特殊处理的那行才会被列出来。
-e : 直接在命令行模式上进行sed的操作编辑
-f : 直接将sed的操作写在一个文件内，-f filename则可以执行filename内的sed操作，  
              add  the contents of script-file to the commands to be executed 将script-file的内容添加到要执行的命令中
-r : 使用扩展正则表达式的语法
-i : 直接修改文件内容，而不是输出到屏幕上 ， -i[SUFFIX], --in-place[=SUFFIX]， edit files in place (makes backup if SUFFIX supplied)
command说明：[n1][,n2] action
n1,n2 : 一般代表【选择进行操作(action)的行数】，举例：如果我的操作是需要在
        5行到20行之间进行的，则【5,20[action]】。
action的参数：
单行模式空间
a : 新增。a的后面接字符，而这些字符会在新增到下一行
i : 插入。i的后面接字符，而这些字符会在新增到上一行
c : 替换。c的后面接字符，这些字符替换n1到n2的行
d : 删除。因为是删除，所以d后面通常不接任何东西
p : 打印。将匹配的数据打印出来。通常p会与选项-n一起使用
s : 替换。将文件原内容替换为新内容。举例：s/lod/new/g
s/regexp/replacement/
              Attempt to match regexp against the pattern space.  If suc‐
              cessful,  replace  that  portion  matched with replacement.
              The replacement may contain  the  special  character  &  to
              refer  to  that portion of the pattern space which matched,
              and the special escapes \1 through \9 to refer to the  cor‐
              responding matching sub-expressions in the regexp.
n : 读取匹配的数据的下一行，覆盖模型空间的前一行(也就是被匹配的行)，结果交给下一个参数处理
多行模式空间
N : 读取匹配的数据的下一行追加到模式空间，同时将两行看做一行，但是两行之间依然含有\n换行符
n N    Read/append the next line of input into the pattern space.
P : 打印。打印模式空间开端至\n(换行)之间的内容，并追加到默认输出之前。
D : 如果模式空间包含换行符，则删除模式空间开端至\n(换行)之间的内容， 并不会读取新的输入行，
    而使用合成的模式空间重新启动循环。如果模式空间不包含换行符，则会像发出d命令那样启动正常的新循环

替换标记
g 表示行内全面替换。 
p 表示打印行。 
w 表示把行写入一个文件。 
x 表示互换模板块中的文本和缓冲区中的文本。 
y 表示把一个字符翻译为另外的字符（但是不用于正则表达式）
\\1 子串匹配标记
& 已匹配字符串标记

其它
! 表示后面的命令对所有没有被选定的行发生作用。 
= 打印当前行号码。 
# 把注释扩展到下一个换行符以前。 

```
二、sed 的工作原理与流程
工作原理：

sed 命令是面向“行”进行处理的，每一次处理一行内容。处理时，sed 会把要处理的行存储在缓冲区中，接着用 sed 命令处理缓冲区中的内容，处理完成后，把缓冲区的内容送往屏幕。接着处理下一行，这样不断重复，直到文件末尾。这个缓冲区被称为“模式空间”（pattern space）。在这个处理过程中，sed 命令并不会对文件本身进行任何更改。

工作流程：

主要包括读取、执行和显示三个过程。

**读取**：sed 从输入流（文件、管道、标准输入）中读取一行内容并存储到临时的缓冲区中（又称模式空间，pattern space）。
**执行**：默认情况下，所有的 sed 命令都在模式空间中顺序地执行，除非指定了行的地址，否则 sed 命令将会在所有的行上依次执行。
**显示**：发送修改后的内容到输出流。在发送数据后，模式空间将会被清空。在所有的文件内容都被处理完成之前，上述过程将重复执行，直至所有内容被处理完。
2.1 模式空间与保持空间
**模式空间(pattern space)：** sed处理文本内容行的一个临时缓冲区，模式空间中的内容会主动打印到标准输出，并自动清空模式空间

**保持空间(hold space)：** sed处理文本内容行的另一个临时缓冲区，不同的是保持空间内容不会主动清空，也不会主动打印到标准输出，而是需要sed命令来进行处理

模式空间与保持空间的关系：

**模式空间：** 相当于流水线，文本行在模式空间中进行处理；
**保持空间：** 相当于仓库，在模式空间对数据进行处理时，可以把数据临时存储到保持空间；作为模式空间的一个辅助临时缓冲区，但又是相互独立，可以进行交互，命令可以寻址模式空间但是不能寻址保持空间。可以使用高级命令h,H,g,G与模式空间进行交互。

模式空间与保持空间进行交互：
```
d : 删除模式空间的内容，开始下一个循环
D : 删除模式空间/n(换行符)前面的内容

h : 【复制】模式空间的内容至保持空间(会覆盖保持空间的原内容)
H : 把模式空间的内容【追加】至保持空间

g : 【复制】保持空间的内容至模式空间(会覆盖模式空间的原内容)
G : 把保持空间的内容【追加】至模式空间

x : 【交换】模式空间与保持空间的内容
```
### 0.1.1. 三、sed命令演示

**注意！** 以下的演示都未加`-i`，所以对实际文件内容不产生任何效果。
```
#使用sed命令对该文件进行演示
[root@localhost ~]# cat passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
=======================================
#用a参数在第一行的下面插入test
[root@localhost ~]# sed '1atest' passwd
root:x:0:0:root:/root:/bin/bash
test
bin:x:1:1:bin:/bin:/sbin/nologin

#用i参数在第二行的上面插入hello
[root@localhost ~]# sed '2ihello' passwd
root:x:0:0:root:/root:/bin/bash
hello
bin:x:1:1:bin:/bin:/sbin/nologin

#用c参数把第二行替换为hello
[root@localhost ~]# sed '2chello' passwd
root:x:0:0:root:/root:/bin/bash
hello

#用d参数删除匹配到‘root’的行
[root@localhost ~]# sed '/root/d' passwd
bin:x:1:1:bin:/bin:/sbin/nologin

#单独用s参数替换文件内容只会替换该行匹配到的第一个
[root@localhost ~]# sed 's/root/tom/' passwd
tom:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
#s和g搭配使用可达到替换全部匹配到的效果
[root@localhost ~]# sed 's/root/tom/g' passwd
tom:x:0:0:tom:/tom:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin

#单独使用p参数可以看到不仅打印出匹配‘root’的行，还把原本内容 \
#一起显示出来了，这是因为sed的特性，文章开头的一段话就说明了。
[root@localhost ~]# sed '/root/p' passwd
root:x:0:0:root:/root:/bin/bash
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
#通常p参数会搭配-n选项一起使用，-n是静默模式
[root@localhost ~]# sed -n '/root/p' passwd
root:x:0:0:root:/root:/bin/bash

#使用y参数进行大小写转换
[root@localhost ~]# sed 'y/abdef/ABDEF/' test
A FriEnD is somEonE
with whom you
DArE to BE yoursElF.
[root@localhost ~]# sed 'y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/' test
A FRIEND IS SOMEONE
WITH WHOM YOU
DARE TO BE YOURSELF.

#用n参数读取当前行(匹配到的行)的下一行至模式空间，n参数会覆盖模式空间的 \
#前一行(也就是含有'root'的行)。此时模式空间只有‘下一行’，后面的d参数会 \
#删除模式空间的内容，所以sed会打印出含有root的行
[root@localhost ~]# sed '/root/n;d' passwd
root:x:0:0:root:/root:/bin/bash


#在前面看到的都是单行模式。每次sed处理一个行。
#但是sed是允许一次处理多行的。加上N参数追加进模式空间，此时\
#sed将两行看做一行，这就是所谓的多行模式空间。
#以下几行是用于sed对多行模式空间进行操作练习的文件内容
[root@localhost ~]# cat test
A friend is someone
with whom you
dare to be yourself.

#可以发现使用N参数没有内容被打印出来，是因为N参数读取当前行的下一行至模式空间时\
#并不会覆盖模式空间的上一行，此时模式空间‘当前行’与‘下一行’都存在，后面的d参数会\
#模式空间的内容，所有没有内容被打印出来
[root@localhost ~]# sed '/root/N;d' passwd
[root@localhost ~]#
#使用N参数追加匹配到的行至模式空间，然后使用s参数进行替换，由于使用N参数，原本\
#内容的两行此时在模式空间里被当作一行进行处理，把\n替换为空格后，由于中间没有了\
#换行符，打印到屏幕上时会显示为一行
[root@localhost ~]# sed '/A/{N;s/someone\n/someone /}' test
A friend is someone with whom you
dare to be yourself.
#对上条命令做了一点小小的修改。先说说这条命令要达成什么效果吧“把第二行的with挪到第一行”\
#这里的思路其实就是把换行符变动了位置，达到了把第二行的开头挪到第一行的结尾的效果
[root@localhost ~]# sed '/A/{N;s/someone\nwith /someone with\n/}' test
A friend is someone with
whom you
dare to be yourself.

#咦？这里原本的第二行怎么不见了呢！来分析一下。首先把匹配的行读入模式空间，后面的N参数\
#又把下一行追加至模式空间，此时模式空间有两行内容，但被看作一行，但这一行中间有\n，\
#P参数只打印模式空间开头到\n之间的内容，也就是说\n之后的内容不会被打印出来
[root@localhost ~]# sed -n '/A/N;P' test
A friend is someone
dare to be yourself.

#D参数使用下面的文本作讲解
[root@localhost ~]# cat sed_D
This is 1
This is 2
This is 3
This is 4
This is 5
#读取1，执行N，得出1\n2，执行D，得出2
#执行N，得出2\n3，执行D，得出3
#依此类推，得出5，执行N，条件失败退出，因无-n参数，故输出5
[root@localhost ~]# sed 'N;D' sed_D
This is 5

#模式空间与保持的交互
#以下几行用作下面练习的文件内容
[root@localhost ~]# cat test
A friend is someone
with whom you
dare to be yourself.

#先匹配含有w的行，N参数把下一行也追加至模式空间，此时有模式有两行内容\
#h参数把模式空间的内容复制到保持空间，之后d参数删除模式空间的内容\
[root@localhost ~]# sed '/w/{N;h;d}' test
A friend is someone

#
[root@localhost ~]# sed '/w/{N;h;d};/A/{N;s#is#the#g;G}' test
A friend the someone
with whom you

dare to be yourself.

```

**sed的选项、[命令](https://www.linuxcool.com/ "命令")、替换标记**

**命令格式**

sed的命令格式：sed [options] 'command' file(s);  
sed的[脚本](https://www.linuxcool.com/ "脚本")格式：sed [options] -f scriptfile file(s);

**选项**

 -e ：直接在命令行模式上进行sed动作编辑，此为默认选项;  
 -f ：将sed的动作写在一个文件内，用–f filename 执行filename内的sed动作;  
 -i ：直接修改文件内容;  
 -n ：只打印模式匹配的行；  
 -r ：支持扩展表达式;  
 -h或--help：显示帮助；  
 -V或--version：显示版本信息。

**参数**

文件：指定待处理的文本文件列表。

**sed常用命令**

 a\ 在当前行下面插入文本;  
 i\ 在当前行上面插入文本;  
 c\ 把选定的行改为新的文本;  
 d 删除，删除选择的行;  
 D 删除模板块的第一行;  
 s 替换指定字符;  
 h 拷贝模板块的内容到内存中的缓冲区;  
 H 追加模板块的内容到内存中的缓冲区;  
 g 获得内存缓冲区的内容，并替代当前模板块中的文本;  
 G 获得内存缓冲区的内容，并追加到当前模板块文本的后面;  
 l 列表不能打印字符的清单;  
 n 读取下一个输入行，用下一个命令处理新的行而不是用第一个命令;  
 N 追加下一个输入行到模板块后面并在二者间嵌入一个新行，改变当前行号码;  
 p 打印模板块的行。 P(大写) 打印模板块的第一行;  
 q 退出Sed;  
 b lable 分支到[脚本](https://www.linuxcool.com/ "脚本")中带有标记的地方，如果分支不存在则分支到脚本的末尾;  
 r file 从file中读行;  
 t label if分支，从最后一行开始，条件一旦满足或者T，t命令，将导致分支到带有标号的命令处，或者到脚本的末尾;  
 T label 错误分支，从最后一行开始，一旦发生错误或者T，t命令，将导致分支到带有标号的命令处，或者到脚本的末尾;  
 w file 写并追加模板块到file末尾;  
 W file 写并追加模板块的第一行到file末尾;  
 ! 表示后面的命令对所有没有被选定的行发生作用;  
 = 打印当前行号;  
# 1. 把注释扩展到下一个换行符以前;

**sed替换标记**

 g 表示行内全面替换;  
 p 表示打印行;  
 w 表示把行写入一个文件;  
 x 表示互换模板块中的文本和缓冲区中的文本;  
 y 表示把一个字符翻译为另外的字符（但是不用于正则表达式）;  
 
 \1 子串匹配标记;  
 & 已匹配字符串标记;

**sed元字符集**

 ^ 匹配行开始，如：/^sed/匹配所有以sed开头的行;  
 
 $ 匹配行结束，如：/sed$/匹配所有以sed结尾的行;  
 
 . 匹配一个非换行符的任意字符，如：/s.d/匹配s后接一个任意字符，最后是d;  
 
 * 匹配0个或多个字符，如：/*sed/匹配所有模板是一个或多个空格后紧跟sed的行;  
  
 [] 匹配一个指定范围内的字符，如/[ss]ed/匹配sed和Sed;  
   
 [^] 匹配一个不在指定范围内的字符，如：/[^A-RT-Z]ed/匹配不包含A-R和T-Z的一个字母开头，紧跟ed的行;  
  
 \(..\) 匹配子串，保存匹配的字符，如s/\(love\)able/\1rs，loveable被替换成lovers;  
  
 & 保存搜索字符用来替换其他字符，如s/love/**&**/，love这成**love**;  
  
 \< 匹配单词的开始，如:/\ 
 \> 匹配单词的结束，如/love\>/匹配包含以love结尾的单词的行;  
 
 x\{m\} 重复字符x，m次，如：/0\{5\}/匹配包含5个0的行;  
 
 x\{m,\} 重复字符x，至少m次，如：/0\{5,\}/匹配至少有5个0的行;  
 
 x\{m,n\} 重复字符x，至少m次，不多于n次，如：/0\{5,10\}/匹配5~10个0的行;
**sed用户实例**

**替换操作：s命令**

替换文本中的字符串：

 sed 's/book/books/' file

**-n选项**和**p命令**一起使用表示只打印那些发生替换的行：

 sed -n 's/test/TEST/p' file

直接编辑文件**选项-i**，会匹配file文件中每一行的第一个book替换为books

 sed -i 's/book/books/g' file

**全面替换标记g**

使用后缀 /g 标记会替换每一行中的所有匹配：

 sed 's/book/books/g' file

当需要从第N处匹配开始替换时，可以使用 /Ng：

 echo sksksksksksk | sed 's/sk/SK/2g' 
 skSKSKSKSKSK
 echo sksksksksksk | sed 's/sk/SK/3g'
 skskSKSKSKSK  
 echo sksksksksksk | sed 's/sk/SK/4g'
 skskskSKSKSK 

**定界符**

以上命令中字符 / 在sed中作为定界符使用，也可以使用任意的定界符

 sed 's:test:TEXT:g' 
 sed 's|test|TEXT|g' 

定界符出现在样式内部时，需要进行转义：

 sed 's/\/bin/\/usr\/local\/bin/g'

**删除操作：d命令**

删除空白行：

 sed '/^$/d' file

删除文件的第2行：

 sed '2d' file

删除文件的第2行到末尾所有行：

 sed '2,$d' file

删除文件最后一行：

 sed '$d' file

删除文件中所有开头是test的行：

 sed '/^test/'d file

**已匹配字符串标记&**

正则表达式 \w\+ 匹配每一个单词，使用 [&] 替换它，& 对应于之前所匹配到的单词：

 echo this is a test line | sed 's/\w\+/[&]/g'
 [this] [is] [a] [test] [line] 

所有以192.168.0.1开头的行都会被替换成它自已加localhost：

 sed 's/^192.168.0.1/&localhost/' file 192.168.0.1localhost

**子串匹配标记\1**

匹配给定样式的其中一部分：

 echo this is digit 7 in a number | sed 's/digit \([0-9]\)/\1/' 
 this is 7 in a number

命令中 digit 7，被替换成了 7。样式匹配到的子串是 7，\(..\) 用于匹配子串，对于匹配到的第一个子串就标记为 \1，依此类推匹配到的第二个结果就是 \2，例如：

 echo aaa BBB | sed 's/\([a-z]\+\) \([A-Z]\+\)/\2 \1/' 
 BBB aaa

love被标记为1，所有loveable会被替换成lovers，并打印出来：

 sed -n 's/\(love\)able/\1rs/p' file

**组合多个表达式**

 sed '表达式' | sed '表达式'  等价于：  
 sed '表达式; 表达式'

**引用**

sed表达式可以使用单引号来引用，但是如果表达式内部包含变量字符串，就需要使用双引号。

 test=hello 
 echo hello WORLD | sed "s/$test/HELLO" 
 HELLO WORLD

**选定行的范围：,（逗号）**

所有在模板test和check所确定的范围内的行都被打印：

 sed -n '/test/,/check/p' file

打印从第5行开始到第一个包含以test开始的行之间的所有行：

 sed -n '5,/^test/p' file

对于模板test和west之间的行，每行的末尾用字符串aaa bbb替换：

 sed '/test/,/west/s/$/aaa bbb/' file

**多点编辑：e命令**

-e选项允许在同一行里执行多条命令：

 sed -e '1,5d' -e 's/test/check/' file

上面sed表达式的第一条命令删除1至5行，第二条命令用check替换test。命令的执行顺序对结果有影响。如果两个命令都是替换命令，那么第一个替换命令将影响第二个替换命令的结果。

和 -e 等价的命令是 --expression：

 sed --expression='s/test/check/' --expression='/love/d' file

**从文件读入：r命令**

file里的内容被读进来，显示在与test匹配的行后面，如果匹配多行，则file的内容将显示在所有匹配行的下面：

 sed '/test/r file' filename

**写入文件：w命令**  
   
在example中所有包含test的行都被写入file里：

 sed -n '/test/w file' example

**追加（行下）：a\命令**

将 this is a test line 追加到 以test 开头的行后面：

 sed '/^test/a\this is a test line' file

在 test.conf 文件第2行之后插入 this is a test line：

 sed -i '2a\this is a test line' test.conf 

**插入（行上）：**

i\命令 将 this is a test line 追加到以test开头的行前面：

 sed '/^test/i\this is a test line' file

在test.conf文件第5行之前插入this is a test line：

 sed -i '5i\this is a test line' test.conf

**下一个：n命令**

如果test被匹配，则移动到匹配行的下一行，替换这一行的aa，变为bb，并打印该行，然后继续：

 sed '/test/{ n; s/aa/bb/; }' file 

**变形：y命令**

把1~10行内所有abcde转变为大写，注意，正则表达式元字符不能使用这个命令：

 sed '1,10y/abcde/ABCDE/' file

**退出：q命令**

打印完第10行后，退出sed sed '10q' file 保持和获取：h命令和G命令 在sed处理文件的时候，每一行都被保存在一个叫模式空间的临时缓冲区中，除非行被删除或者输出被取消，否则所有被处理的行都将打印在屏幕上。接着模式空间被清空，并存入新的一行等待处理。

 sed -e '/test/h' -e '$G' file 

在这个例子里，匹配test的行被找到后，将存入模式空间，h命令将其复制并存入一个称为保持缓存区的特殊缓冲区内。第二条语句的意思是，当到达最后一行后，G命令取出保持缓冲区的行，然后把它放回模式空间中，且追加到现在已经存在于模式空间中的行的末尾。在这个例子中就是追加到最后一行。简单来说，任何包含test的行都被复制并追加到该文件的末尾。

**保持和互换：h命令和x命令**

互换模式空间和保持缓冲区的内容。也就是把包含test与check的行互换：

 sed -e '/test/h' -e '/check/x' file 

**脚本scriptfile**

sed脚本是一个sed的命令清单，启动Sed时以-f选项引导脚本文件名。Sed对于脚本中输入的命令非常挑剔，在命令的末尾不能有任何空白或文本，如果在一行中有多个命令，要用分号分隔。以#开头的行为注释行，且不能跨行。

 sed [options] -f scriptfile file(s)

**打印奇数行或偶数行**

方法1：

 sed -n 'p;n' test.txt  #奇数行 sed -n 'n;p' test.txt  #偶数行 

方法2：

 sed -n '1~2p' test.txt  #奇数行 sed -n '2~2p' test.txt  #偶数行 

**打印匹配字符串的下一行**

 grep -A 1 SCC URFILE 
 sed -n '/SCC/{n;p}' URFILE 
 awk '/SCC/{getline; print}' URFILE