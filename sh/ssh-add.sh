eval "$(ssh-agent -s)"
ssh-add "$HOME/.ssh/$1"
