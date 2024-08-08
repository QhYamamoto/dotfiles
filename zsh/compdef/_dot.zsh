#!/bin/zsh

autoload -U +X compinit && compinit
source <(kubectl completion zsh)

_dot() {
    local commands=("init" "update")
    compadd "${commands[@]}"
}

compdef _dot dot
