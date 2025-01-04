#!/bin/bash

scripts_dir="./bash"

# Get the current user's username
USER_NAME=$(whoami)

# Create a backup of the sudoers file
sudo cp /etc/sudoers /etc/sudoers.bak

# Add the current user to the sudoers file
echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo

my-cli-tool init

# If WIN_HOME is not null,
WIN_HOME=$(wslpath "$(cmd.exe /C 'echo %HOMEDRIVE%%HOMEPATH%' 2>/dev/null | tr -d '\r')")
if [[ -n "$WIN_HOME" ]]; then
  my-cli-tool ahk
fi

# Set Zsh as default shell
echo "Setting Zsh as default shell. Please enter your password..."
chsh -s $(which zsh)

echo "If authentication fails, please run the following command manually to set Zsh as your default shell: \`chsh -s \$(which zsh)\`."

# restore original sudoers file
sudo cp /etc/sudoers.bak /etc/sudoers
sudo chmod 0440 /etc/sudoers
