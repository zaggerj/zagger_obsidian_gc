---
tags: 资源/环境配置
created: 2023-11-06T08:20
updated: 2023-11-14T09:22
---
# tmux

　　[一文了解终端神器tmux - sureZ_ok - 博客园 (cnblogs.com)](https://www.cnblogs.com/sureZ-learning/p/16754905.html)

　　[最好用的笔记软件！双链块引、本地优先、开源免费！ - 哔哩哔哩 (bilibili.com)](https://www.bilibili.com/read/cv22800631)

　　[思源笔记docker搭建及后续使用优化（小白向） - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/427328444?utm_id=0)

　　[(53条消息) Tmux教程 （一文就够）_CSSDCC的博客-CSDN博客](https://blog.csdn.net/CSSDCC/article/details/121231906)

　　[tmux教程 - 简书 (jianshu.com)](https://www.jianshu.com/p/6075c0fd98d9)

　　[Tmux 速成教程：技巧和调整 - 木子三金 - 博客园 (cnblogs.com)](https://www.cnblogs.com/maoxiaolv/p/5526602.html)

　　[Tmux 使用教程 - 阮一峰的网络日志 (ruanyifeng.com)](http://www.ruanyifeng.com/blog/2019/10/tmux.html)

　　[一款超牛逼的 Linux 终端复用神器（附安装、使用教程） (baidu.com)](https://baijiahao.baidu.com/s?id=1683707857909025401&wfr=spider&for=pc)

　　[Tmux 实用教程 (ppmy.cn)](https://www.ppmy.cn/news/70722.html?action=onClick)

　　‍

# 会话任务

```bash
ctrl+b d：window 和 session 解绑
Ctrl+b s：列出所有会话
Ctrl+b $：重命名当前会话
ctrl+d： 杀掉当前session
```

　　‍

# 窗格：

```bash
Ctrl+b %：划分左右两个窗格。
Ctrl+b "：划分上下两个窗格。
Ctrl+b <arrow key>：光标切换到其他窗格。<arrow key>是指向要切换到的窗格的方向键，比如切换到下方窗格，就按方向键↓。
Ctrl+b ;：光标切换到上一个窗格。
Ctrl+b o：光标切换到下一个窗格。
Ctrl+b {：当前窗格与上一个窗格交换位置。
Ctrl+b }：当前窗格与下一个窗格交换位置。
Ctrl+b Ctrl+o：所有窗格向前移动一个位置，第一个窗格变成最后一个窗格。
Ctrl+b Alt+o：所有窗格向后移动一个位置，最后一个窗格变成第一个窗格。
Ctrl+b x：关闭当前窗格。
Ctrl+b !：将当前窗格拆分为一个独立窗口。
Ctrl+b z：当前窗格全屏显示，再使用一次会变回原来大小。
Ctrl+b Ctrl+<arrow key>：按箭头方向调整窗格大小。
Ctrl+b q：显示窗格编号。
```

# 窗口：

```bash
Ctrl+b c：创建一个新窗口，状态栏会显示多个窗口的信息。
Ctrl+b p：切换到上一个窗口（按照状态栏上的顺序）。
Ctrl+b n：切换到下一个窗口。
Ctrl+b <number>：切换到指定编号的窗口，其中的<number>是状态栏上的窗口编号。
Ctrl+b w：从列表中选择窗口。
Ctrl+b ,：窗口重命名。
exit 或 ctrl+b & 终止窗口
```

　　‍
