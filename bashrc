export LANG=ja_JP.UTF-8

#######
# env #
#######
HISTSIZE=5000

########
# brew #
########
homebrew='/opt/homebrew/bin/brew'
if [ -f $homebrew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

##############
# completion #
##############
bash_complation="$(brew --prefix)/etc/bash_completion"
if [ -f $bash_completion ]; then
  . $bash_completion
fi

########
# bind #
########
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

#######
# aws #
#######
aws_completer="$(brew --prefix)/bin/aws_completer"
if [ -f $aws_completer ]; then
  complete -C $aws_completer aws
fi

########
# asdf #
########
asdf_init="$(brew --prefix asdf)/libexec/asdf.sh"
asdf_completer="$(brew --prefix asdf)/etc/bash_completion.d/asdf.bash"
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
PS1='\[\e[1;31m\]\w\[\e[00m\]\[\e[1;36m\]$(__git_ps1)\[\e[00m\] \[\e[1;32m\]→\[\e[00m\] '

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
alias grep='grep --color=auto'
alias l='clear && ls -l'
alias ll='ls -l'
alias ls='ls -G'
alias tmsc='tmux source ~/.tmux.conf'
alias vi='nvim'
alias xargs='xargs '

#########
# local #
#########
bash_local="${HOME}/workspace/settings/dotfiles/bash_local"
if [ -f $bash_local ]; then
  . $bash_local
fi

if command -v nerdctl &> /dev/null
then
  source <(nerdctl completion bash)
fi
