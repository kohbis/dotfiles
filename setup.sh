#!/bin/bash

DOT_FILES=(.bashrc .bash_profile .vimrc .zshrc)

for file in ${DOT_FILES[@]}; do
  ln -s $HOME/workspace/settings/dotfiles/$file $HOME/$file
done

