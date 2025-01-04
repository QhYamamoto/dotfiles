#!/bin/bash

mkdir -p "$HOME/.zsh"

# git-completion
curl -o "$HOME"/.zsh/git-completion.sh \
  https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh

# git-prompt
curl -o "$HOME"/.zsh/git-prompt.sh \
  https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

# git-delta
brew install git-delta
