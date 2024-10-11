#!/bin/zsh

autoload -U +X compinit && compinit
_dotfiles() {
  _arguments -w \
    '1:command:->command' \
    '*::options:->options'

  if [[ $state == command ]]; then
    _values \
      "commands" \
      "init" \
      "update" \
      "git" \
      "ahk"
    return 0
  fi

  if [[ $state == options && $words[1] == "git" ]]; then
    _values -w \
      "options" \
      "--overwrite-global-config"
    return 0;
  fi
}

compdef _dotfiles dotfiles
