---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
# 1. 前言

曾几何时想到部署那不是运维的工作吗？

![关我什么事？](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/447e49d2745141119b3a6e84c1ed8fb5~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

但最近在尝试部署自己的应用，docker 这一环终究是逃不过。这个技术对于前端来说，还是稍微有一点陌生。但如果你曾经也和我一样把台式电脑当作自己的游戏机，用光盘安装过单机游戏，然后打开游戏玩到“昏天黑地”，那么看完这一篇文章，你一定会使用 docker。

# 2. 什么是 docker？

在说 docker 之前，我们需要了解虚拟机。虚拟机说得通俗一点，就是依托本地物理机的环境构建出的另一台电脑：

![Schematic representation of a hosted hypervisor. The virtualization software allocates a virtual contingent of hardware resources provided by the host system (CPU time, RAM, disk space, and peripherals) to each VM.](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/78a8b958cf3a48349375b7b1fef8ac53~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp) 虚拟机 ![虚拟机](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ec97fd08e27044e1adf729a61f79dad4~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp) docker ![docker](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8b4932f57d6547749da3db41fd64a059~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

与虚拟机相比，docker 无需虚拟硬件环境然后再跑一个操作系统，它是一种轻量级的虚拟化，这种虚拟化技术称为**容器化**。

docker 利用操作系统的核心功能，如 Linux 的命名空间、控制组（cgroups）等特性，来创建**独立的、隔离的运行环境**，这个环境称为**容器**。

每个容器都可以运行一个或多个应用程序，并提供了与物理计算机相似的隔离性和资源管理能力，可以在不同的计算机或操作系统上运行应用程序，不必担心环境差异或依赖项冲突。

总结一下就是：docker 启动的容器共用宿主机的内核，不同容器之间是完全独立的。这样一来就可以保证需要部署的应用始终处于统一的环境配置下，方便持续集成和持续交付。另外，还可以利用这个特性创建统一的开发环境。

# 3. Docker 的组成

## 3.1 docker 的感性理解

docker 作为一个工具，它的三件套是：

- Dockerfile
- image（镜像）
- container（容器）

所谓 Dockerfile 就是某个环境的设计稿或蓝图，image 是依照 Dockerfile 刻录下来的镜像，用 image 就可以启动一个或多个独立环境，也就是 container（容器）。

如果非要类比成现实生活中的 🌰，大概是这样：

男生都有热爱游戏的人生阶段。那时候家里换了新电脑，别提多兴奋，我立马找到小伙伴东拼西凑出了一包游戏光碟，什么 CS1.5，CS1.6，魔兽争霸、星际争霸，仙剑奇侠传三、仙剑客栈、三国志11、侠盗飞车……应有尽有。之后，小伙伴们高高兴兴地团坐在一起，我按下主机上的 open 键打开了光驱，拿着 CS 1.5 的游戏光碟扣了进去。

close-我的电脑-F盘-双击-选择安装目录-安装，光碟在光驱中疯狂转动了一阵，一气呵成，双击运行 CS 1.5，是兄弟就在沙漠地图等着我。

当然，在家里联网以后，我就从游侠网上直接下载游戏安装包了，主打一个快乐。

在这段童年趣事中，那一张一张的游戏光碟就是不同的 image，双击运行（run）起来的 CS1.5 就是一个 container。而不同游戏厂商开发出来的游戏设计就是 Dockerfile，根据这份 Dockerfile 将文件刻录进光碟就是 image 的构建（build）。至于 CS1.5 和 1.6 或仙剑奇侠传一和三，这种游戏版本的区别，可以理解为不同版本（tag）的 image。从游侠网直接下载安装包就是拉取 image（pull），而游侠网作为一个游戏平台就是 docker hub —— docker 官方的镜像中心。

## 3.2 docker 使用流程

![docker 流程](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7ede046899e24e9db4e9ac087628d6b3~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

如果将上述流程整理出来，大概是这样的：

1. 准备环境：首先，需要在计算机上安装 docker。这类似于当初安装游戏的过程。

- `docker —version`
- `docker info`

2. 下载/构建镜像：类似于从游侠网下载游戏安装包，docker 使用镜像来构建容器。镜像是一个预先配置好的文件，其中包含了一个完整的应用程序及其依赖项。可以从 Docker Hub 等镜像仓库中搜索并下载适合需求的镜像。或者自己准备一个刻录机，自己刻录游戏，那这就是构建镜像。

- `docker pull <image>`
- `docker build -t <image> <path>`

3. 创建容器：一旦下载了所需的镜像，就可以使用 docker 命令创建容器。容器是基于镜像创建的运行实例，类似于当初安装的游戏。我们可以指定容器的各种参数，例如端口映射、文件挂载等。

`` bash  复制代码  `docker run -d --name <your_contianer_name> -p 8080:80 -v $(pwd):/app <image>` ``

4. 运行应用程序：一旦容器创建完成，就可以使用 docker 命令来启动容器并运行应用程序。就像您当初双击运行游戏一样，docker 会启动容器并运行您所需的应用程序。

- `docker exec -it <container> <command>`

## 3.3 docker 常用指令

**容器管理**

- `docker run <image>`：运行一个新的容器
- `docker start <container>`：启动一个已停止的容器
- `docker stop <container>`：停止一个正在运行的容器
- `docker restart <container>`：重启一个容器
- `docker rm <container>`：删除一个容器
- `docker ps`：列出当前正在运行的容器
- `docker ps -a`：列出所有容器，包括停止的容器

**镜像管理**

- `docker images`：列出本地的镜像
- `docker pull <image>`：下载一个镜像
- `docker push <image>`：将一个镜像推送到远程仓库
- `docker build -t <image> <path>`：根据 Dockerfile 构建一个镜像
- `docker rmi <image>`：删除一个本地的镜像

**日志和输出**

- `docker logs <container>`：查看容器的日志
- `docker exec -it <container> <command>`：在正在运行的容器中执行命令
- `docker cp <container>:<path> <local_path>`：将容器中的文件复制到本地

**网络和端口**

- `docker network ls`：列出 Docker 网络
- `docker network create <network>`：创建一个新的 Docker 网络
- `docker network connect <network> <container>`：将容器连接到指定的网络
- `docker port <container>`：显示容器的端口映射

**数据管理**

- `docker volume ls`：列出 Docker 卷
- `docker volume create <volume>`：创建一个新的 Docker 卷
- `docker volume inspect <volume>`：查看卷的详细信息
- `docker volume rm <volume>`：删除一个 Docker 卷

**其他常用指令：**

- `docker info`：显示系统信息
- `docker logs <container>`：获取容器的 log 信息
- `docker inspect <container>`：显示一个容器的具体配置信息

# 4. 部署前端项目

现在，让我们小试牛刀。

安装 docker 去 docker 官网安装，设置国内镜像源加速直接搜索教程，这两步我就略过了。

举个 🌰，如果我想要把前端项目部署到本地，我该怎么做？

## 4.1 准备前端项目源码

用 vite 火速创建一个 react + ts 项目：

```bash
npm create vite@latest my-react-app-docker-1 --template react-ts
```

创建完成后，打包项目代码：`npm run build` ，得到 `dist` 打包文件。

## 4.2 添加 nginx.conf

部署需要用到 **nginx 服务器**，这是一个高性能的开源Web服务器和反向代理服务器，它在处理高并发、负载均衡等方面表现卓越。下面是 `nginx.conf` 文件，属于 nginx 的主要配置文件，启动 nginx 服务后，将会根据这个文件来确定如何处理传入的请求和响应：

```bash
# 全局配置
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

# 事件模块配置
events {
  use epoll; # 多路复用
  worker_connections 1024;
}

# HTTP模块配置
http {
  # MIME类型配置
  include /etc/nginx/mime.types;
  default_type application/octet-stream;

  # 日志格式配置
  log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                  '$status $body_bytes_sent "$http_referer" '
                  '"$http_user_agent" "$http_x_forwarded_for"';

  # 访问日志配置
  access_log /var/log/nginx/access.log main;

  # Gzip压缩配置
  gzip on;
  gzip_comp_level 6;
  gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

  # 服务器配置
  server {
      listen 80;
      server_name localhost;

      # 根目录配置
      root /usr/share/nginx/html;
      index index.html;

      # 其他路由配置
      location / {
          try_files $uri $uri/ /index.html;
      }

      # 静态文件缓存配置
      location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
          expires 1d;
      }
  }
}

```

## 4.3 添加 Dockfile

在项目根目录下新建文件 Dockerfile，内容如下：

```docker
FROM nginx:stable-alpine3.17

COPY dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
```

- `FROM nginx:stable-alpine3.17`：这个指令指定了基础镜像，使用了名为 `nginx:stable-alpine3.17` 的基础镜像（优先从本地获取，如果本地没有，就从 docker hub 上拉取）。这个基础镜像是一个带有 nginx 的 Alpine Linux 镜像（Alpine 版本的镜像更加轻量），版本为 3.17。
- `COPY dist /usr/share/nginx/html`：这个指令将当前目录下的 `dist` 目录中的内容复制到docker 镜像中的 `/usr/share/nginx/html` 目录下（这是 nginx 的默认的 html 目录）。
- `COPY nginx.conf /etc/nginx/nginx.conf`：这个指令将当前目录下的 `nginx.conf` 文件复制到 docker 镜像中的 `/etc/nginx/nginx.conf` 文件中。这个文件是 nginx 的配置文件，通过复制到镜像中，可以在运行容器时使用自定义的 nginx 配置。

`nginx:stable-alpine3.17` 就是基础镜像，其他常用的基础镜像还有 `ubuntu`、`node`、`nginx`、`postgres` 等等，这些镜像是推荐提前就拉取到本地的，以后当本地构建镜像时，一旦用到就会用本地的，无需重新拉取远程的镜像。

现在拉取 nginx:stable-alpine3.17：

`` bash  复制代码  `docker pull nginx:stable-alpine3.17` ``

## 4.4 构建镜像

![文件结构](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4e97a2c5d4bc46559ab2eb37931a7f6e~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

现在准备工作就绪了，让我们开始构建镜像：

`` bash  复制代码  `docker build -t vite-web:v1 .` ``

- `-t` 指定 image 的名字（`vite-web`），后面可以用冒号指定标签（`v1`），默认是 latest
- `.` 表示 Dokcerfile 文件所在路径，docker 会在这个目录下找到 Dockfile，然后以此来构建镜像（这里表示当前路径）

![构建成功](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/48be51038d5243dbaf4d2509992949ad~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

构建完成，通过指令 `docker images` 可以看到 **vite-web:v1** 镜像已经在 image 的列表中了。

![镜像列表](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/26d7dad8cfd04cf6924cf21f9a90321a~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

## 4.5 启动容器

镜像完毕后，使用这个镜像来启动容器：

`` bash  复制代码  `docker run -d --name my-web-1 -p 8080:80 vite-web:v1` ``

- `-d` 参数表示以后台模式运行容器，即容器将在后台运行而不阻塞终端。
- `--name my-web-1` 参数指定容器的名称为 "my-web-1"，这个名称可以用来唯一标识容器。
- `-p 8081:80` 参数将容器的 80 端口映射到主机的 8081 端口，这样可以通过主机的 8081 端口访问容器中的应用程序。**（类似的 -v 参数也是左边是主机、右边是容器环境）**
- `vite-web:v1` 是要运行的容器镜像的名称和标签。

执行命令，看一下正在运行的容器列表：

`` bash  复制代码  `docker ps` ``

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e3b9fdaffb2c4d26a57588b7e56036a4~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

通过 `curl` 指令来查看网页连接情况：

`` bash  复制代码  `curl http://localhost:8080 -v` ``

![测试网页连接情况](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/eaef5174e4f14e409c14f703df41cd9b~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

再打开网页看看： ![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/81659c0897d846538e9c907573e048c7~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

有的时候，想要查看容器的日志，比如看看为什么没有运行起来、为什么报错了、谁来访问过了等等。用这个指令：

`` bash  复制代码  `docker logs my-web-1 # 用容器名称 docker logs 00e39d9365df # 或用容器id` ``

![容器 my-web-1 的日志](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8357f1841bd5412ea93fb70f020443ce~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

到此，前端本地部署成功！

## 4.6 自动化部署流程

在上面的整个流程中，不管是镜像构建还是容器运行，都是手动去敲命令的，然而，重复的工作都可以被优化。现在使用 **sh 脚本**来自动化执行整个部署流程。

sh 脚本文件一般放在 `bin` 目录下，在 `bin` 目录下新建文件 `setup_for_host.sh` 文件：

```bash
# 构建镜像
image_name=vite-web # 表示镜像名称
version=$(date +'%Y%m%d-%H%M%S') # 表示镜像版本（用时间表示）
contianer_name=my-web # 运行的容器名称
host_port=8080 # 本机端口
container_port=80 # 运行的容器端口

echo 'docker build...' # 构建镜像
docker build -t $image_name:$version .
echo 'docker rm...' # 清理同名容器
# 如果已经有同名的容器，删除掉
if [ "$(docker ps -aq -f name=$contianer_name)" ]; then
  echo 'docker rm ...'
  docker rm -f $contianer_name
fi
echo 'docker run...' # 启动容器
docker run -d --name $contianer_name -p $host_port:$container_port $image_name:$version
echo 'Done!'

```

写好后，把之前运行的 my-web-1 容器删除，因为占用了本机的 8080 端口，和脚本里的 host_port 会冲突：

`` bash  复制代码  `docker rm my-web-1` ``

删除后，在根目录下执行脚本：

`` bash  复制代码  `chmod +x bin/setup_host.sh # 添加可执行权限 bin/setup_host.sh` ``

![部署流程自动化](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a3c65a330edf4be6abd4f6e861100819~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

自动化部署脚本成功了！！！

![image.gif](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/85175ea61b72473db46d791d074b7a28~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

## 4.7 小结

用一幅图来总结这一部分内容： ![本地部署前端项目](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c012ac644b184ceb99bbb7aa3eb3d47d~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

镜像启动出一个容器环境，把容器环境中的 nginx 服务器需要的两个文件从宿主机上拷贝过来，然后把 80 端口映射到宿主机的 80 端口，在宿主机上即可访问网页。

# 5. 部署 Node.js 应用

掌握了前端项目的本地部署后，Node 应用如何部署？

## 5.1 准备后端服务源码

node.js 安装就略过了。

直接用命令行开干：

```bash
mkdir my-express-app-docker-1
cd $_
npm init -y
npm i express
touch server.js
ls
nano server.js

```

server.js 内容如下：

```js
'use strict';

const express = require('express');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/', (req, res) => {
  res.send('Hello World');
});

app.listen(PORT, HOST, () => {
  console.log(`Running on http://${HOST}:${PORT}`);
});

```

在 package.json 文件中添加启动脚本：

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3fe97c5295914281be931c01d235e0e3~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

运行 `npm run start` 后，使用 curl 查看回应，一切正常：

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4fd3c1bb6ba54adc9d9fff1418d106c6~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

## 5.2 添加 .dockerignore 和 Dockfile

express 包用到了 node，本地的 node_modules 不需要拷贝进 docker，所以要用到一个很像 .gitignore 的文件 —— .dockerignore，用来忽略相应文件，.dockerignore 文件内容如下：

```bash
node_modules
npm-debug.log
```

在项目根目录下新建文件 Dockerfile，内容如下：
```bash
# 使用更轻量的 node18
FROM node:18-alpine
# 创建工作目录 /app
WORKDIR /app

# 把安装依赖所需的 package.json AND package-lock.json 复制到 /app
COPY package*.json ./
# 安装依赖
RUN npm install
# 如果是生产环境使用 ci
# RUN npm ci --omit=dev

# 打包源码到 /app
COPY . .

# 暴露端口 8080
EXPOSE 8080
# 启动容器后，执行 node server.js
CMD ["node", "server.js"]

```

## 5.3 构建镜像 + 启动容器

这一步和前端部署章节是一样的。

**构建镜像：**

`` bash  复制代码  `docker build -t express-app .` ``

构建了一个叫做 express-app 的 image，如果不加冒号和 tag 号，那么构建出的镜像默认就是 latest 版本。

**启动容器：**

```bash  复制代码  
docker run -d --name my-express-app -p 3002:8080 express-app
```

用 express-app 启动一个叫做 my-express-app 的 express 应用容器。

通过 `curl` 指令来查看网页连接情况：

``` bash  复制代码  
curl -i localhost:3002
```

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/672cc1a88183454db3b6a84409cab36b~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

连接正常！

如果想停掉这个运行的服务就执行 `docker stop my-express-app` ，如果想再次启动就执行 `docker start my-express-app`

Node 应用的部署也搞定了！

至于自动化部署，按照前端自动化部署脚本照猫画虎即可，这里不多赘述了～

![image.gif](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/135fcd6a275a46dca76dcc9ea432aa0a~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

## 5.4 进入容器

如果想要进入容器看看，那么执行：

``` bash  复制代码  
# docker exec -it <container> <command> # 因为使用 apline 版本的镜像，所以不能用 bash，这里用 sh 或者 ash 代替 docker exec -it my-express-app ash
```

输入 `whoami` 可以看到当前用户是 **root**：

![whoami](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/771fc832ecdb46458f8baea1d67712f2~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

如果没有在 Dockerfile 中设置权限，那么默认都会使用 root，这是一个潜在的问题，一般生产环境不会直接使用 root 去部署服务，关于这一点先挖个坑。

输入 `exit` 回车即可退出容器操作。

# 6. 镜像推送

现在我们前后端的镜像都有了（vite-web 和 express-app），推送到仓库去，然后测试工程师就可以从测试环境、生产环境拉取代码进行测试了。一般来说，公司都会搭建自己的 docker 镜像仓库，这里以 docker hub 为例（注册略）：

## 6.1 docker 登录

第一步、登录 docker hub：

``` bash
docker login
```

![docker 登录成功](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/aae2f4f65fae4655a525f657038c11a8~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

## 6.2 tag 标签设置

第二步、给镜像打上标签：

``` bash  
# docker tag <image> <username>/<image> docker tag vite-web:v1 ericknight/vite-web docker tag express-app ericknight/express-app
```

**注意：**`username` **必须是你的用户名，不能乱填。**

## 6.3 推送到镜像仓库

最后推动到仓库：

``` bash  复制代码  
docker push ericknight/vite-web:latest docker push ericknight/express-app:latest
```

![镜像推送](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/12ca492d6b7647e5b3f3e764ad84c673~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

之后，在 docker hub 上就能看到刚刚推送的镜像了：

![你的镜像仓库](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a5b3274e25eb4c72bd6875a274af7f16~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

# 7. 总结

到这里，基本上就可以掌握 docker 的基础使用以及如何在本地部署项目了，基本流程掌握好就可以：

- Dockerfile
- docker build 或 docker pull
- docker run
- docker push

当然还有其他的 docker 指令，大家可以自己琢磨琢磨。另外，其实部署的内容还有很多很多。比如如何通个网将前后端、数据库联合起来、如何做数据持久化、如何做 CI / CD、如何部署到云服务器，甚至是放弃 docker，使用 serverless 部署，暂且挖个坑……

以上，如有谬误，还请斧正，感谢您的阅读～

👏 对了，如果你还没有我的好友，加我微信：**enjoy_Mr_cat**，备注 `「掘金」` ，即有机会加入高质量前端交流群，在这里你将会认识更多的朋友；也欢迎关注我的公众号 `见嘉 Being Dev`，并设置星标，以便第一时间收到更新。

**参考：**

1. Virtual Machines：[www.ionos.com/digitalguid…](https://link.juejin.cn?target=https%3A%2F%2Fwww.ionos.com%2Fdigitalguide%2Fserver%2Fknow-how%2Fvirtual-machines%2F "https://www.ionos.com/digitalguide/server/know-how/virtual-machines/")
2. Docker — 从入门到实践：[docker-practice.github.io/zh-cn/](https://link.juejin.cn?target=https%3A%2F%2Fdocker-practice.github.io%2Fzh-cn%2F "https://docker-practice.github.io/zh-cn/")
3. Dockerizing a Node.js web app：[nodejs.org/en/docs/gui…](https://link.juejin.cn?target=https%3A%2F%2Fnodejs.org%2Fen%2Fdocs%2Fguides%2Fnodejs-docker-webapp "https://nodejs.org/en/docs/guides/nodejs-docker-webapp")
4. docker docs：[docs.docker.com/get-started…](https://link.juejin.cn?target=https%3A%2F%2Fdocs.docker.com%2Fget-started%2Foverview%2F "https://docs.docker.com/get-started/overview/")
5. [前端工程师也应该了解的docker - 掘金 (juejin.cn)](https://juejin.cn/post/7250029395023544376?utm_source=gold_browser_extension)