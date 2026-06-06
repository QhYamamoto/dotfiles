return {
  "rmagatti/auto-session",
  config = function()
    local plugin_keymaps = require("core.keymaps.plugins").auto_session
    local auto_session = require "auto-session"

    auto_session.setup {
      auto_restore_enabled = true,
      cwd_change_handling = true,
      auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
      pre_restore_cmds = {
        function(session_name)
          require("core.codex_panel").migrate_session_file(session_name)
        end,
      },
      no_restore_cmds = { plugin_keymaps.no_restore_hook },
    }

    plugin_keymaps.setup()
  end,
}
