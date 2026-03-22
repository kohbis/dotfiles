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
  git-cz.json
  rufo
  sqlfluff
  tmux.conf
  vimrc
  zshrc
)
CONFIG_TOOLS=(nvim)
CLAUDE_SUBDIRS=(commands skills templates)
DOTFILES_DIR=$HOME/workspace/dotfiles
DOTFILES_PRIVATE_DIR=$HOME/workspace/dotfiles/dotfiles-private

link_config_files() {
  local tool=$1
  local src_dir="$DOTFILES_DIR/config/$tool"
  local target_dir="$HOME/.config/$tool"

  [ -d "$src_dir" ] || return

  mkdir -p "$target_dir"
  for src in "$src_dir"/*; do
    local name=$(basename "$src")
    local dst="$target_dir/$name"
    if [ -e "$dst" ]; then
      echo "[-] .config/$tool/$name"
    else
      ln -s "$src" "$dst"
      echo "[v] .config/$tool/$name"
    fi
  done
}

unlink_config_files() {
  local tool=$1
  local src_dir="$DOTFILES_DIR/config/$tool"
  local target_dir="$HOME/.config/$tool"

  [ -d "$src_dir" ] || return

  for src in "$src_dir"/*; do
    local name=$(basename "$src")
    local dst="$target_dir/$name"
    if [ -L "$dst" ]; then
      unlink "$dst"
      echo "[v] .config/$tool/$name"
    else
      echo "[-] .config/$tool/$name"
    fi
  done
}

link_claude_files() {
  local src_dir=$1
  local subdir=$2
  local target_dir=$HOME/.claude/$subdir

  [ -d "$src_dir/claude/$subdir" ] || return

  mkdir -p "$target_dir"
  for src in "$src_dir/claude/$subdir"/*; do
    local name=$(basename "$src")
    local dst="$target_dir/$name"
    if [ -e "$dst" ]; then
      echo "[-] .claude/$subdir/$name"
    else
      ln -s "$src" "$dst"
      echo "[v] .claude/$subdir/$name"
    fi
  done
}

unlink_claude_files() {
  local src_dir=$1
  local subdir=$2
  local target_dir=$HOME/.claude/$subdir

  [ -d "$src_dir/claude/$subdir" ] || return

  for src in "$src_dir/claude/$subdir"/*; do
    local name=$(basename "$src")
    local dst="$target_dir/$name"
    if [ -L "$dst" ]; then
      unlink "$dst"
      echo "[v] .claude/$subdir/$name"
    else
      echo "[-] .claude/$subdir/$name"
    fi
  done
}

create_symbolic_link() {
  echo "create symbolic links. [v] created [-] already exists"

  for file in ${DOT_FILES[@]}; do
    if [ -e "$HOME/.$file" ]; then
      echo "[-] .$file"
    else
      mkdir -p "$(dirname "$HOME/.$file")"
      ln -s $DOTFILES_DIR/$file $HOME/.$file
      echo "[v] .$file"
    fi
  done

  for tool in ${CONFIG_TOOLS[@]}; do
    link_config_files "$tool"
  done

  for subdir in ${CLAUDE_SUBDIRS[@]}; do
    link_claude_files "$DOTFILES_DIR" "$subdir"
    if [ -d "$DOTFILES_PRIVATE_DIR" ]; then
      link_claude_files "$DOTFILES_PRIVATE_DIR" "$subdir"
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

  for tool in ${CONFIG_TOOLS[@]}; do
    unlink_config_files "$tool"
  done

  for subdir in ${CLAUDE_SUBDIRS[@]}; do
    unlink_claude_files "$DOTFILES_DIR" "$subdir"
    if [ -d "$DOTFILES_PRIVATE_DIR" ]; then
      unlink_claude_files "$DOTFILES_PRIVATE_DIR" "$subdir"
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
