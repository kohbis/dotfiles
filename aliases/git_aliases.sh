#######
# git #
#######

alias ga='git add'
alias gaa='git add --all'
alias gap='git add --patch'
__git_complete ga _git_add
__git_complete gaa _git_add
__git_complete gap _git_add

alias gb='git branch'
alias gba='git branch -a'
__git_complete gb _git_branch
__git_complete gba _git_branch

alias gcl='git clone --recurse-submodules'
__git_complete gcl _git_clone

alias gcmsg='git commit -m'
alias gcam='git commit --amend'
__git_complete gcmsg _git_commit

alias gco='git checkout'
__git_complete gco _git_checkout

alias gd='git diff'
alias gdc='git diff --cached'
__git_complete gd _git_diff
__git_complete gdc _git_diff

alias gf='git fetch'
__git_complete gf _git_fetch

alias glg='git log --stat'
alias glgg='git log --stat --graph'
__git_complete glg _git_log
__git_complete glgg _git_log

alias gpsup='git push --set-upstream origin `git symbolic-ref --short HEAD`'
__git_complete gpsup _git_push

alias grhh='git reset --hard HEAD'
__git_complete grh _git_reset
__git_complete grhh _git_reset

alias gsho='git show'
__git_complete gsho _git_show

alias gst='git status -uall'
__git_complete gst _git_status
