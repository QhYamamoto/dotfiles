return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
  config = function()
    local treesj = require "treesj"
    local keymap = vim.keymap
    keymap.set("n", "<leader>tt", treesj.toggle)
  end,
}
