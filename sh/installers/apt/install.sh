#!/bin/bash

sudo apt update -yqq
sudo apt install -yqq $(cat "$(dirname $0)"/packages)
