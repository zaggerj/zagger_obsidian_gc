---
tags:
  - 工作/spice/spice问题
created: 2023-11-03T22:29
updated: 2023-11-13T16:49
---
1.常见日志路径

  代理：/var/log/html5proxy/spice.log

  虚拟机：/var/log/libvirt/qemu/<domain-name>.log

2. 如何开启某个虚拟机的详细日志？

  编辑 /etc/nova/nova.conf

  找到 [libvirt]

  修改(添加红色字体部分) qemu_env = RATE=25,SPICE_DEBUG_LEVEL=5

3. 鼠标移动不跟手，像在漂移一样？

  服务器鼠标模式会导致此问题

4. 分辨率没有自适应？

  没有安装 guesttools, 或者服务器配置了 vgpu

5. 通道断开连接了

  客户端在处理每一个服务器消息时，只要报错就会导致全部通道关闭

  客户端主动关闭连接时，会发送 SPICE_MSGC_DISCONNECTING 消息

  客户端连接可能是被动关闭，关闭源可能来自 nginx, 代理，服务器，此时错误码：1005/1006
  
6. spice 代码有点看不懂？

  很正常，多看两遍，还是不懂的话了解一下协议内容

7. 命名代码都是按协议来的，为什么还是有问题？

  有没有可能这不是你的问题

  协议也不是全能的，能覆盖每一个细节，如果你恰好进入了协议死角，和后端 battle 就行