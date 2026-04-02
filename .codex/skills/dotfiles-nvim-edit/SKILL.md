---
name: dotfiles-nvim-edit
description: Use when auditing or editing this dotfiles repository's Neovim configuration under home/config/nvim, including plugin specs, keymaps, duplicate or conflicting mappings, core settings, formatting behavior, and startup-safe changes. Apply this skill for requests such as adding or changing a plugin, investigating duplicate keymaps, resolving mapping conflicts, adjusting keymaps, changing Neovim options or autocmds, or refactoring config structure in this repo.
---

# Dotfiles Neovim Edit

Use this skill when the task is specifically about the Neovim configuration in this dotfiles repository.

## Scope
- `home/config/nvim/init.lua`
- `home/config/nvim/lua/core/`
- `home/config/nvim/lua/plugins/`
- `home/config/nvim/lazy-lock.json` (generated state from `lazy.nvim`; inspect freely, do not hand-edit)

Do not use this skill for shell, WezTerm, Rust CLI, installers, or Windows automation unless the Neovim task explicitly depends on them.

## Workflow
1. Read the relevant Neovim files before editing. Prefer the smallest local change.
2. Preserve the existing module layout. Plugin specs belong under `lua/plugins/`; core behavior belongs under `lua/core/`.
3. Match the repo's Lua style and conventions. Keep edits consistent with surrounding code.
4. Check for keymap collisions before adding mappings, especially in `lua/core/keymaps.lua`.
5. Treat `lazy-lock.json` as generated state. Do not hand-edit it.
6. For routine config cleanup, plugin removal, or refactors, leave `lazy-lock.json` unchanged unless the task includes a plugin management step.
7. When the user wants plugin install/update/removal reflected in `lazy-lock.json`, perform that through `lazy.nvim` in Neovim, not by editing the file directly. Use a headless/plugin-management command when practical in the current environment, and report if that environment support is missing.
8. After editing Lua files, run `stylua home/config/nvim`.
9. If a plugin update introduced breakage, check the local plugin source under `~/.local/share/nvim/lazy/` plus upstream changelog/readme snippets available there before changing repo config. Prefer adapting repo config to the current plugin API over patching plugin code directly.
10. If the task changes startup behavior, plugin loading, command definitions, or plugin management state, also validate with `nvim --headless "+qa"` when the environment supports it.
11. After `Lazy sync`/`Lazy clean`/`Lazy update`, verify both the resulting `lazy-lock.json` diff and remaining config references. Do not assume plugin removal succeeded just because the command reported a clean step.
12. In the final response, state what changed and which checks ran.

## Plugin Management State
- `lazy-lock.json` is the generated lock state used by `lazy.nvim`; it should change as a side effect of plugin management commands.
- Prefer `:Lazy sync` after adding or removing plugins. It is the default reconciliation step because it installs missing plugins, cleans removed ones, and refreshes lock state in one pass.
- Use `:Lazy clean` when the task is specifically about removing plugins that are no longer declared.
- Use `:Lazy update` only when the user explicitly wants plugin versions advanced.
- Use `:Lazy restore` to apply the current lockfile state back onto installed plugins; it does not refresh the lockfile itself.
- For plugin removal tasks, the expected order is: remove plugin specs and direct references, run `:Lazy sync`, then verify that `lazy-lock.json` no longer contains the removed plugin.
- Prefer a headless Neovim invocation for `lazy.nvim` management when it works reliably in the current environment. If headless execution is flaky or unsupported, use an interactive Neovim run and report that choice.
- If `Lazy sync` is blocked by unrelated plugin config errors, filesystem permissions, or read-only cache paths, report that explicitly and verify what did or did not change before deciding whether another sync pass is needed.
- If a plugin under `~/.local/share/nvim/lazy/` fails to update because of a corrupted git worktree, broken submodules, or ownership/permission problems, prefer removing that plugin clone and reinstalling it through `lazy.nvim` instead of trying to manually repair the clone in place.

## Repo-Specific Notes
- Plugin configuration is split into many small files under `home/config/nvim/lua/plugins/`.
- Formatting is managed by `conform.nvim` in `home/config/nvim/lua/plugins/formatting.lua`.
- `home/config/nvim/lua/core/keymaps.lua` is large and heavily customized; additions should be narrow and deliberate.
- `home/config/nvim/init.lua` is only an entrypoint that loads `core` and `lazy-settings`.
- `lazy-lock.json` should normally change only as a side effect of `lazy.nvim` operations such as install, sync, clean, or update.

## Guardrails
- Do not reorganize the whole Neovim config unless the user asks for a refactor.
- Do not add a new plugin when a built-in capability or existing plugin already covers the request, unless the user explicitly wants a new dependency.
- Do not mix unrelated Neovim cleanup into a focused change.
- When removing an unused plugin, prefer deleting its spec and any direct references first. If the user also wants the installed plugin set and lockfile reconciled, run the appropriate `lazy.nvim` management step afterward instead of editing `lazy-lock.json` by hand.
- When Neovim 0.11+ deprecation warnings come from plugin wrappers around LSP actions, prefer switching repo keymaps or call sites to native `vim.lsp.buf.*` / `vim.lsp.*` APIs if that removes the warning without losing essential behavior.
