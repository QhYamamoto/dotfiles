#!/bin/bash

export WIN_HOME=$(wslpath "$(cmd.exe /C 'echo %HOMEDRIVE%%HOMEPATH%' 2>/dev/null | tr -d '\r')")
export ZENHAN_EXE="$WIN_HOME/AppData/Local/zenhan.exe"

# execute zenhan.exe on Windows machine
$ZENHAN_EXE 0 > /tmp/output 2>&1
