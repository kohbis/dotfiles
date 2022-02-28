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
aws_completer='/usr/local/bin/aws_completer'
if [ -f $aws_completer ]; then
  complete -C $aws_completer aws
fi

########
# asdf #
########
asdf_init="/usr/local/opt/asdf/libexec/asdf.sh"
asdf_completer="/usr/local/opt/asdf/etc/bash_completion.d/asdf.bash"
if [ -f $asdf_init ]; then
  . $asdf_init

  if [ -f $asdf_completer ]; then
    . $asdf_completer
  fi
fi

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
git_aliases="${HOME}/workspace/settings/dotfiles/aliases/git_aliases.sh"
if [ -f $git_aliases ]; then
  . $git_aliases
fi

docker_aliases="${HOME}/workspace/settings/dotfiles/aliases/docker_aliases.sh"
if [ -f $docker_aliases ]; then
  . $docker_aliases
fi

terraform_aliases="${HOME}/workspace/settings/dotfiles/aliases/terraform_aliases.sh"
if [ -f $terraform_aliases ]; then
  . $terraform_aliases
fi

# system
alias ls='ls -G'
alias ll='ls -l'
alias l='clear && ls -l'

alias grep='grep --color=auto'

LESS='-g -i -M -R -S -W -z-4 -x4'

# vim, nvim
alias vi='nvim'
# alias vim='nvim'

# tmux
alias tmsc='tmux source ~/.tmux.conf'

#########
# local #
#########
bash_local="${HOME}/workspace/settings/dotfiles/bash_local"
if [ -f $bash_local ]; then
  . $bash_local
fi

