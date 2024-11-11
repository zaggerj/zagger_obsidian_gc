---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
# remote-desktop.spice.js

1. init方法，会加载script，在加载后，返回defer对象，并在defer对象promise时，调用`bootstrapSpice`​方法
2. 或者监听start方法，触发start方法时，进行`bootstrapSpice`​方法的调用，这个过程称之为init过程
3. ​`bootstrapSpice`​的过程中，会`oevdi.run(config)`​启动spice连接，并且开始连接检测idp服务
4. ‍
