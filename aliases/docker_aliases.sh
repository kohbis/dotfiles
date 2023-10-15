##########
# Docker #
##########

alias drm_run='dcl -a | grep -F "_run_" | cut -d" " -f1 | xargs docker rm'
alias drmi_none='docker images | grep -F "<none>" | awk '\''{ print $3 }'\'' | xargs docker rmi'

