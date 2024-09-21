#!/bin/zsh

extensions=("jpg" "jpeg" "png" "gif" "tiff" "ico" "bmp")

file_ext="${1##*.}"

if [[ " ${extensions[@]} " =~ " ${file_ext} " ]]; then
  # Open file by host machine's default viewer.
  wslview "$1"
else
  # Open file by currently opened neovim.
  nvr -l "$1"
fi
