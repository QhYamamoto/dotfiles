local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.setup()
  set_maps {
    { mode = "n", lhs = "<LEADER>csv", rhs = "<CMD>CsvViewToggle<CR>", desc = "Toggle csv view" },
  }
end

return M
