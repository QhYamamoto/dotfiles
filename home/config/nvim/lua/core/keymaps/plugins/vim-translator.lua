local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.setup()
  set_maps {
    {
      mode = "n",
      lhs = "<LEADER>tr",
      rhs = ":TranslateW<CR>",
      desc = "Translate from en => ja",
      opts = { silent = true },
    },
    {
      mode = "v",
      lhs = "<LEADER>tr",
      rhs = ":'<,'>TranslateW<CR>",
      desc = "Translate from en => ja",
      opts = { silent = true },
    },
  }
end

return M
