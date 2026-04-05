local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.setup()
  set_maps {
    { mode = "n", lhs = "<LEADER>mt", rhs = ":MakeTable!<CR>", opts = { noremap = true, silent = true } },
    { mode = "v", lhs = "<LEADER>mt", rhs = ":'<,'>MakeTable!<CR>", opts = { noremap = true, silent = true } },
    { mode = "n", lhs = "<LEADER>umt", rhs = ":'<CMD>UnmakeTable<CR>", opts = { noremap = true, silent = true } },
  }
end

return M
