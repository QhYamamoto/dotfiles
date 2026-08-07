#!/bin/bash

set -e

BREW_PREFIX=$(brew --prefix)
CLAUDE_SQUAD_BIN="$BREW_PREFIX/bin/claude-squad"
CS_BIN="$BREW_PREFIX/bin/cs"

if [ ! -x "$CLAUDE_SQUAD_BIN" ]; then
  echo "claude-squad is not installed. Run the Homebrew installer first." >&2
  exit 1
fi

if [ ! -e "$CS_BIN" ]; then
  ln -s "$CLAUDE_SQUAD_BIN" "$CS_BIN"
fi
