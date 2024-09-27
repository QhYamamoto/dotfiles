#!/bin/bash

source ./bash/_constants.sh
source ./bash/_functions.sh

# FIXME:
mkdir "$WSL_HOME/.config/broot"

# Associative array for config paths that will be symlinked
declare -A symlink_paths=(
  ["$WSL_HOME/dotfiles/.zshrc"]="$WSL_HOME/.zshrc"
  ["$WSL_HOME/dotfiles/zsh/p10k.zsh"]="$WSL_HOME/.p10k.zsh"
  ["$WSL_HOME/dotfiles/zsh/zenhan.zsh"]="$WSL_HOME/.zenhan.zsh"
  ["$WSL_HOME/dotfiles/config/broot/config.toml"]="$WSL_HOME/.config/broot/config.toml"
  ["$WSL_HOME/dotfiles/config/broot/open_file.sh"]="$WSL_HOME/.config/broot/open_file.sh"
  ["$WSL_HOME/dotfiles/config/lazygit"]="$WSL_HOME/.config/lazygit"
  ["$WSL_HOME/dotfiles/config/lazydocker"]="$WSL_HOME/.config/lazydocker"
  ["$WSL_HOME/dotfiles/config/nvim"]="$WSL_HOME/.config/nvim"
)

# Create symbolic links for each entry in symlink_paths
for config_path_key in "${!symlink_paths[@]}"; do
  config_path_value="${symlink_paths[$config_path_key]}"
  create_symlink "$config_path_key" "$config_path_value"
done
