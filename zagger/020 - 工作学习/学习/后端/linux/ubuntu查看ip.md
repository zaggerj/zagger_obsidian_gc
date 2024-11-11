---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
ifconfig eth0 | grep 'inet '| sed 's/inet //g' | sed 's/netmask.*$//g'