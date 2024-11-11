---
created: 2023-11-06T08:20
updated: 2023-11-06T08:20
---
# 1. aliases.sh

　　/Git/etc/profile.d/aliases.sh

　　\# Some good standards, which are not used if the user

　　\# creates his/her own .bashrc/.bash_profile

　　\# --show-control-chars: help showing Korean or accented characters

　　alias ls='ls -F --color=auto --show-control-chars'

　　alias ll='ls -l'

　　alias grep='grep --color'

　　\# proxy

　　\# default socks5

　　alias setproxy="export ALL_PROXY=socks5://127.0.0.1:7890"

　　\# company socks5 ssh tunnel

　　alias setproxy1="export ALL_PROXY=socks5://59.175.233.194:8181"

　　\# reset proxy

　　alias unsetproxy="unset ALL_PROXY"

　　alias cip="curl -i http://ip.cn"

　　\# clear

　　alias c="clear"

　　\# git

　　alias gpl="git pull"

　　alias gpu="git push"

　　alias gs="git status"

　　alias glg="git log --stat"

　　alias gc='git config credential.helper store'

　　\# npm and yarn

　　alias ns="npm start"

　　alias ys="yarn run serve"

　　\# shortcut path

　　alias gw="cd d:/code"

　　\# ls

　　alias lsa="sudo ls -la --color=auto"

　　alias l='ls -la'

　　\# scp

　　alias scp142="scp -r js built resources views personal_login css fonts includes root@172.16.65.142:/var/www/html"

　　alias scp146="scp -r js built resources views personal_login css fonts includes root@172.16.65.146:/var/www/html"

　　case "\$TERM" in

　　xterm\*)

　　\# The following programs are known to require a Win32 Console

　　\# for interactive usage, therefore let's launch them through winpty

　　\# when run inside \`mintty\`.

　　for name in node ipython php php5 psql python2.7

　　do

　　  case "\$(type -p "\$name".exe 2\>/dev/null)" in

　　  ''\|/usr/bin/\*) continue;;

　　  esac

　　  alias \$name="winpty \$name.exe"

　　done

　　;;

　　esac
