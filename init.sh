#!/bin/bash

# home directories
WSL_HOME="$HOME"
WIN_HOME=$(wslpath "$(cmd.exe /C 'echo %HOMEDRIVE%%HOMEPATH%' 2>/dev/null | tr -d '\r')")

# function to copy files/directories
copy_config() {
  local source="$1"
  local destination="$2"

  if [ -d "$destination" ]; then
    rm -rf "$destination"
    cp -r "$source" "$destination"
  elif [ -f "$destination" ]; then
    rm "$destination"
    cp "$source" "$destination"
  fi

  if [ $? -eq 0 ]; then
    echo "Copied: $source -> $destination"
  else
    echo "Error: Failed to copy from $source to $destination" >&2
  fi
}

# function to create symbolic lin/bashk
create_symlink() {
  local target="$1"
  local link_name="$2"

  # check if link_name directory if the target is directory
  local link_dir=$(dirname "$link_name")
  if [ -d "$target" ] && [ ! -d "$link_dir" ]; then
    mkdir -p "$link_dir"
    echo "Directory created: $link_dir"
  fi

  # remove already existing symlink
  if [ -L "$link_name" ]; then
    rm "$link_name"
  fi

  # create new symlink
  if ln -sfn "$target" "$link_name"; then
    echo "Symlink created: $link_name -> $target"
  else
    echo "Error: Failed to create symlink: $link_name -> $target" >&2
  fi
}

# associative array for config paths
declare -A config_paths=(
  ["$WSL_HOME/dotfiles/.zshrc"]="$WSL_HOME/.zshrc"
  ["$WSL_HOME/dotfiles/zsh/p10k.zsh"]="$WSL_HOME/.p10k.zsh"
  ["$WSL_HOME/dotfiles/.config/nvim"]="$WSL_HOME/.config/nvim"
  ["$WSL_HOME/dotfiles/.config/wezterm"]="$WIN_HOME/.config/wezterm"
)

# Copy configuration files to Windows
for config_path_key in "${!config_paths[@]}"; do
  config_path_value="${config_paths[$config_path_key]}"
  if [[ "$config_path_value" == "$WIN_HOME/"* ]]; then
    # if config_path starts with $WIN_HOME, copy it to windows home directory
    copy_config "$config_path_key" "$config_path_value"
  else
    # else create symbolic link
    create_symlink "$config_path_key" "$config_path_value"
  fi
done
