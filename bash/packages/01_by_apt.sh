#!/bin/bash

source ./bash/_constants.sh
source ./bash/_functions.sh

declare -A packages=(
  ["bat"]="ln -s /usr/bin/batcat $WSL_HOME/.local/bin/bat && bat --version"
  ["curl"]="curl --version"
  ["fd-find"]="ln -s $(which fdfind) $WSL_HOME/.local/bin/fd && fd --version"
  ["lua5.4"]="lua -v"
  ["liblua5.4-dev"]=""
  ["git"]="git --version"
  ["npm"]="npm --version"
  ["ripgrep"]="rg --version"
  ["xsel"]="xsel --version"
  ["yarn"]="yarn --version"
  ["zsh"]="zsh -version"
  ["zsh-autosuggestions"]=""
  ["zsh-syntax-highlighting"]=""
  ["python3-pip"]="pip3 --version"
  ["unzip"]="unzip -v"
)

IFS=" "

for package_name in "${!packages[@]}"; do
  sudo apt update -qq && sudo apt install -y $package_name
  verification_cmd=${packages[$package_name]}
  verify_package_installation "$package_name" "$verification_cmd"
done
