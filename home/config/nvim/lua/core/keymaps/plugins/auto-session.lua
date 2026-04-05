local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

local function current_session_name()
  local auto_session_lib = require "auto-session.lib"
  if vim.v.this_session ~= nil and vim.v.this_session ~= "" then
    return auto_session_lib.current_session_name()
  end

  return vim.fn.getcwd(-1, -1)
end

function M.no_restore_hook()
  local auto_session = require "auto-session"
  local home = os.getenv "HOME"
  local cwd = vim.fn.getcwd(-1, -1)
  local exists_session = auto_session.session_exists_for_cwd()

  if not exists_session and cwd == home then
    vim.cmd "Telescope project"
  end
end

function M.setup()
  local auto_session = require "auto-session"

  set_maps {
    {
      mode = "n",
      lhs = "<LEADER>wr",
      rhs = function()
        auto_session.restore_session(current_session_name())
      end,
      desc = "Restore session for cwd",
    },
    {
      mode = "n",
      lhs = "<LEADER>ws",
      rhs = function()
        auto_session.save_session(current_session_name())
      end,
      desc = "Save session for cwd",
    },
    {
      mode = "n",
      lhs = "<LEADER>wd",
      rhs = function()
        auto_session.delete_session(current_session_name())
      end,
      desc = "Delete session for cwd",
    },
  }
end

return M
