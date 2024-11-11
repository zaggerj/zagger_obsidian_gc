---
tags: 资源/软件安装
created: 2023-11-03T22:29
updated: 2023-11-14T09:21
---
## 参考文档
1. [常规 General | Clash for Windows (lbyczf.com)](https://docs.cfw.lbyczf.com/contents/ui/general.html#%E9%80%89%E9%A1%B9%E8%AF%B4%E6%98%8E)
2. ![[1697423248385 1.yml]]
```shell
export https_proxy=http://127.0.0.1:7890;export http_proxy=http://127.0.0.1:7890;export all_proxy=socks5://127.0.0.1:7890
```

```yaml
- name: '反限速'
  type: socks5
  server: 127.0.0.1
  port: 7899

# 规则
rules:
# CUSTOM
- DOMAIN-KEYWORD,microsoft.com,反限速
- DOMAIN-KEYWORD,windowsupdate.com,反限速
- DOMAIN-KEYWORD,163,反限速
- DOMAIN-KEYWORD,126.net,反限速
- DOMAIN-KEYWORD,bili,反限速
- DOMAIN-KEYWORD,gist,Proxy
#- DOMAIN-KEYWORD,github,反限速
- DOMAIN-KEYWORD,live,反限速
- DOMAIN-SUFFIX,msn.cn,反限速
- DOMAIN-KEYWORD,microsoft,反限速
- DOMAIN-KEYWORD,azureedge,反限速
- DOMAIN-KEYWORD,tencent,反限速
```

```yaml
# HTTP 代理端口
port: 7890

# SOCKS5 代理端口
socks-port: 7891

# 允许局域网的连接（可用来共享代理）
allow-lan: true

# 规则模式：Rule（规则） / Global（全局代理）/ Direct（全局直连）
mode: Rule

# 设置日志输出级别 (默认级别：info，级别越高日志输出量越大，越倾向于调试)
# 四个级别：silent / info / warning / error / debug
log-level: info

# Clash 的 RESTful API
external-controller: 127.0.0.1:9090

# DNS 设置
dns:
  enable: false # set true to enable dns (default is false)

# Clash for Windows
# Proxies module latency test settings
cfw-latency-timeout: 3000
cfw-latency-url: http://www.gstatic.com/generate_204

# 代理节点
proxies:
- name: 当前网址：agentneo.tech
  type: trojan
  server: 831d4036-f.andns.co
  port: 10042
  password: F3nYyKZ9
  udp: true
  sni: 831d4036-f.andns.co
  skip-cert-verify: false
- name: x1.0 香港 - 中转1
  type: trojan
  server: 831d4036-f.andns.co
  port: 10042
  password: F3nYyKZ9
  udp: true
  sni: 831d4036-f.andns.co
  skip-cert-verify: false
- name: x1.0 香港 - 中转2
  type: trojan
  server: 831d4036-f.andns.co
  port: 10043
  password: F3nYyKZ9
  udp: true
  sni: 831d4036-f.andns.co
  skip-cert-verify: false
- name: x1.0 香港 - 中转3
  type: trojan
  server: 7c610710-i.andns.co
  port: 10044
  password: F3nYyKZ9
  udp: true
  sni: 7c610710-i.andns.co
  skip-cert-verify: false
- name: x1.0 香港 - 中转4
  type: trojan
  server: e3bac1e1-i.andns.co
  port: 10045
  password: F3nYyKZ9
  udp: true
  sni: e3bac1e1-i.andns.co
  skip-cert-verify: false
- name: x1.0 香港 - 中转5
  type: trojan
  server: 463b21bf-i.andns.co
  port: 10046
  password: F3nYyKZ9
  udp: true
  sni: 463b21bf-i.andns.co
  skip-cert-verify: false
- name: x1.0 香港 - 中转6
  type: trojan
  server: e3bac1e1-i.andns.co
  port: 10047
  password: F3nYyKZ9
  udp: true
  sni: e3bac1e1-i.andns.co
  skip-cert-verify: false
- name: x1.0 香港 1
  type: trojan
  server: 35c0f45d-i.andns.co
  port: 10045
  password: F3nYyKZ9
  udp: true
  sni: 35c0f45d-i.andns.co
  skip-cert-verify: false
- name: x1.0 香港 2
  type: trojan
  server: 35c0f45d-i.andns.co
  port: 10046
  password: F3nYyKZ9
  udp: true
  sni: 35c0f45d-i.andns.co
  skip-cert-verify: false
- n
```