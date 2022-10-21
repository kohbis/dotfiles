##########
# Docker #
##########

# alias datt='docker attach'
# alias dbuild='docker build'
# alias dcbuild='docker-compose build'
# alias dcexec='docker-compose exec'
# alias dcl='docker container ls'
# alias dcla='docker container ls -a'
# alias dclf='docker-compose logs -f'
# alias dclt='docker-compose logs -t'
# alias dcps='docker-compose ps'
# alias dcrestart='docker-compose restart'
# alias dcrun='docker-compose run'
# alias dcstart='docker-compose start'
# alias dcstop='docker-compose stop'
# alias dcup='docker-compose up'
# alias dexec='docker exec'
# alias dims='docker images'
# alias dlf='docker logs -f'
# alias dlt='docker logs -t'
# alias dnw='docker network'
# alias dps='docker ps'
# alias dpull='docker pull'
# alias drestart='docker restart'
# alias drm='docker rm'
# alias drmi='docker rmi'
# alias drun='docker run'
# alias dstart='docker start'
# alias dstop='docker stop'
# alias dvol='docker volume'
alias drm_run='dcl -a | grep -F "_run_" | cut -d" " -f1 | xargs docker rm'
alias drmi_none='docker images | grep -F "<none>" | awk '\''{ print $3 }'\'' | xargs docker rmi'

