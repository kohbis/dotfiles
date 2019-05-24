export LANG=ja_JP.UTF-8

export PATH=~/.local/bin:$PATH

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
alias drm_run='dcl -a | grep run | cut -d" " -f1 | xargs docker rm'

alias dlt='docker logs -t'
alias dlf='docker logs -f'


# system
alias ll='ls -l'

# bash
alias vbp='vi ~/.bash_profile'
alias sbp='source ~/.bash_profile'

# tmux
alias tmsc='tmux source ~/.tmux.conf'

# ssh
alias ssh-pi='ssh pi@192.168.179.3'

# brew
alias bupd='brew update'

