# Repository Guidelines For AI Agents

This repository manages personal dotfiles for WSL, Windows, Neovim, WezTerm,
shell tooling, and a small Rust CLI named `dotfiles`.

Agents should optimize for safe, incremental edits. Prefer changing one
subsystem at a time, verify the specific area touched, and avoid machine-wide
setup unless the user explicitly asks for it.

## Rule Files
Read the relevant files under `.agents/rules/` before editing:

- `.agents/rules/repository.md`: repository layout, editing rules, high-risk areas
- `.agents/rules/verification.md`: checks to run for each subsystem
- `.agents/rules/neovim.md`: Neovim config conventions
- `.agents/rules/neovim-ai-cli-panel.md`: reusable side-panel rules for AI CLI tools

## Commit Style
Follow the existing short typed subject style:

- `add: ...`
- `modify: ...`
- `fix: ...`
- `feature: ...`
- `chore: ...`

Keep commits focused on one logical change.

## Final Responses
State what changed in plain language, mention the exact verification run, and
call out any checks that could not run.
