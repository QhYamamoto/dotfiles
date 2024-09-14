#!/bin/bash

source ./bash/_constants.sh

[[ ! -f zenhan.zip ]] || rm zenhan.zip
[[ ! -d zenhan ]] || rm -rf zenhan
curl -fLO https://github.com/iuchim/zenhan/releases/download/v0.0.1/zenhan.zip
unzip zenhan.zip
chmod u+x zenhan/bin64/zenhan.exe
[[ ! -d $(dirname "$ZENHAN_EXE") ]] || copy_item zenhan/bin64/zenhan.exe "$ZENHAN_EXE"
rm zenhan.zip
rm -rf zenhan
