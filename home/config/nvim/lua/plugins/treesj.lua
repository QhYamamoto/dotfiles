return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
  config = function()
    local treesj = require "treesj"
    require("core.keymaps.plugins").treesj.setup(treesj)
  end,
}
