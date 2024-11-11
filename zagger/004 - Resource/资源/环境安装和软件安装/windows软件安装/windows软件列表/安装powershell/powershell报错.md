---
tags: 资源/环境配置
created: 2023-11-06T08:20
updated: 2023-11-14T09:22
---
设置环境变量时报错
```pwsh 

[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL',$env:SCOOP_GLOBAL, 'Machine')

```


- 报错
```
MethodInvocationException: Exception calling "SetEnvironmentVariable" with "3" argument(s): "Requested registry access is not allowed."
```

- 暂且先设置为user
```
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL',$env:SCOOP_GLOBAL, 'User')

```