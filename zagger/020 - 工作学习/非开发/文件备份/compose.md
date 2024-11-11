---
created: 2023-11-06T08:20
updated: 2023-11-06T08:20
---
# compose 

　　version: '3.4'

　　services:

　　mongo:

　　  image: mongo:4

　　  restart: always

　　  environment:

　　    MONGO_INITDB_ROOT_USERNAME: root

　　    MONGO_INITDB_ROOT_PASSWORD: frontend

　　  networks:

　　    - resource

　　  volumes:

　　    - mongo_data:/data/db

　　  deploy:

　　    placement:

　　      constraints:

　　        - "node.labels.webresource == true"

　　nginx:

　　  image: nginx:stable-alpine

　　  restart: always

　　  volumes:

　　    - ./public:/usr/share/nginx/html

　　    - ./nginx_default.conf:/etc/nginx/conf.d/default.conf

　　  ports:

　　    - 18080:80

　　  networks:

　　    - resource

　　  depends_on:

　　    - webresourcesbackend

　　  deploy:

　　    placement:

　　      constraints:

　　        - "node.labels.webresource == true"

　　webresourcesbackend:

　　  image: vdife/webresourcesbackend

　　  build:

　　    context: .

　　    dockerfile: ./Dockerfile

　　  environment:

　　    NODE_ENV: production

　　    MONGO_HOST: mongo

　　    MONGO_ROOT_USERNAME: root

　　    MONGO_ROOT_PASSWORD: frontend

　　  networks:

　　    - resource

　　  depends_on:

　　    - mongo

　　  deploy:

　　    placement:

　　      constraints:

　　        - "node.labels.webresource == true"

　　networks:

　　resource:

　　volumes:

　　mongo_data:

　　参考链接：

　　[Docker入门之docker-compose - minseo - 博客园 (cnblogs.com)](https://www.cnblogs.com/minseo/p/11548177.html)

　　202.103.24.68
