#!/bin/bash

NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo apt-get install -yqq build-essential
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

brew tap $(cat "$(dirname $0)"/tap)
brew install $(cat "$(dirname $0)"/formula)
