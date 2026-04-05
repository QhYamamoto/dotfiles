local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.setup()
  set_maps {
    { mode = { "n", "v" }, lhs = "<S-Up>", rhs = "<CMD>Treewalker Up<CR>", opts = { silent = true } },
    { mode = { "n", "v" }, lhs = "<S-Down>", rhs = "<CMD>Treewalker Down<CR>", opts = { silent = true } },
    { mode = { "n", "v" }, lhs = "<S-Right>", rhs = "<CMD>Treewalker Right<CR>", opts = { silent = true } },
    { mode = { "n", "v" }, lhs = "<S-Left>", rhs = "<CMD>Treewalker Left<CR>", opts = { silent = true } },
    { mode = "n", lhs = "<LEADER>K", rhs = "<CMD>Treewalker SwapUp<CR>", opts = { silent = true } },
    { mode = "n", lhs = "<LEADER>J", rhs = "<CMD>Treewalker SwapDown<CR>", opts = { silent = true } },
    { mode = "n", lhs = "<LEADER>L", rhs = "<CMD>Treewalker SwapRight<CR>", opts = { silent = true } },
    { mode = "n", lhs = "<LEADER>H", rhs = "<CMD>Treewalker SwapLeft<CR>", opts = { silent = true } },
  }
end

return M
