#!/bin/bash

$HOME/dotfiles/command/dotfiles init

# If WIN_HOME is not null,
WIN_HOME=$(wslpath "$(cmd.exe /C 'echo %HOMEDRIVE%%HOMEPATH%' 2>/dev/null | tr -d '\r')")
if [[ -n "$WIN_HOME" ]]; then
  $HOME/dotfiles/command/dotfiles ahk
fi

# Set Zsh as default shell
echo "Setting Zsh as default shell. Please enter your password..."
chsh -s $(which zsh)

echo "If authentication fails, please run the following command manually to set Zsh as your default shell: \`chsh -s \$(which zsh)\`."
