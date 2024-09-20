#!/bin/bash

source ./bash/_functions.sh

brew tap jorgerojas26/lazysql
brew install lazysql

verify_package_installation "lazysql" "lazysql --version"
