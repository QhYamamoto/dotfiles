return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  keys = require("core.keymaps.plugins").markview.keys,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}
