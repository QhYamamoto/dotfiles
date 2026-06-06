# Neovim AI CLI Panel Rules

Use this file when adding or changing a Neovim plugin that opens an interactive
AI CLI tool in a side panel, such as Codex, Claude Code, or similar terminal TUI
tools.

The goal is to make these tools feel like one reusable assistant panel, not like
ordinary file buffers or throwaway terminal splits.

## Core Behavior
- Treat each AI CLI tool as a single reusable side panel.
- Do not create duplicate panes for the same tool.
- Toggle commands must close the panel when it is visible.
- Toggle commands must reopen an existing hidden buffer when possible.
- Create a new terminal only when no reusable buffer exists.
- Keep the panel state independent from unrelated file buffers.

## Command Semantics
Separate normal open commands from resume commands:

- A normal toggle should open the tool's normal command.
- A resume toggle should open the tool's resume command.
- If any panel for that tool is already visible, both normal and resume toggles should close it instead of opening another pane.

For a tool with both "new session" and "resume last session" modes, do not make
the normal toggle implicitly resume unless the user explicitly asks for that.

## Buffer Identification
Do not rely only on plugin-local state. Session restore can recreate terminal
buffers before the plugin knows about them.

Identify AI CLI buffers by a combination of:

- filetype
- terminal buffer name or command
- any tool-specific buffer variables the plugin provides

Restored terminal buffers may have an empty or generic filetype. Normalize them
after restore so later logic can treat them consistently.

## Session Restore
AI CLI panels may be restored by session plugins as raw terminal buffers. The
local configuration should normalize restored buffers by:

- setting a stable filetype
- setting `buflisted=false`
- applying buffer-local panel mappings
- repairing obsolete or invalid saved terminal commands when needed

Do not assume a session restore path calls the plugin's normal `setup`, `open`,
or `toggle` state.

## Bufferline And Buffer Lists
AI CLI panels should not appear as ordinary buffers in bufferline plugins such as
barbar.

Use both:

- the bufferline plugin's filetype exclusion mechanism
- `buflisted=false` on the AI CLI terminal buffer

This avoids stale restored terminal buffers appearing as tabs.

## Width And Layout
Use a predictable side-panel width instead of letting the panel resize
opportunistically.

For this repo, AI CLI side panels should:

- open as a right-side vertical split
- use a fixed ratio of editor width
- be restored to that ratio after window layout changes

Keep width policy centralized. Do not scatter ad hoc `win_set_width` calls across
plugin specs if a shared fixed-width mechanism already exists.

## Toggle Keymaps
Do not map AI panel toggle keys in terminal mode.

Terminal-mode mappings inside the AI app can accidentally trigger Neovim commands
while the user is typing in the tool. Prefer normal-mode mappings for commands
such as "toggle panel" or "resume panel".

## Pane Navigation
AI CLI terminal buffers should preserve the normal pane navigation workflow.

For this repo:

- `C-h` should move to the left pane.
- `C-k` should move to the upper pane.
- `C-l` should move to the right pane.
- `C-j` should remain untouched when the AI tool uses it as newline or accepts it as normal terminal input.

Use buffer-local mappings so this behavior applies only to the AI CLI panel, not
to every terminal buffer.

## Focus Restoration
When moving away from an AI CLI panel and later returning to it, restore the
focus mode the user had when leaving:

- If the user left while the terminal app had focus, return with terminal focus.
- If the user left from normal mode, return in normal mode.

Store this state per buffer. Do not use a global flag that can leak between
multiple tools or restored sessions.

## Implementation Pattern
Prefer a small local wrapper module under `home/config/nvim/lua/core/` when a
plugin's built-in state is not enough.

The wrapper should own:

- finding existing visible panel windows
- finding reusable hidden buffers
- normalizing restored terminal buffers
- closing or reopening the panel
- applying panel-local navigation mappings
- preserving focus mode

Plugin specs under `home/config/nvim/lua/plugins/` should stay thin: configure
the upstream plugin, override user commands if needed, and delegate panel behavior
to the local wrapper.

## Codex Reference
The current Codex implementation follows this pattern in:

- `home/config/nvim/lua/core/codex_panel.lua`
- `home/config/nvim/lua/core/codex_resume.lua`
- `home/config/nvim/lua/plugins/codex.lua`
- `home/config/nvim/lua/plugins/barbar.lua`
- `home/config/nvim/lua/plugins/auto-session.lua`

Use it as an implementation example, but do not copy Codex-specific command names
blindly for other tools.
