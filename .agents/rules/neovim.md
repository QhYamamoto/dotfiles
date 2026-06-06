# Neovim Rules

## Layout
- Plugin specs live under `home/config/nvim/lua/plugins/`.
- Core settings live under `home/config/nvim/lua/core/`.
- Keymaps live under `home/config/nvim/lua/core/keymaps/`.
- Formatting is handled through `conform.nvim`; Lua formatting should follow `.stylua.toml`.

## Editing Guidance
- Use the existing module layout. Do not fold unrelated behavior into large plugin specs.
- Keep `home/config/nvim/lazy-lock.json` unchanged unless performing intentional plugin management.
- Keymaps are dense and customized. Check for collisions before adding new mappings.
- If changing startup behavior, plugin loading, commands, or autocmds, validate with `nvim --headless "+qa"` when possible.
- Prefer local helper modules under `lua/core/` when behavior needs to coordinate multiple plugins.

## Plugin Management
- Plugin additions/removals should be reflected through `lazy.nvim`, not by hand-editing `lazy-lock.json`.
- Use `:Lazy sync` for reconciliation when adding or removing plugins.
- Use `:Lazy update` only when the user explicitly wants plugin versions advanced.
