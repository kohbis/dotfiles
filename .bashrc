export LANG=ja_JP.UTF-8

#######
# env #
#######
HISTSIZE=5000

##############
# completion #
##############
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

########
# bind #
########
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

#######
# aws #
#######
complete -C '/usr/local/bin/aws_completer' aws

#######
# git #
#######
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWSTASHSTATE=1

##########
# prompt #
##########
PS1='\[\e[1;31m\]\W\[\e[00m\]\[\e[1;36m\]$(__git_ps1)\[\e[00m\] \[\e[1;32m\]→\[\e[00m\] '

#########
# alias #
#########
source $HOME/workspace/settings/dotfiles/aliases/git_aliases.sh
source $HOME/workspace/settings/dotfiles/aliases/docker_aliases.sh
source $HOME/workspace/settings/dotfiles/aliases/terraform_aliases.sh

# system
alias ls='ls -G'
alias ll='ls -l'

LESS='-i -M -R'

# bash
alias sbp='source ~/.bash_profile'

# tmux
alias tmsc='tmux source ~/.tmux.conf'

# ssh
alias ssh-pi='ssh pi@raspberrypi'

