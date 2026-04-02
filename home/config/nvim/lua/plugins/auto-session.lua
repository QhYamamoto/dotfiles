return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require "auto-session"
    local auto_session_lib = require "auto-session.lib"
    local keymap = vim.keymap

    local function current_session_name()
      if vim.v.this_session ~= nil and vim.v.this_session ~= "" then
        return auto_session_lib.current_session_name()
      end

      return vim.fn.getcwd(-1, -1)
    end

    local no_restore_hook = function()
      local home = os.getenv "HOME"
      local cwd = vim.fn.getcwd(-1, -1)
      local exists_session = auto_session.session_exists_for_cwd()

      if not exists_session and cwd == home then
        vim.cmd "Telescope project"
      end
    end

    auto_session.setup {
      auto_restore_enabled = true,
      cwd_change_handling = true,
      auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
      no_restore_cmds = { no_restore_hook },
    }

    keymap.set("n", "<LEADER>wr", function()
      auto_session.restore_session(current_session_name())
    end, { desc = "Restore session for cwd" })
    keymap.set("n", "<LEADER>ws", function()
      auto_session.save_session(current_session_name())
    end, { desc = "Save session for cwd" })
    keymap.set("n", "<LEADER>wd", function()
      auto_session.delete_session(current_session_name())
    end, { desc = "Delete session for cwd" })
  end,
}
