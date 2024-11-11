---
tags:
  - 工作/spice/spice预研优化
created: 2023-11-03T22:29
updated: 2023-11-13T16:47
---
# 1. spice画面质量参数h264

```bash
// 老的h264
 // 通过此参数控制 h264 的开启/关闭
 // h264: true, // 使用默认参数
// h264: {bitRate: 25, frameRate: 25}, // 自定义参数
 // h264: false // 关闭 h264
```

```bash
// 8个月前的新的h264参数
18: {
        vmbr: 16000,
        maxCrf: 30,
        ssrate: -1
},
24: {
        vmbr: 8000,
        maxCrf: 30,
        ssrate: -1
 },
36: {
        vmbr: 4000,
        maxCrf: 36,
        ssrate: -1
 },
```

```bash
// tspace后端根据设置算的spice的参数
bitRate = h264Params['264br']
ssrate = h264Params.ssrate
vmbr = h264Params.vmbr
maxCrf = h264Params.mc
```

```bash

 if (bitRate === 36) { bitRate = 30 }
```

　　‍
