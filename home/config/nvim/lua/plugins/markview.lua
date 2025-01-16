return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local keymap = vim.keymap

    keymap.set("n", "<LEADER>mv", "<CMD>Markview<CR>", { desc = "Toggle markview." })
  end,
}
