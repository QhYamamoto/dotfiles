#!/bin/bash

WSL_HOME="$HOME"
export WSL_HOME

WIN_HOME=$(wslpath "$(cmd.exe /C 'echo %HOMEDRIVE%%HOMEPATH%' 2>/dev/null | tr -d '\r')")
export WIN_HOME

ZENHAN_EXE="$WIN_HOME/AppData/Local/zenhan.exe"
export ZENHAN_EXE
