export LANG=ja_JP.UTF-8

export PATH=~/.local/bin:$PATH

#######
# git #
#######
source /usr/local/etc/bash_completion.d/git-prompt.sh
source /usr/local/etc/bash_completion.d/git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true

##########
# prompt #
##########
PS1='\[\e[1;32m\]→\[\e[0m\] \[\e[1;31m\]\W\[\e[0m\]\[\e[0;36m$(__git_ps1)\[\e[0m\] '

#########
# alias #
#########

source ~/workspace/settings/dotfiles/aliases/git_aliases
source ~/workspace/settings/dotfiles/aliases/docker_aliases

# system
alias ls='ls -G'
alias ll='ls -lh'

LESS='-i -M -R'

# bash
alias vbr='vi ~/.bashrc'
alias sbr='source ~/.bashrc'
alias vbp='vi ~/.bash_profile'
alias sbp='source ~/.bash_profile'

# tmux
alias tmsc='tmux source ~/.tmux.conf'

# ssh
alias ssh-pi='ssh pi@192.168.179.3'

# brew
alias bupd='brew update'

