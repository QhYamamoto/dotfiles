#!/bin/bash

source ./bash/_constants.sh
source ./bash/_functions.sh

# Associative array for config paths that will be symlinked
declare -A symlink_paths=(
  ["$WSL_HOME/dotfiles/.zshrc"]="$WSL_HOME/.zshrc"
  ["$WSL_HOME/dotfiles/zsh/p10k.zsh"]="$WSL_HOME/.p10k.zsh"
  ["$WSL_HOME/dotfiles/zsh/zenhan.zsh"]="$WSL_HOME/.zenhan.zsh"
  ["$WSL_HOME/dotfiles/.config/lazygit"]="$WSL_HOME/.config/lazygit"
  ["$WSL_HOME/dotfiles/.config/lazydocker"]="$WSL_HOME/.config/lazydocker"
)

# Create symbolic links for each entry in symlink_paths
for config_path_key in "${!symlink_paths[@]}"; do
  config_path_value="${symlink_paths[$config_path_key]}"
  create_symlink "$config_path_key" "$config_path_value"
done
