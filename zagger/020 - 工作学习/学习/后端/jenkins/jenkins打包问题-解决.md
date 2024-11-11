---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
# jenkins打包问题-解决

```js
--cache /var/jenkins_home/.npm 这个缓存的问题
sh 'rm -rf /var/jenkins_home/.npm'
sh 'rm -rf ./node_modules'
sh 'npm cache clean -f'
```

　　‍

　　‍

　　‍

```js
String gitCredentials = "zhuxiaokun@os-easy.com-gitlab"
String ngconsoleBranchName = env.NGCONSOLE_VERSION
String ngconsoleRepoUrl = "http://172.16.203.254/hanxiaoxiang/ngconsole.git"
String ngconsoleResourceBranchName = env.NGCONSOLE_RESOURCES_VERSION
String ngconsoleResourceRepoUrl = "http://172.16.203.254/baiyu/ngconsole_resources.git"
String tspaceRepoUrl = "http://172.16.203.254/huangzijie/view-front.git"

pipeline {
    agent any
    environment {
        ARCH='x86'
    }
    stages {
        stage('env') { // 看看当前运行环境
            steps {
                sh 'node -v'
                sh 'npm -v'
                sh 'git --version'
            }
        }
        stage('clone') {
            steps {
                dir('ngconsole') { // 克隆管理台主仓库
                    git branch: ngconsoleBranchName, credentialsId: gitCredentials, url: ngconsoleRepoUrl
                }
                dir('ngconsole_resources') { // 克隆资源仓库
                    git branch: ngconsoleResourceBranchName, credentialsId: gitCredentials, url: ngconsoleResourceRepoUrl
                }
                dir('view-front') { // 克隆资源仓库
                    git branch: ngconsoleBranchName, credentialsId: gitCredentials, url: tspaceRepoUrl
                }
            }
        }
        stage('deps') { // 安装依赖
            steps {
                dir('ngconsole_resources') {
                    sh 'npm ci --cache /var/jenkins_home/.npm --prefer-offline --registry https://registry.npmmirror.com'
                }
                dir('ngconsole') {
                    sh 'npm ci --cache /var/jenkins_home/.npm --prefer-offline --registry https://registry.npmmirror.com'
                }
                dir('view-front') {
                    sh 'npm ci --cache /var/jenkins_home/.npm --prefer-offline --registry https://registry.npmmirror.com'
                }
            }
        }
        stage('build') { // 打包
            steps {
                dir('view-front') {
                    script {
                        withCredentials([usernamePassword(credentialsId: gitCredentials, passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                            def encodedUsername = URLEncoder.encode("$GIT_USERNAME",'UTF-8')
                            def encodedPassword = URLEncoder.encode("$GIT_PASSWORD",'UTF-8')
                            echo encodedUsername
                            sh 'npm run build'
                            // sh "git config user.email $GIT_USERNAME"
                            // sh 'git config user.name jenkins'
                            // sh 'git commit -m "build" . || true'
                            // // sh 'echo ${encodedUsername}'
                            // sh "git push http://${encodedUsername}:${encodedPassword}@172.16.203.254/hanxiaoxiang/ngconsole.git || true"
                        }
                    }
                }
                dir('ngconsole') {
                    script {
                        withCredentials([usernamePassword(credentialsId: gitCredentials, passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                            def encodedUsername = URLEncoder.encode("$GIT_USERNAME",'UTF-8')
                            def encodedPassword = URLEncoder.encode("$GIT_PASSWORD",'UTF-8')
                            echo encodedUsername
                            sh 'npm run build'
                            sh "git config user.email $GIT_USERNAME"
                            sh 'git config user.name jenkins'
                            sh 'git add .'
                            sh 'git commit -m "build" . || true'
                            // sh 'echo ${encodedUsername}'
                            sh "git push http://${encodedUsername}:${encodedPassword}@172.16.203.254/hanxiaoxiang/ngconsole.git || true"
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            emailext body: '''${SCRIPT, template="managed:Groovy Email Template"}''',
            subject: '构建通知：${DEFAULT_SUBJECT}',
            to: 'jiazhihao@os-easy.com,yintianyu01324@os-easy.com',
            from: "weihong@os-easy.com"
          
        }
}
}
```
