#!/bin/bash

# Install pwsh command
sudo apt-get update
wget https://mirror.it.ubc.ca/ubuntu/pool/main/i/icu/libicu72_72.1-3ubuntu3_amd64.deb
sudo dpkg -i libicu72_72.1-3ubuntu3_amd64.deb
sudo apt-get install -y wget
wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.5/powershell_7.4.5-1.deb_amd64.deb
sudo dpkg -i powershell_7.4.5-1.deb_amd64.deb
sudo apt-get install -f
rm powershell_7.4.5-1.deb_amd64.deb

# Download PowershellEditorServices
curl -fLO https://github.com/PowerShell/PowerShellEditorServices/releases/download/v3.20.1/PowerShellEditorServices.zip
unzip PowerShellEditorServices.zip -d "$HOME"
rm PowerShellEditorServices.zip
