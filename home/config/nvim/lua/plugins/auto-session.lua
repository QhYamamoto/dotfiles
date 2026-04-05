return {
  "rmagatti/auto-session",
  config = function()
    local plugin_keymaps = require("core.keymaps.plugins").auto_session
    local auto_session = require "auto-session"

    auto_session.setup {
      auto_restore_enabled = true,
      cwd_change_handling = true,
      auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
      no_restore_cmds = { plugin_keymaps.no_restore_hook },
    }

    plugin_keymaps.setup()
  end,
}
