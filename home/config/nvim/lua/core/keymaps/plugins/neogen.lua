local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.setup()
  set_maps {
    { mode = "n", lhs = "<LEADER>doc", rhs = ":lua require('neogen').generate()<CR>", desc = "Generate docstring." },
  }
end

return M
