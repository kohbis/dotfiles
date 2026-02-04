#!/bin/bash

usage_exit() {
  echo "Usage: `basename $0` [-c] create [-d] delete [-r] recreate symlinks" 1>&2
  exit 1
}

DOT_FILES=(
  bash_local
  bash_profile
  bashrc
  clang-format
  config/nvim/init.lua
  claude/commands
  claude/skills
  git-cz.json
  rufo
  sqlfluff
  tmux.conf
  vimrc
  zshrc
)
CONFIG_DIR=(nvim)

create_symbolic_link() {
  echo "create symbolic links. [v] created [-] already exists"

  for dir in ${CONFIG_DIR[@]}; do
    mkdir -p $HOME/.config/$dir
  done

  for file in ${DOT_FILES[@]}; do
    if [ -e "$HOME/.$file" ]; then
      echo "[-] .$file"
    else
      mkdir -p "$(dirname "$HOME/.$file")"
      ln -s $HOME/workspace/dotfiles/$file $HOME/.$file
      echo "[v] .$file"
    fi
  done
}

remove_symbolic_link() {
  echo "remove symbolic links. [v] removed [-] no file"
  for file in ${DOT_FILES[@]}; do
    if [ -L "$HOME/.$file" ]; then
      unlink $HOME/.$file
      echo "[v] .$file"
    else
      echo "[-] .$file"
    fi
  done
}

recreate_symbolic_link() {
  echo "recreate symbolick links"
  remove_symbolic_link
  create_symbolic_link
}

if [ $# -ne 1 ]; then
  usage_exit
fi

while getopts cdr OPT
do
  case $OPT in
    "c" ) create_symbolic_link ;;
    "d" ) remove_symbolic_link ;;
    "r" ) recreate_symbolic_link ;;
    * ) usage_exit ;;
  esac
done

echo "finish!"
