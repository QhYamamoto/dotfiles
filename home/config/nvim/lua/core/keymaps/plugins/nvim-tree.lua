local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.setup()
  set_maps {
    { mode = "n", lhs = "<LEADER>ee", rhs = "<CMD>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
    {
      mode = "n",
      lhs = "<LEADER>ef",
      rhs = "<CMD>NvimTreeFindFileToggle<CR>",
      desc = "Toggle file explorer on current file",
    },
  }
end

function M.on_attach(bufnr)
  local api = require "nvim-tree.api"

  local opts = function(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set("n", "l", api.node.open.edit, opts "Open")
  vim.keymap.set("n", "<Right>", api.node.open.edit, opts "Open")
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts "Close Directory")
  vim.keymap.set("n", "<Left>", api.node.navigate.parent_close, opts "Close Directory")
end

return M
