#!/bin/bash

source ./bash/_constants.sh
source ./bash/_functions.sh

echo "We'll setup AutoHotKey on Windows. Please kill all AutoHotKey processes before continuing."
read -p "Press any key to continue..."

[ -d "$WIN_HOME/.ahk" ] && rm -rf "$WIN_HOME/.ahk"
copy_item "$WSL_HOME/dotfiles/ahk" "$WIN_HOME/.ahk"

if verify_package_installation "curl" "curl --version"; then
  sudo apt update -qq && sudo apt install -yqq curl
fi

# lsp
[ -d "$WSL_HOME/vscode-autohotkey2-lsp" ] && rm -rf "$WSL_HOME/vscode-autohotkey2-lsp"
mkdir "$WSL_HOME/vscode-autohotkey2-lsp"
cd "$WSL_HOME/vscode-autohotkey2-lsp"
curl -L -o install.js https://raw.githubusercontent.com/thqby/vscode-autohotkey2-lsp/main/tools/install.js
node install.js
rm install.js
cd "$WSL_HOME/dotfiles"

# Install AutoHotkey v1/v2
ahk_dir="$WIN_HOME/.ahk"
mkdir "$ahk_dir/App"
curl -L -o ahk-v1.zip https://www.autohotkey.com/download/1.1/AutoHotkey_1.1.37.02.zip
unzip ahk-v1.zip -d "$ahk_dir/App/v1"
rm ahk-v1.zip
curl -L -O https://www.autohotkey.com/download/ahk-v2.zip
unzip ahk-v2.zip -d "$ahk_dir/App/v2"
rm ahk-v2.zip

# MouseGestureL
curl -L -O https://ss1.xrea.com/pyonkichi.g1.xrea.com/archives/MGLahk140.zip
unzip MGLahk140.zip -d "$ahk_dir/MouseGestureL"
rm MGLahk140.zip

# create Batch file that is to be placed to startup directory
startup_ahk_bat_path="$ahk_dir/startup_ahk.bat"
ahk_dir=${ahk_dir/"/mnt/c/"/"C:/"}
touch "$startup_ahk_bat_path"
echo "
  powershell -Command \"Start-Process '$ahk_dir/App/v2/AutoHotkey64.exe' -ArgumentList '$ahk_dir/main.ahk' -Verb RunAs\"
  start \"\" /B \"$ahk_dir/App/v1/AutoHotkeyU64.exe\" \"$ahk_dir/MouseGestureL/MouseGestureL.ahk\"
" >"$startup_ahk_bat_path"
