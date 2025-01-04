#!/bin/bash

local fonts_dir="$HOME/.fonts"
local font_zip_name="0xProto_2_100.zip"
curl -fLO "https://github.com/0xType/0xProto/releases/download/2.100/$font_zip_name"
sudo unzip "$font_zip_name" -d "$fonts_dir"
rm "$font_zip_name"
fc-cache -fv
