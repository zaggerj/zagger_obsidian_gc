---
tags: 工作/业务问题
created: 2023-11-03T22:29
updated: 2023-11-13T19:27
---
# js随机生成mac地址

　　function randomMac() {

　　const mac = \[

　　(0x52).toString(16),

　　(0x54).toString(16),

　　(0x00).toString(16),

　　Math.floor((Math.random() \* 0xff)).toString(16),

　　Math.floor((Math.random() \* 0xff)).toString(16),

　　Math.floor((Math.random() \* 0xff)).toString(16)

　　\]

　　return mac.join(':')

　　}
