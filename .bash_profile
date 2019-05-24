export LANG=ja_JP.UTF-8

export PATH=~/.local/bin:$PATH

#########
# alias #
#########

source ~/workspace/settings/dotfiles/aliases/git_aliases
source ~/workspace/settings/dotfiles/aliases/docker_aliases

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

