---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
# consoleui维护

　　\- node --version

　　\- npm --version

　　\- npm ci --cache .npm --prefer-offline --registry [https://registry.npmmirror.com/](https://registry.npmmirror.com/)

　　\- npm run build

　　\- PV=\$(node -p 'require("./package.json").version')

　　\- cd ..

　　\- tar cf \$PV.tar.gz consoleui/package.json consoleui/dist

　　\- cp \$PV.tar.gz /var/www/console-ui

　　consoleui不更新的话

　　npm install consoleui

　　[*ftp服务器和npm 临时仓库地址*](note://WEBd1ddec1e8ff0908d3e021335514e9070)
