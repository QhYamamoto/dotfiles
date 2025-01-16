return {
  "stevearc/oil.nvim",
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local oil = require "oil"

    ---@type oil.SetupOpts
    local opts = {
      keymaps = {
        ["q"] = { "actions.close", mode = "n" },
        ["<M-t>"] = { "actions.close", mode = "n" },
        ["h"] = { "actions.parent", mode = "n" },
        ["<C-s>"] = false,
      },
      float = {
        padding = 5,
      },
    }

    oil.setup(opts)

    local keymap = vim.keymap
    keymap.set("n", "<LEADER>ol", "<CMD>Oil --float<CR>", { desc = "Open oil buffer in floating view" })
  end,
}
