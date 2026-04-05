local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

local state = {
  last_args = nil,
}

function M.setup()
  local get_git_rev_from_clipboard = function()
    local rev = vim.fn.getreg "+"
    if rev:match "^[0-9a-fA-F]+$" then
      return rev
    end

    return nil
  end

  set_maps {
    {
      mode = "n",
      lhs = "<LEADER>gdo",
      rhs = function()
        local input = vim.fn.input "DiffviewOpen args: "
        if input == "" then
          input = "HEAD~1..HEAD"
        end

        state.last_args = input
        vim.cmd("DiffviewOpen " .. input)
      end,
      desc = "Open diff view with custom args",
    },
    {
      mode = "n",
      lhs = "<LEADER>gdr",
      rhs = function()
        if not state.last_args then
          print "No previous Diffview state to restore!"
          return
        end

        vim.cmd("DiffviewOpen " .. state.last_args)
      end,
      desc = "Restore last closed diff view",
    },
    {
      mode = "n",
      lhs = "<LEADER>gdc",
      rhs = function()
        local rev = get_git_rev_from_clipboard()
        if rev then
          print(rev)
          vim.cmd(":DiffviewOpen " .. rev .. "~1.." .. rev)
        else
          print "Invalid HashID on clipboard."
        end
      end,
      desc = "Open diff view ({HashId on clipboard}~1..{HashID on clipboard})",
      opts = { noremap = true, silent = true },
    },
  }
end

return M
