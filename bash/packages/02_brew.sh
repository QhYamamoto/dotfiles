#!/bin/bash

source ./bash/_constants.sh
source ./bash/_functions.sh

NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo apt-get install -yqq build-essential
brew install gcc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

verify_package_installation "brew" "brew --version"
