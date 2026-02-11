# Repository Guidelines

## Project Structure & Module Organization
This repository manages cross-platform dotfiles, setup scripts, and a small Rust CLI.

- `home/`: user config files (`zsh`, `nvim`, `wezterm`, tool configs under `home/config/`).
- `sh/`: installation and bootstrap scripts, grouped by package manager in `sh/installers/{apt,brew,others}`.
- `ahk/`: AutoHotkey scripts and MouseGestureL config for Windows.
- `powershell/`: PowerShell helpers for Windows setup.
- `etc/`: static assets and device-specific resources (for example keyboard firmware files).
- `rust/`: `dotfiles` CLI source (`src/`) and Rust tests (`tests/`).
- `init.sh`: entrypoint script that runs initial setup commands.

## Build, Test, and Development Commands
- `bash ./init.sh`: run initial bootstrap on WSL/Linux.
- `dotfiles -h` or `dtf -h`: inspect available CLI commands after initialization.
- `cd rust && cargo build`: build the Rust CLI locally.
- `cd rust && cargo test`: run Rust unit/integration tests in `rust/tests/`.
- `cd rust && cargo run -- -h`: run CLI from source and print help.
- `stylua home/config/nvim`: format Neovim Lua config using repo settings from `.stylua.toml`.

## Coding Style & Naming Conventions
- Lua formatting follows `.stylua.toml`: 2-space indentation, max width 120, Unix line endings.
- Shell scripts should be POSIX/Bash compatible with clear, lowercase filenames (for example `install.sh`).
- Rust follows standard `rustfmt` defaults and idiomatic module layout (`commands`, `modules`, `constants`).
- Prefer descriptive file names by feature/tool (`lsp-config.lua`, `filesystem.rs`, `ssh-add.sh`).

## Testing Guidelines
- Rust tests live in `rust/tests/` and use focused files by behavior (for example `filesystem.rs`, `cil.rs`).
- Add or update tests when changing Rust command behavior or shared modules.
- Run `cd rust && cargo test` before opening a PR.

## Commit & Pull Request Guidelines
- Current history favors short, typed commit subjects: `add: ...`, `modify: ...`, `fix: ...`, `feature: ...`, `chore: ...`.
- Keep commit messages imperative and scoped to one logical change.
- PRs should include:
  - a concise summary of changed areas,
  - any setup/migration impact (WSL, Windows, package installers),
  - screenshots or terminal snippets when UI/UX behavior changes (for example Neovim/Wezterm settings).
