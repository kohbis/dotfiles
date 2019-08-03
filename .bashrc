export LANG=ja_JP.UTF-8

export PATH=~/.local/bin:/usr/local/aws/bin:$PATH

complete -C '/usr/local/bin/aws_completer' aws

#######
# env #
#######
HISTSIZE=5000

########
# bind #
########
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

#######
# git #
#######
source /usr/local/etc/bash_completion.d/git-prompt.sh
source /usr/local/etc/bash_completion.d/git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true

__git_not_pushed()
{
  if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]; then
    head="$(git rev-parse HEAD)"
    for x in $(git rev-parse --remotes)
    do
      if [ "$head" = "$x" ]; then
        return 0
      fi
    done
    echo "?"
  fi
  return 0
}

##########
# prompt #
##########
PS1='\[\e[1;32m\]→\[\e[00m\] \[\e[1;31m\]\W\[\e[00m\]\[\e[1;36m\]$(__git_ps1)\[\e[00m\]\[\e[1;36m\]$(__git_not_pushed)\[\e[00m\] '

#########
# alias #
#########

source ~/workspace/settings/dotfiles/aliases/git_aliases
source ~/workspace/settings/dotfiles/aliases/docker_aliases

# system
alias ls='ls -G'
alias ll='ls -lh'

alias histgrep="history | grep"

LESS='-i -M -R'

# bash
alias vbr='vi ~/.bashrc'
alias sbr='source ~/.bashrc'
alias vbp='vi ~/.bash_profile'
alias sbp='source ~/.bash_profile'

# tmux
alias tmsc='tmux source ~/.tmux.conf'

# ssh
alias ssh-pi='ssh pi@raspberrypi'

# brew
alias bupd='brew update'
alias bupg='brew upgrade'
alias bcupg='brew cask upgrade'
