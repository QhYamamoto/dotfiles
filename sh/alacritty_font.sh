#!/usr/bin/env bash

set -euo pipefail

work_dir="${TMPDIR:-/tmp}/dotfiles-alacritty-font"
venv_dir="${work_dir}/venv"
font_zip="${work_dir}/0xProtoNerdFont.zip"
source_font="${work_dir}/0xProtoNerdFontMono-Italic.ttf"
output_font="${work_dir}/0xProtoFreezeSlant-Regular.ttf"
wsl_font_dir="${HOME}/.local/share/fonts"
wsl_font="${wsl_font_dir}/0xProtoFreezeSlant-Regular.ttf"

mkdir -p "$work_dir"

if [[ ! -x "${venv_dir}/bin/python" ]]; then
  python3 -m venv "$venv_dir"
fi
"${venv_dir}/bin/python" -m pip install --upgrade pip fonttools opentype-feature-freezer

curl -fL -o "$font_zip" \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/0xProto.zip
unzip -o "$font_zip" 0xProtoNerdFontMono-Italic.ttf -d "$work_dir"

"${venv_dir}/bin/pyftfeatfreeze" \
  -f ss02,ss03,ss04,ss05,ss06,zero,onum \
  "$source_font" \
  "$output_font"

"${venv_dir}/bin/python" - "$output_font" <<'PY'
from pathlib import Path
import sys

from fontTools.ttLib import TTFont

path = Path(sys.argv[1])
font = TTFont(path)
family = "0xProto Freeze Slant"
style = "Regular"
full = f"{family} {style}"
ps = "0xProtoFreezeSlant-Regular"
version = "Version 1.000; generated from 0xProto Nerd Font Mono Italic"

name_values = {
    1: family,
    2: style,
    3: f"{version};{ps}",
    4: full,
    6: ps,
    16: family,
    17: style,
}

for record in font["name"].names:
    if record.nameID in name_values:
        record.string = name_values[record.nameID].encode(record.getEncoding(), errors="replace")

for name_id, value in name_values.items():
    existing = [n for n in font["name"].names if n.nameID == name_id]
    platforms = {(n.platformID, n.platEncID, n.langID) for n in existing}
    for platform_id, enc_id, lang_id in [(3, 1, 0x409), (1, 0, 0)]:
        if (platform_id, enc_id, lang_id) not in platforms:
            font["name"].setName(value, name_id, platform_id, enc_id, lang_id)

if "head" in font:
    font["head"].macStyle &= ~0b10
if "OS/2" in font:
    font["OS/2"].fsSelection &= ~0b1
    font["OS/2"].fsSelection |= 0b1000000
if "post" in font:
    font["post"].italicAngle = 0

font.save(path)
PY

mkdir -p "$wsl_font_dir"
cp "$output_font" "$wsl_font"
fc-cache -fv "$wsl_font_dir"

if command -v powershell.exe >/dev/null 2>&1; then
  distro_name="${WSL_DISTRO_NAME:-Ubuntu-22.04}"
  windows_source="\\\\wsl\$\\${distro_name}$(printf '%s' "$output_font" | sed 's#/#\\#g')"
  powershell.exe -NoProfile -Command \
    "\$ErrorActionPreference = 'Stop'; \
     \$src = '${windows_source}'; \
     \$fontDir = \"\$env:LOCALAPPDATA\\Microsoft\\Windows\\Fonts\"; \
     \$dest = Join-Path \$fontDir '0xProtoFreezeSlant-Regular.ttf'; \
     New-Item -ItemType Directory -Force -Path \$fontDir | Out-Null; \
     if (-not (Test-Path -LiteralPath \$dest)) { \
       Copy-Item -LiteralPath \$src -Destination \$dest; \
     } \
     New-ItemProperty -Path 'HKCU:\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Fonts' \
       -Name '0xProto Freeze Slant Regular (TrueType)' \
       -Value \$dest \
       -PropertyType String \
       -Force | Out-Null"
fi

echo "Installed 0xProto Freeze Slant Regular."
