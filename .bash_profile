export LANG=ja_JP.UTF-8

export PATH=~/.local/bin:$PATH

# Node.js
export PATH=$HOME/.nodebrew/current/bin:$PATH
export NODE_PATH=/usr/local/lib/node_modules

# Python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
if which pyenv > /dev/null; then 
    eval "$(pyenv init -)";
fi

# Ruby
export PATH="$HOME/.rbenv/shims:$PATH"
eval "$(rbenv init -)"

# Java
export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
export PATH=$JAVA_HOME/bin:$PATH

# Go
export PATH=$PATH:/usr/local/opt/go/libexec/bin

# Rust
export PATH=$PATH:$HOME/.cargo/env
export PATH="$HOME/.cargo/bin:$PATH"


#########
# alias #
#########
# Docker
alias vdfile='vi Dockerfile'
alias vdcyml='vi docker-compose.yml'
alias cdfile='code Dockerfile'
alias cdcyml='code docker-compose.yml'

alias dps='docker ps'
alias dcps='docker-compose ps'

alias dims='docker images'
alias dimp='docker image prune'
alias dcl='docker container ls'
alias drm='docker rm'
alias drmi='docker rmi'

alias dbuild='docker build'
alias dcbuild='docker-compose build'

alias drun='docker run'
alias dcrun='docker-compose run'

alias dexec='docker exec'
alias dcexec='docker-compose exec'

alias dstart='docker start'
alias dstop='docker stop'
alias dcstart='docker-compose start'
alias dcstop='docker-compose stop'
alias dcrestart='docker-compose restart'

alias d-c='docker-compose'
alias dcup='docker-compose up'

alias datt='docker attach'

alias drmi_none='docker images | grep -F "<none>" | awk '\''{ print "docker rmi "$3 }'\'''

# system
alias ll='ls -l'

alias vbp='vi ~/.bash_profile'
alias sbp='source ~/.bash_profile'

# ssh
alias ssh-pi='ssh pi@192.168.179.3'

# brew
alias bupd='brew update'

# if [ -f $HOME/bin/welcome ]; then
#     . $HOME/bin/welcome
# fi

