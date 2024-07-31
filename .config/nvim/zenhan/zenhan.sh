#!/bin/bash

source ~/.config/nvim/zenhan/.env

EXE_PATH="$WINDOWS_HOME_DIR/AppData/Local/Temp/zenhan.exe"

# copy zenhan.exe to Windows temp directory
cp ~/.config/nvim/zenhan/zenhan.exe $EXE_PATH

# execute copied exe file
$EXE_PATH 0 > /tmp/output 2>&1

# remove temp exe file after execution
rm $EXE_PATH
