#!/bin/zsh

# Check options
overwrite_config=false
for arg in "$@"; do
  if [[ $arg == "--overwrite-global-config" ]]; then
    overwrite_config=true
  fi
done

# Create ssh directory if it doesn't exist
[ -d $HOME/.ssh ] || mkdir "$HOME/.ssh"

# Setup git config
git config --global core.editor "nvim"

echo "Setting up git..."
read -p "Please enter Host:" git_host
read -p "Please enter your user name:" git_user_name
read -p "Please enter your email address:" git_user_email
read -p "Please enter ssh key pair name:" git_key_pair_name

if [[ $overwrite_config == true ]]; then
  git config --global user.name "$git_user_name"
  git config --global user.email "$git_user_email"
fi

# Create ssh config file if it doesn't exist
[ -f "$HOME/.ssh/config" ] || touch "$HOME/.ssh/config"

# Add Host to ssh config file
cat <<EOF >>"$HOME/.ssh/config"
Host $git_host
  HostName $git_host
  User $git_user_name
  IdentityFile $HOME/.ssh/$git_key_pair_name
EOF

# Generate ssh keys
cd "$HOME/.ssh"
ssh-keygen -t ed25519 -C "$git_user_email" -f "$git_key_pair_name"

# Add the private key to the ssh-agent
eval "$(ssh-agent -s)"
ssh-add "$HOME/.ssh/$git_key_pair_name"

# Copy generated public key to the system clipboard.
cat "$HOME/.ssh/$git_key_pair_name.pub" | xsel --clipboard --input

echo "SSH keys are now set up and public key is copied to your clipboard!! Please add it to your git service account."
