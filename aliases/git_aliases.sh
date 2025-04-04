#######
# git #
#######

alias gcz='npx git-cz'
alias gitcz='npx git-cz'

_comp_git_add() {
  local __git_cmd_idx=0
  _git_add
}
alias ga='git add'
alias gaa='git add --all'
alias gap='git add --patch'
__git_complete ga  _comp_git_add
__git_complete gaa _comp_git_add
__git_complete gap _comp_git_add

_comp_git_branch() {
  local __git_cmd_idx=0
  _git_branch
}
alias gb='git branch'
alias gba='git branch -a'
__git_complete gb _comp_git_branch
__git_complete gba _comp_git_branch

alias gcmsg='git commit -m'
__git_complete gcmsg _git_commit

# _comp_git_checkout() {
#   local __git_cmd_idx=0
#   _git_checkout
# }
# alias gco='git checkout'
# __git_complete gco _comp_git_checkout

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

_comp_git_status() {
  local __git_cmd_idx=0
  _git_status
}
alias gst='git status -uall'
__git_complete gst _comp_git_status

_comp_git_switch() {
  local __git_cmd_idx=0
  _git_switch
}
alias gsw='git switch'
__git_complete gsw _comp_git_switch
