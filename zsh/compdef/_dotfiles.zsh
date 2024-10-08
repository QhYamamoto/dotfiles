#!/bin/zsh

autoload -U +X compinit && compinit
source <(kubectl completion zsh)

_dotfiles() {
  local commands=("init" "update" "git")
  compadd "${commands[@]}"
}

compdef _dotfiles dotfiles
