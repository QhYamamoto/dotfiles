#!/bin/bash

source ./bash/_functions.sh

pip3 install neovim-remote
verify_package_installation "nvr" "nvr --version"
