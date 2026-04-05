local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.setup(substitute)
  set_maps {
    { mode = "n", lhs = "s", rhs = substitute.operator, desc = "Substitute with motion" },
    { mode = "n", lhs = "ss", rhs = substitute.line, desc = "Substitute line" },
    { mode = "n", lhs = "S", rhs = substitute.eol, desc = "Substitute to end of line" },
    { mode = "x", lhs = "s", rhs = substitute.visual, desc = "Substitute in visual mode" },
  }
end

return M
