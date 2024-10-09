#!/bin/bash

source ./bash/_constants.sh

scripts_dir="./bash"

# Get the current user's username
USER_NAME=$(whoami)

# Create a backup of the sudoers file
sudo cp /etc/sudoers /etc/sudoers.bak

# Add the current user to the sudoers file
echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo

mapfile -t scripts < <(find "$scripts_dir" -type f -name "*.sh" | sort)

for script in "${scripts[@]}"; do
  base_name=$(basename "$script")

  # Check if the base name starts with two digits
  if [[ $base_name =~ ^[0-9]{2} ]]; then
    source "$script"
  fi
done

# If WIN_HOME is not null,
if [[ -n "$WIN_HOME" ]]; then
  source ./bash/_setup_ahk.sh
fi

# Set Zsh as default shell
echo "We are about to set Zsh as your default shell. Please enter your password."
chsh -s $(which zsh)

echo "If authentication fails, please run the following command manually to set Zsh as your default shell: \`chsh -s \$(which zsh)\`."

# restore original sudoers file
sudo cp /etc/sudoers.bak /etc/sudoers
sudo chmod 0440 /etc/sudoers
