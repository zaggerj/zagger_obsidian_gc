---
alias:
tags: 长青笔记
cdate: 2024-08-27 17:13
uid: 20240827171349
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. windows git bash 配置文件

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2024-08-27 星期二 17:13:49

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

```bash
#!/bin/bash
# ~/.bash_profile
#!/bin/bash

# 规范提交
function commit {
  # 使用方法
  commit_usage() {
    echo "Usage: commit <prefix> <msg> [-n|--no|--no-verify]"
    echo "  prefix: One of 'feat', 'fix', 'comment', 'refactor', 'style', or 'build'."
    echo "  msg: Commit message."
    echo "  -n|--no|--no-verify: Optional flag to disable commit hooks."
  }

  # 定义 commit 函数
  do_commit() {
    local prefix="$1"
    local msg="$2"
    local no_verify_flag=false
    echo "$prefix"
    echo "$msg"
    # 检查 prefix 是否合法
    case "$prefix" in
      feat|fix|comment|refactor|style|build)
        ;;
      *)
        echo "Error: Invalid prefix '$prefix'. Must be one of 'feat', 'fix', 'comment', 'refactor', 'style', or 'build'."
        commit_usage
        return 1
        ;;
    esac

    # 检查消息是否为空
    if [ -z "$msg" ]; then
      echo "Error: Message cannot be empty."
      commit_usage
      return 1
    fi

    # 解析并设置 --no-verify 标志
    shift 2  # 移除前两个参数，以便检查剩余的参数
    while [[ $# -gt 0 ]]; do
      case "$1" in
        -n|--no|--no-verify)
          no_verify_flag=true
          ;;
        *)
          # 忽略其他未知选项
          ;;
      esac
      shift
    done

    # 构造 commit 消息
    local commit_msg="${prefix}: ${msg}"

    # 执行 git commit 命令
    local commit_args=("-m" "$commit_msg")
    if [ "$no_verify_flag" = true ]; then
      commit_args+=("--no-verify")
    fi
    git commit "${commit_args[@]}"
  }

  # 检查参数数量
  if [ $# -lt 2 ]; then
    commit_usage
    return 2
  fi

  # 调用 commit 函数
  do_commit "$@"
}

# 自动push
function auto() { git add.; git commit -m "$1"; git push; }
function gcp() { git commit -m "$1"; git push; }

function check() { git branch -a | grep "$1"; }
function walk() { git checkout "$1"; }
function new() { git checkout -b "$1"; }

# 撤销
function soft() { git reset --soft HEAD^; }
# 回退任意版本
function reset() { git reset --hard "$1"; git push -f; }
function back() { git reset --hard HEAD^ && git push -f; }

# 修改commit信息
function m() { git commit --amend; }
function log() { git log --pretty=format:"%h - %an, %ar : %s"; }

function copyId() { ssh-copy-id -i ~/.ssh/id_rsa.pub "$1"@"$2"; }
function async() { scp -r js built resources views personal_login css fonts includes "$1"@"$2":/var/www/html; }

alias cls='clear'
alias c="clear"
alias pull='git pull'
alias gpl='git pull'
alias origin='git pull origin'
alias a='git add .'
alias gc='git commit -m'
alias ac='git commit -a -m' # 将暂存区提交更新
alias push='git push'
alias gpu='git push'
alias pf='git push -f' # 强制推送

alias glg="git log --stat"
alias gcs='git config credential.helper store'

# 规范提交
alias commit='commit'

alias auto='auto'
alias gcp='gcp'           # 自动commit push

alias s='git status'
alias d='git diff'
alias gs='git stash'
alias gsp='git stash pop'

alias check='check'
alias walk='walk'
alias new='new'

# 撤销
# 撤销commit
alias soft='git reset --soft HEAD^'                                     # 撤销commit
alias reset='reset' 
# 回退上个
alias back='git reset --hard HEAD^ && git push -f'                      # 回退上个

# 修改commit信息
alias m='git commit --amend' 
# 查看版本                            
alias log='git log --pretty=format:"%h - %an, %ar : %s"' # 查看版本



alias copyId='copyId'

# scp
alias sp='async'
alias scp145='scp -r js built resources views personal_login css fonts includes root@172.21.65.145:/var/www/html'
alias scp155="scp -r js built resources views personal_login css fonts includes root@172.21.65.155:/var/www/html"

# alias
alias ls='ls -F --color=auto --show-control-chars'
alias ll='ls -l'
alias grep='grep --color'

alias econf='code ~/.bash_profile'
alias rconf='source ~/.bash_profile'
alias ewezterm='code ~/.wezterm.lua'
alias envim='code ~/.config/nvim/init.vim'
alias ehost='code /c/Windows/System32/drivers/etc/hosts'
alias host='code /c/Windows/System32/drivers/etc/hosts'

# npm and yarn
alias ns="npm start"
alias ys="yarn run serve"

# shortcut path
alias gw="cd d:/code"

# ls
alias lsa="sudo ls -la --color=auto"
alias l='ls -la'

# 不知道啥 自动生成的吧 后续删除掉
case "$TERM" in
xterm*)
  # The following programs are known to require a Win32 Console
  # for interactive usage, therefore let's launch them through winpty
  # when run inside `mintty`.
  for name in node ipython php php5 psql python2.7; do
    case "$(type -p "$name".exe 2>/dev/null)" in
    '' | /usr/bin/*) continue ;;
    esac
    alias $name="winpty $name.exe"
  done
  ;;
esac

# git@172.16.203.254:hanxiaoxiang/ngconsole.git
# git@172.16.203.254:baiyu/ngconsole_resources.git
# git@172.16.203.254:huangzijie/view-front.git
export GIT_INNER_PREFIX=http://172.16.203.254
export GIT_OUTER_PREFIX=http://14f74814.r3.cpolar.top

export NG_SURFIX_URL=/hanxiaoxiang/ngconsole.git
export RE_SURFIX_URL=/baiyu/ngconsole_resources.git
export VF_SURFIX_URL=/huangzijie/view-front.git
export WORK=d:/code
export SPACE=d:/code/ngconsole
export TSPACE=d:/code/view-front

alias chng='git remote set-url origin $GIT_OUTER_PREFIX$NG_SURFIX_URL'
alias clng='git clone $GIT_OUTER_PREFIX$NG_SURFIX_URL'
alias chng1='git remote set-url origin $GIT_INNER_PREFIX$NG_SURFIX_URL'
alias chre='git remote set-url origin $GIT_OUTER_PREFIX$RE_SURFIX_URL'
alias clre='git clone $GIT_OUTER_PREFIX$RE_SURFIX_URL'
alias chre1='git remote set-url origin $GIT_INNER_PREFIX$RE_SURFIX_URL'
alias chvf='git remote set-url origin $GIT_OUTER_PREFIX$VF_SURFIX_URL'
alias clvf='git clone $GIT_OUTER_PREFIX$VF_SURFIX_URL'
alias chvf1='git remote set-url origin $GIT_INNER_PREFIX$VF_SURFIX_URL'

alias wk='cd $WORK'
alias sp='cd $SPACE'
alias ts='cd $TSPACE'
# proxy
# default socks5
alias setproxy="export ALL_PROXY=socks5://127.0.0.1:7890;export http_proxy=http://127.0.0.1:7890;export https_proxy=http://127.0.0.1:7890"
# company socks5 ssh tunnel
alias setproxy1="export ALL_PROXY=socks5://59.175.233.194:8181"
# reset proxy
alias unsetproxy="unset ALL_PROXY;unset http_proxy;unset https_proxy;"
alias setproxy='export https_proxy=http://127.0.0.1:7890;export http_proxy=http://127.0.0.1:7890;export all_proxy=socks5://127.0.0.1:7890'
alias unsetproxy='export https_proxy="";http_proxy="";export all_proxy=""'

alias cip="curl -i http://ip.cn"

alias config='source ~/.bash_profile'
alias pn='pnpm'

# fnm
eval "$(fnm env --use-on-cd)"
fnm use v18

history -r ~/.bash_history
# 设置历史记录大小为较大的值（例如 10000 条命令）
export HISTFILESIZE=10000
export HISTSIZE=10000
chmod 600 ~/.bash_history
# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups  
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
export HISTTIMEFORMAT='%F %T '     # 注意有个空格, 这样在显示时日期与命令之间会有空格分隔

# 在退出时保存历史记录
shopt -s histappend
PROMPT_COMMAND='history -a'
```
# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
