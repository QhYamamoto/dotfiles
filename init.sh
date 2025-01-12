#!/bin/bash

$HOME/dotfiles/command/dotfiles init

# If WIN_HOME is not null, install ahk on Windows machine.
WIN_HOME=$(wslpath "$(cmd.exe /C 'echo %HOMEDRIVE%%HOMEPATH%' 2>/dev/null | tr -d '\r')")
if [[ -n "$WIN_HOME" ]]; then
  $HOME/dotfiles/command/dotfiles ahk
fi
