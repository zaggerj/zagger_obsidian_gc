---
created: 2023-11-06T08:20
updated: 2023-11-06T08:20
---
# visibilitychange

　　visibilitychange事件是在用户离开或返回当前页面时触发的事件，即当浏览器当前页面的可见性状态发生变化时会触发。

　　当用户将当前标签页或窗口最小化、切换到其他标签页或窗口、或将浏览器最小化时，页面的可见性状态会从"visible"（可见）变为"hidden"（隐藏），此时会触发visibilitychange事件。相反地，当用户切换回当前标签页或窗口，或将浏览器恢复大小时，页面的可见性状态会从"hidden"变为"visible"，此时也会触发visibilitychange事件。

　　您可以通过监听visibilitychange事件来处理用户离开或返回页面时需要执行的操作，例如暂停或恢复视频、音频播放，或者在用户离开页面时保存数据，以确保数据不会丢失。
