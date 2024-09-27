#!/bin/bash

source ./bash/_functions.sh

curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

verify_package_installation "zoxide" "zoxide --version"
