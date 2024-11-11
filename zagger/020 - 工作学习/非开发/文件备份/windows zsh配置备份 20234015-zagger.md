---
created: 2023-11-06T08:20
updated: 2023-11-10T12:33
---
# 1. windows zsh配置备份 20234015

　　\# If you come from bash you might have to change your \$PATH.

　　\# export PATH=\$HOME/bin:/usr/local/bin:\$PATH

　　\# Path to your oh-my-zsh installation.

　　export ZSH="\$HOME/.oh-my-zsh"

　　\# Set name of the theme to load --- if set to "random", it will

　　\# load a random theme each time oh-my-zsh is loaded, in which case,

　　\# to know which specific one was loaded, run: echo \$RANDOM_THEME

　　\# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

　　\# ZSH_THEME="robbyrussell"

　　ZSH_THEME="random"

　　\# Set list of themes to pick from when loading at random

　　\# Setting this variable when ZSH_THEME=random will cause zsh to load

　　\# a theme from this variable instead of looking in \$ZSH/themes/

　　\# If set to an empty array, this variable will have no effect.

　　\# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

　　\# Uncomment the following line to use case-sensitive completion.

　　\# CASE_SENSITIVE="true"

　　\# Uncomment the following line to use hyphen-insensitive completion.

　　\# Case-sensitive completion must be off. \_ and - will be interchangeable.

　　\# HYPHEN_INSENSITIVE="true"

　　\# Uncomment one of the following lines to change the auto-update behavior

　　\# zstyle ':omz:update' mode disabled  # disable automatic updates

　　\# zstyle ':omz:update' mode auto      # update automatically without asking

　　\# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

　　\# Uncomment the following line to change how often to auto-update (in days).

　　\# zstyle ':omz:update' frequency 13

　　\# Uncomment the following line if pasting URLs and other text is messed up.

　　\# DISABLE_MAGIC_FUNCTIONS="true"

　　\# Uncomment the following line to disable colors in ls.

　　\# DISABLE_LS_COLORS="true"

　　\# Uncomment the following line to disable auto-setting terminal title.

　　\# DISABLE_AUTO_TITLE="true"

　　\# Uncomment the following line to enable command auto-correction.

　　\# ENABLE_CORRECTION="true"

　　\# Uncomment the following line to display red dots whilst waiting for completion.

　　\# You can also set it to another string to have that shown instead of the default red dots.

　　\# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"

　　\# Caution: this setting can cause issues with multiline prompts in zsh \< 5.7.1 (see \#5765)

　　\# COMPLETION_WAITING_DOTS="true"

　　\# Uncomment the following line if you want to disable marking untracked files

　　\# under VCS as dirty. This makes repository status check for large repositories

　　\# much, much faster.

　　\# DISABLE_UNTRACKED_FILES_DIRTY="true"

　　\# Uncomment the following line if you want to change the command execution time

　　\# stamp shown in the history command output.

　　\# You can set one of the optional three formats:

　　\# "mm/dd/yyyy"\|"dd.mm.yyyy"\|"yyyy-mm-dd"

　　\# or set a custom format using the strftime function format specifications,

　　\# see 'man strftime' for details.

　　\# HIST_STAMPS="mm/dd/yyyy"

　　\# Would you like to use another custom folder than \$ZSH/custom?

　　\# ZSH_CUSTOM=/path/to/new-custom-folder

　　\# Which plugins would you like to load?

　　\# Standard plugins can be found in \$ZSH/plugins/

　　\# Custom plugins may be added to \$ZSH_CUSTOM/plugins/

　　\# Example format: plugins=(rails git textmate ruby lighthouse)

　　\# Add wisely, as too many plugins slow down shell startup.

　　plugins=(

　　git

　　bundler

　　dotenv

　　macos

　　rake

　　rbenv

　　ruby

　　zsh-syntax-highlighting

　　zsh-autosuggestions

　　z

　　sudo

　　)

　　source \$ZSH/oh-my-zsh.sh

　　\# User configuration

　　\# export MANPATH="/usr/local/man:\$MANPATH"

　　\# You may need to manually set your language environment

　　\# export LANG=en_US.UTF-8

　　\# Preferred editor for local and remote sessions

　　\# if \[\[ -n \$SSH_CONNECTION \]\]; then

　　\#   export EDITOR='vim'

　　\# else

　　\#   export EDITOR='mvim'

　　\# fi

　　\# Compilation flags

　　\# export ARCHFLAGS="-arch x86_64"

　　\# Set personal aliases, overriding those provided by oh-my-zsh libs,

　　\# plugins, and themes. Aliases can be placed here, though oh-my-zsh

　　\# users are encouraged to define aliases within the ZSH_CUSTOM folder.

　　\# For a full list of active aliases, run \`alias\`.

　　\#

　　\# Example aliases

　　\# alias zshconfig="mate ~/.zshrc"

　　\# alias ohmyzsh="mate ~/.oh-my-zsh"

　　\# 如果不想看到某个特别讨厌的主题，可以忽略它

　　ZSH_THEME_RANDOM_IGNORED=(

　　pygmalion

　　tjkirch_mod

　　)

　　source /c/Users/zagger/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

　　\# alias

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

　　for name in node ipython php php5 psql python2.7; do

　　  case "\$(type -p "\$name".exe 2\>/dev/null)" in

　　  '' \| /usr/bin/\*) continue ;;

　　  esac

　　  alias \$name="winpty \$name.exe"

　　done

　　;;

　　esac

　　alias cls='clear'

　　alias pull='git pull'

　　alias origin='git pull origin'

　　alias a='git add .'

　　alias gc='git commit -m'

　　alias ac='git commit -a -m' \# 将暂存区提交更新

　　alias push='git push'

　　alias pf='git push -f' \# 强制推送

　　\# 规范提交

　　alias feat='featFun() { git commit -m "feat: \$1";}; featFun'                 \# commit feat

　　alias fix='fixFun() { git commit -m "fix: \$1";}; fixFun'                     \# commit fix

　　alias refactor='refactorFun() { git commit -m "refactor: \$1";}; refactorFun' \# commit refactor

　　alias style='styleFun() { git commit -m "style: \$1";}; styleFun'             \# commit style \`\`

　　alias built='builtFun() { git commit -m "built \$1";}; builtFun'              # commit built

　　alias auto='auto() { git add .; git commit -m "\$1"; git push; }; auto' \# 自动push

　　alias gcp='cpFun() { git commit -m "\$1"; git push; }; cpFun'           \# 自动commit push

　　alias s='git status'

　　alias d='git diff'

　　alias gs='git stash'

　　alias gsp='git stash pop'

　　alias check='checkFun() { git branch -a \| grep "\$1";}; checkFun'

　　alias walk='walkFun() { git checkout \$1;}; walkFun'

　　alias new='newFun() { git checkout -b \$1;}; newFun'

　　\# 撤销

　　alias soft='git reset --soft HEAD^'                                     \# 撤销commit

　　alias reset='backHard() { git reset --hard \$1; git push -f;}; backHard' \# 回退任意版本

　　alias back='git reset --hard HEAD^ && git push -f'                      # 回退上个

　　\# 修改

　　alias m='git commit --amend'                             \# 修改commit信息

　　alias log='git log --pretty=format:"%h - %an, %ar : %s"' \# 查看版本

　　alias copyId='copyIdFun(){ ssh-copy-id -i ~/.ssh/id_rsa.pub \$1@\$2;}; copyIdFun'

　　alias async='scpFun(){ scp -r js built resources views personal_login css fonts includes \$1@\$2:/var/www/html;}; scpFun'

　　alias sp142='scpFun(){ scp -r js built resources views personal_login css fonts includes root@172.16.65.142:/var/www/html;}; scpFun'

　　alias econf='code ~/.bash_profile'

　　alias ewezterm='code ~/.wezterm.lua'

　　alias envim='code ~/.config/nvim/init.vim'

　　alias ehost='code /c/Windows/System32/drivers/etc/hosts'

　　\# git@172.16.203.254:hanxiaoxiang/ngconsole.git

　　\# git@172.16.203.254:baiyu/ngconsole_resources.git

　　\# git@172.16.203.254:huangzijie/view-front.git

　　export GIT_INNER_PREFIX=http://172.16.203.254

　　export GIT_OUTER_PREFIX=https://4ba57d67.r3.cpolar.top

　　\# http://553db3e2.r6.cpolar.top/duanchenghu/spice-web-client.git

　　export NG_SURFIX_URL=/hanxiaoxiang/ngconsole.git

　　export RE_SURFIX_URL=/baiyu/ngconsole_resources.git

　　export VF_SURFIX_URL=/huangzijie/view-front.git

　　export SW_SURFIX_URL=/duanchenghu/spice-web-client.git

　　export WORK=d:/code

　　export SPACE=d:/code/ngconsole

　　export TSPACE=d:/code/view-front

　　alias chng='git remote set-url origin \$GIT_OUTER_PREFIX\$NG_SURFIX_URL'

　　alias clng='git clone \$GIT_OUTER_PREFIX\$NG_SURFIX_URL'

　　alias chng1='git remote set-url origin \$GIT_INNER_PREFIX\$NG_SURFIX_URL'

　　alias chre='git remote set-url origin \$GIT_OUTER_PREFIX\$RE_SURFIX_URL'

　　alias clre='git clone \$GIT_OUTER_PREFIX\$RE_SURFIX_URL'

　　alias chre1='git remote set-url origin \$GIT_INNER_PREFIX\$RE_SURFIX_URL'

　　alias chvf='git remote set-url origin \$GIT_OUTER_PREFIX\$VF_SURFIX_URL'

　　alias clvf='git clone \$GIT_OUTER_PREFIX\$VF_SURFIX_URL'

　　alias chvf1='git remote set-url origin \$GIT_INNER_PREFIX\$VF_SURFIX_URL'

　　alias chsw='git remote set-url origin \$GIT_OUTER_PREFIX\$SW_SURFIX_URL'

　　alias chsw1='git remote set-url origin \$GIT_INNER_PREFIX\$SW_SURFIX_URL'

　　alias wk='cd \$WORK'

　　alias sp='cd \$SPACE'

　　alias ts='cd \$TSPACE'

　　alias setproxy='export https_proxy=http://127.0.0.1:7890;export http_proxy=http://127.0.0.1:7890;export all_proxy=socks5://127.0.0.1:7890'

　　alias unsetproxy='export https_proxy="";http_proxy="";export all_proxy=""'

　　alias config='source ~/.bash_profile'
