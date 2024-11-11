---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
# 解决webspice统一的问题

　　1.关于如何改变linux中，对只有Read-only filesystem的文件，如何改为为可写、可读权限？

　　I、可以执行 mount -o remount,rw /

　　II、执行完毕后，会出现以下字样

　　warning: checktime reached, running e2fsck is recommended

　　re-mounted. Opts: data=ordered

　　III、出现以上字母表示挂载成功，可执行相应文件

　　location /webspice/ {

　　  proxy_pass https://127.0.0.1:6082/;

　　  proxy_http_version 1.1;

　　  proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

　　  proxy_set_header Host \$host;

　　  proxy_set_header X-Real-IP \$remote_addr;

　　  proxy_set_header X-Scheme \$scheme;

　　  proxy_set_header X-Real-PORT \$remote_port;

　　  proxy_set_header Upgrade \$http_upgrade;

　　  proxy_set_header Connection "Upgrade";

　　  proxy_read_timeout 3600;

　　}

　　![截图.png](image1-20230705220235-az8rqxi.png)
