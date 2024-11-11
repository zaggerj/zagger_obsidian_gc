---
tags:
  - 工作/spice/spice问题
created: 2023-11-03T22:29
updated: 2023-11-13T16:48
---
结论： 通过编写测试脚本，反复连接spice和断开spice，主通道，加密字符串254，转字节后127长度，送达发消息长度为131字节时，只有主通道连接着在，其他通道没有继续连接，导致spice白屏，通过将加码字符串254前补两个0的方式，spice可以继续连接，正常使用。测试脚本，反复断开和连接，并且打印是主通道254是，就进行补2个0。
[BUG #48968 【5.5.1GPU补丁测试】【用户门户/我的桌面】【出现1次】用户门户连接A10显卡的服务桌面，对应跳转的界面白屏 - 桌面云融合架构 - 禅道](http://172.16.203.12/zentao/bug-view-48968.html)

![[Pasted image 20230808170123.png]]

消息：
1. 38b => UkVEUQIAAAACAAAAFgAAAAAAAAABAAEAAAAAAAAAEgAAAAkAAAA=
2. 202b <== UkVEUQIAAAACAAAAugAAAAAAAAAwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAKfXRMs4CEQEYSc81T4IUUs08h1iUvoFTQDLaTI3OY7TnlIQefsTzqW0FDTlfCMdegUhfLYlnX51nG/5nBrck3fCX5xKZYwykVXzrGlhMpdLtqWVXn5ylStfRq1q335GGsoFoLNiZibP+FgvmoISYmHKn0XZrYtuAJMhbK8frpl1AgMBAAEBAAAAAQAAALIAAAALAAAACQAAAA==
3. 131b => AQAAAHotZeRDXPBjvBlmMiUUg2f9eYMWqIClac9cehTqmwvGuwbk3vzwfDl5FD3yCou0GDz84wrc1ZiJheudRRzv3CWUsisBpQhlI0LhGgM4tecyVoTGDRGJ19BH/JdxsJxYVJ6xWnT6occxdR6uJRffZUqcIxbC0VX0adU86i1GBHg=
4. 正常的是132b
5. AQAAAEIdyjV5Sdg3lgIlPzcgCsDwcenJEoO7U1iLZloL76DdakG3BeH/iDQopJCkpzC4RmYxXxmiWUIlHD2pTZO0RfWpHsTHJNKufVqos80zKUIBW/WeI80iWTBs4BypHFyv7dnxW8AX04KjwA0qHnTWSHw+mBFAm2PYoKhEtWLGnLT5
6. devtool 控制台日志：![[localhost-1691481363364.log]]
7. ![[Pasted image 20230808171015.png]]
8. ![[Pasted image 20230810093457.png]]
9. ![[R`5VUGBPS4GQURE7W8_5$GJ.png]]