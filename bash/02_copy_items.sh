#!/bin/bash

source ./bash/_constants.sh
source ./bash/_functions.sh

# Associative array for config paths that will be copied
declare -A copy_paths=(
  ["$WSL_HOME/dotfiles/config/wezterm"]="$WIN_HOME/.config/wezterm"
  ["$WSL_HOME/dotfiles/ahk"]="$WIN_HOME/.ahk"
)

# Copy configuration files to Windows for each entry in copy_paths
for config_path_key in "${!copy_paths[@]}"; do
  config_path_value="${copy_paths[$config_path_key]}"
  copy_item "$config_path_key" "$config_path_value"
done
