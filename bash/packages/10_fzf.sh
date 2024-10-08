#!/bin/bash

source ./bash/_constants.sh

git clone --depth=1 https://github.com/junegunn/fzf.git "$WSL_HOME"/.fzf
~/.fzf/install --all
