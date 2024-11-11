---
tags: 工作/业务问题
created: 2023-11-03T22:29
updated: 2023-11-13T19:27
---
# patch-ngconsole-

　　补丁支持的版本：5.5.1版本 ,基于前端开发分支5.5.1-dev（8bf626531d359ebe8682a035997de6f42d41a051），不基于任何补丁  
补丁解决的问题：两个问题：1、关闭模板idp切换功能 2、去掉idp轮询获取token的接口调用，导致桌面挂机状态变为开机状态  
补丁包含的文件：共有5个文件：  
	1.built\spice.js  
	2.view-front\css\299.9c7fb5d9.css  
	3.\view-front\index.html  
	4.\view-front\js\299.09091406.js  
	5.\view-front\js\app.78c6b33a.js

　　补丁的使用方法：  
附件即为补丁，补丁替换说明如下：  
一、管理台替换步骤：

1. 备份服务器上 /var/www/html 目录
2. 解压 patch-ngconsole-20230628.zip 到 vdi 服务器 /var/www/html/ 目录，同名文件覆盖，其他文件要保留，不要直接替换文件夹。
