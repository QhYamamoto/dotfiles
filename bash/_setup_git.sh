#!/bin/bash

source ./bash/_constants.sh

# Create ssh directory if it doesn't exist
[ -d $WSL_HOME/.ssh ] || mkdir "$WSL_HOME/.ssh"

# Setup git config
git config --global core.editor "nvim"

echo "Setting up git."
echo "Please enter your user name:"
read git_user_name
echo "Please enter your email address:"
read git_user_email

git config --global user.name "$git_user_name"
git config --global user.email "$git_user_email"

# Create ssh config file
cat <<EOF >"$WSL_HOME/.ssh/config"
Host github.com
  HostName github.com
  User $git_user_name
  IdentityFile $WSL_HOME/.ssh/github_id_rsa
EOF

# Generate ssh keys
cd "$WSL_HOME/.ssh"
echo "Now, we will set up ssh keys for github. Please name your key file 'github_id_rsa'."
ssh-keygen -t ed25519 -C "$git_user_email"

# Add the private key to the ssh-agent
eval "$(ssh-agent -s)"
ssh-add "$WSL_HOME/.ssh/github_id_rsa"

echo "SSH keys are now set up!! Please add the public key to your github account."
