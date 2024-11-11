---
created: 2023-11-03T22:29
updated: 2023-11-06T12:24
---
# 1. 禅道卫士，偶尔需要重启
#禅道卫士重启 #zentao-doctor #restart
打开xshell连上192.168.0.161，输入账号密码后，直接运行如下命令
`docker restart zentao-doctor`
# 2. a docker实战 - 禅道卫士维护 2023.0606

1. 地址：[禅道卫士](http://192.168.0.161:8090/)
2. 代码仓库：[https://mystorp.coding.net/p/oseasyfe/d/zentao-doctor/git](https://mystorp.coding.net/p/oseasyfe/d/zentao-doctor/git)
3. [zaggerzj@163.com](http://zaggerzj@163.com)
4. 帐号：192.168.0.161
5. root/[oseasy@123](http://oseasy@123)
6. config.json

```js
{
    "host": "172.16.203.12",
    "port": 80,
    "username": "admin",
    "password": "oseasy@2018",
    "verbose": false,
    "code": "test",
    "key": "2d802945902cd6b3081bb9df4fe0553f",
    "requestType": "PATH_INFO"
}
```

7. 
```bash
# /xx/yy/url.html 等于  /xx/yy/url.json
# fe.os-easy.com是代码仓库，暂时不用管
npm run dev # 进行开发
npm run start # 用于生产
npm run pack # 用于打包镜像,执行命令之前确保docker已经启动

# docker 启动失败 先更新docker
# scoop update docker -g # 失败
# 直接使用geek.exe 卸载 docker desktop 然后去官网重新安装 docker desktop https://www.docker.com/products/docker-desktop/
# 然后登录好账号 https://app.docker.com/ zaggerzj@gmail.com
# 重新 打开docker 还是报错
# Building for production...Error: error:0308010C:digital envelope routines::unsupported at new Hash (node:internal/crypto/hash:69:19)

# fnm use v16
# 重新 npm run pack 就好了

#  10 | >>> RUN npm install --production --silent && mv node_modules ../ ERROR: failed to solve: process "/bin/sh -c npm install --production --silent && mv node_modules ../" did not complete successfully: exit code: 1
# 修改 npm run pack中的版本号
# 重新 运行命令还是报错
# 通过ai工具查询 发现 可能是网络问题
# 关闭代理 重新运行命令
# 网络原因 造成的报错
RUN npm install -g cnpm --registry=https://registry.npmmirror.com && rm -rf node_modules && cnpm install --verbose && mv node_modules ../
# 最终成功了

npm run pack # 会打包好前端

# 保存镜像
docker save fe.os-easy.com:5000/zentao-doctor:1.0.16 > zentao-doctor.tar 

# 进行打包
scp -r zentao-doctor.tar root@192.168.0.161:/root
ssh root@192.168.0.161 # 输入密码

rm -rf zentao-doctor.tar

docker rmi xxx

docker load -i zentao-doctor.tar # 加载完镜像
```



16. ​![image](40%20-%20Obsidian/附件/Attachment/assets%206-zagger/image-20230705213808-7ck8gb8.png)​

17. docker ps -a
18. ​![image](40%20-%20Obsidian/附件/Attachment/assets%206-zagger/image-20230705213819-bgypwz1.png)​

19. docker stop xxx
20. docker rm xxx
21. docker rmi xxx

　　​![image](40%20-%20Obsidian/附件/Attachment/assets%206-zagger/image-20230705213844-jn73zvh.png)​

```bash
docker run -d --name zentao-doctor -p 8090:3000 fe.os-easy.com:5000/zentao-doctor:1.0.16 # 出现容器id，表示成功
docker restart zentao-doctor

# 问题1：解决禅道admin账号密码被修改的问题
history | grep docker # 找到最近的zentao-doctor相关的命令
run -d --name zentao-doctor -p 8090:3000 fe.os-easy.com:5000/zentao-doctor:1.0.16
docker exec -it zentao-doctor /bin/sh
# 将目录中的config.json改为自己的账号
docker restart zentao-doctor

docker update --restart=always zentao-doctor

# 问题2 ：解决 docker load -i zentao-doctor.tar 无法加载镜像
# Authorization not available. Check if polkit service is running or see debug message for more information.
# Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
# systemctl start docker systemctl enable docker 都失效
reboot # centos 系统执行重启

```
`

之所以本地可以跑，docker中连不上是因为192.168.0.161跟172.16.203.14网络不通
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20240805155831.png)

安装ubuntu dokcer：
```bash
# 安装依赖包 安装必要的依赖包，这些包用于通过 HTTPS 获取软件仓库
sudo apt install apt-transport-https ca-certificates curl software-properties-common

# 添加 Docker 中科大 GPG 密钥 为了确保下载的 Docker 软件包的真实性和完整性，我们需要添加 Docker 的 GPG 密钥
sudo mkdir -p /etc/apt/keyrings 
sudo curl -fsSL http://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc 
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 添加 Docker 中科大镜像稳定版软件源
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] http://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
sudo apt install docker-ce docker-ce-cli containerd.io

```

```js
docker-compose start  vsftpd

docker-compose logs  vsftpd

docker start frontend-docs

docker stop frontend-docs

cd /usr/local/vsftpd-compose/vsftpd/data/oseasy/trunk/V5.5.0-VPC版本/docker/docker安装包/

md5sum VPC-1.6-X86_64-dev-5.5.0-docker.bin

service docker status

docker status showdoc

chmod 777 VDI-0.5-X86_64-dev-5.5.0-docker.bin

df -h

df -lh

df -all

tar -xzvf 0.0.112.tar.gz

find / -name cloudos-kvm-1.24.11.0-r5971.zip

find -type d -name 'fedoc'
/usr/share/nginx/html/fedoc
systemctl status nginx
systemctl start nginx


# 重启showdoc
cd /
chmod 777 showdoc
chmod 644 showdoc
# 4表示读取权限，2表示写入权限，1表示执行权限。

```
[chmod 权限-rw-r--r--表示什么含义_程序员杰森的博客-CSDN博客](https://blog.csdn.net/weixin_43670802/article/details/105272266)
[Linux chmod 命令 | 菜鸟教程 (runoob.com)](https://www.runoob.com/linux/linux-comm-chmod.html)