# Verification Rules

Run the checks that match the files changed.

## Rust
- `cd rust && cargo test`
- `cd rust && cargo build`

For formatting-only or simple source changes:
- `cd rust && cargo fmt --check`

## Neovim Lua
- `stylua home/config/nvim`
- `nvim --headless "+qa"` when startup validation is needed and the environment supports it

## Shell
- Shell scripts: `bash -n <file>`
- `home/zshrc`: `zsh -n home/zshrc`

## PowerShell
Validate syntax if PowerShell is available. If it is not available, state that
validation was not run.

## AutoHotkey
Static review only unless the user asks for Windows-side runtime validation.

## Commands Agents Should Know
- `bash ./init.sh`
- `dotfiles -h`
- `dotfiles config nvim`
- `cd rust && cargo test`
- `cd rust && cargo build`
- `cd rust && cargo run -- -h`
- `stylua home/config/nvim`

If a check cannot run in the current environment, say so explicitly in the final response.
