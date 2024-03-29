#!/bin/bash

usage_exit() {
  echo "Usage: `basename $0` [-d] remove [-s] create [-u] recreate symlinks" 1>&2
  exit 1
}

DOT_FILES=(
  bash_local
  bash_profile
  bashrc
  clang-format
  config/nvim/init.lua
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
    if [ -f "$HOME/.$file" ]; then
      echo "[-] .$file"
    else
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

while getopts dsu OPT
do
  case $OPT in
    "d" ) remove_symbolic_link ;;
    "u" ) recreate_symbolic_link ;;
    "s" ) create_symbolic_link ;;
    * ) usage_exit ;;
  esac
done

echo "finish!"
