#!/bin/bash

source ./bash/_functions.sh

brew install neovim
verify_package_installation "neovim" "nvim --version"
