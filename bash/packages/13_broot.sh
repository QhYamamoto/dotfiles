#!/bin/bash

source ./bash/_functions.sh

sudo curl -L https://dystroy.org/broot/download/x86_64-linux/broot -o /usr/bin/broot
sudo chmod +x /usr/bin/broot

verify_package_installation "broot" "broot --version"
