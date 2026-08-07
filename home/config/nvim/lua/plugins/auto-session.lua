return {
  "rmagatti/auto-session",
  config = function()
    local plugin_keymaps = require("core.keymaps.plugins").auto_session
    local auto_session = require "auto-session"

    auto_session.setup {
      auto_restore = true,
      cwd_change_handling = true,
      suppressed_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
      pre_restore_cmds = {
        function(session_name)
          require("core.codex_panel").migrate_session_file(session_name)
        end,
      },
      post_restore_cmds = {
        function()
          vim.schedule(function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if
                vim.api.nvim_buf_is_loaded(buf)
                and vim.bo[buf].buftype == ""
                and vim.bo[buf].filetype == ""
                and vim.api.nvim_buf_get_name(buf) ~= ""
              then
                vim.api.nvim_buf_call(buf, function()
                  vim.cmd "filetype detect"
                end)
              end
            end
          end)
        end,
      },
      no_restore_cmds = { plugin_keymaps.no_restore_hook },
    }

    plugin_keymaps.setup()
  end,
}
