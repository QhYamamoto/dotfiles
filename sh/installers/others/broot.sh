#!/bin/bash

sudo curl -L https://dystroy.org/broot/download/x86_64-linux/broot -o /usr/bin/broot
sudo chmod +x /usr/bin/broot

# Set br cmd install state to `refused`
broot --set-install-state refused
