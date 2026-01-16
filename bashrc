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

  bash_completion='/opt/homebrew/etc/profile.d/bash_completion.sh'
  if [[ -r $bash_completion ]]; then
    . $bash_completion
  fi

  aws_completer="$(brew --prefix)/bin/aws_completer"
  if [ -f $aws_completer ]; then
    complete -C $aws_completer aws
  fi
fi

##############
# completion #
##############
if command -v nerdctl &> /dev/null
then
  source <(nerdctl completion bash)
fi

#########
# local #
#########
export PATH="$HOME/.local/bin:$PATH"

bash_local="${HOME}/.bash_local"
if [ -f $bash_local ]; then
  . $bash_local
fi

########
# bind #
########
if [[ $- == *i* ]]; then
  bind '"\e[A": history-search-backward'
  bind '"\e[B": history-search-forward'
fi

#######
# git #
#######
# macOS (Homebrew)
if [ -f /opt/homebrew/etc/bash_completion.d/git-completion.bash ]; then
  source /opt/homebrew/etc/bash_completion.d/git-completion.bash
fi
if [ -f /opt/homebrew/etc/bash_completion.d/git-prompt.sh ]; then
  source /opt/homebrew/etc/bash_completion.d/git-prompt.sh
fi

# Linux (Ubuntu/Debian)
if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
  source /usr/share/git-core/contrib/completion/git-prompt.sh
fi

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWSTASHSTATE=1

##########
# prompt #
##########
PS1='\[\e[1;31m\]\w\[\e[00m\]\[\e[1;36m\]$(__git_ps1)\[\e[00m\] \[\e[1;32m\]→\[\e[00m\] '
added_prompt_command='history -a; history -c; history -r'
PROMPT_COMMAND="$added_prompt_command;$PROMPT_COMMAND"

#########
# alias #
#########
ALIASES=(git docker)
for a in ${ALIASES[@]}; do
  alias_file="${HOME}/workspace/dotfiles/aliases/${a}_aliases.sh"
  if [ -f $alias_file ]; then
    . $alias_file
  fi
done

# terraform
alias tf='terraform'
# kubernetes
alias k='kubectl'

# system
alias grep='grep --color=auto'
alias ll='ls -l'
alias ls='ls -G'
alias vi='nvim'
alias xargs='xargs '

