#!/bin/zsh

autoload -U +X compinit && compinit

_dotfiles() {
  local commands=("init" "update" "git" "ahk")
  compadd "${commands[@]}"
}

compdef _dotfiles dotfiles
