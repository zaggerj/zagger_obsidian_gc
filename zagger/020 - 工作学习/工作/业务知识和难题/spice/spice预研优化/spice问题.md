---
tags:
  - 工作/spice/spice预研优化
created: 2023-11-03T22:29
updated: 2023-11-13T16:47
---
# 1. 问题集锦
1. spice和idp状态监听
# 2. 思路整理
1. 存在spice还没有连成功时，idp就断开了
2. 如何准确掌握当前处于什么进程中？
	1. spice连接中
	2. spice断开中
	3. ipd连接中
	4. idp断开中
3. spice重连代码比较冗余，需要优化
4. 一次idp的连接过程：
	1. oeidp.start()
	2. connected多次
	3. ready多次
	4. endsession一次
	5. destroy一次
5. 一次spice连接过程
	1. connected多次
	2. ready一次
	3. disconnected