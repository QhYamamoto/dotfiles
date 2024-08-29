#!/bin/zsh

autoload -U +X compinit && compinit
source <(kubectl completion zsh)

_dotfiles() {
  local commands=("init" "update")
  compadd "${commands[@]}"
}

compdef _dotfiles dotfiles
