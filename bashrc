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
bash_completion="$(brew --prefix)/etc/bash_completion"
if [ -f $bash_completion ]; then
  . $bash_completion
fi

if command -v nerdctl &> /dev/null
then
  source <(nerdctl completion bash)
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
PS1='\[\e[1;31m\]\h:\w\[\e[00m\]\[\e[1;36m\]$(__git_ps1)\[\e[00m\] \[\e[1;32m\]→\[\e[00m\] '

#########
# alias #
#########
ALIASES=(
  git
  docker
  terraform
)
for a in ${ALIASES[@]}; do
  alias_file="${HOME}/workspace/settings/dotfiles/aliases/${a}_aliases.sh"
  if [ -f $alias_file ]; then
    . $alias_file
  fi
done

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
bash_local="${HOME}/.bash_local"
if [ -f $bash_local ]; then
  . $bash_local
fi
