local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.setup(treesj)
  set_maps {
    { mode = "n", lhs = "<leader>tt", rhs = treesj.toggle },
  }
end

return M
