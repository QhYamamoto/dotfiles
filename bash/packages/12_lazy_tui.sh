#!/bin/bash

# lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

# lazydocker
brew install jesseduffield/lazydocker/lazydocker

# lazysql
source ./bash/_functions.sh

brew tap jorgerojas26/lazysql
brew install lazysql

verify_package_installation "lazysql" "lazysql --version"
