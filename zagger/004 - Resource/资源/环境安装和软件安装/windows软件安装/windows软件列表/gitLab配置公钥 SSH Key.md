---
tags: 资源/环境配置
created: 2023-11-06T08:20
updated: 2023-11-14T09:22
---
# gitLab配置公钥 SSH Key

　　**首先需要已经在电脑上安装git，步骤参考网上即可。**

1. 桌面右键鼠标打开 "Git Bash Here"
2. 键入命令：ssh-keygen -t rsa -C "\*\*\*@126.com"

　　"\*\*\*@126.com"是gitlab账号 

3. 提醒你输入key的名称，输入 id_rsa
4. 在C:\Users\Administrator\\ssh下产生两个文件：id_rsa和id_rsa.pub 如果找不到的话请到桌面上找,找到之后将这两个文件拷贝到C:\Users\Administrator\\ssh目录下即可
5. 用编辑器打开id_rsa.pub文件，复制内容，在gitlab.com的网站上到ssh密钥管理页面，在Key一栏粘贴刚才复制的内容，Title一栏输入名称，这个名称随便起，建议英文，然后点击Add。
6. 完成

　　最后重新"Git Bash Here"  ， 键入 git clone git地址 ；回车即可下载。
