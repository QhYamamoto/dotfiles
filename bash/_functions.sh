#!/bin/bash

# Function: copy_item
# Description: Copies a file or directory from the source to the destination.
#              If the destination exists, it will be removed first.
# Arguments:
#   $1 - Source file or directory
#   $2 - Destination file or directory
copy_item() {
  local source="$1"
  local destination="$2"

  # Remove the destination if it already exists
  if [ -d "$destination" ]; then
    rm -rf "$destination"
  elif [ -f "$destination" ]; then
    rm "$destination"
  fi

  # Copy the source to the destination
  if [ -d "$source" ]; then
    cp -r "$source" "$destination"
  elif [ -f "$source" ]; then
    cp "$source" "$destination"
  fi

  # Check if the copy command was successful
  if [ $? -eq 0 ]; then
    echo "Copied: $source -> $destination"
  else
    echo "Error: Failed to copy from $source to $destination"
    exit 1
  fi
}

# Function: create_symlink
# Description: Creates a symbolic link from the target to the link_name.
#              If the link_name already exists, it will be removed first.
# Arguments:
#   $1 - Target file or directory
#   $2 - Link name for the symbolic link
create_symlink() {
  local target="$1"
  local link_name="$2"

  # Ensure the directory for the symlink exists if the target is a directory
  local link_dir=$(dirname "$link_name")
  if [ -d "$target" ] && [ ! -d "$link_dir" ]; then
    mkdir -p "$link_dir"
    echo "Directory created: $link_dir"
  fi

  # Remove the existing symlink if it exists
  if [ -L "$link_name" ]; then
    rm "$link_name"
  fi

  # Create a new symbolic link
  if ln -sfn "$target" "$link_name"; then
    echo "Symlink created: $link_name -> $target"
  else
    echo "Error: Failed to create symlink: $link_name -> $target"
    exit 1
  fi
}

# Function: verify_package_installation
# Description: Verifies if a given package is installed by running a specified verification command.
#              If the package is not found, it outputs an error and exits.
# Arguments:
#   $1 - The name of the package to verify (used for logging purposes).
#   $2 - The command to verify if the package is installed (e.g., 'which package_name' or 'command --version').
# Notes:
#   - If no verification command is provided, the function will skip the check.
#   - If the verification command outputs "command not found", the function assumes the package is not installed.
verify_package_installation() {
  local package_name="$1"
  local verification_cmd="$2"

  # Skip the check if the verification command is not provided
  if [ -z "$verification_cmd" ]; then
    continue
  fi

  # Execute the verification command and capture the output
  output=$($verification_cmd 2>&1)

  # Check if the output contains "command not found"
  if [[ "$output" != *"command not found"* ]]; then
    echo "The package '$package_name' installed successfully."
  else
    echo "Error: The package '$package_name' isn't installed."
    exit 1
  fi
}
