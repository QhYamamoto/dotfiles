#!/bin/bash

WIN_HOME=$(wslpath "$(cmd.exe /C 'echo %HOMEDRIVE%%HOMEPATH%' 2>/dev/null | tr -d '\r')")
ZENHAN_EXE="$WIN_HOME/AppData/Local/zenhan.exe"

[[ ! -f zenhan.zip ]] || rm zenhan.zip
[[ ! -d zenhan ]] || rm -rf zenhan
curl -fLO https://github.com/iuchim/zenhan/releases/download/v0.0.1/zenhan.zip
unzip zenhan.zip
chmod u+x zenhan/bin64/zenhan.exe
[[ ! -d $(dirname "$ZENHAN_EXE") ]] || copy_item zenhan/bin64/zenhan.exe "$ZENHAN_EXE"
rm zenhan.zip
rm -rf zenhan
