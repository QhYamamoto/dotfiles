return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require "auto-session"

    local no_restore_hook = function()
      local home = os.getenv "HOME"
      local cwd = vim.fn.getcwd()
      local exists_session = require("auto-session").session_exists_for_cwd()

      if not exists_session and cwd == home then
        vim.cmd "Telescope project"
      end
    end

    auto_session.setup {
      auto_restore_enabled = true,
      auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
      no_restore_cmds = { no_restore_hook },
    }

    local keymap = vim.keymap

    keymap.set("n", "<LEADER>wr", "<CMD>SessionRestore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
    keymap.set("n", "<LEADER>ws", "<CMD>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory
    keymap.set("n", "<LEADER>wd", "<CMD>SessionDelete<CR>", { desc = "Delete session" })
  end,
}
