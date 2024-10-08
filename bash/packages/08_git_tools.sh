#!/bin/bash

source ./bash/_constants.sh

mkdir -p "$WSL_HOME/.zsh"

# git-completion
curl -o "$WSL_HOME"/.zsh/git-completion.sh \
  https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh

# git-prompt
curl -o "$WSL_HOME"/.zsh/git-prompt.sh \
  https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

# git-delta
brew install git-delta
