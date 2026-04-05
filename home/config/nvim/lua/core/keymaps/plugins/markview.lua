local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.setup()
  set_maps {
    { mode = "n", lhs = "<LEADER>mv", rhs = "<CMD>Markview<CR>", desc = "Toggle markview." },
  }
end

return M
