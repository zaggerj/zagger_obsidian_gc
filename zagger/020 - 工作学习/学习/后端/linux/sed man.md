---
alias:
tags: 长青笔记
cdate: 2023-12-17 14:10
uid: 20231217141106
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. sed man

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2023-12-17 星期日 14:10:50

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

SED(1)                        User Commands                        SED(1)  
SED（1） 用户命令 SED（1）  
NAME
       sed - stream editor for filtering and transforming text  
NAME sed - 用于过滤和转换文本的流编辑器  
SYNOPSIS
       sed [OPTION]... {script-only-if-no-other-script} [input-file]...  
剧情梗概 sed [选项]...{脚本-only-if-no-other-script}[输入文件]...  
DESCRIPTION
       Sed  is a stream editor.  A stream editor is used to perform basic
       text transformations on an input stream (a file or  input  from  a
       pipeline).   
描述 Sed 是一个流编辑器。流编辑器用于对输入流（文件或来自管道的输入）执行基本文本转换。  
  While in some ways similar to an editor which permits
       scripted edits (such as ed), sed works by  making  only  one  pass
       over  the input(s), and is consequently more efficient.   
虽然在某些方面类似于允许脚本编辑的编辑器（例如 ed），但 sed 只需对输入进行一次传递即可工作，因此效率更高。  
 But it is
       sed's ability to filter text in a pipeline which particularly dis‐
       tinguishes it from other types of editors.  
但是，sed 在管道中过滤文本的能力尤其使它与其他类型的编辑器不同。  
       -n, --quiet, --silent -n， --quiet， --silent  
              suppress automatic printing of pattern space  
禁止自动打印图案空间  
       -e script, --expression=script  
-e 脚本，--expression=脚本  
              add the script to the commands to be executed  
将脚本添加到要执行的命令中  
       -f script-file, --file=script-file  
-f 脚本文件， --file=脚本文件  
              add  the contents of script-file to the commands to be exe‐
              cuted  
将 script-file 的内容添加到要执行的命令中  
       --follow-symlinks  
              follow symlinks when processing in place  
就地处理时遵循符号链接  
       -i[SUFFIX], --in-place[=SUFFIX]  
-i[后缀]， --就地[=后缀]  
              edit files in place (makes backup if SUFFIX supplied)  
就地编辑文件（如果提供了 SUFFIX，则进行备份）  
       -l N, --line-length=N -l N， --line-length=N  
              specify the desired line-wrap length for the `l' command  
为“l”命令指定所需的换行长度  
       --posix --POSIX的  
              disable all GNU extensions.  
禁用所有 GNU 扩展。  
       -E, -r, --regexp-extended  
-E、-r、--正则表达式扩展  
              use extended regular expressions in the script (for  porta‐
              bility use POSIX -E).  
在脚本中使用扩展的正则表达式（对于扩展功能，请使用 POSIX -E）。  
       -s, --separate -s， --分隔  
              consider files as separate rather than as a single, contin‐
              uous long stream.  
将文件视为单独的文件，而不是单个连续的长流。  
       --sandbox --沙盒  
              operate in sandbox mode (disable e/r/w commands).  
在沙盒模式下运行（禁用 e/r/w 命令）。  
       -u, --unbuffered -u， --无缓冲  
              load minimal amounts of data from the input files and flush
              the output buffers more often  
从输入文件加载最少量的数据，并更频繁地刷新输出缓冲区  
       -z, --null-data -z， --null-数据  
              separate lines by NUL characters  
用 NUL 字符分隔行  
       --help
              display this help and exit  
--help 显示此帮助并退出  
       --version
              output version information and exit  
--version 输出版本信息并退出  
       If  no  -e,  --expression, -f, or --file option is given, then the
       first non-option argument is taken as the sed script to interpret.
       All  remaining  arguments  are  names  of input files; if no input
       files are specified, then the standard input is read.  
如果没有给出 -e、--expression、-f 或 --file 选项，则将第一个非选项参数作为要解释的 sed 脚本。所有剩余的参数都是输入文件的名称;如果未指定输入文件，则读取标准输入。  
       GNU sed home page:  <https://www.gnu.org/software/sed/>.   General
       help  using  GNU software: <https://www.gnu.org/gethelp/>.  E-mail
       bug reports to: <bug-sed@gnu.org>.  
GNU sed 主页： .使用 GNU 软件的一般帮助：。将错误报告通过电子邮件发送至：。  
COMMAND SYNOPSIS
       This is just a brief synopsis  of  sed  commands  to  serve  as  a
       reminder  to those who already know sed; other documentation (such
       as the texinfo document) must be  consulted  for  fuller  descrip‐
       tions.  
命令概要 这只是 sed 命令的简要概要，以提醒那些已经知道 sed 的人;必须查阅其他文档（例如 Texinfo 文档）以获得更全面的描述。  
   Zero-address ``commands''
       : label
              Label for b and t commands.  
零地址 ''commands'' ： label b 和 t 命令的标签。  
       #comment
              The comment extends until the next newline (or the end of a
              -e script fragment).  
#comment 注释一直延伸到下一个换行符（或 -e 脚本片段的末尾）。  
       }      The closing bracket of a { } block.  
} { } 块的右括号。  
   Zero- or One- address commands
       =      Print the current line number.  
零地址或单地址命令 = 打印当前行号。  
       a \ 一个\  
       text   Append text, which has each embedded newline preceded by  a
              backslash.  
text 附加文本，每个嵌入的换行符前面都有一个反斜杠。  
       i \ 我\  
       text   Insert  text, which has each embedded newline preceded by a
              backslash.  
text 插入文本，每个嵌入的换行符前面都有一个反斜杠。  
       q [exit-code]
              Immediately quit the sed script without processing any more
              input,  except  that if auto-print is not disabled the cur‐
              rent pattern space will be printed.  The exit code argument
              is a GNU extension.  
q [exit-code] 立即退出 sed 脚本，不再处理任何输入，但如果未禁用自动打印，则将打印当前模式空间。退出代码参数是 GNU 扩展。  
       Q [exit-code]
              Immediately quit the sed script without processing any more
              input.  This is a GNU extension.  
Q [exit-code] 立即退出 sed 脚本，不再处理任何输入。这是一个 GNU 扩展。  
       r filename
              Append text read from filename.  
r filename 附加从 filename 读取的文本。  
       R filename
              Append a line read from filename.  Each invocation  of  the
              command  reads  a line from the file.  This is a GNU exten‐
              sion.  
R filename 附加从 filename 读取的行。每次调用该命令都会从文件中读取一行。这是一个 GNU 扩展。  
   Commands which accept address ranges
       {      Begin a block of commands (end with a }).  
接受地址范围的命令 { 开始一个命令块（以 } 结尾）。  
       b label
              Branch to label; if label is  omitted,  branch  to  end  of
              script.  
b label 分支到标签;如果省略 label，则分支到脚本末尾。  
       c \  
       text   Replace the selected lines with text, which has each embed‐
              ded newline preceded by a backslash.  
text 将所选行替换为文本，该文本的每个嵌入换行符前面都有一个反斜杠。  
       d      Delete pattern space.  Start next cycle.  
d 删除图案空间。开始下一个周期。  
       D      If pattern space contains no newline, start  a  normal  new
              cycle  as  if  the d command was issued.   
D 如果模式空间不包含换行符，则启动一个正常的新循环，就像发出了 d 命令一样。  
 Otherwise, delete
              text in the pattern space up  to  the  first  newline,  and
              restart  cycle  with  the  resultant pattern space, without
              reading a new line of input.  
否则，删除模式空间中直到第一个换行符的文本，然后使用生成的模式空间重新开始循环，而不读取新的输入行。  
       h H    Copy/append pattern space to hold space.  
h H 复制/附加图案空间以保存空间。  
       g G    Copy/append hold space to pattern space.  
g G 将保留空间复制/追加到图案空间。  
       l      List out the current line  in  a  ``visually  unambiguous''
              form.  
l 以“视觉上明确”的形式列出当前行。  
       l width
              List  out  the  current  line in a ``visually unambiguous''
              form, breaking it at  width  characters.   This  is  a  GNU
              extension.  
l width 以“视觉上明确”的形式列出当前行，将其分解为宽度字符。这是一个 GNU 扩展。  
       n N    Read/append the next line of input into the pattern space.  
n N 将下一行输入读取/附加到模式空间中。  
       p      Print the current pattern space.  
p 打印当前图案空间。  
       P      Print  up to the first embedded newline of the current pat‐
              tern space.  
P 打印到当前 pat‐ tern 空间的第一个嵌入换行符。  
       s/regexp/replacement/
              Attempt to match regexp against the pattern space.   
s/regexp/replacement/ 尝试将正则表达式与模式空间进行匹配。  
 If suc‐
              cessful,  replace  that  portion  matched with replacement.
              The replacement may contain  the  special  character  &  to
              refer  to  that portion of the pattern space which matched,
              and the special escapes \1 through \9 to refer to the  cor‐
              responding matching sub-expressions in the regexp.  
如果成功，请更换匹配的部分。替换可以包含特殊字符 & 来指代模式空间中匹配的那部分，而特殊转义符 \1 到 \9 可以指代正则表达式中响应匹配的子表达式。  
       t label
              If a s/// has done a successful substitution since the last
              input line was read and since the last t or T command, then
              branch  to  label;  if  label  is omitted, branch to end of
              script.  
t label 如果 s/// 自读取上一行输入行以来以及自上一个 t 或 T 命令以来成功进行了替换，则分支到 label;如果省略 label，则分支到脚本末尾。  
       T label
              If no s/// has done a  successful  substitution  since  the
              last input line was read and since the last t or T command,
              then branch to label; if label is omitted, branch to end of
              script.  This is a GNU extension.  
T label 如果自读取上一行输入行以来和上一个 t 或 T 命令以来没有 s/// 成功替换，则分支到标签;如果省略 label，则分支到脚本末尾。这是一个 GNU 扩展。  
       w filename
              Write the current pattern space to filename.  
w filename 将当前模式空间写入 filename。  
       W filename
              Write  the first line of the current pattern space to file‐
              name.  This is a GNU extension.  
W filename 将当前模式空间的第一行写入 file‐ name。这是一个 GNU 扩展。  
       x      Exchange the contents of the hold and pattern spaces.  
x 交换保留空间和模式空间的内容。  
       y/source/dest/
              Transliterate the characters in  the  pattern  space  which
              appear in source to the corresponding character in dest.  
y/source/dest/ 将 source 中出现的模式空间中的字符音译为 dest 中的相应字符。  
Addresses
       Sed  commands  can  be  given with no addresses, in which case the
       command will be executed for all input lines; with one address, in
       which case the command will only be executed for input lines which
       match that address; or with two addresses, in which case the  com‐
       mand  will  be executed for all input lines which match the inclu‐
       sive range of lines starting from the first address and continuing
       to the second address.   
地址 Sed 命令可以不带地址，在这种情况下，将对所有输入行执行该命令;具有一个地址，在这种情况下，该命令将仅对与该地址匹配的输入行执行;或具有两个地址，在这种情况下，将对所有输入行执行 com-mand 与从第一个地址开始并一直到第二个地址的包含行范围匹配。  
 Three things to note about address ranges:
       the syntax is addr1,addr2 (i.e., the addresses are separated by  a
       comma); the line which addr1 matched will always be accepted, even
       if addr2 selects an earlier line; and if addr2  is  a  regexp,  it
       will not be tested against the line that addr1 matched.  
关于地址范围需要注意的三点：语法是 addr1，addr2（即地址用逗号分隔）;即使 addr2 选择了较早的行，addr1 匹配的行也将始终被接受;如果 ADDR2 是正则表达式，则不会针对 ADDR1 匹配的行对其进行测试。  
       After  the address (or address-range), and before the command, a !
       may be inserted, which specifies that the command  shall  only  be
       executed if the address (or address-range) does not match.  
在地址（或地址范围）之后，在命令之前，一个 ！可以插入，它指定仅当地址（或地址范围）不匹配时才执行命令。  
       The following address types are supported:  
支持以下地址类型：  
       number Match  only  the  specified  line  number (which increments
              cumulatively across files, unless the -s option  is  speci‐
              fied on the command line).  
number 仅匹配指定的行号（除非在命令行中指定了 -s 选项，否则该行号在文件之间累积递增）。  
       first~step
              Match  every  step'th  line  starting with line first.   
first~step 匹配每一步的第 1 行，以 line first 开头。  
 For
              example, ``sed -n 1~2p'' will print  all  the  odd-numbered
              lines  in  the input stream, and the address 2~5 will match
              every fifth line, starting with the second.   
例如，''sed -n 1~2p'' 将打印输入流中的所有奇数行，地址 2~5 将每五行匹配一次，从第二行开始。  
 first  can  be
              zero;  in  this  case,  sed operates as if it were equal to
              step.  (This is an extension.)  
first 可以为零;在这种情况下，SED 的运行方式就好像它等于 STEP。（这是一个扩展。  
       $      Match the last line.  
$ 匹配最后一行。  
       /regexp/
              Match lines matching the regular expression regexp.  Match‐
              ing is performed on the current pattern space, which can be
              modified with commands such as ``s///''.  
/regexp/ 匹配与正则表达式正则表达式匹配的行。匹配是在当前模式空间上执行的，可以使用诸如 ''s///'' 之类的命令进行修改。  
       \cregexpc
              Match lines matching the regular expression regexp.  The  c
              may be any character.  
\cregexpc 匹配与正则表达式正则表达式匹配的行。c 可以是任何字符。  
       GNU sed also supports some special 2-address forms:  
GNU sed 还支持一些特殊的 2 地址形式：  
       0,addr2
              Start  out in "matched first address" state, until addr2 is
              found.   
0，addr2 以“匹配的第一个地址”状态开始，直到找到 addr2。  
 This is similar to 1,addr2, except  that  if  addr2
              matches  the very first line of input the 0,addr2 form will
              be at the end of its range, whereas the 1,addr2  form  will
              still  be  at  the beginning of its range.   
这类似于 1，addr2，不同之处在于，如果 addr2 与输入的第一行匹配，则 0，addr2 形式将位于其范围的末尾，而 1，addr2 形式仍将位于其范围的开头。  
 This works only
              when addr2 is a regular expression.  
仅当 addr2 是正则表达式时，这才有效。  
       addr1,+N
              Will match addr1 and the N lines following addr1.  
addr1，+N 将匹配 addr1 和 addr1 后面的 N 行。  
       addr1,~N
              Will match addr1 and the lines following  addr1  until  the
              next line whose input line number is a multiple of N.  
addr1，~N 将匹配 addr1 和 addr1 后面的行，直到输入行号是 N 的倍数的下一行。  
REGULAR EXPRESSIONS
       POSIX.2  BREs  should  be  supported,  but  they aren't completely
       because of performance problems.  The \n  sequence  in  a  regular
       expression  matches  the  newline character, and similarly for \a,
       \t, and other sequences.   
正则表达式 POSIX.2 BRE 应该得到支持，但它们并不完全是因为性能问题。正则表达式中的 \n 序列与换行符匹配，\a、\t 和其他序列也是如此。  
 The -E option switches to using extended
       regular  expressions instead; the -E option has been supported for
       years by GNU sed, and is now included in POSIX.  
-E 选项改用扩展正则表达式;GNU sed 多年来一直支持 -E 选项，现在包含在 POSIX 中。  
BUGS
       E-mail bug reports to bug-sed@gnu.org.  Also, please  include  the
       output  of  ``sed --version'' in the body of your report if at all
       possible.  
BUGS 通过电子邮件将错误报告发送给 bug-sed@gnu.org。此外，如果可能，请在报告正文中包含“sed --version”的输出。  
AUTHOR
       Written by Jay Fenlason, Tom Lord, Ken Pizzini, and Paolo Bonzini.
       GNU  sed  home page: <https://www.gnu.org/software/sed/>.  General
       help using GNU software:  <https://www.gnu.org/gethelp/>.   E-mail
       bug reports to: <bug-sed@gnu.org>.  
作者 由 Jay Fenlason、Tom Lord、Ken Pizzini 和 Paolo Bonzini 撰写。GNU sed 主页： .使用 GNU 软件的一般帮助：。将错误报告通过电子邮件发送至：。  
COPYRIGHT
       Copyright  ©  2018 Free Software Foundation, Inc.   
版权所有 版权所有 © 2018 Free Software Foundation， Inc.  
 License GPLv3+:
       GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
       This is free software: you are free to change and redistribute it.
       There is NO WARRANTY, to the extent permitted by law.  
许可证 GPLv3+：GNU GPL 版本 3 或更高版本。这是免费软件：您可以自由更改和重新分发它。在法律允许的范围内，没有保证。  
SEE ALSO
       awk(1), ed(1), grep(1), tr(1), perlre(1), sed.info, any of various
       books on sed, the sed FAQ (http://sed.sf.net/grabbag/tutori‐
       als/sedfaq.txt), http://sed.sf.net/grabbag/.  
另见 awk（1）、ed（1）、grep（1）、tr（1）、perlre（1）、sed.info、任何关于 sed 的书籍、sed FAQ （http://sed.sf.net/grabbag/tutori‐ als/sedfaq.txt）、http://sed.sf.net/grabbag/。  
       The full documentation for sed is maintained as a Texinfo manual.
       If the info and sed programs are properly installed at your site,
       the command  
sed 的完整文档以 Texinfo 手册的形式进行维护。如果 info 和 sed 程序已正确安装在您的站点上，则命令  
              info sed 信息 sed  
       should give you access to the complete manual.  
应该可以让您访问完整的手册。  
sed 4.5                         March 2018                         SED(1)
  
sed 4.5 三月 2018 SED（1）

# 2. sed

功能强大的流式文本编辑器

## 2.1. [](http://bash.lutixia.cn/c/sed.html#%E8%A1%A5%E5%85%85%E8%AF%B4%E6%98%8E)补充说明

**sed** 是一种流编辑器，它是文本处理中非常重要的工具，能够完美的配合正则表达式使用，功能不同凡响。处理时，把当前处理的行存储在临时缓冲区中，称为“模式空间”（pattern space），接着用sed命令处理缓冲区中的内容，处理完成后，把缓冲区的内容送往屏幕。接着处理下一行，这样不断重复，直到文件末尾。文件内容并没有 改变，除非你使用重定向存储输出。Sed主要用来自动编辑一个或多个文件；简化对文件的反复操作；编写转换程序等。

## 2.2. [](http://bash.lutixia.cn/c/sed.html#sed%E7%9A%84%E9%80%89%E9%A1%B9%E5%91%BD%E4%BB%A4%E6%9B%BF%E6%8D%A2%E6%A0%87%E8%AE%B0)sed的选项、命令、替换标记

**命令格式**

```shell
sed [options] 'command' file(s)
sed [options] -f scriptfile file(s)
```

### 2.2.1. [](http://bash.lutixia.cn/c/sed.html#%E9%80%89%E9%A1%B9)选项

```shell
-e<script>或--expression=<script>：以选项中的指定的script来处理输入的文本文件；
-f<script文件>或--file=<script文件>：以选项中指定的script文件来处理输入的文本文件；
-h或--help：显示帮助；
-n或--quiet或——silent：仅显示script处理后的结果；
-V或--version：显示版本信息。
```

### 2.2.2. [](http://bash.lutixia.cn/c/sed.html#%E5%8F%82%E6%95%B0)参数

文件：指定待处理的文本文件列表。

### 2.2.3. [](http://bash.lutixia.cn/c/sed.html#sed%E5%91%BD%E4%BB%A4)sed命令

```shell
a\ # 在当前行下面插入文本。
i\ # 在当前行上面插入文本。
c\ # 把选定的行改为新的文本。
d # 删除，删除选择的行。
D # 删除模板块的第一行。
s # 替换指定字符
h # 拷贝模板块的内容到内存中的缓冲区。
H # 追加模板块的内容到内存中的缓冲区。
g # 获得内存缓冲区的内容，并替代当前模板块中的文本。
G # 获得内存缓冲区的内容，并追加到当前模板块文本的后面。
l # 列表不能打印字符的清单。
n # 读取下一个输入行，用下一个命令处理新的行而不是用第一个命令。
N # 追加下一个输入行到模板块后面并在二者间嵌入一个新行，改变当前行号码。
p # 打印模板块的行。
P # (大写) 打印模板块的第一行。
q # 退出Sed。
b lable # 分支到脚本中带有标记的地方，如果分支不存在则分支到脚本的末尾。
r file # 从file中读行。
t label # if分支，从最后一行开始，条件一旦满足或者T，t命令，将导致分支到带有标号的命令处，或者到脚本的末尾。
T label # 错误分支，从最后一行开始，一旦发生错误或者T，t命令，将导致分支到带有标号的命令处，或者到脚本的末尾。
w file # 写并追加模板块到file末尾。  
W file # 写并追加模板块的第一行到file末尾。  
! # 表示后面的命令对所有没有被选定的行发生作用。  
= # 打印当前行号码。  
# # 把注释扩展到下一个换行符以前。  
```

### 2.2.4. [](http://bash.lutixia.cn/c/sed.html#sed%E6%9B%BF%E6%8D%A2%E6%A0%87%E8%AE%B0)sed替换标记

```shell
g # 表示行内全面替换。  
p # 表示打印行。  
w # 表示把行写入一个文件。  
x # 表示互换模板块中的文本和缓冲区中的文本。  
y # 表示把一个字符翻译为另外的字符（但是不用于正则表达式）
\1 # 子串匹配标记
& # 已匹配字符串标记
```

### 2.2.5. [](http://bash.lutixia.cn/c/sed.html#sed%E5%85%83%E5%AD%97%E7%AC%A6%E9%9B%86)sed元字符集

```shell
^ # 匹配行开始，如：/^sed/匹配所有以sed开头的行。
$ # 匹配行结束，如：/sed$/匹配所有以sed结尾的行。
. # 匹配一个非换行符的任意字符，如：/s.d/匹配s后接一个任意字符，最后是d。
* # 匹配0个或多个字符，如：/*sed/匹配所有模板是一个或多个空格后紧跟sed的行。
[] # 匹配一个指定范围内的字符，如/[sS]ed/匹配sed和Sed。  
[^] # 匹配一个不在指定范围内的字符，如：/[^A-RT-Z]ed/匹配不包含A-R和T-Z的一个字母开头，紧跟ed的行。
\(..\) # 匹配子串，保存匹配的字符，如s/\(love\)able/\1rs，loveable被替换成lovers。
& # 保存搜索字符用来替换其他字符，如s/love/ **&** /，love这成 **love** 。
\< # 匹配单词的开始，如:/\<love/匹配包含以love开头的单词的行。
\> # 匹配单词的结束，如/love\>/匹配包含以love结尾的单词的行。
x\{m\} # 重复字符x，m次，如：/0\{5\}/匹配包含5个0的行。
x\{m,\} # 重复字符x，至少m次，如：/0\{5,\}/匹配至少有5个0的行。
x\{m,n\} # 重复字符x，至少m次，不多于n次，如：/0\{5,10\}/匹配5~10个0的行。  
```

## 2.3. [](http://bash.lutixia.cn/c/sed.html#sed%E7%94%A8%E6%B3%95%E5%AE%9E%E4%BE%8B)sed用法实例

### 2.3.1. [](http://bash.lutixia.cn/c/sed.html#%E6%9B%BF%E6%8D%A2%E6%93%8D%E4%BD%9Cs%E5%91%BD%E4%BB%A4)替换操作：s命令

替换文本中的字符串：

```shell
sed 's/book/books/' file
```

**-n选项** 和 **p命令** 一起使用表示只打印那些发生替换的行：

sed -n 's/test/TEST/p' file

直接编辑文件 **选项-i** ，会匹配file文件中每一行的所有book替换为books：

```shell
sed -i 's/book/books/g' file
```

### 2.3.2. [](http://bash.lutixia.cn/c/sed.html#%E5%85%A8%E9%9D%A2%E6%9B%BF%E6%8D%A2%E6%A0%87%E8%AE%B0g)全面替换标记g

使用后缀 /g 标记会替换每一行中的所有匹配：

```shell
sed 's/book/books/g' file
```

当需要从第N处匹配开始替换时，可以使用 /Ng：

```shell
echo sksksksksksk | sed 's/sk/SK/2g'
skSKSKSKSKSK

echo sksksksksksk | sed 's/sk/SK/3g'
skskSKSKSKSK

echo sksksksksksk | sed 's/sk/SK/4g'
skskskSKSKSK
```

### 2.3.3. [](http://bash.lutixia.cn/c/sed.html#%E5%AE%9A%E7%95%8C%E7%AC%A6)定界符

以上命令中字符 / 在sed中作为定界符使用，也可以使用任意的定界符：

```shell
sed 's:test:TEXT:g'
sed 's|test|TEXT|g'
```

定界符出现在样式内部时，需要进行转义：

```shell
sed 's/\/bin/\/usr\/local\/bin/g'
```

### 2.3.4. [](http://bash.lutixia.cn/c/sed.html#%E5%88%A0%E9%99%A4%E6%93%8D%E4%BD%9Cd%E5%91%BD%E4%BB%A4)删除操作：d命令

删除空白行：

```shell
sed '/^$/d' file
```

删除文件的第2行：

```shell
sed '2d' file
```

删除文件的第2行到末尾所有行：

```shell
sed '2,$d' file
```

删除文件最后一行：

```shell
sed '$d' file
```

删除文件中所有开头是test的行：

```shell
sed '/^test/'d file
```

### 2.3.5. [](http://bash.lutixia.cn/c/sed.html#%E5%B7%B2%E5%8C%B9%E9%85%8D%E5%AD%97%E7%AC%A6%E4%B8%B2%E6%A0%87%E8%AE%B0)已匹配字符串标记&

正则表达式 \w+ 匹配每一个单词，使用 [&] 替换它，& 对应于之前所匹配到的单词：

```shell
echo this is a test line | sed 's/\w\+/[&]/g'
[this] [is] [a] [test] [line]
```

所有以192.168.0.1开头的行都会被替换成它自已加localhost：

```shell
sed 's/^192.168.0.1/&localhost/' file
192.168.0.1localhost
```

### 2.3.6. [](http://bash.lutixia.cn/c/sed.html#%E5%AD%90%E4%B8%B2%E5%8C%B9%E9%85%8D%E6%A0%87%E8%AE%B01)子串匹配标记\1

匹配给定样式的其中一部分：

```shell
echo this is digit 7 in a number | sed 's/digit \([0-9]\)/\1/'
this is 7 in a number
```

命令中 digit 7，被替换成了 7。样式匹配到的子串是 7，(..) 用于匹配子串，对于匹配到的第一个子串就标记为 **\1** ，依此类推匹配到的第二个结果就是 **\2** ，例如：

```shell
echo aaa BBB | sed 's/\([a-z]\+\) \([A-Z]\+\)/\2 \1/'
BBB aaa
```

love被标记为1，所有loveable会被替换成lovers，并打印出来：

```shell
sed -n 's/\(love\)able/\1rs/p' file
```

通过替换获取ip：

```shell
ifconfig ens32 | sed -n '/inet /p' | sed 's/inet \([0-9.]\+\).*/\1/'
192.168.75.126
```

### 2.3.7. [](http://bash.lutixia.cn/c/sed.html#%E5%A4%A7%E5%B0%8F%E5%86%99%E8%BD%AC%E6%8D%A2ul)大小写转换U/L

```shell
\u：	首字母转换为大写
\U：  全部转换为大写
\l：	 首字母转换为小写
\L：	 全部转换为小写
```

首字母转换为大写：

```shell
[root@node6 ~]# sed 's/^[a-z]\+/\u&/' passwd 
Root:x:0:0:root:/root:/bin/bash
Bin:x:1:1:bin:/bin:/sbin/nologin
Daemon:x:2:2:daemon:/sbin:/sbin/nologin
Adm:x:3:4:adm:/var/adm:/sbin/nologin
Lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
Sync:x:5:0:sync:/sbin:/bin/sync
```

匹配到的字符全部转换为大写：

```shell
[root@node6 ~]# sed 's/^[a-z]\+/\U&/' passwd 
ROOT:x:0:0:root:/root:/bin/bash
BIN:x:1:1:bin:/bin:/sbin/nologin
```

### 2.3.8. [](http://bash.lutixia.cn/c/sed.html#%E7%BB%84%E5%90%88%E5%A4%9A%E4%B8%AA%E8%A1%A8%E8%BE%BE%E5%BC%8F)组合多个表达式

```shell
sed '表达式' | sed '表达式'

等价于：

sed '表达式; 表达式'
```

### 2.3.9. [](http://bash.lutixia.cn/c/sed.html#%E5%BC%95%E7%94%A8)引用

sed表达式可以使用单引号来引用，但是如果表达式内部包含变量字符串，就需要使用双引号。

```shell
test=hello
echo hello WORLD | sed "s/$test/HELLO"
HELLO WORLD
```

### 2.3.10. [](http://bash.lutixia.cn/c/sed.html#%E9%80%89%E5%AE%9A%E8%A1%8C%E7%9A%84%E8%8C%83%E5%9B%B4%E9%80%97%E5%8F%B7)选定行的范围：,（逗号）

所有在模板test和check所确定的范围内的行都被打印：

```shell
sed -n '/test/,/check/p' file
```

打印从第5行开始到第一个包含以test开始的行之间的所有行：

```shell
sed -n '5,/^test/p' file
```

对于模板test和west之间的行，每行的末尾用字符串aaa bbb替换：

```shell
sed '/test/,/west/s/$/aaa bbb/' file
```

### 2.3.11. [](http://bash.lutixia.cn/c/sed.html#%E5%A4%9A%E7%82%B9%E7%BC%96%E8%BE%91e%E5%91%BD%E4%BB%A4)多点编辑：e命令

-e选项允许在同一行里执行多条命令：

```shell
sed -e '1,5d' -e 's/test/check/' file
```

上面sed表达式的第一条命令删除1至5行，第二条命令用check替换test。命令的执行顺序对结果有影响。如果两个命令都是替换命令，那么第一个替换命令将影响第二个替换命令的结果。

和 -e 等价的命令是 --expression：

```shell
sed --expression='s/test/check/' --expression='/love/d' file
```

### 2.3.12. [](http://bash.lutixia.cn/c/sed.html#%E4%BB%8E%E6%96%87%E4%BB%B6%E8%AF%BB%E5%85%A5r%E5%91%BD%E4%BB%A4)从文件读入：r命令

file里的内容被读进来，显示在与test匹配的行后面，如果匹配多行，则file的内容将显示在所有匹配行的下面：

```shell
sed '/test/r file' filename
```

### 2.3.13. [](http://bash.lutixia.cn/c/sed.html#%E5%86%99%E5%85%A5%E6%96%87%E4%BB%B6w%E5%91%BD%E4%BB%A4-)写入文件：w命令  

在example中所有包含test的行都被写入file里：

```shell
sed -n '/test/w file' example
```

### 2.3.14. [](http://bash.lutixia.cn/c/sed.html#%E8%BF%BD%E5%8A%A0%E8%A1%8C%E4%B8%8Ba%E5%91%BD%E4%BB%A4)追加（行下）：a\命令

将 this is a test line 追加到 以test 开头的行后面：

```shell
sed '/^test/a\this is a test line' file
```

在 test.conf 文件第2行之后插入 this is a test line：

```shell
sed -i '2a\this is a test line' test.conf
```

### 2.3.15. [](http://bash.lutixia.cn/c/sed.html#%E6%8F%92%E5%85%A5%E8%A1%8C%E4%B8%8Ai%E5%91%BD%E4%BB%A4)插入（行上）：i\命令

将 this is a test line 追加到以test开头的行前面：

```shell
sed '/^test/i\this is a test line' file
```

在test.conf文件第5行之前插入this is a test line：

```shell
sed -i '5i\this is a test line' test.conf
```

### 2.3.16. [](http://bash.lutixia.cn/c/sed.html#%E6%9B%BF%E6%8D%A2%E6%8C%87%E5%AE%9A%E8%A1%8Cc%E5%91%BD%E4%BB%A4)替换指定行：c\命令

把root开头的行替换新内容：

```shell
[root@node6 ~]# sed '/^root/c this is new line!' passwd 
this is new line!
bin:x:1:1:bin:/bin:/sbin/nologin
```

如果是指定范围替换，需要注意，sed不是每行进行替换，而是把整个范围作为整体替换：

```shell
[root@node6 ~]# nl passwd | sed '1,5c\   this is dangerous!'
     this is dangerous!
     6	sync:x:5:0:sync:/sbin:/bin/sync
     7	shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
```

如果想实现对第一行到第五行统一替换为相同内容，可以用下面的命令实现：

```shell
[root@node5 ~]# sed '1{:a;s/.*/lutxixia/;n;6!ba}' passwd 
lutxixia
lutxixia
lutxixia
lutxixia
lutxixia
sync:x:5:0:sync:/sbin:/bin/sync

其中：
:a  	是设置一个循环标签
s/.*/lutixia/	是用lutixia字符替换匹配到的每行内容
n	是读取下一行
6!	是读到第六行退出循环，终止操作,如果没有，则继续循环。
ba	是如果没有到第六行就跳转到a继续循环
```

### 2.3.17. [](http://bash.lutixia.cn/c/sed.html#%E4%B8%8B%E4%B8%80%E4%B8%AAn%E5%91%BD%E4%BB%A4)下一个：n命令

如果test被匹配，则移动到匹配行的下一行，替换这一行的aa，变为bb，并打印该行，然后继续：

```shell
sed '/test/{ n; s/aa/bb/; }' file
```

### 2.3.18. [](http://bash.lutixia.cn/c/sed.html#%E5%8F%98%E5%BD%A2y%E5%91%BD%E4%BB%A4)变形：y命令

把1~10行内所有abcde转变为大写，注意，正则表达式元字符不能使用这个命令：

```shell
sed '1,10y/abcde/ABCDE/' file
```

### 2.3.19. [](http://bash.lutixia.cn/c/sed.html#%E9%80%80%E5%87%BAq%E5%91%BD%E4%BB%A4)退出：q命令

打印完前10行后，退出sed:

```shell
sed '10q' file
```

直到找到第一个匹配项，退出sed：

```shell
[root@node4 ~]# sed  '/nginx/q' nginx.yml 
---
- hosts: nginx
```

### 2.3.20. [](http://bash.lutixia.cn/c/sed.html#%E4%BF%9D%E6%8C%81%E5%92%8C%E8%8E%B7%E5%8F%96h%E5%91%BD%E4%BB%A4%E5%92%8Cg%E5%91%BD%E4%BB%A4)保持和获取：h命令和G命令

在sed处理文件的时候，每一行都被保存在一个叫模式空间的临时缓冲区中，除非行被删除或者输出被取消，否则所有被处理的行都将 打印在屏幕上。接着模式空间被清空，并存入新的一行等待处理。

```shell
sed -e '/test/h' -e '$G' file
```

在这个例子里，匹配test的行被找到后，将存入模式空间，h命令将其复制并存入一个称为保持缓存区的特殊缓冲区内。第二条语句的意思是，当到达最后一行后，G命令取出保持缓冲区的行，然后把它放回模式空间中，且追加到现在已经存在于模式空间中的行的末尾。在这个例子中就是追加到最后一行。简单来说，任何包含test的行都被复制并追加到该文件的末尾。

### 2.3.21. [](http://bash.lutixia.cn/c/sed.html#%E4%BF%9D%E6%8C%81%E5%92%8C%E4%BA%92%E6%8D%A2h%E5%91%BD%E4%BB%A4%E5%92%8Cx%E5%91%BD%E4%BB%A4)保持和互换：h命令和x命令

互换模式空间和保持缓冲区的内容。也就是把包含test与check的行互换：

```shell
sed -e '/test/h' -e '/check/x' file
```

### 2.3.22. [](http://bash.lutixia.cn/c/sed.html#%E8%84%9A%E6%9C%ACscriptfile)脚本scriptfile

sed脚本是一个sed的命令清单，启动Sed时以-f选项引导脚本文件名。Sed对于脚本中输入的命令非常挑剔，在命令的末尾不能有任何空白或文本，如果在一行中有多个命令，要用分号分隔。以#开头的行为注释行，且不能跨行。

```shell
sed [options] -f scriptfile file(s)
```

### 2.3.23. [](http://bash.lutixia.cn/c/sed.html#%E6%89%93%E5%8D%B0%E5%A5%87%E6%95%B0%E8%A1%8C%E6%88%96%E5%81%B6%E6%95%B0%E8%A1%8C)打印奇数行或偶数行

方法1：

```shell
sed -n 'p;n' test.txt  #奇数行
sed -n 'n;p' test.txt  #偶数行
```

方法2：

```shell
sed -n '1~2p' test.txt  #奇数行
sed -n '2~2p' test.txt  #偶数行
```

### 2.3.24. [](http://bash.lutixia.cn/c/sed.html#%E6%89%93%E5%8D%B0%E5%8C%B9%E9%85%8D%E5%AD%97%E7%AC%A6%E4%B8%B2%E7%9A%84%E4%B8%8B%E4%B8%80%E8%A1%8C)打印匹配字符串的下一行

```shell
grep -A 1 SCC URFILE
sed -n '/SCC/{n;p}' URFILE
awk '/SCC/{getline; print}' URFILE
```
# 3. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
