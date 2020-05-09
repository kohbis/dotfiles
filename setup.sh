#!/bin/bash

usage_exit() {
  echo "Usage: `basename $0` [-d] [-s] [-u]" 1>&2
  exit 1
}

DOT_FILES=(bashrc bash_profile vimrc zshrc tmux.conf)

create_symbolic_link() {
  echo "create symbolic links"
  for file in ${DOT_FILES[@]}; do
    ln -s $HOME/workspace/settings/dotfiles/$file $HOME/.$file
  done
}

remove_symbolic_link() {
  echo "remove symbolic links"
  for file in ${DOT_FILES[@]}; do
    unlink $HOME/.$file
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
